import '../../../core/exceptions/offline_first_exceptions.dart';
import '../models/business_location.dart';
import '../models/pos_device.dart';
import 'location_service.dart';
import 'pos_device_service.dart';
import 'location_cloud_service.dart';
import 'pos_device_cloud_service.dart';
import '../../../core/utils/logger.dart';

class LocationSyncService {
  static final _logger = Logger('LocationSyncService');
  
  final LocationService _localLocationService = LocationService();
  final POSDeviceService _localPOSService = POSDeviceService();
  final LocationCloudService _cloudLocationService = LocationCloudService();
  final POSDeviceCloudService _cloudPOSService = POSDeviceCloudService();

  // Download locations from cloud to local (initial sync)
  Future<List<BusinessLocation>> downloadBusinessLocationsFromCloud(String businessId) async {
    try {
      _logger.info('Downloading locations from cloud for business: $businessId');

      // Get existing cloud locations
      final cloudLocations = await _cloudLocationService.getCloudLocationsByBusinessId(businessId);
      
      if (cloudLocations.isEmpty) {
        _logger.info('No cloud locations found for business: $businessId');
        return [];
      }

      // Insert all cloud locations into local database
      for (final cloudLocation in cloudLocations) {
        try {
          // Mark as synced since it's coming from cloud
          final syncedLocation = cloudLocation.copyWith(syncStatus: SyncStatus.synced);
          await _localLocationService.insertLocationFromCloud(syncedLocation);
          _logger.info('Downloaded location from cloud: ${cloudLocation.name}');
        } catch (e) {
          _logger.error('Error downloading location ${cloudLocation.id}', e);
          // Continue with other locations
        }
      }

      _logger.info('Downloaded ${cloudLocations.length} locations from cloud for business: $businessId');
      return cloudLocations;
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to download locations from cloud',
        'downloadBusinessLocationsFromCloud',
        syncDirection: 'download',
        originalError: e,
      );
    }
  }

  // Sync locations for a business (bidirectional)
  Future<List<BusinessLocation>> syncBusinessLocations(String businessId) async {
    try {
      _logger.info('Starting location sync for business: $businessId');

      // Get data from both sources
      final localLocations = await _localLocationService.getLocationsByBusinessId(businessId);
      final cloudLocations = await _cloudLocationService.getCloudLocationsByBusinessId(businessId);

      // If local is empty but cloud has data, download from cloud first
      if (localLocations.isEmpty && cloudLocations.isNotEmpty) {
        _logger.info('Local locations empty, downloading from cloud...');
        return await downloadBusinessLocationsFromCloud(businessId);
      }

      // Merge and resolve conflicts
      final mergedLocations = await _mergeLocations(localLocations, cloudLocations);

      // Update local database with merged data
      for (final location in mergedLocations) {
        final existingLocal = localLocations.firstWhere(
          (l) => l.id == location.id,
          orElse: () => throw StateError('Not found'),
        );

        try {
          if (existingLocal.id == location.id) {
            await _localLocationService.updateLocation(location.copyWith(syncStatus: SyncStatus.synced));
          }
        } catch (e) {
          // Location doesn't exist locally, insert it
          await _localLocationService.insertLocationFromCloud(location.copyWith(syncStatus: SyncStatus.synced));
        }
      }

      // Sync pending local changes to cloud
      await _syncPendingLocationsToCloud(businessId);

      _logger.info('Location sync completed for business: $businessId');
      return mergedLocations;
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to sync business locations',
        'syncBusinessLocations',
        syncDirection: 'bidirectional',
        originalError: e,
      );
    }
  }

  // Download POS devices from cloud to local (initial sync)
  Future<List<POSDevice>> downloadLocationDevicesFromCloud(String locationId) async {
    try {
      _logger.info('Downloading POS devices from cloud for location: $locationId');

      // Get existing cloud devices
      final cloudDevices = await _cloudPOSService.getCloudDevicesByLocationId(locationId);
      
      if (cloudDevices.isEmpty) {
        _logger.info('No cloud POS devices found for location: $locationId');
        return [];
      }

      // Insert all cloud devices into local database
      for (final cloudDevice in cloudDevices) {
        try {
          // Mark as synced since it's coming from cloud
          final syncedDevice = cloudDevice.copyWith(syncStatus: SyncStatus.synced);
          await _localPOSService.insertDeviceFromCloud(syncedDevice);
          _logger.info('Downloaded POS device from cloud: ${cloudDevice.deviceName}');
        } catch (e) {
          _logger.error('Error downloading POS device ${cloudDevice.id}', e);
          // Continue with other devices
        }
      }

      _logger.info('Downloaded ${cloudDevices.length} POS devices from cloud for location: $locationId');
      return cloudDevices;
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to download POS devices from cloud',
        'downloadLocationDevicesFromCloud',
        syncDirection: 'download',
        originalError: e,
      );
    }
  }

  // Sync POS devices for a location (bidirectional)
  Future<List<POSDevice>> syncLocationDevices(String locationId) async {
    try {
      _logger.info('Starting POS device sync for location: $locationId');

      // Get data from both sources
      final localDevices = await _localPOSService.getDevicesByLocationId(locationId);
      final cloudDevices = await _cloudPOSService.getCloudDevicesByLocationId(locationId);

      // If local is empty but cloud has data, download from cloud first
      if (localDevices.isEmpty && cloudDevices.isNotEmpty) {
        _logger.info('Local POS devices empty, downloading from cloud...');
        return await downloadLocationDevicesFromCloud(locationId);
      }

      // Merge and resolve conflicts
      final mergedDevices = await _mergeDevices(localDevices, cloudDevices);

      // Update local database with merged data
      for (final device in mergedDevices) {
        final existingLocal = localDevices.firstWhere(
          (d) => d.id == device.id,
          orElse: () => throw StateError('Not found'),
        );

        try {
          if (existingLocal.id == device.id) {
            await _localPOSService.updateDevice(device.copyWith(syncStatus: SyncStatus.synced));
          }
        } catch (e) {
          // Device doesn't exist locally, insert it
          await _localPOSService.insertDeviceFromCloud(device.copyWith(syncStatus: SyncStatus.synced));
        }
      }

      // Sync pending local changes to cloud
      await _syncPendingDevicesToCloud(locationId);

      _logger.info('POS device sync completed for location: $locationId');
      return mergedDevices;
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to sync location POS devices',
        'syncLocationDevices',
        syncDirection: 'bidirectional',
        originalError: e,
      );
    }
  }

  // Create location with cloud sync
  Future<BusinessLocation> createLocationWithSync({
    required String businessId,
    required String name,
    String? address,
    String? phone,
    bool isDefault = false,
  }) async {
    try {
      // Create locally first
      final localLocation = await _localLocationService.createLocation(
        businessId: businessId,
        name: name,
        address: address,
        phone: phone,
        isDefault: isDefault,
      );

      // Try to sync to cloud
      try {
        await _cloudLocationService.createCloudLocation(localLocation);
        
        // Update local with synced status
        final syncedLocation = localLocation.copyWith(syncStatus: SyncStatus.synced);
        await _localLocationService.updateLocation(syncedLocation);
        
        return syncedLocation;
      } catch (e) {
        _logger.warning('Failed to sync location to cloud, keeping local', e);
        return localLocation; // Return local version, will sync later
      }
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to create location with sync',
        'createLocationWithSync',
        syncDirection: 'upload',
        originalError: e,
      );
    }
  }

  // Create POS device with cloud sync
  Future<POSDevice> createDeviceWithSync({
    required String locationId,
    required String deviceName,
    String? deviceCode,
    bool isDefault = false,
  }) async {
    try {
      // Create locally first
      final localDevice = await _localPOSService.createDevice(
        locationId: locationId,
        deviceName: deviceName,
        deviceCode: deviceCode,
        isDefault: isDefault,
      );

      // Try to sync to cloud
      try {
        await _cloudPOSService.createCloudDevice(localDevice);
        
        // Update local with synced status
        final syncedDevice = localDevice.copyWith(syncStatus: SyncStatus.synced);
        await _localPOSService.updateDevice(syncedDevice);
        
        return syncedDevice;
      } catch (e) {
        _logger.warning('Failed to sync device to cloud, keeping local', e);
        return localDevice; // Return local version, will sync later
      }
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to create device with sync',
        'createDeviceWithSync',
        syncDirection: 'upload',
        originalError: e,
      );
    }
  }

  // Update location with cloud sync
  Future<BusinessLocation> updateLocationWithSync(BusinessLocation location) async {
    try {
      // Update locally first
      final localLocation = await _localLocationService.updateLocation(location);

      // Try to sync to cloud
      try {
        await _cloudLocationService.updateCloudLocation(localLocation);
        
        // Update local with synced status
        final syncedLocation = localLocation.copyWith(syncStatus: SyncStatus.synced);
        await _localLocationService.updateLocation(syncedLocation);
        
        return syncedLocation;
      } catch (e) {
        _logger.warning('Failed to sync location update to cloud, keeping local', e);
        return localLocation; // Return local version, will sync later
      }
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to update location with sync',
        'updateLocationWithSync',
        syncDirection: 'upload',
        originalError: e,
      );
    }
  }

  // Update POS device with cloud sync
  Future<POSDevice> updateDeviceWithSync(POSDevice device) async {
    try {
      // Update locally first
      final localDevice = await _localPOSService.updateDevice(device);

      // Try to sync to cloud
      try {
        await _cloudPOSService.updateCloudDevice(localDevice);
        
        // Update local with synced status
        final syncedDevice = localDevice.copyWith(syncStatus: SyncStatus.synced);
        await _localPOSService.updateDevice(syncedDevice);
        
        return syncedDevice;
      } catch (e) {
        _logger.warning('Failed to sync device update to cloud, keeping local', e);
        return localDevice; // Return local version, will sync later
      }
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to update device with sync',
        'updateDeviceWithSync',
        syncDirection: 'upload',
        originalError: e,
      );
    }
  }

  // Delete location with cloud sync
  Future<void> deleteLocationWithSync(String locationId) async {
    try {
      // Delete locally first (soft delete)
      await _localLocationService.deleteLocation(locationId);

      // Try to sync to cloud
      try {
        await _cloudLocationService.deleteCloudLocation(locationId);
        _logger.info('Location deleted from cloud: $locationId');
      } catch (e) {
        _logger.warning('Failed to sync location deletion to cloud', e);
        // Local deletion is preserved, will sync later
      }
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to delete location with sync',
        'deleteLocationWithSync',
        syncDirection: 'upload',
        originalError: e,
      );
    }
  }

  // Delete POS device with cloud sync
  Future<void> deleteDeviceWithSync(String deviceId) async {
    try {
      // Delete locally first (soft delete)
      await _localPOSService.deleteDevice(deviceId);

      // Try to sync to cloud
      try {
        await _cloudPOSService.deleteCloudDevice(deviceId);
        _logger.info('Device deleted from cloud: $deviceId');
      } catch (e) {
        _logger.warning('Failed to sync device deletion to cloud', e);
        // Local deletion is preserved, will sync later
      }
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to delete device with sync',
        'deleteDeviceWithSync',
        syncDirection: 'upload',
        originalError: e,
      );
    }
  }

  // Download all business data from cloud (for initial login after logout)
  Future<void> downloadAllBusinessDataFromCloud(String businessId) async {
    try {
      _logger.info('Downloading all business data from cloud for business: $businessId');

      // First download locations
      final locations = await downloadBusinessLocationsFromCloud(businessId);
      
      // Then download POS devices for each location
      for (final location in locations) {
        await downloadLocationDevicesFromCloud(location.id);
      }

      _logger.info('Successfully downloaded all business data from cloud for business: $businessId');
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to download all business data from cloud',
        'downloadAllBusinessDataFromCloud',
        syncDirection: 'download',
        originalError: e,
      );
    }
  }

  // Sync all pending changes to cloud
  Future<void> syncPendingChangesToCloud(String businessId) async {
    try {
      await _syncPendingLocationsToCloud(businessId);

      // Get all locations for this business and sync their devices
      final locations = await _localLocationService.getLocationsByBusinessId(businessId);
      for (final location in locations) {
        await _syncPendingDevicesToCloud(location.id);
      }

      _logger.info('All pending changes synced to cloud for business: $businessId');
    } catch (e) {
      throw ExceptionFactory.sync(
        'Failed to sync pending changes to cloud',
        'syncPendingChangesToCloud',
        syncDirection: 'upload',
        originalError: e,
      );
    }
  }

  // Private helper methods
  Future<List<BusinessLocation>> _mergeLocations(
    List<BusinessLocation> localLocations,
    List<BusinessLocation> cloudLocations,
  ) async {
    final mergedMap = <String, BusinessLocation>{};

    // Add all cloud locations (these are the source of truth for synced data)
    for (final cloudLocation in cloudLocations) {
      mergedMap[cloudLocation.id] = cloudLocation;
    }

    // Add local locations that don't exist in cloud or are newer
    for (final localLocation in localLocations) {
      final cloudLocation = mergedMap[localLocation.id];
      
      if (cloudLocation == null) {
        // Local-only location, keep it
        mergedMap[localLocation.id] = localLocation;
      } else if (localLocation.updatedAt.isAfter(cloudLocation.updatedAt)) {
        // Local is newer, prefer local
        mergedMap[localLocation.id] = localLocation;
      }
    }

    return mergedMap.values.toList();
  }

  Future<List<POSDevice>> _mergeDevices(
    List<POSDevice> localDevices,
    List<POSDevice> cloudDevices,
  ) async {
    final mergedMap = <String, POSDevice>{};

    // Add all cloud devices (these are the source of truth for synced data)
    for (final cloudDevice in cloudDevices) {
      mergedMap[cloudDevice.id] = cloudDevice;
    }

    // Add local devices that don't exist in cloud or are newer
    for (final localDevice in localDevices) {
      final cloudDevice = mergedMap[localDevice.id];
      
      if (cloudDevice == null) {
        // Local-only device, keep it
        mergedMap[localDevice.id] = localDevice;
      } else if (localDevice.updatedAt.isAfter(cloudDevice.updatedAt)) {
        // Local is newer, prefer local
        mergedMap[localDevice.id] = localDevice;
      }
    }

    return mergedMap.values.toList();
  }

  Future<void> _syncPendingLocationsToCloud(String businessId) async {
    try {
      final pendingLocations = await _localLocationService.getLocationsToSync();
      final businessLocations = pendingLocations.where((l) => l.businessId == businessId).toList();

      for (final location in businessLocations) {
        try {
          // Check if location exists in cloud
          final cloudLocation = await _cloudLocationService.getCloudLocationById(location.id);
          
          if (cloudLocation == null) {
            // Create in cloud
            try {
              await _cloudLocationService.createCloudLocation(location);
              _logger.info('Successfully created location in cloud: ${location.name}');
            } catch (e) {
              if (e.toString().contains('duplicate key value violates unique constraint')) {
                // Location already exists in cloud but our check missed it
                _logger.info('Location ${location.id} already exists in cloud, marking as synced');
                await _localLocationService.markAsSynced(location.id);
                continue;
              }
              rethrow;
            }
          } else {
            // Update in cloud
            await _cloudLocationService.updateCloudLocation(location);
            _logger.info('Successfully updated location in cloud: ${location.name}');
          }

          // Mark as synced locally
          await _localLocationService.markAsSynced(location.id);
        } catch (e) {
          _logger.error('Failed to sync location ${location.id} to cloud', e);
          // Continue with other locations
        }
      }
    } catch (e) {
      _logger.error('Error syncing pending locations to cloud', e);
    }
  }

  Future<void> _syncPendingDevicesToCloud(String locationId) async {
    try {
      final pendingDevices = await _localPOSService.getDevicesToSync();
      final locationDevices = pendingDevices.where((d) => d.locationId == locationId).toList();

      for (final device in locationDevices) {
        try {
          // Check if device exists in cloud
          final cloudDevice = await _cloudPOSService.getCloudDeviceById(device.id);
          
          if (cloudDevice == null) {
            // Create in cloud
            try {
              await _cloudPOSService.createCloudDevice(device);
              _logger.info('Successfully created POS device in cloud: ${device.deviceName}');
            } catch (e) {
              if (e.toString().contains('duplicate key value violates unique constraint')) {
                // Device already exists in cloud but our check missed it
                _logger.info('Device ${device.id} already exists in cloud, marking as synced');
                await _localPOSService.markAsSynced(device.id);
                continue;
              }
              rethrow;
            }
          } else {
            // Update in cloud
            await _cloudPOSService.updateCloudDevice(device);
            _logger.info('Successfully updated POS device in cloud: ${device.deviceName}');
          }

          // Mark as synced locally
          await _localPOSService.markAsSynced(device.id);
        } catch (e) {
          _logger.error('Failed to sync device ${device.id} to cloud', e);
          // Continue with other devices
        }
      }
    } catch (e) {
      _logger.error('Error syncing pending devices to cloud', e);
    }
  }
}