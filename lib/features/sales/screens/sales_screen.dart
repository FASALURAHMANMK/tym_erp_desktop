import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/logger.dart';
import '../../orders/models/order.dart';
import '../../orders/models/order_status.dart';
import '../providers/sales_provider.dart';
import '../widgets/order_details_dialog.dart';
import '../widgets/sales_filters.dart';
import '../widgets/sales_summary_cards.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final _dateFormat = DateFormat('dd/MM/yy HH:mm');
  final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

  int _currentPage = 0;
  static const int _ordersPerPage = 15;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final salesAsync = ref.watch(filteredSalesProvider);
    final statisticsAsync = ref.watch(todaysSalesStatisticsProvider);

    return Scaffold(
      body: Column(
        children: [
          // Header with title and summary cards
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sales Analytics',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'View completed orders and sales performance',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Summary cards
                SalesSummaryCards(statistics: statisticsAsync),
              ],
            ),
          ),

          // Filters
          const SalesFilters(),

          // Sales data table
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sales Records',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${salesAsync.length} orders',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table content
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildSalesTable(salesAsync, theme),
                    ),
                  ),

                  // Pagination
                  if (salesAsync.length > _ordersPerPage)
                    _buildPagination(salesAsync.length, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTable(List<Order> sales, ThemeData theme) {
    if (sales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No sales records found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completed orders will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    // Calculate pagination
    final startIndex = _currentPage * _ordersPerPage;
    final endIndex = (startIndex + _ordersPerPage).clamp(0, sales.length);
    final paginatedSales = sales.sublist(startIndex, endIndex);

    return DataTable(
      columnSpacing: 24,
      horizontalMargin: 24,
      headingRowColor: WidgetStateProperty.all(
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
      ),
      headingTextStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      dataTextStyle: theme.textTheme.bodyMedium,
      columns: [
        DataColumn(
          label: const Text('Order'),
          tooltip: 'Order number and invoice',
        ),
        DataColumn(
          label: const Text('Date/Time'),
          tooltip: 'Order completion time',
        ),
        DataColumn(
          label: const Text('Customer'),
          tooltip: 'Customer name and contact',
        ),
        DataColumn(
          label: const Text('Amount'),
          tooltip: 'Total amount and tax',
          numeric: true,
        ),
        DataColumn(
          label: const Text('Order Type'),
          tooltip: 'Price category / service type',
        ),
        DataColumn(
          label: const Text('Items'),
          tooltip: 'Number of items',
          numeric: true,
        ),
        DataColumn(
          label: const Text('Payment'),
          tooltip: 'Payment method used',
        ),
        DataColumn(
          label: const Text('Discount'),
          tooltip: 'Total discount applied',
          numeric: true,
        ),
        const DataColumn(label: Text('Actions'), tooltip: 'Available actions'),
      ],
      rows:
          paginatedSales.map((order) {
            return DataRow(
              onSelectChanged: (_) => _showOrderDetails(order),
              cells: [
                // Order Number
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        order.orderNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      if (order.tokenNumber != null)
                        Text(
                          'Token: ${order.tokenNumber}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Date/Time
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _dateFormat.format(
                          order.completedAt ?? order.orderedAt,
                        ),
                      ),
                      Text(
                        _getRelativeTime(order.completedAt ?? order.orderedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Customer
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        order.customerName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (order.customerPhone != null)
                        Text(
                          order.customerPhone!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Amount
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currencyFormat.format(order.total),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      if (order.taxAmount > 0)
                        Text(
                          'Tax: ${_currencyFormat.format(order.taxAmount)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Order Type (Price Category)
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getOrderTypeColor(
                        order.priceCategoryName ?? order.orderType.displayName,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getOrderTypeColor(
                          order.priceCategoryName ??
                              order.orderType.displayName,
                        ).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      order.priceCategoryName ?? order.orderType.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getOrderTypeColor(
                          order.priceCategoryName ??
                              order.orderType.displayName,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Items Count
                DataCell(
                  Text(
                    order.items.length.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Payment Method
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (order.payments.isNotEmpty) ...[
                        Text(order.payments.first.paymentMethodName),
                        if (order.payments.length > 1)
                          Text(
                            '+${order.payments.length - 1} more',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                      ] else
                        Text(
                          'Not Set',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),

                // Discount
                DataCell(
                  order.discountAmount > 0
                      ? Text(
                        _currencyFormat.format(order.discountAmount),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                      : Text(
                        '₹0.00',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                ),

                // Actions
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _showOrderDetails(order),
                        icon: const Icon(Icons.visibility),
                        tooltip: 'View Details',
                        iconSize: 20,
                      ),
                      IconButton(
                        onPressed: () => _printReceipt(order),
                        icon: const Icon(Icons.print),
                        tooltip: 'Print Receipt',
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildPagination(int totalItems, ThemeData theme) {
    final totalPages = (totalItems / _ordersPerPage).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${(_currentPage * _ordersPerPage) + 1}-${((_currentPage + 1) * _ordersPerPage).clamp(0, totalItems)} of $totalItems orders',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed:
                    _currentPage > 0
                        ? () => setState(() => _currentPage--)
                        : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous page',
              ),
              Text(
                'Page ${_currentPage + 1} of $totalPages',
                style: theme.textTheme.bodyMedium,
              ),
              IconButton(
                onPressed:
                    _currentPage < totalPages - 1
                        ? () => setState(() => _currentPage++)
                        : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next page',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getOrderTypeColor(String orderType) {
    switch (orderType.toLowerCase()) {
      case 'dine-in':
      case 'dine in':
        return Colors.blue;
      case 'parcel':
      case 'takeaway':
        return Colors.orange;
      case 'delivery':
        return Colors.green;
      case 'catering':
        return Colors.purple;
      case 'waiter order':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  void _printReceipt(Order order) {
    // TODO: Implement receipt printing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt printing for order ${order.orderNumber}'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
