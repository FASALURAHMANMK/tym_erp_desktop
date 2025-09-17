import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../orders/models/order.dart';
import '../../orders/models/order_status.dart';
import '../../orders/services/order_business_state_service.dart';
import '../models/table.dart';

/// Dialog to select from multiple orders for a table
class TableOrderSelectionDialog extends ConsumerWidget {

  final RestaurantTable table;
  final List<Order> orders;

  const TableOrderSelectionDialog({
    super.key,
    required this.table,
    required this.orders,
  });

  static Future<OrderSelectionResult?> show(
    BuildContext context,
    RestaurantTable table,
    List<Order> orders,
  ) async {
    return showDialog<OrderSelectionResult>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => TableOrderSelectionDialog(table: table, orders: orders),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.table_restaurant,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Table ${table.displayText} - Multiple Orders',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select an order to view/edit or create a new order',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Orders list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _buildOrderCard(context, order);
                },
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(
                        OrderSelectionResult(action: OrderAction.createNew),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final theme = Theme.of(context);

    // Use centralized logic for status display
    final statusText = OrderBusinessStateService.getOrderSelectionStatusText(order);
    final statusColorHex = OrderBusinessStateService.getOrderSelectionStatusColorHex(order);
    final statusColor = Color(int.parse(statusColorHex.replaceFirst('#', '0xFF')));

    // Determine payment status
    IconData paymentIcon;
    Color paymentColor;
    String paymentText;
    switch (order.paymentStatus) {
      case PaymentStatus.pending:
        paymentIcon = Icons.payment;
        paymentColor = Colors.orange;
        paymentText = 'Payment Pending';
        break;
      case PaymentStatus.partial:
        paymentIcon = Icons.account_balance_wallet;
        paymentColor = Colors.blue;
        paymentText = 'Partially Paid';
        break;
      case PaymentStatus.paid:
        paymentIcon = Icons.check_circle;
        paymentColor = Colors.green;
        paymentText = 'Paid';
        break;
      case PaymentStatus.refunded:
        paymentIcon = Icons.replay;
        paymentColor = Colors.red;
        paymentText = 'Refunded';
        break;
    }

    // Check if KOT/Bill printed (based on status)
    final kotPrinted = order.status == OrderStatus.confirmed ||
                       order.status == OrderStatus.preparing || 
                       order.status == OrderStatus.ready || 
                       order.status == OrderStatus.served ||
                       order.status == OrderStatus.completed;
    final billPrinted = order.status == OrderStatus.served || 
                        order.status == OrderStatus.completed ||
                        order.paymentStatus == PaymentStatus.paid;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(
            OrderSelectionResult(
              action: OrderAction.selectExisting,
              selectedOrder: order,
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header
              Row(
                children: [
                  Text(
                    order.orderNumber,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(order.orderedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Order details
              Row(
                children: [
                  // Items count
                  Icon(
                    Icons.shopping_bag,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${order.items.length} items',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),

                  // Customer
                  Icon(
                    Icons.person,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(order.customerName, style: theme.textTheme.bodySmall),
                  const Spacer(),

                  // Total amount
                  Text(
                    '₹${order.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status indicators
              Row(
                children: [
                  // Payment status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: paymentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(paymentIcon, size: 14, color: paymentColor),
                        const SizedBox(width: 4),
                        Text(
                          paymentText,
                          style: TextStyle(
                            color: paymentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // KOT status
                  if (kotPrinted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.print, size: 14, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            'KOT',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),

                  // Bill status
                  if (billPrinted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            'Bill',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// Result from order selection dialog
class OrderSelectionResult {
  final OrderAction action;
  final Order? selectedOrder;

  OrderSelectionResult({required this.action, this.selectedOrder});
}

/// Action selected in the dialog
enum OrderAction { selectExisting, createNew }
