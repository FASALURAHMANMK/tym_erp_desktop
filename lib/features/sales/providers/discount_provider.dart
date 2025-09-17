import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/discount_repository.dart';
import '../models/discount.dart';
import '../../business/providers/business_provider.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../../core/utils/logger.dart';
import 'cart_provider.dart';

part 'discount_provider.g.dart';

final _logger = Logger('DiscountProvider');

// Discount Repository Provider
@riverpod
Future<DiscountRepository> discountRepository(Ref ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  
  final repository = DiscountRepository(
    localDatabase: database,
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );
  
  // Initialize tables
  await repository.initializeLocalTables();
  
  return repository;
}

// Active Discounts Provider
@riverpod
class ActiveDiscounts extends _$ActiveDiscounts {
  @override
  FutureOr<List<Discount>> build() async {
    final business = ref.watch(selectedBusinessProvider);
    if (business == null) return [];
    
    final repository = await ref.watch(discountRepositoryProvider.future);
    
    // Get active discounts
    final result = await repository.getDiscounts(
      businessId: business.id,
      status: 'active',
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to load active discounts', error);
        return [];
      },
      (discounts) => discounts,
    );
  }
  
  Future<void> addDiscount({
    required String name,
    required double value,
    required DiscountType type,
    required DiscountScope scope,
    String? code,
    String? description,
    double? minimumAmount,
    double? maximumDiscount,
    DateTime? validFrom,
    DateTime? validUntil,
    bool autoApply = false,
    bool requiresCoupon = false,
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final repository = await ref.read(discountRepositoryProvider.future);
    
    final result = await repository.addDiscount(
      businessId: business.id,
      name: name,
      value: value,
      type: type,
      scope: scope,
      code: code,
      description: description,
      minimumAmount: minimumAmount,
      maximumDiscount: maximumDiscount,
      validFrom: validFrom,
      validUntil: validUntil,
      autoApply: autoApply,
      requiresCoupon: requiresCoupon,
      productIds: productIds,
      categoryIds: categoryIds,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (newDiscount) {
        final currentDiscounts = state.valueOrNull ?? [];
        state = AsyncValue.data([...currentDiscounts, newDiscount]);
        _logger.info('Added discount: $name');
      },
    );
  }
  
  Future<void> updateDiscount({
    required String discountId,
    required String name,
    required double value,
    required DiscountType type,
    required DiscountScope scope,
    String? code,
    String? description,
    double? minimumAmount,
    double? maximumDiscount,
    DateTime? validFrom,
    DateTime? validUntil,
    bool autoApply = false,
    bool requiresCoupon = false,
    bool isActive = true,
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    final repository = await ref.read(discountRepositoryProvider.future);
    
    final result = await repository.updateDiscount(
      discountId: discountId,
      name: name,
      value: value,
      type: type,
      scope: scope,
      code: code,
      description: description,
      minimumAmount: minimumAmount,
      maximumDiscount: maximumDiscount,
      validFrom: validFrom,
      validUntil: validUntil,
      autoApply: autoApply,
      requiresCoupon: requiresCoupon,
      isActive: isActive,
      productIds: productIds,
      categoryIds: categoryIds,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (updatedDiscount) {
        final currentDiscounts = state.valueOrNull ?? [];
        final index = currentDiscounts.indexWhere((d) => d.id == discountId);
        if (index != -1) {
          final updatedList = [...currentDiscounts];
          updatedList[index] = updatedDiscount;
          state = AsyncValue.data(updatedList);
        }
        _logger.info('Updated discount: $name');
      },
    );
  }
  
  Future<void> deleteDiscount(String discountId) async {
    final repository = await ref.read(discountRepositoryProvider.future);
    
    final result = await repository.deleteDiscount(discountId);
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        final currentDiscounts = state.valueOrNull ?? [];
        state = AsyncValue.data(
          currentDiscounts.where((d) => d.id != discountId).toList(),
        );
        _logger.info('Deleted discount: $discountId');
      },
    );
  }
  
  Future<void> toggleDiscountStatus(String discountId, bool isActive) async {
    final repository = await ref.read(discountRepositoryProvider.future);
    
    final result = await repository.toggleDiscountStatus(discountId, isActive);
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        final currentDiscounts = state.valueOrNull ?? [];
        final index = currentDiscounts.indexWhere((d) => d.id == discountId);
        if (index != -1) {
          final updatedList = [...currentDiscounts];
          updatedList[index] = updatedList[index].copyWith(isActive: isActive);
          state = AsyncValue.data(updatedList);
        }
        _logger.info('Toggled discount status: $discountId to $isActive');
      },
    );
  }
}

// Get applicable discounts for a cart
@riverpod
Future<List<Discount>> applicableDiscounts(
  Ref ref, {
  required double cartTotal,
  List<String>? productIds,
  List<String>? categoryIds,
  String? customerId,
}) async {
  final business = ref.watch(selectedBusinessProvider);
  if (business == null) return [];
  
  final repository = await ref.watch(discountRepositoryProvider.future);
  
  final result = await repository.getApplicableDiscounts(
    businessId: business.id,
    cartTotal: cartTotal,
    productIds: productIds,
    categoryIds: categoryIds,
    customerId: customerId,
  );
  
  return result.fold(
    (error) {
      _logger.error('Failed to get applicable discounts', error);
      return [];
    },
    (discounts) => discounts,
  );
}

// Validate a coupon code
@riverpod
Future<Discount?> validateCoupon(
  Ref ref, {
  required String code,
  String? customerId,
}) async {
  final business = ref.watch(selectedBusinessProvider);
  if (business == null) return null;
  
  final repository = await ref.watch(discountRepositoryProvider.future);
  
  final result = await repository.validateCoupon(
    code: code,
    businessId: business.id,
    customerId: customerId,
  );
  
  return result.fold(
    (error) {
      _logger.error('Coupon validation failed: $error');
      return null;
    },
    (discount) => discount,
  );
}

// Calculate discount amount
@riverpod
double calculateDiscount(
  Ref ref, {
  required Discount discount,
  required double baseAmount,
}) {
  return discount.calculateDiscount(baseAmount);
}

// Record discount usage
@riverpod
class DiscountUsage extends _$DiscountUsage {
  @override
  FutureOr<void> build() async {}
  
  Future<void> recordUsage({
    required String discountId,
    required String orderId,
    required double discountAmount,
    String? customerId,
    String? locationId,
  }) async {
    final repository = await ref.read(discountRepositoryProvider.future);
    
    final result = await repository.recordDiscountUsage(
      discountId: discountId,
      orderId: orderId,
      discountAmount: discountAmount,
      customerId: customerId,
      locationId: locationId,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        _logger.info('Recorded discount usage for order: $orderId');
      },
    );
  }
}

// Auto-apply discounts to items provider
@riverpod
class AutoApplyItemDiscounts extends _$AutoApplyItemDiscounts {
  @override
  FutureOr<void> build() async {
    // Watch cart changes
    final cart = ref.watch(cartNotifierProvider);
    if (cart == null || cart.isEmpty) return;
    
    final business = ref.watch(selectedBusinessProvider);
    if (business == null) return;
    
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    
    // Process each item for applicable discounts
    for (final item in cart.items) {
      // Skip if user manually removed discounts from this item
      if (item.manuallyRemovedDiscounts) continue;
      
      // Skip if item already has discounts (manual or auto)
      if (item.appliedDiscounts.isNotEmpty) continue;
      
      // Get applicable discounts for this item
      final discounts = await ref.read(
        applicableDiscountsProvider(
          cartTotal: item.lineSubtotal,
          productIds: [item.productId],
          categoryIds: item.categoryId != null ? [item.categoryId!] : null,
          customerId: cart.customerId,
        ).future,
      );
      
      // Find applicable auto-apply discounts for this item
      final applicableAutoDiscounts = discounts.where((discount) {
        if (!discount.isAutoApply) return false;
        
        // Check if discount applies to this item
        if (discount.productId != null && discount.productId == item.productId) {
          return true;
        }
        
        if (discount.categoryId != null && item.categoryId != null && 
            discount.categoryId == item.categoryId) {
          return true;
        }
        
        // General discount (no specific products/categories)
        if (discount.productId == null && discount.categoryId == null) {
          return true;
        }
        
        return false;
      }).toList();
      
      // Apply the best auto-discount if any
      if (applicableAutoDiscounts.isNotEmpty) {
        // Find the discount with the highest value
        Discount? bestDiscount;
        double bestValue = 0;
        
        for (final discount in applicableAutoDiscounts) {
          final value = discount.calculateDiscount(item.lineSubtotal);
          if (value > bestValue) {
            bestValue = value;
            bestDiscount = discount;
          }
        }
        
        if (bestDiscount != null) {
          cartNotifier.applyItemDiscount(
            item.id,
            discountId: bestDiscount.id,
            discountName: bestDiscount.name,
            type: bestDiscount.type,
            value: bestDiscount.value,
            isAutoApplied: true,
          );
          _logger.info('Auto-applied best discount ${bestDiscount.name} (₹$bestValue) to item ${item.productName}');
        }
      }
    }
  }
}