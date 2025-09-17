import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../business/providers/business_provider.dart';
import '../../customers/models/customer.dart';
import '../../location/providers/location_provider.dart';
import '../../sales/models/cart.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../repositories/order_repository.dart';

part 'order_provider.g.dart';

// Logger instance
final _logger = Logger('OrderProvider');

// Order repository provider
@riverpod
Future<OrderRepository> orderRepository(Ref ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;

  final repository = OrderRepository(
    localDatabase: database,
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );

  // Initialize tables
  await repository.initializeLocalTables();

  return repository;
}

// Initialize order tables
final initializeOrderTablesProvider = FutureProvider<void>((ref) async {
  await ref.watch(orderRepositoryProvider.future);
  _logger.info('Order tables initialized');
});

// Create order from cart
final createOrderFromCartProvider =
    FutureProvider.family<Order?, Map<String, dynamic>>((ref, params) async {
      try {
        final repository = await ref.watch(orderRepositoryProvider.future);
        final user = ref.watch(currentUserProvider);
        final selectedBusiness = ref.watch(selectedBusinessProvider);
        final selectedLocation = await ref.watch(
          selectedLocationNotifierProvider.future,
        );

        if (user == null) {
          throw Exception('User not authenticated');
        }

        if (selectedBusiness == null) {
          throw Exception('No business selected');
        }

        if (selectedLocation == null) {
          throw Exception('No location selected');
        }

        final cart = params['cart'] as Cart;
        final customer = params['customer'] as Customer;
        final payments = params['payments'] as List<Map<String, dynamic>>;
        final orderType =
            params['orderType'] as OrderType? ?? OrderType.takeaway;
        final priceCategoryName = params['priceCategoryName'] as String?;
        final tableId = params['tableId'] as String?;
        final tableName = params['tableName'] as String?;
        final customerNotes = params['customerNotes'] as String?;
        final kitchenNotes = params['kitchenNotes'] as String?;

        // Get the selected POS device
        final selectedPosDevice = await ref.read(
          selectedPOSDeviceNotifierProvider.future,
        );
        if (selectedPosDevice == null) {
          throw Exception(
            'No POS device selected. Please select a POS device in settings.',
          );
        }

        final result = await repository.createOrderFromCart(
          cart: cart,
          customer: customer,
          businessId: selectedBusiness.id,
          locationId: selectedLocation.id,
          posDeviceId: selectedPosDevice.id,
          userId: user.id,
          userName: user.email ?? 'Unknown',
          payments: payments,
          orderType: orderType,
          priceCategoryName: priceCategoryName,
          tableId: tableId,
          tableName: tableName,
          customerNotes: customerNotes,
          kitchenNotes: kitchenNotes,
        );

        return result.fold(
          (error) {
            _logger.error('Failed to create order: $error');
            throw Exception(error);
          },
          (order) {
            _logger.info('Order created successfully: ${order.orderNumber}');
            // Invalidate orders list to refresh
            ref.invalidate(ordersProvider);
            ref.invalidate(activeOrdersProvider);
            ref.invalidate(todaysOrdersProvider);
            return order;
          },
        );
      } catch (e) {
        _logger.error('Error creating order from cart', e);
        throw Exception('Failed to create order: $e');
      }
    });

// Orders list provider
final ordersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  final selectedBusiness = ref.watch(selectedBusinessProvider);
  final selectedLocation = await ref.watch(
    selectedLocationNotifierProvider.future,
  );

  if (selectedBusiness == null) {
    return [];
  }

  final result = await repository.getOrders(
    businessId: selectedBusiness.id,
    locationId: selectedLocation?.id,
    limit: 100,
  );

  return result.fold((error) {
    _logger.error('Failed to load orders: $error');
    return <Order>[];
  }, (orders) => orders);
});

// Active orders provider (not completed/cancelled/refunded)
final activeOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  final selectedBusiness = ref.watch(selectedBusinessProvider);
  final selectedLocation = await ref.watch(
    selectedLocationNotifierProvider.future,
  );

  if (selectedBusiness == null || selectedLocation == null) {
    return [];
  }

  final result = await repository.getActiveOrders(
    businessId: selectedBusiness.id,
    locationId: selectedLocation.id,
  );

  return result.fold((error) {
    _logger.error('Failed to load active orders: $error');
    return <Order>[];
  }, (orders) => orders);
});

// Today's orders provider
final todaysOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = await ref.watch(orderRepositoryProvider.future);
  final selectedBusiness = ref.watch(selectedBusinessProvider);
  final selectedLocation = await ref.watch(
    selectedLocationNotifierProvider.future,
  );

  if (selectedBusiness == null || selectedLocation == null) {
    return [];
  }

  final result = await repository.getTodaysOrders(
    businessId: selectedBusiness.id,
    locationId: selectedLocation.id,
  );

  return result.fold((error) {
    _logger.error('Failed to load today\'s orders: $error');
    return <Order>[];
  }, (orders) => orders);
});

// Order by ID provider
final orderByIdProvider = FutureProvider.family<Order?, String>((
  ref,
  orderId,
) async {
  final repository = await ref.watch(orderRepositoryProvider.future);

  final result = await repository.getOrderById(orderId);

  return result.fold((error) {
    _logger.error('Failed to load order: $error');
    return null;
  }, (order) => order);
});

// Order management notifier
class OrderNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  OrderNotifier(this._ref) : super(const AsyncValue.data(null));

  // Update order status
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? reason,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = await _ref.read(orderRepositoryProvider.future);
      final user = _ref.read(currentUserProvider);

      if (user == null) {
        throw Exception('User not authenticated');
      }

      final result = await repository.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
        userId: user.id,
        userName: user.email ?? 'Unknown',
        reason: reason,
      );

      result.fold(
        (error) {
          state = AsyncValue.error(error, StackTrace.current);
          _logger.error('Failed to update order status: $error');
        },
        (order) {
          state = const AsyncValue.data(null);
          // Invalidate orders to refresh
          _ref.invalidate(ordersProvider);
          _ref.invalidate(activeOrdersProvider);
          _ref.invalidate(todaysOrdersProvider);
          _ref.invalidate(orderByIdProvider(orderId));
          _logger.info(
            'Order status updated: ${order.orderNumber} to ${newStatus.displayName}',
          );
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      _logger.error('Error updating order status', e);
    }
  }

  // Mark order as preparing
  Future<void> startPreparing(String orderId) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.preparing,
      reason: 'Kitchen started preparing',
    );
  }

  // Mark order as ready
  Future<void> markAsReady(String orderId) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.ready,
      reason: 'Order is ready',
    );
  }

  // Mark order as served (dine-in)
  Future<void> markAsServed(String orderId) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.served,
      reason: 'Order served to customer',
    );
  }

  // Mark order as picked up (takeaway)
  Future<void> markAsPickedUp(String orderId) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.picked,
      reason: 'Customer picked up order',
    );
  }

  // Complete order
  Future<void> completeOrder(String orderId) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.completed,
      reason: 'Order completed',
    );
  }

  // Cancel order
  Future<void> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.cancelled,
      reason: reason,
    );
  }

  // Get active orders for a specific table
  Future<List<Order>> getTableOrders({
    required String businessId,
    required String locationId,
    required String tableId,
  }) async {
    try {
      final repository = await _ref.read(orderRepositoryProvider.future);
      final result = await repository.getTableOrders(
        businessId: businessId,
        locationId: locationId,
        tableId: tableId,
      );

      return result.fold(
        (error) {
          _logger.error('Failed to get table orders: $error');
          return [];
        },
        (orders) => orders,
      );
    } catch (e) {
      _logger.error('Error getting table orders', e);
      return [];
    }
  }

  // Create order from cart
  Future<Order?> createOrderFromCart({
    required Cart cart,
    required Customer customer,
    required String businessId,
    required String locationId,
    required String posDeviceId,
    required String userId,
    required String userName,
    OrderType orderType = OrderType.dineIn,
    String? priceCategoryName,
    String? tableId,
    String? tableName,
    OrderStatus orderStatus = OrderStatus.draft,
    bool isDraft = true,
  }) async {
    try {
      final repository = await _ref.read(orderRepositoryProvider.future);
      
      // For now, we'll create order without payments for draft orders
      final payments = <Map<String, dynamic>>[];
      
      final result = await repository.createOrderFromCart(
        cart: cart,
        customer: customer,
        businessId: businessId,
        locationId: locationId,
        posDeviceId: posDeviceId,
        userId: userId,
        userName: userName,
        payments: payments,
        orderType: orderType,
        priceCategoryName: priceCategoryName,
        tableId: tableId,
        tableName: tableName,
      );

      return result.fold(
        (error) {
          _logger.error('Failed to create order from cart: $error');
          throw Exception(error);
        },
        (order) async {
          _logger.info('Order created successfully: ${order.orderNumber}');

          // If caller requested a specific initial status (e.g., confirmed for KOT),
          // and this isn't intended to remain as a draft, update status immediately.
          if (!isDraft && orderStatus != OrderStatus.draft) {
            final statusResult = await repository.updateOrderStatus(
              orderId: order.id,
              newStatus: orderStatus,
              userId: userId,
              userName: userName,
              reason: 'Initial status set by Cart action',
            );
            statusResult.fold(
              (err) => _logger.error(
                'Failed to set initial status ${orderStatus.displayName}: $err',
              ),
              (_) => _logger.info(
                'Order ${order.orderNumber} moved to ${orderStatus.displayName}',
              ),
            );
          }

          // Invalidate orders list to refresh
          _ref.invalidate(ordersProvider);
          _ref.invalidate(activeOrdersProvider);
          _ref.invalidate(todaysOrdersProvider);
          return order;
        },
      );
    } catch (e) {
      _logger.error('Error creating order from cart', e);
      return null;
    }
  }

  // Update order items (for existing orders)
  Future<Order?> updateOrderItems({
    required String orderId,
    required Cart cart,
    required String userId,
    required String userName,
  }) async {
    try {
      final repository = await _ref.read(orderRepositoryProvider.future);
      
      _logger.info('Updating order items for order: $orderId');
      
      // Call the repository method to update order items
      final result = await repository.updateOrderItems(
        orderId: orderId,
        cart: cart,
        userId: userId,
        userName: userName,
      );
      
      return result.fold(
        (error) {
          _logger.error('Failed to update order items: $error');
          return null;
        },
        (updatedOrder) {
          _logger.info('Order items updated successfully for order: $orderId');
          
          // Invalidate orders to refresh
          _ref.invalidate(ordersProvider);
          _ref.invalidate(activeOrdersProvider);
          _ref.invalidate(todaysOrdersProvider);
          _ref.invalidate(orderByIdProvider(orderId));
          
          return updatedOrder;
        },
      );
    } catch (e) {
      _logger.error('Error updating order items', e);
      return null;
    }
  }
}

// Order notifier provider
final orderNotifierProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<void>>((ref) {
      return OrderNotifier(ref);
    });

// Order statistics provider
final orderStatisticsProvider = Provider<OrderStatistics>((ref) {
  final todaysOrdersAsync = ref.watch(todaysOrdersProvider);

  return todaysOrdersAsync.when(
    data: (orders) {
      final completedOrders =
          orders.where((o) => o.status == OrderStatus.completed).toList();
      final activeOrders = orders.where((o) => o.isActive).toList();
      final cancelledOrders =
          orders.where((o) => o.status == OrderStatus.cancelled).toList();

      final totalRevenue = completedOrders.fold<double>(
        0,
        (sum, order) => sum + order.total,
      );

      final averageOrderValue =
          completedOrders.isNotEmpty
              ? totalRevenue / completedOrders.length
              : 0.0;

      return OrderStatistics(
        todayOrderCount: orders.length,
        completedOrderCount: completedOrders.length,
        activeOrderCount: activeOrders.length,
        cancelledOrderCount: cancelledOrders.length,
        todayRevenue: totalRevenue.toDouble(),
        averageOrderValue: averageOrderValue,
      );
    },
    loading: () => OrderStatistics.empty(),
    error: (_, __) => OrderStatistics.empty(),
  );
});

// Order statistics model
class OrderStatistics {
  final int todayOrderCount;
  final int completedOrderCount;
  final int activeOrderCount;
  final int cancelledOrderCount;
  final double todayRevenue;
  final double averageOrderValue;

  OrderStatistics({
    required this.todayOrderCount,
    required this.completedOrderCount,
    required this.activeOrderCount,
    required this.cancelledOrderCount,
    required this.todayRevenue,
    required this.averageOrderValue,
  });

  factory OrderStatistics.empty() => OrderStatistics(
    todayOrderCount: 0,
    completedOrderCount: 0,
    activeOrderCount: 0,
    cancelledOrderCount: 0,
    todayRevenue: 0,
    averageOrderValue: 0,
  );
}

// Filtered orders provider with search
final filteredOrdersProvider = Provider.family<List<Order>, OrderFilter>((
  ref,
  filter,
) {
  final ordersAsync = ref.watch(ordersProvider);

  return ordersAsync.when(
    data: (orders) {
      var filtered = orders;

      // Apply status filter
      if (filter.status != null) {
        filtered = filtered.where((o) => o.status == filter.status).toList();
      }

      // Apply payment status filter
      if (filter.paymentStatus != null) {
        filtered =
            filtered
                .where((o) => o.paymentStatus == filter.paymentStatus)
                .toList();
      }

      // Apply order type filter
      if (filter.orderType != null) {
        filtered =
            filtered.where((o) => o.orderType == filter.orderType).toList();
      }

      // Apply date range filter
      if (filter.fromDate != null) {
        filtered =
            filtered
                .where((o) => o.orderedAt.isAfter(filter.fromDate!))
                .toList();
      }

      if (filter.toDate != null) {
        filtered =
            filtered
                .where((o) => o.orderedAt.isBefore(filter.toDate!))
                .toList();
      }

      // Apply search query
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final query = filter.searchQuery!.toLowerCase();
        filtered =
            filtered
                .where(
                  (o) =>
                      o.orderNumber.toLowerCase().contains(query) ||
                      o.customerName.toLowerCase().contains(query) ||
                      (o.customerPhone?.toLowerCase().contains(query) ??
                          false) ||
                      (o.tokenNumber?.toLowerCase().contains(query) ?? false) ||
                      (o.tableName?.toLowerCase().contains(query) ?? false),
                )
                .toList();
      }

      // Sort by date (newest first)
      filtered.sort((a, b) => b.orderedAt.compareTo(a.orderedAt));

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Order filter model
class OrderFilter {
  final OrderStatus? status;
  final PaymentStatus? paymentStatus;
  final OrderType? orderType;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? searchQuery;

  OrderFilter({
    this.status,
    this.paymentStatus,
    this.orderType,
    this.fromDate,
    this.toDate,
    this.searchQuery,
  });

  OrderFilter copyWith({
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    OrderType? orderType,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
  }) {
    return OrderFilter(
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderType: orderType ?? this.orderType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Order filter state provider
final orderFilterProvider = StateProvider<OrderFilter>((ref) {
  return OrderFilter();
});
