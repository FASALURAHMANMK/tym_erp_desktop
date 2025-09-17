import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/applied_item_discount.dart';
import '../models/discount.dart';
import '../../charges/models/charge.dart';
import '../../charges/providers/charge_provider.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../location/models/business_location.dart';
import '../../location/models/pos_device.dart';
import '../../products/domain/models/product.dart';
import '../../../core/utils/logger.dart';

part 'cart_provider.g.dart';

/// Helper provider for selected location
@riverpod
BusinessLocation? selectedLocation(Ref ref) {
  return ref.watch(selectedLocationNotifierProvider).valueOrNull;
}

/// Helper provider for selected POS device
@riverpod
POSDevice? selectedPOSDevice(Ref ref) {
  return ref.watch(selectedPOSDeviceNotifierProvider).valueOrNull;
}

/// Provider for the current active cart
/// Using keepAlive to preserve cart state across navigation
@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  static final _logger = Logger('CartNotifier');

  @override
  Cart? build() {
    // Initialize with empty cart when business/location changes
    final business = ref.watch(selectedBusinessProvider);
    final location = ref.watch(selectedLocationProvider);
    final posDevice = ref.watch(selectedPOSDeviceProvider);
    
    if (business == null || location == null || posDevice == null) {
      return null;
    }
    
    // Don't persist cart across sessions (as per requirement)
    // Create new empty cart
    return _createEmptyCart();
  }
  
  /// Create a new empty cart
  Cart _createEmptyCart() {
    final business = ref.read(selectedBusinessProvider);
    final location = ref.read(selectedLocationProvider);
    final posDevice = ref.read(selectedPOSDeviceProvider);
    
    if (business == null || location == null || posDevice == null) {
      throw Exception('Business, location, and POS device must be selected');
    }
    
    // Get default price category (will be set when tab is selected)
    return Cart.empty(
      businessId: business.id,
      locationId: location.id,
      posDeviceId: posDevice.id,
      priceCategoryId: '', // Will be set when price category is selected
      createdBy: 'user', // TODO: Get from auth provider
    );
  }
  
  /// Add item to cart
  void addItem(CartItem item) {
    if (state == null) {
      state = _createEmptyCart();
    }
    
    state = state!.addItem(item);
    _logger.info('Added item to cart: ${item.productName}');
  }
  
  /// Remove item from cart
  void removeItem(String itemId) {
    if (state == null) return;
    
    state = state!.removeItem(itemId);
    _logger.info('Removed item from cart: $itemId');
  }
  
  /// Update item quantity
  void updateItemQuantity(String itemId, double quantity) {
    if (state == null) return;
    
    state = state!.updateItemQuantity(itemId, quantity);
    _logger.info('Updated item quantity: $itemId to $quantity');
  }
  
  /// Clear cart completely (new empty cart)
  void clearCart() {
    // Create new empty cart with same business context
    final business = ref.read(selectedBusinessProvider);
    final location = ref.read(selectedLocationProvider);
    final posDevice = ref.read(selectedPOSDeviceProvider);
    
    if (business == null || location == null || posDevice == null) {
      state = null;
      return;
    }
    
    state = Cart.empty(
      businessId: business.id,
      locationId: location.id,
      posDeviceId: posDevice.id,
      priceCategoryId: '', // Will be set when price category is selected
      createdBy: 'user', // TODO: Get from auth provider
    );
    _logger.info('Cart cleared');
  }
  
  /// Clear only items while preserving context (table, customer, order ID)
  void clearItems() {
    if (state == null) {
      _logger.warning('clearItems called but cart state is null');
      return;
    }
    
    state = state!.copyWith(
      items: [],
      updatedAt: DateTime.now(),
    );
    _logger.info('Cart items cleared, context preserved - orderId: ${state!.orderId}, table: ${state!.tableName}');
  }
  
  /// Set price category
  void setPriceCategory(String priceCategoryId, String priceCategoryName) {
    if (state == null) {
      state = _createEmptyCart();
    }
    
    state = state!.copyWith(
      priceCategoryId: priceCategoryId,
      priceCategoryName: priceCategoryName,
      updatedAt: DateTime.now(),
    );
    _logger.info('Price category set: $priceCategoryName');
  }
  
  /// Set customer and apply customer discount if applicable
  void setCustomer({
    String? customerId, 
    String? customerName, 
    String? customerPhone,
    double customerDiscountPercent = 0,
  }) {
    if (state == null) return;
    
    // Store current items to preserve them
    final currentItems = state!.items;
    final currentOrderId = state!.orderId;
    
    state = state!.setCustomer(
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
    );
    
    // Ensure items and order ID are preserved
    if (currentItems.isNotEmpty || currentOrderId != null) {
      state = state!.copyWith(
        items: currentItems,
        orderId: currentOrderId,
      );
    }
    
    // Apply customer discount if available and no manual discount already applied
    if (customerDiscountPercent > 0 && !state!.manualDiscountApplied) {
      applyOrderDiscount(
        percent: customerDiscountPercent,
        reason: 'Customer Discount - $customerName',
      );
    }
    
    _logger.info('Customer set: $customerName (discount: $customerDiscountPercent%) - preserved ${currentItems.length} items');
  }
  
  /// Set table (for restaurants)
  void setTable({String? tableId, String? tableName}) {
    if (state == null) return;
    
    state = state!.setTable(
      tableId: tableId,
      tableName: tableName,
    );
    _logger.info('Table set: $tableName');
  }
  
  /// Set order ID (when loading existing order)
  void setOrderId(String orderId) {
    if (state == null) return;
    
    // Handle empty string as null to clear order ID
    final orderIdToSet = orderId.isEmpty ? null : orderId;
    state = state!.copyWith(orderId: orderIdToSet);
    _logger.info('Order ID set: ${orderIdToSet ?? "cleared"}');
  }
  
  /// Add item from existing order
  void addItemFromOrder({
    String? orderItemId,  // Original order item ID if loading from existing order
    required String productId,
    required String variationId,
    required String productName,
    required String variationName,
    required int quantity,
    required double unitPrice,
    double taxRate = 0,
    double discountAmount = 0,
    String? specialInstructions,
  }) {
    if (state == null) {
      // Initialize cart if needed
      final business = ref.read(selectedBusinessProvider);
      final location = ref.read(selectedLocationProvider);
      final posDevice = ref.read(selectedPOSDeviceProvider);
      
      if (business == null || location == null || posDevice == null) {
        _logger.error('Cannot add item from order without business context');
        return;
      }
      
      state = Cart.empty(
        businessId: business.id,
        locationId: location.id,
        posDeviceId: posDevice.id,
        priceCategoryId: '', // Will be set when price category is selected
        createdBy: 'user', // TODO: Get from auth provider
      );
    }
    
    // Create cart item from order item
    final cartItem = CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: productId,
      variationId: variationId,
      productName: productName,
      variationName: variationName,
      productCode: '',
      sku: '',
      unitOfMeasure: '',
      categoryId: '',
      categoryName: '',
      quantity: quantity.toDouble(),
      unitPrice: unitPrice,
      originalPrice: unitPrice,
      discountAmount: discountAmount,
      taxRate: taxRate,
      specialInstructions: specialInstructions,
      metadata: orderItemId != null ? {'orderItemId': orderItemId} : {},  // Store original order item ID
      addedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    state = state!.addItem(cartItem);
    _logger.info('Added item from order: $productName - $variationName');
    _logger.info('Cart now has ${state!.items.length} items');
  }
  
  /// Apply order-level discount (manual)
  void applyOrderDiscount({
    double? amount, 
    double? percent, 
    String? reason,
  }) {
    if (state == null) return;
    
    state = state!.applyOrderDiscount(
      amount: amount,
      percent: percent,
      reason: reason,
    );
    _logger.info('Order discount applied: amount=$amount, percent=$percent, reason=$reason');
  }
  
  /// Clear order-level discount
  void clearOrderDiscount() {
    if (state == null) return;
    
    state = state!.copyWith(
      orderDiscountAmount: 0,
      orderDiscountPercent: 0,
      orderDiscountReason: null,
      manualDiscountApplied: false,
      updatedAt: DateTime.now(),
    );
    _logger.info('Order discount cleared');
  }
  
  /// Check if an item has a specific discount applied
  bool isItemDiscountApplied(String itemId, String discountId) {
    if (state == null) return false;
    final item = state!.items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => CartItem(
        id: '',
        productId: '',
        productName: '',
        variationId: '',
        variationName: '',
        quantity: 0,
        unitPrice: 0,
        originalPrice: 0,
        addedAt: DateTime.now(),
      ),
    );
    return item.appliedDiscounts.any((d) => d.discountId == discountId);
  }
  
  /// Apply item-level discount
  void applyItemDiscount(String itemId, {
    required String discountId,
    required String discountName,
    required DiscountType type,
    required double value,
    required bool isAutoApplied,
  }) {
    if (state == null) return;
    
    final updatedItems = state!.items.map((item) {
      if (item.id == itemId) {
        // Calculate discount amount for this item
        final discountAmount = type == DiscountType.percentage
            ? item.lineSubtotal * (value / 100)
            : value;
        
        // Create applied discount record
        final appliedDiscount = AppliedItemDiscount(
          discountId: discountId,
          discountName: discountName,
          type: type,
          value: value,
          calculatedAmount: discountAmount,
          isAutoApplied: isAutoApplied,
          appliedAt: DateTime.now(),
        );
        
        // Add to applied discounts (replace if same discount ID exists)
        final appliedDiscounts = [...item.appliedDiscounts];
        appliedDiscounts.removeWhere((d) => d.discountId == discountId);
        appliedDiscounts.add(appliedDiscount);
        
        // Calculate total discount for the item
        final totalDiscountAmount = appliedDiscounts.fold<double>(
          0,
          (sum, d) => sum + d.calculatedAmount,
        );
        
        return item.copyWith(
          appliedDiscounts: appliedDiscounts,
          discountAmount: totalDiscountAmount,
          manuallyRemovedDiscounts: false, // Reset flag when applying discount
          updatedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();
    
    state = state!.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );
    
    _logger.info('Item discount applied: item=$itemId, discount=$discountName');
  }
  
  /// Remove item-level discount
  void removeItemDiscount(String itemId, String discountId) {
    if (state == null) return;
    
    final updatedItems = state!.items.map((item) {
      if (item.id == itemId) {
        // Remove the discount
        final appliedDiscounts = [...item.appliedDiscounts];
        appliedDiscounts.removeWhere((d) => d.discountId == discountId);
        
        // Recalculate total discount
        final totalDiscountAmount = appliedDiscounts.fold<double>(
          0,
          (sum, d) => sum + d.calculatedAmount,
        );
        
        return item.copyWith(
          appliedDiscounts: appliedDiscounts,
          discountAmount: totalDiscountAmount,
          manuallyRemovedDiscounts: true, // Mark that user manually removed discounts
          updatedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();
    
    state = state!.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );
    
    _logger.info('Item discount removed: item=$itemId, discount=$discountId');
  }
  
  /// Apply charges to cart
  Future<void> applyCharges() async {
    if (state == null) return;
    
    final applicableCharges = await ref.read(applicableChargesProvider.future);
    final appliedCharges = <AppliedCharge>[];
    final uuid = const Uuid();
    
    for (final charge in applicableCharges) {
      // Skip if charge is already applied (unless it's auto-apply)
      if (!charge.autoApply && 
          state!.appliedCharges.any((c) => c.chargeId == charge.id)) {
        continue;
      }
      
      final chargeAmount = charge.calculateCharge(
        state!.calculatedSubtotal - state!.totalDiscountAmount,
      );
      
      if (chargeAmount > 0) {
        appliedCharges.add(
          AppliedCharge(
            id: uuid.v4(),
            orderId: '', // Will be set when order is created
            chargeId: charge.id,
            chargeCode: charge.code,
            chargeName: charge.name,
            chargeType: charge.chargeType.name,
            calculationType: charge.calculationType.name,
            baseAmount: state!.calculatedSubtotal - state!.totalDiscountAmount,
            chargeRate: charge.value,
            chargeAmount: chargeAmount,
            isTaxable: charge.isTaxable,
            isManual: false,
            createdAt: DateTime.now(),
          ),
        );
      }
    }
    
    state = state!.applyCharges(appliedCharges);
    _logger.info('Applied ${appliedCharges.length} charges to cart');
  }
  
  /// Add manual charge to cart
  void addManualCharge(Charge charge) {
    if (state == null) return;
    
    final uuid = const Uuid();
    final chargeAmount = charge.calculateCharge(
      state!.calculatedSubtotal - state!.totalDiscountAmount,
    );
    
    if (chargeAmount > 0) {
      final appliedCharge = AppliedCharge(
        id: uuid.v4(),
        orderId: '',
        chargeId: null,  // Set to null for manual charges since they don't exist in charges table
        chargeCode: charge.code,
        chargeName: charge.name,
        chargeType: charge.chargeType.name,
        calculationType: charge.calculationType.name,
        baseAmount: state!.calculatedSubtotal - state!.totalDiscountAmount,
        chargeRate: charge.value,
        chargeAmount: chargeAmount,
        isTaxable: charge.isTaxable,
        isManual: true,
        createdAt: DateTime.now(),
      );
      
      state = state!.addCharge(appliedCharge);
      _logger.info('Added manual charge: ${charge.name}');
    }
  }
  
  /// Remove charge from cart
  void removeCharge(String chargeId) {
    if (state == null) return;
    
    state = state!.removeCharge(chargeId);
    _logger.info('Removed charge: $chargeId');
  }
  
  /// Clear all charges
  void clearAllCharges() {
    if (state == null) return;
    
    state = state!.applyCharges([]);
    _logger.info('Cleared all charges');
  }
  
  /// Clear all item discounts
  void clearAllItemDiscounts() {
    if (state == null) return;
    
    final updatedItems = state!.items.map((item) {
      return item.copyWith(
        appliedDiscounts: [],
        discountAmount: 0,
        discountPercent: 0,
        updatedAt: DateTime.now(),
      );
    }).toList();
    
    state = state!.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );
    
    _logger.info('All item discounts cleared');
  }
  
  
  /// Add product to cart (helper method)
  void addProduct({
    required Product product,
    required ProductVariation variation,
    required double price,
    double quantity = 1,
    double? taxPercent,
  }) {
    final item = CartItem.fromProduct(
      product: product,
      variation: variation,
      price: price,
      quantity: quantity,
      taxPercent: taxPercent,
    );
    
    addItem(item);
  }
  
  /// Check if product variation is in cart
  bool isInCart(String productId, String variationId) {
    if (state == null) return false;
    
    return state!.items.any((item) => 
      item.productId == productId && item.variationId == variationId
    );
  }
  
  /// Get quantity of product variation in cart
  double getQuantityInCart(String productId, String variationId) {
    if (state == null) return 0;
    
    final item = state!.items.firstWhere(
      (item) => item.productId == productId && item.variationId == variationId,
      orElse: () => CartItem(
        id: '',
        productId: '',
        productName: '',
        variationId: '',
        variationName: '',
        quantity: 0,
        unitPrice: 0,
        originalPrice: 0,
        addedAt: DateTime.now(),
      ),
    );
    
    return item.quantity;
  }
  
  /// Hold cart (park)
  void holdCart() {
    if (state == null || state!.isEmpty) return;
    
    state = state!.copyWith(
      status: CartStatus.onHold,
      updatedAt: DateTime.now(),
    );
    
    // TODO: Save to held_orders table
    
    // Create new cart
    state = _createEmptyCart();
    _logger.info('Cart held');
  }
  
  /// Recall held cart
  void recallCart(Cart heldCart) {
    state = heldCart.copyWith(
      status: CartStatus.active,
      updatedAt: DateTime.now(),
    );
    _logger.info('Cart recalled: ${heldCart.id}');
  }
}

/// Provider for cart item count
@riverpod
int cartItemCount(Ref ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart?.itemCount ?? 0;
}

/// Provider for cart total
@riverpod
double cartTotal(Ref ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart?.calculatedTotal ?? 0.0;
}

/// Provider for cart quantity
@riverpod
double cartTotalQuantity(Ref ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart?.totalQuantity ?? 0.0;
}