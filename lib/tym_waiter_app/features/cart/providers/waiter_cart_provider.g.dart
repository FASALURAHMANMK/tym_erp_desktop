// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiter_cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waiterPriceCategoryIdHash() =>
    r'bbbd74f58f0a0b186f030be2e65e3cc93fb92f06';

/// Price category provider for waiter (dine-in by default)
///
/// Copied from [waiterPriceCategoryId].
@ProviderFor(waiterPriceCategoryId)
final waiterPriceCategoryIdProvider = AutoDisposeProvider<String>.internal(
  waiterPriceCategoryId,
  name: r'waiterPriceCategoryIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$waiterPriceCategoryIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaiterPriceCategoryIdRef = AutoDisposeProviderRef<String>;
String _$waiterCartNotifierHash() =>
    r'bf2a34c75a3266cc4efaecff05a67edf2a4a7bd0';

/// Waiter-specific cart provider
/// Maintains cart state per table session
///
/// Copied from [WaiterCartNotifier].
@ProviderFor(WaiterCartNotifier)
final waiterCartNotifierProvider =
    NotifierProvider<WaiterCartNotifier, Cart?>.internal(
      WaiterCartNotifier.new,
      name: r'waiterCartNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$waiterCartNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WaiterCartNotifier = Notifier<Cart?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
