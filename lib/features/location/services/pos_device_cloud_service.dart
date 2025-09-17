import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/utils/logger.dart';
import '../models/pos_device.dart';

class POSDeviceCloudService {
  static final _logger = Logger('POSDeviceCloudService');
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all POS devices for a location from cloud
  Future<List<POSDevice>> getCloudDevicesByLocationId(String locationId) async {
    try {
      final response = await _supabase
          .from('pos_devices')
          .select()
          .eq('location_id', locationId)
          .eq('is_active', true)
          .order('is_default', ascending: false)
          .order('device_name', ascending: true);

      _logger.info('Retrieved ${response.length} POS devices from cloud for location $locationId');
      return response.map<POSDevice>((json) => POSDevice.fromSupabase(json)).toList();
    } catch (e) {
      _logger.error('Error getting cloud POS devices for location $locationId', e);
      throw Exception('Failed to get POS devices from cloud: $e');
    }
  }

  // Get all POS devices for a business from cloud
  Future<List<POSDevice>> getCloudDevicesByBusinessId(String businessId) async {
    try {
      final response = await _supabase
          .from('pos_devices')
          .select('''
            *,
            business_locations!inner(business_id)
          ''')
          .eq('business_locations.business_id', businessId)
          .eq('is_active', true)
          .order('is_default', ascending: false)
          .order('device_name', ascending: true);

      _logger.info('Retrieved ${response.length} POS devices from cloud for business $businessId');
      return response.map<POSDevice>((json) {
        // Remove the nested business_locations data for clean POSDevice parsing
        final cleanJson = Map<String, dynamic>.from(json);
        cleanJson.remove('business_locations');
        return POSDevice.fromSupabase(cleanJson);
      }).toList();
    } catch (e) {
      _logger.error('Error getting cloud POS devices for business $businessId', e);
      throw Exception('Failed to get POS devices from cloud: $e');
    }
  }

  // Create POS device in cloud
  Future<POSDevice> createCloudDevice(POSDevice device) async {
    try {
      // Convert to cloud format with proper date formatting
      final cloudData = device.toSupabaseJson();

      final response = await _supabase
          .from('pos_devices')
          .insert(cloudData)
          .select()
          .single();

      _logger.info('Created POS device in cloud: ${device.deviceName}');
      return POSDevice.fromSupabase(response);
    } catch (e) {
      _logger.error('Error creating POS device in cloud', e);
      throw Exception('Failed to create POS device in cloud: $e');
    }
  }

  // Update POS device in cloud
  Future<POSDevice> updateCloudDevice(POSDevice device) async {
    try {
      // Convert to cloud format with proper date formatting
      final cloudData = device.toSupabaseJson();

      final response = await _supabase
          .from('pos_devices')
          .update(cloudData)
          .eq('id', device.id)
          .select()
          .single();

      _logger.info('Updated POS device in cloud: ${device.deviceName}');
      return POSDevice.fromSupabase(response);
    } catch (e) {
      _logger.error('Error updating POS device in cloud', e);
      throw Exception('Failed to update POS device in cloud: $e');
    }
  }

  // Delete POS device in cloud (soft delete)
  Future<void> deleteCloudDevice(String deviceId) async {
    try {
      await _supabase
          .from('pos_devices')
          .update({'is_active': false})
          .eq('id', deviceId);

      _logger.info('Deleted POS device in cloud: $deviceId');
    } catch (e) {
      _logger.error('Error deleting POS device in cloud', e);
      throw Exception('Failed to delete POS device in cloud: $e');
    }
  }

  // Set POS device as default in cloud
  Future<void> setCloudDeviceAsDefault(String deviceId, String locationId) async {
    try {
      // First, unset other defaults for this location
      await _supabase
          .from('pos_devices')
          .update({'is_default': false})
          .eq('location_id', locationId)
          .eq('is_active', true);

      // Then set this device as default
      await _supabase
          .from('pos_devices')
          .update({'is_default': true})
          .eq('id', deviceId);

      _logger.info('Set POS device as default in cloud: $deviceId');
    } catch (e) {
      _logger.error('Error setting POS device as default in cloud', e);
      throw Exception('Failed to set POS device as default in cloud: $e');
    }
  }

  // Get POS device by ID from cloud
  Future<POSDevice?> getCloudDeviceById(String deviceId) async {
    try {
      final response = await _supabase
          .from('pos_devices')
          .select()
          .eq('id', deviceId)
          .maybeSingle();

      if (response != null) {
        return POSDevice.fromSupabase(response);
      }
      return null;
    } catch (e) {
      _logger.error('Error getting POS device by ID from cloud', e);
      return null;
    }
  }

  // Get POS device by device code from cloud
  Future<POSDevice?> getCloudDeviceByCode(String deviceCode) async {
    try {
      final response = await _supabase
          .from('pos_devices')
          .select()
          .eq('device_code', deviceCode)
          .eq('is_active', true)
          .maybeSingle();

      if (response != null) {
        return POSDevice.fromSupabase(response);
      }
      return null;
    } catch (e) {
      _logger.error('Error getting POS device by code from cloud', e);
      return null;
    }
  }

  // Get default POS device for a location from cloud
  Future<POSDevice?> getCloudDefaultDevice(String locationId) async {
    try {
      final response = await _supabase
          .from('pos_devices')
          .select()
          .eq('location_id', locationId)
          .eq('is_default', true)
          .eq('is_active', true)
          .maybeSingle();

      if (response != null) {
        return POSDevice.fromSupabase(response);
      }
      return null;
    } catch (e) {
      _logger.error('Error getting default POS device from cloud', e);
      return null;
    }
  }

  // Get POS device count for a location from cloud
  Future<int> getCloudDeviceCount(String locationId) async {
    try {
      final response = await _supabase
          .from('pos_devices')
          .select('id')
          .eq('location_id', locationId)
          .eq('is_active', true);

      return response.length;
    } catch (e) {
      _logger.error('Error getting POS device count from cloud', e);
      return 0;
    }
  }

  // Get POS device count for entire business from cloud
  Future<int> getCloudBusinessDeviceCount(String businessId) async {
    try {
      final response = await _supabase
          .from('pos_devices')
          .select('''
            id,
            business_locations!inner(business_id)
          ''')
          .eq('business_locations.business_id', businessId)
          .eq('is_active', true);

      return response.length;
    } catch (e) {
      _logger.error('Error getting business POS device count from cloud', e);
      return 0;
    }
  }

  // Update device sync timestamp in cloud
  Future<void> updateCloudSyncTimestamp(String deviceId) async {
    try {
      await _supabase
          .from('pos_devices')
          .update({'last_sync_at': DateTime.now().toUtc().toIso8601String()})
          .eq('id', deviceId);

      _logger.info('Updated sync timestamp for device in cloud: $deviceId');
    } catch (e) {
      _logger.error('Error updating sync timestamp in cloud', e);
    }
  }

  // Generate unique device code by checking cloud
  Future<String> generateCloudDeviceCode(String locationId) async {
    try {
      // Get count of existing devices for this location
      final count = await getCloudDeviceCount(locationId);
      final deviceCode = 'POS${(count + 1).toString().padLeft(3, '0')}';
      
      // Check if this code already exists
      final existing = await getCloudDeviceByCode(deviceCode);
      if (existing != null) {
        // If it exists, try with timestamp suffix
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
        return 'POS$timestamp';
      }
      
      return deviceCode;
    } catch (e) {
      _logger.error('Error generating device code', e);
      // Fallback to timestamp-based code
      return 'POS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    }
  }

  // Batch sync POS devices from cloud
  Future<List<POSDevice>> syncDevicesFromCloud(String locationId) async {
    try {
      return await getCloudDevicesByLocationId(locationId);
    } catch (e) {
      _logger.error('Error syncing POS devices from cloud', e);
      throw Exception('Failed to sync POS devices from cloud: $e');
    }
  }

  // Check if user has permission to access location's POS devices
  Future<bool> canAccessLocationDevices(String locationId) async {
    try {
      final response = await _supabase
          .from('business_locations')
          .select('''
            id,
            businesses!inner(owner_id)
          ''')
          .eq('id', locationId)
          .eq('businesses.owner_id', _supabase.auth.currentUser?.id ?? '')
          .maybeSingle();

      return response != null;
    } catch (e) {
      _logger.error('Error checking location access', e);
      return false;
    }
  }
}