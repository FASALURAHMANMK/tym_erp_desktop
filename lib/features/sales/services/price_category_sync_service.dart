import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../location/services/location_cloud_service.dart';

/// Service to handle syncing of price categories with proper dependency management
class PriceCategorySyncService {
  static final _logger = Logger('PriceCategorySyncService');
  
  final LocalDatabaseService _localDb = LocalDatabaseService();
  final SyncQueueService _syncQueueService = SyncQueueService();
  final LocationCloudService _locationCloudService = LocationCloudService();
  final SupabaseClient _supabase = Supabase.instance.client;
  final _connectivity = Connectivity();

  // Singleton pattern
  static final PriceCategorySyncService _instance = PriceCategorySyncService._internal();
  factory PriceCategorySyncService() => _instance;
  PriceCategorySyncService._internal();

  /// Process sync queue for price categories
  /// Ensures that locations exist in cloud before syncing price categories
  Future<void> processSyncQueue() async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _logger.info('No internet connection, skipping sync');
        return;
      }

      // Get ready items based on backoff for price categories
      final pendingItems = await _syncQueueService.getReadyItemsForTable('price_categories');
      
      if (pendingItems.isEmpty) {
        _logger.debug('No pending price categories to sync');
        return;
      }

      _logger.info('Processing ${pendingItems.length} pending price category sync items');

      for (final item in pendingItems) {
        await _processSyncItem(item);
      }
    } catch (e, stackTrace) {
      _logger.error('Error processing price category sync queue', e, stackTrace);
    }
  }

  /// Process a single sync queue item
  Future<void> _processSyncItem(Map<String, dynamic> item) async {
    try {
      final data = jsonDecode(item['data'] as String) as Map<String, dynamic>;
      final operation = item['operation'] as String;
      final recordId = item['record_id'] as String;
      
      // Extract location ID from the data
      final locationId = data['locationId'] ?? data['location_id'];
      if (locationId == null) {
        _logger.error('No location ID found in price category data');
        await _syncQueueService.updateRetryCount(
          item['id'] as String,
          'Missing location ID',
        );
        return;
      }

      // Check if location exists in cloud
      final locationExists = await _checkLocationExistsInCloud(locationId);
      
      if (!locationExists) {
        _logger.info('Location $locationId not yet in cloud, deferring price category sync');
        // Don't increment retry count for dependency issues
        return;
      }

      // Convert data to Supabase format
      final supabaseData = _convertToSupabaseFormat(data);

      // Perform the sync operation
      switch (operation) {
        case 'INSERT':
        case 'CREATE':
          await _syncInsert(recordId, supabaseData);
          break;
        case 'UPDATE':
          await _syncUpdate(recordId, supabaseData);
          break;
        case 'DELETE':
          await _syncDelete(recordId);
          break;
        default:
          _logger.warning('Unknown sync operation: $operation');
      }

      // Remove from sync queue on success
      await _syncQueueService.removeItem(item['id'] as String);
      
      // Mark as synced in local database
      await _markAsSynced(recordId);
      
      _logger.info('Successfully synced price category: $recordId');
    } catch (e) {
      final errorMessage = e.toString();
      _logger.error('Error processing sync item ${item['id']}', e);
      
      // Update retry count with error message
      await _syncQueueService.updateRetryCount(
        item['id'] as String,
        errorMessage,
      );
      
      // Handle specific errors
      if (errorMessage.contains('foreign key constraint')) {
        _logger.info('Foreign key constraint error - location may not be synced yet');
        // Don't increment retry count for FK errors that will resolve
      }
    }
  }

  /// Check if a location exists in the cloud
  Future<bool> _checkLocationExistsInCloud(String locationId) async {
    try {
      final location = await _locationCloudService.getCloudLocationById(locationId);
      return location != null;
    } catch (e) {
      _logger.error('Error checking if location exists in cloud', e);
      return false;
    }
  }

  /// Sync INSERT operation
  Future<void> _syncInsert(String recordId, Map<String, dynamic> data) async {
    try {
      await _supabase
          .from('price_categories')
          .insert(data);
      
      _logger.info('Inserted price category to cloud: $recordId');
    } catch (e) {
      if (e.toString().contains('duplicate key')) {
        // Record already exists, try update instead
        _logger.info('Price category already exists in cloud, updating instead');
        await _syncUpdate(recordId, data);
      } else {
        rethrow;
      }
    }
  }

  /// Sync UPDATE operation
  Future<void> _syncUpdate(String recordId, Map<String, dynamic> data) async {
    await _supabase
        .from('price_categories')
        .upsert(data)
        .eq('id', recordId);
    
    _logger.info('Updated price category in cloud: $recordId');
  }

  /// Sync DELETE operation (soft delete)
  Future<void> _syncDelete(String recordId) async {
    await _supabase
        .from('price_categories')
        .update({'is_active': false})
        .eq('id', recordId);
    
    _logger.info('Soft deleted price category in cloud: $recordId');
  }

  /// Mark a record as synced in local database
  Future<void> _markAsSynced(String recordId) async {
    try {
      final db = await _localDb.database;
      await db.update(
        'price_categories',
        {
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [recordId],
      );
    } catch (e) {
      _logger.error('Error marking price category as synced', e);
    }
  }

  /// Convert to Supabase format (snake_case)
  Map<String, dynamic> _convertToSupabaseFormat(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // Convert to snake_case field names
    converted['is_default'] = converted.remove('isDefault');
    converted['is_active'] = converted.remove('isActive');
    converted['is_visible'] = converted.remove('isVisible');
    converted['business_id'] = converted.remove('businessId');
    converted['location_id'] = converted.remove('locationId');
    converted['display_order'] = converted.remove('displayOrder');
    converted['icon_name'] = converted.remove('iconName');
    converted['color_hex'] = converted.remove('colorHex');
    converted['created_at'] = converted.remove('createdAt')?.toString();
    converted['updated_at'] = converted.remove('updatedAt')?.toString();
    converted['created_by'] = converted.remove('createdBy');

    // Remove local-only fields that don't exist in Supabase
    converted.remove('hasUnsyncedChanges');
    converted.remove('has_unsynced_changes');
    converted.remove('lastSyncedAt');
    converted.remove('last_synced_at');

    return converted;
  }

  /// Sync all pending price categories for a business
  Future<void> syncPendingCategoriesForBusiness(String businessId) async {
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _logger.info('No internet connection, skipping sync');
        return;
      }

      // Get all locations for this business
      final db = await _localDb.database;
      final locations = await db.query(
        'business_locations',
        where: 'business_id = ?',
        whereArgs: [businessId],
      );

      // First ensure all locations are synced
      for (final location in locations) {
        final locationId = location['id'] as String;
        final locationExists = await _checkLocationExistsInCloud(locationId);
        
        if (!locationExists) {
          _logger.info('Location $locationId not in cloud, cannot sync its price categories yet');
          continue;
        }

        // Get pending price categories for this location
        final pendingCategories = await db.query(
          'price_categories',
          where: 'location_id = ? AND has_unsynced_changes = 1',
          whereArgs: [locationId],
        );

        _logger.info('Found ${pendingCategories.length} pending price categories for location $locationId');

        // Sync each category
        for (final category in pendingCategories) {
          try {
            final categoryData = Map<String, dynamic>.from(category);
            
            // Convert booleans from integers
            categoryData['isDefault'] = categoryData['is_default'] == 1;
            categoryData['isActive'] = categoryData['is_active'] == 1;
            categoryData['isVisible'] = categoryData['is_visible'] == 1;
            categoryData['businessId'] = categoryData['business_id'];
            categoryData['locationId'] = categoryData['location_id'];
            categoryData['displayOrder'] = categoryData['display_order'];
            categoryData['iconName'] = categoryData['icon_name'];
            categoryData['colorHex'] = categoryData['color_hex'];
            categoryData['createdAt'] = categoryData['created_at'];
            categoryData['updatedAt'] = categoryData['updated_at'];
            categoryData['createdBy'] = categoryData['created_by'];
            
            // Parse settings JSON
            if (categoryData['settings'] is String) {
              try {
                categoryData['settings'] = jsonDecode(categoryData['settings']);
              } catch (_) {
                categoryData['settings'] = {};
              }
            }
            
            final supabaseData = _convertToSupabaseFormat(categoryData);
            
            await _syncInsert(category['id'] as String, supabaseData);
            await _markAsSynced(category['id'] as String);
            
            _logger.info('Successfully synced price category: ${category['name']}');
          } catch (e) {
            _logger.error('Error syncing price category ${category['id']}', e);
            // Continue with other categories
          }
        }
      }
    } catch (e, stackTrace) {
      _logger.error('Error syncing pending categories for business', e, stackTrace);
    }
  }
}
