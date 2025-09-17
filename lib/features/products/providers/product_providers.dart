import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/exceptions/offline_first_exceptions.dart';
import '../../business/providers/business_provider.dart';
import '../domain/models/product.dart';
import '../domain/models/product_brand.dart';
import '../domain/models/product_category.dart';
import '../domain/models/product_stock.dart';
import 'product_repository_provider.dart';

part 'product_providers.g.dart';

// Single product provider
@riverpod
Future<Product?> productById(Ref ref, String productId) async {
  try {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.getProductById(productId);
    
    return result.fold(
      (failure) => null,
      (product) => product,
    );
  } catch (e) {
    return null;
  }
}

// Product list state
class ProductListState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final String? selectedCategoryId;
  final String? selectedBrandId;
  final bool? showActiveOnly;

  const ProductListState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.selectedCategoryId,
    this.selectedBrandId,
    this.showActiveOnly = true,
  });

  ProductListState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategoryId,
    String? selectedBrandId,
    bool? showActiveOnly,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedBrandId: selectedBrandId ?? this.selectedBrandId,
      showActiveOnly: showActiveOnly ?? this.showActiveOnly,
    );
  }
}

// Product List Notifier
@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  @override
  ProductListState build() {
    // Reload products when business changes
    ref.listen(selectedBusinessProvider, (previous, next) {
      if (previous != next && next != null) {
        loadProducts();
      }
    });

    // Initial load if business is selected
    final business = ref.watch(selectedBusinessProvider);
    if (business != null) {
      Future.microtask(() => loadProducts());
    }

    return const ProductListState();
  }

  Future<void> loadProducts() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = await ref.read(productRepositoryFutureProvider.future);
      final result = await repository.getProducts(
        businessId: business.id,
        categoryId: state.selectedCategoryId,
        brandId: state.selectedBrandId,
        isActive: state.showActiveOnly,
        searchQuery: state.searchQuery,
      );

      result.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
        (products) => state = state.copyWith(
          isLoading: false,
          products: products,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
    loadProducts();
  }

  void setSelectedCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
    loadProducts();
  }

  void setSelectedBrand(String? brandId) {
    state = state.copyWith(selectedBrandId: brandId);
    loadProducts();
  }

  void toggleActiveOnly() {
    state = state.copyWith(showActiveOnly: !state.showActiveOnly!);
    loadProducts();
  }

  Future<Either<OfflineFirstException, Product>> createProduct(Product product) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.createProduct(product);
    
    result.fold(
      (failure) => null,
      (product) => loadProducts(), // Reload list on success
    );
    
    return result;
  }

  Future<Either<OfflineFirstException, Product>> updateProduct(Product product) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.updateProduct(product);
    
    result.fold(
      (failure) => null,
      (product) => loadProducts(), // Reload list on success
    );
    
    return result;
  }

  Future<Either<OfflineFirstException, void>> deleteProduct(String productId) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.deleteProduct(productId);
    
    result.fold(
      (failure) => null,
      (_) => loadProducts(), // Reload list on success
    );
    
    return result;
  }
}

// Category list state
class CategoryListState {
  final List<ProductCategory> categories;
  final bool isLoading;
  final String? error;

  const CategoryListState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoryListState copyWith({
    List<ProductCategory>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryListState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Category List Notifier
@riverpod
class CategoryListNotifier extends _$CategoryListNotifier {
  @override
  CategoryListState build() {
    // Reload categories when business changes
    ref.listen(selectedBusinessProvider, (previous, next) {
      if (previous != next && next != null) {
        loadCategories();
      }
    });

    // Initial load if business is selected
    final business = ref.watch(selectedBusinessProvider);
    if (business != null) {
      Future.microtask(() => loadCategories());
    }

    return const CategoryListState();
  }

  Future<void> loadCategories() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = await ref.read(productRepositoryFutureProvider.future);
      final result = await repository.getCategories(
        businessId: business.id,
        isActive: true,
      );

      result.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
        (categories) => state = state.copyWith(
          isLoading: false,
          categories: categories,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Either<OfflineFirstException, ProductCategory>> createCategory(ProductCategory category) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.createCategory(category);
    
    result.fold(
      (failure) => null,
      (category) => loadCategories(), // Reload list on success
    );
    
    return result;
  }

  Future<Either<OfflineFirstException, ProductCategory>> updateCategory(ProductCategory category) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.updateCategory(category);
    
    result.fold(
      (failure) => null,
      (category) => loadCategories(), // Reload list on success
    );
    
    return result;
  }

  Future<Either<OfflineFirstException, void>> deleteCategory(String categoryId) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.deleteCategory(categoryId);
    
    result.fold(
      (failure) => null,
      (_) => loadCategories(), // Reload list on success
    );
    
    return result;
  }
}

// Brand list state
class BrandListState {
  final List<ProductBrand> brands;
  final bool isLoading;
  final String? error;

  const BrandListState({
    this.brands = const [],
    this.isLoading = false,
    this.error,
  });

  BrandListState copyWith({
    List<ProductBrand>? brands,
    bool? isLoading,
    String? error,
  }) {
    return BrandListState(
      brands: brands ?? this.brands,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Brand List Notifier
@riverpod
class BrandListNotifier extends _$BrandListNotifier {
  @override
  BrandListState build() {
    // Reload brands when business changes
    ref.listen(selectedBusinessProvider, (previous, next) {
      if (previous != next && next != null) {
        loadBrands();
      }
    });

    // Initial load if business is selected
    final business = ref.watch(selectedBusinessProvider);
    if (business != null) {
      Future.microtask(() => loadBrands());
    }

    return const BrandListState();
  }

  Future<void> loadBrands() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = await ref.read(productRepositoryFutureProvider.future);
      final result = await repository.getBrands(
        businessId: business.id,
        isActive: true,
      );

      result.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
        (brands) => state = state.copyWith(
          isLoading: false,
          brands: brands,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Either<OfflineFirstException, ProductBrand>> createBrand(ProductBrand brand) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.createBrand(brand);
    
    result.fold(
      (failure) => null,
      (brand) => loadBrands(), // Reload list on success
    );
    
    return result;
  }

  Future<Either<OfflineFirstException, ProductBrand>> updateBrand(ProductBrand brand) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.updateBrand(brand);
    
    result.fold(
      (failure) => null,
      (brand) => loadBrands(), // Reload list on success
    );
    
    return result;
  }

  Future<Either<OfflineFirstException, void>> deleteBrand(String brandId) async {
    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.deleteBrand(brandId);
    
    result.fold(
      (failure) => null,
      (_) => loadBrands(), // Reload list on success
    );
    
    return result;
  }
}

// Stock providers
@riverpod
Future<Either<OfflineFirstException, List<ProductStock>>> stockLevels(
  Ref ref,
  String locationId,
) async {
  final repository = await ref.watch(productRepositoryFutureProvider.future);
  return repository.getStockLevels(locationId: locationId);
}

@riverpod
Future<Either<OfflineFirstException, List<ProductStock>>> lowStockItems(
  Ref ref,
  String locationId,
) async {
  final repository = await ref.watch(productRepositoryFutureProvider.future);
  return repository.getStockLevels(
    locationId: locationId,
    lowStockOnly: true,
  );
}

// Product detail provider
@riverpod
Future<Either<OfflineFirstException, Product>> productDetail(
  Ref ref,
  String productId,
) async {
  final repository = await ref.watch(productRepositoryFutureProvider.future);
  return repository.getProductById(productId);
}

// Sync provider
@riverpod
class ProductSyncNotifier extends _$ProductSyncNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<Either<OfflineFirstException, void>> syncProducts() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) {
      return Left(
        ValidationException(
          'No business selected',
          'syncProducts',
          fieldName: 'businessId',
        ),
      );
    }

    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.syncProducts(businessId: business.id);
    
    // Refresh all product-related data after sync
    result.fold(
      (failure) => null,
      (_) {
        ref.invalidate(productListNotifierProvider);
        ref.invalidate(categoryListNotifierProvider);
        ref.invalidate(brandListNotifierProvider);
      },
    );
    
    return result;
  }

  Future<Either<OfflineFirstException, void>> downloadProductsForBusiness() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) {
      return Left(
        ValidationException(
          'No business selected',
          'downloadProductsForBusiness',
          fieldName: 'businessId',
        ),
      );
    }

    final repository = await ref.read(productRepositoryFutureProvider.future);
    final result = await repository.downloadProductsForBusiness(businessId: business.id);
    
    // Refresh all product-related data after download
    result.fold(
      (failure) => null,
      (_) {
        ref.invalidate(productListNotifierProvider);
        ref.invalidate(categoryListNotifierProvider);
        ref.invalidate(brandListNotifierProvider);
      },
    );
    
    return result;
  }
}