// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiter_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waiterBusinessHash() => r'38d35001eed23b5ad1d60086a7393321e7ab5947';

/// Provider for waiter's business context
///
/// Copied from [waiterBusiness].
@ProviderFor(waiterBusiness)
final waiterBusinessProvider =
    AutoDisposeFutureProvider<BusinessModel?>.internal(
      waiterBusiness,
      name: r'waiterBusinessProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$waiterBusinessHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaiterBusinessRef = AutoDisposeFutureProviderRef<BusinessModel?>;
String _$waiterLocationNotifierHash() =>
    r'174cb605785053e1c139589cee16d8c0af2c900c';

/// Provider for waiter's assigned location
/// Fetches locations from Supabase cloud for the waiter app
///
/// Copied from [WaiterLocationNotifier].
@ProviderFor(WaiterLocationNotifier)
final waiterLocationNotifierProvider = AutoDisposeAsyncNotifierProvider<
  WaiterLocationNotifier,
  BusinessLocation?
>.internal(
  WaiterLocationNotifier.new,
  name: r'waiterLocationNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$waiterLocationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WaiterLocationNotifier = AutoDisposeAsyncNotifier<BusinessLocation?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
