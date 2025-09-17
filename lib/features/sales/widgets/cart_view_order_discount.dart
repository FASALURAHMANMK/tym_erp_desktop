// This is a simplified version of the order discount dialog
// It only handles manual order-level discounts

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';

extension OrderDiscountDialog on ConsumerWidget {
  void showOrderDiscountDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.read(cartNotifierProvider);
    if (cart == null) return;

    // Calculate the subtotal after item discounts for order discount calculation
    final subtotalAfterItemDiscounts = cart.calculatedSubtotal - cart.totalItemDiscounts;

    final percentController = TextEditingController(
      text: cart.orderDiscountPercent > 0 ? cart.orderDiscountPercent.toString() : '',
    );
    final amountController = TextEditingController(
      text: cart.orderDiscountAmount > 0 ? cart.orderDiscountAmount.toString() : '',
    );
    final reasonController = TextEditingController(
      text: cart.orderDiscountReason ?? '',
    );

    String discountType = cart.orderDiscountPercent > 0 ? 'percent' : 'amount';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.discount, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Order Discount'),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show current totals
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
                            Text('₹${cart.calculatedSubtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        if (cart.totalItemDiscounts > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Item Discounts:'),
                              Text(
                                '-₹${cart.totalItemDiscounts.toStringAsFixed(2)}',
                                style: TextStyle(color: theme.colorScheme.error),
                              ),
                            ],
                          ),
                        ],
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Amount for Order Discount:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹${subtotalAfterItemDiscounts.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Reason for discount
                  TextField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      labelText: 'Reason for Discount',
                      hintText: 'e.g., VIP customer, Complaint resolution',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.note),
                    ),
                    maxLines: 2,
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
                              amountController.clear();
                              percentController.clear();
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Fixed Amount'),
                          value: 'amount',
                          groupValue: discountType,
                          onChanged: (value) {
                            setState(() {
                              discountType = value!;
                              amountController.clear();
                              percentController.clear();
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Discount input
                  if (discountType == 'percent')
                    TextField(
                      controller: percentController,
                      decoration: InputDecoration(
                        labelText: 'Discount Percentage',
                        hintText: 'Enter percentage (0-100)',
                        suffixText: '%',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.percent),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    )
                  else
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Discount Amount',
                        hintText: 'Enter amount',
                        prefixText: '₹',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.currency_rupee),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Preview
                  if ((discountType == 'percent' && percentController.text.isNotEmpty) ||
                      (discountType == 'amount' && amountController.text.isNotEmpty))
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('After Item Discounts:'),
                              Text('₹${subtotalAfterItemDiscounts.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Order Discount:'),
                              Text(
                                '-₹${_calculatePreviewDiscount(
                                  subtotalAfterItemDiscounts,
                                  discountType == 'percent',
                                  percentController.text,
                                  amountController.text,
                                ).toStringAsFixed(2)}',
                                style: TextStyle(color: theme.colorScheme.error),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'New Total:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '₹${(subtotalAfterItemDiscounts - _calculatePreviewDiscount(
                                  subtotalAfterItemDiscounts,
                                  discountType == 'percent',
                                  percentController.text,
                                  amountController.text,
                                )).toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear order discount
                ref.read(cartNotifierProvider.notifier).clearOrderDiscount();
                Navigator.of(context).pop();
              },
              child: const Text('Clear Discount'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (discountType == 'percent') {
                  final percent = double.tryParse(percentController.text) ?? 0;
                  if (percent > 0 && percent <= 100) {
                    ref.read(cartNotifierProvider.notifier).applyOrderDiscount(
                      percent: percent,
                      reason: reasonController.text.isNotEmpty ? reasonController.text : null,
                    );
                    Navigator.of(context).pop();
                  }
                } else {
                  final amount = double.tryParse(amountController.text) ?? 0;
                  if (amount > 0 && amount <= subtotalAfterItemDiscounts) {
                    ref.read(cartNotifierProvider.notifier).applyOrderDiscount(
                      amount: amount,
                      reason: reasonController.text.isNotEmpty ? reasonController.text : null,
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

  // Calculate preview discount
  double _calculatePreviewDiscount(
    double subtotal,
    bool isPercentage,
    String percentText,
    String amountText,
  ) {
    if (isPercentage) {
      final percent = double.tryParse(percentText) ?? 0;
      return subtotal * (percent / 100);
    } else {
      final amount = double.tryParse(amountText) ?? 0;
      return amount > subtotal ? subtotal : amount;
    }
  }
}