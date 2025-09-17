import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/logger.dart';
import '../../../products/providers/product_provider.dart';
import '../../../business/providers/business_provider.dart';
import '../../services/kot_print_service.dart';
import '../../services/kot_routing_service.dart';
import '../../services/kot_formatter_service.dart';
import '../../../products/domain/models/product_category.dart';

// Mock order item model for testing
class MockOrderItem {
  final String id;
  final String productId;
  final String productName;
  final String? variationId;
  final String? variationName;
  final String categoryId;
  final String categoryName;
  final double quantity;
  final double unitPrice;
  final String? specialInstructions;

  MockOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.variationId,
    this.variationName,
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.unitPrice,
    this.specialInstructions,
  });
}

// Mock order model for testing
class MockOrder {
  final String id;
  final String orderNumber;
  final String? tableNumber;
  final String? customerName;
  final List<MockOrderItem> items;
  final DateTime orderedAt;
  final double total;

  MockOrder({
    required this.id,
    required this.orderNumber,
    this.tableNumber,
    this.customerName,
    required this.items,
    required this.orderedAt,
    required this.total,
  });
}

class KotTestScreen extends ConsumerStatefulWidget {
  const KotTestScreen({super.key});

  @override
  ConsumerState<KotTestScreen> createState() => _KotTestScreenState();
}

class _KotTestScreenState extends ConsumerState<KotTestScreen> {
  static final _logger = Logger('KotTestScreen');
  
  final List<MockOrderItem> _orderItems = [];
  final _tableController = TextEditingController();
  final _customerController = TextEditingController();
  final _instructionsController = TextEditingController();
  String? _selectedProductId;
  String? _selectedVariationId;
  double _quantity = 1;
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    // Trigger initial data load
    Future.microtask(() {
      final business = ref.read(selectedBusinessProvider);
      if (business != null) {
        // Pre-fetch products and categories
        ref.read(productsNotifierProvider(business.id));
        ref.read(productCategoriesProvider(business.id));
        _logger.info('Pre-fetching products and categories for business: ${business.id}');
      }
    });
  }

  @override
  void dispose() {
    _tableController.dispose();
    _customerController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product')),
      );
      return;
    }

    final business = ref.read(selectedBusinessProvider);
    if (business == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No business selected')),
      );
      return;
    }

    // Use watched values from build method instead of reading fresh
    final productsAsync = ref.read(productsNotifierProvider(business.id));
    final categoriesAsync = ref.read(productCategoriesProvider(business.id));

    // Handle products async data
    final products = productsAsync.valueOrNull;
    if (products == null || products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Products not loaded yet')),
      );
      return;
    }

    // Handle categories async data - with better error handling
    List<ProductCategory> categories;
    if (categoriesAsync.hasValue) {
      categories = categoriesAsync.value ?? [];
      _logger.debug('Categories loaded: ${categories.length} categories');
    } else if (categoriesAsync.hasError) {
      // If there's an error loading categories, use empty list as fallback
      _logger.warning('Categories loading error', categoriesAsync.error);
      categories = [];
    } else {
      // Still loading - this shouldn't happen if button is properly disabled
      _logger.info('Categories still loading when Add Item pressed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categories still loading...')),
      );
      return;
    }

    try {
      final product = products.firstWhere((p) => p.id == _selectedProductId);
      
      // Get the selected variation or use the first one
      final variation = _selectedVariationId != null
          ? product.variations.firstWhere(
              (v) => v.id == _selectedVariationId,
              orElse: () => product.variations.first,
            )
          : product.variations.first;

      // Get the category with fallback
      ProductCategory category;
      if (categories.isEmpty || product.categoryId == null) {
        // Use a default category if categories list is empty or product has no category
        category = ProductCategory(
          id: 'default',
          businessId: business.id,
          name: 'General',
          parentCategoryId: null,
          displayOrder: 0,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        // Try to find the category
        category = categories.firstWhere(
          (c) => c.id == product.categoryId,
          orElse: () => ProductCategory(
            id: 'default',
            businessId: business.id,
            name: 'General',
            parentCategoryId: null,
            displayOrder: 0,
            isActive: true,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }

      setState(() {
        _orderItems.add(MockOrderItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          productName: product.name,
          variationId: variation.id,
          variationName: variation.name,
          categoryId: category.id,
          categoryName: category.name,
          quantity: _quantity,
          unitPrice: variation.sellingPrice,
          specialInstructions: _instructionsController.text.isEmpty
              ? null
              : _instructionsController.text,
        ));

        // Reset form
        _selectedProductId = null;
        _selectedVariationId = null;
        _quantity = 1;
        _instructionsController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${product.name} to order'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeItem(String itemId) {
    setState(() {
      _orderItems.removeWhere((item) => item.id == itemId);
    });
  }

  Future<void> _printKOT() async {
    if (_orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add items to the order')),
      );
      return;
    }

    setState(() => _isPrinting = true);

    try {
      // Create mock order
      final order = MockOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        orderNumber: 'TEST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        tableNumber: _tableController.text.isEmpty ? null : _tableController.text,
        customerName: _customerController.text.isEmpty ? null : _customerController.text,
        items: _orderItems,
        orderedAt: DateTime.now(),
        total: _orderItems.fold(0, (sum, item) => sum + (item.quantity * item.unitPrice)),
      );

      // Get services
      final printService = ref.read(kotPrintServiceProvider);
      final routingService = ref.read(kotRoutingServiceProvider);
      final formatterService = ref.read(kotFormatterServiceProvider);

      // Route items to stations
      final routedItems = await routingService.routeOrderItems(order.items);

      // Print KOT for each station
      for (final stationEntry in routedItems.entries) {
        final station = stationEntry.key;
        final items = stationEntry.value;

        // Format KOT
        final kotContent = await formatterService.formatKOT(
          order: order,
          station: station,
          items: items,
        );

        // Print to physical printer
        await printService.printKOT(
          station: station,
          content: kotContent,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('KOT printed successfully to ${routedItems.length} station(s)'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear order after successful print
        setState(() {
          _orderItems.clear();
          _tableController.clear();
          _customerController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error printing KOT: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final business = ref.watch(selectedBusinessProvider);
    if (business == null) {
      return const Center(child: Text('No business selected'));
    }

    final productsAsync = ref.watch(productsNotifierProvider(business.id));
    final categoriesAsync = ref.watch(productCategoriesProvider(business.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('KOT Test & Print'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // TODO: Add styling settings later
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     // Navigate to KOT styling configuration
          //     context.push('/kot-configuration/styling');
          //   },
          //   tooltip: 'KOT Styling Settings',
          // ),
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: _orderItems.isEmpty ? null : () {
              // Show print preview
              _showPrintPreview();
            },
            tooltip: 'Print Preview',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left side - Order Form
          Expanded(
            flex: 2,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Test Order',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    
                    // Order Details
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tableController,
                            decoration: const InputDecoration(
                              labelText: 'Table Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.table_restaurant),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _customerController,
                            decoration: const InputDecoration(
                              labelText: 'Customer Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Divider(),
                    const SizedBox(height: 16),

                    // Add Item Form
                    Text(
                      'Add Items',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    productsAsync.when(
                      data: (products) {
                        // Check if categories are loaded for button state
                        final categoriesReady = categoriesAsync.hasValue || categoriesAsync.hasError;
                        
                        return Column(
                          children: [
                            // Product Selection
                            DropdownButtonFormField<String>(
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
                                  _selectedVariationId = null;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Variation Selection
                            if (_selectedProductId != null && products.isNotEmpty) ...[
                              Builder(
                                builder: (context) {
                                  try {
                                    final selectedProduct = products.firstWhere(
                                      (p) => p.id == _selectedProductId,
                                    );
                                    
                                    return Column(
                                      children: [
                                        DropdownButtonFormField<String>(
                                          key: ValueKey(_selectedProductId), // Force rebuild when product changes
                                          value: _selectedVariationId,
                                          decoration: const InputDecoration(
                                            labelText: 'Select Variation',
                                            border: OutlineInputBorder(),
                                          ),
                                          items: selectedProduct.variations.map((variation) {
                                            return DropdownMenuItem(
                                              value: variation.id,
                                              child: Text('${variation.name} - \$${variation.sellingPrice.toStringAsFixed(2)}'),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() => _selectedVariationId = value);
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    );
                                  } catch (e) {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ],

                            // Quantity
                            Row(
                              children: [
                                const Text('Quantity:'),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _quantity.toString(),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => setState(() => _quantity++),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Special Instructions
                            TextField(
                              controller: _instructionsController,
                              decoration: const InputDecoration(
                                labelText: 'Special Instructions (Optional)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.note),
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),

                            // Add Item Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: Text(!categoriesReady 
                                    ? 'Loading Categories...' 
                                    : 'Add Item to Order'),
                                onPressed: !categoriesReady || _selectedProductId == null
                                    ? null 
                                    : _addItem,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading products...'),
                          ],
                        ),
                      ),
                      error: (error, stack) => Text('Error loading products: $error'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right side - Order Summary
          Expanded(
            flex: 3,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Items',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Chip(
                          label: Text('${_orderItems.length} items'),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Items List
                  Expanded(
                    child: _orderItems.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No items in order', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _orderItems.length,
                            itemBuilder: (context, index) {
                              final item = _orderItems[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(item.quantity.toStringAsFixed(0)),
                                  ),
                                  title: Text(item.productName),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (item.variationName != null)
                                        Text('Variation: ${item.variationName}'),
                                      Text('Category: ${item.categoryName}'),
                                      if (item.specialInstructions != null)
                                        Text(
                                          'Note: ${item.specialInstructions}',
                                          style: const TextStyle(fontStyle: FontStyle.italic),
                                        ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '\$${(item.quantity * item.unitPrice).toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeItem(item.id),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            },
                          ),
                  ),

                  // Footer with Total and Print Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              '\$${_orderItems.fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice)).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            icon: _isPrinting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.print, size: 28),
                            label: Text(
                              _isPrinting ? 'Printing KOT...' : 'Print KOT',
                              style: const TextStyle(fontSize: 18),
                            ),
                            onPressed: _isPrinting || _orderItems.isEmpty ? null : _printKOT,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrintPreview() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 400,
          height: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KOT Preview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SingleChildScrollView(
                    child: Text(
                      '=========================\n'
                      '     RESTAURANT NAME\n'
                      '      KITCHEN KOT\n'
                      '=========================\n'
                      'Order: TEST-001\n'
                      'Table: 5\n'
                      'Time: 14:30\n'
                      '-------------------------\n'
                      '\n'
                      '2 x Chicken Burger\n'
                      '  No onions\n'
                      '\n'
                      '1 x French Fries\n'
                      '\n'
                      '3 x Coca Cola\n'
                      '\n'
                      '-------------------------\n'
                      'Token: 42\n'
                      '=========================',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}