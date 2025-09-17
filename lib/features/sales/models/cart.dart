import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';
import '../../charges/models/charge.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

enum CartStatus {
  @JsonValue('active')
  active,
  @JsonValue('on_hold')
  onHold,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id,
    required String businessId,
    required String locationId,
    required String posDeviceId,
    required String priceCategoryId,
    String? priceCategoryName,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? tableId,
    String? tableName,
    String? orderId, // Link to existing order for updates
    @Default([]) List<CartItem> items,
    @Default(0.0) double subtotal,
    @Default(0.0) double orderDiscountAmount, // Manual order-level discount
    @Default(0.0) double orderDiscountPercent, // Manual order-level discount percentage
    String? orderDiscountReason, // Reason for manual order discount
    @Default(false) bool manualDiscountApplied, // Track if discount was manually selected
    @Default([]) List<AppliedCharge> appliedCharges, // Applied charges
    @Default(0.0) double totalChargesAmount, // Total charges amount
    @Default(0.0) double taxAmount,
    @Default(0.0) double totalAmount,
    @Default(0.0) double roundOffAmount,
    @Default(CartStatus.active) CartStatus status,
    String? notes,
    String? referenceNumber,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? createdBy,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  const Cart._();

  // Calculate subtotal from items
  double get calculatedSubtotal {
    return items.fold(0.0, (sum, item) => sum + item.lineSubtotal);
  }

  // Calculate total discount from items
  double get totalItemDiscounts {
    return items.fold(
      0.0,
      (sum, item) => sum + item.effectiveDiscountAmount,
    );
  }
  
  // Calculate order-level discount
  double get effectiveOrderDiscount {
    // Order discount applies to subtotal after item discounts
    final subtotalAfterItemDiscounts = calculatedSubtotal - totalItemDiscounts;
    if (orderDiscountPercent > 0) {
      return subtotalAfterItemDiscounts * (orderDiscountPercent / 100);
    }
    return orderDiscountAmount;
  }
  
  // Total discount (items + order)
  double get totalDiscountAmount {
    return totalItemDiscounts + effectiveOrderDiscount;
  }
  
  // Alias for compatibility with order creation
  double get totalDiscounts => totalDiscountAmount;

  // Calculate total charges
  double get calculatedChargesAmount {
    return appliedCharges.fold(0.0, (sum, charge) => sum + charge.chargeAmount);
  }

  // Calculate taxable charges
  double get taxableChargesAmount {
    return appliedCharges
        .where((charge) => charge.isTaxable)
        .fold(0.0, (sum, charge) => sum + charge.chargeAmount);
  }

  // Calculate total tax from items and taxable charges
  double get totalTaxAmount {
    final itemsTax = items.fold(0.0, (sum, item) => sum + item.effectiveTaxAmount);
    // TODO: Calculate tax on taxable charges when tax rates are configured
    return itemsTax;
  }

  // Calculate final total
  double get calculatedTotal {
    return calculatedSubtotal -
        totalDiscountAmount +
        calculatedChargesAmount +
        totalTaxAmount +
        roundOffAmount;
  }

  // Get item count
  int get itemCount => items.length;

  // Get total quantity
  double get totalQuantity {
    return items.fold(0.0, (sum, item) => sum + item.quantity);
  }

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;

  // Check if cart has customer
  bool get hasCustomer => customerId != null && customerId!.isNotEmpty;

  // Check if cart has table (for restaurants)
  bool get hasTable => tableId != null && tableId!.isNotEmpty;

  // Check if cart has discount
  bool get hasDiscount =>
      orderDiscountAmount > 0 ||
      orderDiscountPercent > 0 ||
      items.any((item) => item.hasDiscount);

  // Check if cart has charges
  bool get hasCharges => appliedCharges.isNotEmpty;

  // Add item to cart
  Cart addItem(CartItem item) {
    // Check if item already exists (same product and variation)
    final existingIndex = items.indexWhere(
      (i) => i.productId == item.productId && i.variationId == item.variationId,
    );

    List<CartItem> updatedItems;
    if (existingIndex >= 0) {
      // Update quantity of existing item
      updatedItems = [...items];
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.updateQuantity(
        existingItem.quantity + item.quantity,
      );
    } else {
      // Add new item
      updatedItems = [...items, item];
    }

    return _updateTotals(
      copyWith(items: updatedItems, updatedAt: DateTime.now()),
    );
  }

  // Remove item from cart
  Cart removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    return _updateTotals(
      copyWith(items: updatedItems, updatedAt: DateTime.now()),
    );
  }

  // Update item quantity
  Cart updateItemQuantity(String itemId, double quantity) {
    if (quantity <= 0) {
      return removeItem(itemId);
    }

    final updatedItems =
        items.map((item) {
          if (item.id == itemId) {
            return item.updateQuantity(quantity);
          }
          return item;
        }).toList();

    return _updateTotals(
      copyWith(items: updatedItems, updatedAt: DateTime.now()),
    );
  }

  // Clear all items
  Cart clearItems() {
    return _updateTotals(copyWith(items: [], updatedAt: DateTime.now()));
  }

  // Apply order-level discount
  Cart applyOrderDiscount({double? amount, double? percent, String? reason}) {
    return _updateTotals(
      copyWith(
        orderDiscountAmount: amount ?? orderDiscountAmount,
        orderDiscountPercent: percent ?? orderDiscountPercent,
        orderDiscountReason: reason ?? orderDiscountReason,
        manualDiscountApplied: true,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Set customer
  Cart setCustomer({
    String? customerId,
    String? customerName,
    String? customerPhone,
  }) {
    return copyWith(
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      updatedAt: DateTime.now(),
    );
  }

  // Set table (for restaurants)
  Cart setTable({String? tableId, String? tableName}) {
    return copyWith(
      tableId: tableId,
      tableName: tableName,
      updatedAt: DateTime.now(),
    );
  }

  // Apply charges to cart
  Cart applyCharges(List<AppliedCharge> charges) {
    final totalCharges = charges.fold(0.0, (sum, charge) => sum + charge.chargeAmount);
    return _updateTotals(
      copyWith(
        appliedCharges: charges,
        totalChargesAmount: totalCharges,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Add a single charge
  Cart addCharge(AppliedCharge charge) {
    final updatedCharges = [...appliedCharges, charge];
    final totalCharges = updatedCharges.fold(0.0, (sum, c) => sum + c.chargeAmount);
    return _updateTotals(
      copyWith(
        appliedCharges: updatedCharges,
        totalChargesAmount: totalCharges,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Remove a charge
  Cart removeCharge(String chargeIdToRemove) {
    // For manual charges, chargeId is null, so we need to match by id
    final updatedCharges = appliedCharges.where((c) {
      // Check both chargeId and id to handle both regular and manual charges
      return c.chargeId != chargeIdToRemove && c.id != chargeIdToRemove;
    }).toList();
    final totalCharges = updatedCharges.fold(0.0, (sum, c) => sum + c.chargeAmount);
    return _updateTotals(
      copyWith(
        appliedCharges: updatedCharges,
        totalChargesAmount: totalCharges,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Update totals based on items and charges
  Cart _updateTotals(Cart cart) {
    final subtotal = cart.calculatedSubtotal;
    final charges = cart.calculatedChargesAmount;
    final tax = cart.totalTaxAmount;
    final total = cart.calculatedTotal;

    return cart.copyWith(
      subtotal: subtotal,
      totalChargesAmount: charges,
      taxAmount: tax,
      totalAmount: total,
    );
  }

  // Create empty cart
  static Cart empty({
    required String businessId,
    required String locationId,
    required String posDeviceId,
    required String priceCategoryId,
    String? priceCategoryName,
    String? createdBy,
  }) {
    return Cart(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      businessId: businessId,
      locationId: locationId,
      posDeviceId: posDeviceId,
      priceCategoryId: priceCategoryId,
      priceCategoryName: priceCategoryName,
      createdAt: DateTime.now(),
      createdBy: createdBy,
    );
  }
}
