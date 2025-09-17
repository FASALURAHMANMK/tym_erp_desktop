import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/products/domain/models/product.dart';
import '../../../../features/products/domain/models/product_category.dart';
import '../../../../features/sales/models/table.dart';
import '../../cart/providers/waiter_cart_provider.dart';
import '../providers/waiter_products_provider.dart';

/// Product browsing screen for waiters
class WaiterProductsScreen extends ConsumerStatefulWidget {
  final RestaurantTable table;

  const WaiterProductsScreen({
    super.key,
    required this.table,
  });

  @override
  ConsumerState<WaiterProductsScreen> createState() => _WaiterProductsScreenState();
}

class _WaiterProductsScreenState extends ConsumerState<WaiterProductsScreen> {
  static final _logger = Logger('WaiterProductsScreen');
  
  String? _selectedCategoryId;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _logger.info('Opening products for table: ${widget.table.displayText}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(waiterCartNotifierProvider);
    final itemCount = cart?.items.length ?? 0;
    final cartTotal = cart?.calculatedTotal ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Products'),
            Text(
              'Table ${widget.table.displayText}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          // Cart badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: itemCount > 0 
                  ? () => context.push('/waiter/tables/${widget.table.id}/cart', extra: widget.table)
                  : null,
              ),
              if (itemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$itemCount',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(8),
              color: theme.colorScheme.surfaceContainerHighest,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild for search
                },
              ),
            ),

          // Category chips
          if (!_isSearching) _buildCategoryChips(),

          // Products grid
          Expanded(
            child: _searchController.text.isNotEmpty
                ? _buildSearchResults()
                : _buildProductGrid(),
          ),
        ],
      ),
      // Bottom bar with cart summary
      bottomNavigationBar: itemCount > 0
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$itemCount items',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          '₹${cartTotal.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () => context.push('/waiter/tables/${widget.table.id}/cart', extra: widget.table),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('View Cart'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCategoryChips() {
    final categoriesAsync = ref.watch(waiterProductCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        // Add "All" category at the beginning
        final allCategories = [
          ProductCategory(
            id: '',
            businessId: '',
            name: 'All',
            description: 'All products',
            displayOrder: -1,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          ...categories,
        ];

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = _selectedCategoryId == category.id ||
                  (category.id.isEmpty && _selectedCategoryId == null);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategoryId = category.id.isEmpty ? null : category.id;
                    });
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => SizedBox(
        height: 50,
        child: Center(
          child: Text('Error loading categories: $error'),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final productsAsync = ref.watch(
      waiterProductsByCategoryProvider(_selectedCategoryId),
    );
    final pricesAsync = ref.watch(waiterVariationPricesProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return pricesAsync.when(
          data: (prices) => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductCard(
                product: product,
                variationPrices: prices,
                onAddToCart: (variation) => _addToCart(product, variation),
              );
            },
          ),
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductCard(
                product: product,
                variationPrices: const {},
                onAddToCart: (variation) => _addToCart(product, variation),
              );
            },
          ),
          error: (_, __) => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductCard(
                product: product,
                variationPrices: const {},
                onAddToCart: (variation) => _addToCart(product, variation),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(waiterProductsByCategoryProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final searchAsync = ref.watch(
      waiterProductSearchProvider(_searchController.text),
    );
    final pricesAsync = ref.watch(waiterVariationPricesProvider);

    return searchAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64),
                const SizedBox(height: 16),
                Text('No products found for "${_searchController.text}"'),
              ],
            ),
          );
        }

        return pricesAsync.when(
          data: (prices) => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductCard(
                product: product,
                variationPrices: prices,
                onAddToCart: (variation) => _addToCart(product, variation),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductCard(
                product: product,
                variationPrices: const {},
                onAddToCart: (variation) => _addToCart(product, variation),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Error searching: $error'),
      ),
    );
  }

  void _addToCart(Product product, dynamic variation) {
    final prices = ref.read(waiterVariationPricesProvider).valueOrNull ?? {};
    final price = prices[variation.id] ?? variation.sellingPrice;

    ref.read(waiterCartNotifierProvider.notifier).addItem(
      productId: product.id,
      variationId: variation.id,
      productName: product.name,
      variationName: variation.name,
      productCode: product.shortCode ?? '',
      sku: variation.sku ?? '',
      unitOfMeasure: product.unitOfMeasure.name,
      categoryId: product.categoryId,
      categoryName: 'Products', // We don't have category name in product model
      quantity: 1,
      unitPrice: price,
      taxRate: product.taxRate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${product.name} to cart'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            context.push('/waiter/tables/${widget.table.id}/cart', extra: widget.table);
          },
        ),
      ),
    );
  }

}

/// Product card widget
class _ProductCard extends StatelessWidget {
  final Product product;
  final Map<String, double> variationPrices;
  final Function(dynamic) onAddToCart; // Using dynamic for variation

  const _ProductCard({
    required this.product,
    required this.variationPrices,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final variations = product.variations;

    if (variations.isEmpty) {
      return Card(
        child: Center(
          child: Text(
            '${product.name}\n(No variations)',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // For single variation, show simple card
    if (variations.length == 1) {
      final variation = variations.first;
      final price = variationPrices[variation.id] ?? variation.sellingPrice;

      return Card(
        child: InkWell(
          onTap: () => onAddToCart(variation),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image placeholder
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.fastfood,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Product name
                Text(
                  product.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () => onAddToCart(variation),
                      icon: const Icon(Icons.add),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // For multiple variations, show selection dialog on tap
    return Card(
      child: InkWell(
        onTap: () => _showVariationDialog(context, variations),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image placeholder
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.fastfood,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Product name
              Text(
                product.name,
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Variation count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${variations.length} options',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const Spacer(),
              // Price range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getPriceRange(variations),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriceRange(List<dynamic> variations) {
    final prices = variations.map((v) {
      return variationPrices[v.id] ?? v.sellingPrice;
    }).toList();
    
    prices.sort();
    final min = prices.first;
    final max = prices.last;

    if (min == max) {
      return '₹${min.toStringAsFixed(2)}';
    }
    return '₹${min.toStringAsFixed(0)} - ${max.toStringAsFixed(0)}';
  }

  void _showVariationDialog(BuildContext context, List<dynamic> variations) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: variations.length,
                itemBuilder: (context, index) {
                  final variation = variations[index];
                  final price = variationPrices[variation.id] ?? variation.sellingPrice;

                  return ListTile(
                    title: Text(variation.name),
                    subtitle: Text(variation.sku),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () {
                            onAddToCart(variation);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}