import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_status.dart';
import 'item_modifier.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    // Identification
    required String id,
    required String orderId,
    
    // Product Information (snapshot at time of order)
    required String productId,
    required String variationId,
    required String productName,
    required String variationName,
    String? productCode,
    String? sku,
    String? unitOfMeasure,
    
    // Quantity & Pricing
    @Default(1) double quantity,
    required double unitPrice, // Original price
    @Default(0) double modifiersPrice, // Additional charges for modifiers
    
    // Modifiers/Customization
    @Default([]) List<ItemModifier> modifiers,
    String? specialInstructions,
    
    // Discounts
    @Default(0) double discountAmount,
    @Default(0) double discountPercent,
    String? discountReason,
    String? appliedDiscountId,
    
    // Tax (snapshot at time of order)
    @Default(0) double taxRate,
    @Default(0) double taxAmount,
    String? taxGroupId,
    String? taxGroupName,
    
    // Calculated Totals
    @Default(0) double subtotal, // (unitPrice + modifiersPrice) * quantity
    @Default(0) double total, // subtotal - discount + tax
    
    // Kitchen/Preparation
    @Default(false) bool skipKot,
    @Default(false) bool kotPrinted,
    DateTime? kotPrintedAt,
    String? kotNumber,
    @Default(PreparationStatus.pending) PreparationStatus preparationStatus,
    DateTime? preparedAt,
    String? preparedBy, // Kitchen staff ID
    String? station, // Kitchen station (e.g., "Main Kitchen", "Bar", "Dessert")
    
    // Service
    DateTime? servedAt,
    String? servedBy, // Waiter ID
    
    // Void/Cancel Information
    @Default(false) bool isVoided,
    DateTime? voidedAt,
    String? voidedBy,
    String? voidReason,
    @Default(false) bool isComplimentary,
    String? complimentaryReason,
    
    // Return/Refund
    @Default(false) bool isReturned,
    @Default(0) double returnedQuantity,
    DateTime? returnedAt,
    String? returnReason,
    @Default(0) double refundedAmount,
    
    // Display & Sorting
    @Default(0) int displayOrder,
    String? category, // For grouping in display
    String? categoryId,
    
    // Notes
    String? itemNotes,
    
    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => 
      _$OrderItemFromJson(json);
  
  // Helper methods
  const OrderItem._();
  
  // Calculate line subtotal
  double get lineSubtotal {
    return (unitPrice + modifiersPrice) * quantity;
  }
  
  // Calculate line total after discount
  double get lineAfterDiscount {
    return lineSubtotal - discountAmount;
  }
  
  // Calculate final line total
  double get lineTotal {
    return lineAfterDiscount + taxAmount;
  }
  
  // Check if item can be modified
  bool get canModify {
    return !kotPrinted && !isVoided && preparationStatus == PreparationStatus.pending;
  }
  
  // Check if item can be voided
  bool get canVoid {
    return !isVoided && !isReturned;
  }
  
  // Check if item is ready
  bool get isReady {
    return preparationStatus == PreparationStatus.ready || 
           preparationStatus == PreparationStatus.served;
  }
  
  // Check if item needs kitchen preparation
  bool get needsKitchen {
    return !skipKot && !isVoided;
  }
  
  // Get effective quantity (after returns)
  double get effectiveQuantity {
    return quantity - returnedQuantity;
  }
  
  // Get display name with variation
  String get displayName {
    if (variationName != 'Default' && variationName.isNotEmpty) {
      return '$productName ($variationName)';
    }
    return productName;
  }
  
  // Get modifiers display text
  String get modifiersText {
    if (modifiers.isEmpty) return '';
    return modifiers.map((m) => m.displayText).join(', ');
  }
  
  // Check if item has special requirements
  bool get hasSpecialRequirements {
    return specialInstructions != null && specialInstructions!.isNotEmpty ||
           modifiers.isNotEmpty;
  }
  
  // Get status color for UI
  String get statusColor {
    if (isVoided) return 'red';
    if (isComplimentary) return 'purple';
    if (isReturned) return 'orange';
    
    switch (preparationStatus) {
      case PreparationStatus.pending:
        return 'grey';
      case PreparationStatus.preparing:
        return 'blue';
      case PreparationStatus.ready:
        return 'green';
      case PreparationStatus.served:
        return 'teal';
    }
  }
  
  // Create from cart item (helper for conversion)
  static OrderItem fromCartItem({
    required String orderId,
    required dynamic cartItem, // Will be CartItem type
    required int displayOrder,
  }) {
    // This will be implemented when we do cart to order conversion
    throw UnimplementedError();
  }
}