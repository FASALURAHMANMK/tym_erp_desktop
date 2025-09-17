// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentMethodRepositoryHash() =>
    r'fb6819998c7466c442cd63fcec24ecfc40a43b84';

/// See also [paymentMethodRepository].
@ProviderFor(paymentMethodRepository)
final paymentMethodRepositoryProvider =
    AutoDisposeFutureProvider<PaymentMethodRepository>.internal(
      paymentMethodRepository,
      name: r'paymentMethodRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$paymentMethodRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentMethodRepositoryRef =
    AutoDisposeFutureProviderRef<PaymentMethodRepository>;
String _$activePaymentMethodsHash() =>
    r'2011c7a0f2b92943fecc8af30e03e027d3dfab2b';

/// See also [activePaymentMethods].
@ProviderFor(activePaymentMethods)
final activePaymentMethodsProvider =
    AutoDisposeFutureProvider<List<PaymentMethod>>.internal(
      activePaymentMethods,
      name: r'activePaymentMethodsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activePaymentMethodsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivePaymentMethodsRef =
    AutoDisposeFutureProviderRef<List<PaymentMethod>>;
String _$paymentMethodsHash() => r'7e413f42f46e45e105b65277ed1cdd3e8f85dc44';

/// See also [PaymentMethods].
@ProviderFor(PaymentMethods)
final paymentMethodsProvider = AutoDisposeAsyncNotifierProvider<
  PaymentMethods,
  List<PaymentMethod>
>.internal(
  PaymentMethods.new,
  name: r'paymentMethodsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentMethodsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentMethods = AutoDisposeAsyncNotifier<List<PaymentMethod>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
