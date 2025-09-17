import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../orders/models/order.dart';
import '../../orders/models/order_status.dart';
import '../../orders/providers/order_provider.dart';
import '../../orders/services/order_business_state_service.dart';
import '../models/price_category.dart';
import '../models/table.dart';
import '../providers/cart_provider.dart';
import '../providers/price_category_provider.dart';
import '../providers/table_provider.dart';
import '../widgets/cart_view.dart';
import '../widgets/product_grid_view.dart';
import '../widgets/table_order_selection_dialog.dart';
import '../widgets/tables_view.dart';

/// Enhanced tables view that shows product listing when table is selected
class EnhancedTablesView extends ConsumerStatefulWidget {
  const EnhancedTablesView({super.key});

  @override
  ConsumerState<EnhancedTablesView> createState() => _EnhancedTablesViewState();
}

class _EnhancedTablesViewState extends ConsumerState<EnhancedTablesView> {
  static final _logger = Logger('EnhancedTablesView');

  String? _selectedFloorId;
  RestaurantTable? _selectedTable;
  bool _showProductView = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);

    return selectedLocationAsync.when(
      data: (selectedLocation) {
        if (selectedBusiness == null || selectedLocation == null) {
          return const Center(
            child: Text('Please select a business and location'),
          );
        }

        // If showing product view for selected table
        if (_showProductView && _selectedTable != null) {
          return _buildTableOrderView(context);
        }

        // Show full-width tables grid view (no cart)
        return Container(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
          child: _buildTablesGridView(
            context,
            selectedBusiness.id,
            selectedLocation.id,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) =>
              Center(child: Text('Error loading location: $error')),
    );
  }

  Widget _buildTablesGridView(
    BuildContext context,
    String businessId,
    String locationId,
  ) {
    final theme = Theme.of(context);
    final floorsAsync = ref.watch(floorsProvider((businessId, locationId)));

    return floorsAsync.when(
      data: (floors) {
        if (floors.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_restaurant,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No floors configured',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please configure floors in Table Management',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Select first floor by default
        if (_selectedFloorId == null && floors.isNotEmpty) {
          _selectedFloorId = floors.first.id;
        }

        final selectedFloor = floors.firstWhere(
          (f) => f.id == _selectedFloorId,
          orElse: () => floors.first,
        );

        return Column(
          children: [
            // Floor selector
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: floors.length,
                itemBuilder: (context, index) {
                  final floor = floors[index];
                  final isSelected = floor.id == _selectedFloorId;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(floor.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFloorId = floor.id;
                          });
                        }
                      },
                      avatar: CircleAvatar(
                        backgroundColor:
                            isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerHighest,
                        child: Text(
                          floor.tables.length.toString(),
                          style: TextStyle(
                            color:
                                isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Tables grid
            Expanded(
              child:
                  selectedFloor.tables.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.table_restaurant,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tables in ${selectedFloor.name}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: selectedFloor.tables.length,
                        itemBuilder: (context, index) {
                          final table = selectedFloor.tables[index];
                          return _buildTableCard(context, table);
                        },
                      ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading tables: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(floorsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildTableCard(BuildContext context, RestaurantTable table) {
    final theme = Theme.of(context);
    final statusColor = Color(
      int.parse(table.statusColorHex.replaceFirst('#', '0xFF')),
    );

    return Card(
      color: statusColor.withValues(alpha: 0.9),
      child: InkWell(
        onTap: () => _onTableTap(context, table),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Table name
              Text(
                table.displayText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Seating capacity
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${table.seatingCapacity}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Status and time
              if (table.status != TableStatus.free) ...[
                const SizedBox(height: 8),
                Text(
                  table.statusText.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (table.occupiedAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _getOccupiedDuration(table.occupiedAt!),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],

              // Current amount
              if (table.currentAmount != null && table.currentAmount! > 0) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${table.currentAmount!.toStringAsFixed(2)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableOrderView(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final selectedLocation =
        ref.watch(selectedLocationNotifierProvider).valueOrNull;

    // Get dine-in price category
    final priceCategoriesAsync = ref.watch(
      visiblePriceCategoriesProvider((
        selectedBusiness!.id,
        selectedLocation!.id,
      )),
    );

    return priceCategoriesAsync.when(
      data: (categories) {
        // Find dine-in price category
        final dineInCategory = categories.firstWhere(
          (cat) => cat.type == PriceCategoryType.dineIn,
          orElse: () => categories.first,
        );

        return Row(
          children: [
            // Product grid with header
            Expanded(
              flex: 60,
              child: Column(
                children: [
                  // Header with table info and back button
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _exitTableOrderView,
                          tooltip: 'Back to Tables',
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.table_restaurant,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Table ${_selectedTable!.displayText}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_selectedTable!.seatingCapacity} Seats',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        const Spacer(),
                        // Add new order button if table is occupied
                        if (_selectedTable!.status == TableStatus.occupied) ...[
                          ElevatedButton.icon(
                            onPressed: _createNewOrderForTable,
                            icon: const Icon(Icons.add),
                            label: const Text('New Order'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Product grid
                  Expanded(
                    child: Container(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      child: ProductGridView(priceCategory: dineInCategory),
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced Cart with table-specific actions
            Expanded(
              flex: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: CartView(
                  showTableActions: true,
                  onTableActionCompleted: _exitTableOrderView,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) =>
              Center(child: Text('Error loading price categories: $error')),
    );
  }

  String _getOccupiedDuration(DateTime occupiedAt) {
    final duration = DateTime.now().difference(occupiedAt);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  void _onTableTap(BuildContext context, RestaurantTable table) async {
    if (table.isFree) {
      // Start new order for this table
      _startNewOrderForTable(context, table);
    } else if (table.status == TableStatus.occupied ||
        table.status == TableStatus.billed) {
      // Load all orders for the table and let the user choose
      await _loadTableOrders(context, table);
    } else {
      // Table is blocked or reserved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Table ${table.displayText} is ${table.statusText}'),
        ),
      );
    }
  }

  void _startNewOrderForTable(BuildContext context, RestaurantTable table) {
    // Set the selected table
    ref.read(selectedTableProvider.notifier).selectTable(table);

    // Clear cart for new order
    ref.read(cartNotifierProvider.notifier).clearCart();

    // Clear any existing order ID to ensure new order is created
    ref.read(cartNotifierProvider.notifier).setOrderId('');

    // Set table in cart
    ref
        .read(cartNotifierProvider.notifier)
        .setTable(tableId: table.id, tableName: table.displayText);

    // Show product view
    setState(() {
      _selectedTable = table;
      _showProductView = true;
    });

    _logger.info('Starting new order for table ${table.displayText}');
  }

  Future<void> _loadTableOrders(
    BuildContext context,
    RestaurantTable table,
  ) async {
    _logger.info('Loading orders for table ${table.displayText}');

    try {
      // Get active orders for this table
      final selectedBusiness = ref.read(selectedBusinessProvider);
      final selectedLocation =
          ref.read(selectedLocationNotifierProvider).valueOrNull;

      if (selectedBusiness == null || selectedLocation == null) {
        _showErrorSnackBar(context, 'Missing business or location');
        return;
      }

      // Load orders for this table
      final orders = await ref
          .read(orderNotifierProvider.notifier)
          .getTableOrders(
            businessId: selectedBusiness.id,
            locationId: selectedLocation.id,
            tableId: table.id,
          );

      if (!context.mounted) return;
      
      // Update table status based on orders using centralized logic
      if (orders.isNotEmpty) {
        final businessState = OrderBusinessStateService.getTableState(orders);
        
        TableStatus newTableStatus;
        switch (businessState) {
          case TableBusinessState.free:
            newTableStatus = TableStatus.free;
            break;
          case TableBusinessState.occupied:
            newTableStatus = TableStatus.occupied;
            break;
          case TableBusinessState.billed:
            newTableStatus = TableStatus.billed;
            break;
          case TableBusinessState.completed:
            newTableStatus = TableStatus.free;
            break;
        }
        
        // Update table status
        ref.read(
          floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier,
        ).updateTableStatus(table.id, newTableStatus);
        
        _logger.info(
          'Updated table ${table.displayText} status to ${newTableStatus.name} based on business state: ${businessState.name}'
        );
      }

      if (orders.isEmpty) {
        // No orders, start fresh
        _startNewOrderForTable(context, table);
      } else if (orders.length == 1) {
        // Single order - check its status
        final order = orders.first;
        // Check if order is billed (served status for dine-in indicates billed)
        // or completed/paid
        if (order.status == OrderStatus.served || 
            order.paymentStatus == PaymentStatus.paid ||
            order.status == OrderStatus.completed) {
          // Show billed order dialog
          _showBilledOrderDialog(context, table, order: order);
        } else {
          // Load the order into cart for editing
          _loadOrderIntoCart(context, table, order);
        }
      } else {
        // Multiple orders, show selection dialog
        final selectedOrder = await TableOrderSelectionDialog.show(
          context,
          table,
          orders,
        );

        if (!context.mounted) return;

        if (selectedOrder != null) {
          if (selectedOrder.action == OrderAction.createNew) {
            _startNewOrderForTable(context, table);
          } else if (selectedOrder.selectedOrder != null) {
            final order = selectedOrder.selectedOrder!;
            // Check if order is billed (served status indicates billed) or completed/paid
            if (order.status == OrderStatus.served ||
                order.paymentStatus == PaymentStatus.paid ||
                order.status == OrderStatus.completed) {
              // Show billed order dialog
              _showBilledOrderDialog(context, table, order: order);
            } else {
              // Load the order into cart for editing
              _loadOrderIntoCart(context, table, order);
            }
          }
        }
      }
    } catch (e) {
      _logger.error('Error loading table orders', e);
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to load orders');
      }
    }
  }

  void _loadOrderIntoCart(
    BuildContext context,
    RestaurantTable table,
    Order order,
  ) async {
    // Set the selected table first
    ref.read(selectedTableProvider.notifier).selectTable(table);

    // Get cart notifier
    final cartNotifier = ref.read(cartNotifierProvider.notifier);

    // Don't clear items yet - we'll add them directly

    // Set order ID first
    cartNotifier.setOrderId(order.id);

    // Set table context
    cartNotifier.setTable(tableId: table.id, tableName: table.displayText);

    // Set customer if available
    if (order.customerId.isNotEmpty) {
      cartNotifier.setCustomer(
        customerId: order.customerId,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
      );
    } else {
      // Set walk-in customer if no customer in order
      cartNotifier.setCustomer(
        customerId: '',
        customerName: 'Walk-in Customer',
        customerPhone: '',
      );
    }

    // Clear items AFTER setting all context to avoid state issues
    cartNotifier.clearItems();

    // Add small delay to ensure state is ready
    await Future.delayed(const Duration(milliseconds: 50));

    // Load order items into cart
    for (final item in order.items) {
      cartNotifier.addItemFromOrder(
        orderItemId: item.id,  // Pass the original order item ID
        productId: item.productId,
        variationId: item.variationId,
        productName: item.productName,
        variationName: item.variationName,
        quantity: item.quantity.toInt(),
        unitPrice: item.unitPrice,
        taxRate: item.taxRate,
        discountAmount: item.discountAmount,
        specialInstructions: item.specialInstructions,
      );
    }

    // Add another small delay to ensure items are added
    await Future.delayed(const Duration(milliseconds: 100));

    // Log the current cart state BEFORE showing product view
    var currentCart = ref.read(cartNotifierProvider);
    _logger.info(
      'Before showing view - Cart has ${currentCart?.items.length ?? 0} items',
    );
    _logger.info('Cart order ID: ${currentCart?.orderId}');

    // Show product view
    setState(() {
      _selectedTable = table;
      _showProductView = true;
    });

    // Wait a bit and check again
    await Future.delayed(const Duration(milliseconds: 200));

    // Log the current cart state for debugging
    currentCart = ref.read(cartNotifierProvider);
    _logger.info('Loaded order ${order.id} for table ${table.displayText}');
    _logger.info(
      'Cart has ${currentCart?.items.length ?? 0} items after loading',
    );
    _logger.info('Cart isEmpty: ${currentCart?.isEmpty ?? true}');
    _logger.info('Cart order ID still set: ${currentCart?.orderId}');
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBilledOrderDialog(
    BuildContext context,
    RestaurantTable table, {
    Order? order,
  }) {
    final orderAmount = order?.total ?? table.currentAmount ?? 0;
    final orderNumber = order?.orderNumber ?? 'N/A';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Table ${table.displayText} - Billed'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order: #$orderNumber',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Amount: ₹${orderAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This order has been billed and is awaiting payment.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (order != null && context.mounted) {
                    // Mark order as paid
                    await _markOrderAsPaid(context, order);
                  }
                  if (context.mounted) {
                    // Mark table as free
                    _markTableAsFree(context, table);
                  }
                },
                child: const Text('Mark as Paid'),
              ),
            ],
          ),
    );
  }

  Future<void> _markOrderAsPaid(BuildContext context, Order order) async {
    try {
      // Update order status to completed and payment status to paid
      await ref
          .read(orderNotifierProvider.notifier)
          .updateOrderStatus(
            orderId: order.id,
            newStatus: OrderStatus.completed,
            reason: 'Marked as paid from table view',
          );

      // TODO: Update payment status when payment model is implemented

      _logger.info('Order ${order.orderNumber} marked as paid');
    } catch (e) {
      _logger.error('Error marking order as paid', e);
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to mark order as paid');
      }
    }
  }

  void _markTableAsFree(BuildContext context, RestaurantTable table) async {
    final selectedBusiness = ref.read(selectedBusinessProvider);
    final selectedLocation =
        ref.read(selectedLocationNotifierProvider).valueOrNull;

    if (selectedBusiness != null && selectedLocation != null) {
      // Check if there are other active orders for this table
      try {
        final orders = await ref
            .read(orderNotifierProvider.notifier)
            .getTableOrders(
              businessId: selectedBusiness.id,
              locationId: selectedLocation.id,
              tableId: table.id,
            );
        
        // Use centralized business state logic to determine table status
        final businessState = OrderBusinessStateService.getTableState(orders);
        
        TableStatus newTableStatus;
        String statusMessage;
        Color statusColor;
        
        switch (businessState) {
          case TableBusinessState.free:
          case TableBusinessState.completed:
            newTableStatus = TableStatus.free;
            statusMessage = 'Table ${table.displayText} is now free';
            statusColor = Colors.green;
            break;
          case TableBusinessState.occupied:
            newTableStatus = TableStatus.occupied;
            statusMessage = 'Table ${table.displayText} still has active orders';
            statusColor = Colors.orange;
            break;
          case TableBusinessState.billed:
            newTableStatus = TableStatus.billed;
            statusMessage = 'Table ${table.displayText} still has billed orders';
            statusColor = Colors.amber;
            break;
        }
        
        // Update table status
        ref
            .read(
              floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier,
            )
            .updateTableStatus(table.id, newTableStatus);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(statusMessage),
              backgroundColor: statusColor,
            ),
          );
        }
      } catch (e) {
        _logger.error('Error checking table orders', e);
        // If error, just mark as free
        ref
            .read(
              floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier,
            )
            .updateTableStatus(table.id, TableStatus.free);
      }
    }
  }

  void _exitTableOrderView() {
    setState(() {
      _showProductView = false;
      _selectedTable = null;
    });

    // Clear selected table
    ref.read(selectedTableProvider.notifier).clearTable();
  }

  void _createNewOrderForTable() {
    // Clear cart for new order but keep table selected
    ref.read(cartNotifierProvider.notifier).clearCart();

    // Important: Clear the order ID to ensure a new order is created
    ref.read(cartNotifierProvider.notifier).setOrderId('');

    // Set table in cart again
    ref
        .read(cartNotifierProvider.notifier)
        .setTable(
          tableId: _selectedTable!.id,
          tableName: _selectedTable!.displayText,
        );

    // Set default walk-in customer for new order
    ref.read(cartNotifierProvider.notifier).setCustomer(
      customerId: '',
      customerName: 'Walk-in Customer',
      customerPhone: '',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Starting new order for table ${_selectedTable!.displayText}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
