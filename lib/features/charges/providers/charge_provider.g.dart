// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chargeRepositoryHash() => r'9f90186f825d02cd1c7d8d0845d28455e0282b4a';

/// See also [chargeRepository].
@ProviderFor(chargeRepository)
final chargeRepositoryProvider =
    AutoDisposeFutureProvider<ChargeRepository>.internal(
      chargeRepository,
      name: r'chargeRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$chargeRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChargeRepositoryRef = AutoDisposeFutureProviderRef<ChargeRepository>;
String _$activeChargesHash() => r'd7ac0ecdeb17a879bfee96dd17c4c878d46e9bea';

/// See also [activeCharges].
@ProviderFor(activeCharges)
final activeChargesProvider = AutoDisposeFutureProvider<List<Charge>>.internal(
  activeCharges,
  name: r'activeChargesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeChargesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveChargesRef = AutoDisposeFutureProviderRef<List<Charge>>;
String _$applicableChargesHash() => r'6e3671fe7a2f4a9d132fd2afbcee440bda6d5b93';

/// See also [applicableCharges].
@ProviderFor(applicableCharges)
final applicableChargesProvider =
    AutoDisposeFutureProvider<List<Charge>>.internal(
      applicableCharges,
      name: r'applicableChargesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$applicableChargesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApplicableChargesRef = AutoDisposeFutureProviderRef<List<Charge>>;
String _$totalChargesHash() => r'e5e8da30675ad33f6ae63dda1f2a2c0fe6000553';

/// See also [totalCharges].
@ProviderFor(totalCharges)
final totalChargesProvider = AutoDisposeProvider<double>.internal(
  totalCharges,
  name: r'totalChargesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalChargesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalChargesRef = AutoDisposeProviderRef<double>;
String _$taxableChargesHash() => r'346367aacf528554b889b5aa7d463cc46c2fbf88';

/// See also [taxableCharges].
@ProviderFor(taxableCharges)
final taxableChargesProvider = AutoDisposeProvider<double>.internal(
  taxableCharges,
  name: r'taxableChargesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taxableChargesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaxableChargesRef = AutoDisposeProviderRef<double>;
String _$chargesNotifierHash() => r'83d202419c14c183315d5ce35fe539d0d6dd43e3';

/// See also [ChargesNotifier].
@ProviderFor(ChargesNotifier)
final chargesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ChargesNotifier, List<Charge>>.internal(
      ChargesNotifier.new,
      name: r'chargesNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$chargesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChargesNotifier = AutoDisposeAsyncNotifier<List<Charge>>;
String _$autoApplyChargesHash() => r'0fdecf6feb6c93e9da44e856dc128586bd6c2990';

/// See also [AutoApplyCharges].
@ProviderFor(AutoApplyCharges)
final autoApplyChargesProvider = AutoDisposeAsyncNotifierProvider<
  AutoApplyCharges,
  List<AppliedCharge>
>.internal(
  AutoApplyCharges.new,
  name: r'autoApplyChargesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$autoApplyChargesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoApplyCharges = AutoDisposeAsyncNotifier<List<AppliedCharge>>;
String _$defaultChargesCreatorHash() =>
    r'b3dce4de43797070248a6431fd0c5a1bbf9633e2';

/// See also [DefaultChargesCreator].
@ProviderFor(DefaultChargesCreator)
final defaultChargesCreatorProvider =
    AutoDisposeAsyncNotifierProvider<DefaultChargesCreator, void>.internal(
      DefaultChargesCreator.new,
      name: r'defaultChargesCreatorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$defaultChargesCreatorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DefaultChargesCreator = AutoDisposeAsyncNotifier<void>;
String _$customerChargeExemptionsHash() =>
    r'8440f9d1a48321770759dff8fb1ca44b3b3ddddf';

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

abstract class _$CustomerChargeExemptions
    extends BuildlessAutoDisposeAsyncNotifier<List<CustomerChargeExemption>> {
  late final String customerId;

  FutureOr<List<CustomerChargeExemption>> build(String customerId);
}

/// See also [CustomerChargeExemptions].
@ProviderFor(CustomerChargeExemptions)
const customerChargeExemptionsProvider = CustomerChargeExemptionsFamily();

/// See also [CustomerChargeExemptions].
class CustomerChargeExemptionsFamily
    extends Family<AsyncValue<List<CustomerChargeExemption>>> {
  /// See also [CustomerChargeExemptions].
  const CustomerChargeExemptionsFamily();

  /// See also [CustomerChargeExemptions].
  CustomerChargeExemptionsProvider call(String customerId) {
    return CustomerChargeExemptionsProvider(customerId);
  }

  @override
  CustomerChargeExemptionsProvider getProviderOverride(
    covariant CustomerChargeExemptionsProvider provider,
  ) {
    return call(provider.customerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerChargeExemptionsProvider';
}

/// See also [CustomerChargeExemptions].
class CustomerChargeExemptionsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CustomerChargeExemptions,
          List<CustomerChargeExemption>
        > {
  /// See also [CustomerChargeExemptions].
  CustomerChargeExemptionsProvider(String customerId)
    : this._internal(
        () => CustomerChargeExemptions()..customerId = customerId,
        from: customerChargeExemptionsProvider,
        name: r'customerChargeExemptionsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$customerChargeExemptionsHash,
        dependencies: CustomerChargeExemptionsFamily._dependencies,
        allTransitiveDependencies:
            CustomerChargeExemptionsFamily._allTransitiveDependencies,
        customerId: customerId,
      );

  CustomerChargeExemptionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.customerId,
  }) : super.internal();

  final String customerId;

  @override
  FutureOr<List<CustomerChargeExemption>> runNotifierBuild(
    covariant CustomerChargeExemptions notifier,
  ) {
    return notifier.build(customerId);
  }

  @override
  Override overrideWith(CustomerChargeExemptions Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomerChargeExemptionsProvider._internal(
        () => create()..customerId = customerId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        customerId: customerId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    CustomerChargeExemptions,
    List<CustomerChargeExemption>
  >
  createElement() {
    return _CustomerChargeExemptionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerChargeExemptionsProvider &&
        other.customerId == customerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, customerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerChargeExemptionsRef
    on AutoDisposeAsyncNotifierProviderRef<List<CustomerChargeExemption>> {
  /// The parameter `customerId` of this provider.
  String get customerId;
}

class _CustomerChargeExemptionsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CustomerChargeExemptions,
          List<CustomerChargeExemption>
        >
    with CustomerChargeExemptionsRef {
  _CustomerChargeExemptionsProviderElement(super.provider);

  @override
  String get customerId =>
      (origin as CustomerChargeExemptionsProvider).customerId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
