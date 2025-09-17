// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiter_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waiterOrderRepositoryHash() =>
    r'8f3c930a0790843ccf5e275ae81badd4c4051ced';

/// Provider for order repository
///
/// Copied from [waiterOrderRepository].
@ProviderFor(waiterOrderRepository)
final waiterOrderRepositoryProvider =
    AutoDisposeProvider<WaiterOrderRepository>.internal(
      waiterOrderRepository,
      name: r'waiterOrderRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$waiterOrderRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaiterOrderRepositoryRef =
    AutoDisposeProviderRef<WaiterOrderRepository>;
String _$waiterTableOrdersHash() => r'62e1aa56be44ee0245401582ab8b4e2c1dcc36cf';

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

/// Provider for fetching orders for a specific table
///
/// Copied from [waiterTableOrders].
@ProviderFor(waiterTableOrders)
const waiterTableOrdersProvider = WaiterTableOrdersFamily();

/// Provider for fetching orders for a specific table
///
/// Copied from [waiterTableOrders].
class WaiterTableOrdersFamily extends Family<AsyncValue<List<Order>>> {
  /// Provider for fetching orders for a specific table
  ///
  /// Copied from [waiterTableOrders].
  const WaiterTableOrdersFamily();

  /// Provider for fetching orders for a specific table
  ///
  /// Copied from [waiterTableOrders].
  WaiterTableOrdersProvider call(String tableId) {
    return WaiterTableOrdersProvider(tableId);
  }

  @override
  WaiterTableOrdersProvider getProviderOverride(
    covariant WaiterTableOrdersProvider provider,
  ) {
    return call(provider.tableId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'waiterTableOrdersProvider';
}

/// Provider for fetching orders for a specific table
///
/// Copied from [waiterTableOrders].
class WaiterTableOrdersProvider extends AutoDisposeFutureProvider<List<Order>> {
  /// Provider for fetching orders for a specific table
  ///
  /// Copied from [waiterTableOrders].
  WaiterTableOrdersProvider(String tableId)
    : this._internal(
        (ref) => waiterTableOrders(ref as WaiterTableOrdersRef, tableId),
        from: waiterTableOrdersProvider,
        name: r'waiterTableOrdersProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$waiterTableOrdersHash,
        dependencies: WaiterTableOrdersFamily._dependencies,
        allTransitiveDependencies:
            WaiterTableOrdersFamily._allTransitiveDependencies,
        tableId: tableId,
      );

  WaiterTableOrdersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tableId,
  }) : super.internal();

  final String tableId;

  @override
  Override overrideWith(
    FutureOr<List<Order>> Function(WaiterTableOrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WaiterTableOrdersProvider._internal(
        (ref) => create(ref as WaiterTableOrdersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tableId: tableId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Order>> createElement() {
    return _WaiterTableOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WaiterTableOrdersProvider && other.tableId == tableId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tableId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WaiterTableOrdersRef on AutoDisposeFutureProviderRef<List<Order>> {
  /// The parameter `tableId` of this provider.
  String get tableId;
}

class _WaiterTableOrdersProviderElement
    extends AutoDisposeFutureProviderElement<List<Order>>
    with WaiterTableOrdersRef {
  _WaiterTableOrdersProviderElement(super.provider);

  @override
  String get tableId => (origin as WaiterTableOrdersProvider).tableId;
}

String _$waiterActiveOrdersCountHash() =>
    r'26c8258d482d935be2b94ab85d7513949acc4e4c';

/// Provider for current active orders count
///
/// Copied from [waiterActiveOrdersCount].
@ProviderFor(waiterActiveOrdersCount)
final waiterActiveOrdersCountProvider = AutoDisposeFutureProvider<int>.internal(
  waiterActiveOrdersCount,
  name: r'waiterActiveOrdersCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$waiterActiveOrdersCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaiterActiveOrdersCountRef = AutoDisposeFutureProviderRef<int>;
String _$waiterOrderNotifierHash() =>
    r'ff18755378e7dc9fddfe5d9431a55da2eee71d2d';

/// Provider for creating orders from cart
///
/// Copied from [WaiterOrderNotifier].
@ProviderFor(WaiterOrderNotifier)
final waiterOrderNotifierProvider =
    AutoDisposeAsyncNotifierProvider<WaiterOrderNotifier, Order?>.internal(
      WaiterOrderNotifier.new,
      name: r'waiterOrderNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$waiterOrderNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WaiterOrderNotifier = AutoDisposeAsyncNotifier<Order?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
