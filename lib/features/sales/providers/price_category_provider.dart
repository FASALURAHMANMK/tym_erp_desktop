import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../models/price_category.dart';
import '../repositories/price_category_repository.dart';
import '../services/price_category_sync_service.dart';
import 'cart_provider.dart';

/// Provider for PriceCategoryRepository
final priceCategoryRepositoryProvider = Provider<PriceCategoryRepository>((ref) {
  return PriceCategoryRepository(
    localDb: LocalDatabaseService(),
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );
});

/// Provider for price categories by business and location
final priceCategoriesProvider = FutureProvider.family<List<PriceCategory>, (String, String)>(
  (ref, params) async {
    final (businessId, locationId) = params;
    final repository = ref.watch(priceCategoryRepositoryProvider);
    
    final result = await repository.getPriceCategories(
      businessId: businessId,
      locationId: locationId,
    );
    
    return result.fold(
      (error) => throw error,
      (categories) => categories,
    );
  },
);

/// Provider for visible price categories (for sell screen tabs)
final visiblePriceCategoriesProvider = FutureProvider.family<List<PriceCategory>, (String, String)>(
  (ref, params) async {
    final (businessId, locationId) = params;
    final repository = ref.watch(priceCategoryRepositoryProvider);
    
    final result = await repository.getPriceCategories(
      businessId: businessId,
      locationId: locationId,
    );
    
    return result.fold(
      (error) => throw error,
      (categories) => categories.where((c) => c.isVisible).toList(),
    );
  },
);

/// State notifier for managing selected price category
class SelectedPriceCategoryNotifier extends StateNotifier<PriceCategory?> {
  final Ref ref;
  
  SelectedPriceCategoryNotifier(this.ref) : super(null);
  
  void selectCategory(PriceCategory category) {
    state = category;
    
    // Update cart with selected price category
    ref.read(cartNotifierProvider.notifier).setPriceCategory(
      category.id,
      category.name,
    );
  }
  
  void clear() {
    state = null;
  }
  
  /// Initialize with the first visible category or default
  Future<void> initializeDefault(String businessId, String locationId) async {
    try {
      final categories = await ref.read(
        visiblePriceCategoriesProvider((businessId, locationId)).future,
      );
      
      if (categories.isNotEmpty) {
        // Try to find Dine-In as default, otherwise use first
        final dineInCategory = categories.firstWhere(
          (c) => c.type == PriceCategoryType.dineIn,
          orElse: () => categories.first,
        );
        state = dineInCategory;
      }
    } catch (e) {
      // If error, keep state as null
      state = null;
    }
  }
}

/// Provider for selected price category
final selectedPriceCategoryProvider = 
    StateNotifierProvider<SelectedPriceCategoryNotifier, PriceCategory?>((ref) {
  return SelectedPriceCategoryNotifier(ref);
});

/// Service class for price category operations
class PriceCategoryService {
  static final _logger = Logger('PriceCategoryService');
  final PriceCategoryRepository _repository;
  
  PriceCategoryService(this._repository);
  
  /// Create default price categories for a new business location
  Future<void> createDefaultCategoriesForLocation({
    required String businessId,
    required String locationId,
  }) async {
    final result = await _repository.createDefaultCategories(
      businessId: businessId,
      locationId: locationId,
    );
    
    result.fold(
      (error) => throw error,
      (categories) {
        _logger.info('Created ${categories.length} default price categories');
        // Background sync will handle syncing when location is ready
        return categories;
      },
    );
  }
  
  /// Create a custom price category
  Future<PriceCategory> createCustomCategory({
    required String businessId,
    required String locationId,
    required String name,
    String? description,
    String? iconName,
    String? colorHex,
    int displayOrder = 999,
  }) async {
    final result = await _repository.createPriceCategory(
      businessId: businessId,
      locationId: locationId,
      name: name,
      type: PriceCategoryType.custom,
      description: description,
      iconName: iconName,
      colorHex: colorHex,
      displayOrder: displayOrder,
    );
    
    return result.fold(
      (error) => throw error,
      (category) => category,
    );
  }
  
  /// Update a price category
  Future<PriceCategory> updateCategory(PriceCategory category) async {
    final result = await _repository.updatePriceCategory(category);
    
    return result.fold(
      (error) => throw error,
      (updatedCategory) => updatedCategory,
    );
  }
  
  /// Toggle category visibility
  Future<PriceCategory> toggleCategoryVisibility(PriceCategory category) async {
    final updatedCategory = category.copyWith(
      isVisible: !category.isVisible,
    );
    
    final result = await _repository.updatePriceCategory(updatedCategory);
    
    return result.fold(
      (error) => throw error,
      (category) => category,
    );
  }
  
  /// Delete a price category (soft delete)
  Future<void> deleteCategory(String categoryId) async {
    final result = await _repository.deletePriceCategory(categoryId);
    
    result.fold(
      (error) => throw error,
      (_) => null,
    );
  }
}

/// Provider for PriceCategoryService
final priceCategoryServiceProvider = Provider<PriceCategoryService>((ref) {
  final repository = ref.watch(priceCategoryRepositoryProvider);
  return PriceCategoryService(repository);
});

/// Provider for PriceCategorySyncService
final priceCategorySyncServiceProvider = Provider<PriceCategorySyncService>((ref) {
  return PriceCategorySyncService();
});