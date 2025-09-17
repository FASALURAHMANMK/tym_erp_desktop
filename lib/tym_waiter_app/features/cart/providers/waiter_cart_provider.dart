import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/sales/models/cart.dart';
import '../../../../features/sales/models/cart_item.dart';
import '../../../../features/sales/models/table.dart';
import '../../auth/providers/waiter_auth_provider.dart';

part 'waiter_cart_provider.g.dart';

/// Selected table for the waiter
final waiterSelectedTableProvider = StateProvider<RestaurantTable?>((ref) => null);

/// Waiter-specific cart provider
/// Maintains cart state per table session
@Riverpod(keepAlive: true)
class WaiterCartNotifier extends _$WaiterCartNotifier {
  static final _logger = Logger('WaiterCartNotifier');
  static const _uuid = Uuid();

  @override
  Cart? build() {
    // Watch for table changes to clear cart when switching tables
    final selectedTable = ref.watch(waiterSelectedTableProvider);
    
    if (selectedTable == null) {
      return null;
    }
    
    // Initialize cart for the selected table
    return _initializeCartForTable(selectedTable);
  }
  
  /// Initialize a new cart for the selected table
  Cart _initializeCartForTable(RestaurantTable table) {
    final waiter = ref.read(currentWaiterProvider);
    
    if (waiter == null) {
      throw Exception('No waiter logged in');
    }
    
    _logger.info('Initializing cart for table ${table.displayText}');
    
    return Cart.empty(
      businessId: waiter.businessId,
      locationId: table.locationId,
      posDeviceId: '', // Will be set from waiter's assigned POS device
      priceCategoryId: '', // Will be set based on price category selection
      createdBy: waiter.id,
    ).setTable(
      tableId: table.id,
      tableName: table.displayText,
    );
  }
  
  /// Add item to cart
  void addItem({
    required String productId,
    required String variationId,
    required String productName,
    required String variationName,
    required String productCode,
    required String sku,
    required String unitOfMeasure,
    required String categoryId,
    required String categoryName,
    required double quantity,
    required double unitPrice,
    required double taxRate,
    String? specialInstructions,
  }) {
    if (state == null) {
      _logger.warning('Cannot add item - no cart initialized');
      return;
    }
    
    final cartItem = CartItem(
      id: _uuid.v4(),
      productId: productId,
      variationId: variationId,
      productName: productName,
      variationName: variationName,
      productCode: productCode,
      sku: sku,
      unitOfMeasure: unitOfMeasure,
      categoryId: categoryId,
      categoryName: categoryName,
      quantity: quantity,
      unitPrice: unitPrice,
      originalPrice: unitPrice,
      discountAmount: 0,
      taxRate: taxRate,
      specialInstructions: specialInstructions,
      addedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    state = state!.addItem(cartItem);
    _logger.info('Added item to cart: $productName - $variationName');
  }
  
  /// Update item quantity
  void updateItemQuantity(String itemId, double quantity) {
    if (state == null) return;
    
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    
    state = state!.updateItemQuantity(itemId, quantity);
    _logger.info('Updated item quantity: $itemId to $quantity');
  }
  
  /// Remove item from cart
  void removeItem(String itemId) {
    if (state == null) return;
    
    state = state!.removeItem(itemId);
    _logger.info('Removed item from cart: $itemId');
  }
  
  /// Clear the entire cart
  void clearCart() {
    final selectedTable = ref.read(waiterSelectedTableProvider);
    if (selectedTable != null) {
      state = _initializeCartForTable(selectedTable);
      _logger.info('Cart cleared for table ${selectedTable.displayText}');
    } else {
      state = null;
      _logger.info('Cart cleared completely');
    }
  }
  
  /// Set customer information
  void setCustomer({
    String? customerId,
    String? customerName,
    String? customerPhone,
  }) {
    if (state == null) return;
    
    state = state!.setCustomer(
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
    );
    _logger.info('Customer set: $customerName');
  }
  
  /// Set order ID (when loading existing order)
  void setOrderId(String? orderId) {
    if (state == null) return;
    
    state = state!.copyWith(orderId: orderId);
    _logger.info('Order ID set: ${orderId ?? "cleared"}');
  }
  
  /// Load cart from existing order
  void loadFromOrder({
    required String orderId,
    required List<CartItem> items,
    String? customerId,
    String? customerName,
    String? customerPhone,
  }) {
    if (state == null) {
      _logger.warning('Cannot load order - no cart initialized');
      return;
    }
    
    state = state!.copyWith(
      orderId: orderId,
      items: items,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      updatedAt: DateTime.now(),
    );
    
    _logger.info('Loaded ${items.length} items from order $orderId');
  }
  
  /// Update special instructions for an item
  void updateSpecialInstructions(String itemId, String? instructions) {
    if (state == null) return;
    
    final updatedItems = state!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(
          specialInstructions: instructions,
          updatedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();
    
    state = state!.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );
    
    _logger.info('Updated special instructions for item: $itemId');
  }
  
  /// Check if cart has items
  bool get hasItems => state?.items.isNotEmpty ?? false;
  
  /// Get cart item count
  int get itemCount => state?.items.length ?? 0;
  
  /// Get cart total
  double get total => state?.calculatedTotal ?? 0;
}

/// Price category provider for waiter (dine-in by default)
@riverpod
String waiterPriceCategoryId(Ref ref) {
  // For waiter app, we typically use dine-in price category
  // This can be enhanced to support multiple categories later
  return 'dine_in'; // Default price category ID
}