import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/logger.dart';
import '../features/business/models/business_model.dart';
import 'local_database_service.dart';

/// Progress tracking for data download
class DataSeedingProgress {
  final String currentTask;
  final int totalSteps;
  final int completedSteps;
  final double percentage;
  final bool isComplete;
  final String? error;

  DataSeedingProgress({
    required this.currentTask,
    required this.totalSteps,
    required this.completedSteps,
    this.error,
  })  : percentage = totalSteps > 0 ? (completedSteps / totalSteps) * 100 : 0,
        isComplete = completedSteps >= totalSteps && totalSteps > 0;

  DataSeedingProgress copyWith({
    String? currentTask,
    int? totalSteps,
    int? completedSteps,
    String? error,
  }) {
    return DataSeedingProgress(
      currentTask: currentTask ?? this.currentTask,
      totalSteps: totalSteps ?? this.totalSteps,
      completedSteps: completedSteps ?? this.completedSteps,
      error: error ?? this.error,
    );
  }
}

/// Comprehensive data seeding service for initial data download
class DataSeedingService {
  static final _logger = Logger('DataSeedingService');

  final SupabaseClient _supabase;
  final LocalDatabaseService _localDb;
  
  // Cache for table columns
  final Map<String, Set<String>> _tableColumns = {};

  // Progress tracking
  final _progressController = StreamController<DataSeedingProgress>.broadcast();
  Stream<DataSeedingProgress> get progressStream => _progressController.stream;

  DataSeedingService({
    required SupabaseClient supabase,
    required LocalDatabaseService localDb,
  })  : _supabase = supabase,
        _localDb = localDb;

  /// Download all data for a business when user logs in or switches business
  Future<void> seedBusinessData(BusinessModel business) async {
    _logger.info('Starting comprehensive data seeding for business: ${business.id}');

    // Removed product_variation_prices step; total steps reduced by 1
    const totalSteps = 14;
    int currentStep = 0;

    try {
      final db = await _localDb.database;
      
      // Pre-cache table columns
      await _cacheTableColumns(db);

      // Step 1: Download business locations
      _updateProgress('Downloading locations...', totalSteps, ++currentStep);
      await _downloadLocations(business.id, db);

      // Step 2: Download POS devices
      _updateProgress('Downloading POS devices...', totalSteps, ++currentStep);
      await _downloadPOSDevices(business.id, db);

      // Step 3: Download product categories
      _updateProgress('Downloading product categories...', totalSteps, ++currentStep);
      await _downloadProductCategories(business.id, db);

      // Step 4: Download product brands
      _updateProgress('Downloading product brands...', totalSteps, ++currentStep);
      await _downloadProductBrands(business.id, db);

      // Step 5: Download products and variations
      _updateProgress('Downloading products...', totalSteps, ++currentStep);
      await _downloadProducts(business.id, db);

      // Step 6: Download price categories
      _updateProgress('Downloading price categories...', totalSteps, ++currentStep);
      await _downloadPriceCategories(business.id, db);

      // Step 7: (removed) Product variation prices are not used anymore

      // Step 8: Download table areas and tables
      _updateProgress('Downloading table configuration...', totalSteps, ++currentStep);
      await _downloadTableConfiguration(business.id, db);

      // Step 9: Download charges configuration
      _updateProgress('Downloading charges...', totalSteps, ++currentStep);
      await _downloadCharges(business.id, db);

      // Step 10: Download discounts configuration
      _updateProgress('Downloading discounts...', totalSteps, ++currentStep);
      await _downloadDiscounts(business.id, db);

      // Step 11: Download payment methods
      _updateProgress('Downloading payment methods...', totalSteps, ++currentStep);
      await _downloadPaymentMethods(business.id, db);

      // Step 12: Download customers
      _updateProgress('Downloading customers...', totalSteps, ++currentStep);
      await _downloadCustomers(business.id, db);

      // Step 13: Download employees
      _updateProgress('Downloading employees...', totalSteps, ++currentStep);
      await _downloadEmployees(business.id, db);

      // Step 14: Download active orders
      _updateProgress('Downloading active orders...', totalSteps, ++currentStep);
      await _downloadActiveOrders(business.id, db);

      // Step 15 (renumbered due to removal): Download recent order history (last 7 days)
      _updateProgress('Downloading recent orders...', totalSteps, ++currentStep);
      await _downloadRecentOrders(business.id, db);

      _updateProgress('Data seeding complete!', totalSteps, totalSteps);
      _logger.info('Data seeding completed successfully for business: ${business.id}');
    } catch (e, stackTrace) {
      _logger.error('Data seeding failed', e, stackTrace);
      _updateProgress('Data seeding failed', totalSteps, currentStep, error: e.toString());
      rethrow;
    }
  }

  // Progress update helper
  void _updateProgress(String task, int total, int completed, {String? error}) {
    _progressController.add(DataSeedingProgress(
      currentTask: task,
      totalSteps: total,
      completedSteps: completed,
      error: error,
    ));
  }
  
  /// Cache table columns for all tables we'll be using
  Future<void> _cacheTableColumns(Database db) async {
    final tables = [
      'business_locations', 'pos_devices', 'product_categories', 'product_brands',
      'products', 'product_variations', 'price_categories',
      'table_areas', 'tables', 'charges', 'discounts', 'payment_methods',
      'customers', 'employees', 'orders', 'order_items', 'order_payments'
    ];
    
    for (final table in tables) {
      _tableColumns[table] = await _getTableColumns(db, table);
    }
  }
  
  /// Get columns for a table
  Future<Set<String>> _getTableColumns(Database db, String tableName) async {
    try {
      final result = await db.rawQuery('PRAGMA table_info($tableName)');
      return result.map((row) => row['name'] as String).toSet();
    } catch (e) {
      _logger.warning('Could not get columns for table $tableName: $e');
      return {};
    }
  }

  /// Check if a cached table has a specific column
  bool _hasColumn(String tableName, String columnName) {
    final cols = _tableColumns[tableName];
    return cols != null && cols.contains(columnName);
  }

  /// Insert or replace a row while preserving local unsynced changes.
  /// If the target table has `has_unsynced_changes` and the existing row has it set to 1,
  /// we compare timestamps when possible:
  /// - If local.updated_at >= remote.updated_at => skip (preserve local unsynced edit)
  /// - If remote.updated_at > local.updated_at => allow overwrite (remote is newer)
  Future<void> _safeInsert(
    Database db,
    String tableName,
    Map<String, dynamic> data, {
    String idColumn = 'id',
  }) async {
    try {
      final id = data[idColumn];
      if (id != null && _hasColumn(tableName, 'has_unsynced_changes')) {
        final existing = await db.query(
          tableName,
          columns: [idColumn, 'has_unsynced_changes'] + (_hasColumn(tableName, 'updated_at') ? ['updated_at'] : []),
          where: '$idColumn = ?',
          whereArgs: [id],
        );
        if (existing.isNotEmpty) {
          final hasUnsynced = existing.first['has_unsynced_changes'];
          final isUnsynced = hasUnsynced is int ? hasUnsynced == 1 : hasUnsynced == true;
          if (isUnsynced) {
            // If we can compare updated_at, only skip when local is newer or same
            if (_hasColumn(tableName, 'updated_at')) {
              final localUpdatedRaw = existing.first['updated_at'];
              final remoteUpdatedRaw = data['updated_at'];
              final localUpdated = _parseDateTime(localUpdatedRaw);
              final remoteUpdated = _parseDateTime(remoteUpdatedRaw);
              if (localUpdated != null && remoteUpdated != null) {
                if (!remoteUpdated.isAfter(localUpdated)) {
                  _logger.info('Skipping overwrite (local newer or equal) for $tableName: $id');
                  return;
                }
              } else {
                _logger.info('Skipping overwrite of unsynced local $tableName: $id');
                return;
              }
            } else {
              _logger.info('Skipping overwrite of unsynced local $tableName: $id');
              return;
            }
          }
        }
      }

      await db.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.error('Safe insert failed for $tableName', e);
      // Do not force-replace here to preserve local safety; allow caller flow to continue
    }
  }

  /// Parse a dynamic value into DateTime if possible
  DateTime? _parseDateTime(dynamic value) {
    try {
      if (value == null) return null;
      if (value is int) {
        // assume milliseconds since epoch
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      if (value is String && value.isNotEmpty) {
        return DateTime.parse(value);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get last synced watermark for a table
  Future<DateTime?> _getWatermark(Database db, String tableName) async {
    try {
      final rows = await db.query(
        'sync_state',
        columns: ['last_synced_at'],
        where: 'table_name = ?',
        whereArgs: [tableName],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      final v = rows.first['last_synced_at'];
      return _parseDateTime(v);
    } catch (_) {
      return null;
    }
  }

  /// Set last synced watermark for a table
  Future<void> _setWatermark(Database db, String tableName, DateTime ts) async {
    try {
      await db.insert(
        'sync_state',
        {
          'table_name': tableName,
          'last_synced_at': ts.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.warning('Failed to update sync watermark for $tableName: $e');
    }
  }

  /// Convert Supabase data types to SQLite-compatible types and filter columns
  Map<String, dynamic> _convertToSQLiteFormat(Map<String, dynamic> data, String tableName) {
    final converted = Map<String, dynamic>.from(data);
    final tableColumns = _tableColumns[tableName] ?? {};
    
    // If we don't have column info, just convert types
    if (tableColumns.isEmpty) {
      converted.forEach((key, value) {
        // Convert booleans to integers (0/1)
        if (value is bool) {
          converted[key] = value ? 1 : 0;
        }
        // Convert lists to JSON strings
        else if (value is List) {
          converted[key] = jsonEncode(value);
        }
        // Convert maps/objects to JSON strings
        else if (value is Map) {
          converted[key] = jsonEncode(value);
        }
        // Keep nulls, numbers, and strings as-is
      });
      return converted;
    }
    
    // Filter to only include columns that exist in the local table
    final filtered = <String, dynamic>{};
    converted.forEach((key, value) {
      // Convert snake_case to check if column exists
      if (tableColumns.contains(key)) {
        // Convert booleans to integers (0/1)
        if (value is bool) {
          filtered[key] = value ? 1 : 0;
        }
        // Convert lists to JSON strings
        else if (value is List) {
          filtered[key] = jsonEncode(value);
        }
        // Convert maps/objects to JSON strings
        else if (value is Map) {
          filtered[key] = jsonEncode(value);
        }
        // Keep nulls, numbers, and strings as-is
        else {
          filtered[key] = value;
        }
      }
    });
    
    return filtered;
  }

  // 1. Download business locations
  Future<void> _downloadLocations(String businessId, Database db) async {
    try {
      final last = await _getWatermark(db, 'business_locations');
      var query = _supabase
          .from('business_locations')
          .select()
          .eq('business_id', businessId);
      if (last != null) {
        query = query.gte('updated_at', last.toIso8601String());
      }
      final locations = await query.order('updated_at');

      DateTime? maxTs;

      for (final location in locations) {
        final data = _convertToSQLiteFormat({
          ...location,
          'sync_status': 'synced',
          'created_at': DateTime.parse(location['created_at']).millisecondsSinceEpoch,
          'updated_at': DateTime.parse(location['updated_at']).millisecondsSinceEpoch,
        }, 'business_locations');
        
        await _safeInsert(db, 'business_locations', data);
        final ts = _parseDateTime(location['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${locations.length} locations');
      if (maxTs != null) {
        await _setWatermark(db, 'business_locations', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download locations', e);
      // Continue with other downloads even if this fails
    }
  }

  // 2. Download POS devices
  Future<void> _downloadPOSDevices(String businessId, Database db) async {
    try {
      // Get all locations for this business first
      final locations = await db.query(
        'business_locations',
        where: 'business_id = ?',
        whereArgs: [businessId],
      );

      final last = await _getWatermark(db, 'pos_devices');
      DateTime? maxTs;
      for (final location in locations) {
        // Build filtered query per location using watermark
        var devQuery = _supabase
            .from('pos_devices')
            .select()
            .eq('location_id', location['id'] as Object);
        if (last != null) {
          devQuery = devQuery.gte('updated_at', last.toIso8601String());
        }
        final devicesFiltered = await devQuery.order('updated_at');

        for (final device in devicesFiltered) {
          final data = _convertToSQLiteFormat({
            ...device,
            'sync_status': 'synced',
            'created_at': DateTime.parse(device['created_at']).millisecondsSinceEpoch,
            'updated_at': DateTime.parse(device['updated_at']).millisecondsSinceEpoch,
            'last_sync_at': DateTime.now().millisecondsSinceEpoch,
          }, 'pos_devices');
          
          await _safeInsert(db, 'pos_devices', data);
          final ts = _parseDateTime(device['updated_at']);
          if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
            maxTs = ts;
          }
        }
      }

      _logger.info('Downloaded POS devices for all locations');
      if (maxTs != null) {
        await _setWatermark(db, 'pos_devices', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download POS devices', e);
    }
  }

  // 3. Download product categories
  Future<void> _downloadProductCategories(String businessId, Database db) async {
    try {
      final last = await _getWatermark(db, 'product_categories');
      var catQuery = _supabase
          .from('product_categories')
          .select()
          .eq('business_id', businessId);
      if (last != null) {
        catQuery = catQuery.gte('updated_at', last.toIso8601String());
      }
      final categories = await catQuery.order('updated_at');

      DateTime? maxTs;

      for (final category in categories) {
        final data = _convertToSQLiteFormat({
          ...category,
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        }, 'product_categories');
        
        await _safeInsert(db, 'product_categories', data);
        final ts = _parseDateTime(category['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${categories.length} product categories');
      if (maxTs != null) {
        await _setWatermark(db, 'product_categories', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download product categories', e);
    }
  }

  // 4. Download product brands
  Future<void> _downloadProductBrands(String businessId, Database db) async {
    try {
      final last = await _getWatermark(db, 'product_brands');
      var brandQuery = _supabase
          .from('product_brands')
          .select()
          .eq('business_id', businessId);
      if (last != null) {
        brandQuery = brandQuery.gte('updated_at', last.toIso8601String());
      }
      final brands = await brandQuery.order('updated_at');

      DateTime? maxTs;

      for (final brand in brands) {
        final data = _convertToSQLiteFormat({
          ...brand,
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        }, 'product_brands');

        await _safeInsert(db, 'product_brands', data);
        final ts = _parseDateTime(brand['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${brands.length} product brands');
      if (maxTs != null) {
        await _setWatermark(db, 'product_brands', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download product brands', e);
    }
  }

  // 5. Download products and variations
  Future<void> _downloadProducts(String businessId, Database db) async {
    try {
      final productLast = await _getWatermark(db, 'products');
      var productQuery = _supabase
          .from('products')
          .select()
          .eq('business_id', businessId);
      if (productLast != null) {
        productQuery = productQuery.gte('updated_at', productLast.toIso8601String());
      }
      final products = await productQuery.order('updated_at');

      DateTime? maxProductTs;

      for (final product in products) {
        // Save product
        final productData = _convertToSQLiteFormat({
          ...product,
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        }, 'products');
        
        await _safeInsert(db, 'products', productData);
        final pTs = _parseDateTime(product['updated_at']);
        if (pTs != null && (maxProductTs == null || pTs.isAfter(maxProductTs))) {
          maxProductTs = pTs;
        }

        // Download all variations for this product (product_variations has no updated_at column)
        final variations = await _supabase
            .from('product_variations')
            .select()
            .eq('product_id', product['id'])
            .order('display_order');

        for (final variation in variations) {
          // Normalize required numeric fields to avoid NOT NULL constraint failures
          final normalized = Map<String, dynamic>.from(variation);
          // If 'selling_price' missing, fallback to 'price' or 0.0
          if (normalized['selling_price'] == null) {
            normalized['selling_price'] = normalized['price'] ?? 0.0;
          }
          // Ensure mrp present
          normalized['mrp'] = normalized['mrp'] ?? 0.0;
          // Ensure boolean-like flags are present
          normalized['is_active'] = normalized['is_active'] ?? true;
          normalized['is_default'] = normalized['is_default'] ?? false;

          final variationData = _convertToSQLiteFormat(normalized, 'product_variations');
          await _safeInsert(db, 'product_variations', variationData);
          // No updated_at column on product_variations; skip watermark tracking for variations
        }
      }

      _logger.info('Downloaded ${products.length} products with variations');
      if (maxProductTs != null) {
        await _setWatermark(db, 'products', maxProductTs!);
      }
      // No variation watermark set (table lacks updated_at in Supabase)
    } catch (e) {
      _logger.error('Failed to download products', e);
    }
  }

  // 6. Download price categories
  Future<void> _downloadPriceCategories(String businessId, Database db) async {
    try {
      final priceCategories = await _supabase
          .from('price_categories')
          .select()
          .eq('business_id', businessId)
          .order('display_order');

      for (final category in priceCategories) {
        final data = _convertToSQLiteFormat({
          ...category,
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        }, 'price_categories');
        
        await _safeInsert(db, 'price_categories', data);
      }

      _logger.info('Downloaded ${priceCategories.length} price categories');
    } catch (e) {
      _logger.error('Failed to download price categories', e);
    }
  }

  // (Removed) Product variation prices are not used anymore; skipping cloud download

  // 8. Download table areas and tables
  Future<void> _downloadTableConfiguration(String businessId, Database db) async {
    try {
      // Download table areas
      final lastAreas = await _getWatermark(db, 'table_areas');
      var areaQuery = _supabase
          .from('table_areas')
          .select()
          .eq('business_id', businessId);
      if (lastAreas != null) {
        areaQuery = areaQuery.gte('updated_at', lastAreas.toIso8601String());
      }
      final areas = await areaQuery.order('updated_at');

      DateTime? maxAreaTs;
      DateTime? maxTableTs;

      for (final area in areas) {
        final areaData = _convertToSQLiteFormat({
          ...area,
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        }, 'table_areas');
        
        await _safeInsert(db, 'table_areas', areaData);
        final aTs = _parseDateTime(area['updated_at']);
        if (aTs != null && (maxAreaTs == null || aTs.isAfter(maxAreaTs))) {
          maxAreaTs = aTs;
        }

        // Download tables for this area
        final lastTables = await _getWatermark(db, 'tables');
        var tableQuery = _supabase
            .from('tables')
            .select()
            .eq('area_id', area['id']);
        if (lastTables != null) {
          tableQuery = tableQuery.gte('updated_at', lastTables.toIso8601String());
        }
        final tables = await tableQuery.order('updated_at');

        for (final table in tables) {
          final tableData = _convertToSQLiteFormat({
            ...table,
            'has_unsynced_changes': 0,
            'last_synced_at': DateTime.now().toIso8601String(),
          }, 'tables');

          await _safeInsert(db, 'tables', tableData);
          final tTs = _parseDateTime(table['updated_at']);
          if (tTs != null && (maxTableTs == null || tTs.isAfter(maxTableTs))) {
            maxTableTs = tTs;
          }
        }
      }

      _logger.info('Downloaded table areas and tables');
      if (maxAreaTs != null) {
        await _setWatermark(db, 'table_areas', maxAreaTs!);
      }
      if (maxTableTs != null) {
        await _setWatermark(db, 'tables', maxTableTs!);
      }
    } catch (e) {
      _logger.error('Failed to download table configuration', e);
    }
  }

  // 9. Download charges
  Future<void> _downloadCharges(String businessId, Database db) async {
    try {
      // Check if charges table exists
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='charges'"
      );

      if (tables.isEmpty) {
        _logger.warning('Charges table does not exist, skipping download');
        return;
      }

      final last = await _getWatermark(db, 'charges');
      var chargeQuery = _supabase
          .from('charges')
          .select()
          .eq('business_id', businessId)
          .eq('is_active', true);
      if (last != null) {
        chargeQuery = chargeQuery.gte('updated_at', last.toIso8601String());
      }
      final charges = await chargeQuery.order('updated_at');

      DateTime? maxTs;

      for (final charge in charges) {
        // Don't add last_synced_at here as it might not exist in the charges table
        final data = _convertToSQLiteFormat({
          ...charge,
          'has_unsynced_changes': 0,
        }, 'charges');
        
        await _safeInsert(db, 'charges', data);
        final ts = _parseDateTime(charge['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${charges.length} charges');
      if (maxTs != null) {
        await _setWatermark(db, 'charges', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download charges', e);
    }
  }

  // 10. Download discounts
  Future<void> _downloadDiscounts(String businessId, Database db) async {
    try {
      // Check if discounts table exists
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='discounts'"
      );

      if (tables.isEmpty) {
        _logger.warning('Discounts table does not exist, skipping download');
        return;
      }

      final last = await _getWatermark(db, 'discounts');
      var discQuery = _supabase
          .from('discounts')
          .select()
          .eq('business_id', businessId)
          .eq('is_active', true);
      if (last != null) {
        discQuery = discQuery.gte('updated_at', last.toIso8601String());
      }
      final discounts = await discQuery.order('updated_at');

      DateTime? maxTs;

      for (final discount in discounts) {
        final data = _convertToSQLiteFormat({
          ...discount,
          'has_unsynced_changes': 0,
        }, 'discounts');
        
        await _safeInsert(db, 'discounts', data);
        final ts = _parseDateTime(discount['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${discounts.length} discounts');
      if (maxTs != null) {
        await _setWatermark(db, 'discounts', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download discounts', e);
    }
  }

  // 11. Download payment methods
  Future<void> _downloadPaymentMethods(String businessId, Database db) async {
    try {
      // Check if payment_methods table exists
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='payment_methods'"
      );

      if (tables.isEmpty) {
        _logger.warning('Payment methods table does not exist, skipping download');
        return;
      }

      final last = await _getWatermark(db, 'payment_methods');
      var payQuery = _supabase
          .from('payment_methods')
          .select()
          .eq('business_id', businessId)
          .eq('is_active', true);
      if (last != null) {
        payQuery = payQuery.gte('updated_at', last.toIso8601String());
      }
      final paymentMethods = await payQuery.order('updated_at');

      DateTime? maxTs;

      for (final method in paymentMethods) {
        final data = _convertToSQLiteFormat({
          ...method,
          'has_unsynced_changes': 0,
        }, 'payment_methods');
        
        await _safeInsert(db, 'payment_methods', data);
        final ts = _parseDateTime(method['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${paymentMethods.length} payment methods');
      if (maxTs != null) {
        await _setWatermark(db, 'payment_methods', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download payment methods', e);
    }
  }

  // 12. Download customers
  Future<void> _downloadCustomers(String businessId, Database db) async {
    try {
      // Check if customers table exists
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='customers'"
      );

      if (tables.isEmpty) {
        _logger.warning('Customers table does not exist, skipping download');
        return;
      }

      final last = await _getWatermark(db, 'customers');
      var custQuery = _supabase
          .from('customers')
          .select()
          .eq('business_id', businessId);
      if (last != null) {
        custQuery = custQuery.gte('updated_at', last.toIso8601String());
      }
      final customers = await custQuery.order('updated_at', ascending: false).limit(500);

      DateTime? maxTs;

      for (final customer in customers) {
        final data = _convertToSQLiteFormat({
          ...customer,
          'has_unsynced_changes': 0,
        }, 'customers');
        
        await _safeInsert(db, 'customers', data);
        final ts = _parseDateTime(customer['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${customers.length} customers');
      if (maxTs != null) {
        await _setWatermark(db, 'customers', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download customers', e);
    }
  }

  // 13. Download employees
  Future<void> _downloadEmployees(String businessId, Database db) async {
    try {
      final last = await _getWatermark(db, 'employees');
      var empQuery = _supabase
          .from('employees')
          .select()
          .eq('business_id', businessId)
          .eq('employment_status', 'active');
      if (last != null) {
        empQuery = empQuery.gte('updated_at', last.toIso8601String());
      }
      final employees = await empQuery.order('updated_at');

      DateTime? maxTs;

      for (final employee in employees) {
        final data = _convertToSQLiteFormat({
          ...employee,
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        }, 'employees');
        
        await _safeInsert(db, 'employees', data);
        final ts = _parseDateTime(employee['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${employees.length} employees');
      if (maxTs != null) {
        await _setWatermark(db, 'employees', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download employees', e);
    }
  }

  // 14. Download active orders
  Future<void> _downloadActiveOrders(String businessId, Database db) async {
    try {
      // Download orders that are not completed or cancelled (delta by updated_at)
      final last = await _getWatermark(db, 'orders');
      var activeQuery = _supabase
          .from('orders')
          .select('*, order_items(*), order_payments(*), order_discounts(*), order_charges(*)')
          .eq('business_id', businessId)
          .or('status.eq.draft,status.eq.confirmed,status.eq.preparing,status.eq.ready,status.eq.served');
      if (last != null) {
        activeQuery = activeQuery.gte('updated_at', last.toIso8601String());
      }
      final ordersResponse = await activeQuery.order('updated_at', ascending: false);

      final orders = ordersResponse as List;

      DateTime? maxTs;
      for (final order in orders) {
        // Save order with nested data as JSON - properly encode arrays as JSON strings
        final orderData = _convertToSQLiteFormat({
          ...Map<String, dynamic>.from(order),
          'items': order['order_items'] != null ? jsonEncode(order['order_items']) : '[]',
          'payments': order['order_payments'] != null ? jsonEncode(order['order_payments']) : '[]',
          'order_discounts': order['order_discounts'] != null ? jsonEncode(order['order_discounts']) : '[]',
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        }, 'orders');
        
        await _safeInsert(db, 'orders', orderData);

        // Save order items
        if (order['order_items'] != null) {
          for (final item in order['order_items']) {
            final itemData = _convertToSQLiteFormat({
              ...item,
              'has_unsynced_changes': 0,
            }, 'order_items');
            
            await _safeInsert(db, 'order_items', itemData);
          }
        }

        // Save order payments
        if (order['order_payments'] != null) {
          for (final payment in order['order_payments']) {
            final paymentData = _convertToSQLiteFormat({
              ...payment,
              'has_unsynced_changes': 0,
            }, 'order_payments');
            
            await _safeInsert(db, 'order_payments', paymentData);
          }
        }
        final ts = _parseDateTime(order['updated_at']);
        if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
          maxTs = ts;
        }
      }

      _logger.info('Downloaded ${orders.length} active orders');
      if (maxTs != null) {
        await _setWatermark(db, 'orders', maxTs!);
      }
    } catch (e) {
      _logger.error('Failed to download active orders', e);
    }
  }

  // 15. Download recent orders (history window, paged)
  Future<void> _downloadRecentOrders(String businessId, Database db) async {
    try {
      // Expand history window to improve fresh-start coverage
      final historyDays = 180;
      final cutoff = DateTime.now().subtract(Duration(days: historyDays));

      final last = await _getWatermark(db, 'orders');
      var baseQuery = _supabase
          .from('orders')
          .select('*, order_items(*), order_payments(*), order_discounts(*), order_charges(*)')
          .eq('business_id', businessId)
          .gte('created_at', cutoff.toIso8601String());
      if (last != null) {
        baseQuery = baseQuery.gte('updated_at', last.toIso8601String());
      }

      const pageSize = 200;
      var offset = 0;
      var totalFetched = 0;
      DateTime? maxTs;

      while (true) {
        final page = await baseQuery
            .order('updated_at', ascending: false)
            .range(offset, offset + pageSize - 1);
        if (page.isEmpty) break;

        for (final order in page) {
          // Skip if already downloaded
          final existing = await db.query(
            'orders',
            where: 'id = ?',
            whereArgs: [order['id']],
          );

          if (existing.isEmpty) {
            final orderData = _convertToSQLiteFormat({
              ...Map<String, dynamic>.from(order),
              'items': order['order_items'] != null ? jsonEncode(order['order_items']) : '[]',
              'payments': order['order_payments'] != null ? jsonEncode(order['order_payments']) : '[]',
              'order_discounts': order['order_discounts'] != null ? jsonEncode(order['order_discounts']) : '[]',
              'has_unsynced_changes': 0,
              'last_synced_at': DateTime.now().toIso8601String(),
            }, 'orders');

            await _safeInsert(db, 'orders', orderData);
          }

          final ts = _parseDateTime(order['updated_at']);
          if (ts != null && (maxTs == null || ts.isAfter(maxTs))) {
            maxTs = ts;
          }
        }

        totalFetched += page.length;
        if (page.length < pageSize) break; // last page
        offset += page.length;
      }

      if (maxTs != null) {
        await _setWatermark(db, 'orders', maxTs!);
      }

      _logger.info('Downloaded $totalFetched recent orders (last $historyDays days)');
    } catch (e) {
      _logger.error('Failed to download recent orders', e);
    }
  }

  void dispose() {
    _progressController.close();
  }
}
