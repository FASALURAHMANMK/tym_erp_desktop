import 'package:freezed_annotation/freezed_annotation.dart';
import '../../products/domain/models/product.dart';
import 'applied_item_discount.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id, // Unique ID for this cart item
    required String productId,
    required String productName,
    String? categoryId, // Add category ID for discount matching
    String? categoryName,
    required String variationId,
    required String variationName,
    String? productImage,
    String? productCode,
    String? sku,
    String? unitOfMeasure,
    required double quantity,
    required double unitPrice,
    required double originalPrice, // Original price before any modifications
    @Default(0.0) double discountAmount,
    @Default(0.0) double discountPercent,
    String? discountReason,
    String? appliedDiscountId,
    @Default([]) List<AppliedItemDiscount> appliedDiscounts, // Track all applied discounts
    @Default(false) bool manuallyRemovedDiscounts, // Track if user manually removed discounts
    @Default(0.0) double taxAmount,
    @Default(0.0) double taxPercent,
    @Default(0.0) double taxRate,
    String? taxGroupId,
    String? taxGroupName,
    String? notes,
    String? specialInstructions,
    @Default(false) bool skipKot,
    @Default({}) Map<String, dynamic> metadata, // For any additional data
    required DateTime addedAt,
    DateTime? updatedAt,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  const CartItem._();

  // Calculate line total
  double get lineSubtotal => quantity * unitPrice;
  
  // Alias for compatibility with order items
  double get subtotal => lineSubtotal;
  
  // Calculate discount amount based on percentage or fixed amount
  double get effectiveDiscountAmount {
    if (discountPercent > 0) {
      return lineSubtotal * (discountPercent / 100);
    }
    return discountAmount;
  }
  
  // Calculate tax on discounted amount
  double get effectiveTaxAmount {
    final discountedAmount = lineSubtotal - effectiveDiscountAmount;
    if (taxPercent > 0) {
      return discountedAmount * (taxPercent / 100);
    }
    return taxAmount;
  }
  
  // Final line total after discount and tax
  double get lineTotal {
    return lineSubtotal - effectiveDiscountAmount + effectiveTaxAmount;
  }
  
  // Check if item has discount
  bool get hasDiscount => discountAmount > 0 || discountPercent > 0;
  
  // Check if item has tax
  bool get hasTax => taxAmount > 0 || taxPercent > 0;
  
  // Create cart item from product and variation
  static CartItem fromProduct({
    required Product product,
    required ProductVariation variation,
    required double price,
    double quantity = 1,
    double? taxPercent,
  }) {
    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: product.id,
      productName: product.name,
      categoryId: product.categoryId, // Include category ID for discount matching
      variationId: variation.id,
      variationName: variation.name,
      productImage: product.imageUrl,
      quantity: quantity,
      unitPrice: price,
      originalPrice: price,
      taxPercent: taxPercent ?? 0,
      addedAt: DateTime.now(),
    );
  }
  
  // Create a copy with updated quantity
  CartItem updateQuantity(double newQuantity) {
    return copyWith(
      quantity: newQuantity,
      updatedAt: DateTime.now(),
    );
  }
  
  // Create a copy with discount
  CartItem applyDiscount({double? amount, double? percent}) {
    return copyWith(
      discountAmount: amount ?? discountAmount,
      discountPercent: percent ?? discountPercent,
      updatedAt: DateTime.now(),
    );
  }
  
  // Create a copy with updated price
  CartItem updatePrice(double newPrice) {
    return copyWith(
      unitPrice: newPrice,
      updatedAt: DateTime.now(),
    );
  }
}