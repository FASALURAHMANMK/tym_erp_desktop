import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/tax_repository.dart';
import '../models/tax_config.dart';
import '../../business/providers/business_provider.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../../core/utils/logger.dart';

part 'tax_provider.g.dart';

final _logger = Logger('TaxProvider');

// Tax Repository Provider
@riverpod
Future<TaxRepository> taxRepository(Ref ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  
  final repository = TaxRepository(
    localDatabase: database,
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );
  
  // Initialize tables
  await repository.initializeLocalTables();
  
  return repository;
}

// Tax Groups Provider
@riverpod
class TaxGroups extends _$TaxGroups {
  @override
  FutureOr<List<TaxGroup>> build() async {
    final business = ref.watch(selectedBusinessProvider);
    if (business == null) return [];
    
    final repository = await ref.watch(taxRepositoryProvider.future);
    
    // Try to download from server first (if online)
    try {
      await repository.downloadTaxData(business.id);
    } catch (e) {
      _logger.warning('Could not download tax data from server, using local data', e);
    }
    
    // Load from local database
    final result = await repository.getTaxGroups(business.id);
    
    return result.fold(
      (error) => throw Exception(error),
      (groups) => groups,
    );
  }
  
  Future<void> addTaxGroup({
    required String name,
    String? description,
    bool isDefault = false,
  }) async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final repository = await ref.read(taxRepositoryProvider.future);
    
    final result = await repository.addTaxGroup(
      businessId: business.id,
      name: name,
      description: description,
      isDefault: isDefault,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (newGroup) {
        final currentGroups = state.valueOrNull ?? [];
        state = AsyncValue.data([...currentGroups, newGroup]);
        _logger.info('Added tax group: $name');
      },
    );
  }
  
  Future<void> addTaxRate({
    required String taxGroupId,
    required String name,
    required double rate,
    TaxType type = TaxType.percentage,
    TaxCalculationMethod calculationMethod = TaxCalculationMethod.exclusive,
  }) async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final repository = await ref.read(taxRepositoryProvider.future);
    
    final result = await repository.addTaxRate(
      taxGroupId: taxGroupId,
      businessId: business.id,
      name: name,
      rate: rate,
      type: type,
      calculationMethod: calculationMethod,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (newRate) {
        // Update the tax group with new rate
        final currentGroups = state.valueOrNull ?? [];
        state = AsyncValue.data(
          currentGroups.map((group) {
            if (group.id == taxGroupId) {
              return group.copyWith(
                taxRates: [...group.taxRates, newRate],
              );
            }
            return group;
          }).toList(),
        );
        _logger.info('Added tax rate: $name to group: $taxGroupId');
      },
    );
  }
  
  Future<void> createDefaultTaxGroups() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) throw Exception('No business selected');
    
    final repository = await ref.read(taxRepositoryProvider.future);
    
    final result = await repository.createDefaultTaxGroups(business.id);
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        // Refresh the list
        ref.invalidateSelf();
        _logger.info('Created default tax groups');
      },
    );
  }
}

// Selected Tax Group Provider
@riverpod
class SelectedTaxGroup extends _$SelectedTaxGroup {
  @override
  TaxGroup? build() => null;
  
  void selectGroup(TaxGroup? group) {
    state = group;
  }
}

// Tax Assignment Providers
@riverpod
class ProductTaxAssignment extends _$ProductTaxAssignment {
  @override
  FutureOr<void> build() async {}
  
  Future<void> assignTaxToProduct({
    required String productId,
    required String taxGroupId,
  }) async {
    final repository = await ref.read(taxRepositoryProvider.future);
    
    final result = await repository.assignTaxToProduct(
      productId: productId,
      taxGroupId: taxGroupId,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        _logger.info('Assigned tax group $taxGroupId to product $productId');
      },
    );
  }
  
  Future<void> assignTaxToProducts({
    required List<String> productIds,
    required String taxGroupId,
  }) async {
    for (final productId in productIds) {
      await assignTaxToProduct(
        productId: productId,
        taxGroupId: taxGroupId,
      );
    }
  }
}

@riverpod
class CategoryTaxAssignment extends _$CategoryTaxAssignment {
  @override
  FutureOr<void> build() async {}
  
  Future<void> assignTaxToCategory({
    required String categoryId,
    required String taxGroupId,
  }) async {
    final repository = await ref.read(taxRepositoryProvider.future);
    
    final result = await repository.assignTaxToCategory(
      categoryId: categoryId,
      taxGroupId: taxGroupId,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        _logger.info('Assigned tax group $taxGroupId to category $categoryId');
      },
    );
  }
  
  Future<void> assignTaxToCategories({
    required List<String> categoryIds,
    required String taxGroupId,
  }) async {
    for (final categoryId in categoryIds) {
      await assignTaxToCategory(
        categoryId: categoryId,
        taxGroupId: taxGroupId,
      );
    }
  }
}

// Get tax for a product
@riverpod
Future<TaxGroup?> productTax(Ref ref, String productId) async {
  final repository = await ref.watch(taxRepositoryProvider.future);
  
  final result = await repository.getTaxForProduct(productId);
  
  return result.fold(
    (error) {
      _logger.error('Error getting tax for product $productId', error);
      return null;
    },
    (taxGroup) => taxGroup,
  );
}

// Default tax group provider
@riverpod
TaxGroup? defaultTaxGroup(Ref ref) {
  final groups = ref.watch(taxGroupsProvider).valueOrNull ?? [];
  
  try {
    return groups.firstWhere((g) => g.isDefault);
  } catch (e) {
    return groups.isNotEmpty ? groups.first : null;
  }
}

// Calculate tax for amount
@riverpod
double calculateTax(
  Ref ref, {
  required double amount,
  required String? taxGroupId,
}) {
  if (taxGroupId == null) return 0;
  
  final groups = ref.watch(taxGroupsProvider).valueOrNull ?? [];
  
  try {
    final group = groups.firstWhere((g) => g.id == taxGroupId);
    
    // Calculate tax from all rates in the group
    double totalTax = 0;
    for (final rate in group.taxRates) {
      if (rate.isActive) {
        totalTax += rate.calculateTax(amount);
      }
    }
    
    return totalTax;
  } catch (e) {
    _logger.error('Error calculating tax for group $taxGroupId', e);
    return 0;
  }
}