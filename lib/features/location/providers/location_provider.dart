import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/auth_provider.dart';
import '../../business/providers/business_provider.dart';
import '../../sales/providers/price_category_provider.dart';
import '../../../core/utils/logger.dart';
import '../../../services/device_code_generator.dart';
import '../models/business_location.dart';
import '../models/pos_device.dart';
import '../services/location_persistence_service.dart';
import '../services/location_service.dart';
import '../services/location_sync_service.dart';
import '../services/pos_device_service.dart';

part 'location_provider.g.dart';

// Logger instance
final _logger = Logger('LocationProvider');

// Location Service Provider
@riverpod
LocationService locationService(Ref ref) {
  return LocationService();
}

// POS Device Service Provider
@riverpod
POSDeviceService posDeviceService(Ref ref) {
  return POSDeviceService();
}

// Location Sync Service Provider
@riverpod
LocationSyncService locationSyncService(Ref ref) {
  return LocationSyncService();
}

// Business Locations Provider
@riverpod
class BusinessLocationsNotifier extends _$BusinessLocationsNotifier {
  bool _isSyncing = false;

  @override
  FutureOr<List<BusinessLocation>> build(String businessId) async {
    try {
      // First get local data
      final locationService = ref.read(locationServiceProvider);
      final localLocations = await locationService.getLocationsByBusinessId(
        businessId,
      );

      // Attempt to sync with cloud in background
      _backgroundSync(businessId);

      return localLocations;
    } catch (e) {
      _logger.error('Error building business locations', e);
      rethrow;
    }
  }

  // Background sync that doesn't block the UI
  void _backgroundSync(String businessId) {
    if (_isSyncing) return; // Prevent concurrent syncing

    Future.microtask(() async {
      if (_isSyncing) return; // Double-check
      _isSyncing = true;

      try {
        final syncService = ref.read(locationSyncServiceProvider);
        await syncService.syncBusinessLocations(businessId);
        // Note: syncLocationDevices requires locationId, not businessId
        // Will sync devices per location in their individual providers

        // Refresh the provider after successful sync
        final locationService = ref.read(locationServiceProvider);
        final updatedLocations = await locationService.getLocationsByBusinessId(
          businessId,
        );
        state = AsyncValue.data(updatedLocations);
      } catch (e) {
        _logger.warning('Background sync failed', e);
        // Don't update state on sync failure - keep existing data
      } finally {
        _isSyncing = false;
      }
    });
  }

  Future<void> refreshLocations() async {
    try {
      // First get local data immediately (offline-first)
      final locationService = ref.read(locationServiceProvider);
      final locations = await locationService.getLocationsByBusinessId(
        businessId,
      );
      state = AsyncValue.data(locations);

      // Then attempt background sync without blocking UI
      _backgroundSync(businessId);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<BusinessLocation> createLocation({
    required String name,
    String? address,
    String? phone,
    bool isDefault = false,
  }) async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final posDeviceService = ref.read(posDeviceServiceProvider);

      // Create location
      final location = await locationService.createLocation(
        businessId: businessId,
        name: name,
        address: address,
        phone: phone,
        isDefault: isDefault,
      );

      // Create default POS device for the location
      await posDeviceService.createDefaultDevice(location.id, location.name);

      // Create default price categories for the new location
      try {
        _logger.info('Attempting to create default price categories for location: ${location.name}');
        final priceCategoryService = ref.read(priceCategoryServiceProvider);
        await priceCategoryService.createDefaultCategoriesForLocation(
          businessId: businessId,
          locationId: location.id,
        );
        _logger.info('Successfully created default price categories for location: ${location.name}');
      } catch (e, stackTrace) {
        _logger.error('Failed to create default price categories', e, stackTrace);
        // Continue even if price category creation fails
      }

      // Refresh locations
      await refreshLocations();

      // Invalidate related providers
      ref.invalidate(selectedLocationNotifierProvider);
      ref.invalidate(locationPOSDevicesNotifierProvider(location.id));

      return location;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateLocation(BusinessLocation location) async {
    try {
      final locationService = ref.read(locationServiceProvider);
      await locationService.updateLocation(location);
      await refreshLocations();

      // Invalidate selected location if it was updated
      ref.invalidate(selectedLocationNotifierProvider);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteLocation(String locationId) async {
    try {
      final locationService = ref.read(locationServiceProvider);
      await locationService.deleteLocation(locationId);
      await refreshLocations();

      // Invalidate selected location if it was deleted
      ref.invalidate(selectedLocationNotifierProvider);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> setAsDefault(String locationId) async {
    try {
      final locationService = ref.read(locationServiceProvider);
      await locationService.setAsDefault(locationId, businessId);
      await refreshLocations();

      // Update selected location
      ref.invalidate(selectedLocationNotifierProvider);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }
}

// Selected Location Provider
@riverpod
class SelectedLocationNotifier extends _$SelectedLocationNotifier {
  @override
  FutureOr<BusinessLocation?> build() async {
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final user = ref.watch(currentUserProvider);

    if (selectedBusiness == null || user == null) return null;

    // First try to get persisted location from SharedPreferences
    var location = await LocationPersistenceService.getSelectedLocation(
      user.id,
    );

    // Validate that the persisted location belongs to the selected business
    if (location != null && location.businessId != selectedBusiness.id) {
      location = null; // Clear invalid location
    }

    // If no valid persisted location, try to get from database
    if (location == null) {
      final locationService = ref.read(locationServiceProvider);

      // Try to get default location first
      location = await locationService.getDefaultLocation(selectedBusiness.id);

      // If no default, get first available location
      if (location == null) {
        final locations = await locationService.getLocationsByBusinessId(
          selectedBusiness.id,
        );
        if (locations.isNotEmpty) {
          location = locations.first;
          // Set it as default
          await locationService.setAsDefault(location.id, selectedBusiness.id);
        }
      }

      // Persist the selected location
      if (location != null) {
        await LocationPersistenceService.saveSelectedLocation(
          user.id,
          location,
        );
      }
    }

    return location;
  }

  Future<void> selectLocation(BusinessLocation location) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = AsyncValue.data(location);

    // Persist the selection
    await LocationPersistenceService.saveSelectedLocation(user.id, location);

    // Note: Don't invalidate selectedPOSDeviceNotifierProvider here to avoid circular dependency
    // The POS device will be updated separately when selectDevice() is called
  }

  Future<void> clearSelection() async {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      await LocationPersistenceService.clearSelectedLocation(user.id);
    }
    state = const AsyncValue.data(null);
  }
}

// Location POS Devices Provider
@riverpod
class LocationPOSDevicesNotifier extends _$LocationPOSDevicesNotifier {
  bool _isSyncing = false;

  @override
  FutureOr<List<POSDevice>> build(String locationId) async {
    try {
      // First get local data
      final posDeviceService = ref.read(posDeviceServiceProvider);
      final localDevices = await posDeviceService.getDevicesByLocationId(
        locationId,
      );

      // Attempt background sync
      _backgroundSyncDevices(locationId);

      return localDevices;
    } catch (e) {
      _logger.error('Error building location POS devices', e);
      rethrow;
    }
  }

  // Background sync for POS devices
  void _backgroundSyncDevices(String locationId) {
    if (_isSyncing) return; // Prevent concurrent syncing

    Future.microtask(() async {
      if (_isSyncing) return; // Double-check
      _isSyncing = true;

      try {
        final syncService = ref.read(locationSyncServiceProvider);
        await syncService.syncLocationDevices(locationId);

        // Refresh the provider after successful sync
        final posDeviceService = ref.read(posDeviceServiceProvider);
        final updatedDevices = await posDeviceService.getDevicesByLocationId(
          locationId,
        );
        state = AsyncValue.data(updatedDevices);
      } catch (e) {
        _logger.warning('Background POS device sync failed', e);
        // Don't update state on sync failure - keep existing data
      } finally {
        _isSyncing = false;
      }
    });
  }

  Future<void> refreshDevices() async {
    try {
      // First get local data immediately (offline-first)
      final posDeviceService = ref.read(posDeviceServiceProvider);
      final devices = await posDeviceService.getDevicesByLocationId(locationId);
      state = AsyncValue.data(devices);

      // Then attempt background sync without blocking UI
      _backgroundSyncDevices(locationId);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<POSDevice> createDevice({
    required String deviceName,
    String? deviceCode,
    bool isDefault = false,
  }) async {
    try {
      final posDeviceService = ref.read(posDeviceServiceProvider);

      final device = await posDeviceService.createDevice(
        locationId: locationId,
        deviceName: deviceName,
        deviceCode: deviceCode,
        isDefault: isDefault,
      );

      await refreshDevices();

      // Invalidate selected POS device
      ref.invalidate(selectedPOSDeviceNotifierProvider);

      return device;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateDevice(POSDevice device) async {
    try {
      final posDeviceService = ref.read(posDeviceServiceProvider);
      await posDeviceService.updateDevice(device);
      await refreshDevices();

      // Invalidate selected POS device if it was updated
      ref.invalidate(selectedPOSDeviceNotifierProvider);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      final posDeviceService = ref.read(posDeviceServiceProvider);
      await posDeviceService.deleteDevice(deviceId);
      await refreshDevices();

      // Invalidate selected POS device if it was deleted
      ref.invalidate(selectedPOSDeviceNotifierProvider);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> setAsDefault(String deviceId) async {
    try {
      final posDeviceService = ref.read(posDeviceServiceProvider);
      await posDeviceService.setAsDefault(deviceId, locationId);
      await refreshDevices();

      // Update selected POS device
      ref.invalidate(selectedPOSDeviceNotifierProvider);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }
}

// Selected POS Device Provider
@riverpod
class SelectedPOSDeviceNotifier extends _$SelectedPOSDeviceNotifier {
  @override
  FutureOr<POSDevice?> build() async {
    final selectedLocation = ref.watch(selectedLocationNotifierProvider);
    final user = ref.watch(currentUserProvider);

    return selectedLocation.when(
      data: (location) async {
        if (location == null || user == null) return null;

        // First try to get persisted device from SharedPreferences
        var device = await LocationPersistenceService.getSelectedPOSDevice(
          user.id,
        );

        // Validate that the persisted device belongs to the selected location
        if (device != null && device.locationId != location.id) {
          device = null; // Clear invalid device
        }

        // If no valid persisted device, try to get from database
        if (device == null) {
          final posDeviceService = ref.read(posDeviceServiceProvider);

          // Try to get default device first
          device = await posDeviceService.getDefaultDevice(location.id);

          // If no default, get first available device
          if (device == null) {
            final devices = await posDeviceService.getDevicesByLocationId(
              location.id,
            );
            if (devices.isNotEmpty) {
              device = devices.first;
              // Set it as default
              await posDeviceService.setAsDefault(device.id, location.id);
            }
          }

          // Persist the selected device
          if (device != null) {
            await LocationPersistenceService.saveSelectedPOSDevice(
              user.id,
              device,
            );
          }
        }

        return device;
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  Future<void> selectDevice(POSDevice device) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    state = AsyncValue.data(device);

    // Persist the selection
    await LocationPersistenceService.saveSelectedPOSDevice(user.id, device);
  }

  Future<void> clearSelection() async {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      await LocationPersistenceService.clearSelectedPOSDevice(user.id);
    }
    state = const AsyncValue.data(null);
  }
}

// Business POS Devices Provider (all devices across all locations)
@riverpod
Future<List<POSDevice>> businessPOSDevices(
  Ref ref,
  String businessId,
) async {
  final posDeviceService = ref.read(posDeviceServiceProvider);
  return await posDeviceService.getDevicesByBusinessId(businessId);
}

// Location Summary Provider
@riverpod
Future<Map<String, dynamic>> locationSummary(
  Ref ref,
  String businessId,
) async {
  final locationService = ref.read(locationServiceProvider);

  final locationCount = await locationService.getLocationCount(businessId);
  final deviceCount = await DeviceCodeGenerator.getBusinessDeviceCount(businessId);

  return {
    'locationCount': locationCount,
    'deviceCount': deviceCount,
    'hasSetup': locationCount > 0 && deviceCount > 0,
  };
}

// Currently selected context provider for easy access
@riverpod
Future<Map<String, dynamic>?> currentERPContext(
  Ref ref,
) async {
  final business = ref.watch(selectedBusinessProvider);
  final locationAsync = ref.watch(selectedLocationNotifierProvider);
  final deviceAsync = ref.watch(selectedPOSDeviceNotifierProvider);

  if (business == null) return null;

  return locationAsync.when(
    data:
        (location) => deviceAsync.when(
          data:
              (device) => {
                'business': business,
                'location': location,
                'device': device,
                'canOperate': location != null && device != null,
              },
          loading:
              () => {
                'business': business,
                'location': location,
                'device': null,
                'canOperate': false,
              },
          error:
              (_, __) => {
                'business': business,
                'location': location,
                'device': null,
                'canOperate': false,
              },
        ),
    loading:
        () => {
          'business': business,
          'location': null,
          'device': null,
          'canOperate': false,
        },
    error:
        (_, __) => {
          'business': business,
          'location': null,
          'device': null,
          'canOperate': false,
        },
  );
}
