// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiter_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waiterProductCategoriesHash() =>
    r'e2b9b3bbbb936a1ef9b1edb651bcad76334ce8a5';

/// Fetch product categories from Supabase
///
/// Copied from [waiterProductCategories].
@ProviderFor(waiterProductCategories)
final waiterProductCategoriesProvider =
    AutoDisposeFutureProvider<List<ProductCategory>>.internal(
      waiterProductCategories,
      name: r'waiterProductCategoriesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$waiterProductCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaiterProductCategoriesRef =
    AutoDisposeFutureProviderRef<List<ProductCategory>>;
String _$waiterProductsByCategoryHash() =>
    r'23e1f9d2059f7f8dd099d6648d8ce5b3d454b973';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Fetch products by category from Supabase
///
/// Copied from [waiterProductsByCategory].
@ProviderFor(waiterProductsByCategory)
const waiterProductsByCategoryProvider = WaiterProductsByCategoryFamily();

/// Fetch products by category from Supabase
///
/// Copied from [waiterProductsByCategory].
class WaiterProductsByCategoryFamily extends Family<AsyncValue<List<Product>>> {
  /// Fetch products by category from Supabase
  ///
  /// Copied from [waiterProductsByCategory].
  const WaiterProductsByCategoryFamily();

  /// Fetch products by category from Supabase
  ///
  /// Copied from [waiterProductsByCategory].
  WaiterProductsByCategoryProvider call(String? categoryId) {
    return WaiterProductsByCategoryProvider(categoryId);
  }

  @override
  WaiterProductsByCategoryProvider getProviderOverride(
    covariant WaiterProductsByCategoryProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'waiterProductsByCategoryProvider';
}

/// Fetch products by category from Supabase
///
/// Copied from [waiterProductsByCategory].
class WaiterProductsByCategoryProvider
    extends AutoDisposeFutureProvider<List<Product>> {
  /// Fetch products by category from Supabase
  ///
  /// Copied from [waiterProductsByCategory].
  WaiterProductsByCategoryProvider(String? categoryId)
    : this._internal(
        (ref) => waiterProductsByCategory(
          ref as WaiterProductsByCategoryRef,
          categoryId,
        ),
        from: waiterProductsByCategoryProvider,
        name: r'waiterProductsByCategoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$waiterProductsByCategoryHash,
        dependencies: WaiterProductsByCategoryFamily._dependencies,
        allTransitiveDependencies:
            WaiterProductsByCategoryFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  WaiterProductsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String? categoryId;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(WaiterProductsByCategoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WaiterProductsByCategoryProvider._internal(
        (ref) => create(ref as WaiterProductsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _WaiterProductsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WaiterProductsByCategoryProvider &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WaiterProductsByCategoryRef
    on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _WaiterProductsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with WaiterProductsByCategoryRef {
  _WaiterProductsByCategoryProviderElement(super.provider);

  @override
  String? get categoryId =>
      (origin as WaiterProductsByCategoryProvider).categoryId;
}

String _$waiterProductSearchHash() =>
    r'8dfcf553de4b75b566408de7baab43065dea9a57';

/// Search products by name or SKU
///
/// Copied from [waiterProductSearch].
@ProviderFor(waiterProductSearch)
const waiterProductSearchProvider = WaiterProductSearchFamily();

/// Search products by name or SKU
///
/// Copied from [waiterProductSearch].
class WaiterProductSearchFamily extends Family<AsyncValue<List<Product>>> {
  /// Search products by name or SKU
  ///
  /// Copied from [waiterProductSearch].
  const WaiterProductSearchFamily();

  /// Search products by name or SKU
  ///
  /// Copied from [waiterProductSearch].
  WaiterProductSearchProvider call(String searchQuery) {
    return WaiterProductSearchProvider(searchQuery);
  }

  @override
  WaiterProductSearchProvider getProviderOverride(
    covariant WaiterProductSearchProvider provider,
  ) {
    return call(provider.searchQuery);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'waiterProductSearchProvider';
}

/// Search products by name or SKU
///
/// Copied from [waiterProductSearch].
class WaiterProductSearchProvider
    extends AutoDisposeFutureProvider<List<Product>> {
  /// Search products by name or SKU
  ///
  /// Copied from [waiterProductSearch].
  WaiterProductSearchProvider(String searchQuery)
    : this._internal(
        (ref) =>
            waiterProductSearch(ref as WaiterProductSearchRef, searchQuery),
        from: waiterProductSearchProvider,
        name: r'waiterProductSearchProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$waiterProductSearchHash,
        dependencies: WaiterProductSearchFamily._dependencies,
        allTransitiveDependencies:
            WaiterProductSearchFamily._allTransitiveDependencies,
        searchQuery: searchQuery,
      );

  WaiterProductSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(WaiterProductSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WaiterProductSearchProvider._internal(
        (ref) => create(ref as WaiterProductSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _WaiterProductSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WaiterProductSearchProvider &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WaiterProductSearchRef on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _WaiterProductSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with WaiterProductSearchRef {
  _WaiterProductSearchProviderElement(super.provider);

  @override
  String get searchQuery => (origin as WaiterProductSearchProvider).searchQuery;
}

String _$waiterVariationPricesHash() =>
    r'dd119950f97911f96a9843efe68151bb1e9ba21c';

/// Get variation prices for the dine-in price category
///
/// Copied from [waiterVariationPrices].
@ProviderFor(waiterVariationPrices)
final waiterVariationPricesProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
      waiterVariationPrices,
      name: r'waiterVariationPricesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$waiterVariationPricesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaiterVariationPricesRef =
    AutoDisposeFutureProviderRef<Map<String, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
