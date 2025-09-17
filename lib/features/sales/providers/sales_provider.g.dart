// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$completedOrdersHash() => r'd45f0ed607f9875dbf639da69cd489f57cb27138';

/// Provider for completed orders (sales)
///
/// Copied from [completedOrders].
@ProviderFor(completedOrders)
final completedOrdersProvider = AutoDisposeFutureProvider<List<Order>>.internal(
  completedOrders,
  name: r'completedOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completedOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedOrdersRef = AutoDisposeFutureProviderRef<List<Order>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
