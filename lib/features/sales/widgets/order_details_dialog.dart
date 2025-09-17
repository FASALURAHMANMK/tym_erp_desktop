import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../orders/models/order.dart';
import '../../orders/models/order_status.dart';

class OrderDetailsDialog extends StatelessWidget {
  final Order order;
  
  const OrderDetailsDialog({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

    return Dialog(
      child: Container(
        width: 900,
        height: 700,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
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
                    Icons.receipt_long,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        order.orderNumber,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column - Order info and items
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderInfoSection(theme, dateFormat),
                          const SizedBox(height: 24),
                          _buildCustomerInfoSection(theme),
                          const SizedBox(height: 24),
                          _buildOrderItemsSection(theme, currencyFormat),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 24),
                    
                    // Right column - Payment and summary
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPricingBreakdownSection(theme, currencyFormat),
                          const SizedBox(height: 24),
                          _buildPaymentInfoSection(theme, currencyFormat),
                          const SizedBox(height: 24),
                          _buildOrderTimelineSection(theme, dateFormat),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer with actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _copyOrderDetails(context),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Details'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _printReceipt(context),
                    icon: const Icon(Icons.print),
                    label: const Text('Print Receipt'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
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

  Widget _buildOrderInfoSection(ThemeData theme, DateFormat dateFormat) {
    return _buildSection(
      theme: theme,
      title: 'Order Information',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _buildInfoRow('Order Number', order.orderNumber, theme),
          _buildInfoRow('Order Type', order.priceCategoryName ?? order.orderType.displayName, theme),
          if (order.tableId != null)
            _buildInfoRow('Table', order.tableName ?? 'Unknown', theme),
          if (order.tokenNumber != null)
            _buildInfoRow('Token Number', order.tokenNumber!, theme),
          _buildInfoRow('Ordered At', dateFormat.format(order.orderedAt), theme),
          _buildInfoRow('Completed At', dateFormat.format(order.completedAt ?? order.orderedAt), theme),
          _buildInfoRow('Created By', order.createdByName ?? 'Unknown', theme),
          if (order.servedByName != null)
            _buildInfoRow('Served By', order.servedByName!, theme),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoSection(ThemeData theme) {
    return _buildSection(
      theme: theme,
      title: 'Customer Information',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _buildInfoRow('Name', order.customerName, theme),
          if (order.customerPhone != null)
            _buildInfoRow('Phone', order.customerPhone!, theme),
          if (order.customerEmail != null)
            _buildInfoRow('Email', order.customerEmail!, theme),
          if (order.deliveryAddressLine1 != null) ...[
            _buildInfoRow('Address', order.deliveryAddressLine1!, theme),
            if (order.deliveryCity != null)
              _buildInfoRow('City', order.deliveryCity!, theme),
          ],
          if (order.customerNotes != null)
            _buildInfoRow('Notes', order.customerNotes!, theme),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(ThemeData theme, NumberFormat currencyFormat) {
    return _buildSection(
      theme: theme,
      title: 'Order Items (${order.items.length})',
      icon: Icons.shopping_cart_outlined,
      child: Column(
        children: order.items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (item.variationName != 'Default')
                            Text(
                              item.variationName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.quantity} × ${currencyFormat.format(item.unitPrice)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      currencyFormat.format(item.total),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                
                if (item.specialInstructions != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note,
                          size: 16,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.specialInstructions!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.amber.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (item.discountAmount > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.discount,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Discount: ${currencyFormat.format(item.discountAmount)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      if (item.discountReason != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(${item.discountReason})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPricingBreakdownSection(ThemeData theme, NumberFormat currencyFormat) {
    return _buildSection(
      theme: theme,
      title: 'Pricing Breakdown',
      icon: Icons.calculate_outlined,
      child: Column(
        children: [
          _buildPriceRow('Subtotal', order.subtotal, currencyFormat, theme),
          if (order.discountAmount > 0)
            _buildPriceRow('Discount', -order.discountAmount, currencyFormat, theme, 
                          color: theme.colorScheme.error),
          if (order.chargesAmount > 0)
            _buildPriceRow('Charges', order.chargesAmount, currencyFormat, theme,
                          color: theme.colorScheme.primary),
          if (order.taxAmount > 0)
            _buildPriceRow('Tax', order.taxAmount, currencyFormat, theme),
          if (order.tipAmount > 0)
            _buildPriceRow('Tip', order.tipAmount, currencyFormat, theme),
          if (order.roundOffAmount != 0)
            _buildPriceRow('Round Off', order.roundOffAmount, currencyFormat, theme),
          const Divider(),
          _buildPriceRow('Total', order.total, currencyFormat, theme,
                        isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoSection(ThemeData theme, NumberFormat currencyFormat) {
    return _buildSection(
      theme: theme,
      title: 'Payment Information',
      icon: Icons.payment_outlined,
      child: Column(
        children: [
          _buildInfoRow('Payment Status', order.paymentStatus.displayName, theme),
          _buildPriceRow('Total Paid', order.totalPaid, currencyFormat, theme),
          if (order.changeAmount > 0)
            _buildPriceRow('Change Given', order.changeAmount, currencyFormat, theme,
                          color: Colors.green),
          
          const SizedBox(height: 16),
          
          // Payment methods breakdown
          if (order.payments.isNotEmpty) ...[
            Text(
              'Payment Methods:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...order.payments.map((payment) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payment.paymentMethodName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currencyFormat.format(payment.totalAmount),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (payment.referenceNumber != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Ref: ${payment.referenceNumber}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderTimelineSection(ThemeData theme, DateFormat dateFormat) {
    final timeline = <Map<String, dynamic>>[];
    
    timeline.add({
      'title': 'Order Created',
      'time': order.orderedAt,
      'icon': Icons.add_circle_outline,
      'color': Colors.blue,
    });
    
    if (order.confirmedAt != null) {
      timeline.add({
        'title': 'Order Confirmed',
        'time': order.confirmedAt,
        'icon': Icons.check_circle_outline,
        'color': Colors.orange,
      });
    }
    
    if (order.preparedAt != null) {
      timeline.add({
        'title': 'Preparation Started',
        'time': order.preparedAt,
        'icon': Icons.kitchen_outlined,
        'color': Colors.purple,
      });
    }
    
    if (order.readyAt != null) {
      timeline.add({
        'title': 'Order Ready',
        'time': order.readyAt,
        'icon': Icons.done_outline,
        'color': Colors.green,
      });
    }
    
    if (order.servedAt != null) {
      timeline.add({
        'title': 'Order Served',
        'time': order.servedAt,
        'icon': Icons.room_service_outlined,
        'color': Colors.teal,
      });
    }
    
    timeline.add({
      'title': 'Order Completed',
      'time': order.completedAt ?? order.orderedAt,
      'icon': Icons.verified_outlined,
      'color': Colors.green,
    });

    return _buildSection(
      theme: theme,
      title: 'Order Timeline',
      icon: Icons.timeline_outlined,
      child: Column(
        children: timeline.map((event) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (event['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    event['icon'] as IconData,
                    color: event['color'] as Color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        dateFormat.format(event['time'] as DateTime),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
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
      ),
    );
  }

  Widget _buildPriceRow(
    String label, 
    double amount, 
    NumberFormat currencyFormat, 
    ThemeData theme, {
    Color? color,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: isTotal ? FontWeight.bold : null,
              fontSize: isTotal ? 16 : null,
            ),
          ),
          Text(
            currencyFormat.format(amount),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: color ?? (isTotal ? theme.colorScheme.primary : null),
              fontSize: isTotal ? 16 : null,
            ),
          ),
        ],
      ),
    );
  }

  void _copyOrderDetails(BuildContext context) {
    final details = '''
Order: ${order.orderNumber}
Customer: ${order.customerName}
${order.customerPhone != null ? 'Phone: ${order.customerPhone}' : ''}
Type: ${order.priceCategoryName ?? order.orderType.displayName}
${order.tableName != null ? 'Table: ${order.tableName}' : ''}
Total: ₹${order.total.toStringAsFixed(2)}
Items: ${order.items.length}
Completed: ${DateFormat('dd/MM/yyyy HH:mm').format(order.completedAt ?? order.orderedAt)}
''';

    Clipboard.setData(ClipboardData(text: details));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order details copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _printReceipt(BuildContext context) {
    // TODO: Implement receipt printing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt printing for order ${order.orderNumber}'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}