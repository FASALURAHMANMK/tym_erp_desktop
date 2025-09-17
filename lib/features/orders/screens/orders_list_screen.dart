import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/logger.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../providers/order_provider.dart';
import '../widgets/order_filter_dialog.dart';
import '../widgets/order_status_badge.dart';
import 'order_details_screen.dart';

class OrdersListScreen extends ConsumerStatefulWidget {
  const OrdersListScreen({super.key});

  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen> {
  static final _logger = Logger('OrdersListScreen');

  final _searchController = TextEditingController();
  String _searchQuery = '';
  OrderStatus? _selectedStatus;
  OrderType? _selectedOrderType;
  PaymentStatus? _selectedPaymentStatus;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get filtered orders
    final filter = OrderFilter(
      status: _selectedStatus,
      paymentStatus: _selectedPaymentStatus,
      orderType: _selectedOrderType,
      fromDate: _fromDate,
      toDate: _toDate,
      searchQuery: _searchQuery,
    );

    final ordersAsync = ref.watch(filteredOrdersProvider(filter));
    final statistics = ref.watch(orderStatisticsProvider);

    return Scaffold(
      body: Column(
        children: [
          // Header with statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Column(
              children: [
                // Statistics cards
                Row(
                  children: [
                    _buildStatCard(
                      context,
                      'Today\'s Orders',
                      statistics.todayOrderCount.toString(),
                      Icons.receipt_long,
                      theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      context,
                      'Active Orders',
                      statistics.activeOrderCount.toString(),
                      Icons.pending_actions,
                      Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      context,
                      'Today\'s Revenue',
                      '₹${statistics.todayRevenue.toStringAsFixed(2)}',
                      Icons.monetization_on,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      context,
                      'Average Order',
                      '₹${statistics.averageOrderValue.toStringAsFixed(2)}',
                      Icons.trending_up,
                      Colors.blue,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Search and filters
                Row(
                  children: [
                    // Search field
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search orders...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon:
                              _searchQuery.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                  : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Status filter
                    DropdownButton<OrderStatus?>(
                      value: _selectedStatus,
                      hint: const Text('All Status'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Status'),
                        ),
                        ...OrderStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status.displayName),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      },
                    ),

                    const SizedBox(width: 16),

                    // Order type filter
                    DropdownButton<OrderType?>(
                      value: _selectedOrderType,
                      hint: const Text('All Types'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Types'),
                        ),
                        ...OrderType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedOrderType = value;
                        });
                      },
                    ),

                    const SizedBox(width: 16),

                    // Advanced filters button
                    ElevatedButton.icon(
                      onPressed: _showAdvancedFilters,
                      icon: const Icon(Icons.filter_list),
                      label: const Text('More Filters'),
                    ),

                    const SizedBox(width: 16),

                    // Refresh button
                    IconButton(
                      onPressed: () {
                        ref.invalidate(ordersProvider);
                        ref.invalidate(activeOrdersProvider);
                        ref.invalidate(todaysOrdersProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Orders list
          Expanded(
            child:
                ordersAsync.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters or search query',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: ordersAsync.length,
                      itemBuilder: (context, index) {
                        final order = ordersAsync[index];
                        return _buildOrderCard(context, order);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
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
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(orderId: order.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header row
              Row(
                children: [
                  // Order number and type
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getOrderTypeIcon(order.orderType),
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                order.orderNumber,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (order.tokenNumber != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Token: ${order.tokenNumber}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Status badge
                  OrderStatusBadge(status: order.status),
                ],
              ),

              const SizedBox(height: 12),

              // Customer and items info
              Row(
                children: [
                  // Customer info
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.customerName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (order.customerPhone != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '• ${order.customerPhone}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat.format(order.orderedAt),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Items count
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_basket,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${order.items.length} items',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Total amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${order.total.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Payment status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getPaymentStatusIcon(order.paymentStatus),
                            size: 14,
                            color: _getPaymentStatusColor(order.paymentStatus),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.paymentStatus.displayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getPaymentStatusColor(
                                order.paymentStatus,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Action buttons (if applicable)
              if (order.isActive) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (order.status == OrderStatus.confirmed) ...[
                      OutlinedButton.icon(
                        onPressed:
                            () => _updateOrderStatus(
                              order.id,
                              OrderStatus.preparing,
                            ),
                        icon: const Icon(Icons.restaurant, size: 16),
                        label: const Text('Start Preparing'),
                      ),
                    ],
                    if (order.status == OrderStatus.preparing) ...[
                      OutlinedButton.icon(
                        onPressed:
                            () =>
                                _updateOrderStatus(order.id, OrderStatus.ready),
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: const Text('Mark Ready'),
                      ),
                    ],
                    if (order.status == OrderStatus.ready) ...[
                      if (order.orderType == OrderType.dineIn) ...[
                        OutlinedButton.icon(
                          onPressed:
                              () => _updateOrderStatus(
                                order.id,
                                OrderStatus.served,
                              ),
                          icon: const Icon(Icons.room_service, size: 16),
                          label: const Text('Mark Served'),
                        ),
                      ] else ...[
                        OutlinedButton.icon(
                          onPressed:
                              () => _updateOrderStatus(
                                order.id,
                                OrderStatus.picked,
                              ),
                          icon: const Icon(Icons.shopping_bag, size: 16),
                          label: const Text('Mark Picked'),
                        ),
                      ],
                    ],
                    if (order.status == OrderStatus.served ||
                        order.status == OrderStatus.picked) ...[
                      ElevatedButton.icon(
                        onPressed:
                            () => _updateOrderStatus(
                              order.id,
                              OrderStatus.completed,
                            ),
                        icon: const Icon(Icons.done_all, size: 16),
                        label: const Text('Complete Order'),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
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

  Future<void> _updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await ref
          .read(orderNotifierProvider.notifier)
          .updateOrderStatus(orderId: orderId, newStatus: newStatus);

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

  Future<void> _showAdvancedFilters() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => OrderFilterDialog(
            initialPaymentStatus: _selectedPaymentStatus,
            initialFromDate: _fromDate,
            initialToDate: _toDate,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedPaymentStatus = result['paymentStatus'];
        _fromDate = result['fromDate'];
        _toDate = result['toDate'];
      });
    }
  }
}
