// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productByIdHash() => r'78cf488866a56814797b2f323f8782399fb49dc9';

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

/// See also [productById].
@ProviderFor(productById)
const productByIdProvider = ProductByIdFamily();

/// See also [productById].
class ProductByIdFamily extends Family<AsyncValue<Product?>> {
  /// See also [productById].
  const ProductByIdFamily();

  /// See also [productById].
  ProductByIdProvider call(String productId) {
    return ProductByIdProvider(productId);
  }

  @override
  ProductByIdProvider getProviderOverride(
    covariant ProductByIdProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productByIdProvider';
}

/// See also [productById].
class ProductByIdProvider extends AutoDisposeFutureProvider<Product?> {
  /// See also [productById].
  ProductByIdProvider(String productId)
    : this._internal(
        (ref) => productById(ref as ProductByIdRef, productId),
        from: productByIdProvider,
        name: r'productByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productByIdHash,
        dependencies: ProductByIdFamily._dependencies,
        allTransitiveDependencies: ProductByIdFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<Product?> Function(ProductByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductByIdProvider._internal(
        (ref) => create(ref as ProductByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Product?> createElement() {
    return _ProductByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductByIdProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductByIdRef on AutoDisposeFutureProviderRef<Product?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductByIdProviderElement
    extends AutoDisposeFutureProviderElement<Product?>
    with ProductByIdRef {
  _ProductByIdProviderElement(super.provider);

  @override
  String get productId => (origin as ProductByIdProvider).productId;
}

String _$stockLevelsHash() => r'353d7ec38d50042c244a4541bdc14de53f423212';

/// See also [stockLevels].
@ProviderFor(stockLevels)
const stockLevelsProvider = StockLevelsFamily();

/// See also [stockLevels].
class StockLevelsFamily
    extends
        Family<AsyncValue<Either<OfflineFirstException, List<ProductStock>>>> {
  /// See also [stockLevels].
  const StockLevelsFamily();

  /// See also [stockLevels].
  StockLevelsProvider call(String locationId) {
    return StockLevelsProvider(locationId);
  }

  @override
  StockLevelsProvider getProviderOverride(
    covariant StockLevelsProvider provider,
  ) {
    return call(provider.locationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stockLevelsProvider';
}

/// See also [stockLevels].
class StockLevelsProvider
    extends
        AutoDisposeFutureProvider<
          Either<OfflineFirstException, List<ProductStock>>
        > {
  /// See also [stockLevels].
  StockLevelsProvider(String locationId)
    : this._internal(
        (ref) => stockLevels(ref as StockLevelsRef, locationId),
        from: stockLevelsProvider,
        name: r'stockLevelsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$stockLevelsHash,
        dependencies: StockLevelsFamily._dependencies,
        allTransitiveDependencies: StockLevelsFamily._allTransitiveDependencies,
        locationId: locationId,
      );

  StockLevelsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationId,
  }) : super.internal();

  final String locationId;

  @override
  Override overrideWith(
    FutureOr<Either<OfflineFirstException, List<ProductStock>>> Function(
      StockLevelsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StockLevelsProvider._internal(
        (ref) => create(ref as StockLevelsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationId: locationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    Either<OfflineFirstException, List<ProductStock>>
  >
  createElement() {
    return _StockLevelsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockLevelsProvider && other.locationId == locationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StockLevelsRef
    on
        AutoDisposeFutureProviderRef<
          Either<OfflineFirstException, List<ProductStock>>
        > {
  /// The parameter `locationId` of this provider.
  String get locationId;
}

class _StockLevelsProviderElement
    extends
        AutoDisposeFutureProviderElement<
          Either<OfflineFirstException, List<ProductStock>>
        >
    with StockLevelsRef {
  _StockLevelsProviderElement(super.provider);

  @override
  String get locationId => (origin as StockLevelsProvider).locationId;
}

String _$lowStockItemsHash() => r'cc79991c29fae297ef038ce15aefed9690d8a082';

/// See also [lowStockItems].
@ProviderFor(lowStockItems)
const lowStockItemsProvider = LowStockItemsFamily();

/// See also [lowStockItems].
class LowStockItemsFamily
    extends
        Family<AsyncValue<Either<OfflineFirstException, List<ProductStock>>>> {
  /// See also [lowStockItems].
  const LowStockItemsFamily();

  /// See also [lowStockItems].
  LowStockItemsProvider call(String locationId) {
    return LowStockItemsProvider(locationId);
  }

  @override
  LowStockItemsProvider getProviderOverride(
    covariant LowStockItemsProvider provider,
  ) {
    return call(provider.locationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lowStockItemsProvider';
}

/// See also [lowStockItems].
class LowStockItemsProvider
    extends
        AutoDisposeFutureProvider<
          Either<OfflineFirstException, List<ProductStock>>
        > {
  /// See also [lowStockItems].
  LowStockItemsProvider(String locationId)
    : this._internal(
        (ref) => lowStockItems(ref as LowStockItemsRef, locationId),
        from: lowStockItemsProvider,
        name: r'lowStockItemsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$lowStockItemsHash,
        dependencies: LowStockItemsFamily._dependencies,
        allTransitiveDependencies:
            LowStockItemsFamily._allTransitiveDependencies,
        locationId: locationId,
      );

  LowStockItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.locationId,
  }) : super.internal();

  final String locationId;

  @override
  Override overrideWith(
    FutureOr<Either<OfflineFirstException, List<ProductStock>>> Function(
      LowStockItemsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LowStockItemsProvider._internal(
        (ref) => create(ref as LowStockItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        locationId: locationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    Either<OfflineFirstException, List<ProductStock>>
  >
  createElement() {
    return _LowStockItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LowStockItemsProvider && other.locationId == locationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LowStockItemsRef
    on
        AutoDisposeFutureProviderRef<
          Either<OfflineFirstException, List<ProductStock>>
        > {
  /// The parameter `locationId` of this provider.
  String get locationId;
}

class _LowStockItemsProviderElement
    extends
        AutoDisposeFutureProviderElement<
          Either<OfflineFirstException, List<ProductStock>>
        >
    with LowStockItemsRef {
  _LowStockItemsProviderElement(super.provider);

  @override
  String get locationId => (origin as LowStockItemsProvider).locationId;
}

String _$productDetailHash() => r'd2cc8af39e56f28f2944b3b4b58d7e85a9e834e9';

/// See also [productDetail].
@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily();

/// See also [productDetail].
class ProductDetailFamily
    extends Family<AsyncValue<Either<OfflineFirstException, Product>>> {
  /// See also [productDetail].
  const ProductDetailFamily();

  /// See also [productDetail].
  ProductDetailProvider call(String productId) {
    return ProductDetailProvider(productId);
  }

  @override
  ProductDetailProvider getProviderOverride(
    covariant ProductDetailProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProvider';
}

/// See also [productDetail].
class ProductDetailProvider
    extends AutoDisposeFutureProvider<Either<OfflineFirstException, Product>> {
  /// See also [productDetail].
  ProductDetailProvider(String productId)
    : this._internal(
        (ref) => productDetail(ref as ProductDetailRef, productId),
        from: productDetailProvider,
        name: r'productDetailProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productDetailHash,
        dependencies: ProductDetailFamily._dependencies,
        allTransitiveDependencies:
            ProductDetailFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<Either<OfflineFirstException, Product>> Function(
      ProductDetailRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProvider._internal(
        (ref) => create(ref as ProductDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Either<OfflineFirstException, Product>>
  createElement() {
    return _ProductDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailRef
    on AutoDisposeFutureProviderRef<Either<OfflineFirstException, Product>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductDetailProviderElement
    extends
        AutoDisposeFutureProviderElement<Either<OfflineFirstException, Product>>
    with ProductDetailRef {
  _ProductDetailProviderElement(super.provider);

  @override
  String get productId => (origin as ProductDetailProvider).productId;
}

String _$productListNotifierHash() =>
    r'c84de60884e0ef29dfea628c5cfb28ff6807139a';

/// See also [ProductListNotifier].
@ProviderFor(ProductListNotifier)
final productListNotifierProvider =
    AutoDisposeNotifierProvider<ProductListNotifier, ProductListState>.internal(
      ProductListNotifier.new,
      name: r'productListNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$productListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProductListNotifier = AutoDisposeNotifier<ProductListState>;
String _$categoryListNotifierHash() =>
    r'0876a437693534e872a00da8b269bd716605667b';

/// See also [CategoryListNotifier].
@ProviderFor(CategoryListNotifier)
final categoryListNotifierProvider = AutoDisposeNotifierProvider<
  CategoryListNotifier,
  CategoryListState
>.internal(
  CategoryListNotifier.new,
  name: r'categoryListNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoryListNotifier = AutoDisposeNotifier<CategoryListState>;
String _$brandListNotifierHash() => r'b94fef7b9b0d361526c4c9a438580edee0d9de60';

/// See also [BrandListNotifier].
@ProviderFor(BrandListNotifier)
final brandListNotifierProvider =
    AutoDisposeNotifierProvider<BrandListNotifier, BrandListState>.internal(
      BrandListNotifier.new,
      name: r'brandListNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$brandListNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BrandListNotifier = AutoDisposeNotifier<BrandListState>;
String _$productSyncNotifierHash() =>
    r'4082362002d8cd7c836344f121f07b2b6bb9cdcc';

/// See also [ProductSyncNotifier].
@ProviderFor(ProductSyncNotifier)
final productSyncNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ProductSyncNotifier, void>.internal(
      ProductSyncNotifier.new,
      name: r'productSyncNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$productSyncNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProductSyncNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
