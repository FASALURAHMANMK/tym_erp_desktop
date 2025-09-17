// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taxRepositoryHash() => r'2a95180c4e49e2dba98131eed3a79b3b854d71a8';

/// See also [taxRepository].
@ProviderFor(taxRepository)
final taxRepositoryProvider = AutoDisposeFutureProvider<TaxRepository>.internal(
  taxRepository,
  name: r'taxRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taxRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaxRepositoryRef = AutoDisposeFutureProviderRef<TaxRepository>;
String _$productTaxHash() => r'087efd7d64cf914b8ad2ffdeb88e4d56cf19e64b';

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

/// See also [productTax].
@ProviderFor(productTax)
const productTaxProvider = ProductTaxFamily();

/// See also [productTax].
class ProductTaxFamily extends Family<AsyncValue<TaxGroup?>> {
  /// See also [productTax].
  const ProductTaxFamily();

  /// See also [productTax].
  ProductTaxProvider call(String productId) {
    return ProductTaxProvider(productId);
  }

  @override
  ProductTaxProvider getProviderOverride(
    covariant ProductTaxProvider provider,
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
  String? get name => r'productTaxProvider';
}

/// See also [productTax].
class ProductTaxProvider extends AutoDisposeFutureProvider<TaxGroup?> {
  /// See also [productTax].
  ProductTaxProvider(String productId)
    : this._internal(
        (ref) => productTax(ref as ProductTaxRef, productId),
        from: productTaxProvider,
        name: r'productTaxProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productTaxHash,
        dependencies: ProductTaxFamily._dependencies,
        allTransitiveDependencies: ProductTaxFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductTaxProvider._internal(
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
    FutureOr<TaxGroup?> Function(ProductTaxRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductTaxProvider._internal(
        (ref) => create(ref as ProductTaxRef),
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
  AutoDisposeFutureProviderElement<TaxGroup?> createElement() {
    return _ProductTaxProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductTaxProvider && other.productId == productId;
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
mixin ProductTaxRef on AutoDisposeFutureProviderRef<TaxGroup?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductTaxProviderElement
    extends AutoDisposeFutureProviderElement<TaxGroup?>
    with ProductTaxRef {
  _ProductTaxProviderElement(super.provider);

  @override
  String get productId => (origin as ProductTaxProvider).productId;
}

String _$defaultTaxGroupHash() => r'c8d0ee0e17bb59196ac328b089bdcd66e9c58057';

/// See also [defaultTaxGroup].
@ProviderFor(defaultTaxGroup)
final defaultTaxGroupProvider = AutoDisposeProvider<TaxGroup?>.internal(
  defaultTaxGroup,
  name: r'defaultTaxGroupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$defaultTaxGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefaultTaxGroupRef = AutoDisposeProviderRef<TaxGroup?>;
String _$calculateTaxHash() => r'85e19344c1dc124ec619ed93ced0ecfc1bd56df1';

/// See also [calculateTax].
@ProviderFor(calculateTax)
const calculateTaxProvider = CalculateTaxFamily();

/// See also [calculateTax].
class CalculateTaxFamily extends Family<double> {
  /// See also [calculateTax].
  const CalculateTaxFamily();

  /// See also [calculateTax].
  CalculateTaxProvider call({
    required double amount,
    required String? taxGroupId,
  }) {
    return CalculateTaxProvider(amount: amount, taxGroupId: taxGroupId);
  }

  @override
  CalculateTaxProvider getProviderOverride(
    covariant CalculateTaxProvider provider,
  ) {
    return call(amount: provider.amount, taxGroupId: provider.taxGroupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'calculateTaxProvider';
}

/// See also [calculateTax].
class CalculateTaxProvider extends AutoDisposeProvider<double> {
  /// See also [calculateTax].
  CalculateTaxProvider({required double amount, required String? taxGroupId})
    : this._internal(
        (ref) => calculateTax(
          ref as CalculateTaxRef,
          amount: amount,
          taxGroupId: taxGroupId,
        ),
        from: calculateTaxProvider,
        name: r'calculateTaxProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$calculateTaxHash,
        dependencies: CalculateTaxFamily._dependencies,
        allTransitiveDependencies:
            CalculateTaxFamily._allTransitiveDependencies,
        amount: amount,
        taxGroupId: taxGroupId,
      );

  CalculateTaxProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.amount,
    required this.taxGroupId,
  }) : super.internal();

  final double amount;
  final String? taxGroupId;

  @override
  Override overrideWith(double Function(CalculateTaxRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: CalculateTaxProvider._internal(
        (ref) => create(ref as CalculateTaxRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        amount: amount,
        taxGroupId: taxGroupId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _CalculateTaxProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateTaxProvider &&
        other.amount == amount &&
        other.taxGroupId == taxGroupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);
    hash = _SystemHash.combine(hash, taxGroupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalculateTaxRef on AutoDisposeProviderRef<double> {
  /// The parameter `amount` of this provider.
  double get amount;

  /// The parameter `taxGroupId` of this provider.
  String? get taxGroupId;
}

class _CalculateTaxProviderElement extends AutoDisposeProviderElement<double>
    with CalculateTaxRef {
  _CalculateTaxProviderElement(super.provider);

  @override
  double get amount => (origin as CalculateTaxProvider).amount;
  @override
  String? get taxGroupId => (origin as CalculateTaxProvider).taxGroupId;
}

String _$taxGroupsHash() => r'40c69896f5ff30f0ff8aa82507a6f654b06782d3';

/// See also [TaxGroups].
@ProviderFor(TaxGroups)
final taxGroupsProvider =
    AutoDisposeAsyncNotifierProvider<TaxGroups, List<TaxGroup>>.internal(
      TaxGroups.new,
      name: r'taxGroupsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$taxGroupsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaxGroups = AutoDisposeAsyncNotifier<List<TaxGroup>>;
String _$selectedTaxGroupHash() => r'1a9452a346f31a0a921ed29b57493af3ce63c87b';

/// See also [SelectedTaxGroup].
@ProviderFor(SelectedTaxGroup)
final selectedTaxGroupProvider =
    AutoDisposeNotifierProvider<SelectedTaxGroup, TaxGroup?>.internal(
      SelectedTaxGroup.new,
      name: r'selectedTaxGroupProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedTaxGroupHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedTaxGroup = AutoDisposeNotifier<TaxGroup?>;
String _$productTaxAssignmentHash() =>
    r'd32e270998530c9359ee744b0012e43a6a5f609b';

/// See also [ProductTaxAssignment].
@ProviderFor(ProductTaxAssignment)
final productTaxAssignmentProvider =
    AutoDisposeAsyncNotifierProvider<ProductTaxAssignment, void>.internal(
      ProductTaxAssignment.new,
      name: r'productTaxAssignmentProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$productTaxAssignmentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProductTaxAssignment = AutoDisposeAsyncNotifier<void>;
String _$categoryTaxAssignmentHash() =>
    r'bffcdc381b9a8030862f177a44afdf4e3820acce';

/// See also [CategoryTaxAssignment].
@ProviderFor(CategoryTaxAssignment)
final categoryTaxAssignmentProvider =
    AutoDisposeAsyncNotifierProvider<CategoryTaxAssignment, void>.internal(
      CategoryTaxAssignment.new,
      name: r'categoryTaxAssignmentProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$categoryTaxAssignmentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CategoryTaxAssignment = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
