import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../domain/models/product.dart';

class ProductVariationsSection extends StatefulWidget {
  final List<ProductVariation> variations;
  final ValueChanged<List<ProductVariation>> onVariationsChanged;

  const ProductVariationsSection({
    super.key,
    required this.variations,
    required this.onVariationsChanged,
  });

  @override
  State<ProductVariationsSection> createState() => _ProductVariationsSectionState();
}

class _ProductVariationsSectionState extends State<ProductVariationsSection> {
  late List<ProductVariation> _variations;

  @override
  void initState() {
    super.initState();
    _variations = List.from(widget.variations);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Variations',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage different variations of your product',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _addVariation,
              icon: const Icon(Icons.add),
              label: const Text('Add Variation'),
            ),
          ],
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 24),

        // Variations List
        if (_variations.isEmpty)
          _buildEmptyState()
        else
          ..._variations.asMap().entries.map((entry) {
            final index = entry.key;
            final variation = entry.value;
            return _buildVariationCard(index, variation);
          }),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No variations added',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Add at least one variation for your product',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addVariation,
                icon: const Icon(Icons.add),
                label: const Text('Add First Variation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariationCard(int index, ProductVariation variation) {
    final isDefault = variation.isDefault;
    final canDelete = _variations.length > 1;

    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveDimensions.getContentPadding(context),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.getCardPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Variation Header
            Row(
              children: [
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  'Variation ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (!isDefault)
                  TextButton(
                    onPressed: () => _setAsDefault(index),
                    child: const Text('Set as Default'),
                  ),
                if (canDelete)
                  IconButton(
                    onPressed: () => _removeVariation(index),
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).colorScheme.error,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Variation Name
            TextFormField(
              initialValue: variation.name,
              decoration: const InputDecoration(
                labelText: 'Variation Name *',
                hintText: 'e.g., Small, Medium, Large',
                prefixIcon: Icon(Icons.label),
              ),
              onChanged: (value) => _updateVariation(index, variation.copyWith(name: value)),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Variation name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // SKU and Barcode Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: variation.sku,
                    decoration: const InputDecoration(
                      labelText: 'SKU',
                      hintText: 'Stock Keeping Unit',
                      prefixIcon: Icon(Icons.qr_code_scanner),
                    ),
                    onChanged: (value) => _updateVariation(index, variation.copyWith(sku: value)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: variation.barcode,
                    decoration: const InputDecoration(
                      labelText: 'Barcode',
                      hintText: 'Product barcode',
                      prefixIcon: Icon(Icons.qr_code),
                    ),
                    onChanged: (value) => _updateVariation(index, variation.copyWith(barcode: value)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pricing Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: variation.mrp.toStringAsFixed(2),
                    decoration: const InputDecoration(
                      labelText: 'MRP *',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      final mrp = double.tryParse(value) ?? 0.0;
                      _updateVariation(index, variation.copyWith(mrp: mrp));
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'MRP is required';
                      }
                      final mrp = double.tryParse(value);
                      if (mrp == null || mrp < 0) {
                        return 'Invalid MRP';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: variation.sellingPrice.toStringAsFixed(2),
                    decoration: const InputDecoration(
                      labelText: 'Selling Price *',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      final price = double.tryParse(value) ?? 0.0;
                      _updateVariation(index, variation.copyWith(sellingPrice: price));
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selling price is required';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price < 0) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: variation.purchasePrice?.toStringAsFixed(2) ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Purchase Price',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      final price = value.isEmpty ? null : double.tryParse(value);
                      _updateVariation(index, variation.copyWith(purchasePrice: price));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Checkboxes Row
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('For Sale'),
                    value: variation.isForSale,
                    onChanged: (value) => _updateVariation(
                      index, 
                      variation.copyWith(isForSale: value ?? true),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('For Purchase'),
                    value: variation.isForPurchase,
                    onChanged: (value) => _updateVariation(
                      index, 
                      variation.copyWith(isForPurchase: value ?? false),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Active'),
                    value: variation.isActive,
                    onChanged: (value) => _updateVariation(
                      index, 
                      variation.copyWith(isActive: value ?? true),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addVariation() {
    final newVariation = ProductVariation(
      id: '',
      productId: '',
      name: '',
      sku: '',
      mrp: 0.0,
      sellingPrice: 0.0,
      isDefault: _variations.isEmpty,
      isActive: true,
      displayOrder: _variations.length,
      isForSale: true,
      isForPurchase: false,
    );

    setState(() {
      _variations.add(newVariation);
    });

    widget.onVariationsChanged(_variations);
  }

  void _removeVariation(int index) {
    if (_variations.length <= 1) return;

    final wasDefault = _variations[index].isDefault;

    setState(() {
      _variations.removeAt(index);

      // If removed variation was default, set first one as default
      if (wasDefault && _variations.isNotEmpty) {
        _variations[0] = _variations[0].copyWith(isDefault: true);
      }

      // Update display order
      for (int i = 0; i < _variations.length; i++) {
        _variations[i] = _variations[i].copyWith(displayOrder: i);
      }
    });

    widget.onVariationsChanged(_variations);
  }

  void _updateVariation(int index, ProductVariation updatedVariation) {
    setState(() {
      _variations[index] = updatedVariation;
    });

    widget.onVariationsChanged(_variations);
  }

  void _setAsDefault(int index) {
    setState(() {
      // Remove default from all variations
      for (int i = 0; i < _variations.length; i++) {
        _variations[i] = _variations[i].copyWith(isDefault: false);
      }

      // Set selected as default
      _variations[index] = _variations[index].copyWith(isDefault: true);
    });

    widget.onVariationsChanged(_variations);
  }
}