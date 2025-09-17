import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/business/models/business_model.dart';
import '../../../../features/business/services/business_service.dart';
import '../../../../features/location/models/business_location.dart';
import '../../auth/providers/waiter_auth_provider.dart';

part 'waiter_location_provider.g.dart';

/// Provider for waiter's business context
@riverpod
Future<BusinessModel?> waiterBusiness(Ref ref) async {
  final waiter = ref.watch(currentWaiterProvider);
  if (waiter == null) return null;

  try {
    // Get the business details for the waiter
    final businesses = await BusinessService.getUserBusinesses(waiter.userId);
    final business = businesses.firstWhere(
      (b) => b.id == waiter.businessId,
      orElse: () => throw Exception('Business not found for waiter'),
    );
    return business;
  } catch (e) {
    Logger('WaiterLocationProvider').error('Failed to get waiter business', e);
    return null;
  }
}

/// Provider for waiter's assigned location
/// Fetches locations from Supabase cloud for the waiter app
@riverpod
class WaiterLocationNotifier extends _$WaiterLocationNotifier {
  final _logger = Logger('WaiterLocationNotifier');

  @override
  FutureOr<BusinessLocation?> build() async {
    final waiter = ref.watch(currentWaiterProvider);
    if (waiter == null) {
      _logger.warning('No waiter logged in');
      return null;
    }

    _logger.info('Fetching locations for waiter: ${waiter.displayName} (${waiter.employeeCode})');
    _logger.info('Business ID: ${waiter.businessId}');
    _logger.info('Can access all locations: ${waiter.canAccessAllLocations}');
    _logger.info('Assigned locations: ${waiter.assignedLocations}');

    try {
      // For waiter app, we need to fetch locations from Supabase cloud
      // since the mobile app doesn't have access to desktop's local database
      final supabase = Supabase.instance.client;
      
      // First, let's check if we're authenticated
      final user = supabase.auth.currentUser;
      if (user == null) {
        _logger.error('No authenticated user in Supabase');
        return null;
      }
      _logger.info('Authenticated as user: ${user.id}');
      
      // Fetch locations from Supabase for the business
      _logger.info('Querying business_locations for business_id: ${waiter.businessId}');
      final response = await supabase
          .from('business_locations')
          .select()
          .eq('business_id', waiter.businessId)
          .eq('is_active', true);

      _logger.info('Supabase response: ${response.toString()}');

      if (response.isEmpty) {
        _logger.warning(
          'No locations found in cloud for waiter business: ${waiter.businessId}',
        );
        
        // Try fetching without the is_active filter to see if locations exist but are inactive
        final allLocationsResponse = await supabase
            .from('business_locations')
            .select()
            .eq('business_id', waiter.businessId);
            
        if (allLocationsResponse.isNotEmpty) {
          _logger.warning('Found ${allLocationsResponse.length} locations but none are active');
        } else {
          _logger.warning('No locations found at all for this business');
        }
        
        return null;
      }

      // Convert response to BusinessLocation objects
      // Use fromSupabase since we're getting data from Supabase, not SQLite
      final locations = (response as List)
          .map((json) => BusinessLocation.fromSupabase(json))
          .toList();

      // If waiter has specific location assignments, filter by them
      // Otherwise, if they can access all locations, use the default or first one
      BusinessLocation? selectedLocation;
      
      if (waiter.canAccessAllLocations) {
        // Can access all locations - find default or use first
        selectedLocation = locations.firstWhere(
          (loc) => loc.isDefault,
          orElse: () => locations.first,
        );
      } else if (waiter.assignedLocations.isNotEmpty) {
        // Has specific location assignments
        selectedLocation = locations.firstWhere(
          (loc) => waiter.assignedLocations.contains(loc.id),
          orElse: () => locations.first,
        );
      } else {
        // No specific assignments but can't access all - use default/first
        selectedLocation = locations.firstWhere(
          (loc) => loc.isDefault,
          orElse: () => locations.first,
        );
      }

      _logger.info('Waiter location set to: ${selectedLocation.name}');

      return selectedLocation;
    } catch (e) {
      _logger.error('Failed to get waiter location from cloud', e);
      return null;
    }
  }

  /// Manually set a location for the waiter
  /// This might be used if the waiter can work across multiple locations
  Future<void> setLocation(BusinessLocation location) async {
    state = AsyncValue.data(location);
  }
}
