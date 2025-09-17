import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/sales/models/table.dart';
import '../../auth/providers/waiter_auth_provider.dart';
import '../../cart/providers/waiter_cart_provider.dart';
import '../../orders/providers/waiter_order_provider.dart';
import '../providers/waiter_location_provider.dart';
import '../providers/waiter_table_provider.dart';
import '../widgets/table_card.dart';
import '../widgets/floor_selector.dart';
import '../widgets/order_selection_dialog.dart';

/// Main tables screen for waiter app
/// Shows all tables with real-time status updates
class TableListScreen extends ConsumerStatefulWidget {
  const TableListScreen({super.key});

  @override
  ConsumerState<TableListScreen> createState() => _TableListScreenState();
}

class _TableListScreenState extends ConsumerState<TableListScreen> {
  static final _logger = Logger('TableListScreen');
  String? _selectedFloorId;
  TableStatus? _filterStatus;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentWaiter = ref.watch(currentWaiterProvider);
    
    if (currentWaiter == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login to view tables'),
        ),
      );
    }
    
    // Get location from waiter's context
    final locationAsync = ref.watch(waiterLocationNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
        actions: [
          // Filter dropdown
          PopupMenuButton<TableStatus?>(
            icon: Icon(
              Icons.filter_list,
              color: _filterStatus != null ? theme.colorScheme.primary : null,
            ),
            onSelected: (status) {
              setState(() {
                _filterStatus = status;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Tables'),
              ),
              const PopupMenuItem(
                value: TableStatus.free,
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text('Free'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TableStatus.occupied,
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Occupied'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TableStatus.billed,
                child: Row(
                  children: [
                    Icon(Icons.receipt, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text('Billed'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TableStatus.reserved,
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text('Reserved'),
                  ],
                ),
              ),
            ],
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(waiterFloorsProvider);
            },
          ),
        ],
      ),
      body: locationAsync.when(
        data: (location) {
          if (location == null) {
            return const Center(
              child: Text('No location assigned. Please contact your manager.'),
            );
          }
          
          // Use the waiter-specific floors provider
          final floorsAsync = ref.watch(waiterFloorsProvider);
          
          return floorsAsync.when(
            data: (floors) {
              if (floors.isEmpty) {
                return _buildEmptyState(context);
              }
              
              // Select first floor by default
              if (_selectedFloorId == null && floors.isNotEmpty) {
                _selectedFloorId = floors.first.id;
              }
              
              final selectedFloor = floors.firstWhere(
                (f) => f.id == _selectedFloorId,
                orElse: () => floors.first,
              );
              
              // Filter tables based on status
              final tables = _filterStatus != null
                  ? selectedFloor.tables.where((t) => t.status == _filterStatus).toList()
                  : selectedFloor.tables;
              
              return Column(
                children: [
                  // Floor selector
                  FloorSelector(
                    floors: floors,
                    selectedFloorId: selectedFloor.id,
                    onFloorSelected: (floorId) {
                      setState(() {
                        _selectedFloorId = floorId;
                      });
                    },
                  ),
                  
                  // Stats bar
                  _buildStatsBar(selectedFloor),
                  
                  // Tables grid
                  Expanded(
                    child: tables.isEmpty
                        ? Center(
                            child: Text(
                              _filterStatus != null
                                  ? 'No ${_getStatusText(_filterStatus!)} tables'
                                  : 'No tables on this floor',
                              style: theme.textTheme.bodyLarge,
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              ref.invalidate(waiterFloorsProvider);
                            },
                            child: GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: tables.length,
                              itemBuilder: (context, index) {
                                final table = tables[index];
                                return TableCard(
                                  table: table,
                                  onTap: () => _handleTableTap(table),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading tables: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(waiterFloorsProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading location: $error'),
        ),
      ),
    );
  }
  
  Widget _buildStatsBar(Floor floor) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total',
            floor.totalTables.toString(),
            Colors.blue,
          ),
          _buildStatItem(
            'Free',
            floor.freeTables.toString(),
            Colors.green,
          ),
          _buildStatItem(
            'Occupied',
            floor.occupiedTables.toString(),
            Colors.red,
          ),
          _buildStatItem(
            'Billed',
            floor.billedTables.toString(),
            Colors.orange,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_restaurant,
            size: 120,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No Tables Available',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tables have not been configured for this location.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Please contact your manager to set up tables.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleTableTap(RestaurantTable table) {
    _logger.info('Table tapped: ${table.tableName} with status ${table.status}');
    
    // Set the selected table in the provider
    ref.read(waiterSelectedTableProvider.notifier).state = table;
    
    // Clear cart when switching tables
    ref.read(waiterCartNotifierProvider.notifier).clearCart();
    
    // Handle navigation based on table status
    switch (table.status) {
      case TableStatus.free:
        _handleFreeTable(table);
        break;
      case TableStatus.occupied:
        _handleOccupiedTable(table);
        break;
      case TableStatus.billed:
        _handleBilledTable(table);
        break;
      case TableStatus.blocked:
      case TableStatus.reserved:
        _showTableUnavailable(table);
        break;
    }
  }
  
  void _handleFreeTable(RestaurantTable table) {
    _logger.info('Starting new order for free table: ${table.tableName}');
    
    // Set selected table and clear cart
    ref.read(waiterSelectedTableProvider.notifier).state = table;
    ref.read(waiterCartNotifierProvider.notifier).clearCart();
    
    // Navigate to product selection screen
    context.push('/waiter/tables/${table.id}/products', extra: table);
  }
  
  void _handleOccupiedTable(RestaurantTable table) async {
    _logger.info('Loading existing orders for occupied table: ${table.tableName}');
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Fetch orders for this table
      final orders = await ref.read(
        waiterTableOrdersProvider(table.id).future,
      );

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      if (orders.isEmpty) {
        // No orders found, start new order
        _handleFreeTable(table);
      } else if (orders.length == 1) {
        // Single order, load it directly
        _loadOrderToCart(table, orders.first);
      } else {
        // Multiple orders, show selection dialog
        showDialog(
          context: context,
          builder: (context) => OrderSelectionDialog(
            table: table,
            orders: orders,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading if still showing
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading orders: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _loadOrderToCart(RestaurantTable table, dynamic order) {
    _logger.info('Loading order ${order.orderNumber} to cart');
    
    // Set table
    ref.read(waiterSelectedTableProvider.notifier).state = table;
    
    // Navigate to products screen
    // The order selection dialog handles loading the order items
    context.push('/waiter/tables/${table.id}/products', extra: table);
  }
  
  void _handleBilledTable(RestaurantTable table) {
    _logger.info('Table ${table.tableName} is already billed');
    
    // Show payment dialog or view-only mode
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table ${table.tableName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            const Text('This table has been billed and is awaiting payment.'),
            if (table.currentAmount != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Amount: ₹${table.currentAmount!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to payment screen
              context.push('/waiter/tables/${table.id}/payment', extra: table);
            },
            child: const Text('Process Payment'),
          ),
        ],
      ),
    );
  }
  
  void _showTableUnavailable(RestaurantTable table) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Table ${table.tableName} is ${_getStatusText(table.status).toLowerCase()}'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  String _getStatusText(TableStatus status) {
    switch (status) {
      case TableStatus.free:
        return 'Free';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.billed:
        return 'Billed';
      case TableStatus.blocked:
        return 'Blocked';
      case TableStatus.reserved:
        return 'Reserved';
    }
  }
}