import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/orders/models/order.dart';
import '../../../../features/orders/models/order_status.dart';
import '../../../../features/sales/models/cart_item.dart';
import '../../../../features/sales/models/table.dart';
import '../../cart/providers/waiter_cart_provider.dart';
import '../../orders/providers/waiter_order_provider.dart';

/// Dialog for selecting an order when a table has multiple orders
class OrderSelectionDialog extends ConsumerWidget {
  final RestaurantTable table;
  final List<Order> orders;

  const OrderSelectionDialog({
    super.key,
    required this.table,
    required this.orders,
  });

  static final _logger = Logger('OrderSelectionDialog');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // Separate orders by status
    final draftOrders = orders.where((o) => o.status == OrderStatus.draft).toList();
    final confirmedOrders = orders.where((o) => o.status == OrderStatus.confirmed).toList();
    final servedOrders = orders.where((o) => o.status == OrderStatus.served).toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Order',
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        table.displayText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            
            // Orders list
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Draft orders (can be edited)
                    if (draftOrders.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        'Draft Orders',
                        Colors.grey,
                        'Can be edited',
                      ),
                      ...draftOrders.map((order) => _buildOrderTile(
                        context,
                        ref,
                        order,
                        canEdit: true,
                      )),
                      const SizedBox(height: 8),
                    ],

                    // Confirmed orders (in kitchen)
                    if (confirmedOrders.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        'Confirmed Orders',
                        Colors.orange,
                        'In kitchen',
                      ),
                      ...confirmedOrders.map((order) => _buildOrderTile(
                        context,
                        ref,
                        order,
                        canEdit: true,
                      )),
                      const SizedBox(height: 8),
                    ],

                    // Served orders (ready for payment)
                    if (servedOrders.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        'Served Orders',
                        Colors.amber,
                        'Ready for payment',
                      ),
                      ...servedOrders.map((order) => _buildOrderTile(
                        context,
                        ref,
                        order,
                        canEdit: false,
                      )),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),

            // New order button
            const Divider(),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _startNewOrder(context, ref);
              },
              icon: const Icon(Icons.add),
              label: const Text('Start New Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    Color color,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTile(
    BuildContext context,
    WidgetRef ref,
    Order order,
    {required bool canEdit}
  ) {
    final theme = Theme.of(context);
    final itemCount = order.items.length;
    final total = order.total;

    Color statusColor;
    IconData statusIcon;
    switch (order.status) {
      case OrderStatus.draft:
        statusColor = Colors.grey;
        statusIcon = Icons.edit_note;
        break;
      case OrderStatus.confirmed:
        statusColor = Colors.orange;
        statusIcon = Icons.restaurant;
        break;
      case OrderStatus.served:
        statusColor = Colors.amber;
        statusIcon = Icons.receipt;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.receipt_long;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          if (canEdit) {
            _loadOrderToCart(context, ref, order);
          } else {
            _showPaymentDialog(context, order);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Order details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.orderNumber,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.status.displayName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$itemCount items • ₹${total.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      _formatTime(order.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              // Action icon
              Icon(
                canEdit ? Icons.edit : Icons.payment,
                color: theme.colorScheme.outline,
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

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _startNewOrder(BuildContext context, WidgetRef ref) {
    _logger.info('Starting new order for table ${table.displayText}');
    
    // Clear cart and set table
    ref.read(waiterSelectedTableProvider.notifier).state = table;
    ref.read(waiterCartNotifierProvider.notifier).clearCart();
    
    // Navigate to products screen
    context.push('/waiter/tables/${table.id}/products', extra: table);
  }

  void _loadOrderToCart(BuildContext context, WidgetRef ref, Order order) {
    _logger.info('Loading order ${order.orderNumber} to cart');
    
    // Set table
    ref.read(waiterSelectedTableProvider.notifier).state = table;
    
    // Load order items to cart
    final cartNotifier = ref.read(waiterCartNotifierProvider.notifier);
    
    // Clear existing cart
    cartNotifier.clearCart();
    
    // Set order ID for updating existing order
    cartNotifier.setOrderId(order.id);
    
    // Load items
    final cartItems = order.items.map((orderItem) => CartItem(
      id: orderItem.id,
      productId: orderItem.productId,
      variationId: orderItem.variationId,
      productName: orderItem.productName,
      variationName: orderItem.variationName,
      productCode: orderItem.productCode ?? '',
      sku: orderItem.sku ?? '',
      unitOfMeasure: orderItem.unitOfMeasure ?? '',
      categoryId: orderItem.categoryId ?? '',
      categoryName: orderItem.category ?? '',
      quantity: orderItem.quantity,
      unitPrice: orderItem.unitPrice,
      originalPrice: orderItem.unitPrice,
      discountAmount: orderItem.discountAmount,
      discountPercent: orderItem.discountPercent,
      taxRate: orderItem.taxRate,
      taxAmount: orderItem.taxAmount,
      specialInstructions: orderItem.specialInstructions,
      addedAt: orderItem.createdAt,
      updatedAt: orderItem.updatedAt,
    )).toList();
    
    cartNotifier.loadFromOrder(
      orderId: order.id,
      items: cartItems,
      customerId: order.customerId,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
    );
    
    // Navigate to products screen to continue editing
    context.push('/waiter/tables/${table.id}/products', extra: table);
  }

  void _showPaymentDialog(BuildContext context, Order order) {
    _logger.info('Showing payment dialog for order ${order.orderNumber}');
    
    // TODO: Navigate to payment screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment'),
        content: Text(
          'Process payment for order ${order.orderNumber}\n'
          'Total: ₹${order.total.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to payment screen
            },
            child: const Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }
}