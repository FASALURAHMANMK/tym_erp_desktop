import 'package:uuid/uuid.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../../services/default_item_manager.dart';
import '../../../core/exceptions/offline_first_exceptions.dart';
import '../../../core/utils/logger.dart';
import '../models/business_location.dart';

class LocationService {
  static final _logger = Logger('LocationService');
  final LocalDatabaseService _dbService = LocalDatabaseService();
  final SyncQueueService _syncQueueService = SyncQueueService();
  final Uuid _uuid = const Uuid();

  // Get all locations for a business
  Future<List<BusinessLocation>> getLocationsByBusinessId(String businessId) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'business_locations',
        where: 'business_id = ? AND is_active = ?',
        whereArgs: [businessId, 1],
        orderBy: 'is_default DESC, name ASC',
      );

      _logger.info('Retrieved ${maps.length} locations for business $businessId');
      return maps.map((map) => BusinessLocation.fromJson(map)).toList();
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve locations for business',
        'getLocationsByBusinessId',
        tableName: 'business_locations',
        recordId: businessId,
        originalError: e,
      );
    }
  }

  // Get location by ID
  Future<BusinessLocation?> getLocationById(String locationId) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'business_locations',
        where: 'id = ?',
        whereArgs: [locationId],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return BusinessLocation.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve location by ID',
        'getLocationById',
        tableName: 'business_locations',
        recordId: locationId,
        originalError: e,
      );
    }
  }

  // Get default location for a business
  Future<BusinessLocation?> getDefaultLocation(String businessId) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'business_locations',
        where: 'business_id = ? AND is_default = ? AND is_active = ?',
        whereArgs: [businessId, 1, 1],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return BusinessLocation.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve default location',
        'getDefaultLocation',
        tableName: 'business_locations',
        recordId: businessId,
        originalError: e,
      );
    }
  }

  // Create a new location
  Future<BusinessLocation> createLocation({
    required String businessId,
    required String name,
    String? address,
    String? phone,
    bool isDefault = false,
  }) async {
    final now = DateTime.now();
    final location = BusinessLocation(
      id: _uuid.v4(),
      businessId: businessId,
      name: name,
      address: address,
      phone: phone,
      isDefault: isDefault,
      isActive: true,
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
    );

    try {
      final db = await _dbService.database;
      
      // If this is being set as default, unset other defaults
      if (isDefault) {
        await DefaultItemManager.unsetLocationDefaults(db, businessId);
      }

      await db.insert('business_locations', location.toJson());
      
      // Add to sync queue
      await _syncQueueService.addToQueue('business_locations', 'insert', location.id, location.toJson());
      
      _logger.info('Created location: ${location.name} for business $businessId');
      return location;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to create location',
        'createLocation',
        tableName: 'business_locations',
        originalError: e,
      );
    }
  }

  // Update location
  Future<BusinessLocation> updateLocation(BusinessLocation location) async {
    final updatedLocation = location.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    try {
      final db = await _dbService.database;
      
      // If this is being set as default, unset other defaults
      if (updatedLocation.isDefault) {
        await DefaultItemManager.unsetLocationDefaults(db, updatedLocation.businessId, excludeLocationId: updatedLocation.id);
      }

      await db.update(
        'business_locations',
        updatedLocation.toJson(),
        where: 'id = ?',
        whereArgs: [updatedLocation.id],
      );

      // Add to sync queue
      await _syncQueueService.addToQueue('business_locations', 'update', updatedLocation.id, updatedLocation.toJson());
      
      _logger.info('Updated location: ${updatedLocation.name}');
      return updatedLocation;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to update location',
        'updateLocation',
        tableName: 'business_locations',
        recordId: updatedLocation.id,
        originalError: e,
      );
    }
  }

  // Delete location (soft delete)
  Future<void> deleteLocation(String locationId) async {
    try {
      final db = await _dbService.database;
      
      // Soft delete - mark as inactive
      await db.update(
        'business_locations',
        {
          'is_active': 0,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
          'sync_status': SyncStatus.pending.name,
        },
        where: 'id = ?',
        whereArgs: [locationId],
      );

      // Add to sync queue
      await _syncQueueService.addToQueue('business_locations', 'update', locationId, {'is_active': false});
      
      _logger.info('Deleted location: $locationId');
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to delete location',
        'deleteLocation',
        tableName: 'business_locations',
        recordId: locationId,
        originalError: e,
      );
    }
  }

  // Set location as default
  Future<void> setAsDefault(String locationId, String businessId) async {
    try {
      final db = await _dbService.database;
      
      // Use DefaultItemManager to set as default
      await DefaultItemManager.setLocationAsDefault(db, locationId, businessId);

      // Add to sync queue
      await _syncQueueService.addToQueue('business_locations', 'update', locationId, {'is_default': true});
      
      _logger.info('Set location $locationId as default for business $businessId');
    } catch (e) {
      throw ExceptionFactory.defaultItem(
        'Failed to set location as default',
        'setAsDefault',
        tableName: 'business_locations',
        parentId: businessId,
        itemId: locationId,
        originalError: e,
      );
    }
  }

  // Create default location for a new business
  Future<BusinessLocation> createDefaultLocation(String businessId, String businessName) async {
    return await createLocation(
      businessId: businessId,
      name: '$businessName - Main Location',
      isDefault: true,
    );
  }

  // Get locations that need syncing
  Future<List<BusinessLocation>> getLocationsToSync() async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'business_locations',
        where: 'sync_status = ?',
        whereArgs: [SyncStatus.pending.name],
      );

      return maps.map((map) => BusinessLocation.fromJson(map)).toList();
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve locations for sync',
        'getLocationsToSync',
        tableName: 'business_locations',
        originalError: e,
      );
    }
  }

  // Mark location as synced
  Future<void> markAsSynced(String locationId) async {
    try {
      final db = await _dbService.database;
      await db.update(
        'business_locations',
        {'sync_status': SyncStatus.synced.name},
        where: 'id = ?',
        whereArgs: [locationId],
      );
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to mark location as synced',
        'markAsSynced',
        tableName: 'business_locations',
        recordId: locationId,
        originalError: e,
      );
    }
  }

  // Insert location from cloud sync
  Future<void> insertLocationFromCloud(BusinessLocation location) async {
    try {
      final db = await _dbService.database;
      await db.insert('business_locations', location.toJson());
      _logger.info('Inserted location from cloud: ${location.name}');
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to insert location from cloud',
        'insertLocationFromCloud',
        tableName: 'business_locations',
        recordId: location.id,
        originalError: e,
      );
    }
  }


  // Get location count for a business
  Future<int> getLocationCount(String businessId) async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM business_locations WHERE business_id = ? AND is_active = ?',
        [businessId, 1],
      );
      return result.first['count'] as int;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to get location count',
        'getLocationCount',
        tableName: 'business_locations',
        recordId: businessId,
        originalError: e,
      );
    }
  }
}