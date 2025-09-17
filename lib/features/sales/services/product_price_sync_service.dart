import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';

/// Service to handle syncing of product variation prices and table price overrides
class ProductPriceSyncService {
  static final _logger = Logger('ProductPriceSyncService');
  
  final LocalDatabaseService _localDb = LocalDatabaseService();
  final SyncQueueService _syncQueueService = SyncQueueService();
  final SupabaseClient _supabase = Supabase.instance.client;
  final _connectivity = Connectivity();
  
  Timer? _syncTimer;
  bool _isSyncing = false;

  // Singleton pattern
  static final ProductPriceSyncService _instance = ProductPriceSyncService._internal();
  factory ProductPriceSyncService() => _instance;
  ProductPriceSyncService._internal();

  DateTime? _parseDateTime(dynamic value) {
    try {
      if (value == null) return null;
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String && value.isNotEmpty) return DateTime.parse(value);
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> _getWatermarkFor(String table) async {
    try {
      final db = await _localDb.database;
      final rows = await db.query(
        'sync_state',
        columns: ['last_synced_at'],
        where: 'table_name = ?',
        whereArgs: [table],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      final v = rows.first['last_synced_at'];
      return _parseDateTime(v);
    } catch (_) {
      return null;
    }
  }

  Future<void> _setWatermarkFor(String table, DateTime ts) async {
    try {
      final db = await _localDb.database;
      await db.insert(
        'sync_state',
        {
          'table_name': table,
          'last_synced_at': ts.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {}
  }

  Future<DateTime?> _getTablePricesWatermark() => _getWatermarkFor('table_price_overrides');

  /// Initialize background sync
  void initialize() {
    _logger.info('Initializing product price sync service');
    
    // Start periodic sync timer (every 30 seconds)
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!_isSyncing) {
        processSyncQueue();
      }
    });
  }

  /// Process sync queue for product prices
  Future<void> processSyncQueue() async {
    if (_isSyncing) {
      _logger.debug('Sync already in progress, skipping');
      return;
    }
    
    _isSyncing = true;
    
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _logger.info('No internet connection, skipping sync');
        return;
      }

      // Removed: product_variation_prices sync; only table overrides are synced
      // Also process table price overrides (ready items)
      final pendingTablePrices = await _syncQueueService.getReadyItemsForTable('table_price_overrides');
      
      if (pendingTablePrices.isNotEmpty) {
        _logger.info('Processing ${pendingTablePrices.length} pending table price sync items');
        
        for (final item in pendingTablePrices) {
          await _processTablePriceSyncItem(item);
        }
      } else {
        _logger.debug('No pending table price overrides to sync');
      }
    } catch (e, stackTrace) {
      _logger.error('Error processing product price sync queue', e, stackTrace);
    } finally {
      _isSyncing = false;
    }
  }

  // Removed: product_variation_prices sync handler

  /// Process a single table price override sync item
  Future<void> _processTablePriceSyncItem(Map<String, dynamic> item) async {
    try {
      final data = jsonDecode(item['data'] as String) as Map<String, dynamic>;
      final operation = item['operation'] as String;
      final recordId = item['record_id'] as String;
      
      // For INSERT operations, check if the variation exists in Supabase first
      if (operation == 'INSERT' || operation == 'CREATE') {
        final variationId = data['variationId'] ?? data['variation_id'];
        if (variationId != null) {
          final variationExists = await _checkVariationExistsInSupabase(variationId);
          if (!variationExists) {
            _logger.info('Variation $variationId not yet available in Supabase, will retry later');
            // Don't increment retry count for timing issues - just skip this iteration
            return;
          }
        }
      }
      
      // Convert data to Supabase format
      final supabaseData = _convertTablePriceToSupabaseFormat(data);

      // Perform the sync operation
      switch (operation) {
        case 'INSERT':
        case 'CREATE':
          await _syncInsert('table_price_overrides', recordId, supabaseData);
          break;
        case 'UPDATE':
          await _syncUpdate('table_price_overrides', recordId, supabaseData);
          break;
        case 'DELETE':
          await _syncDelete('table_price_overrides', recordId);
          break;
        default:
          _logger.warning('Unknown sync operation: $operation');
      }

      // Remove from sync queue on success
      await _syncQueueService.removeItem(item['id'] as String);
      
      // Mark as synced in local database
      await _markAsSynced('table_price_overrides', recordId);
      
      _logger.info('Successfully synced table price override: $recordId');
    } catch (e) {
      final errorMessage = e.toString();
      _logger.error('Error processing sync item ${item['id']}', e);
      
      // Update retry count with error message
      await _syncQueueService.updateRetryCount(
        item['id'] as String,
        errorMessage,
      );
    }
  }

  /// Sync INSERT operation
  Future<void> _syncInsert(String table, String recordId, Map<String, dynamic> data) async {
    try {
      await _supabase.from(table).insert(data);
      _logger.info('Inserted $table to cloud: $recordId');
    } catch (e) {
      if (e.toString().contains('duplicate key')) {
        // Record already exists, try update instead
        _logger.info('$table already exists in cloud, updating instead');
        await _syncUpdate(table, recordId, data);
      } else {
        rethrow;
      }
    }
  }

  /// Sync UPDATE operation
  Future<void> _syncUpdate(String table, String recordId, Map<String, dynamic> data) async {
    await _supabase
        .from(table)
        .upsert(data)
        .eq('id', recordId);
    
    _logger.info('Updated $table in cloud: $recordId');
  }

  /// Sync DELETE operation
  Future<void> _syncDelete(String table, String recordId) async {
    await _supabase
        .from(table)
        .delete()
        .eq('id', recordId);
    
    _logger.info('Deleted $table in cloud: $recordId');
  }

  /// Mark a record as synced in local database
  Future<void> _markAsSynced(String table, String recordId) async {
    try {
      final db = await _localDb.database;
      await db.update(
        table,
        {
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [recordId],
      );
    } catch (e) {
      _logger.error('Error marking $table as synced', e);
    }
  }

  /// Convert product variation price to Supabase format (snake_case)
  Map<String, dynamic> _convertToSupabaseFormat(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // Convert to snake_case field names
    converted['variation_id'] = converted.remove('variationId') ?? converted['variation_id'];
    converted['price_category_id'] = converted.remove('priceCategoryId') ?? converted['price_category_id'];
    converted['is_active'] = converted.remove('isActive') ?? converted['is_active'];
    converted['created_at'] = (converted.remove('createdAt') ?? converted['created_at'])?.toString();
    converted['updated_at'] = (converted.remove('updatedAt') ?? converted['updated_at'])?.toString();
    
    // Handle created_by - remove if not present or if it's 'system'
    final createdBy = converted.remove('createdBy') ?? converted.remove('created_by');
    if (createdBy != null && createdBy != 'system') {
      converted['created_by'] = createdBy;
    }

    // Remove local-only fields that don't exist in Supabase
    converted.remove('hasUnsyncedChanges');
    converted.remove('has_unsynced_changes');
    converted.remove('lastSyncedAt');
    converted.remove('last_synced_at');

    return converted;
  }

  /// Convert table price override to Supabase format (snake_case)
  Map<String, dynamic> _convertTablePriceToSupabaseFormat(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // Convert to snake_case field names
    converted['table_id'] = converted.remove('tableId') ?? converted['table_id'];
    converted['variation_id'] = converted.remove('variationId') ?? converted['variation_id'];
    converted['is_active'] = converted.remove('isActive') ?? converted['is_active'];
    converted['created_at'] = (converted.remove('createdAt') ?? converted['created_at'])?.toString();
    converted['updated_at'] = (converted.remove('updatedAt') ?? converted['updated_at'])?.toString();
    
    // Handle created_by - remove if not present or if it's 'system'
    final createdBy = converted.remove('createdBy') ?? converted.remove('created_by');
    if (createdBy != null && createdBy != 'system') {
      converted['created_by'] = createdBy;
    }

    // Remove local-only fields that don't exist in Supabase
    converted.remove('hasUnsyncedChanges');
    converted.remove('has_unsynced_changes');
    converted.remove('lastSyncedAt');
    converted.remove('last_synced_at');

    return converted;
  }

  /// Check if a product variation exists in Supabase
  Future<bool> _checkVariationExistsInSupabase(String variationId) async {
    try {
      final response = await _supabase
          .from('product_variations')
          .select('id')
          .eq('id', variationId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      _logger.debug('Error checking variation existence: $e');
      // If we can't check, assume it doesn't exist yet
      return false;
    }
  }

  /// Download product prices from cloud for a business
  Future<void> downloadPricesForBusiness(String businessId) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _logger.info('No internet connection, skipping download');
        return;
      }

      // Get all variations for this business
      final db = await _localDb.database;
      final products = await db.query(
        'products',
        where: 'business_id = ?',
        whereArgs: [businessId],
      );
      
      final variationIds = <String>[];
      for (final product in products) {
        final variations = await db.query(
          'product_variations',
          where: 'product_id = ?',
          whereArgs: [product['id']],
        );
        variationIds.addAll(variations.map((v) => v['id'] as String));
      }
      
      if (variationIds.isEmpty) {
        _logger.info('No variations found for business');
        return;
      }

      // Removed: product variation prices download; using selling_price from product_variations
      
      // Download table price overrides
      final lastTable = await _getTablePricesWatermark();
      var tablePriceQuery = _supabase
          .from('table_price_overrides')
          .select()
          .inFilter('variation_id', variationIds);
      if (lastTable != null) {
        tablePriceQuery = tablePriceQuery.gte('updated_at', lastTable.toIso8601String());
      }
      final tablePricesResponse = await tablePriceQuery;
          
      _logger.info('Downloaded ${tablePricesResponse.length} table price overrides');
      DateTime? maxTableTs;
      
      // Save to local database
      for (final priceData in tablePricesResponse) {
        await db.insert(
          'table_price_overrides',
          {
            'id': priceData['id'],
            'table_id': priceData['table_id'],
            'variation_id': priceData['variation_id'],
            'price': priceData['price'],
            'is_active': priceData['is_active'] ? 1 : 0,
            'created_at': priceData['created_at'],
            'updated_at': priceData['updated_at'],
            'created_by': priceData['created_by'],
            'has_unsynced_changes': 0,
            'last_synced_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        final ts2 = _parseDateTime(priceData['updated_at']);
        if (ts2 != null && (maxTableTs == null || ts2.isAfter(maxTableTs))) {
          maxTableTs = ts2;
        }
      }
      if (maxTableTs != null) {
        await _setWatermarkFor('table_price_overrides', maxTableTs!);
      }
    } catch (e, stackTrace) {
      _logger.error('Error downloading prices for business', e, stackTrace);
    }
  }

  /// Dispose of resources
  void dispose() {
    _syncTimer?.cancel();
  }
}
