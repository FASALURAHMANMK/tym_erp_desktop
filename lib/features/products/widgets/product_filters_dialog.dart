import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../providers/product_providers.dart';

class ProductFiltersDialog extends ConsumerWidget {
  const ProductFiltersDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productListState = ref.watch(productListNotifierProvider);
    final categories = ref.watch(categoryListNotifierProvider).categories;
    final brands = ref.watch(brandListNotifierProvider).brands;
    
    return AlertDialog(
      title: const Text('Filter Products'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category filter
            Text(
              'Category',
              style: ResponsiveTypography.getScaledTextStyle(
                context,
                Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 8),
            DropdownButtonFormField<String?>(
              value: productListState.selectedCategoryId,
              decoration: const InputDecoration(
                hintText: 'All Categories',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...categories.map((category) => DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                )),
              ],
              onChanged: (value) {
                ref.read(productListNotifierProvider.notifier)
                    .setSelectedCategory(value);
              },
            ),
            
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            
            // Brand filter
            Text(
              'Brand',
              style: ResponsiveTypography.getScaledTextStyle(
                context,
                Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 8),
            DropdownButtonFormField<String?>(
              value: productListState.selectedBrandId,
              decoration: const InputDecoration(
                hintText: 'All Brands',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Brands'),
                ),
                ...brands.map((brand) => DropdownMenuItem(
                  value: brand.id,
                  child: Text(brand.name),
                )),
              ],
              onChanged: (value) {
                ref.read(productListNotifierProvider.notifier)
                    .setSelectedBrand(value);
              },
            ),
            
            ResponsiveSpacing.getVerticalSpacing(context, 16),
            
            // Active status filter
            Text(
              'Status',
              style: ResponsiveTypography.getScaledTextStyle(
                context,
                Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ResponsiveSpacing.getVerticalSpacing(context, 8),
            SwitchListTile(
              title: const Text('Show active products only'),
              value: productListState.showActiveOnly ?? true,
              onChanged: (_) {
                ref.read(productListNotifierProvider.notifier)
                    .toggleActiveOnly();
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Clear all filters
            final notifier = ref.read(productListNotifierProvider.notifier);
            notifier.setSelectedCategory(null);
            notifier.setSelectedBrand(null);
            if (!(productListState.showActiveOnly ?? true)) {
              notifier.toggleActiveOnly();
            }
            Navigator.pop(context);
          },
          child: const Text('Clear Filters'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}