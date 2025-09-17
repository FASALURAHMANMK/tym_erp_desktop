import '../models/order.dart';
import '../models/order_status.dart';

/// Business states for table management UI
enum TableBusinessState {
  free,       // No active orders (green)
  occupied,   // Has active orders (red) 
  billed,     // All orders billed, awaiting payment (amber)
  completed,  // All orders completed (green)
}

/// Service to manage order business state mapping
/// Provides centralized logic for determining table states based on order statuses
class OrderBusinessStateService {
  /// Determine table business state from list of orders
  static TableBusinessState getTableState(List<Order> tableOrders) {
    if (tableOrders.isEmpty) {
      return TableBusinessState.free;
    }

    // Check different order categories
    final activeOrders = tableOrders.where(_isActiveOrder).toList();
    final billedOrders = tableOrders.where(_isBilledOrder).toList();
    final completedOrders = tableOrders.where(_isCompletedOrder).toList();

    // All orders are completed/cancelled - table is free
    if (completedOrders.length == tableOrders.length) {
      return TableBusinessState.free;
    }

    // Has active orders (draft, confirmed, preparing, ready) - table is occupied
    if (activeOrders.isNotEmpty) {
      return TableBusinessState.occupied;
    }

    // Only billed orders remaining (served/picked, awaiting payment) - table is billed
    if (billedOrders.isNotEmpty && activeOrders.isEmpty) {
      return TableBusinessState.billed;
    }

    // Fallback to free
    return TableBusinessState.free;
  }

  /// Check if order is in active state (occupies table)
  static bool _isActiveOrder(Order order) {
    return _isActiveOrderStatus(order.status);
  }

  /// Check if order is in billed state (awaiting payment)
  static bool _isBilledOrder(Order order) {
    return _isBilledOrderStatus(order.status);
  }

  /// Check if order is completed/closed
  static bool _isCompletedOrder(Order order) {
    return _isCompletedOrderStatus(order.status);
  }

  /// Check if order status is active (occupies table)
  static bool _isActiveOrderStatus(OrderStatus status) {
    return [
      OrderStatus.draft,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
    ].contains(status);
  }

  /// Check if order status is billed (awaiting payment)
  static bool _isBilledOrderStatus(OrderStatus status) {
    return [
      OrderStatus.served,  // Dine-in: food served, bill printed
      OrderStatus.picked,  // Takeaway: order picked up, bill issued
    ].contains(status);
  }

  /// Check if order status is completed/closed
  static bool _isCompletedOrderStatus(OrderStatus status) {
    return [
      OrderStatus.completed,  // Payment received
      OrderStatus.cancelled,  // Order cancelled
      OrderStatus.refunded,   // Payment refunded
    ].contains(status);
  }

  /// Get business state display text
  static String getBusinessStateText(TableBusinessState state) {
    switch (state) {
      case TableBusinessState.free:
        return 'FREE';
      case TableBusinessState.occupied:
        return 'OCCUPIED';
      case TableBusinessState.billed:
        return 'BILLED';
      case TableBusinessState.completed:
        return 'COMPLETED';
    }
  }

  /// Get business state display color
  static String getBusinessStateColorHex(TableBusinessState state) {
    switch (state) {
      case TableBusinessState.free:
        return '#4CAF50';  // Green
      case TableBusinessState.occupied:
        return '#F44336';  // Red
      case TableBusinessState.billed:
        return '#FF9800';  // Amber
      case TableBusinessState.completed:
        return '#4CAF50';  // Green
    }
  }

  /// Determine if order should show as "BILLED" in selection dialog
  /// This is for dine-in orders that have been served and are awaiting payment
  static bool isOrderBilled(Order order) {
    return _isBilledOrderStatus(order.status) && 
           order.orderType == OrderType.dineIn;
  }

  /// Get appropriate status text for order selection dialog
  static String getOrderSelectionStatusText(Order order) {
    // Special case: served dine-in orders should show as "BILLED"
    if (order.status == OrderStatus.served && order.orderType == OrderType.dineIn) {
      return 'BILLED';
    }
    
    // Special case: picked takeaway orders should show as "BILLED"  
    if (order.status == OrderStatus.picked && 
        (order.orderType == OrderType.takeaway || order.orderType == OrderType.delivery)) {
      return 'BILLED';
    }

    // Default to status display name
    return order.status.displayName.toUpperCase();
  }

  /// Get appropriate status color for order selection dialog
  static String getOrderSelectionStatusColorHex(Order order) {
    // Special case: billed orders show amber
    if (isOrderBilled(order) || 
        (order.status == OrderStatus.picked && 
         (order.orderType == OrderType.takeaway || order.orderType == OrderType.delivery))) {
      return '#FF9800';  // Amber
    }

    // Use standard status colors
    switch (order.status) {
      case OrderStatus.draft:
        return '#9E9E9E';  // Grey
      case OrderStatus.confirmed:
        return '#FF9800';  // Orange
      case OrderStatus.preparing:
        return '#2196F3';  // Blue
      case OrderStatus.ready:
        return '#4CAF50';  // Green
      case OrderStatus.served:
        return '#009688';  // Teal
      case OrderStatus.picked:
        return '#009688';  // Teal
      case OrderStatus.completed:
        return '#009688';  // Teal
      case OrderStatus.cancelled:
        return '#F44336';  // Red
      case OrderStatus.refunded:
        return '#F44336';  // Red
    }
  }

  /// Check if orders list has any active (non-completed) orders
  static bool hasActiveOrders(List<Order> orders) {
    return orders.any((order) => _isActiveOrderStatus(order.status));
  }

  /// Check if orders list has any billed orders
  static bool hasBilledOrders(List<Order> orders) {
    return orders.any((order) => _isBilledOrderStatus(order.status));
  }

  /// Check if all orders in list are completed
  static bool allOrdersCompleted(List<Order> orders) {
    if (orders.isEmpty) return true;
    return orders.every((order) => _isCompletedOrderStatus(order.status));
  }

  /// Get count of orders by business state
  static Map<String, int> getOrderCountsByState(List<Order> orders) {
    return {
      'active': orders.where(_isActiveOrder).length,
      'billed': orders.where(_isBilledOrder).length,
      'completed': orders.where(_isCompletedOrder).length,
    };
  }
}