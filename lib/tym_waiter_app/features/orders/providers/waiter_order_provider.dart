import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/orders/models/order.dart';
import '../../../../features/orders/models/order_status.dart';
import '../../../../features/sales/models/cart.dart';
import '../../auth/providers/waiter_auth_provider.dart';
import '../../cart/providers/waiter_cart_provider.dart';
import '../repositories/waiter_order_repository.dart';

part 'waiter_order_provider.g.dart';

/// Provider for order repository
@riverpod
WaiterOrderRepository waiterOrderRepository(Ref ref) {
  return WaiterOrderRepository();
}

/// Provider for creating orders from cart
@riverpod
class WaiterOrderNotifier extends _$WaiterOrderNotifier {
  static final _logger = Logger('WaiterOrderNotifier');

  @override
  Future<Order?> build() async {
    return null;
  }

  /// Save order as draft
  Future<Order> saveOrder({String? kitchenNotes}) async {
    try {
      _logger.info('Saving order as draft');
      
      final cart = ref.read(waiterCartNotifierProvider);
      if (cart == null || cart.items.isEmpty) {
        throw Exception('Cart is empty');
      }

      final waiter = ref.read(currentWaiterProvider);
      if (waiter == null) {
        throw Exception('No waiter logged in');
      }

      final repository = ref.read(waiterOrderRepositoryProvider);
      
      state = const AsyncValue.loading();
      
      final order = await repository.createOrder(
        cart: cart,
        initialStatus: OrderStatus.draft,
        waiterId: waiter.id,
        waiterName: waiter.displayName,
        kitchenNotes: kitchenNotes,
      );

      state = AsyncValue.data(order);
      
      // Clear cart after successful order creation
      ref.read(waiterCartNotifierProvider.notifier).clearCart();
      
      _logger.info('Order saved as draft: ${order.orderNumber}');
      return order;
    } catch (e, stack) {
      _logger.error('Error saving order', e, stack);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Send order to kitchen (KOT)
  Future<Order> sendKOT({String? kitchenNotes}) async {
    try {
      _logger.info('Sending order to kitchen (KOT)');
      
      final cart = ref.read(waiterCartNotifierProvider);
      if (cart == null || cart.items.isEmpty) {
        throw Exception('Cart is empty');
      }

      final waiter = ref.read(currentWaiterProvider);
      if (waiter == null) {
        throw Exception('No waiter logged in');
      }

      final repository = ref.read(waiterOrderRepositoryProvider);
      
      state = const AsyncValue.loading();
      
      final order = await repository.createOrder(
        cart: cart,
        initialStatus: OrderStatus.confirmed,
        waiterId: waiter.id,
        waiterName: waiter.displayName,
        kitchenNotes: kitchenNotes,
      );

      state = AsyncValue.data(order);
      
      // Clear cart after successful order creation
      ref.read(waiterCartNotifierProvider.notifier).clearCart();
      
      _logger.info('KOT sent for order: ${order.orderNumber}');
      return order;
    } catch (e, stack) {
      _logger.error('Error sending KOT', e, stack);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Generate bill for order
  Future<Order> generateBill({String? kitchenNotes}) async {
    try {
      _logger.info('Generating bill');
      
      final cart = ref.read(waiterCartNotifierProvider);
      if (cart == null || cart.items.isEmpty) {
        throw Exception('Cart is empty');
      }

      final waiter = ref.read(currentWaiterProvider);
      if (waiter == null) {
        throw Exception('No waiter logged in');
      }

      final repository = ref.read(waiterOrderRepositoryProvider);
      
      state = const AsyncValue.loading();
      
      final order = await repository.createOrder(
        cart: cart,
        initialStatus: OrderStatus.served,
        waiterId: waiter.id,
        waiterName: waiter.displayName,
        kitchenNotes: kitchenNotes,
      );

      state = AsyncValue.data(order);
      
      // Clear cart after successful order creation
      ref.read(waiterCartNotifierProvider.notifier).clearCart();
      
      _logger.info('Bill generated for order: ${order.orderNumber}');
      return order;
    } catch (e, stack) {
      _logger.error('Error generating bill', e, stack);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Send KOT and generate bill
  Future<Order> kotAndBill({String? kitchenNotes}) async {
    try {
      _logger.info('Sending KOT and generating bill');
      
      // For KOT & Bill, we create the order as served (which implies KOT was sent)
      return await generateBill(kitchenNotes: kitchenNotes);
    } catch (e) {
      _logger.error('Error in KOT & Bill', e);
      rethrow;
    }
  }
}

/// Provider for fetching orders for a specific table
@riverpod
Future<List<Order>> waiterTableOrders(Ref ref, String tableId) async {
  final repository = ref.read(waiterOrderRepositoryProvider);
  return repository.getTableOrders(tableId);
}

/// Provider for current active orders count
@riverpod
Future<int> waiterActiveOrdersCount(Ref ref) async {
  final waiter = ref.watch(currentWaiterProvider);
  if (waiter == null) {
    return 0;
  }

  // TODO: Implement fetching active orders count for the waiter
  return 0;
}