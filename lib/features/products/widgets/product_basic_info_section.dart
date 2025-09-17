import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../sales/providers/tax_provider.dart';
import '../domain/models/product.dart';
import '../providers/product_providers.dart';

class ProductBasicInfoSection extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController nameAltController;
  final TextEditingController descriptionController;
  final TextEditingController descriptionAltController;
  final TextEditingController barcodeController;
  final TextEditingController hsnController;
  final TextEditingController shortCodeController;
  final TextEditingController tagsController;
  final String? selectedCategoryId;
  final String? selectedBrandId;
  final UnitOfMeasure unitOfMeasure;
  final ProductType productType;
  final double taxRate; // Deprecated
  final String? taxGroupId; // Deprecated
  final String? taxRateId;
  final bool isActive;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBrandChanged;
  final ValueChanged<UnitOfMeasure?> onUnitChanged;
  final ValueChanged<ProductType?> onProductTypeChanged;
  final ValueChanged<double> onTaxRateChanged; // Deprecated
  final ValueChanged<String?> onTaxGroupChanged; // Deprecated
  final ValueChanged<String?> onSpecificTaxRateChanged;
  final ValueChanged<bool> onActiveChanged;

  const ProductBasicInfoSection({
    super.key,
    required this.nameController,
    required this.nameAltController,
    required this.descriptionController,
    required this.descriptionAltController,
    required this.barcodeController,
    required this.hsnController,
    required this.shortCodeController,
    required this.tagsController,
    required this.selectedCategoryId,
    required this.selectedBrandId,
    required this.unitOfMeasure,
    required this.productType,
    required this.taxRate, // Deprecated
    this.taxGroupId, // Deprecated
    this.taxRateId,
    required this.isActive,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    required this.onUnitChanged,
    required this.onProductTypeChanged,
    required this.onTaxRateChanged, // Deprecated
    required this.onTaxGroupChanged, // Deprecated
    required this.onSpecificTaxRateChanged,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListNotifierProvider).categories;
    final brands = ref.watch(brandListNotifierProvider).brands;
    final taxGroupsAsync = ref.watch(taxGroupsProvider);
    final taxGroups = taxGroupsAsync.valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name *',
            hintText: 'Enter product name',
            prefixIcon: Icon(Icons.inventory_2),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
            }
            if (value.trim().length < 2) {
              return 'Product name must be at least 2 characters';
            }
            return null;
          },
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Product Name in Alternate Language
        TextFormField(
          controller: nameAltController,
          decoration: const InputDecoration(
            labelText: 'Product Name (Alternate Language)',
            hintText: 'Enter product name in alternate language',
            prefixIcon: Icon(Icons.translate),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Description
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Enter product description',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Description in Alternate Language
        TextFormField(
          controller: descriptionAltController,
          decoration: const InputDecoration(
            labelText: 'Description (Alternate Language)',
            hintText: 'Enter description in alternate language',
            prefixIcon: Icon(Icons.translate),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 24),

        // Category and Brand Row
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  prefixIcon: Icon(Icons.category),
                ),
                items:
                    categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                onChanged: onCategoryChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedBrandId,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  prefixIcon: Icon(Icons.branding_watermark),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No Brand')),
                  ...brands.map(
                    (brand) => DropdownMenuItem(
                      value: brand.id,
                      child: Text(brand.name),
                    ),
                  ),
                ],
                onChanged: onBrandChanged,
              ),
            ),
          ],
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Unit of Measure and Product Type Row
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<UnitOfMeasure>(
                value: unitOfMeasure,
                decoration: const InputDecoration(
                  labelText: 'Unit of Measure',
                  prefixIcon: Icon(Icons.straighten),
                ),
                items:
                    UnitOfMeasure.values
                        .map(
                          (unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(_getUnitDisplayName(unit)),
                          ),
                        )
                        .toList(),
                onChanged: onUnitChanged,
              ),
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 16),
            Expanded(
              child: DropdownButtonFormField<ProductType>(
                value: productType,
                decoration: const InputDecoration(
                  labelText: 'Product Type',
                  prefixIcon: Icon(Icons.category),
                ),
                items:
                    ProductType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(_getProductTypeDisplayName(type)),
                          ),
                        )
                        .toList(),
                onChanged: onProductTypeChanged,
              ),
            ),
          ],
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Barcode and HSN Row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Barcode',
                  hintText: 'Enter barcode',
                  prefixIcon: Icon(Icons.qr_code),
                ),
              ),
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 16),
            Expanded(
              child: TextFormField(
                controller: hsnController,
                decoration: const InputDecoration(
                  labelText: 'HSN Code',
                  hintText: 'Enter HSN code',
                  prefixIcon: Icon(Icons.code),
                ),
              ),
            ),
          ],
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Short Code and Tax Rate Row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: shortCodeController,
                decoration: const InputDecoration(
                  labelText: 'Short Code',
                  hintText: 'Enter short code',
                  prefixIcon: Icon(Icons.short_text),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ),
            ResponsiveSpacing.getHorizontalSpacing(context, 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  // Build the list of available tax rates
                  final availableTaxRateIds = <String>{};
                  final taxRateItems = <DropdownMenuItem<String>>[
                    const DropdownMenuItem(value: null, child: Text('No Tax')),
                  ];
                  
                  for (final group in taxGroups) {
                    final activeRates = group.taxRates.where((rate) => rate.isActive).toList();
                    for (final rate in activeRates) {
                      availableTaxRateIds.add(rate.id);
                      taxRateItems.add(
                        DropdownMenuItem(
                          value: rate.id,
                          child: Text('${group.name} - ${rate.name} (${rate.rate}%)'),
                        ),
                      );
                    }
                  }
                  
                  // Validate that the selected taxRateId exists in available rates
                  final validatedTaxRateId = (taxRateId != null && availableTaxRateIds.contains(taxRateId))
                      ? taxRateId
                      : null;
                  
                  return DropdownButtonFormField<String>(
                    value: validatedTaxRateId,
                    decoration: const InputDecoration(
                      labelText: 'Tax Rate',
                      prefixIcon: Icon(Icons.receipt_long),
                    ),
                    items: taxRateItems,
                    onChanged: onSpecificTaxRateChanged,
                  );
                },
              ),
            ),
          ],
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Tags
        TextFormField(
          controller: tagsController,
          decoration: const InputDecoration(
            labelText: 'Tags',
            hintText: 'Enter tags separated by commas',
            prefixIcon: Icon(Icons.label),
            helperText: 'e.g., vegetarian, spicy, gluten-free',
          ),
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 16),

        // Active Status
        Card(
          child: SwitchListTile(
            title: const Text('Active'),
            subtitle: const Text('Product is available for sale'),
            value: isActive,
            onChanged: onActiveChanged,
            secondary: Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  String _getUnitDisplayName(UnitOfMeasure unit) {
    switch (unit) {
      case UnitOfMeasure.count:
        return 'Count';
      case UnitOfMeasure.kg:
        return 'Kilogram (kg)';
      case UnitOfMeasure.gram:
        return 'Gram (g)';
      case UnitOfMeasure.liter:
        return 'Liter (L)';
      case UnitOfMeasure.ml:
        return 'Milliliter (ml)';
      case UnitOfMeasure.meter:
        return 'Meter (m)';
      case UnitOfMeasure.cm:
        return 'Centimeter (cm)';
      case UnitOfMeasure.piece:
        return 'Piece';
      case UnitOfMeasure.box:
        return 'Box';
      case UnitOfMeasure.dozen:
        return 'Dozen';
      case UnitOfMeasure.pack:
        return 'Pack';
    }
  }

  String _getProductTypeDisplayName(ProductType type) {
    switch (type) {
      case ProductType.physical:
        return 'Physical Product';
      case ProductType.service:
        return 'Service';
      case ProductType.digital:
        return 'Digital Product';
    }
  }
}
