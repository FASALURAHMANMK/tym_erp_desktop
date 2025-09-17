// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationServiceHash() => r'38d15292e1d1d4553c8f07a36b00411aa0a8d30e';

/// See also [locationService].
@ProviderFor(locationService)
final locationServiceProvider = AutoDisposeProvider<LocationService>.internal(
  locationService,
  name: r'locationServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$locationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationServiceRef = AutoDisposeProviderRef<LocationService>;
String _$posDeviceServiceHash() => r'ac07017c52183e97db0dd77263630dd6ee1ad87b';

/// See also [posDeviceService].
@ProviderFor(posDeviceService)
final posDeviceServiceProvider = AutoDisposeProvider<POSDeviceService>.internal(
  posDeviceService,
  name: r'posDeviceServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$posDeviceServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PosDeviceServiceRef = AutoDisposeProviderRef<POSDeviceService>;
String _$locationSyncServiceHash() =>
    r'75713422b183b1f7951c897df0569fba035a520c';

/// See also [locationSyncService].
@ProviderFor(locationSyncService)
final locationSyncServiceProvider =
    AutoDisposeProvider<LocationSyncService>.internal(
      locationSyncService,
      name: r'locationSyncServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$locationSyncServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationSyncServiceRef = AutoDisposeProviderRef<LocationSyncService>;
String _$businessPOSDevicesHash() =>
    r'a47fe08781a788706702b949037250d030958093';

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

/// See also [businessPOSDevices].
@ProviderFor(businessPOSDevices)
const businessPOSDevicesProvider = BusinessPOSDevicesFamily();

/// See also [businessPOSDevices].
class BusinessPOSDevicesFamily extends Family<AsyncValue<List<POSDevice>>> {
  /// See also [businessPOSDevices].
  const BusinessPOSDevicesFamily();

  /// See also [businessPOSDevices].
  BusinessPOSDevicesProvider call(String businessId) {
    return BusinessPOSDevicesProvider(businessId);
  }

  @override
  BusinessPOSDevicesProvider getProviderOverride(
    covariant BusinessPOSDevicesProvider provider,
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
  String? get name => r'businessPOSDevicesProvider';
}

/// See also [businessPOSDevices].
class BusinessPOSDevicesProvider
    extends AutoDisposeFutureProvider<List<POSDevice>> {
  /// See also [businessPOSDevices].
  BusinessPOSDevicesProvider(String businessId)
    : this._internal(
        (ref) => businessPOSDevices(ref as BusinessPOSDevicesRef, businessId),
        from: businessPOSDevicesProvider,
        name: r'businessPOSDevicesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$businessPOSDevicesHash,
        dependencies: BusinessPOSDevicesFamily._dependencies,
        allTransitiveDependencies:
            BusinessPOSDevicesFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  BusinessPOSDevicesProvider._internal(
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
    FutureOr<List<POSDevice>> Function(BusinessPOSDevicesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BusinessPOSDevicesProvider._internal(
        (ref) => create(ref as BusinessPOSDevicesRef),
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
  AutoDisposeFutureProviderElement<List<POSDevice>> createElement() {
    return _BusinessPOSDevicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessPOSDevicesProvider &&
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
mixin BusinessPOSDevicesRef on AutoDisposeFutureProviderRef<List<POSDevice>> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _BusinessPOSDevicesProviderElement
    extends AutoDisposeFutureProviderElement<List<POSDevice>>
    with BusinessPOSDevicesRef {
  _BusinessPOSDevicesProviderElement(super.provider);

  @override
  String get businessId => (origin as BusinessPOSDevicesProvider).businessId;
}

String _$locationSummaryHash() => r'407cfe753e09cef0f98eb6e84f989b32134046a4';

/// See also [locationSummary].
@ProviderFor(locationSummary)
const locationSummaryProvider = LocationSummaryFamily();

/// See also [locationSummary].
class LocationSummaryFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [locationSummary].
  const LocationSummaryFamily();

  /// See also [locationSummary].
  LocationSummaryProvider call(String businessId) {
    return LocationSummaryProvider(businessId);
  }

  @override
  LocationSummaryProvider getProviderOverride(
    covariant LocationSummaryProvider provider,
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
  String? get name => r'locationSummaryProvider';
}

/// See also [locationSummary].
class LocationSummaryProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [locationSummary].
  LocationSummaryProvider(String businessId)
    : this._internal(
        (ref) => locationSummary(ref as LocationSummaryRef, businessId),
        from: locationSummaryProvider,
        name: r'locationSummaryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$locationSummaryHash,
        dependencies: LocationSummaryFamily._dependencies,
        allTransitiveDependencies:
            LocationSummaryFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  LocationSummaryProvider._internal(
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
    FutureOr<Map<String, dynamic>> Function(LocationSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocationSummaryProvider._internal(
        (ref) => create(ref as LocationSummaryRef),
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
    return _LocationSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationSummaryProvider && other.businessId == businessId;
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
mixin LocationSummaryRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _LocationSummaryProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with LocationSummaryRef {
  _LocationSummaryProviderElement(super.provider);

  @override
  String get businessId => (origin as LocationSummaryProvider).businessId;
}

String _$currentERPContextHash() => r'341ba2d010e717e49e2a743874acda9c7a92ac60';

/// See also [currentERPContext].
@ProviderFor(currentERPContext)
final currentERPContextProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>?>.internal(
      currentERPContext,
      name: r'currentERPContextProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentERPContextHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentERPContextRef =
    AutoDisposeFutureProviderRef<Map<String, dynamic>?>;
String _$businessLocationsNotifierHash() =>
    r'6fa8e6835e254c54083973be011c7be8c8368694';

abstract class _$BusinessLocationsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<BusinessLocation>> {
  late final String businessId;

  FutureOr<List<BusinessLocation>> build(String businessId);
}

/// See also [BusinessLocationsNotifier].
@ProviderFor(BusinessLocationsNotifier)
const businessLocationsNotifierProvider = BusinessLocationsNotifierFamily();

/// See also [BusinessLocationsNotifier].
class BusinessLocationsNotifierFamily
    extends Family<AsyncValue<List<BusinessLocation>>> {
  /// See also [BusinessLocationsNotifier].
  const BusinessLocationsNotifierFamily();

  /// See also [BusinessLocationsNotifier].
  BusinessLocationsNotifierProvider call(String businessId) {
    return BusinessLocationsNotifierProvider(businessId);
  }

  @override
  BusinessLocationsNotifierProvider getProviderOverride(
    covariant BusinessLocationsNotifierProvider provider,
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
  String? get name => r'businessLocationsNotifierProvider';
}

/// See also [BusinessLocationsNotifier].
class BusinessLocationsNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BusinessLocationsNotifier,
          List<BusinessLocation>
        > {
  /// See also [BusinessLocationsNotifier].
  BusinessLocationsNotifierProvider(String businessId)
    : this._internal(
        () => BusinessLocationsNotifier()..businessId = businessId,
        from: businessLocationsNotifierProvider,
        name: r'businessLocationsNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$businessLocationsNotifierHash,
        dependencies: BusinessLocationsNotifierFamily._dependencies,
        allTransitiveDependencies:
            BusinessLocationsNotifierFamily._allTransitiveDependencies,
        businessId: businessId,
      );

  BusinessLocationsNotifierProvider._internal(
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
  FutureOr<List<BusinessLocation>> runNotifierBuild(
    covariant BusinessLocationsNotifier notifier,
  ) {
    return notifier.build(businessId);
  }

  @override
  Override overrideWith(BusinessLocationsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BusinessLocationsNotifierProvider._internal(
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
    BusinessLocationsNotifier,
    List<BusinessLocation>
  >
  createElement() {
    return _BusinessLocationsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BusinessLocationsNotifierProvider &&
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
mixin BusinessLocationsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<BusinessLocation>> {
  /// The parameter `businessId` of this provider.
  String get businessId;
}

class _BusinessLocationsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BusinessLocationsNotifier,
          List<BusinessLocation>
        >
    with BusinessLocationsNotifierRef {
  _BusinessLocationsNotifierProviderElement(super.provider);

  @override
  String get businessId =>
      (origin as BusinessLocationsNotifierProvider).businessId;
}

String _$selectedLocationNotifierHash() =>
    r'344e613fe671bc63ab00559ddfbf0ed4bd7a865a';

/// See also [SelectedLocationNotifier].
@ProviderFor(SelectedLocationNotifier)
final selectedLocationNotifierProvider = AutoDisposeAsyncNotifierProvider<
  SelectedLocationNotifier,
  BusinessLocation?
>.internal(
  SelectedLocationNotifier.new,
  name: r'selectedLocationNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedLocationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedLocationNotifier =
    AutoDisposeAsyncNotifier<BusinessLocation?>;
String _$locationPOSDevicesNotifierHash() =>
    r'dd6ebecd74b95e43ca3f0b87950c62122a061f00';

abstract class _$LocationPOSDevicesNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<POSDevice>> {
  late final String locationId;

  FutureOr<List<POSDevice>> build(String locationId);
}

/// See also [LocationPOSDevicesNotifier].
@ProviderFor(LocationPOSDevicesNotifier)
const locationPOSDevicesNotifierProvider = LocationPOSDevicesNotifierFamily();

/// See also [LocationPOSDevicesNotifier].
class LocationPOSDevicesNotifierFamily
    extends Family<AsyncValue<List<POSDevice>>> {
  /// See also [LocationPOSDevicesNotifier].
  const LocationPOSDevicesNotifierFamily();

  /// See also [LocationPOSDevicesNotifier].
  LocationPOSDevicesNotifierProvider call(String locationId) {
    return LocationPOSDevicesNotifierProvider(locationId);
  }

  @override
  LocationPOSDevicesNotifierProvider getProviderOverride(
    covariant LocationPOSDevicesNotifierProvider provider,
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
  String? get name => r'locationPOSDevicesNotifierProvider';
}

/// See also [LocationPOSDevicesNotifier].
class LocationPOSDevicesNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          LocationPOSDevicesNotifier,
          List<POSDevice>
        > {
  /// See also [LocationPOSDevicesNotifier].
  LocationPOSDevicesNotifierProvider(String locationId)
    : this._internal(
        () => LocationPOSDevicesNotifier()..locationId = locationId,
        from: locationPOSDevicesNotifierProvider,
        name: r'locationPOSDevicesNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$locationPOSDevicesNotifierHash,
        dependencies: LocationPOSDevicesNotifierFamily._dependencies,
        allTransitiveDependencies:
            LocationPOSDevicesNotifierFamily._allTransitiveDependencies,
        locationId: locationId,
      );

  LocationPOSDevicesNotifierProvider._internal(
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
  FutureOr<List<POSDevice>> runNotifierBuild(
    covariant LocationPOSDevicesNotifier notifier,
  ) {
    return notifier.build(locationId);
  }

  @override
  Override overrideWith(LocationPOSDevicesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: LocationPOSDevicesNotifierProvider._internal(
        () => create()..locationId = locationId,
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
  AutoDisposeAsyncNotifierProviderElement<
    LocationPOSDevicesNotifier,
    List<POSDevice>
  >
  createElement() {
    return _LocationPOSDevicesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationPOSDevicesNotifierProvider &&
        other.locationId == locationId;
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
mixin LocationPOSDevicesNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<POSDevice>> {
  /// The parameter `locationId` of this provider.
  String get locationId;
}

class _LocationPOSDevicesNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          LocationPOSDevicesNotifier,
          List<POSDevice>
        >
    with LocationPOSDevicesNotifierRef {
  _LocationPOSDevicesNotifierProviderElement(super.provider);

  @override
  String get locationId =>
      (origin as LocationPOSDevicesNotifierProvider).locationId;
}

String _$selectedPOSDeviceNotifierHash() =>
    r'c2024e32511262529439c2f5baf0f90a9baf33e3';

/// See also [SelectedPOSDeviceNotifier].
@ProviderFor(SelectedPOSDeviceNotifier)
final selectedPOSDeviceNotifierProvider = AutoDisposeAsyncNotifierProvider<
  SelectedPOSDeviceNotifier,
  POSDevice?
>.internal(
  SelectedPOSDeviceNotifier.new,
  name: r'selectedPOSDeviceNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedPOSDeviceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedPOSDeviceNotifier = AutoDisposeAsyncNotifier<POSDevice?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
