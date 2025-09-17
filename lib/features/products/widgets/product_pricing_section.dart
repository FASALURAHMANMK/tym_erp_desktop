import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive_utils.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../sales/models/price_category.dart';
import '../../sales/providers/price_category_provider.dart';
import '../domain/models/product.dart';

class ProductPricingSection extends ConsumerStatefulWidget {
  final List<ProductVariation> variations;
  final ValueChanged<List<ProductVariation>> onVariationsChanged;

  const ProductPricingSection({
    super.key,
    required this.variations,
    required this.onVariationsChanged,
  });

  @override
  ConsumerState<ProductPricingSection> createState() => _ProductPricingSectionState();
}

class _ProductPricingSectionState extends ConsumerState<ProductPricingSection> {
  late List<ProductVariation> _variations;
  int _selectedVariationIndex = 0;
  
  // Text controllers for base prices
  late TextEditingController _mrpController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _purchasePriceController;
  
  // Map of text controllers for category prices (categoryId -> controller)
  final Map<String, TextEditingController> _categoryPriceControllers = {};
  
  @override
  void initState() {
    super.initState();
    _variations = List.from(widget.variations);
    _initializeControllers();
  }
  
  void _initializeControllers() {
    if (_variations.isEmpty) {
      _mrpController = TextEditingController(text: '0.00');
      _sellingPriceController = TextEditingController(text: '0.00');
      _purchasePriceController = TextEditingController(text: '');
      return;
    }
    
    final variation = _variations[_selectedVariationIndex];
    
    _mrpController = TextEditingController(
      text: variation.mrp.toStringAsFixed(2),
    );
    _sellingPriceController = TextEditingController(
      text: variation.sellingPrice.toStringAsFixed(2),
    );
    _purchasePriceController = TextEditingController(
      text: variation.purchasePrice?.toStringAsFixed(2) ?? '',
    );
  }
  
  void _updateControllersForVariation() {
    final variation = _variations[_selectedVariationIndex];
    _mrpController.text = variation.mrp.toStringAsFixed(2);
    _sellingPriceController.text = variation.sellingPrice.toStringAsFixed(2);
    _purchasePriceController.text = variation.purchasePrice?.toStringAsFixed(2) ?? '';
    
    // Update category price controllers
    for (final entry in _categoryPriceControllers.entries) {
      final categoryId = entry.key;
      final controller = entry.value;
      final categoryPrice = variation.categoryPrices[categoryId];
      controller.text = categoryPrice?.toStringAsFixed(2) ?? '';
    }
  }
  
  void _initializeCategoryControllers(List<PriceCategory> priceCategories) {
    final variation = _variations[_selectedVariationIndex];
    
    for (final category in priceCategories) {
      if (!_categoryPriceControllers.containsKey(category.id)) {
        final categoryPrice = variation.categoryPrices[category.id];
        _categoryPriceControllers[category.id] = TextEditingController(
          text: categoryPrice?.toStringAsFixed(2) ?? '',
        );
      }
    }
  }
  
  @override
  void dispose() {
    _mrpController.dispose();
    _sellingPriceController.dispose();
    _purchasePriceController.dispose();
    // Dispose all category price controllers
    for (final controller in _categoryPriceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final business = ref.watch(selectedBusinessProvider);
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);
    
    return selectedLocationAsync.when(
      data: (selectedLocation) {
        if (business == null || selectedLocation == null) {
          return const Center(
            child: Text('Please select a business and location'),
          );
        }

        final priceCategoriesAsync = ref.watch(
          priceCategoriesProvider((business.id, selectedLocation.id)),
        );

        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Set different prices for each price category and variation',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        ResponsiveSpacing.getVerticalSpacing(context, 24),

        // Variation selector if multiple variations exist
        if (_variations.length > 1) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Variation',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _variations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final variation = entry.value;
                      return ChoiceChip(
                        label: Text(variation.name),
                        selected: _selectedVariationIndex == index,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedVariationIndex = index;
                              _updateControllersForVariation();
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          ResponsiveSpacing.getVerticalSpacing(context, 16),
        ],

        // Price categories pricing
        priceCategoriesAsync.when(
          data: (priceCategories) {
            if (priceCategories.isEmpty) {
              return _buildEmptyState();
            }
            
            // Initialize controllers for new categories if needed
            _initializeCategoryControllers(priceCategories);
            
            return Column(
              children: [
                // Base prices card
                _buildBasePricesCard(),
                ResponsiveSpacing.getVerticalSpacing(context, 16),
                
                // Price category overrides card
                _buildPriceCategoryOverridesCard(priceCategories),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error loading price categories: $error'),
          ),
        ),
      ],
    );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading location: $error'),
      ),
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
                Icons.price_change_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No price categories found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Price categories will be created automatically when you create a location',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasePricesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Base Prices',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _mrpController,
                    decoration: const InputDecoration(
                      labelText: 'MRP',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      final mrp = double.tryParse(value) ?? 0.0;
                      _updateVariation(_selectedVariationIndex, (v) => v.copyWith(mrp: mrp));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _sellingPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Default Selling Price',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      final price = double.tryParse(value) ?? 0.0;
                      _updateVariation(_selectedVariationIndex, (v) => v.copyWith(sellingPrice: price));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _purchasePriceController,
                    decoration: const InputDecoration(
                      labelText: 'Purchase Price (Optional)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      final price = value.isEmpty ? null : double.tryParse(value);
                      _updateVariation(_selectedVariationIndex, (v) => v.copyWith(purchasePrice: price));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCategoryOverridesCard(List<PriceCategory> priceCategories) {
    final variation = _variations[_selectedVariationIndex];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Price Category Overrides',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _applyDefaultPriceToAll(variation.sellingPrice),
                  icon: const Icon(Icons.content_copy, size: 16),
                  label: const Text('Apply Default to All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Leave empty to use the default selling price',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            
            // Price category grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 800 ? 3 : 
                                       constraints.maxWidth > 500 ? 2 : 1;
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: priceCategories.length,
                  itemBuilder: (context, index) {
                    final category = priceCategories[index];
                    final currentPrice = variation.categoryPrices[category.id];
                    
                    return _buildPriceCategoryField(category, currentPrice);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCategoryField(PriceCategory category, double? currentPrice) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Category icon and name
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    size: 16,
                    color: _getCategoryColor(category),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (category.description != null)
                        Text(
                          category.description!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Price input
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: _categoryPriceControllers[category.id],
              decoration: InputDecoration(
                hintText: 'Default',
                prefixText: '₹ ',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: category.isDefault,
                fillColor: category.isDefault 
                    ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : null,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              onChanged: (value) {
                final price = value.isEmpty ? null : double.tryParse(value);
                _updateCategoryPrice(category.id, price);
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(PriceCategory category) {
    switch (category.type) {
      case PriceCategoryType.dineIn:
        return Icons.restaurant;
      case PriceCategoryType.takeaway:
        return Icons.takeout_dining;
      case PriceCategoryType.delivery:
        return Icons.delivery_dining;
      case PriceCategoryType.catering:
        return Icons.celebration;
      case PriceCategoryType.custom:
        return Icons.star;
    }
  }

  Color _getCategoryColor(PriceCategory category) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (category.colorHex != null) {
      try {
        return Color(int.parse(category.colorHex!.replaceAll('#', '0xFF')));
      } catch (_) {
        // Fall through to default colors
      }
    }
    
    switch (category.type) {
      case PriceCategoryType.dineIn:
        return colorScheme.primary;
      case PriceCategoryType.takeaway:
        return Colors.orange;
      case PriceCategoryType.delivery:
        return Colors.blue;
      case PriceCategoryType.catering:
        return Colors.purple;
      case PriceCategoryType.custom:
        return colorScheme.tertiary;
    }
  }

  void _updateVariation(int index, ProductVariation Function(ProductVariation) update) {
    setState(() {
      _variations[index] = update(_variations[index]);
    });
    widget.onVariationsChanged(_variations);
  }

  void _updateCategoryPrice(String categoryId, double? price) {
    setState(() {
      final variation = _variations[_selectedVariationIndex];
      final updatedPrices = Map<String, double>.from(variation.categoryPrices);
      
      if (price == null) {
        updatedPrices.remove(categoryId);
      } else {
        updatedPrices[categoryId] = price;
      }
      
      _variations[_selectedVariationIndex] = variation.copyWith(
        categoryPrices: updatedPrices,
      );
    });
    widget.onVariationsChanged(_variations);
  }

  void _applyDefaultPriceToAll(double defaultPrice) {
    final business = ref.read(selectedBusinessProvider);
    final selectedLocationAsync = ref.read(selectedLocationNotifierProvider);
    
    selectedLocationAsync.whenData((selectedLocation) {
      if (business == null || selectedLocation == null) return;

      final priceCategoriesAsync = ref.read(
        priceCategoriesProvider((business.id, selectedLocation.id)),
      );

      priceCategoriesAsync.whenData((priceCategories) {
      setState(() {
        final variation = _variations[_selectedVariationIndex];
        final updatedPrices = <String, double>{};
        
        for (final category in priceCategories) {
          updatedPrices[category.id] = defaultPrice;
        }
        
        _variations[_selectedVariationIndex] = variation.copyWith(
          categoryPrices: updatedPrices,
        );
      });
      widget.onVariationsChanged(_variations);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default price applied to all categories'),
          duration: Duration(seconds: 2),
        ),
      );
      });
    });
  }
}