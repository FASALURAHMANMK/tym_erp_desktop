import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item.dart';
import '../models/discount.dart';
import '../providers/cart_provider.dart';
import '../providers/discount_provider.dart';
import '../../../core/utils/logger.dart';

class ItemDetailDialog extends ConsumerStatefulWidget {
  final CartItem item;
  
  const ItemDetailDialog({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<ItemDetailDialog> createState() => _ItemDetailDialogState();
}

class _ItemDetailDialogState extends ConsumerState<ItemDetailDialog> {
  static final _logger = Logger('ItemDetailDialog');
  
  String? selectedDiscountId;
  bool isLoadingDiscounts = true;
  List<Discount> applicableDiscounts = [];
  
  // Manual discount controllers
  final TextEditingController manualAmountController = TextEditingController();
  final TextEditingController manualPercentController = TextEditingController();
  final TextEditingController manualReasonController = TextEditingController();
  String manualDiscountType = 'percent';
  bool showManualDiscount = false;
  
  @override
  void initState() {
    super.initState();
    // Set the currently applied discount if any
    if (widget.item.appliedDiscounts.isNotEmpty) {
      selectedDiscountId = widget.item.appliedDiscounts.first.discountId;
    }
    _loadApplicableDiscounts();
  }
  
  @override
  void dispose() {
    manualAmountController.dispose();
    manualPercentController.dispose();
    manualReasonController.dispose();
    super.dispose();
  }
  
  Future<void> _loadApplicableDiscounts() async {
    try {
      final cart = ref.read(cartNotifierProvider);
      if (cart == null) return;
      
      // Get all applicable discounts for this item
      final discounts = await ref.read(
        applicableDiscountsProvider(
          cartTotal: widget.item.lineSubtotal,
          productIds: [widget.item.productId],
          categoryIds: widget.item.categoryId != null ? [widget.item.categoryId!] : null,
          customerId: cart.customerId,
        ).future,
      );
      
      // Filter discounts that actually apply to this item
      final itemApplicableDiscounts = discounts.where((discount) {
        // Check if discount applies to this specific item
        if (discount.scope == DiscountScope.item) {
          return discount.productId == widget.item.productId;
        } else if (discount.scope == DiscountScope.category) {
          return discount.categoryId == widget.item.categoryId;
        } else if (discount.scope == DiscountScope.cart) {
          return true; // Cart-level discounts apply to all items
        }
        return false;
      }).toList();
      
      setState(() {
        applicableDiscounts = itemApplicableDiscounts;
        isLoadingDiscounts = false;
        
        // If no discount is selected but there are auto-apply discounts, select the best one
        if (selectedDiscountId == null && itemApplicableDiscounts.isNotEmpty) {
          final autoApplyDiscounts = itemApplicableDiscounts.where((d) => d.isAutoApply).toList();
          if (autoApplyDiscounts.isNotEmpty) {
            // Select the discount with the highest value
            final bestDiscount = _findBestDiscount(autoApplyDiscounts);
            if (bestDiscount != null) {
              selectedDiscountId = bestDiscount.id;
              _applyDiscount(bestDiscount);
            }
          }
        }
      });
    } catch (e) {
      _logger.error('Failed to load applicable discounts', e);
      setState(() {
        isLoadingDiscounts = false;
      });
    }
  }
  
  Discount? _findBestDiscount(List<Discount> discounts) {
    if (discounts.isEmpty) return null;
    
    Discount? bestDiscount;
    double bestValue = 0;
    
    for (final discount in discounts) {
      final value = discount.calculateDiscount(widget.item.lineSubtotal);
      if (value > bestValue) {
        bestValue = value;
        bestDiscount = discount;
      }
    }
    
    return bestDiscount;
  }
  
  void _applyDiscount(Discount discount) {
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final cart = ref.read(cartNotifierProvider);
    
    // Get the current item from cart (not widget.item which might be stale)
    final currentItem = cart?.items.firstWhere(
      (i) => i.id == widget.item.id,
      orElse: () => widget.item,
    ) ?? widget.item;
    
    // First, clear any existing discounts on this item
    if (currentItem.appliedDiscounts.isNotEmpty) {
      for (final applied in currentItem.appliedDiscounts) {
        cartNotifier.removeItemDiscount(widget.item.id, applied.discountId);
      }
    }
    
    // Apply the selected discount
    cartNotifier.applyItemDiscount(
      widget.item.id,
      discountId: discount.id,
      discountName: discount.name,
      type: discount.type,
      value: discount.value,
      isAutoApplied: discount.isAutoApply,
    );
    
    _logger.info('Applied discount ${discount.name} to item ${widget.item.productName}');
  }
  
  void _removeAllDiscounts() {
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final cart = ref.read(cartNotifierProvider);
    
    // Get the current item from cart (not widget.item which might be stale)
    final currentItem = cart?.items.firstWhere(
      (i) => i.id == widget.item.id,
      orElse: () => widget.item,
    ) ?? widget.item;
    
    // Remove all discounts from this item
    if (currentItem.appliedDiscounts.isNotEmpty) {
      for (final applied in currentItem.appliedDiscounts) {
        cartNotifier.removeItemDiscount(widget.item.id, applied.discountId);
      }
    }
    
    setState(() {
      selectedDiscountId = null;
    });
    
    _logger.info('Removed all discounts from item ${widget.item.productName}');
  }
  
  void _applyManualDiscount() {
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    
    // First, clear any existing discounts
    if (widget.item.appliedDiscounts.isNotEmpty) {
      for (final applied in widget.item.appliedDiscounts) {
        cartNotifier.removeItemDiscount(widget.item.id, applied.discountId);
      }
    }
    
    // Apply manual discount
    final value = manualDiscountType == 'percent'
        ? double.tryParse(manualPercentController.text) ?? 0
        : double.tryParse(manualAmountController.text) ?? 0;
    
    if (value > 0) {
      // Generate a proper UUID for manual discount
      final uuid = const Uuid();
      final manualDiscountId = uuid.v4();
      
      cartNotifier.applyItemDiscount(
        widget.item.id,
        discountId: manualDiscountId,
        discountName: manualReasonController.text.isNotEmpty 
            ? manualReasonController.text 
            : 'Manual Discount',
        type: manualDiscountType == 'percent' 
            ? DiscountType.percentage 
            : DiscountType.fixed,
        value: value,
        isAutoApplied: false,
      );
      
      Navigator.of(context).pop();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Watch for cart changes to update the item
    final cart = ref.watch(cartNotifierProvider);
    final currentItem = cart?.items.firstWhere(
      (i) => i.id == widget.item.id,
      orElse: () => widget.item,
    ) ?? widget.item;
    
    // Update selectedDiscountId based on current item's applied discounts
    if (currentItem.appliedDiscounts.isNotEmpty && 
        selectedDiscountId != currentItem.appliedDiscounts.first.discountId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            selectedDiscountId = currentItem.appliedDiscounts.first.discountId;
          });
        }
      });
    } else if (currentItem.appliedDiscounts.isEmpty && selectedDiscountId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            selectedDiscountId = null;
          });
        }
      });
    }
    
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(currentItem.productName),
          if (currentItem.variationName != 'Default')
            Text(
              currentItem.variationName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item details
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
                        const Text('Quantity:'),
                        Text(currentItem.quantity.toString()),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Unit Price:'),
                        Text('₹${currentItem.unitPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${currentItem.lineSubtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              // Discounts section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Discounts',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (currentItem.appliedDiscounts.isNotEmpty)
                    TextButton(
                      onPressed: _removeAllDiscounts,
                      child: const Text('Clear All'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              
              if (isLoadingDiscounts)
                const Center(child: CircularProgressIndicator())
              else if (applicableDiscounts.isEmpty && !showManualDiscount)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'No discounts available for this item',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              showManualDiscount = true;
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Manual Discount'),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Auto-apply discounts
                if (applicableDiscounts.any((d) => d.isAutoApply)) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'Automatic Discounts',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...applicableDiscounts.where((d) => d.isAutoApply).map((discount) {
                    final discountValue = discount.calculateDiscount(currentItem.lineSubtotal);
                    final isSelected = currentItem.appliedDiscounts.any((a) => a.discountId == discount.id);
                    
                    return InkWell(
                      onTap: () {
                        // If clicking on already selected discount, deselect it
                        if (isSelected) {
                          setState(() {
                            selectedDiscountId = null;
                          });
                          _removeAllDiscounts();
                        } else {
                          setState(() {
                            selectedDiscountId = discount.id;
                          });
                          _applyDiscount(discount);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: discount.id,
                              groupValue: isSelected ? discount.id : null,
                              onChanged: (_) {
                                // Handled by InkWell
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    discount.name,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    discount.type == DiscountType.percentage
                                        ? '${discount.value}% off (₹${discountValue.toStringAsFixed(2)})'
                                        : '₹${discount.value} off',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                
                // Manual/coupon discounts
                if (applicableDiscounts.any((d) => !d.isAutoApply)) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: applicableDiscounts.any((d) => d.isAutoApply)
                          ? null
                          : const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_offer, size: 16, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Available Discounts',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...applicableDiscounts.where((d) => !d.isAutoApply).map((discount) {
                    final discountValue = discount.calculateDiscount(currentItem.lineSubtotal);
                    final isSelected = currentItem.appliedDiscounts.any((a) => a.discountId == discount.id);
                    
                    return InkWell(
                      onTap: () {
                        // If clicking on already selected discount, deselect it
                        if (isSelected) {
                          setState(() {
                            selectedDiscountId = null;
                          });
                          _removeAllDiscounts();
                        } else {
                          setState(() {
                            selectedDiscountId = discount.id;
                          });
                          _applyDiscount(discount);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: discount.id,
                              groupValue: isSelected ? discount.id : null,
                              onChanged: (_) {
                                // Handled by InkWell
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    discount.name,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    discount.type == DiscountType.percentage
                                        ? '${discount.value}% off (₹${discountValue.toStringAsFixed(2)})'
                                        : '₹${discount.value} off',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 20),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                
                // Add manual discount button
                if (!showManualDiscount && applicableDiscounts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          showManualDiscount = true;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Manual Discount'),
                    ),
                  ),
                ],
              ],
              
              // Manual discount section
              if (showManualDiscount) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Manual Discount',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showManualDiscount = false;
                                manualAmountController.clear();
                                manualPercentController.clear();
                                manualReasonController.clear();
                              });
                            },
                            icon: const Icon(Icons.close),
                            iconSize: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Reason
                      TextField(
                        controller: manualReasonController,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          hintText: 'e.g., Damaged item, Special offer',
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Type selector
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Percent'),
                              value: 'percent',
                              groupValue: manualDiscountType,
                              onChanged: (value) {
                                setState(() {
                                  manualDiscountType = value!;
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
                              groupValue: manualDiscountType,
                              onChanged: (value) {
                                setState(() {
                                  manualDiscountType = value!;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                      
                      // Value input
                      if (manualDiscountType == 'percent')
                        TextField(
                          controller: manualPercentController,
                          decoration: const InputDecoration(
                            labelText: 'Discount Percentage',
                            hintText: '0-100',
                            suffixText: '%',
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                        )
                      else
                        TextField(
                          controller: manualAmountController,
                          decoration: InputDecoration(
                            labelText: 'Discount Amount',
                            hintText: 'Max: ₹${currentItem.lineSubtotal.toStringAsFixed(2)}',
                            prefixText: '₹',
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _applyManualDiscount,
                        icon: const Icon(Icons.check),
                        label: const Text('Apply Manual Discount'),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Current discount summary
              if (currentItem.appliedDiscounts.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Applied Discount',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Only show the first discount since we enforce one discount per item
                      if (currentItem.appliedDiscounts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  currentItem.appliedDiscounts.first.discountName,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                '-₹${currentItem.appliedDiscounts.first.calculatedAmount.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              
              // Final totals
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      Text('₹${currentItem.lineSubtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  if (currentItem.effectiveDiscountAmount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount:'),
                        Text(
                          '-₹${currentItem.effectiveDiscountAmount.toStringAsFixed(2)}',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                  ],
                  if (currentItem.effectiveTaxAmount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tax (${currentItem.taxPercent}%):'),
                        Text('+₹${currentItem.effectiveTaxAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Line Total:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${currentItem.lineTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}