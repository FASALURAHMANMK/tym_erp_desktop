// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTablesHash() => r'3c93844b2ab812f9e0f5481540537bb353217d54';

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

/// See also [allTables].
@ProviderFor(allTables)
const allTablesProvider = AllTablesFamily();

/// See also [allTables].
class AllTablesFamily extends Family<AsyncValue<List<RestaurantTable>>> {
  /// See also [allTables].
  const AllTablesFamily();

  /// See also [allTables].
  AllTablesProvider call((String, String) params) {
    return AllTablesProvider(params);
  }

  @override
  AllTablesProvider getProviderOverride(covariant AllTablesProvider provider) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allTablesProvider';
}

/// See also [allTables].
class AllTablesProvider
    extends AutoDisposeFutureProvider<List<RestaurantTable>> {
  /// See also [allTables].
  AllTablesProvider((String, String) params)
    : this._internal(
        (ref) => allTables(ref as AllTablesRef, params),
        from: allTablesProvider,
        name: r'allTablesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$allTablesHash,
        dependencies: AllTablesFamily._dependencies,
        allTransitiveDependencies: AllTablesFamily._allTransitiveDependencies,
        params: params,
      );

  AllTablesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final (String, String) params;

  @override
  Override overrideWith(
    FutureOr<List<RestaurantTable>> Function(AllTablesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllTablesProvider._internal(
        (ref) => create(ref as AllTablesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RestaurantTable>> createElement() {
    return _AllTablesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllTablesProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllTablesRef on AutoDisposeFutureProviderRef<List<RestaurantTable>> {
  /// The parameter `params` of this provider.
  (String, String) get params;
}

class _AllTablesProviderElement
    extends AutoDisposeFutureProviderElement<List<RestaurantTable>>
    with AllTablesRef {
  _AllTablesProviderElement(super.provider);

  @override
  (String, String) get params => (origin as AllTablesProvider).params;
}

String _$freeTablesHash() => r'3df39eacedd05d39eba4dda0414bb32b8af91b63';

/// See also [freeTables].
@ProviderFor(freeTables)
const freeTablesProvider = FreeTablesFamily();

/// See also [freeTables].
class FreeTablesFamily extends Family<AsyncValue<List<RestaurantTable>>> {
  /// See also [freeTables].
  const FreeTablesFamily();

  /// See also [freeTables].
  FreeTablesProvider call((String, String) params) {
    return FreeTablesProvider(params);
  }

  @override
  FreeTablesProvider getProviderOverride(
    covariant FreeTablesProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'freeTablesProvider';
}

/// See also [freeTables].
class FreeTablesProvider
    extends AutoDisposeFutureProvider<List<RestaurantTable>> {
  /// See also [freeTables].
  FreeTablesProvider((String, String) params)
    : this._internal(
        (ref) => freeTables(ref as FreeTablesRef, params),
        from: freeTablesProvider,
        name: r'freeTablesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$freeTablesHash,
        dependencies: FreeTablesFamily._dependencies,
        allTransitiveDependencies: FreeTablesFamily._allTransitiveDependencies,
        params: params,
      );

  FreeTablesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final (String, String) params;

  @override
  Override overrideWith(
    FutureOr<List<RestaurantTable>> Function(FreeTablesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FreeTablesProvider._internal(
        (ref) => create(ref as FreeTablesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RestaurantTable>> createElement() {
    return _FreeTablesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FreeTablesProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FreeTablesRef on AutoDisposeFutureProviderRef<List<RestaurantTable>> {
  /// The parameter `params` of this provider.
  (String, String) get params;
}

class _FreeTablesProviderElement
    extends AutoDisposeFutureProviderElement<List<RestaurantTable>>
    with FreeTablesRef {
  _FreeTablesProviderElement(super.provider);

  @override
  (String, String) get params => (origin as FreeTablesProvider).params;
}

String _$floorsHash() => r'54be4f0dbdc0642f686104ab03d6c74017b16f88';

abstract class _$Floors extends BuildlessAutoDisposeAsyncNotifier<List<Floor>> {
  late final (String, String) params;

  FutureOr<List<Floor>> build((String, String) params);
}

/// See also [Floors].
@ProviderFor(Floors)
const floorsProvider = FloorsFamily();

/// See also [Floors].
class FloorsFamily extends Family<AsyncValue<List<Floor>>> {
  /// See also [Floors].
  const FloorsFamily();

  /// See also [Floors].
  FloorsProvider call((String, String) params) {
    return FloorsProvider(params);
  }

  @override
  FloorsProvider getProviderOverride(covariant FloorsProvider provider) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'floorsProvider';
}

/// See also [Floors].
class FloorsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Floors, List<Floor>> {
  /// See also [Floors].
  FloorsProvider((String, String) params)
    : this._internal(
        () => Floors()..params = params,
        from: floorsProvider,
        name: r'floorsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$floorsHash,
        dependencies: FloorsFamily._dependencies,
        allTransitiveDependencies: FloorsFamily._allTransitiveDependencies,
        params: params,
      );

  FloorsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final (String, String) params;

  @override
  FutureOr<List<Floor>> runNotifierBuild(covariant Floors notifier) {
    return notifier.build(params);
  }

  @override
  Override overrideWith(Floors Function() create) {
    return ProviderOverride(
      origin: this,
      override: FloorsProvider._internal(
        () => create()..params = params,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Floors, List<Floor>> createElement() {
    return _FloorsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FloorsProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FloorsRef on AutoDisposeAsyncNotifierProviderRef<List<Floor>> {
  /// The parameter `params` of this provider.
  (String, String) get params;
}

class _FloorsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Floors, List<Floor>>
    with FloorsRef {
  _FloorsProviderElement(super.provider);

  @override
  (String, String) get params => (origin as FloorsProvider).params;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
