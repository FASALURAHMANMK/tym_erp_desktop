import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../business/providers/business_provider.dart';
import '../../charges/models/charge.dart';
import '../../customers/models/customer.dart';
import '../../customers/providers/customer_provider.dart';
import '../../customers/widgets/customer_selector.dart';
import '../../payments/widgets/checkout_dialog.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/discount_provider.dart';
import 'cart_charges_section.dart';
import 'item_detail_dialog.dart';
import 'table_cart_actions.dart';

class CartView extends ConsumerStatefulWidget {
  final bool showTableActions;
  final VoidCallback? onTableActionCompleted;
  
  const CartView({
    super.key,
    this.showTableActions = false,
    this.onTableActionCompleted,
  });

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  static final _logger = Logger('CartView');

  @override
  void initState() {
    super.initState();
    // Set walk-in customer as default when cart is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaultCustomer();
    });
  }

  Future<void> _setDefaultCustomer() async {
    final cart = ref.read(cartNotifierProvider);
    
    // Only set default customer if cart doesn't already have one or an order context
    if (cart?.customerId == null || cart!.customerId!.isEmpty) {
      // Also skip if cart has an order ID (loaded from existing order)
      if (cart?.orderId != null && cart!.orderId!.isNotEmpty) {
        _logger.info('Cart has existing order context, skipping default customer');
        return;
      }
      
      final business = ref.read(selectedBusinessProvider);
      if (business != null) {
        try {
          final walkInCustomer = await ref.read(
            walkInCustomerProvider(business.id).future,
          );
          _selectCustomer(walkInCustomer);
        } catch (e) {
          _logger.error('Failed to set default customer: $e');
        }
      }
    } else {
      _logger.info('Cart already has customer: ${cart?.customerName}');
    }
  }

  void _selectCustomer(Customer? customer) {
    if (customer != null) {
      ref.read(selectedCustomerProvider.notifier).state = customer;
      ref
          .read(cartNotifierProvider.notifier)
          .setCustomer(
            customerId: customer.id,
            customerName: customer.name,
            customerPhone: customer.phone,
            customerDiscountPercent: customer.discountPercent,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartNotifierProvider);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final cartItemCount = ref.watch(cartItemCountProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    // Watch for auto-apply discounts (this will automatically apply them)
    ref.watch(autoApplyItemDiscountsProvider);

    return Column(
      children: [
        // Header with cart title and item count
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart?.orderId != null ? 'Order #${cart!.orderId!.substring(0, 8).toUpperCase()}' : 'Cart',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (cart?.tableName != null) ...[
                          Text(
                            'Table: ${cart!.tableName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$cartItemCount',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Customer Selector
        Padding(
          padding: const EdgeInsets.all(8),
          child: CustomerSelector(onCustomerSelected: _selectCustomer),
        ),

        // Charges Section
        const CartChargesSection(),

        // Cart items list
        Expanded(
          child:
              cart == null || cart.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cart is empty',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items to get started',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap:
                              () => _showItemDetailDialog(context, ref, item),
                          child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  item.productImage != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.productImage!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.image_not_supported,
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                  ),
                                        ),
                                      )
                                      : Icon(
                                        Icons.inventory_2,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                            ),
                            title: Text(
                              item.productName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.variationName != 'Default')
                                  Text(
                                    item.variationName,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                Row(
                                  children: [
                                    Text(
                                      '₹${item.unitPrice.toStringAsFixed(2)} × ${item.quantity.toStringAsFixed(item.quantity == item.quantity.roundToDouble() ? 0 : 2)}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    if (item.appliedDiscounts.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          '${item.appliedDiscounts.length} discount${item.appliedDiscounts.length > 1 ? 's' : ''}',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${item.lineTotal.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item.effectiveDiscountAmount > 0)
                                    Text(
                                      '-₹${item.effectiveDiscountAmount.toStringAsFixed(2)}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.green),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
        // Cart summary and actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Summary section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal'),
                  Text(
                    '₹${cart?.calculatedSubtotal.toStringAsFixed(2) ?? '0.00'}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              // Item Discounts section
              if (cart != null && cart.totalItemDiscounts > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Item Discounts'),
                    Text(
                      '-₹${cart.totalItemDiscounts.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
              // Order Discount section
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order Discount'),
                  cart != null && cart.effectiveOrderDiscount > 0
                      ? Row(
                        children: [
                          Text(
                            '-₹${cart.effectiveOrderDiscount.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed:
                                () => _showOrderDiscountDialog(context, ref),
                            icon: const Icon(Icons.edit),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                          ),
                        ],
                      )
                      : InkWell(
                        onTap: () => _showOrderDiscountDialog(context, ref),
                        child: Row(
                          children: [
                            Text(
                              'Add Discount',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                ],
              ),
              // Charges section
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Charges'),
                  cart != null && cart.calculatedChargesAmount > 0
                      ? Row(
                        children: [
                          Text(
                            '+₹${cart.calculatedChargesAmount.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed:
                                () => _showManualChargeDialog(context, ref),
                            icon: const Icon(Icons.edit),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                          ),
                        ],
                      )
                      : InkWell(
                        onTap: () => _showManualChargeDialog(context, ref),
                        child: Row(
                          children: [
                            Text(
                              'Add Charge',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                ],
              ),
              // Tax section
              if (cart != null && cart.totalTaxAmount > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tax'),
                    Text(
                      '+₹${cart.totalTaxAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const Divider(height: 16),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${cartTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action buttons - Show table actions or regular actions
              if (widget.showTableActions) ...[
                TableCartActions(onActionCompleted: widget.onTableActionCompleted),
              ] else ...[
                // Regular action buttons for non-table orders
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            cart == null || cart.isEmpty
                                ? null
                                : () {
                                  cartNotifier.clearCart();
                                },
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            cart == null || cart.isEmpty
                                ? null
                                : () async {
                                  final result = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:
                                        (context) => CheckoutDialog(cart: cart),
                                  );

                                  if (result != null) {
                                    // Order was completed successfully
                                    // The cart is already cleared by the dialog
                                    // TODO: Navigate to receipt or new sale
                                  }
                                },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Show order discount dialog for manual discount
  void _showOrderDiscountDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.read(cartNotifierProvider);
    if (cart == null) return;

    // Calculate the subtotal after item discounts
    final subtotalAfterItemDiscounts =
        cart.calculatedSubtotal - cart.totalItemDiscounts;

    final percentController = TextEditingController(
      text:
          cart.orderDiscountPercent > 0
              ? cart.orderDiscountPercent.toString()
              : '',
    );
    final amountController = TextEditingController(
      text:
          cart.orderDiscountAmount > 0
              ? cart.orderDiscountAmount.toString()
              : '',
    );
    final reasonController = TextEditingController(
      text: cart.orderDiscountReason ?? '',
    );

    String discountType = cart.orderDiscountPercent > 0 ? 'percent' : 'amount';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Order Discount'),
                  content: SizedBox(
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Show current totals
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal:'),
                                    Text(
                                      '₹${cart.calculatedSubtotal.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                if (cart.totalItemDiscounts > 0) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Item Discounts:'),
                                      Text(
                                        '-₹${cart.totalItemDiscounts.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Amount for Order Discount:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '₹${subtotalAfterItemDiscounts.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Discount type selector
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Percentage'),
                                  value: 'percent',
                                  groupValue: discountType,
                                  onChanged: (value) {
                                    setState(() {
                                      discountType = value!;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Amount'),
                                  value: 'amount',
                                  groupValue: discountType,
                                  onChanged: (value) {
                                    setState(() {
                                      discountType = value!;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                            ],
                          ),

                          // Discount input
                          if (discountType == 'percent')
                            TextField(
                              controller: percentController,
                              decoration: const InputDecoration(
                                labelText: 'Discount Percentage',
                                hintText: '0-100',
                                suffixText: '%',
                              ),
                              keyboardType: TextInputType.number,
                            )
                          else
                            TextField(
                              controller: amountController,
                              decoration: const InputDecoration(
                                labelText: 'Discount Amount',
                                prefixText: '₹',
                              ),
                              keyboardType: TextInputType.number,
                            ),

                          const SizedBox(height: 16),

                          // Reason
                          TextField(
                            controller: reasonController,
                            decoration: const InputDecoration(
                              labelText: 'Reason (optional)',
                              hintText: 'e.g., VIP customer',
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        ref
                            .read(cartNotifierProvider.notifier)
                            .clearOrderDiscount();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Clear'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (discountType == 'percent') {
                          final percent =
                              double.tryParse(percentController.text) ?? 0;
                          if (percent > 0 && percent <= 100) {
                            ref
                                .read(cartNotifierProvider.notifier)
                                .applyOrderDiscount(
                                  percent: percent,
                                  reason:
                                      reasonController.text.isNotEmpty
                                          ? reasonController.text
                                          : null,
                                );
                            Navigator.of(context).pop();
                          }
                        } else {
                          final amount =
                              double.tryParse(amountController.text) ?? 0;
                          if (amount > 0 &&
                              amount <= subtotalAfterItemDiscounts) {
                            ref
                                .read(cartNotifierProvider.notifier)
                                .applyOrderDiscount(
                                  amount: amount,
                                  reason:
                                      reasonController.text.isNotEmpty
                                          ? reasonController.text
                                          : null,
                                );
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Show item detail dialog with discount information
  void _showItemDetailDialog(
    BuildContext context,
    WidgetRef ref,
    CartItem item,
  ) {
    showDialog(
      context: context,
      builder: (context) => ItemDetailDialog(item: item),
    );
  }

  // Show manual charge dialog (similar to order discount)
  void _showManualChargeDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.read(cartNotifierProvider);
    if (cart == null) return;

    // If there are existing charges, show the charges list dialog first
    if (cart.appliedCharges.isNotEmpty) {
      _showChargesListDialog(context, ref);
      return;
    }

    // Calculate the subtotal after discounts for charge calculation
    final subtotalAfterDiscounts =
        cart.calculatedSubtotal - cart.totalDiscountAmount;

    final nameController = TextEditingController();
    final percentController = TextEditingController();
    final amountController = TextEditingController();

    String chargeType = 'amount'; // Default to amount

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add Manual Charge'),
                  content: SizedBox(
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Show current totals
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal:'),
                                    Text(
                                      '₹${cart.calculatedSubtotal.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                if (cart.totalDiscountAmount > 0) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Discounts:'),
                                      Text(
                                        '-₹${cart.totalDiscountAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (cart.calculatedChargesAmount > 0) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Existing Charges:'),
                                      Text(
                                        '+₹${cart.calculatedChargesAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Base Amount for Charge:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '₹${subtotalAfterDiscounts.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Charge name
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Charge Name (Optional)',
                              hintText: 'e.g., Rush Order Charge',
                              helperText: 'Leave empty for default name',
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),

                          const SizedBox(height: 16),

                          // Charge type selector
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Percentage'),
                                  value: 'percent',
                                  groupValue: chargeType,
                                  onChanged: (value) {
                                    setState(() {
                                      chargeType = value!;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Amount'),
                                  value: 'amount',
                                  groupValue: chargeType,
                                  onChanged: (value) {
                                    setState(() {
                                      chargeType = value!;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                            ],
                          ),

                          // Charge value input
                          if (chargeType == 'percent')
                            TextField(
                              controller: percentController,
                              decoration: const InputDecoration(
                                labelText: 'Charge Percentage',
                                hintText: '0-100',
                                suffixText: '%',
                              ),
                              keyboardType: TextInputType.number,
                            )
                          else
                            TextField(
                              controller: amountController,
                              decoration: const InputDecoration(
                                labelText: 'Charge Amount',
                                prefixText: '₹',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (chargeType == 'percent') {
                          final percent =
                              double.tryParse(percentController.text) ?? 0;
                          if (percent > 0 && percent <= 100) {
                            // Use provided name or generate default
                            final chargeName =
                                nameController.text.trim().isEmpty
                                    ? 'Additional Charge ${percent.toStringAsFixed(0)}%'
                                    : nameController.text.trim();

                            // Create a manual percentage charge
                            _addManualCharge(
                              ref: ref,
                              name: chargeName,
                              value: percent,
                              isPercentage: true,
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter a valid percentage (1-100)',
                                ),
                              ),
                            );
                          }
                        } else {
                          final amount =
                              double.tryParse(amountController.text) ?? 0;
                          if (amount > 0) {
                            // Use provided name or generate default
                            final chargeName =
                                nameController.text.trim().isEmpty
                                    ? 'Additional Charge ₹${amount.toStringAsFixed(0)}'
                                    : nameController.text.trim();

                            // Create a manual fixed charge
                            _addManualCharge(
                              ref: ref,
                              name: chargeName,
                              value: amount,
                              isPercentage: false,
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid amount'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Show charges list dialog when charges exist
  void _showChargesListDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.read(cartNotifierProvider);
    if (cart == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Manage Charges'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // List of existing charges
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.appliedCharges.length,
                    itemBuilder: (context, index) {
                      final charge = cart.appliedCharges[index];
                      return ListTile(
                        title: Text(charge.chargeName),
                        subtitle: Text(
                          charge.isManual
                              ? 'Manual charge'
                              : '${charge.chargeType} - ${charge.calculationType}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${charge.chargeAmount.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .removeCharge(charge.chargeId ?? charge.id);
                                Navigator.of(context).pop();
                                // Reopen dialog if there are still charges
                                if (cart.appliedCharges.length > 1) {
                                  _showChargesListDialog(context, ref);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Total charges
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Charges:',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${cart.calculatedChargesAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(cartNotifierProvider.notifier).clearAllCharges();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Open add charge dialog
                  _showAddChargeDialog(context, ref);
                },
                child: const Text('Add Charge'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  // Show add charge dialog (for adding new charges)
  void _showAddChargeDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.read(cartNotifierProvider);
    if (cart == null) return;

    // Calculate the subtotal after discounts for charge calculation
    final subtotalAfterDiscounts =
        cart.calculatedSubtotal - cart.totalDiscountAmount;

    final nameController = TextEditingController();
    final percentController = TextEditingController();
    final amountController = TextEditingController();

    String chargeType = 'amount'; // Default to amount

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add Manual Charge'),
                  content: SizedBox(
                    width: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Show current totals
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal:'),
                                    Text(
                                      '₹${cart.calculatedSubtotal.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                if (cart.totalDiscountAmount > 0) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Discounts:'),
                                      Text(
                                        '-₹${cart.totalDiscountAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (cart.calculatedChargesAmount > 0) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Existing Charges:'),
                                      Text(
                                        '+₹${cart.calculatedChargesAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Base Amount for Charge:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '₹${subtotalAfterDiscounts.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Charge name
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Charge Name (Optional)',
                              hintText: 'e.g., Rush Order Charge',
                              helperText: 'Leave empty for default name',
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),

                          const SizedBox(height: 16),

                          // Charge type selector
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Percentage'),
                                  value: 'percent',
                                  groupValue: chargeType,
                                  onChanged: (value) {
                                    setState(() {
                                      chargeType = value!;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Amount'),
                                  value: 'amount',
                                  groupValue: chargeType,
                                  onChanged: (value) {
                                    setState(() {
                                      chargeType = value!;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                            ],
                          ),

                          // Charge value input
                          if (chargeType == 'percent')
                            TextField(
                              controller: percentController,
                              decoration: const InputDecoration(
                                labelText: 'Charge Percentage',
                                hintText: '0-100',
                                suffixText: '%',
                              ),
                              keyboardType: TextInputType.number,
                            )
                          else
                            TextField(
                              controller: amountController,
                              decoration: const InputDecoration(
                                labelText: 'Charge Amount',
                                prefixText: '₹',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (chargeType == 'percent') {
                          final percent =
                              double.tryParse(percentController.text) ?? 0;
                          if (percent > 0 && percent <= 100) {
                            // Use provided name or generate default
                            final chargeName =
                                nameController.text.trim().isEmpty
                                    ? 'Additional Charge ${percent.toStringAsFixed(0)}%'
                                    : nameController.text.trim();

                            // Create a manual percentage charge
                            _addManualCharge(
                              ref: ref,
                              name: chargeName,
                              value: percent,
                              isPercentage: true,
                            );
                            Navigator.of(context).pop();
                            // Show charges list if there are charges
                            if (ref
                                    .read(cartNotifierProvider)
                                    ?.appliedCharges
                                    .isNotEmpty ??
                                false) {
                              _showChargesListDialog(context, ref);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter a valid percentage (1-100)',
                                ),
                              ),
                            );
                          }
                        } else {
                          final amount =
                              double.tryParse(amountController.text) ?? 0;
                          if (amount > 0) {
                            // Use provided name or generate default
                            final chargeName =
                                nameController.text.trim().isEmpty
                                    ? 'Additional Charge ₹${amount.toStringAsFixed(0)}'
                                    : nameController.text.trim();

                            // Create a manual fixed charge
                            _addManualCharge(
                              ref: ref,
                              name: chargeName,
                              value: amount,
                              isPercentage: false,
                            );
                            Navigator.of(context).pop();
                            // Show charges list if there are charges
                            if (ref
                                    .read(cartNotifierProvider)
                                    ?.appliedCharges
                                    .isNotEmpty ??
                                false) {
                              _showChargesListDialog(context, ref);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid amount'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Helper method to add manual charge
  void _addManualCharge({
    required WidgetRef ref,
    required String name,
    required double value,
    required bool isPercentage,
  }) {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) return;

    // Generate a proper UUID for manual charges
    final uuid = const Uuid();
    final manualChargeId = uuid.v4();

    // Create a temporary charge object for manual charges
    final manualCharge = Charge(
      id: manualChargeId,
      businessId: business.id,
      code: 'MANUAL',
      name: name,
      chargeType: ChargeType.custom,
      calculationType:
          isPercentage ? CalculationType.percentage : CalculationType.fixed,
      value: value,
      isActive: true,
      autoApply: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(cartNotifierProvider.notifier).addManualCharge(manualCharge);
    _logger.info('Added manual charge: $name with ID: $manualChargeId');
  }
}
