import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../data/local/product_local_database.dart';
import '../data/repositories/offline_first_product_repository.dart';
import '../domain/models/product.dart';
import '../domain/models/product_category.dart';
import '../domain/repositories/product_repository.dart';
import '../../business/providers/business_provider.dart';

part 'product_provider.g.dart';

final _logger = Logger('ProductProvider');

// Product Repository Provider
final productRepositoryProvider = FutureProvider<ProductRepository>((ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  
  return OfflineFirstProductRepository(
    supabase: Supabase.instance.client,
    localDatabase: ProductLocalDatabase(
      database: database,
      syncQueueService: SyncQueueService(),
    ),
    syncQueueService: SyncQueueService(),
    logger: _logger,
  );
});

// Products by business provider
@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  FutureOr<List<Product>> build(String businessId) async {
    final repositoryAsync = await ref.watch(productRepositoryProvider.future);
    
    final result = await repositoryAsync.getProducts(
      businessId: businessId,
      isActive: true, // Only show active products in POS
    );
    
    return result.fold(
      (error) => throw error,
      (products) => products,
    );
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(productRepositoryProvider.future);
      final result = await repository.getProducts(
        businessId: businessId,
        isActive: true,
      );
      
      return result.fold(
        (error) => throw error,
        (products) => products,
      );
    });
  }
  
  Future<List<Product>> searchProducts(String query) async {
    final repository = await ref.read(productRepositoryProvider.future);
    
    final result = await repository.getProducts(
      businessId: businessId,
      searchQuery: query,
      isActive: true,
    );
    
    return result.fold(
      (error) => throw error,
      (products) => products,
    );
  }
  
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final repository = await ref.read(productRepositoryProvider.future);
    
    final result = await repository.getProducts(
      businessId: businessId,
      categoryId: categoryId,
      isActive: true,
    );
    
    return result.fold(
      (error) => throw error,
      (products) => products,
    );
  }
}

// Product categories provider
@riverpod
FutureOr<List<ProductCategory>> productCategories(
  Ref ref,
  String businessId,
) async {
  final repository = await ref.watch(productRepositoryProvider.future);
  
  final result = await repository.getCategories(
    businessId: businessId,
    isActive: true,
  );
  
  return result.fold(
    (error) => throw error,
    (categories) => categories,
  );
}

// Helper provider to get products for current business
@riverpod
FutureOr<List<Product>> currentBusinessProducts(Ref ref) async {
  final selectedBusiness = ref.watch(selectedBusinessProvider);
  if (selectedBusiness == null) {
    return [];
  }
  
  return ref.watch(productsNotifierProvider(selectedBusiness.id).future);
}

// Helper provider to get categories for current business
@riverpod
FutureOr<List<ProductCategory>> currentBusinessCategories(Ref ref) async {
  final selectedBusiness = ref.watch(selectedBusinessProvider);
  if (selectedBusiness == null) {
    return [];
  }
  
  return ref.watch(productCategoriesProvider(selectedBusiness.id).future);
}