import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/logger.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../providers/order_provider.dart';
import '../widgets/order_status_badge.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;
  
  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  static final _logger = Logger('OrderDetailsScreen');
  final _dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderByIdProvider(widget.orderId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          // Refresh button
          IconButton(
            onPressed: () {
              ref.invalidate(orderByIdProvider(widget.orderId));
            },
            icon: const Icon(Icons.refresh),
          ),
          
          // Print button
          IconButton(
            onPressed: () {
              // TODO: Implement receipt printing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Receipt printing will be available soon'),
                ),
              );
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return const Center(
              child: Text('Order not found'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Order info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        order.orderNumber,
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      OrderStatusBadge(
                                        status: order.status,
                                        large: true,
                                      ),
                                      if (order.tokenNumber != null) ...[
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.orange.withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.confirmation_number,
                                                size: 16,
                                                color: Colors.orange,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Token: ${order.tokenNumber}',
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ordered at ${_dateFormat.format(order.orderedAt)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Order type
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _getOrderTypeIcon(order.orderType),
                                    size: 32,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.orderType.displayName,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Status timeline
                        if (order.status != OrderStatus.draft) ...[
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 20),
                          _buildStatusTimeline(order),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column - Items and totals
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Order items
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Items',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...order.items.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildOrderItemRow(item),
                                  )),
                                  
                                  const Divider(height: 32),
                                  
                                  // Totals
                                  _buildTotalRow('Subtotal', order.subtotal),
                                  if (order.discountAmount > 0) ...[
                                    const SizedBox(height: 8),
                                    _buildTotalRow(
                                      'Discount',
                                      -order.discountAmount,
                                      isDiscount: true,
                                    ),
                                  ],
                                  if (order.taxAmount > 0) ...[
                                    const SizedBox(height: 8),
                                    _buildTotalRow('Tax', order.taxAmount),
                                  ],
                                  const SizedBox(height: 8),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  _buildTotalRow(
                                    'Total',
                                    order.total,
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Payments
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payments',
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      _buildPaymentStatusBadge(order.paymentStatus),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ...order.payments.map((payment) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getPaymentMethodIcon(payment.paymentMethodCode),
                                          size: 20,
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                payment.paymentMethodName,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (payment.referenceNumber != null) ...[
                                                Text(
                                                  'Ref: ${payment.referenceNumber}',
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '₹${payment.totalAmount.toStringAsFixed(2)}',
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  
                                  if (order.changeAmount > 0) ...[
                                    const Divider(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Change Given',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '₹${order.changeAmount.toStringAsFixed(2)}',
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Right column - Customer and actions
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Customer info
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Customer Information',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(Icons.person, 'Name', order.customerName),
                                  if (order.customerPhone != null) ...[
                                    const SizedBox(height: 8),
                                    _buildInfoRow(Icons.phone, 'Phone', order.customerPhone!),
                                  ],
                                  if (order.customerEmail != null) ...[
                                    const SizedBox(height: 8),
                                    _buildInfoRow(Icons.email, 'Email', order.customerEmail!),
                                  ],
                                  if (order.tableName != null) ...[
                                    const SizedBox(height: 8),
                                    _buildInfoRow(Icons.table_restaurant, 'Table', order.tableName!),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Notes
                          if (order.customerNotes != null || order.kitchenNotes != null) ...[
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Notes',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (order.customerNotes != null) ...[
                                      const SizedBox(height: 16),
                                      _buildNoteSection('Customer Notes', order.customerNotes!),
                                    ],
                                    if (order.kitchenNotes != null) ...[
                                      const SizedBox(height: 12),
                                      _buildNoteSection('Kitchen Notes', order.kitchenNotes!),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Actions
                          if (order.isActive) ...[
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Actions',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ..._buildActionButtons(order),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error loading order: $error'),
        ),
      ),
    );
  }
  
  Widget _buildStatusTimeline(Order order) {
    final theme = Theme.of(context);
    final statuses = <OrderStatus, DateTime?>{
      OrderStatus.confirmed: order.confirmedAt,
      OrderStatus.preparing: order.preparedAt,
      OrderStatus.ready: order.readyAt,
    };
    
    if (order.orderType == OrderType.dineIn) {
      statuses[OrderStatus.served] = order.servedAt;
    } else {
      statuses[OrderStatus.picked] = order.servedAt;
    }
    
    statuses[OrderStatus.completed] = order.completedAt;
    
    return Row(
      children: statuses.entries.map((entry) {
        final isCompleted = entry.value != null;
        final isLast = entry.key == statuses.keys.last;
        
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green
                          : theme.colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        color: isCompleted
                            ? Colors.green
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.circle,
                      size: 20,
                      color: isCompleted
                          ? Colors.white
                          : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.key.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: isCompleted ? FontWeight.bold : null,
                      color: isCompleted
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  if (entry.value != null) ...[
                    Text(
                      DateFormat('hh:mm a').format(entry.value!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? Colors.green
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildOrderItemRow(dynamic item) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (item.variationName != item.productName) ...[
                Text(
                  item.variationName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
              if (item.specialInstructions != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.specialInstructions!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 2)} × ₹${item.unitPrice.toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: Text(
            '₹${item.total.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTotalRow(String label, double amount, {bool isDiscount = false, bool isTotal = false}) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : theme.textTheme.bodyMedium,
        ),
        Text(
          '${isDiscount ? '-' : ''}₹${amount.abs().toStringAsFixed(2)}',
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  color: isDiscount ? Colors.green : null,
                ),
        ),
      ],
    );
  }
  
  Widget _buildPaymentStatusBadge(PaymentStatus status) {
    final color = _getPaymentStatusColor(status);
    final icon = _getPaymentStatusIcon(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNoteSection(String title, String notes) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            notes,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
  
  List<Widget> _buildActionButtons(Order order) {
    final buttons = <Widget>[];
    
    if (order.status == OrderStatus.confirmed) {
      buttons.add(
        ElevatedButton.icon(
          onPressed: () => _updateOrderStatus(OrderStatus.preparing),
          icon: const Icon(Icons.restaurant),
          label: const Text('Start Preparing'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }
    
    if (order.status == OrderStatus.preparing) {
      buttons.add(
        ElevatedButton.icon(
          onPressed: () => _updateOrderStatus(OrderStatus.ready),
          icon: const Icon(Icons.check_circle),
          label: const Text('Mark Ready'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }
    
    if (order.status == OrderStatus.ready) {
      if (order.orderType == OrderType.dineIn) {
        buttons.add(
          ElevatedButton.icon(
            onPressed: () => _updateOrderStatus(OrderStatus.served),
            icon: const Icon(Icons.room_service),
            label: const Text('Mark Served'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        );
      } else {
        buttons.add(
          ElevatedButton.icon(
            onPressed: () => _updateOrderStatus(OrderStatus.picked),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Mark Picked Up'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        );
      }
    }
    
    if (order.status == OrderStatus.served || order.status == OrderStatus.picked) {
      buttons.add(
        ElevatedButton.icon(
          onPressed: () => _updateOrderStatus(OrderStatus.completed),
          icon: const Icon(Icons.done_all),
          label: const Text('Complete Order'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }
    
    // Cancel button for active orders
    if (order.status != OrderStatus.completed &&
        order.status != OrderStatus.cancelled &&
        order.status != OrderStatus.refunded) {
      buttons.add(const SizedBox(height: 8));
      buttons.add(
        OutlinedButton.icon(
          onPressed: () => _showCancelDialog(),
          icon: const Icon(Icons.cancel),
          label: const Text('Cancel Order'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
      );
    }
    
    return buttons;
  }
  
  Future<void> _updateOrderStatus(OrderStatus newStatus) async {
    try {
      await ref.read(orderNotifierProvider.notifier).updateOrderStatus(
        orderId: widget.orderId,
        newStatus: newStatus,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to ${newStatus.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to update order status', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _showCancelDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to cancel this order?'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Cancellation Reason',
                hintText: 'Enter reason for cancellation',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No, Keep Order'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel Order'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty) {
      try {
        await ref.read(orderNotifierProvider.notifier).cancelOrder(
          orderId: widget.orderId,
          reason: result,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order cancelled successfully'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        _logger.error('Failed to cancel order', e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to cancel order: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  IconData _getOrderTypeIcon(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return Icons.restaurant;
      case OrderType.takeaway:
        return Icons.shopping_bag;
      case OrderType.delivery:
        return Icons.delivery_dining;
      case OrderType.online:
        return Icons.language;
    }
  }
  
  IconData _getPaymentMethodIcon(String code) {
    switch (code) {
      case 'cash':
        return Icons.payments;
      case 'credit_card':
      case 'debit_card':
        return Icons.credit_card;
      case 'upi':
        return Icons.smartphone;
      case 'cheque':
        return Icons.receipt;
      case 'bank_transfer':
        return Icons.account_balance;
      case 'customer_credit':
        return Icons.account_balance_wallet;
      case 'wallet':
        return Icons.wallet;
      default:
        return Icons.payment;
    }
  }
  
  IconData _getPaymentStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.partial:
        return Icons.hourglass_bottom;
      case PaymentStatus.paid:
        return Icons.check_circle;
      case PaymentStatus.refunded:
        return Icons.replay;
    }
  }
  
  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.partial:
        return Colors.amber;
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.refunded:
        return Colors.purple;
    }
  }
}