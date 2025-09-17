import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/kot_item_routing.dart';
import '../../providers/kot_providers.dart';
import '../../../business/providers/business_provider.dart';
import '../../../location/providers/location_provider.dart';
import '../../../products/providers/product_provider.dart';

class RoutingFormDialog extends ConsumerStatefulWidget {
  final KotItemRouting? routing;

  const RoutingFormDialog({super.key, this.routing});

  static Future<void> show(BuildContext context, {KotItemRouting? routing}) {
    return showDialog(
      context: context,
      builder: (context) => RoutingFormDialog(routing: routing),
    );
  }

  @override
  ConsumerState<RoutingFormDialog> createState() => _RoutingFormDialogState();
}

class _RoutingFormDialogState extends ConsumerState<RoutingFormDialog> {
  late String? _selectedStationId;
  late String? _selectedCategoryId;
  late String? _selectedProductId;
  late String? _selectedVariationId;
  late int _priority;
  late bool _isActive;
  String _routingType = 'category'; // category, product, variation
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStationId = widget.routing?.stationId;
    _selectedCategoryId = widget.routing?.categoryId;
    _selectedProductId = widget.routing?.productId;
    _selectedVariationId = widget.routing?.variationId;
    _priority = widget.routing?.priority ?? 1;
    _isActive = widget.routing?.isActive ?? true;
    
    // Determine routing type from existing routing
    if (widget.routing != null) {
      if (widget.routing!.variationId != null) {
        _routingType = 'variation';
      } else if (widget.routing!.productId != null) {
        _routingType = 'product';
      } else {
        _routingType = 'category';
      }
    }
  }

  Future<void> _saveRouting() async {
    if (_selectedStationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a station')),
      );
      return;
    }

    // Validate based on routing type
    if (_routingType == 'category' && _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    } else if (_routingType == 'product' && _selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product')),
      );
      return;
    } else if (_routingType == 'variation' && (_selectedProductId == null || _selectedVariationId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product and variation')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final business = ref.read(selectedBusinessProvider);
      final locationAsync = ref.read(selectedLocationNotifierProvider);
      
      if (business == null) {
        throw Exception('No business selected');
      }

      final location = locationAsync.valueOrNull;
      if (location == null) {
        throw Exception('No location selected');
      }

      final routing = KotItemRouting(
        id: widget.routing?.id ?? '',
        businessId: business.id,
        locationId: location.id,
        stationId: _selectedStationId!,
        categoryId: _routingType == 'category' ? _selectedCategoryId : null,
        productId: _routingType != 'category' ? _selectedProductId : null,
        variationId: _routingType == 'variation' ? _selectedVariationId : null,
        priority: _priority,
        isActive: _isActive,
        createdAt: widget.routing?.createdAt,
        updatedAt: DateTime.now(),
      );

      await ref.read(kotItemRoutingNotifierProvider.notifier).saveItemRouting(routing);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.routing == null 
                ? 'Routing rule created successfully' 
                : 'Routing rule updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving routing: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(kotStationsProvider);
    
    // Get selected business to fetch products and categories
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    if (selectedBusiness == null) {
      return const AlertDialog(
        title: Text('No Business Selected'),
        content: Text('Please select a business first'),
      );
    }
    
    final categoriesAsync = ref.watch(productCategoriesProvider(selectedBusiness.id));
    final productsAsync = ref.watch(productsNotifierProvider(selectedBusiness.id));

    return AlertDialog(
      title: Text(widget.routing == null ? 'Add Item Routing' : 'Edit Item Routing'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Routing Type Selection
              const Text('Route items by:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'category',
                    label: Text('Category'),
                    icon: Icon(Icons.category),
                  ),
                  ButtonSegment(
                    value: 'product',
                    label: Text('Product'),
                    icon: Icon(Icons.inventory),
                  ),
                  ButtonSegment(
                    value: 'variation',
                    label: Text('Variation'),
                    icon: Icon(Icons.layers),
                  ),
                ],
                selected: {_routingType},
                onSelectionChanged: (value) {
                  setState(() {
                    _routingType = value.first;
                    // Reset selections when changing type
                    _selectedCategoryId = null;
                    _selectedProductId = null;
                    _selectedVariationId = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Category Selection (if routing by category)
              if (_routingType == 'category') ...[
                categoriesAsync.when(
                  data: (categories) => DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Error loading categories'),
                ),
                const SizedBox(height: 16),
              ],

              // Product Selection (if routing by product or variation)
              if (_routingType == 'product' || _routingType == 'variation') ...[
                productsAsync.when(
                  data: (products) => DropdownButtonFormField<String>(
                    value: _selectedProductId,
                    decoration: const InputDecoration(
                      labelText: 'Select Product',
                      border: OutlineInputBorder(),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem(
                        value: product.id,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProductId = value;
                        _selectedVariationId = null; // Reset variation when product changes
                      });
                    },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Error loading products'),
                ),
                const SizedBox(height: 16),
              ],

              // Variation Selection (if routing by variation)
              if (_routingType == 'variation' && _selectedProductId != null) ...[
                productsAsync.when(
                  data: (products) {
                    final product = products.firstWhere(
                      (p) => p.id == _selectedProductId,
                      orElse: () => products.first,
                    );
                    return DropdownButtonFormField<String>(
                      value: _selectedVariationId,
                      decoration: const InputDecoration(
                        labelText: 'Select Variation',
                        border: OutlineInputBorder(),
                      ),
                      items: product.variations.map((variation) {
                        return DropdownMenuItem(
                          value: variation.id,
                          child: Text(variation.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedVariationId = value);
                      },
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Error loading variations'),
                ),
                const SizedBox(height: 16),
              ],

              // Station Selection
              stationsAsync.when(
                data: (stations) => DropdownButtonFormField<String>(
                  value: _selectedStationId,
                  decoration: const InputDecoration(
                    labelText: 'Route to Station',
                    border: OutlineInputBorder(),
                  ),
                  items: stations.map((station) {
                    return DropdownMenuItem(
                      value: station.id,
                      child: Row(
                        children: [
                          if (station.color != null)
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Color(int.parse(station.color!.replaceAll('#', '0xFF'))),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(station.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedStationId = value);
                  },
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error loading stations'),
              ),
              const SizedBox(height: 16),

              // Priority
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Priority', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Slider(
                    value: _priority.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _priority.toString(),
                    onChanged: (value) {
                      setState(() => _priority = value.toInt());
                    },
                  ),
                  Text(
                    'Priority: $_priority (Lower number = Higher priority)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Active switch
              SwitchListTile(
                title: const Text('Active'),
                subtitle: const Text('Enable this routing rule'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveRouting,
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.routing == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}