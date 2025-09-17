import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../models/price_category.dart';
import '../models/cart_item.dart';
import '../models/tax_config.dart';
import '../providers/cart_provider.dart';
import '../providers/tax_provider.dart';
import '../../products/providers/product_provider.dart';
import '../../products/domain/models/product.dart';
import '../../../core/utils/logger.dart';

class ProductGridView extends ConsumerStatefulWidget {
  final PriceCategory priceCategory;
  
  const ProductGridView({
    super.key,
    required this.priceCategory,
  });

  @override
  ConsumerState<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends ConsumerState<ProductGridView> {
  static final _logger = Logger('ProductGridView');
  
  String? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }
  
  List<Product> _filterProducts(List<Product> products) {
    var filtered = products;
    
    // Filter by category
    if (_selectedCategoryId != null) {
      filtered = filtered.where((p) => p.categoryId == _selectedCategoryId).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(query) ||
               (p.shortCode?.toLowerCase().contains(query) ?? false) ||
               (p.barcode?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
    
    return filtered;
  }
  
  void _addProductToCart(Product product) {
    if (product.variations.isEmpty) {
      _logger.warning('Product ${product.name} has no variations');
      return;
    }
    
    // If product has multiple variations, show selection dialog
    if (product.variations.length > 1) {
      _showVariationSelectionDialog(product);
      return;
    }
    
    // Single variation - add directly
    final variation = product.variations.first;
    _addVariationToCart(product, variation);
  }
  
  void _addVariationToCart(Product product, ProductVariation variation) async {
    // Get price for current price category
    final price = _getPriceForCategory(variation);
    
    // Calculate tax based on product's specific tax rate
    double taxPercent = 0;
    final productTaxRateId = product.taxRateId;
    _logger.info('Product ${product.name} - taxRateId: $productTaxRateId, taxGroupId: ${product.taxGroupId}, taxRate: ${product.taxRate}');
    if (productTaxRateId != null) {
      final taxGroups = await ref.read(taxGroupsProvider.future);
      // Find the specific tax rate across all groups
      for (final group in taxGroups) {
        final rate = group.taxRates.firstWhereOrNull(
          (r) => r.id == productTaxRateId,
        );
        if (rate != null && rate.isActive && rate.type == TaxType.percentage) {
          taxPercent = rate.rate;
          break;
        }
      }
    } else if (product.taxGroupId != null) {
      // Fallback to deprecated taxGroupId field (use first active rate)
      final taxGroups = await ref.read(taxGroupsProvider.future);
      final taxGroup = taxGroups.firstWhereOrNull(
        (g) => g.id == product.taxGroupId,
      );
      if (taxGroup != null && taxGroup.taxRates.isNotEmpty) {
        final firstActiveRate = taxGroup.taxRates.firstWhereOrNull(
          (r) => r.isActive && r.type == TaxType.percentage,
        );
        if (firstActiveRate != null) {
          taxPercent = firstActiveRate.rate;
        }
      }
    } else {
      // Fallback to deprecated taxRate field
      taxPercent = product.taxRate;
    }
    
    final cartItem = CartItem.fromProduct(
      product: product,
      variation: variation,
      price: price,
      quantity: 1,
      taxPercent: taxPercent,
    );
    
    ref.read(cartNotifierProvider.notifier).addItem(cartItem);
    _logger.info('Added ${product.name} (${variation.name}) to cart at ₹$price with $taxPercent% tax');
  }
  
  double _getPriceForCategory(ProductVariation variation) {
    // Check if this price category has a specific price override
    final priceCategoryId = widget.priceCategory.id;
    
    if (variation.categoryPrices.containsKey(priceCategoryId)) {
      return variation.categoryPrices[priceCategoryId]!;
    }
    
    // Fall back to the default selling price
    return variation.sellingPrice;
  }
  
  void _showVariationSelectionDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${product.name} Variation'),
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: product.variations.length,
            itemBuilder: (context, index) {
              final variation = product.variations[index];
              final price = _getPriceForCategory(variation);
              
              return ListTile(
                title: Text(variation.name),
                subtitle: variation.sku != null ? Text('SKU: ${variation.sku}') : null,
                trailing: Text(
                  '₹${price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _addVariationToCart(product, variation);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Search bar and action buttons
        Container(
          padding: const EdgeInsets.all(16),
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              // Search and action buttons row
              Row(
                children: [
                  // Search field
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search by product name, SKU, or barcode...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Quick Sale button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Open quick sale dialog
                    },
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Quick Sale'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Add Items button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Open add items dialog
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Items'),
                  ),
                  const SizedBox(width: 8),
                  // Add Expense button
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Open add expense dialog
                    },
                    icon: const Icon(Icons.money_off),
                    label: const Text('Add Expense'),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Main content area
        Expanded(
          child: Row(
            children: [
              // Category sidebar
              Container(
                width: 180,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: Border(
                    right: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: ref.watch(currentBusinessCategoriesProvider).when(
                  data: (categories) => ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _CategoryTile(
                        label: 'All',
                        isSelected: _selectedCategoryId == null,
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = null;
                          });
                        },
                      ),
                      ...categories.map((category) => _CategoryTile(
                        label: category.name,
                        isSelected: _selectedCategoryId == category.id,
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.id;
                          });
                        },
                      )),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Error loading categories'),
                  ),
                ),
              ),
              
              // Product grid
              Expanded(
                child: ref.watch(currentBusinessProductsProvider).when(
                  data: (products) {
                    final filteredProducts = _filterProducts(products);
                    
                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                ? 'No products found for "$_searchQuery"'
                                : _selectedCategoryId != null
                                  ? 'No products in this category'
                                  : 'No products available',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    // Get cart items to show quantities
                    final cart = ref.watch(cartNotifierProvider);
                    
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        
                        // Get display price (from first variation or default)
                        double displayPrice = 0.0;
                        String priceRange = '';
                        
                        if (product.variations.isNotEmpty) {
                          // Get prices for all variations in this category
                          final prices = product.variations.map((v) => 
                            _getPriceForCategory(v)
                          ).toSet().toList()..sort();
                          
                          if (prices.length == 1) {
                            displayPrice = prices.first;
                          } else {
                            // Show price range for multiple variations
                            displayPrice = prices.first;
                            priceRange = '₹${prices.first.toStringAsFixed(0)} - ₹${prices.last.toStringAsFixed(0)}';
                          }
                        }
                        
                        // Calculate total quantity in cart for all variations
                        int quantityInCart = 0;
                        if (cart != null) {
                          final cartItems = cart.items.where(
                            (item) => item.productId == product.id
                          );
                          for (final item in cartItems) {
                            quantityInCart += item.quantity.toInt();
                          }
                        }
                        
                        return _ProductCard(
                          name: product.name,
                          price: displayPrice,
                          priceRange: priceRange,
                          hasVariations: product.variations.length > 1,
                          variationCount: product.variations.length,
                          quantity: quantityInCart,
                          onTap: () => _addProductToCart(product),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error loading products: $error'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _CategoryTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : null,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected 
              ? theme.colorScheme.onPrimary 
              : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String priceRange;
  final bool hasVariations;
  final int variationCount;
  final int quantity;
  final VoidCallback onTap;
  
  const _ProductCard({
    required this.name,
    required this.price,
    this.priceRange = '',
    this.hasVariations = false,
    this.variationCount = 1,
    required this.quantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Product name
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Variation indicator
                  if (hasVariations) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$variationCount variations',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  // Price or price range
                  if (priceRange.isNotEmpty)
                    Text(
                      priceRange,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      '₹${price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            
            // Quantity badge
            if (quantity > 0)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        quantity.toString(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
