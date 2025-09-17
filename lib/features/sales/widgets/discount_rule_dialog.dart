import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/discount.dart';
import '../providers/discount_provider.dart';
import '../../products/providers/product_providers.dart';
import '../../../core/utils/logger.dart';

class DiscountRuleDialog extends ConsumerStatefulWidget {
  final Discount? existingDiscount;

  const DiscountRuleDialog({
    super.key,
    this.existingDiscount,
  });

  @override
  ConsumerState<DiscountRuleDialog> createState() => _DiscountRuleDialogState();
}

class _DiscountRuleDialogState extends ConsumerState<DiscountRuleDialog> {
  static final _logger = Logger('DiscountRuleDialog');
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _codeController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _buyQuantityController = TextEditingController();
  final _getQuantityController = TextEditingController();
  final _usageLimitController = TextEditingController();
  final _perCustomerLimitController = TextEditingController();

  DiscountType _selectedType = DiscountType.percentage;
  DiscountScope _selectedScope = DiscountScope.cart;
  bool _isAutoApply = false;
  bool _requiresCoupon = false;
  DateTime? _validFrom;
  DateTime? _validUntil;
  TimeOfDay? _validFromTime;
  TimeOfDay? _validUntilTime;
  
  final Set<int> _selectedDays = {};
  final Set<String> _selectedProductIds = {};
  final Set<String> _selectedCategoryIds = {};

  final List<String> _weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
    'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingDiscount != null) {
      _loadExistingDiscount();
    }
  }

  void _loadExistingDiscount() {
    final discount = widget.existingDiscount!;
    _nameController.text = discount.name;
    _descriptionController.text = discount.description ?? '';
    _valueController.text = discount.value.toString();
    _codeController.text = discount.couponCode ?? '';
    _minAmountController.text = discount.minimumAmount?.toString() ?? '';
    _maxDiscountController.text = discount.maximumDiscount?.toString() ?? '';
    
    _selectedType = discount.type;
    _selectedScope = discount.scope;
    _isAutoApply = discount.isAutoApply;
    _requiresCoupon = discount.couponCode != null;
    _validFrom = discount.validFrom;
    _validUntil = discount.validUntil;
    
    if (discount.categoryId != null) {
      _selectedCategoryIds.add(discount.categoryId!);
    }
    if (discount.productId != null) {
      _selectedProductIds.add(discount.productId!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _codeController.dispose();
    _minAmountController.dispose();
    _maxDiscountController.dispose();
    _minQuantityController.dispose();
    _buyQuantityController.dispose();
    _getQuantityController.dispose();
    _usageLimitController.dispose();
    _perCustomerLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Dialog(
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.85,
        constraints: const BoxConstraints(
          maxWidth: 1000,
          minWidth: 600,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.discount,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.existingDiscount != null
                        ? 'Edit Discount Rule'
                        : 'Create Discount Rule',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information Section
                      _buildSectionHeader('Basic Information'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Discount Name *',
                                hintText: 'e.g., Happy Hour Special',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.label),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a discount name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<DiscountType>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Discount Type',
                                border: OutlineInputBorder(),
                              ),
                              items: DiscountType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type == DiscountType.percentage
                                      ? 'Percentage'
                                      : 'Fixed Amount'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _valueController,
                              decoration: InputDecoration(
                                labelText: _selectedType == DiscountType.percentage
                                    ? 'Discount Percentage *'
                                    : 'Discount Amount *',
                                hintText: _selectedType == DiscountType.percentage
                                    ? 'e.g., 20'
                                    : 'e.g., 100',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.percent),
                                suffixText: _selectedType == DiscountType.percentage
                                    ? '%'
                                    : '₹',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a discount value';
                                }
                                final parsed = double.tryParse(value);
                                if (parsed == null || parsed <= 0) {
                                  return 'Please enter a valid positive number';
                                }
                                if (_selectedType == DiscountType.percentage && parsed > 100) {
                                  return 'Percentage cannot exceed 100%';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<DiscountScope>(
                              value: _selectedScope,
                              decoration: const InputDecoration(
                                labelText: 'Apply To',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: DiscountScope.cart,
                                  child: Text('Entire Cart'),
                                ),
                                DropdownMenuItem(
                                  value: DiscountScope.category,
                                  child: Text('Specific Categories'),
                                ),
                                DropdownMenuItem(
                                  value: DiscountScope.item,
                                  child: Text('Specific Products'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedScope = value!;
                                  // Clear selections when changing scope
                                  _selectedProductIds.clear();
                                  _selectedCategoryIds.clear();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Optional description for internal reference',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 2,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Application Settings Section
                      _buildSectionHeader('Application Settings'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Auto Apply'),
                              subtitle: const Text('Automatically apply when conditions are met'),
                              value: _isAutoApply,
                              onChanged: (value) {
                                setState(() {
                                  _isAutoApply = value;
                                  if (value) {
                                    _requiresCoupon = false;
                                  }
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: SwitchListTile(
                              title: const Text('Requires Coupon'),
                              subtitle: const Text('Customer must enter a code'),
                              value: _requiresCoupon,
                              onChanged: _isAutoApply ? null : (value) {
                                setState(() {
                                  _requiresCoupon = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      if (_requiresCoupon) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            labelText: 'Coupon Code *',
                            hintText: 'e.g., WEEKEND20',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.confirmation_number),
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: _requiresCoupon
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a coupon code';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Conditions Section
                      _buildSectionHeader('Conditions'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _minAmountController,
                              decoration: const InputDecoration(
                                labelText: 'Minimum Purchase Amount',
                                hintText: 'e.g., 500',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.shopping_cart),
                                suffixText: '₹',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (_selectedType == DiscountType.percentage)
                            Expanded(
                              child: TextFormField(
                                controller: _maxDiscountController,
                                decoration: const InputDecoration(
                                  labelText: 'Maximum Discount Amount',
                                  hintText: 'e.g., 200',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.money_off),
                                  suffixText: '₹',
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                ],
                              ),
                            )
                          else
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                      
                      // Product/Category Selection
                      if (_selectedScope != DiscountScope.cart) ...[
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          _selectedScope == DiscountScope.category
                              ? 'Select Categories'
                              : 'Select Products',
                        ),
                        const SizedBox(height: 16),
                        _buildProductCategorySelection(),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Validity Period Section
                      _buildSectionHeader('Validity Period'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Valid From',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _validFrom != null
                                      ? DateFormat('MMM dd, yyyy').format(_validFrom!)
                                      : 'Select start date',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Valid Until',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _validUntil != null
                                      ? DateFormat('MMM dd, yyyy').format(_validUntil!)
                                      : 'Select end date',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Time restrictions
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectTime(context, true),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Daily Start Time',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.access_time),
                                ),
                                child: Text(
                                  _validFromTime != null
                                      ? _validFromTime!.format(context)
                                      : 'All day',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectTime(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Daily End Time',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.access_time),
                                ),
                                child: Text(
                                  _validUntilTime != null
                                      ? _validUntilTime!.format(context)
                                      : 'All day',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Day selection
                      _buildDaySelection(),
                      
                      const SizedBox(height: 24),
                      
                      // Usage Limits Section
                      _buildSectionHeader('Usage Limits'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _usageLimitController,
                              decoration: const InputDecoration(
                                labelText: 'Total Usage Limit',
                                hintText: 'Leave empty for unlimited',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.countertops),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _perCustomerLimitController,
                              decoration: const InputDecoration(
                                labelText: 'Per Customer Limit',
                                hintText: 'Leave empty for unlimited',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer with actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _saveDiscount,
                    icon: const Icon(Icons.save),
                    label: Text(
                      widget.existingDiscount != null ? 'Update' : 'Create',
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

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCategorySelection() {
    final theme = Theme.of(context);
    
    if (_selectedScope == DiscountScope.category) {
      final categoriesState = ref.watch(categoryListNotifierProvider);
      
      if (categoriesState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (categoriesState.error != null) {
        return Center(child: Text('Error loading categories: ${categoriesState.error}'));
      }
      
      final categories = categoriesState.categories;
      
      return Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CheckboxListTile(
              title: Text(category.name),
              subtitle: category.description != null
                  ? Text(category.description!)
                  : null,
              value: _selectedCategoryIds.contains(category.id),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedCategoryIds.add(category.id);
                  } else {
                    _selectedCategoryIds.remove(category.id);
                  }
                });
              },
            );
          },
        ),
      );
    } else {
      final productsState = ref.watch(productListNotifierProvider);
      
      if (productsState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (productsState.error != null) {
        return Center(child: Text('Error loading products: ${productsState.error}'));
      }
      
      final products = productsState.products;
      
      return Container(
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return CheckboxListTile(
              title: Text(product.name),
              subtitle: Text('SKU: ${product.variations.first.sku ?? 'N/A'}'),
              value: _selectedProductIds.contains(product.id),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedProductIds.add(product.id);
                  } else {
                    _selectedProductIds.remove(product.id);
                  }
                });
              },
            );
          },
        ),
      );
    }
  }

  Widget _buildDaySelection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Valid Days',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            return FilterChip(
              label: Text(_weekDays[index]),
              selected: _selectedDays.contains(index),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDays.add(index);
                  } else {
                    _selectedDays.remove(index);
                  }
                });
              },
            );
          }),
        ),
        if (_selectedDays.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'All days (no restriction)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_validFrom ?? DateTime.now())
          : (_validUntil ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _validFrom = picked;
        } else {
          _validUntil = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFrom
          ? (_validFromTime ?? TimeOfDay.now())
          : (_validUntilTime ?? TimeOfDay.now()),
    );
    
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _validFromTime = picked;
        } else {
          _validUntilTime = picked;
        }
      });
    }
  }

  Future<void> _saveDiscount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate product/category selection for specific scopes
    if (_selectedScope == DiscountScope.category && _selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    if (_selectedScope == DiscountScope.item && _selectedProductIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final notifier = ref.read(activeDiscountsProvider.notifier);
      
      if (widget.existingDiscount != null) {
        // Update existing discount
        await notifier.updateDiscount(
          discountId: widget.existingDiscount!.id,
          name: _nameController.text,
          value: double.parse(_valueController.text),
          type: _selectedType,
          scope: _selectedScope,
          code: _requiresCoupon ? _codeController.text : null,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          minimumAmount: _minAmountController.text.isNotEmpty
              ? double.parse(_minAmountController.text)
              : null,
          maximumDiscount: _maxDiscountController.text.isNotEmpty
              ? double.parse(_maxDiscountController.text)
              : null,
          validFrom: _validFrom,
          validUntil: _validUntil,
          autoApply: _isAutoApply,
          requiresCoupon: _requiresCoupon,
          isActive: widget.existingDiscount!.isActive,
          productIds: _selectedProductIds.isNotEmpty
              ? _selectedProductIds.toList()
              : null,
          categoryIds: _selectedCategoryIds.isNotEmpty
              ? _selectedCategoryIds.toList()
              : null,
        );
      } else {
        // Create new discount
        await notifier.addDiscount(
          name: _nameController.text,
          value: double.parse(_valueController.text),
          type: _selectedType,
          scope: _selectedScope,
          code: _requiresCoupon ? _codeController.text : null,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          minimumAmount: _minAmountController.text.isNotEmpty
              ? double.parse(_minAmountController.text)
              : null,
          maximumDiscount: _maxDiscountController.text.isNotEmpty
              ? double.parse(_maxDiscountController.text)
              : null,
          validFrom: _validFrom,
          validUntil: _validUntil,
          autoApply: _isAutoApply,
          requiresCoupon: _requiresCoupon,
          productIds: _selectedProductIds.isNotEmpty
              ? _selectedProductIds.toList()
              : null,
          categoryIds: _selectedCategoryIds.isNotEmpty
              ? _selectedCategoryIds.toList()
              : null,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingDiscount != null
                  ? 'Discount updated successfully'
                  : 'Discount created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      _logger.error('Error saving discount', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}