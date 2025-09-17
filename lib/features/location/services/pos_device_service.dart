import 'package:uuid/uuid.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../../services/default_item_manager.dart';
import '../../../services/device_code_generator.dart';
import '../../../core/exceptions/offline_first_exceptions.dart';
import '../../../core/utils/logger.dart';
import '../models/pos_device.dart';
import '../models/business_location.dart';

class POSDeviceService {
  static final _logger = Logger('POSDeviceService');
  final LocalDatabaseService _dbService = LocalDatabaseService();
  final SyncQueueService _syncQueueService = SyncQueueService();
  final Uuid _uuid = const Uuid();

  // Get all POS devices for a location
  Future<List<POSDevice>> getDevicesByLocationId(String locationId) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pos_devices',
        where: 'location_id = ? AND is_active = ?',
        whereArgs: [locationId, 1],
        orderBy: 'is_default DESC, device_name ASC',
      );

      _logger.info('Retrieved ${maps.length} POS devices for location $locationId');
      return maps.map((map) => POSDevice.fromJson(map)).toList();
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve POS devices for location',
        'getDevicesByLocationId',
        tableName: 'pos_devices',
        recordId: locationId,
        originalError: e,
      );
    }
  }

  // Get all POS devices for a business (across all locations)
  Future<List<POSDevice>> getDevicesByBusinessId(String businessId) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT pd.* FROM pos_devices pd
        INNER JOIN business_locations bl ON pd.location_id = bl.id
        WHERE bl.business_id = ? AND pd.is_active = ? AND bl.is_active = ?
        ORDER BY pd.is_default DESC, pd.device_name ASC
      ''', [businessId, 1, 1]);

      _logger.info('Retrieved ${maps.length} POS devices for business $businessId');
      return maps.map((map) => POSDevice.fromJson(map)).toList();
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve POS devices for business',
        'getDevicesByBusinessId',
        tableName: 'pos_devices',
        recordId: businessId,
        originalError: e,
      );
    }
  }

  // Get POS device by ID
  Future<POSDevice?> getDeviceById(String deviceId) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pos_devices',
        where: 'id = ?',
        whereArgs: [deviceId],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return POSDevice.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve POS device by ID',
        'getDeviceById',
        tableName: 'pos_devices',
        recordId: deviceId,
        originalError: e,
      );
    }
  }

  // Get device by device code
  Future<POSDevice?> getDeviceByCode(String deviceCode) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pos_devices',
        where: 'device_code = ? AND is_active = ?',
        whereArgs: [deviceCode, 1],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return POSDevice.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve POS device by code',
        'getDeviceByCode',
        tableName: 'pos_devices',
        recordId: deviceCode,
        originalError: e,
      );
    }
  }

  // Check if device code exists within a specific business (deprecated - use DeviceCodeGenerator)
  @Deprecated('Use DeviceCodeGenerator.isCodeUniqueInBusiness instead')
  Future<bool> isDeviceCodeExistsInBusiness(String deviceCode, String businessId, {String? excludeDeviceId}) async {
    final isUnique = await DeviceCodeGenerator.isCodeUniqueInBusiness(
      deviceCode, 
      businessId, 
      excludeDeviceId: excludeDeviceId,
    );
    return !isUnique; // Invert because this method returns existence, not uniqueness
  }

  // Get default POS device for a location
  Future<POSDevice?> getDefaultDevice(String locationId) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pos_devices',
        where: 'location_id = ? AND is_default = ? AND is_active = ?',
        whereArgs: [locationId, 1, 1],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return POSDevice.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve default POS device',
        'getDefaultDevice',
        tableName: 'pos_devices',
        recordId: locationId,
        originalError: e,
      );
    }
  }


  // Create a new POS device
  Future<POSDevice> createDevice({
    required String locationId,
    required String deviceName,
    String? deviceCode,
    bool isDefault = false,
  }) async {
    final now = DateTime.now();
    
    // Get business ID from location for device code generation
    final db = await _dbService.database;
    final locationResult = await db.query(
      'business_locations',
      columns: ['business_id'],
      where: 'id = ?',
      whereArgs: [locationId],
      limit: 1,
    );
    
    if (locationResult.isEmpty) {
      throw ExceptionFactory.validation(
        'Location not found',
        'createDevice',
        fieldName: 'locationId',
        fieldValue: locationId,
      );
    }
    
    final businessId = locationResult.first['business_id'] as String;
    final generatedCode = await DeviceCodeGenerator.validateOrGenerate(
      deviceCode,
      businessId,
    );
    
    final device = POSDevice(
      id: _uuid.v4(),
      locationId: locationId,
      deviceName: deviceName,
      deviceCode: generatedCode,
      isDefault: isDefault,
      isActive: true,
      lastSyncAt: now,
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
    );

    try {
      // If this is being set as default, unset other defaults for this location
      if (isDefault) {
        await DefaultItemManager.unsetDeviceDefaults(db, locationId);
      }

      await db.insert('pos_devices', device.toJson());
      
      // Add to sync queue
      await _syncQueueService.addToQueue('pos_devices', 'insert', device.id, device.toJson());
      
      _logger.info('Created POS device: ${device.deviceName} (${device.deviceCode}) for location $locationId');
      return device;
    } catch (e) {
      if (e is OfflineFirstException) {
        rethrow;
      }
      throw ExceptionFactory.localDatabase(
        'Failed to create POS device',
        'createDevice',
        tableName: 'pos_devices',
        originalError: e,
      );
    }
  }

  // Update POS device
  Future<POSDevice> updateDevice(POSDevice device) async {
    final updatedDevice = device.copyWith(
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    try {
      final db = await _dbService.database;
      
      // If this is being set as default, unset other defaults for this location
      if (updatedDevice.isDefault) {
        await DefaultItemManager.unsetDeviceDefaults(db, updatedDevice.locationId, excludeDeviceId: updatedDevice.id);
      }

      await db.update(
        'pos_devices',
        updatedDevice.toJson(),
        where: 'id = ?',
        whereArgs: [updatedDevice.id],
      );

      // Add to sync queue
      await _syncQueueService.addToQueue('pos_devices', 'update', updatedDevice.id, updatedDevice.toJson());
      
      _logger.info('Updated POS device: ${updatedDevice.deviceName}');
      return updatedDevice;
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to update POS device',
        'updateDevice',
        tableName: 'pos_devices',
        recordId: updatedDevice.id,
        originalError: e,
      );
    }
  }

  // Update device sync timestamp
  Future<void> updateSyncTimestamp(String deviceId) async {
    try {
      final db = await _dbService.database;
      await db.update(
        'pos_devices',
        {
          'last_sync_at': DateTime.now().millisecondsSinceEpoch,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to update sync timestamp',
        'updateSyncTimestamp',
        tableName: 'pos_devices',
        recordId: deviceId,
        originalError: e,
      );
    }
  }

  // Delete POS device (soft delete)
  Future<void> deleteDevice(String deviceId) async {
    try {
      final db = await _dbService.database;
      
      // Soft delete - mark as inactive
      await db.update(
        'pos_devices',
        {
          'is_active': 0,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
          'sync_status': SyncStatus.pending.name,
        },
        where: 'id = ?',
        whereArgs: [deviceId],
      );

      // Add to sync queue
      await _syncQueueService.addToQueue('pos_devices', 'update', deviceId, {'is_active': false});
      
      _logger.info('Deleted POS device: $deviceId');
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to delete POS device',
        'deleteDevice',
        tableName: 'pos_devices',
        recordId: deviceId,
        originalError: e,
      );
    }
  }

  // Set device as default
  Future<void> setAsDefault(String deviceId, String locationId) async {
    try {
      final db = await _dbService.database;
      
      // Use DefaultItemManager to set as default
      await DefaultItemManager.setDeviceAsDefault(db, deviceId, locationId);

      // Add to sync queue
      await _syncQueueService.addToQueue('pos_devices', 'update', deviceId, {'is_default': true});
      
      _logger.info('Set POS device $deviceId as default for location $locationId');
    } catch (e) {
      throw ExceptionFactory.defaultItem(
        'Failed to set POS device as default',
        'setAsDefault',
        tableName: 'pos_devices',
        parentId: locationId,
        itemId: deviceId,
        originalError: e,
      );
    }
  }

  // Create default POS device for a new location
  Future<POSDevice> createDefaultDevice(String locationId, String locationName) async {
    return await createDevice(
      locationId: locationId,
      deviceName: '$locationName - Main POS',
      isDefault: true,
    );
  }

  // Get devices that need syncing
  Future<List<POSDevice>> getDevicesToSync() async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pos_devices',
        where: 'sync_status = ?',
        whereArgs: [SyncStatus.pending.name],
      );

      return maps.map((map) => POSDevice.fromJson(map)).toList();
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to retrieve devices for sync',
        'getDevicesToSync',
        tableName: 'pos_devices',
        originalError: e,
      );
    }
  }

  // Mark device as synced
  Future<void> markAsSynced(String deviceId) async {
    try {
      final db = await _dbService.database;
      await db.update(
        'pos_devices',
        {'sync_status': SyncStatus.synced.name},
        where: 'id = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to mark device as synced',
        'markAsSynced',
        tableName: 'pos_devices',
        recordId: deviceId,
        originalError: e,
      );
    }
  }

  // Insert device from cloud sync
  Future<void> insertDeviceFromCloud(POSDevice device) async {
    try {
      final db = await _dbService.database;
      await db.insert('pos_devices', device.toJson());
      _logger.info('Inserted device from cloud: ${device.deviceName}');
    } catch (e) {
      throw ExceptionFactory.localDatabase(
        'Failed to insert device from cloud',
        'insertDeviceFromCloud',
        tableName: 'pos_devices',
        recordId: device.id,
        originalError: e,
      );
    }
  }


  // Get device count for a location (deprecated - use DeviceCodeGenerator)
  @Deprecated('Use DeviceCodeGenerator.getLocationDeviceCount instead')
  Future<int> getDeviceCount(String locationId) async {
    return await DeviceCodeGenerator.getLocationDeviceCount(locationId);
  }

  // Get device count for entire business (deprecated - use DeviceCodeGenerator)
  @Deprecated('Use DeviceCodeGenerator.getBusinessDeviceCount instead')
  Future<int> getBusinessDeviceCount(String businessId) async {
    return await DeviceCodeGenerator.getBusinessDeviceCount(businessId);
  }
}