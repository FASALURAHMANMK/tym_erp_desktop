import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../repositories/charge_repository.dart';
import '../models/charge.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../../core/utils/logger.dart';
import '../../sales/providers/cart_provider.dart';

part 'charge_provider.g.dart';

final _logger = Logger('ChargeProvider');

// Charge Repository Provider
@riverpod
Future<ChargeRepository> chargeRepository(Ref ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  
  final repository = ChargeRepository(
    localDatabase: database,
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );
  
  // Initialize tables
  await repository.initializeLocalTables();
  
  return repository;
}

// All Charges Provider
@riverpod
class ChargesNotifier extends _$ChargesNotifier {
  @override
  FutureOr<List<Charge>> build() async {
    final business = ref.watch(selectedBusinessProvider);
    if (business == null) return [];
    
    final selectedLocation = ref.watch(selectedLocationNotifierProvider);
    final locationId = selectedLocation.valueOrNull?.id;
    
    final repository = await ref.watch(chargeRepositoryProvider.future);
    
    // Get all charges for the business
    final result = await repository.getCharges(
      businessId: business.id,
      locationId: locationId,
      activeOnly: false, // Get all charges for management
    );
    
    return result.fold(
      (error) {
        _logger.error('Failed to load charges', error);
        return [];
      },
      (charges) => charges,
    );
  }
  
  Future<void> addCharge({
    required String code,
    required String name,
    required ChargeType chargeType,
    required CalculationType calculationType,
    String? description,
    double? value,
    ChargeScope scope = ChargeScope.order,
    bool autoApply = false,
    bool isMandatory = false,
    bool isTaxable = true,
    bool applyBeforeDiscount = false,
    double? minimumOrderValue,
    double? maximumOrderValue,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String>? applicableDays,
    Map<String, dynamic>? applicableTimeSlots,
    int displayOrder = 0,
    String? iconName,
    String? colorHex,
    List<ChargeTier>? tiers,
    ChargeFormula? formula,
  }) async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final selectedLocation = ref.read(selectedLocationNotifierProvider);
    final locationId = selectedLocation.valueOrNull?.id;
    
    final repository = await ref.read(chargeRepositoryProvider.future);
    
    final result = await repository.addCharge(
      businessId: business.id,
      locationId: locationId,
      code: code,
      name: name,
      chargeType: chargeType,
      calculationType: calculationType,
      description: description,
      value: value,
      scope: scope,
      autoApply: autoApply,
      isMandatory: isMandatory,
      isTaxable: isTaxable,
      applyBeforeDiscount: applyBeforeDiscount,
      minimumOrderValue: minimumOrderValue,
      maximumOrderValue: maximumOrderValue,
      validFrom: validFrom,
      validUntil: validUntil,
      applicableDays: applicableDays,
      applicableTimeSlots: applicableTimeSlots,
      displayOrder: displayOrder,
      iconName: iconName,
      colorHex: colorHex,
      tiers: tiers,
      formula: formula,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (newCharge) {
        // Update the state with the new charge
        final currentCharges = state.valueOrNull ?? [];
        state = AsyncValue.data([...currentCharges, newCharge]);
        _logger.info('Added charge: $name');
      },
    );
  }
  
  Future<void> updateCharge({
    required String chargeId,
    required String name,
    required ChargeType chargeType,
    required CalculationType calculationType,
    String? description,
    double? value,
    ChargeScope? scope,
    bool? autoApply,
    bool? isMandatory,
    bool? isTaxable,
    bool? applyBeforeDiscount,
    double? minimumOrderValue,
    double? maximumOrderValue,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String>? applicableDays,
    Map<String, dynamic>? applicableTimeSlots,
    int? displayOrder,
    bool? isActive,
    String? iconName,
    String? colorHex,
    List<ChargeTier>? tiers,
    ChargeFormula? formula,
  }) async {
    final repository = await ref.read(chargeRepositoryProvider.future);
    
    final result = await repository.updateCharge(
      chargeId: chargeId,
      name: name,
      chargeType: chargeType,
      calculationType: calculationType,
      description: description,
      value: value,
      scope: scope,
      autoApply: autoApply,
      isMandatory: isMandatory,
      isTaxable: isTaxable,
      applyBeforeDiscount: applyBeforeDiscount,
      minimumOrderValue: minimumOrderValue,
      maximumOrderValue: maximumOrderValue,
      validFrom: validFrom,
      validUntil: validUntil,
      applicableDays: applicableDays,
      applicableTimeSlots: applicableTimeSlots,
      displayOrder: displayOrder,
      isActive: isActive,
      iconName: iconName,
      colorHex: colorHex,
      tiers: tiers,
      formula: formula,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (updatedCharge) {
        // Update the state with the updated charge
        final currentCharges = state.valueOrNull ?? [];
        final index = currentCharges.indexWhere((c) => c.id == chargeId);
        if (index != -1) {
          final updatedList = [...currentCharges];
          updatedList[index] = updatedCharge;
          state = AsyncValue.data(updatedList);
        }
        _logger.info('Updated charge: $name');
      },
    );
  }
  
  Future<void> deleteCharge(String chargeId) async {
    final repository = await ref.read(chargeRepositoryProvider.future);
    
    final result = await repository.deleteCharge(chargeId);
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        // Remove from state
        final currentCharges = state.valueOrNull ?? [];
        state = AsyncValue.data(
          currentCharges.where((c) => c.id != chargeId).toList(),
        );
        _logger.info('Deleted charge: $chargeId');
      },
    );
  }
  
  Future<void> toggleChargeStatus(String chargeId, bool isActive) async {
    await updateCharge(
      chargeId: chargeId,
      name: '', // Will be preserved from existing
      chargeType: ChargeType.custom, // Will be preserved
      calculationType: CalculationType.fixed, // Will be preserved
      isActive: isActive,
    );
  }
}

// Active Charges Provider (only active charges for cart/order)
@riverpod
Future<List<Charge>> activeCharges(Ref ref) async {
  final charges = await ref.watch(chargesNotifierProvider.future);
  return charges.where((c) => c.isActive && c.isValid).toList();
}

// Applicable Charges Provider for current cart
@riverpod
Future<List<Charge>> applicableCharges(Ref ref) async {
  final business = ref.watch(selectedBusinessProvider);
  if (business == null) return [];
  
  final selectedLocation = ref.watch(selectedLocationNotifierProvider);
  final locationId = selectedLocation.valueOrNull?.id;
  
  final cart = ref.watch(cartNotifierProvider);
  if (cart == null || cart.isEmpty) return [];
  
  final repository = await ref.watch(chargeRepositoryProvider.future);
  
  // Get categories and products from cart items
  final categoryIds = cart.items
      .where((item) => item.categoryId != null)
      .map((item) => item.categoryId!)
      .toSet()
      .toList();
      
  final productIds = cart.items
      .map((item) => item.productId)
      .toSet()
      .toList();
  
  final result = await repository.getApplicableCharges(
    businessId: business.id,
    locationId: locationId,
    orderValue: cart.subtotal,
    customerId: cart.customerId,
    categoryIds: categoryIds,
    productIds: productIds,
    customerGroupId: null, // TODO: Get from customer when implemented
  );
  
  return result.fold(
    (error) {
      _logger.error('Failed to get applicable charges', error);
      return [];
    },
    (charges) => charges,
  );
}

// Auto-apply charges provider
@riverpod
class AutoApplyCharges extends _$AutoApplyCharges {
  @override
  FutureOr<List<AppliedCharge>> build() async {
    final cart = ref.watch(cartNotifierProvider);
    if (cart == null || cart.isEmpty) return [];
    
    final applicableCharges = await ref.watch(applicableChargesProvider.future);
    
    // Filter for auto-apply charges
    final autoApplyCharges = applicableCharges.where((c) => c.autoApply).toList();
    
    final appliedCharges = <AppliedCharge>[];
    
    for (final charge in autoApplyCharges) {
      final chargeAmount = charge.calculateCharge(cart.subtotal);
      
      if (chargeAmount > 0) {
        appliedCharges.add(
          AppliedCharge(
            id: charge.id,
            orderId: '', // Will be set when order is created
            chargeId: charge.id,
            chargeCode: charge.code,
            chargeName: charge.name,
            chargeType: charge.chargeType.name,
            calculationType: charge.calculationType.name,
            baseAmount: cart.subtotal,
            chargeRate: charge.value,
            chargeAmount: chargeAmount,
            isTaxable: charge.isTaxable,
            createdAt: DateTime.now(),
          ),
        );
      }
    }
    
    return appliedCharges;
  }
  
  void addManualCharge(Charge charge) {
    final chargeAmount = charge.calculateCharge(
      ref.read(cartNotifierProvider)?.subtotal ?? 0,
    );
    
    if (chargeAmount > 0) {
      final appliedCharge = AppliedCharge(
        id: charge.id,
        orderId: '',
        chargeId: charge.id,
        chargeCode: charge.code,
        chargeName: charge.name,
        chargeType: charge.chargeType.name,
        calculationType: charge.calculationType.name,
        baseAmount: ref.read(cartNotifierProvider)?.subtotal ?? 0,
        chargeRate: charge.value,
        chargeAmount: chargeAmount,
        isTaxable: charge.isTaxable,
        isManual: true,
        createdAt: DateTime.now(),
      );
      
      final currentCharges = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentCharges, appliedCharge]);
    }
  }
  
  void removeCharge(String chargeId) {
    final currentCharges = state.valueOrNull ?? [];
    state = AsyncValue.data(
      currentCharges.where((c) => c.chargeId != chargeId).toList(),
    );
  }
  
  void adjustChargeAmount(String chargeId, double newAmount, String reason) {
    final currentCharges = state.valueOrNull ?? [];
    final index = currentCharges.indexWhere((c) => c.chargeId == chargeId);
    
    if (index != -1) {
      final charge = currentCharges[index];
      final adjustedCharge = charge.copyWith(
        originalAmount: charge.chargeAmount,
        chargeAmount: newAmount,
        adjustmentReason: reason,
        isManual: true,
      );
      
      final updatedList = [...currentCharges];
      updatedList[index] = adjustedCharge;
      state = AsyncValue.data(updatedList);
    }
  }
  
  void clearCharges() {
    state = const AsyncValue.data([]);
  }
}

// Calculate total charges
@riverpod
double totalCharges(Ref ref) {
  final charges = ref.watch(autoApplyChargesProvider);
  
  return charges.when(
    data: (chargesList) {
      return chargesList.fold(0.0, (total, charge) => total + charge.chargeAmount);
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
}

// Calculate taxable charges
@riverpod
double taxableCharges(Ref ref) {
  final charges = ref.watch(autoApplyChargesProvider);
  
  return charges.when(
    data: (chargesList) {
      return chargesList
          .where((c) => c.isTaxable)
          .fold(0.0, (total, charge) => total + charge.chargeAmount);
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
}

// Create default charges for new business
@riverpod
class DefaultChargesCreator extends _$DefaultChargesCreator {
  @override
  FutureOr<void> build() async {}
  
  Future<void> createDefaultCharges() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) return;
    
    final repository = await ref.read(chargeRepositoryProvider.future);
    
    try {
      // Create service charge (10%)
      await repository.addCharge(
        businessId: business.id,
        code: 'SERVICE',
        name: 'Service Charge',
        chargeType: ChargeType.service,
        calculationType: CalculationType.percentage,
        description: 'Standard service charge',
        value: 10.0,
        scope: ChargeScope.order,
        autoApply: false,
        isTaxable: true,
        displayOrder: 1,
      );
      
      // Create packaging charge (fixed ₹10)
      await repository.addCharge(
        businessId: business.id,
        code: 'PACKAGING',
        name: 'Packaging Charge',
        chargeType: ChargeType.packaging,
        calculationType: CalculationType.fixed,
        description: 'Standard packaging charge',
        value: 10.0,
        scope: ChargeScope.order,
        autoApply: false,
        isTaxable: false,
        displayOrder: 2,
      );
      
      // Create delivery charge (tiered)
      await repository.addCharge(
        businessId: business.id,
        code: 'DELIVERY',
        name: 'Delivery Charge',
        chargeType: ChargeType.delivery,
        calculationType: CalculationType.tiered,
        description: 'Distance-based delivery charge',
        scope: ChargeScope.order,
        autoApply: false,
        isTaxable: false,
        displayOrder: 3,
        tiers: [
          ChargeTier(
            id: const Uuid().v4(),
            chargeId: '',
            tierName: 'Nearby',
            minValue: 0,
            maxValue: 500,
            chargeValue: 50,
            displayOrder: 1,
            createdAt: DateTime.now(),
          ),
          ChargeTier(
            id: const Uuid().v4(),
            chargeId: '',
            tierName: 'Medium Distance',
            minValue: 500,
            maxValue: 1000,
            chargeValue: 30,
            displayOrder: 2,
            createdAt: DateTime.now(),
          ),
          ChargeTier(
            id: const Uuid().v4(),
            chargeId: '',
            tierName: 'Free Delivery',
            minValue: 1000,
            maxValue: null,
            chargeValue: 0,
            displayOrder: 3,
            createdAt: DateTime.now(),
          ),
        ],
      );
      
      _logger.info('Created default charges for business: ${business.name}');
    } catch (e) {
      _logger.error('Failed to create default charges', e);
    }
  }
}

// Customer charge exemptions provider
@riverpod
class CustomerChargeExemptions extends _$CustomerChargeExemptions {
  @override
  FutureOr<List<CustomerChargeExemption>> build(String customerId) async {
    // TODO: Implement when customer exemptions are needed
    return [];
  }
  
  Future<void> addExemption({
    required String chargeId,
    required String exemptionType,
    double? exemptionValue,
    String? reason,
    DateTime? validFrom,
    DateTime? validUntil,
  }) async {
    // TODO: Implement exemption management
  }
  
  Future<void> removeExemption(String exemptionId) async {
    // TODO: Implement exemption removal
  }
}