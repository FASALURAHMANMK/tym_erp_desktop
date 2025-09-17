import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../sales/models/cart.dart';
import '../../sales/models/price_category.dart';
import '../../sales/providers/cart_provider.dart';
import '../../sales/providers/price_category_provider.dart';
import '../models/payment_method.dart';
import '../providers/payment_method_provider.dart';
import '../../customers/providers/customer_provider.dart';
import '../../orders/providers/order_provider.dart';
import '../../orders/models/order_status.dart';
import '../../sales/providers/sales_provider.dart';

class CheckoutDialog extends ConsumerStatefulWidget {
  final Cart cart;
  
  const CheckoutDialog({
    super.key,
    required this.cart,
  });

  @override
  ConsumerState<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends ConsumerState<CheckoutDialog> {
  static final _logger = Logger('CheckoutDialog');
  static const _uuid = Uuid();
  
  // Payment tracking
  final Map<String, double> _payments = {};
  final Map<String, TextEditingController> _paymentControllers = {};
  final Map<String, TextEditingController> _referenceControllers = {};
  
  // Selected payment method for current entry
  PaymentMethod? _selectedPaymentMethod;
  
  // Totals
  double get _totalPaid => _payments.values.fold(0, (sum, amount) => sum + amount);
  double get _remainingAmount => widget.cart.calculatedTotal - _totalPaid;
  double get _changeAmount => _totalPaid > widget.cart.calculatedTotal 
      ? _totalPaid - widget.cart.calculatedTotal 
      : 0;
  
  @override
  void initState() {
    super.initState();
    // Auto-select cash as default payment method
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final methods = await ref.read(activePaymentMethodsProvider.future);
      final cashMethod = methods.firstWhere(
        (m) => m.code == 'cash',
        orElse: () => methods.first,
      );
      setState(() {
        _selectedPaymentMethod = cashMethod;
      });
    });
  }
  
  /// Map price category type to order type
  OrderType _getOrderTypeFromPriceCategory(PriceCategory? priceCategory) {
    if (priceCategory == null) {
      // Fallback to table context if no price category
      return widget.cart.tableId != null && widget.cart.tableId!.isNotEmpty
          ? OrderType.dineIn
          : OrderType.takeaway;
    }
    
    switch (priceCategory.type) {
      case PriceCategoryType.dineIn:
        return OrderType.dineIn;
      case PriceCategoryType.takeaway:
        return OrderType.takeaway;
      case PriceCategoryType.delivery:
        return OrderType.delivery;
      case PriceCategoryType.catering:
        // Catering is typically pickup/takeaway orders for events
        return OrderType.takeaway;
      case PriceCategoryType.custom:
        // For custom price categories, use intelligent name-based mapping
        return _mapCustomCategoryToOrderType(priceCategory);
    }
  }
  
  /// Intelligently map custom price category to order type based on name and context
  OrderType _mapCustomCategoryToOrderType(PriceCategory priceCategory) {
    final name = priceCategory.name.toLowerCase();
    
    // Check for delivery-related keywords
    if (name.contains('delivery') || 
        name.contains('ship') || 
        name.contains('courier')) {
      return OrderType.delivery;
    }
    
    // Check for dine-in related keywords  
    if (name.contains('dine') || 
        name.contains('restaurant') || 
        name.contains('table') ||
        name.contains('eat in')) {
      return OrderType.dineIn;
    }
    
    // Check for online-related keywords
    if (name.contains('online') || 
        name.contains('web') || 
        name.contains('app') ||
        name.contains('digital')) {
      return OrderType.online;
    }
    
    // Default to takeaway for most custom categories
    // (catering, events, wholesale, bulk orders, etc.)
    return OrderType.takeaway;
  }
  
  @override
  void dispose() {
    for (final controller in _paymentControllers.values) {
      controller.dispose();
    }
    for (final controller in _referenceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _addPayment() {
    if (_selectedPaymentMethod == null) return;
    
    final paymentId = '${_selectedPaymentMethod!.code}_${_uuid.v4().substring(0, 8)}';
    final controller = TextEditingController();
    
    // If this is the first payment, default to full amount
    if (_payments.isEmpty) {
      controller.text = _remainingAmount.toStringAsFixed(2);
    }
    
    setState(() {
      _paymentControllers[paymentId] = controller;
      _payments[paymentId] = 0;
      
      if (_selectedPaymentMethod!.requiresReference) {
        _referenceControllers[paymentId] = TextEditingController();
      }
    });
    
    // Listen to changes
    controller.addListener(() {
      final amount = double.tryParse(controller.text) ?? 0;
      setState(() {
        _payments[paymentId] = amount;
      });
    });
    
    // Auto-fill the first payment
    if (_payments.length == 1) {
      _payments[paymentId] = _remainingAmount;
    }
  }
  
  void _removePayment(String paymentId) {
    setState(() {
      _payments.remove(paymentId);
      _paymentControllers[paymentId]?.dispose();
      _paymentControllers.remove(paymentId);
      _referenceControllers[paymentId]?.dispose();
      _referenceControllers.remove(paymentId);
    });
  }
  
  Future<void> _completeCheckout() async {
    // Check if customer credit is being used and validate
    final selectedCustomer = ref.read(selectedCustomerProvider);
    bool usingCustomerCredit = false;
    double creditAmount = 0;
    
    for (final paymentId in _payments.keys) {
      final methodCode = paymentId.split('_').first;
      if (methodCode == 'customer_credit') {
        usingCustomerCredit = true;
        creditAmount = _payments[paymentId] ?? 0;
        break;
      }
    }
    
    // If using customer credit, validate credit limit
    if (usingCustomerCredit && selectedCustomer != null) {
      if (selectedCustomer.customerType == 'walk_in') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Walk-in customer cannot use credit'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      final canUseCredit = await ref.read(customerNotifierProvider.notifier)
          .canMakeCreditPurchase(
            customerId: selectedCustomer.id,
            purchaseAmount: creditAmount,
          );
      
      if (!canUseCredit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Credit limit exceeded. Available: ₹${selectedCustomer.availableCredit.toStringAsFixed(2)}'
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    
    // Validate payments
    if (_totalPaid < widget.cart.calculatedTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment incomplete. Remaining: ₹${_remainingAmount.toStringAsFixed(2)}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Validate reference numbers for payments that require them
    for (final paymentId in _payments.keys) {
      final methodCode = paymentId.split('_').first;
      final methods = await ref.read(activePaymentMethodsProvider.future);
      final methodOrNull = methods.where((m) => m.code == methodCode).firstOrNull;
      
      if (methodOrNull == null) {
        // Handle case where payment method is not found
        _logger.error('Payment method not found for code: $methodCode');
        continue;
      }
      
      if (methodOrNull.requiresReference) {
        final reference = _referenceControllers[paymentId]?.text ?? '';
        if (reference.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter reference number for ${methodOrNull.name}'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
      }
    }
    
    // Prepare payment data for order creation
    final paymentDataList = <Map<String, dynamic>>[];
    
    for (final paymentId in _payments.keys) {
      final methodCode = paymentId.split('_').first;
      final methods = await ref.read(activePaymentMethodsProvider.future);
      final method = methods.where((m) => m.code == methodCode).firstOrNull;
      
      if (method == null) {
        _logger.error('Payment method not found for code: $methodCode');
        continue;
      }
      
      paymentDataList.add({
        'methodId': method.id,
        'methodName': method.name,
        'methodCode': method.code,
        'amount': _payments[paymentId],
        'tipAmount': 0.0, // TODO: Add tip support
        'referenceNumber': _referenceControllers[paymentId]?.text,
        'transactionId': null, // Will be set by payment gateway
      });
    }
    
    // Get selected customer (or walk-in)
    final customer = ref.read(selectedCustomerProvider) ?? 
                     await ref.read(walkInCustomerProvider(widget.cart.businessId ?? '').future);
    
    if (customer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer information is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing payment...'),
                ],
              ),
            ),
          ),
        ),
      );
      
      late dynamic order;
      
      // Check if we're completing an existing order or creating a new one
      if (widget.cart.orderId != null && widget.cart.orderId!.isNotEmpty) {
        // Existing order - mark as completed with payment
        _logger.info('Completing existing order: ${widget.cart.orderId}');
        
        // Update the order status to completed
        await ref.read(orderNotifierProvider.notifier).updateOrderStatus(
          orderId: widget.cart.orderId!,
          newStatus: OrderStatus.completed,
          reason: 'Payment completed',
        );
        
        // Get the updated order to return
        final orderResult = await ref.read(orderByIdProvider(widget.cart.orderId!).future);
        order = orderResult;
        
        if (order == null) {
          throw Exception('Failed to update order');
        }
        
        _logger.info('Order ${widget.cart.orderId} marked as completed');
      } else {
        // New order - create from cart with payment
        // Get selected price category for order type and name
        final selectedPriceCategory = ref.read(selectedPriceCategoryProvider);
        final orderType = _getOrderTypeFromPriceCategory(selectedPriceCategory);
        final priceCategoryName = selectedPriceCategory?.name; // Preserve original category name
            
        final orderParams = {
          'cart': widget.cart,
          'customer': customer,
          'payments': paymentDataList,
          'charges': widget.cart.appliedCharges.map((charge) => {
            'id': charge.id,
            'chargeId': charge.chargeId,
            'chargeName': charge.chargeName,
            'chargeType': charge.chargeType,
            'calculationType': charge.calculationType,
            'baseAmount': charge.baseAmount,
            'chargeRate': charge.chargeRate,
            'chargeAmount': charge.chargeAmount,
            'isTaxable': charge.isTaxable,
            'isManual': charge.isManual,
          }).toList(),
          'orderType': orderType,
          'priceCategoryName': priceCategoryName, // Store original category name for reporting
          'tableId': widget.cart.tableId,
          'tableName': widget.cart.tableName,
          'customerNotes': null, // TODO: Add customer notes field
          'kitchenNotes': null, // TODO: Add kitchen notes field
        };
        
        order = await ref.read(createOrderFromCartProvider(orderParams).future);
        
        if (order == null) {
          throw Exception('Failed to create order');
        }
        
        _logger.info('Order created successfully: ${order.orderNumber}');
      }
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Clear the cart
      ref.read(cartNotifierProvider.notifier).clearCart();

      // Invalidate sales providers so Sales screen updates immediately
      try {
        ref.invalidate(completedOrdersProvider);
      } catch (_) {}
      
      if (mounted) {
        // Close checkout dialog and return order
        Navigator.of(context).pop(order);
        
        final actionText = widget.cart.orderId != null ? 'completed' : 'created';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order ${order.orderNumber} $actionText successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Navigate to order details
              },
            ),
          ),
        );
      }
      
      // TODO: Print receipt if needed
      // TODO: Send KOT to kitchen if needed
      
    } catch (e) {
      _logger.error('Failed to complete checkout', e);
      
      // Close loading dialog if still open
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paymentMethodsAsync = ref.watch(activePaymentMethodsProvider);
    
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Checkout',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            
            // Content
            Expanded(
              child: Row(
                children: [
                  // Left side - Order summary
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Items list
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: widget.cart.items.length,
                              itemBuilder: (context, index) {
                                final item = widget.cart.items[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(item.productName),
                                  subtitle: Text(
                                    '${item.quantity} × ₹${item.unitPrice.toStringAsFixed(2)}',
                                  ),
                                  trailing: Text(
                                    '₹${item.lineTotal.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Totals
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal:'),
                                  Text('₹${widget.cart.calculatedSubtotal.toStringAsFixed(2)}'),
                                ],
                              ),
                              if (widget.cart.totalItemDiscounts > 0) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Item Discounts:'),
                                    Text(
                                      '-₹${widget.cart.totalItemDiscounts.toStringAsFixed(2)}',
                                      style: TextStyle(color: theme.colorScheme.error),
                                    ),
                                  ],
                                ),
                              ],
                              if (widget.cart.effectiveOrderDiscount > 0) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Order Discount:'),
                                    Text(
                                      '-₹${widget.cart.effectiveOrderDiscount.toStringAsFixed(2)}',
                                      style: TextStyle(color: theme.colorScheme.error),
                                    ),
                                  ],
                                ),
                              ],
                              if (widget.cart.calculatedChargesAmount > 0) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Charges:'),
                                    Text(
                                      '+₹${widget.cart.calculatedChargesAmount.toStringAsFixed(2)}',
                                      style: TextStyle(color: theme.colorScheme.primary),
                                    ),
                                  ],
                                ),
                              ],
                              if (widget.cart.totalTaxAmount > 0) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Tax:'),
                                    Text('+₹${widget.cart.totalTaxAmount.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ],
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  Text(
                                    '₹${widget.cart.calculatedTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // Right side - Payment methods
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Methods',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            paymentMethodsAsync.when(
                              data: (methods) => DropdownButton<PaymentMethod>(
                                value: _selectedPaymentMethod,
                                hint: const Text('Select method'),
                                items: methods.map((method) {
                                  return DropdownMenuItem(
                                    value: method,
                                    child: Text(method.name),
                                  );
                                }).toList(),
                                onChanged: (method) {
                                  setState(() {
                                    _selectedPaymentMethod = method;
                                  });
                                },
                              ),
                              loading: () => const CircularProgressIndicator(),
                              error: (_, __) => const Text('Error loading methods'),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        ElevatedButton.icon(
                          onPressed: _selectedPaymentMethod != null && _remainingAmount > 0
                              ? _addPayment
                              : null,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Payment'),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Payment entries
                        Expanded(
                          child: ListView.builder(
                            itemCount: _payments.length,
                            itemBuilder: (context, index) {
                              final paymentId = _payments.keys.elementAt(index);
                              final methodCode = paymentId.split('_').first;
                              
                              return paymentMethodsAsync.when(
                                data: (methods) {
                                  final method = methods.firstWhere(
                                    (m) => m.code == methodCode,
                                    orElse: () => methods.first,
                                  );
                                  
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                _getPaymentIcon(method.displayIcon),
                                                color: theme.colorScheme.primary,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                method.name,
                                                style: theme.textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () => _removePayment(paymentId),
                                                icon: const Icon(Icons.delete),
                                                iconSize: 20,
                                                color: Colors.red,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: _paymentControllers[paymentId],
                                            decoration: InputDecoration(
                                              labelText: 'Amount',
                                              prefixText: '₹',
                                              isDense: true,
                                              suffixText: index == 0 && _payments.length == 1
                                                  ? 'Full Amount'
                                                  : null,
                                            ),
                                            keyboardType: const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d{0,2}'),
                                              ),
                                            ],
                                          ),
                                          if (method.requiresReference) ...[
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: _referenceControllers[paymentId],
                                              decoration: const InputDecoration(
                                                labelText: 'Reference Number',
                                                hintText: 'Transaction ID / Cheque No.',
                                                isDense: true,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                loading: () => const CircularProgressIndicator(),
                                error: (_, __) => const Text('Error'),
                              );
                            },
                          ),
                        ),
                        
                        // Payment summary
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Due:'),
                                  Text(
                                    '₹${widget.cart.calculatedTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Paid:'),
                                  Text(
                                    '₹${_totalPaid.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _totalPaid >= widget.cart.calculatedTotal
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              if (_remainingAmount > 0) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Remaining:'),
                                    Text(
                                      '₹${_remainingAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (_changeAmount > 0) ...[
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Change:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '₹${_changeAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer actions
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _totalPaid >= widget.cart.calculatedTotal
                      ? _completeCheckout
                      : null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Complete Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getPaymentIcon(String icon) {
    switch (icon) {
      case 'cash':
        return Icons.payments;
      case 'credit_card':
        return Icons.credit_card;
      case 'account_balance':
        return Icons.account_balance;
      case 'receipt':
        return Icons.receipt;
      case 'smartphone':
        return Icons.smartphone;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'wallet':
        return Icons.wallet;
      default:
        return Icons.payment;
    }
  }
}
