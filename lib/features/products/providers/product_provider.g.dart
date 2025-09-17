// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productCategoriesHash() => r'87de68aecc6bc41b80b89654669ba5f6a18c388b';

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

/// See also [productCategories].
@ProviderFor(productCategories)
const productCategoriesProvider = ProductCategoriesFamily();

/// See also [productCategories].
class ProductCategoriesFamily
    extends Family<AsyncValue<List<ProductCategory>>> {
  /// See also [productCategories].
  const ProductCategoriesFamily();

  /// See also [productCategories].
  ProductCategoriesProvider call(String businessId) {
    return ProductCategoriesProvider(businessId);
  }

  @override
  ProductCategoriesProvider getProviderOverride(
    covariant ProductCategoriesProvider provider,
  ) {
    return call(provider.businessId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productCategoriesProvider';
}

/// See also [productCategories].
class ProductCategoriesProvider
    extends AutoDisposeFutureProvider<List<ProductCategory>> {
  /// See also [productCategories].
  ProductCategoriesProvider(String businessId)
    : this._internal(
        (ref) => productCategories(ref as ProductCategoriesRef, businessId),
        from: productCategoriesProvider,
        name: r'productCategoriesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productCategoriesHash,
        dependencies: ProductCategoriesFamily._dependencies,
        allTransitiveDependencies:
            ProductCategoriesFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  ProductCategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessId,
  }) : super.internal();

  final String businessId;

  @override
  Override overrideWith(
    FutureOr<List<ProductCategory>> Function(ProductCategoriesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductCategoriesProvider._internal(
        (ref) => create(ref as ProductCategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessId: businessId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductCategory>> createElement() {
    return _ProductCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductCategoriesProvider && other.businessId == businessId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductCategoriesRef
    on AutoDisposeFutureProviderRef<List<ProductCategory>> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _ProductCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductCategory>>
    with ProductCategoriesRef {
  _ProductCategoriesProviderElement(super.provider);

  @override
  String get businessId => (origin as ProductCategoriesProvider).businessId;
}

String _$currentBusinessProductsHash() =>
    r'1bcb3dacefcdd46e158644c27e3b3edc4e264736';

/// See also [currentBusinessProducts].
@ProviderFor(currentBusinessProducts)
final currentBusinessProductsProvider =
    AutoDisposeFutureProvider<List<Product>>.internal(
      currentBusinessProducts,
      name: r'currentBusinessProductsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentBusinessProductsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentBusinessProductsRef =
    AutoDisposeFutureProviderRef<List<Product>>;
String _$currentBusinessCategoriesHash() =>
    r'4cf2e1f1406cabeb6920a2aaa3d6831b87f6a334';

/// See also [currentBusinessCategories].
@ProviderFor(currentBusinessCategories)
final currentBusinessCategoriesProvider =
    AutoDisposeFutureProvider<List<ProductCategory>>.internal(
      currentBusinessCategories,
      name: r'currentBusinessCategoriesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentBusinessCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentBusinessCategoriesRef =
    AutoDisposeFutureProviderRef<List<ProductCategory>>;
String _$productsNotifierHash() => r'95cd18db29ccc896f22be7421d43285b9db7cea5';

abstract class _$ProductsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Product>> {
  late final String businessId;

  FutureOr<List<Product>> build(String businessId);
}

/// See also [ProductsNotifier].
@ProviderFor(ProductsNotifier)
const productsNotifierProvider = ProductsNotifierFamily();

/// See also [ProductsNotifier].
class ProductsNotifierFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [ProductsNotifier].
  const ProductsNotifierFamily();

  /// See also [ProductsNotifier].
  ProductsNotifierProvider call(String businessId) {
    return ProductsNotifierProvider(businessId);
  }

  @override
  ProductsNotifierProvider getProviderOverride(
    covariant ProductsNotifierProvider provider,
  ) {
    return call(provider.businessId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productsNotifierProvider';
}

/// See also [ProductsNotifier].
class ProductsNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<ProductsNotifier, List<Product>> {
  /// See also [ProductsNotifier].
  ProductsNotifierProvider(String businessId)
    : this._internal(
        () => ProductsNotifier()..businessId = businessId,
        from: productsNotifierProvider,
        name: r'productsNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productsNotifierHash,
        dependencies: ProductsNotifierFamily._dependencies,
        allTransitiveDependencies:
            ProductsNotifierFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  ProductsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.businessId,
  }) : super.internal();

  final String businessId;

  @override
  FutureOr<List<Product>> runNotifierBuild(
    covariant ProductsNotifier notifier,
  ) {
    return notifier.build(businessId);
  }

  @override
  Override overrideWith(ProductsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductsNotifierProvider._internal(
        () => create()..businessId = businessId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        businessId: businessId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProductsNotifier, List<Product>>
  createElement() {
    return _ProductsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsNotifierProvider && other.businessId == businessId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, businessId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Product>> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _ProductsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ProductsNotifier, List<Product>>
    with ProductsNotifierRef {
  _ProductsNotifierProviderElement(super.provider);

  @override
  String get businessId => (origin as ProductsNotifierProvider).businessId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
