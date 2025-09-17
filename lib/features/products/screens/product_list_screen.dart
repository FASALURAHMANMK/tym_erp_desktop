import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../domain/models/product.dart';
import '../domain/models/product_brand.dart';
import '../domain/models/product_category.dart';
import '../providers/product_providers.dart';
import '../providers/product_repository_provider.dart';
import '../widgets/product_filters_dialog.dart';
import '../widgets/product_list_tile.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBusiness = ref.watch(selectedBusinessProvider);

    if (selectedBusiness == null) {
      return const Scaffold(
        appBar: null,
        body: Center(child: Text('No business selected')),
      );
    }

    final productListState = ref.watch(productListNotifierProvider);
    final contentPadding = ResponsiveDimensions.getContentPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Products',
          style: ResponsiveTypography.getScaledTextStyle(
            context,
            Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        actions: [
          // Sync button with pending indicator
          FutureBuilder<int>(
            future: () async {
              final repository = await ref.read(productRepositoryFutureProvider.future);
              return repository.getPendingChangesCount();
            }(),
            builder: (context, snapshot) {
              final hasPendingChanges = (snapshot.data ?? 0) > 0;
              
              return Stack(
                children: [
                  IconButton(
                    onPressed: () async {
                      final repository = await ref.read(productRepositoryFutureProvider.future);
                      final result = await repository.syncPendingChanges();
                      
                      if (mounted) {
                        result.fold(
                          (failure) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sync failed: ${failure.message}'),
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sync completed successfully'),
                              ),
                            );
                            // Reload products to reflect any changes
                            ref.read(productListNotifierProvider.notifier).loadProducts();
                          },
                        );
                      }
                    },
                    icon: const Icon(Icons.sync),
                    tooltip: hasPendingChanges 
                      ? 'Sync to Cloud (${snapshot.data} pending)' 
                      : 'Sync to Cloud',
                  ),
                  if (hasPendingChanges)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          // Filter button
          Stack(
            children: [
              IconButton(
                onPressed: () => _showFiltersDialog(context),
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter Products',
              ),
              if (_hasActiveFilters())
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          // Bulk upload button
          IconButton(
            onPressed: () => context.go('/products/bulk-upload'),
            icon: const Icon(Icons.upload_file),
            tooltip: 'Bulk Upload',
          ),
          // Add product button
          IconButton(
            onPressed: () => _navigateToProductForm(context),
            icon: const Icon(Icons.add),
            tooltip: 'Add Product',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          children: [
            // Search bar
            _buildSearchBar(context),

            // Active filters chips
            if (_hasActiveFilters()) ...[
              ResponsiveSpacing.getVerticalSpacing(context, 8),
              _buildActiveFilters(context),
            ],

            ResponsiveSpacing.getVerticalSpacing(context, 16),

            // Products list
            Expanded(
              child:
                  productListState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : productListState.error != null
                      ? _buildErrorState(context, productListState.error!)
                      : _buildProductsList(context, productListState.products),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToProductForm(context),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveDimensions.getCardPadding(context),
          vertical: ResponsiveDimensions.getCardPadding(context) * 0.5,
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products by name, SKU, or barcode...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                _searchQuery.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        ref
                            .read(productListNotifierProvider.notifier)
                            .setSearchQuery(null);
                      },
                      icon: const Icon(Icons.clear),
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: ResponsiveDimensions.getCardPadding(context) * 0.5,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            // Debounce search
            Future.delayed(const Duration(milliseconds: 300), () {
              if (_searchQuery == value) {
                ref
                    .read(productListNotifierProvider.notifier)
                    .setSearchQuery(value.isEmpty ? null : value);
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context) {
    final productListState = ref.watch(productListNotifierProvider);
    final categories = ref.watch(categoryListNotifierProvider).categories;
    final brands = ref.watch(brandListNotifierProvider).brands;

    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (productListState.selectedCategoryId != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(
                  categories
                      .firstWhere(
                        (c) => c.id == productListState.selectedCategoryId,
                        orElse:
                            () => ProductCategory(
                              id: '',
                              businessId: '',
                              name: 'Unknown',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                      )
                      .name,
                ),
                onDeleted: () {
                  ref
                      .read(productListNotifierProvider.notifier)
                      .setSelectedCategory(null);
                },
              ),
            ),
          if (productListState.selectedBrandId != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(
                  brands
                      .firstWhere(
                        (b) => b.id == productListState.selectedBrandId,
                        orElse:
                            () => ProductBrand(
                              id: '',
                              businessId: '',
                              name: 'Unknown',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                      )
                      .name,
                ),
                onDeleted: () {
                  ref
                      .read(productListNotifierProvider.notifier)
                      .setSelectedBrand(null);
                },
              ),
            ),
          if (productListState.showActiveOnly == false)
            Chip(
              label: const Text('Including Inactive'),
              onDeleted: () {
                ref
                    .read(productListNotifierProvider.notifier)
                    .toggleActiveOnly();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder:
          (context, index) => ResponsiveSpacing.getVerticalSpacing(context, 8),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListTile(
          product: product,
          onTap: () => _navigateToProductForm(context, product: product),
          onEdit: () => _navigateToProductForm(context, product: product),
          onDelete: () => _showDeleteProductDialog(context, product),
          onToggleActive: () => _toggleProductActive(product),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasFilters = _hasActiveFilters() || _searchQuery.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.inventory_2_outlined,
            size: ResponsiveDimensions.getIconSize(context) * 3,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          Text(
            hasFilters ? 'No products found' : 'No products yet',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            hasFilters
                ? 'Try adjusting your search or filters'
                : 'Add your first product to get started',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium,
            )?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 24),
          if (hasFilters)
            OutlinedButton.icon(
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Clear Filters'),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _navigateToProductForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ResponsiveDimensions.getIconSize(context) * 2,
            color: Theme.of(context).colorScheme.error,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
          Text(
            'Error loading products',
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 8),
          Text(
            error,
            style: ResponsiveTypography.getScaledTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium,
            )?.copyWith(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
          ElevatedButton.icon(
            onPressed:
                () =>
                    ref
                        .read(productListNotifierProvider.notifier)
                        .loadProducts(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    final state = ref.watch(productListNotifierProvider);
    return state.selectedCategoryId != null ||
        state.selectedBrandId != null ||
        state.showActiveOnly == false;
  }

  void _clearAllFilters() {
    final notifier = ref.read(productListNotifierProvider.notifier);
    notifier.setSelectedCategory(null);
    notifier.setSelectedBrand(null);
    if (!ref.read(productListNotifierProvider).showActiveOnly!) {
      notifier.toggleActiveOnly();
    }
  }

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ProductFiltersDialog(),
    );
  }

  void _navigateToProductForm(BuildContext context, {Product? product}) {
    if (product != null) {
      context.go('/products/edit/${product.id}');
    } else {
      context.go('/products/new');
    }
  }

  void _showDeleteProductDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text(
              'Are you sure you want to delete "${product.name}"?\n\n'
              'This will mark the product as inactive and it will no longer appear in sales.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final result = await ref
                      .read(productListNotifierProvider.notifier)
                      .deleteProduct(product.id);

                  if (mounted) {
                    result.fold(
                      (failure) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${failure.message}'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      (_) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product deleted successfully'),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _toggleProductActive(Product product) async {
    final updatedProduct = product.copyWith(isActive: !product.isActive);
    final result = await ref
        .read(productListNotifierProvider.notifier)
        .updateProduct(updatedProduct);

    if (mounted) {
      result.fold(
        (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${failure.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              product.isActive
                  ? 'Product deactivated successfully'
                  : 'Product activated successfully',
            ),
          ),
        ),
      );
    }
  }
}
