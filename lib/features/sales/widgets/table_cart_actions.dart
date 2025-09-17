import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../auth/providers/auth_provider.dart';
import '../../business/providers/business_provider.dart';
import '../../customers/models/customer.dart';
import '../../customers/providers/customer_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../orders/models/order_status.dart';
import '../../orders/providers/order_provider.dart';
import '../../orders/services/order_business_state_service.dart';
import '../../payments/widgets/checkout_dialog.dart';
import '../models/cart.dart';
import '../models/table.dart';
import '../providers/cart_provider.dart';
import '../providers/price_category_provider.dart';
import '../providers/table_provider.dart';
import '../widgets/tables_view.dart';

/// Simplified table-specific action buttons for cart
class TableCartActions extends ConsumerWidget {
  static final _logger = Logger('TableCartActions');

  final VoidCallback? onActionCompleted;

  const TableCartActions({
    super.key,
    this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartNotifierProvider);
    final selectedTable = ref.watch(selectedTableProvider);

    if (cart == null || cart.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Primary actions row
        Row(
          children: [
            // Save button (for now, just complete without payment)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _saveOrder(context, ref, cart, selectedTable),
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // KOT button (placeholder for now)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _printKOT(context, ref, cart, selectedTable),
                icon: const Icon(Icons.print),
                label: const Text('KOT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Secondary actions row
        Row(
          children: [
            // Bill button (placeholder for now)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _printBill(context, ref, cart, selectedTable),
                icon: const Icon(Icons.receipt),
                label: const Text('Bill'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // KOT & Bill button (placeholder for now)
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    () => _printKOTAndBill(context, ref, cart, selectedTable),
                icon: const Icon(Icons.done_all),
                label: const Text('KOT & Bill'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Complete order button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _completeOrder(context, ref, cart, selectedTable),
            icon: const Icon(Icons.check_circle),
            label: const Text('Complete Order'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Save order as draft
  Future<void> _saveOrder(
    BuildContext context,
    WidgetRef ref,
    Cart cart,
    RestaurantTable? table,
  ) async {
    _logger.info('Saving draft order for table ${table?.displayText}');

    if (table == null) {
      _showErrorSnackBar(context, 'No table selected');
      return;
    }

    try {
      // Get required data
      final selectedBusiness = ref.read(selectedBusinessProvider);
      final selectedLocation =
          ref.read(selectedLocationNotifierProvider).valueOrNull;
      final selectedPosDevice = ref.read(selectedPOSDeviceProvider);
      final currentUser = ref.read(currentUserProvider);
      final selectedCustomer = ref.read(selectedCustomerProvider);

      if (selectedBusiness == null ||
          selectedLocation == null ||
          selectedPosDevice == null ||
          currentUser == null) {
        _showErrorSnackBar(context, 'Missing required data');
        return;
      }

      // Get customer from cart or use walk-in customer
      final customer =
          selectedCustomer ??
          Customer(
            id: '',
            businessId: selectedBusiness.id,
            customerCode: 'WALK-IN',
            name: cart.customerName ?? 'Walk-in Customer',
            phone: cart.customerPhone ?? '',
            email: '',
            customerType: 'walk_in',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

      // Check if we're updating an existing order or creating new
      final existingOrderId = cart.orderId;

      if (existingOrderId != null) {
        // Update existing order
        await ref
            .read(orderNotifierProvider.notifier)
            .updateOrderItems(
              orderId: existingOrderId,
              cart: cart,
              userId: currentUser.id,
              userName: currentUser.email ?? 'Unknown',
            );
        _logger.info('Updated existing order: $existingOrderId');
      } else {
        // Create new order
        // Get the dine-in price category name for reporting
        final selectedPriceCategory = ref.read(selectedPriceCategoryProvider);
        final priceCategoryName = selectedPriceCategory?.name ?? 'Dine-In';
        
        final order = await ref
            .read(orderNotifierProvider.notifier)
            .createOrderFromCart(
              cart: cart,
              customer: customer,
              businessId: selectedBusiness.id,
              locationId: selectedLocation.id,
              posDeviceId: selectedPosDevice.id,
              userId: currentUser.id,
              userName: currentUser.email ?? 'Unknown',
              orderType: OrderType.dineIn,
              priceCategoryName: priceCategoryName,
              tableId: table.id,
              tableName: table.displayText,
              orderStatus: OrderStatus.draft,
              isDraft: true,
            );

        if (order != null) {
          _logger.info('Created new draft order: ${order.id}');
          // Update table with order ID
          _updateTableStatus(
            ref,
            table,
            TableStatus.occupied,
            orderId: order.id,
          );
        } else {
          _showErrorSnackBar(context, 'Failed to save order');
          return;
        }
      }

      // Clear cart after successful save
      ref.read(cartNotifierProvider.notifier).clearCart();
      _showSuccessSnackBar(
        context,
        'Order saved for table ${table.displayText}',
      );
      
      // Navigate back to tables screen after successful action
      if (onActionCompleted != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          onActionCompleted!();
        });
      }
    } catch (e) {
      _logger.error('Error saving order', e);
      _showErrorSnackBar(context, 'Failed to save order');
    }
  }

  /// Print KOT and save order as confirmed
  Future<void> _printKOT(
    BuildContext context,
    WidgetRef ref,
    Cart cart,
    RestaurantTable? table,
  ) async {
    _logger.info('Printing KOT for table ${table?.displayText}');

    if (table == null) {
      _showErrorSnackBar(context, 'No table selected');
      return;
    }

    try {
      // Get required data
      final selectedBusiness = ref.read(selectedBusinessProvider);
      final selectedLocation =
          ref.read(selectedLocationNotifierProvider).valueOrNull;
      final selectedPosDevice = ref.read(selectedPOSDeviceProvider);
      final currentUser = ref.read(currentUserProvider);
      final selectedCustomer = ref.read(selectedCustomerProvider);

      if (selectedBusiness == null ||
          selectedLocation == null ||
          selectedPosDevice == null ||
          currentUser == null) {
        _showErrorSnackBar(context, 'Missing required data');
        return;
      }

      // Get customer from cart or use walk-in customer
      final customer =
          selectedCustomer ??
          Customer(
            id: '',
            businessId: selectedBusiness.id,
            customerCode: 'WALK-IN',
            name: cart.customerName ?? 'Walk-in Customer',
            phone: cart.customerPhone ?? '',
            email: '',
            customerType: 'walk_in',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

      // Check if we're updating an existing order or creating new
      final existingOrderId = cart.orderId;

      if (existingOrderId != null) {
        // Update existing order and mark KOT printed
        await ref
            .read(orderNotifierProvider.notifier)
            .updateOrderItems(
              orderId: existingOrderId,
              cart: cart,
              userId: currentUser.id,
              userName: currentUser.email ?? 'Unknown',
            );
        await ref
            .read(orderNotifierProvider.notifier)
            .updateOrderStatus(
              orderId: existingOrderId,
              newStatus: OrderStatus.confirmed,
            );
        _logger.info('Updated existing order with KOT: $existingOrderId');
      } else {
        // Create new confirmed order with KOT
        // Get the dine-in price category name for reporting
        final selectedPriceCategory = ref.read(selectedPriceCategoryProvider);
        final priceCategoryName = selectedPriceCategory?.name ?? 'Dine-In';
        
        final order = await ref
            .read(orderNotifierProvider.notifier)
            .createOrderFromCart(
              cart: cart,
              customer: customer,
              businessId: selectedBusiness.id,
              locationId: selectedLocation.id,
              posDeviceId: selectedPosDevice.id,
              userId: currentUser.id,
              userName: currentUser.email ?? 'Unknown',
              orderType: OrderType.dineIn,
              priceCategoryName: priceCategoryName,
              tableId: table.id,
              tableName: table.displayText,
              orderStatus: OrderStatus.confirmed,
              isDraft: false,
            );

        if (order != null) {
          _logger.info('Created new order with KOT: ${order.id}');
          // Update table with order ID
          _updateTableStatus(
            ref,
            table,
            TableStatus.occupied,
            orderId: order.id,
          );
        } else {
          _showErrorSnackBar(context, 'Failed to create order');
          return;
        }
      }

      // TODO: Send KOT to printer

      // Clear cart after successful KOT
      ref.read(cartNotifierProvider.notifier).clearCart();
      _showSuccessSnackBar(context, 'KOT sent for table ${table.displayText}');
      
      // Navigate back to tables screen after successful action
      if (onActionCompleted != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          onActionCompleted!();
        });
      }
    } catch (e) {
      _logger.error('Error printing KOT', e);
      _showErrorSnackBar(context, 'Failed to send KOT');
    }
  }

  /// Print bill and mark order as billed
  Future<void> _printBill(
    BuildContext context,
    WidgetRef ref,
    Cart cart,
    RestaurantTable? table,
  ) async {
    _logger.info('Printing bill for table ${table?.displayText}');

    if (table == null) {
      _showErrorSnackBar(context, 'No table selected');
      return;
    }

    try {
      // Get the current order ID from cart
      final orderId = cart.orderId;

      if (orderId == null || orderId.isEmpty) {
        // No existing order, create a new one for billing
        _logger.info('Creating new order for billing');
        
        // Get required data
        final selectedBusiness = ref.read(selectedBusinessProvider);
        final selectedLocation =
            ref.read(selectedLocationNotifierProvider).valueOrNull;
        final selectedPosDevice = ref.read(selectedPOSDeviceProvider);
        final currentUser = ref.read(currentUserProvider);
        final selectedCustomer = ref.read(selectedCustomerProvider);

        if (selectedBusiness == null ||
            selectedLocation == null ||
            selectedPosDevice == null ||
            currentUser == null) {
          _showErrorSnackBar(context, 'Missing required data');
          return;
        }

        // Get customer from cart or use walk-in customer
        final customer =
            selectedCustomer ??
            Customer(
              id: '',
              businessId: selectedBusiness.id,
              customerCode: 'WALK-IN',
              name: cart.customerName ?? 'Walk-in Customer',
              phone: cart.customerPhone ?? '',
              email: '',
              customerType: 'walk_in',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

        // Create new order as draft first, then mark as billed
        // Get the dine-in price category name for reporting
        final selectedPriceCategory = ref.read(selectedPriceCategoryProvider);
        final priceCategoryName = selectedPriceCategory?.name ?? 'Dine-In';
        
        final order = await ref
            .read(orderNotifierProvider.notifier)
            .createOrderFromCart(
              cart: cart,
              customer: customer,
              businessId: selectedBusiness.id,
              locationId: selectedLocation.id,
              posDeviceId: selectedPosDevice.id,
              userId: currentUser.id,
              userName: currentUser.email ?? 'Unknown',
              orderType: OrderType.dineIn,
              priceCategoryName: priceCategoryName,
              tableId: table.id,
              tableName: table.displayText,
            );

        if (order != null) {
          _logger.info('Created new order for billing: ${order.id}');
          
          // Now update it to served status (billed)
          await ref
              .read(orderNotifierProvider.notifier)
              .updateOrderStatus(
                orderId: order.id,
                newStatus: OrderStatus.served,
                reason: 'Bill printed',
              );
          
          _logger.info('Updated order to served status (billed): ${order.id}');
          
          // Since we just created a billed order, table should be billed
          _updateTableStatus(ref, table, TableStatus.billed);
        } else {
          _showErrorSnackBar(context, 'Failed to create order for billing');
          return;
        }
      } else {
        // Update existing order to served status
        await ref
            .read(orderNotifierProvider.notifier)
            .updateOrderStatus(
              orderId: orderId,
              newStatus: OrderStatus.served,
              reason: 'Bill printed',
            );

        _logger.info('Order $orderId marked as billed');
        
        // Check if there are other active orders for this table
        final selectedBusiness = ref.read(selectedBusinessProvider);
        final selectedLocation =
            ref.read(selectedLocationNotifierProvider).valueOrNull;

        if (selectedBusiness != null && selectedLocation != null) {
          final orders = await ref
              .read(orderNotifierProvider.notifier)
              .getTableOrders(
                businessId: selectedBusiness.id,
                locationId: selectedLocation.id,
                tableId: table.id,
              );

          // Filter out the order we just updated to get remaining orders
          final remainingOrders = orders.where((o) => o.id != orderId).toList();
          
          // For business state calculation, we need to simulate the updated order status
          // Since we just updated it to served status, we assume it's now billed
          final updatedOrders = [...remainingOrders];
          
          // Add a served status order to represent the just-updated order
          final updatedOrder = orders.firstWhere((o) => o.id == orderId);
          final orderWithServedStatus = updatedOrder.copyWith(
            status: OrderStatus.served, // This is the updated status
          );
          updatedOrders.add(orderWithServedStatus);

          // Use centralized business state logic
          final businessState = OrderBusinessStateService.getTableState(updatedOrders);
          
          switch (businessState) {
            case TableBusinessState.free:
              _updateTableStatus(ref, table, TableStatus.free);
              break;
            case TableBusinessState.occupied:
              _updateTableStatus(ref, table, TableStatus.occupied);
              break;
            case TableBusinessState.billed:
              _updateTableStatus(ref, table, TableStatus.billed);
              break;
            case TableBusinessState.completed:
              _updateTableStatus(ref, table, TableStatus.free);
              break;
          }
        }
      }

      // Clear cart
      ref.read(cartNotifierProvider.notifier).clearCart();

      // TODO: Actually print the bill

      _showSuccessSnackBar(
        context,
        'Bill printed for table ${table.displayText}',
      );
      
      // Navigate back to tables screen after successful action
      if (onActionCompleted != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          onActionCompleted!();
        });
      }
    } catch (e) {
      _logger.error('Error printing bill', e);
      _showErrorSnackBar(context, 'Failed to print bill');
    }
  }

  /// Print both KOT and Bill
  Future<void> _printKOTAndBill(
    BuildContext context,
    WidgetRef ref,
    Cart cart,
    RestaurantTable? table,
  ) async {
    _logger.info('Printing KOT and Bill for table ${table?.displayText}');

    if (table == null) {
      _showErrorSnackBar(context, 'No table selected');
      return;
    }

    try {
      // Get required data
      final selectedBusiness = ref.read(selectedBusinessProvider);
      final selectedLocation =
          ref.read(selectedLocationNotifierProvider).valueOrNull;
      final selectedPosDevice = ref.read(selectedPOSDeviceProvider);
      final currentUser = ref.read(currentUserProvider);
      final selectedCustomer = ref.read(selectedCustomerProvider);

      if (selectedBusiness == null ||
          selectedLocation == null ||
          selectedPosDevice == null ||
          currentUser == null) {
        _showErrorSnackBar(context, 'Missing required data');
        return;
      }

      // Get customer from cart or use walk-in customer
      final customer =
          selectedCustomer ??
          Customer(
            id: '',
            businessId: selectedBusiness.id,
            customerCode: 'WALK-IN',
            name: cart.customerName ?? 'Walk-in Customer',
            phone: cart.customerPhone ?? '',
            email: '',
            customerType: 'walk_in',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

      // Check if we're updating an existing order or creating new
      final existingOrderId = cart.orderId;

      if (existingOrderId != null && existingOrderId.isNotEmpty) {
        // Update existing order to served status (billed)
        await ref
            .read(orderNotifierProvider.notifier)
            .updateOrderStatus(
              orderId: existingOrderId,
              newStatus: OrderStatus.served,
              reason: 'KOT sent and bill printed',
            );
        _logger.info('Updated existing order with KOT & Bill: $existingOrderId');
      } else {
        // Create new order as draft first
        // Get the dine-in price category name for reporting
        final selectedPriceCategory = ref.read(selectedPriceCategoryProvider);
        final priceCategoryName = selectedPriceCategory?.name ?? 'Dine-In';
        
        final order = await ref
            .read(orderNotifierProvider.notifier)
            .createOrderFromCart(
              cart: cart,
              customer: customer,
              businessId: selectedBusiness.id,
              locationId: selectedLocation.id,
              posDeviceId: selectedPosDevice.id,
              userId: currentUser.id,
              userName: currentUser.email ?? 'Unknown',
              orderType: OrderType.dineIn,
              priceCategoryName: priceCategoryName,
              tableId: table.id,
              tableName: table.displayText,
            );

        if (order != null) {
          _logger.info('Created new order: ${order.id}');
          
          // Now update it to served status (billed)
          await ref
              .read(orderNotifierProvider.notifier)
              .updateOrderStatus(
                orderId: order.id,
                newStatus: OrderStatus.served,
                reason: 'KOT sent and bill printed',
              );
          
          _logger.info('Updated order to served status: ${order.id}');
        } else {
          _showErrorSnackBar(context, 'Failed to create order');
          return;
        }
      }

      // Update table status to billed
      _updateTableStatus(ref, table, TableStatus.billed);

      // Clear cart
      ref.read(cartNotifierProvider.notifier).clearCart();

      // TODO: Send KOT to printer
      // TODO: Print bill

      _showSuccessSnackBar(
        context,
        'KOT sent and bill printed for table ${table.displayText}',
      );
      
      // Navigate back to tables screen after successful action
      if (onActionCompleted != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          onActionCompleted!();
        });
      }
    } catch (e) {
      _logger.error('Error printing KOT and Bill', e);
      _showErrorSnackBar(context, 'Failed to send KOT and print bill');
    }
  }

  /// Complete order with payment
  Future<void> _completeOrder(
    BuildContext context,
    WidgetRef ref,
    Cart cart,
    RestaurantTable? table,
  ) async {
    // Show checkout dialog
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CheckoutDialog(cart: cart),
    );

    if (result != null) {
      _logger.info('Order completed');

      // Add a small delay to ensure order status update has completed
      await Future.delayed(const Duration(milliseconds: 100));

      // Check if there are other active orders for this table
      if (table != null) {
        final selectedBusiness = ref.read(selectedBusinessProvider);
        final selectedLocation =
            ref.read(selectedLocationNotifierProvider).valueOrNull;

        if (selectedBusiness != null && selectedLocation != null) {
          // Get all orders for this table
          final orders = await ref
              .read(orderNotifierProvider.notifier)
              .getTableOrders(
                businessId: selectedBusiness.id,
                locationId: selectedLocation.id,
                tableId: table.id,
              );

          _logger.info('Found ${orders.length} orders for table ${table.displayText}');
          
          // Log order details for debugging
          for (final order in orders) {
            _logger.info('Order ${order.orderNumber}: status=${order.status.value}, id=${order.id}');
          }

          // Use centralized business state logic to determine table status
          final businessState = OrderBusinessStateService.getTableState(orders);
          
          switch (businessState) {
            case TableBusinessState.free:
              _updateTableStatus(ref, table, TableStatus.free);
              _logger.info(
                'Table ${table.displayText} has no more active orders, marking as free',
              );
              break;
            case TableBusinessState.occupied:
              _updateTableStatus(ref, table, TableStatus.occupied);
              _logger.info(
                'Table ${table.displayText} still has active orders, keeping as occupied',
              );
              break;
            case TableBusinessState.billed:
              _updateTableStatus(ref, table, TableStatus.billed);
              _logger.info(
                'Table ${table.displayText} has billed orders, marking as billed',
              );
              break;
            case TableBusinessState.completed:
              _updateTableStatus(ref, table, TableStatus.free);
              _logger.info(
                'Table ${table.displayText} orders completed, marking as free',
              );
              break;
          }
        }
      }

      _showSuccessSnackBar(
        context,
        'Order completed for table ${table?.displayText}',
      );
    }
  }

  /// Update table status
  void _updateTableStatus(
    WidgetRef ref,
    RestaurantTable table,
    TableStatus status, {
    String? orderId,
  }) {
    final selectedBusiness = ref.read(selectedBusinessProvider);
    final selectedLocation =
        ref.read(selectedLocationNotifierProvider).valueOrNull;

    if (selectedBusiness != null && selectedLocation != null) {
      ref
          .read(
            floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier,
          )
          .updateTableStatus(table.id, status, orderId: orderId);
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
}
