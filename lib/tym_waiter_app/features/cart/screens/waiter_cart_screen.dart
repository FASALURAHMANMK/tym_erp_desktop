import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/sales/models/cart_item.dart';
import '../../../../features/sales/models/table.dart';
import '../../orders/providers/waiter_order_provider.dart';
import '../../tables/providers/waiter_table_provider.dart';
import '../providers/waiter_cart_provider.dart';

/// Cart screen for waiter app
class WaiterCartScreen extends ConsumerStatefulWidget {
  final RestaurantTable table;

  const WaiterCartScreen({super.key, required this.table});

  @override
  ConsumerState<WaiterCartScreen> createState() => _WaiterCartScreenState();
}

class _WaiterCartScreenState extends ConsumerState<WaiterCartScreen> {
  static final _logger = Logger('WaiterCartScreen');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(waiterCartNotifierProvider);

    if (cart == null) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cart'),
              Text(widget.table.displayText, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        body: const Center(child: Text('Cart not initialized')),
      );
    }

    final items = cart.items;
    final subtotal = cart.calculatedSubtotal;
    final tax = cart.totalTaxAmount;
    final total = cart.calculatedTotal;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cart'),
            Text(
              '${widget.table.displayText} • ${items.length} items',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(onPressed: _clearCart, child: const Text('Clear')),
        ],
      ),
      body:
          items.isEmpty
              ? _buildEmptyCart(context)
              : Column(
                children: [
                  // Cart items list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _CartItemTile(
                          item: item,
                          onQuantityChanged: (newQuantity) {
                            _updateItemQuantity(item, newQuantity);
                          },
                          onRemove: () => _removeItem(item),
                          onSpecialInstructionsChanged: (instructions) {
                            _updateSpecialInstructions(item, instructions);
                          },
                        );
                      },
                    ),
                  ),
                  // Summary section
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', subtotal),
                        if (tax > 0) _buildSummaryRow('Tax', tax),
                        const Divider(height: 16),
                        _buildSummaryRow('Total', total, isTotal: true),
                      ],
                    ),
                  ),
                ],
              ),
      // Bottom action buttons
      bottomNavigationBar:
          items.isEmpty
              ? null
              : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Row(
                  children: [
                    // Add more items
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add More'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Proceed to actions
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _proceedToActions,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Proceed'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text('Cart is empty', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Add items to continue',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.add),
            label: const Text('Add Items'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    final theme = Theme.of(context);
    final textStyle =
        isTotal
            ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
            : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: textStyle?.copyWith(
              color: isTotal ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  void _updateItemQuantity(CartItem item, double newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(item);
    } else {
      ref
          .read(waiterCartNotifierProvider.notifier)
          .updateItemQuantity(item.id, newQuantity);
    }
  }

  void _removeItem(CartItem item) {
    ref.read(waiterCartNotifierProvider.notifier).removeItem(item.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.productName} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Re-add the item
            ref
                .read(waiterCartNotifierProvider.notifier)
                .addItem(
                  productId: item.productId,
                  variationId: item.variationId,
                  productName: item.productName,
                  variationName: item.variationName,
                  productCode: item.productCode ?? '',
                  sku: item.sku ?? '',
                  unitOfMeasure: item.unitOfMeasure ?? '',
                  categoryId: item.categoryId ?? '',
                  categoryName: item.categoryName ?? '',
                  quantity: item.quantity,
                  unitPrice: item.unitPrice,
                  taxRate: item.taxRate,
                  specialInstructions: item.specialInstructions,
                );
          },
        ),
      ),
    );
  }

  void _updateSpecialInstructions(CartItem item, String instructions) {
    ref
        .read(waiterCartNotifierProvider.notifier)
        .updateSpecialInstructions(
          item.id,
          instructions.isEmpty ? null : instructions,
        );
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text(
              'Are you sure you want to clear all items from the cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  ref.read(waiterCartNotifierProvider.notifier).clearCart();
                  Navigator.pop(context);
                  context.pop(); // Go back to products screen
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _proceedToActions() {
    // Show actions dialog
    _showCartActionsDialog();
  }

  void _showCartActionsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select Action',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Save as draft
                  ListTile(
                    leading: const Icon(Icons.save),
                    title: const Text('Save Order'),
                    subtitle: const Text('Save as draft for later'),
                    onTap: () {
                      Navigator.pop(context);
                      _saveOrder();
                    },
                  ),
                  const Divider(),
                  // Send to kitchen (KOT)
                  ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: const Text('KOT'),
                    subtitle: const Text('Send to kitchen'),
                    onTap: () {
                      Navigator.pop(context);
                      _sendKOT();
                    },
                  ),
                  const Divider(),
                  // Generate bill
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: const Text('Bill'),
                    subtitle: const Text('Generate bill for payment'),
                    onTap: () {
                      Navigator.pop(context);
                      _generateBill();
                    },
                  ),
                  const Divider(),
                  // KOT & Bill
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('KOT & Bill'),
                    subtitle: const Text('Send to kitchen and generate bill'),
                    onTap: () {
                      Navigator.pop(context);
                      _kotAndBill();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
    );
  }

  void _saveOrder() async {
    _logger.info('Saving order as draft');

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create order as draft
      final order =
          await ref.read(waiterOrderNotifierProvider.notifier).saveOrder();

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order saved: ${order.orderNumber}'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the floors provider to show updated table status
      ref.invalidate(waiterFloorsProvider);
      
      context.go('/waiter/tables');
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendKOT() async {
    _logger.info('Sending KOT to kitchen');

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create order as confirmed (KOT)
      final order =
          await ref.read(waiterOrderNotifierProvider.notifier).sendKOT();

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('KOT sent: ${order.orderNumber}'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the floors provider to show updated table status
      ref.invalidate(waiterFloorsProvider);
      
      context.go('/waiter/tables');
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send KOT: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _generateBill() async {
    _logger.info('Generating bill');

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create order as served (Billed)
      final order =
          await ref.read(waiterOrderNotifierProvider.notifier).generateBill();

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill generated: ${order.orderNumber}'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the floors provider to show updated table status
      ref.invalidate(waiterFloorsProvider);
      
      context.go('/waiter/tables');
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate bill: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _kotAndBill() async {
    _logger.info('Sending KOT and generating bill');

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create order as served with KOT
      final order =
          await ref.read(waiterOrderNotifierProvider.notifier).kotAndBill();

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('KOT sent & Bill generated: ${order.orderNumber}'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the floors provider to show updated table status
      ref.invalidate(waiterFloorsProvider);
      
      context.go('/waiter/tables');
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

/// Cart item tile widget
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(double) onQuantityChanged;
  final VoidCallback onRemove;
  final Function(String) onSpecialInstructionsChanged;

  const _CartItemTile({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onSpecialInstructionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (item.variationName != 'Default')
                        Text(
                          item.variationName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${item.unitPrice.toStringAsFixed(2)} × ${item.quantity.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                // Item total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${item.lineTotal.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: onRemove,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
            // Quantity controls
            const SizedBox(height: 8),
            Row(
              children: [
                // Decrease quantity
                IconButton.filled(
                  onPressed: () => onQuantityChanged(item.quantity - 1),
                  icon: const Icon(Icons.remove),
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                // Quantity display
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.quantity.toStringAsFixed(0),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                // Increase quantity
                IconButton.filled(
                  onPressed: () => onQuantityChanged(item.quantity + 1),
                  icon: const Icon(Icons.add),
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                const Spacer(),
                // Special instructions
                TextButton.icon(
                  onPressed:
                      () => _showSpecialInstructionsDialog(
                        context,
                        item,
                        onSpecialInstructionsChanged,
                      ),
                  icon: const Icon(Icons.note_add, size: 18),
                  label: Text(
                    item.specialInstructions != null
                        ? 'Note added'
                        : 'Add note',
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            // Show special instructions if present
            if (item.specialInstructions != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note,
                      size: 16,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.specialInstructions!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSpecialInstructionsDialog(
    BuildContext context,
    CartItem item,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: item.specialInstructions);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Special Instructions'),
            content: TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'E.g., No onions, extra spicy, etc.',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  onSave(controller.text);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
