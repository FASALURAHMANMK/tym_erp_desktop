import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_discount.freezed.dart';
part 'order_discount.g.dart';

@freezed
class OrderDiscount with _$OrderDiscount {
  const factory OrderDiscount({
    required String id,
    required String orderId,
    
    // Discount Information (snapshot)
    required String discountId,
    required String discountName,
    required String discountCode,
    
    // Type
    required String discountType, // percentage, fixed, item_based, buy_x_get_y
    required String appliedTo, // order, items, category, specific_items
    
    // Values
    @Default(0) double discountPercent,
    @Default(0) double discountAmount,
    @Default(0) double maximumDiscount,
    
    // Applied Amount (actual discount given)
    required double appliedAmount,
    
    // Conditions (snapshot of what qualified this discount)
    @Default(0) double minimumPurchase,
    @Default(0) int minimumQuantity,
    @Default([]) List<String> applicableCategories,
    @Default([]) List<String> applicableProducts,
    
    // Application Details
    @Default('auto') String applicationMethod, // auto, manual, coupon
    String? couponCode,
    String? appliedBy, // User ID who applied manual discount
    String? appliedByName, // Snapshot
    
    // Reason (for manual discounts)
    String? reason,
    String? authorizedBy, // Manager who authorized
    
    // Metadata
    required DateTime appliedAt,
    Map<String, dynamic>? metadata,
  }) = _OrderDiscount;

  factory OrderDiscount.fromJson(Map<String, dynamic> json) => 
      _$OrderDiscountFromJson(json);
  
  const OrderDiscount._();
  
  // Check if discount is percentage based
  bool get isPercentage => discountType == 'percentage';
  
  // Check if discount is fixed amount
  bool get isFixed => discountType == 'fixed';
  
  // Check if discount was manually applied
  bool get isManual => applicationMethod == 'manual';
  
  // Check if discount was from coupon
  bool get isCoupon => applicationMethod == 'coupon';
  
  // Check if discount was auto-applied
  bool get isAutomatic => applicationMethod == 'auto';
  
  // Get display text
  String get displayText {
    if (isPercentage) {
      return '${discountPercent.toStringAsFixed(0)}% Off';
    } else {
      return '₹${discountAmount.toStringAsFixed(2)} Off';
    }
  }
  
  // Get full display text with name
  String get fullDisplayText {
    return '$discountName - $displayText';
  }
  
  // Get application method display
  String get applicationMethodDisplay {
    switch (applicationMethod) {
      case 'auto':
        return 'Automatic';
      case 'manual':
        return 'Manual';
      case 'coupon':
        return 'Coupon';
      default:
        return applicationMethod;
    }
  }
}