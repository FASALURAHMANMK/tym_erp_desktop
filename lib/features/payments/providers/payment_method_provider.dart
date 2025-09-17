import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../business/providers/business_provider.dart';
import '../models/payment_method.dart';
import '../repositories/payment_method_repository.dart';

part 'payment_method_provider.g.dart';

final _logger = Logger('PaymentMethodProvider');

// Payment Method Repository Provider
@riverpod
Future<PaymentMethodRepository> paymentMethodRepository(Ref ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  
  final repository = PaymentMethodRepository(
    localDatabase: database,
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );
  
  // Initialize tables
  await repository.initializeLocalTables();
  
  return repository;
}

// Payment Methods Provider
@riverpod
class PaymentMethods extends _$PaymentMethods {
  @override
  FutureOr<List<PaymentMethod>> build() async {
    final business = ref.watch(selectedBusinessProvider);
    if (business == null) return [];
    
    final repository = await ref.watch(paymentMethodRepositoryProvider.future);
    
    // Ensure default payment methods exist
    final defaultsResult = await repository.ensureDefaultPaymentMethods(
      businessId: business.id,
    );
    
    return defaultsResult.fold(
      (error) {
        _logger.error('Failed to ensure default payment methods', error);
        return [];
      },
      (methods) {
        _logger.info('Loaded ${methods.length} payment methods');
        return methods;
      },
    );
  }
  
  Future<void> refresh() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) return;
    
    final repository = await ref.read(paymentMethodRepositoryProvider.future);
    
    final result = await repository.getPaymentMethods(
      businessId: business.id,
    );
    
    result.fold(
      (error) => _logger.error('Failed to refresh payment methods', error),
      (methods) {
        state = AsyncValue.data(methods);
        _logger.info('Refreshed ${methods.length} payment methods');
      },
    );
  }
  
  Future<void> addPaymentMethod({
    required String name,
    required String code,
    String? icon,
    bool requiresReference = false,
    bool requiresApproval = false,
    Map<String, dynamic>? settings,
  }) async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final repository = await ref.read(paymentMethodRepositoryProvider.future);
    
    final now = DateTime.now();
    final method = PaymentMethod(
      id: const Uuid().v4(),
      businessId: business.id,
      name: name,
      code: code,
      icon: icon,
      requiresReference: requiresReference,
      requiresApproval: requiresApproval,
      settings: settings ?? {},
      displayOrder: (state.value?.length ?? 0) + 1,
      createdAt: now,
      updatedAt: now,
    );
    
    final result = await repository.addPaymentMethod(method: method);
    
    result.fold(
      (error) => throw Exception(error),
      (newMethod) {
        final currentMethods = state.valueOrNull ?? [];
        state = AsyncValue.data([...currentMethods, newMethod]);
        _logger.info('Added payment method: $name');
      },
    );
  }
  
  Future<void> updatePaymentMethod({
    required String methodId,
    String? name,
    String? icon,
    bool? requiresReference,
    bool? requiresApproval,
    Map<String, dynamic>? settings,
    int? displayOrder,
  }) async {
    final currentMethods = state.valueOrNull ?? [];
    final methodIndex = currentMethods.indexWhere((m) => m.id == methodId);
    
    if (methodIndex == -1) {
      throw Exception('Payment method not found');
    }
    
    final method = currentMethods[methodIndex];
    final updatedMethod = method.copyWith(
      name: name ?? method.name,
      icon: icon ?? method.icon,
      requiresReference: requiresReference ?? method.requiresReference,
      requiresApproval: requiresApproval ?? method.requiresApproval,
      settings: settings ?? method.settings,
      displayOrder: displayOrder ?? method.displayOrder,
      updatedAt: DateTime.now(),
    );
    
    final repository = await ref.read(paymentMethodRepositoryProvider.future);
    final result = await repository.updatePaymentMethod(method: updatedMethod);
    
    result.fold(
      (error) => throw Exception(error),
      (updated) {
        final updatedList = [...currentMethods];
        updatedList[methodIndex] = updated;
        state = AsyncValue.data(updatedList);
        _logger.info('Updated payment method: ${updated.name}');
      },
    );
  }
  
  Future<void> deletePaymentMethod(String methodId) async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final repository = await ref.read(paymentMethodRepositoryProvider.future);
    
    final result = await repository.deletePaymentMethod(
      methodId: methodId,
      businessId: business.id,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        final currentMethods = state.valueOrNull ?? [];
        state = AsyncValue.data(
          currentMethods.where((m) => m.id != methodId).toList(),
        );
        _logger.info('Deleted payment method: $methodId');
      },
    );
  }
  
  Future<void> togglePaymentMethodStatus(String methodId, bool isActive) async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final repository = await ref.read(paymentMethodRepositoryProvider.future);
    
    final result = await repository.togglePaymentMethodStatus(
      methodId: methodId,
      isActive: isActive,
      businessId: business.id,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        final currentMethods = state.valueOrNull ?? [];
        final index = currentMethods.indexWhere((m) => m.id == methodId);
        if (index != -1) {
          final updatedList = [...currentMethods];
          updatedList[index] = updatedList[index].copyWith(isActive: isActive);
          state = AsyncValue.data(updatedList);
        }
        _logger.info('Toggled payment method status: $methodId to $isActive');
      },
    );
  }
  
  Future<void> reorderPaymentMethods(List<String> orderedIds) async {
    final currentMethods = state.valueOrNull ?? [];
    final repository = await ref.read(paymentMethodRepositoryProvider.future);
    
    final updatedMethods = <PaymentMethod>[];
    
    for (int i = 0; i < orderedIds.length; i++) {
      final method = currentMethods.firstWhere((m) => m.id == orderedIds[i]);
      final updatedMethod = method.copyWith(displayOrder: i + 1);
      
      final result = await repository.updatePaymentMethod(method: updatedMethod);
      result.fold(
        (error) => _logger.error('Failed to update order for ${method.name}', error),
        (updated) => updatedMethods.add(updated),
      );
    }
    
    // Add any methods not in orderedIds at the end
    for (final method in currentMethods) {
      if (!orderedIds.contains(method.id)) {
        updatedMethods.add(method);
      }
    }
    
    state = AsyncValue.data(updatedMethods);
    _logger.info('Reordered payment methods');
  }
}

// Active Payment Methods Provider (only active methods)
@riverpod
Future<List<PaymentMethod>> activePaymentMethods(Ref ref) async {
  final methods = await ref.watch(paymentMethodsProvider.future);
  return methods.where((m) => m.isActive).toList();
}