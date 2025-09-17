// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiter_table_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waiterFloorsHash() => r'114dc4e40d65130ca6c17ad2b00c13f7fcb58989';

/// Provider for fetching floors and tables from Supabase for waiter app
///
/// Copied from [waiterFloors].
@ProviderFor(waiterFloors)
final waiterFloorsProvider = AutoDisposeFutureProvider<List<Floor>>.internal(
  waiterFloors,
  name: r'waiterFloorsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$waiterFloorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaiterFloorsRef = AutoDisposeFutureProviderRef<List<Floor>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
