// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$discountRepositoryHash() =>
    r'e7048dba6cda7ba4824b62535c488b8da95a8e85';

/// See also [discountRepository].
@ProviderFor(discountRepository)
final discountRepositoryProvider =
    AutoDisposeFutureProvider<DiscountRepository>.internal(
      discountRepository,
      name: r'discountRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$discountRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiscountRepositoryRef =
    AutoDisposeFutureProviderRef<DiscountRepository>;
String _$applicableDiscountsHash() =>
    r'3fdc11f52d3452fce25ae8a8361b8fb916b751bb';

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

/// See also [applicableDiscounts].
@ProviderFor(applicableDiscounts)
const applicableDiscountsProvider = ApplicableDiscountsFamily();

/// See also [applicableDiscounts].
class ApplicableDiscountsFamily extends Family<AsyncValue<List<Discount>>> {
  /// See also [applicableDiscounts].
  const ApplicableDiscountsFamily();

  /// See also [applicableDiscounts].
  ApplicableDiscountsProvider call({
    required double cartTotal,
    List<String>? productIds,
    List<String>? categoryIds,
    String? customerId,
  }) {
    return ApplicableDiscountsProvider(
      cartTotal: cartTotal,
      productIds: productIds,
      categoryIds: categoryIds,
      customerId: customerId,
    );
  }

  @override
  ApplicableDiscountsProvider getProviderOverride(
    covariant ApplicableDiscountsProvider provider,
  ) {
    return call(
      cartTotal: provider.cartTotal,
      productIds: provider.productIds,
      categoryIds: provider.categoryIds,
      customerId: provider.customerId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'applicableDiscountsProvider';
}

/// See also [applicableDiscounts].
class ApplicableDiscountsProvider
    extends AutoDisposeFutureProvider<List<Discount>> {
  /// See also [applicableDiscounts].
  ApplicableDiscountsProvider({
    required double cartTotal,
    List<String>? productIds,
    List<String>? categoryIds,
    String? customerId,
  }) : this._internal(
         (ref) => applicableDiscounts(
           ref as ApplicableDiscountsRef,
           cartTotal: cartTotal,
           productIds: productIds,
           categoryIds: categoryIds,
           customerId: customerId,
         ),
         from: applicableDiscountsProvider,
         name: r'applicableDiscountsProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$applicableDiscountsHash,
         dependencies: ApplicableDiscountsFamily._dependencies,
         allTransitiveDependencies:
             ApplicableDiscountsFamily._allTransitiveDependencies,
         cartTotal: cartTotal,
         productIds: productIds,
         categoryIds: categoryIds,
         customerId: customerId,
       );

  ApplicableDiscountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cartTotal,
    required this.productIds,
    required this.categoryIds,
    required this.customerId,
  }) : super.internal();

  final double cartTotal;
  final List<String>? productIds;
  final List<String>? categoryIds;
  final String? customerId;

  @override
  Override overrideWith(
    FutureOr<List<Discount>> Function(ApplicableDiscountsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApplicableDiscountsProvider._internal(
        (ref) => create(ref as ApplicableDiscountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cartTotal: cartTotal,
        productIds: productIds,
        categoryIds: categoryIds,
        customerId: customerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Discount>> createElement() {
    return _ApplicableDiscountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicableDiscountsProvider &&
        other.cartTotal == cartTotal &&
        other.productIds == productIds &&
        other.categoryIds == categoryIds &&
        other.customerId == customerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cartTotal.hashCode);
    hash = _SystemHash.combine(hash, productIds.hashCode);
    hash = _SystemHash.combine(hash, categoryIds.hashCode);
    hash = _SystemHash.combine(hash, customerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ApplicableDiscountsRef on AutoDisposeFutureProviderRef<List<Discount>> {
  /// The parameter `cartTotal` of this provider.
  double get cartTotal;

  /// The parameter `productIds` of this provider.
  List<String>? get productIds;

  /// The parameter `categoryIds` of this provider.
  List<String>? get categoryIds;

  /// The parameter `customerId` of this provider.
  String? get customerId;
}

class _ApplicableDiscountsProviderElement
    extends AutoDisposeFutureProviderElement<List<Discount>>
    with ApplicableDiscountsRef {
  _ApplicableDiscountsProviderElement(super.provider);

  @override
  double get cartTotal => (origin as ApplicableDiscountsProvider).cartTotal;
  @override
  List<String>? get productIds =>
      (origin as ApplicableDiscountsProvider).productIds;
  @override
  List<String>? get categoryIds =>
      (origin as ApplicableDiscountsProvider).categoryIds;
  @override
  String? get customerId => (origin as ApplicableDiscountsProvider).customerId;
}

String _$validateCouponHash() => r'179154a0eb47b477f1ab06f01f10370f5a6f1036';

/// See also [validateCoupon].
@ProviderFor(validateCoupon)
const validateCouponProvider = ValidateCouponFamily();

/// See also [validateCoupon].
class ValidateCouponFamily extends Family<AsyncValue<Discount?>> {
  /// See also [validateCoupon].
  const ValidateCouponFamily();

  /// See also [validateCoupon].
  ValidateCouponProvider call({required String code, String? customerId}) {
    return ValidateCouponProvider(code: code, customerId: customerId);
  }

  @override
  ValidateCouponProvider getProviderOverride(
    covariant ValidateCouponProvider provider,
  ) {
    return call(code: provider.code, customerId: provider.customerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'validateCouponProvider';
}

/// See also [validateCoupon].
class ValidateCouponProvider extends AutoDisposeFutureProvider<Discount?> {
  /// See also [validateCoupon].
  ValidateCouponProvider({required String code, String? customerId})
    : this._internal(
        (ref) => validateCoupon(
          ref as ValidateCouponRef,
          code: code,
          customerId: customerId,
        ),
        from: validateCouponProvider,
        name: r'validateCouponProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$validateCouponHash,
        dependencies: ValidateCouponFamily._dependencies,
        allTransitiveDependencies:
            ValidateCouponFamily._allTransitiveDependencies,
        code: code,
        customerId: customerId,
      );

  ValidateCouponProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.code,
    required this.customerId,
  }) : super.internal();

  final String code;
  final String? customerId;

  @override
  Override overrideWith(
    FutureOr<Discount?> Function(ValidateCouponRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ValidateCouponProvider._internal(
        (ref) => create(ref as ValidateCouponRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        code: code,
        customerId: customerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Discount?> createElement() {
    return _ValidateCouponProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidateCouponProvider &&
        other.code == code &&
        other.customerId == customerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, code.hashCode);
    hash = _SystemHash.combine(hash, customerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ValidateCouponRef on AutoDisposeFutureProviderRef<Discount?> {
  /// The parameter `code` of this provider.
  String get code;

  /// The parameter `customerId` of this provider.
  String? get customerId;
}

class _ValidateCouponProviderElement
    extends AutoDisposeFutureProviderElement<Discount?>
    with ValidateCouponRef {
  _ValidateCouponProviderElement(super.provider);

  @override
  String get code => (origin as ValidateCouponProvider).code;
  @override
  String? get customerId => (origin as ValidateCouponProvider).customerId;
}

String _$calculateDiscountHash() => r'8e4c005ba03aab2fd125841849fb1bfd785bf4a9';

/// See also [calculateDiscount].
@ProviderFor(calculateDiscount)
const calculateDiscountProvider = CalculateDiscountFamily();

/// See also [calculateDiscount].
class CalculateDiscountFamily extends Family<double> {
  /// See also [calculateDiscount].
  const CalculateDiscountFamily();

  /// See also [calculateDiscount].
  CalculateDiscountProvider call({
    required Discount discount,
    required double baseAmount,
  }) {
    return CalculateDiscountProvider(
      discount: discount,
      baseAmount: baseAmount,
    );
  }

  @override
  CalculateDiscountProvider getProviderOverride(
    covariant CalculateDiscountProvider provider,
  ) {
    return call(discount: provider.discount, baseAmount: provider.baseAmount);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'calculateDiscountProvider';
}

/// See also [calculateDiscount].
class CalculateDiscountProvider extends AutoDisposeProvider<double> {
  /// See also [calculateDiscount].
  CalculateDiscountProvider({
    required Discount discount,
    required double baseAmount,
  }) : this._internal(
         (ref) => calculateDiscount(
           ref as CalculateDiscountRef,
           discount: discount,
           baseAmount: baseAmount,
         ),
         from: calculateDiscountProvider,
         name: r'calculateDiscountProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$calculateDiscountHash,
         dependencies: CalculateDiscountFamily._dependencies,
         allTransitiveDependencies:
             CalculateDiscountFamily._allTransitiveDependencies,
         discount: discount,
         baseAmount: baseAmount,
       );

  CalculateDiscountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.discount,
    required this.baseAmount,
  }) : super.internal();

  final Discount discount;
  final double baseAmount;

  @override
  Override overrideWith(double Function(CalculateDiscountRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: CalculateDiscountProvider._internal(
        (ref) => create(ref as CalculateDiscountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        discount: discount,
        baseAmount: baseAmount,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _CalculateDiscountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateDiscountProvider &&
        other.discount == discount &&
        other.baseAmount == baseAmount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, discount.hashCode);
    hash = _SystemHash.combine(hash, baseAmount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalculateDiscountRef on AutoDisposeProviderRef<double> {
  /// The parameter `discount` of this provider.
  Discount get discount;

  /// The parameter `baseAmount` of this provider.
  double get baseAmount;
}

class _CalculateDiscountProviderElement
    extends AutoDisposeProviderElement<double>
    with CalculateDiscountRef {
  _CalculateDiscountProviderElement(super.provider);

  @override
  Discount get discount => (origin as CalculateDiscountProvider).discount;
  @override
  double get baseAmount => (origin as CalculateDiscountProvider).baseAmount;
}

String _$activeDiscountsHash() => r'0afd59c8491924abc137a4d7fb2190c1e7cfa115';

/// See also [ActiveDiscounts].
@ProviderFor(ActiveDiscounts)
final activeDiscountsProvider =
    AutoDisposeAsyncNotifierProvider<ActiveDiscounts, List<Discount>>.internal(
      ActiveDiscounts.new,
      name: r'activeDiscountsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeDiscountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveDiscounts = AutoDisposeAsyncNotifier<List<Discount>>;
String _$discountUsageHash() => r'fd97517b54ccf847fa5f8c64b332ea16c88e2a89';

/// See also [DiscountUsage].
@ProviderFor(DiscountUsage)
final discountUsageProvider =
    AutoDisposeAsyncNotifierProvider<DiscountUsage, void>.internal(
      DiscountUsage.new,
      name: r'discountUsageProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$discountUsageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DiscountUsage = AutoDisposeAsyncNotifier<void>;
String _$autoApplyItemDiscountsHash() =>
    r'f062bc99681f28fdea22bd1fd0c83cca5dfedc9d';

/// See also [AutoApplyItemDiscounts].
@ProviderFor(AutoApplyItemDiscounts)
final autoApplyItemDiscountsProvider =
    AutoDisposeAsyncNotifierProvider<AutoApplyItemDiscounts, void>.internal(
      AutoApplyItemDiscounts.new,
      name: r'autoApplyItemDiscountsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$autoApplyItemDiscountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AutoApplyItemDiscounts = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
