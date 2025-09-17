import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/business_location.dart';
import '../models/pos_device.dart';
import '../../../core/utils/logger.dart';

class LocationPersistenceService {
  static final _logger = Logger('LocationPersistenceService');
  
  // Keys for SharedPreferences
  static const String _selectedLocationKey = 'selected_location';
  static const String _selectedPOSDeviceKey = 'selected_pos_device';
  static const String _userLocationCachePrefix = 'user_location_cache_';
  static const String _userDeviceCachePrefix = 'user_device_cache_';

  // Save selected location for a user
  static Future<void> saveSelectedLocation(String userId, BusinessLocation location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_selectedLocationKey}_$userId';
      final jsonString = jsonEncode(location.toJson());
      await prefs.setString(key, jsonString);
      _logger.info('Saved selected location for user $userId: ${location.name}');
    } catch (e) {
      _logger.error('Error saving selected location', e);
    }
  }

  // Get selected location for a user
  static Future<BusinessLocation?> getSelectedLocation(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_selectedLocationKey}_$userId';
      final jsonString = prefs.getString(key);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final location = BusinessLocation.fromJson(json);
        _logger.info('Retrieved selected location for user $userId: ${location.name}');
        return location;
      }
    } catch (e) {
      _logger.error('Error getting selected location', e);
    }
    return null;
  }

  // Save selected POS device for a user
  static Future<void> saveSelectedPOSDevice(String userId, POSDevice device) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_selectedPOSDeviceKey}_$userId';
      final jsonString = jsonEncode(device.toJson());
      await prefs.setString(key, jsonString);
      _logger.info('Saved selected POS device for user $userId: ${device.deviceCode}');
    } catch (e) {
      _logger.error('Error saving selected POS device', e);
    }
  }

  // Get selected POS device for a user
  static Future<POSDevice?> getSelectedPOSDevice(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_selectedPOSDeviceKey}_$userId';
      final jsonString = prefs.getString(key);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final device = POSDevice.fromJson(json);
        _logger.info('Retrieved selected POS device for user $userId: ${device.deviceCode}');
        return device;
      }
    } catch (e) {
      _logger.error('Error getting selected POS device', e);
    }
    return null;
  }

  // Clear selected location for a user
  static Future<void> clearSelectedLocation(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_selectedLocationKey}_$userId';
      await prefs.remove(key);
      _logger.info('Cleared selected location for user $userId');
    } catch (e) {
      _logger.error('Error clearing selected location', e);
    }
  }

  // Clear selected POS device for a user
  static Future<void> clearSelectedPOSDevice(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_selectedPOSDeviceKey}_$userId';
      await prefs.remove(key);
      _logger.info('Cleared selected POS device for user $userId');
    } catch (e) {
      _logger.error('Error clearing selected POS device', e);
    }
  }

  // Cache locations for offline access
  static Future<void> cacheUserLocations(String userId, String businessId, List<BusinessLocation> locations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userLocationCachePrefix${userId}_$businessId';
      final jsonString = jsonEncode(locations.map((l) => l.toJson()).toList());
      await prefs.setString(key, jsonString);
      _logger.info('Cached ${locations.length} locations for user $userId, business $businessId');
    } catch (e) {
      _logger.error('Error caching user locations', e);
    }
  }

  // Get cached locations for offline access
  static Future<List<BusinessLocation>> getCachedUserLocations(String userId, String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userLocationCachePrefix${userId}_$businessId';
      final jsonString = prefs.getString(key);
      
      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        final locations = jsonList.map((json) => BusinessLocation.fromJson(json as Map<String, dynamic>)).toList();
        _logger.info('Retrieved ${locations.length} cached locations for user $userId, business $businessId');
        return locations;
      }
    } catch (e) {
      _logger.error('Error getting cached user locations', e);
    }
    return [];
  }

  // Cache POS devices for offline access
  static Future<void> cacheUserDevices(String userId, String locationId, List<POSDevice> devices) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userDeviceCachePrefix${userId}_$locationId';
      final jsonString = jsonEncode(devices.map((d) => d.toJson()).toList());
      await prefs.setString(key, jsonString);
      _logger.info('Cached ${devices.length} devices for user $userId, location $locationId');
    } catch (e) {
      _logger.error('Error caching user devices', e);
    }
  }

  // Get cached POS devices for offline access
  static Future<List<POSDevice>> getCachedUserDevices(String userId, String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userDeviceCachePrefix${userId}_$locationId';
      final jsonString = prefs.getString(key);
      
      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        final devices = jsonList.map((json) => POSDevice.fromJson(json as Map<String, dynamic>)).toList();
        _logger.info('Retrieved ${devices.length} cached devices for user $userId, location $locationId');
        return devices;
      }
    } catch (e) {
      _logger.error('Error getting cached user devices', e);
    }
    return [];
  }

  // Clear all cached data for a user
  static Future<void> clearUserCache(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      // Find all keys related to this user
      final userKeys = keys.where((key) =>
          key.startsWith('${_selectedLocationKey}_$userId') ||
          key.startsWith('${_selectedPOSDeviceKey}_$userId') ||
          key.startsWith('$_userLocationCachePrefix$userId') ||
          key.startsWith('$_userDeviceCachePrefix$userId')).toList();
      
      // Remove all user-related keys
      for (final key in userKeys) {
        await prefs.remove(key);
      }
      
      _logger.info('Cleared all location/device cache for user $userId');
    } catch (e) {
      _logger.error('Error clearing user cache', e);
    }
  }

  // Clear cached locations for a specific business
  static Future<void> clearBusinessLocationCache(String userId, String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userLocationCachePrefix${userId}_$businessId';
      await prefs.remove(key);
      _logger.info('Cleared location cache for user $userId, business $businessId');
    } catch (e) {
      _logger.error('Error clearing business location cache', e);
    }
  }

  // Clear cached devices for a specific location
  static Future<void> clearLocationDeviceCache(String userId, String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userDeviceCachePrefix${userId}_$locationId';
      await prefs.remove(key);
      _logger.info('Cleared device cache for user $userId, location $locationId');
    } catch (e) {
      _logger.error('Error clearing location device cache', e);
    }
  }

  // Check if location cache exists for a business
  static Future<bool> hasLocationCache(String userId, String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userLocationCachePrefix${userId}_$businessId';
      return prefs.containsKey(key);
    } catch (e) {
      _logger.error('Error checking location cache', e);
      return false;
    }
  }

  // Check if device cache exists for a location
  static Future<bool> hasDeviceCache(String userId, String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_userDeviceCachePrefix${userId}_$locationId';
      return prefs.containsKey(key);
    } catch (e) {
      _logger.error('Error checking device cache', e);
      return false;
    }
  }

  // Get cache timestamp for debugging
  static Future<DateTime?> getCacheTimestamp(String userId, String businessId, {bool isDevice = false, String? locationId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = isDevice 
          ? '$_userDeviceCachePrefix${userId}_$locationId'
          : '$_userLocationCachePrefix${userId}_$businessId';
      
      // SharedPreferences doesn't store timestamps directly,
      // but we could enhance this by storing cache metadata
      // For now, we'll check if the key exists and return current time
      if (prefs.containsKey(key)) {
        return DateTime.now(); // Placeholder - could be enhanced with actual timestamps
      }
    } catch (e) {
      _logger.error('Error getting cache timestamp', e);
    }
    return null;
  }

  // Save both location and device together for atomic updates
  static Future<void> saveSelectedContext(String userId, BusinessLocation location, POSDevice device) async {
    try {
      await Future.wait([
        saveSelectedLocation(userId, location),
        saveSelectedPOSDevice(userId, device),
      ]);
      _logger.info('Saved selected context for user $userId: ${location.name} • ${device.deviceCode}');
    } catch (e) {
      _logger.error('Error saving selected context', e);
    }
  }

  // Get both location and device together
  static Future<Map<String, dynamic>?> getSelectedContext(String userId) async {
    try {
      final results = await Future.wait([
        getSelectedLocation(userId),
        getSelectedPOSDevice(userId),
      ]);
      
      final location = results[0] as BusinessLocation?;
      final device = results[1] as POSDevice?;
      
      if (location != null && device != null) {
        return {
          'location': location,
          'device': device,
        };
      }
    } catch (e) {
      _logger.error('Error getting selected context', e);
    }
    return null;
  }

  // Clear both location and device together
  static Future<void> clearSelectedContext(String userId) async {
    try {
      await Future.wait([
        clearSelectedLocation(userId),
        clearSelectedPOSDevice(userId),
      ]);
      _logger.info('Cleared selected context for user $userId');
    } catch (e) {
      _logger.error('Error clearing selected context', e);
    }
  }
}