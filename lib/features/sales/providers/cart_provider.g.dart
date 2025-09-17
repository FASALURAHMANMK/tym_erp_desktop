// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedLocationHash() => r'e29d1c1cc1d50cbe4c7bc0a97703de9e3a996fe8';

/// Helper provider for selected location
///
/// Copied from [selectedLocation].
@ProviderFor(selectedLocation)
final selectedLocationProvider =
    AutoDisposeProvider<BusinessLocation?>.internal(
      selectedLocation,
      name: r'selectedLocationProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedLocationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedLocationRef = AutoDisposeProviderRef<BusinessLocation?>;
String _$selectedPOSDeviceHash() => r'4673432d2ad645e6c3eecefce560d18f73a9d461';

/// Helper provider for selected POS device
///
/// Copied from [selectedPOSDevice].
@ProviderFor(selectedPOSDevice)
final selectedPOSDeviceProvider = AutoDisposeProvider<POSDevice?>.internal(
  selectedPOSDevice,
  name: r'selectedPOSDeviceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedPOSDeviceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedPOSDeviceRef = AutoDisposeProviderRef<POSDevice?>;
String _$cartItemCountHash() => r'e309c1ab5b9d198e19ba723f3451aa0830c6811a';

/// Provider for cart item count
///
/// Copied from [cartItemCount].
@ProviderFor(cartItemCount)
final cartItemCountProvider = AutoDisposeProvider<int>.internal(
  cartItemCount,
  name: r'cartItemCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cartItemCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartItemCountRef = AutoDisposeProviderRef<int>;
String _$cartTotalHash() => r'95599347e3abb5684967c74e2fc2d812b9901f44';

/// Provider for cart total
///
/// Copied from [cartTotal].
@ProviderFor(cartTotal)
final cartTotalProvider = AutoDisposeProvider<double>.internal(
  cartTotal,
  name: r'cartTotalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartTotalRef = AutoDisposeProviderRef<double>;
String _$cartTotalQuantityHash() => r'204167b13fce310ddce6b7de986ff81befe5bb86';

/// Provider for cart quantity
///
/// Copied from [cartTotalQuantity].
@ProviderFor(cartTotalQuantity)
final cartTotalQuantityProvider = AutoDisposeProvider<double>.internal(
  cartTotalQuantity,
  name: r'cartTotalQuantityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cartTotalQuantityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartTotalQuantityRef = AutoDisposeProviderRef<double>;
String _$cartNotifierHash() => r'405b1c1381c9ef11d073e21d8731bedbedd82f49';

/// Provider for the current active cart
/// Using keepAlive to preserve cart state across navigation
///
/// Copied from [CartNotifier].
@ProviderFor(CartNotifier)
final cartNotifierProvider = NotifierProvider<CartNotifier, Cart?>.internal(
  CartNotifier.new,
  name: r'cartNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CartNotifier = Notifier<Cart?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
