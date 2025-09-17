import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/business_location.dart';
import '../../../core/utils/logger.dart';

class LocationCloudService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static final _logger = Logger('LocationCloudService');

  // Get all locations for a business from cloud
  Future<List<BusinessLocation>> getCloudLocationsByBusinessId(
    String businessId,
  ) async {
    try {
      final response = await _supabase
          .from('business_locations')
          .select()
          .eq('business_id', businessId)
          .eq('is_active', true)
          .order('is_default', ascending: false)
          .order('name', ascending: true);

      _logger.info(
        'Retrieved ${response.length} locations from cloud for business $businessId',
      );
      return response
          .map<BusinessLocation>(
            (json) => BusinessLocation.fromSupabase(json),
          )
          .toList();
    } catch (e) {
      _logger.error('Error getting cloud locations for business $businessId', e);
      throw Exception('Failed to get locations from cloud: $e');
    }
  }

  // Create location in cloud
  Future<BusinessLocation> createCloudLocation(
    BusinessLocation location,
  ) async {
    try {
      // Convert to cloud format with proper date formatting
      final cloudData = location.toSupabaseJson();

      final response =
          await _supabase
              .from('business_locations')
              .insert(cloudData)
              .select()
              .single();

      _logger.info('Created location in cloud: ${location.name}');
      return BusinessLocation.fromSupabase(response);
    } catch (e) {
      _logger.error('Error creating location in cloud', e);
      throw Exception('Failed to create location in cloud: $e');
    }
  }

  // Update location in cloud
  Future<BusinessLocation> updateCloudLocation(
    BusinessLocation location,
  ) async {
    try {
      // Convert to cloud format with proper date formatting
      final cloudData = location.toSupabaseJson();

      final response =
          await _supabase
              .from('business_locations')
              .update(cloudData)
              .eq('id', location.id)
              .select()
              .single();

      _logger.info('Updated location in cloud: ${location.name}');
      return BusinessLocation.fromSupabase(response);
    } catch (e) {
      _logger.error('Error updating location in cloud', e);
      throw Exception('Failed to update location in cloud: $e');
    }
  }

  // Delete location in cloud (soft delete)
  Future<void> deleteCloudLocation(String locationId) async {
    try {
      await _supabase
          .from('business_locations')
          .update({'is_active': false})
          .eq('id', locationId);

      _logger.info('Deleted location in cloud: $locationId');
    } catch (e) {
      _logger.error('Error deleting location in cloud', e);
      throw Exception('Failed to delete location in cloud: $e');
    }
  }

  // Set location as default in cloud
  Future<void> setCloudLocationAsDefault(
    String locationId,
    String businessId,
  ) async {
    try {
      // First, unset other defaults for this business
      await _supabase
          .from('business_locations')
          .update({'is_default': false})
          .eq('business_id', businessId)
          .eq('is_active', true);

      // Then set this location as default
      await _supabase
          .from('business_locations')
          .update({'is_default': true})
          .eq('id', locationId);

      _logger.info('Set location as default in cloud: $locationId');
    } catch (e) {
      _logger.error('Error setting location as default in cloud', e);
      throw Exception('Failed to set location as default in cloud: $e');
    }
  }

  // Get location by ID from cloud
  Future<BusinessLocation?> getCloudLocationById(String locationId) async {
    try {
      final response =
          await _supabase
              .from('business_locations')
              .select()
              .eq('id', locationId)
              .maybeSingle();

      if (response != null) {
        return BusinessLocation.fromSupabase(response);
      }
      return null;
    } catch (e) {
      _logger.error('Error getting location by ID from cloud', e);
      return null;
    }
  }

  // Get default location for a business from cloud
  Future<BusinessLocation?> getCloudDefaultLocation(String businessId) async {
    try {
      final response =
          await _supabase
              .from('business_locations')
              .select()
              .eq('business_id', businessId)
              .eq('is_default', true)
              .eq('is_active', true)
              .maybeSingle();

      if (response != null) {
        return BusinessLocation.fromSupabase(response);
      }
      return null;
    } catch (e) {
      _logger.error('Error getting default location from cloud', e);
      return null;
    }
  }

  // Get location count for a business from cloud
  Future<int> getCloudLocationCount(String businessId) async {
    try {
      final response = await _supabase
          .from('business_locations')
          .select('id')
          .eq('business_id', businessId)
          .eq('is_active', true);

      return response.length;
    } catch (e) {
      _logger.error('Error getting location count from cloud', e);
      return 0;
    }
  }

  // Batch sync locations from cloud
  Future<List<BusinessLocation>> syncLocationsFromCloud(
    String businessId,
  ) async {
    try {
      return await getCloudLocationsByBusinessId(businessId);
    } catch (e) {
      _logger.error('Error syncing locations from cloud', e);
      throw Exception('Failed to sync locations from cloud: $e');
    }
  }

  // Check if user has permission to access business locations
  Future<bool> canAccessBusinessLocations(String businessId) async {
    try {
      final response =
          await _supabase
              .from('businesses')
              .select('id')
              .eq('id', businessId)
              .eq('owner_id', _supabase.auth.currentUser?.id ?? '')
              .maybeSingle();

      return response != null;
    } catch (e) {
      _logger.error('Error checking business access', e);
      return false;
    }
  }
}
