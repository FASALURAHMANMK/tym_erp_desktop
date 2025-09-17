import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/business_model.dart';
import '../models/business_state.dart';
import '../services/business_service.dart';
import '../services/business_persistence_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/services/subscription_persistence_service.dart';
import '../../location/providers/location_provider.dart';
import '../../location/services/location_persistence_service.dart';
import '../../sales/providers/price_category_provider.dart';
import '../../../services/local_database_service.dart';
import '../../../core/utils/logger.dart';
import '../../../tym_waiter_app/main_waiter.dart' as waiter;
import '../../../tym_waiter_app/core/services/waiter_session_service.dart';

part 'business_provider.g.dart';

@riverpod
class BusinessNotifier extends _$BusinessNotifier {
  final _logger = Logger('BusinessNotifier');
  
  @override
  BusinessState build() {
    return const BusinessState();
  }

  /// Check user's businesses after successful authentication
  Future<void> checkUserBusinesses() async {
    // Check if there's an active waiter session
    // Skip business check for waiter employees to prevent interference
    final hasWaiterSession = await WaiterSessionService.isWaiterAuthenticated();
    if (hasWaiterSession || waiter.isInWaiterMode) {
      _logger.info('Skipping business check - waiter session active or in waiter mode');
      return;
    }
    
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // Don't re-check if we already have businesses and a selected business
    // This prevents overwriting state after business creation
    if (state.hasBusinesses && state.hasSelectedBusiness && state.hasCheckedBusinesses) {
      _logger.info('Skipping business check - already have businesses and selection');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      List<BusinessModel> businesses = [];
      bool isOffline = false;
      
      try {
        // Try to fetch from database first (online)
        businesses = await BusinessService.getUserBusinesses(user.id);
        
        // Cache the businesses for offline access
        await BusinessPersistenceService.cacheUserBusinesses(user.id, businesses);
        _logger.info('Fetched ${businesses.length} businesses online and cached them');
      } catch (e) {
        // Network error - try offline cache
        _logger.error('Failed to fetch businesses online', e);
        _logger.info('Attempting to load cached businesses for offline access...');
        
        businesses = await BusinessPersistenceService.getCachedUserBusinesses(user.id);
        isOffline = true;
        
        if (businesses.isEmpty) {
          // No cached data available
          throw Exception('No internet connection and no cached business data available');
        }
        
        _logger.info('Loaded ${businesses.length} businesses from offline cache');
      }
      
      // Check for persisted selected business
      BusinessModel? selectedBusiness;
      final persistedBusinessId = await BusinessPersistenceService.getUserSelectedBusinessId(user.id);
      _logger.info('Persisted business ID for user ${user.id}: $persistedBusinessId (offline: $isOffline)');
      
      if (persistedBusinessId != null) {
        // Try to find the persisted business in user's businesses
        try {
          selectedBusiness = businesses.firstWhere(
            (business) => business.id == persistedBusinessId,
          );
        } catch (e) {
          // Persisted business not found, fall back to auto-select logic
          selectedBusiness = businesses.length == 1 ? businesses.first : null;
        }
      } else if (businesses.length == 1) {
        // Auto-select if only one business exists
        selectedBusiness = businesses.first;
      }
      
      state = state.copyWith(
        userBusinesses: businesses,
        isLoading: false,
        hasCheckedBusinesses: true,
        selectedBusiness: selectedBusiness,
        isOfflineMode: isOffline,
      );
      
      // If a business was auto-selected, trigger download of business data
      if (selectedBusiness != null && !isOffline) {
        try {
          final locationSyncService = ref.read(locationSyncServiceProvider);
          final locationService = ref.read(locationServiceProvider);
          
          // Check if we have any local data for this business
          final localLocations = await locationService.getLocationsByBusinessId(selectedBusiness.id);
          
          if (localLocations.isEmpty) {
            _logger.info('Auto-selected business ${selectedBusiness.name} has no local data, downloading from cloud...');
            await locationSyncService.downloadAllBusinessDataFromCloud(selectedBusiness.id);
            _logger.info('Business data download completed for auto-selected business ${selectedBusiness.name}');
          }
        } catch (e) {
          _logger.warning('Failed to download auto-selected business data from cloud', e);
          // Don't throw error - allow user to continue
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        hasCheckedBusinesses: true,
      );
    }
  }

  /// Create a new business
  Future<BusinessModel> createBusiness({
    required String name,
    required BusinessType businessType,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? taxNumber,
    String? registrationNumber,
  }) async {
    final user = ref.read(currentUserProvider);
    if (user == null) throw Exception('User not authenticated');

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newBusiness = await BusinessService.createBusiness(
        name: name,
        businessType: businessType,
        ownerId: user.id,
        description: description,
        address: address,
        phone: phone,
        email: email,
        website: website,
        taxNumber: taxNumber,
        registrationNumber: registrationNumber,
      );

      // Create trial subscription for the new business
      try {
        await ref.read(businessSubscriptionNotifierProvider(newBusiness.id).notifier)
            .createTrialSubscription(newBusiness.id);
        _logger.info('Created trial subscription for business: ${newBusiness.name}');
      } catch (e) {
        _logger.warning('Failed to create trial subscription', e);
        // Continue even if subscription creation fails
      }

      // Create default location and POS device for the new business
      try {
        final locationService = ref.read(locationServiceProvider);
        final posDeviceService = ref.read(posDeviceServiceProvider);
        
        // Create default location
        final defaultLocation = await locationService.createDefaultLocation(
          newBusiness.id, 
          newBusiness.name,
        );
        _logger.info('Created default location for business: ${defaultLocation.name}');
        
        // Create default POS device for the location
        final defaultPOSDevice = await posDeviceService.createDefaultDevice(
          defaultLocation.id,
          defaultLocation.name,
        );
        _logger.info('Created default POS device: ${defaultPOSDevice.deviceName} (${defaultPOSDevice.deviceCode})');
        
        // Create default price categories for the new location
        try {
          _logger.info('Creating default price categories for location: ${defaultLocation.name}');
          final priceCategoryService = ref.read(priceCategoryServiceProvider);
          await priceCategoryService.createDefaultCategoriesForLocation(
            businessId: newBusiness.id,
            locationId: defaultLocation.id,
          );
          _logger.info('Successfully created default price categories');
        } catch (e) {
          _logger.warning('Failed to create default price categories', e);
          // Continue even if price category creation fails
        }
        
        // Invalidate location providers to refresh the data
        ref.invalidate(businessLocationsNotifierProvider(newBusiness.id));
        ref.invalidate(selectedLocationNotifierProvider);
        ref.invalidate(selectedPOSDeviceNotifierProvider);
        
      } catch (e) {
        _logger.warning('Failed to create default location/POS device', e);
        // Continue even if location setup fails
      }

      // Update state with new business
      final updatedBusinesses = [...state.userBusinesses, newBusiness];
      state = state.copyWith(
        userBusinesses: updatedBusinesses,
        selectedBusiness: newBusiness, // Auto-select the newly created business
        isLoading: false,
      );

      // Persist the newly created and selected business
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        await BusinessPersistenceService.saveUserSelectedBusiness(currentUser.id, newBusiness);
        
        // Update cached businesses list to include the new business
        await BusinessPersistenceService.cacheUserBusinesses(currentUser.id, updatedBusinesses);
      }

      return newBusiness;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Select a business from the user's businesses
  Future<void> selectBusiness(BusinessModel business) async {
    state = state.copyWith(selectedBusiness: business);
    
    // Persist the selected business
    final user = ref.read(currentUserProvider);
    if (user != null) {
      await BusinessPersistenceService.saveUserSelectedBusiness(user.id, business);
    }
    
    // Trigger download of business data from cloud if local database is empty
    try {
      final locationSyncService = ref.read(locationSyncServiceProvider);
      final locationService = ref.read(locationServiceProvider);
      
      // Check if we have any local data for this business
      final localLocations = await locationService.getLocationsByBusinessId(business.id);
      
      if (localLocations.isEmpty) {
        _logger.info('No local data found for business ${business.name}, downloading from cloud...');
        await locationSyncService.downloadAllBusinessDataFromCloud(business.id);
        
        // Invalidate location providers to refresh with downloaded data
        ref.invalidate(businessLocationsNotifierProvider(business.id));
        ref.invalidate(selectedLocationNotifierProvider);
        ref.invalidate(selectedPOSDeviceNotifierProvider);
        
        _logger.info('Business data download completed for ${business.name}');
      } else {
        _logger.info('Local data exists for business ${business.name}, skipping download');
      }
    } catch (e) {
      _logger.warning('Failed to download business data from cloud', e);
      // Don't throw error - allow user to continue with local data
    }
  }

  /// Update an existing business
  Future<void> updateBusiness(BusinessModel updatedBusiness) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final business = await BusinessService.updateBusiness(updatedBusiness);
      
      // Update the business in the list
      final updatedBusinesses = state.userBusinesses
          .map((b) => b.id == business.id ? business : b)
          .toList();

      state = state.copyWith(
        userBusinesses: updatedBusinesses,
        selectedBusiness: state.selectedBusiness?.id == business.id 
            ? business 
            : state.selectedBusiness,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Delete a business (soft delete)
  Future<void> deleteBusiness(String businessId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await BusinessService.deleteBusiness(businessId);
      
      // Remove the business from the list
      final updatedBusinesses = state.userBusinesses
          .where((b) => b.id != businessId)
          .toList();

      // Clear selected business if it was deleted
      BusinessModel? selectedBusiness = state.selectedBusiness;
      if (selectedBusiness?.id == businessId) {
        selectedBusiness = updatedBusinesses.isNotEmpty ? updatedBusinesses.first : null;
      }

      state = state.copyWith(
        userBusinesses: updatedBusinesses,
        selectedBusiness: selectedBusiness,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Clear all business data (used on sign out)
  Future<void> clearBusinessData() async {
    // Clear persisted business selection and cached data
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _logger.info('Clearing all user data for user: ${user.id}');
      
      // Clear business data
      await BusinessPersistenceService.clearUserSelectedBusiness(user.id);
      await BusinessPersistenceService.clearCachedBusinesses(user.id);
      
      // Clear subscription cache for user
      await SubscriptionPersistenceService.clearUserSubscriptionCache(user.id);
      
      // Clear ALL location and POS device persistence data (selected + cached)
      await LocationPersistenceService.clearUserCache(user.id);
      
      // Clear local database (all locations, POS devices, sync queue)
      final dbService = LocalDatabaseService();
      await dbService.clearAllUserData();
      
      _logger.info('All user data cleared successfully (business, subscription, location, and local database)');
    } else {
      _logger.warning('No user found when trying to clear user data');
    }
    
    state = const BusinessState();
  }

  /// Reset error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Convenient providers for accessing business state
@riverpod
bool hasBusinesses(Ref ref) {
  return ref.watch(businessNotifierProvider).hasBusinesses;
}

@riverpod
bool hasMultipleBusinesses(Ref ref) {
  return ref.watch(businessNotifierProvider).hasMultipleBusinesses;
}

@riverpod
BusinessModel? selectedBusiness(Ref ref) {
  return ref.watch(businessNotifierProvider).selectedBusiness;
}

@riverpod
List<BusinessModel> userBusinesses(Ref ref) {
  return ref.watch(businessNotifierProvider).userBusinesses;
}

@riverpod
bool isBusinessLoading(Ref ref) {
  return ref.watch(businessNotifierProvider).isLoading;
}

@riverpod
bool hasCheckedBusinesses(Ref ref) {
  return ref.watch(businessNotifierProvider).hasCheckedBusinesses;
}

/// Navigation helper that determines where to navigate after authentication
@riverpod
String? postAuthNavigation(Ref ref) {
  final businessState = ref.watch(businessNotifierProvider);
  
  // Still checking businesses
  if (!businessState.hasCheckedBusinesses || businessState.isLoading) {
    return null; // Stay on current screen or show loading
  }
  
  // No businesses - go to business creation
  if (!businessState.hasBusinesses) {
    return '/create-business';
  }
  
  // Multiple businesses - go to business selection
  if (businessState.hasMultipleBusinesses && !businessState.hasSelectedBusiness) {
    return '/select-business';
  }
  
  // Single business or business selected - go to main app
  return '/home';
}