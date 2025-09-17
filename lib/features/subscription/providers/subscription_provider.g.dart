// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionServiceHash() =>
    r'51fb58091d7babc315c400f9d2c3d7beebd82fc8';

/// See also [subscriptionService].
@ProviderFor(subscriptionService)
final subscriptionServiceProvider =
    AutoDisposeProvider<SubscriptionService>.internal(
      subscriptionService,
      name: r'subscriptionServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$subscriptionServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionServiceRef = AutoDisposeProviderRef<SubscriptionService>;
String _$canAccessERPHash() => r'6adee28d556dc3b70dd38d7c50ca3a0ea409a74b';

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

/// See also [canAccessERP].
@ProviderFor(canAccessERP)
const canAccessERPProvider = CanAccessERPFamily();

/// See also [canAccessERP].
class CanAccessERPFamily extends Family<AsyncValue<bool>> {
  /// See also [canAccessERP].
  const CanAccessERPFamily();

  /// See also [canAccessERP].
  CanAccessERPProvider call(String businessId) {
    return CanAccessERPProvider(businessId);
  }

  @override
  CanAccessERPProvider getProviderOverride(
    covariant CanAccessERPProvider provider,
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
  String? get name => r'canAccessERPProvider';
}

/// See also [canAccessERP].
class CanAccessERPProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [canAccessERP].
  CanAccessERPProvider(String businessId)
    : this._internal(
        (ref) => canAccessERP(ref as CanAccessERPRef, businessId),
        from: canAccessERPProvider,
        name: r'canAccessERPProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$canAccessERPHash,
        dependencies: CanAccessERPFamily._dependencies,
        allTransitiveDependencies:
            CanAccessERPFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  CanAccessERPProvider._internal(
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
    FutureOr<bool> Function(CanAccessERPRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanAccessERPProvider._internal(
        (ref) => create(ref as CanAccessERPRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CanAccessERPProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanAccessERPProvider && other.businessId == businessId;
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
mixin CanAccessERPRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _CanAccessERPProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CanAccessERPRef {
  _CanAccessERPProviderElement(super.provider);

  @override
  String get businessId => (origin as CanAccessERPProvider).businessId;
}

String _$subscriptionSummaryHash() =>
    r'7cd7370287577f123bb9711e981c35c168c8b717';

/// See also [subscriptionSummary].
@ProviderFor(subscriptionSummary)
const subscriptionSummaryProvider = SubscriptionSummaryFamily();

/// See also [subscriptionSummary].
class SubscriptionSummaryFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [subscriptionSummary].
  const SubscriptionSummaryFamily();

  /// See also [subscriptionSummary].
  SubscriptionSummaryProvider call(String businessId) {
    return SubscriptionSummaryProvider(businessId);
  }

  @override
  SubscriptionSummaryProvider getProviderOverride(
    covariant SubscriptionSummaryProvider provider,
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
  String? get name => r'subscriptionSummaryProvider';
}

/// See also [subscriptionSummary].
class SubscriptionSummaryProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [subscriptionSummary].
  SubscriptionSummaryProvider(String businessId)
    : this._internal(
        (ref) => subscriptionSummary(ref as SubscriptionSummaryRef, businessId),
        from: subscriptionSummaryProvider,
        name: r'subscriptionSummaryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$subscriptionSummaryHash,
        dependencies: SubscriptionSummaryFamily._dependencies,
        allTransitiveDependencies:
            SubscriptionSummaryFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  SubscriptionSummaryProvider._internal(
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
    FutureOr<Map<String, dynamic>> Function(SubscriptionSummaryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubscriptionSummaryProvider._internal(
        (ref) => create(ref as SubscriptionSummaryRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _SubscriptionSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubscriptionSummaryProvider &&
        other.businessId == businessId;
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
mixin SubscriptionSummaryRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _SubscriptionSummaryProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with SubscriptionSummaryRef {
  _SubscriptionSummaryProviderElement(super.provider);

  @override
  String get businessId => (origin as SubscriptionSummaryProvider).businessId;
}

String _$revenueReportHash() => r'b1ef18e39d7e26a352381046ee5a14a0626035aa';

/// See also [revenueReport].
@ProviderFor(revenueReport)
const revenueReportProvider = RevenueReportFamily();

/// See also [revenueReport].
class RevenueReportFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [revenueReport].
  const RevenueReportFamily();

  /// See also [revenueReport].
  RevenueReportProvider call({DateTime? startDate, DateTime? endDate}) {
    return RevenueReportProvider(startDate: startDate, endDate: endDate);
  }

  @override
  RevenueReportProvider getProviderOverride(
    covariant RevenueReportProvider provider,
  ) {
    return call(startDate: provider.startDate, endDate: provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'revenueReportProvider';
}

/// See also [revenueReport].
class RevenueReportProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [revenueReport].
  RevenueReportProvider({DateTime? startDate, DateTime? endDate})
    : this._internal(
        (ref) => revenueReport(
          ref as RevenueReportRef,
          startDate: startDate,
          endDate: endDate,
        ),
        from: revenueReportProvider,
        name: r'revenueReportProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$revenueReportHash,
        dependencies: RevenueReportFamily._dependencies,
        allTransitiveDependencies:
            RevenueReportFamily._allTransitiveDependencies,
        startDate: startDate,
        endDate: endDate,
      );

  RevenueReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(RevenueReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RevenueReportProvider._internal(
        (ref) => create(ref as RevenueReportRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _RevenueReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RevenueReportProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RevenueReportRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _RevenueReportProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with RevenueReportRef {
  _RevenueReportProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as RevenueReportProvider).startDate;
  @override
  DateTime? get endDate => (origin as RevenueReportProvider).endDate;
}

String _$subscriptionNotifierHash() =>
    r'92f366a21f9ca04932582199df9130d41010d50b';

/// See also [SubscriptionNotifier].
@ProviderFor(SubscriptionNotifier)
final subscriptionNotifierProvider = AutoDisposeAsyncNotifierProvider<
  SubscriptionNotifier,
  List<SubscriptionPlan>
>.internal(
  SubscriptionNotifier.new,
  name: r'subscriptionNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subscriptionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionNotifier =
    AutoDisposeAsyncNotifier<List<SubscriptionPlan>>;
String _$businessSubscriptionNotifierHash() =>
    r'41035063a8ed37a1b75c3639757185cbfe5cf5ec';

abstract class _$BusinessSubscriptionNotifier
    extends BuildlessAutoDisposeAsyncNotifier<BusinessSubscription?> {
  late final String businessId;

  FutureOr<BusinessSubscription?> build(String businessId);
}

/// See also [BusinessSubscriptionNotifier].
@ProviderFor(BusinessSubscriptionNotifier)
const businessSubscriptionNotifierProvider =
    BusinessSubscriptionNotifierFamily();

/// See also [BusinessSubscriptionNotifier].
class BusinessSubscriptionNotifierFamily
    extends Family<AsyncValue<BusinessSubscription?>> {
  /// See also [BusinessSubscriptionNotifier].
  const BusinessSubscriptionNotifierFamily();

  /// See also [BusinessSubscriptionNotifier].
  BusinessSubscriptionNotifierProvider call(String businessId) {
    return BusinessSubscriptionNotifierProvider(businessId);
  }

  @override
  BusinessSubscriptionNotifierProvider getProviderOverride(
    covariant BusinessSubscriptionNotifierProvider provider,
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
  String? get name => r'businessSubscriptionNotifierProvider';
}

/// See also [BusinessSubscriptionNotifier].
class BusinessSubscriptionNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BusinessSubscriptionNotifier,
          BusinessSubscription?
        > {
  /// See also [BusinessSubscriptionNotifier].
  BusinessSubscriptionNotifierProvider(String businessId)
    : this._internal(
        () => BusinessSubscriptionNotifier()..businessId = businessId,
        from: businessSubscriptionNotifierProvider,
        name: r'businessSubscriptionNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$businessSubscriptionNotifierHash,
        dependencies: BusinessSubscriptionNotifierFamily._dependencies,
        allTransitiveDependencies:
            BusinessSubscriptionNotifierFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  BusinessSubscriptionNotifierProvider._internal(
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
  FutureOr<BusinessSubscription?> runNotifierBuild(
    covariant BusinessSubscriptionNotifier notifier,
  ) {
    return notifier.build(businessId);
  }

  @override
  Override overrideWith(BusinessSubscriptionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BusinessSubscriptionNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    BusinessSubscriptionNotifier,
    BusinessSubscription?
  >
  createElement() {
    return _BusinessSubscriptionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessSubscriptionNotifierProvider &&
        other.businessId == businessId;
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
mixin BusinessSubscriptionNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<BusinessSubscription?> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _BusinessSubscriptionNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BusinessSubscriptionNotifier,
          BusinessSubscription?
        >
    with BusinessSubscriptionNotifierRef {
  _BusinessSubscriptionNotifierProviderElement(super.provider);

  @override
  String get businessId =>
      (origin as BusinessSubscriptionNotifierProvider).businessId;
}

String _$paymentHistoryNotifierHash() =>
    r'ac32e843f12c0f1f17a210ed5eb89a1b2042df70';

abstract class _$PaymentHistoryNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<SubscriptionPayment>> {
  late final String subscriptionId;

  FutureOr<List<SubscriptionPayment>> build(String subscriptionId);
}

/// See also [PaymentHistoryNotifier].
@ProviderFor(PaymentHistoryNotifier)
const paymentHistoryNotifierProvider = PaymentHistoryNotifierFamily();

/// See also [PaymentHistoryNotifier].
class PaymentHistoryNotifierFamily
    extends Family<AsyncValue<List<SubscriptionPayment>>> {
  /// See also [PaymentHistoryNotifier].
  const PaymentHistoryNotifierFamily();

  /// See also [PaymentHistoryNotifier].
  PaymentHistoryNotifierProvider call(String subscriptionId) {
    return PaymentHistoryNotifierProvider(subscriptionId);
  }

  @override
  PaymentHistoryNotifierProvider getProviderOverride(
    covariant PaymentHistoryNotifierProvider provider,
  ) {
    return call(provider.subscriptionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paymentHistoryNotifierProvider';
}

/// See also [PaymentHistoryNotifier].
class PaymentHistoryNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PaymentHistoryNotifier,
          List<SubscriptionPayment>
        > {
  /// See also [PaymentHistoryNotifier].
  PaymentHistoryNotifierProvider(String subscriptionId)
    : this._internal(
        () => PaymentHistoryNotifier()..subscriptionId = subscriptionId,
        from: paymentHistoryNotifierProvider,
        name: r'paymentHistoryNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$paymentHistoryNotifierHash,
        dependencies: PaymentHistoryNotifierFamily._dependencies,
        allTransitiveDependencies:
            PaymentHistoryNotifierFamily._allTransitiveDependencies,
        subscriptionId: subscriptionId,
      );

  PaymentHistoryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subscriptionId,
  }) : super.internal();

  final String subscriptionId;

  @override
  FutureOr<List<SubscriptionPayment>> runNotifierBuild(
    covariant PaymentHistoryNotifier notifier,
  ) {
    return notifier.build(subscriptionId);
  }

  @override
  Override overrideWith(PaymentHistoryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PaymentHistoryNotifierProvider._internal(
        () => create()..subscriptionId = subscriptionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subscriptionId: subscriptionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    PaymentHistoryNotifier,
    List<SubscriptionPayment>
  >
  createElement() {
    return _PaymentHistoryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentHistoryNotifierProvider &&
        other.subscriptionId == subscriptionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subscriptionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaymentHistoryNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<SubscriptionPayment>> {
  /// The parameter `subscriptionId` of this provider.
  String get subscriptionId;
}

class _PaymentHistoryNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PaymentHistoryNotifier,
          List<SubscriptionPayment>
        >
    with PaymentHistoryNotifierRef {
  _PaymentHistoryNotifierProviderElement(super.provider);

  @override
  String get subscriptionId =>
      (origin as PaymentHistoryNotifierProvider).subscriptionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
