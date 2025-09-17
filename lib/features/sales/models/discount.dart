import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount.freezed.dart';
part 'discount.g.dart';

enum DiscountType {
  @JsonValue('percentage')
  percentage,
  @JsonValue('fixed')
  fixed,
}

enum DiscountScope {
  @JsonValue('item')
  item, // Applied to specific items
  @JsonValue('cart')
  cart, // Applied to entire cart
  @JsonValue('category')
  category, // Applied to items in specific category
}

@freezed
class Discount with _$Discount {
  const factory Discount({
    required String id,
    required String name,
    required double value, // Percentage or fixed amount
    @Default(DiscountType.percentage) DiscountType type,
    @Default(DiscountScope.cart) DiscountScope scope,
    double? minimumAmount, // Minimum purchase amount to apply
    double? maximumDiscount, // Cap on discount amount
    String? categoryId, // For category-specific discounts
    String? productId, // For product-specific discounts
    String? couponCode, // Optional coupon code
    DateTime? validFrom,
    DateTime? validUntil,
    @Default(true) bool isActive,
    @Default(false) bool isAutoApply, // Automatically apply if conditions met
    String? description,
    @Default({}) Map<String, dynamic> conditions, // Additional conditions
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Discount;

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);

  const Discount._();

  // Check if discount is currently valid
  bool get isValid {
    if (!isActive) return false;
    
    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validUntil != null && now.isAfter(validUntil!)) return false;
    
    return true;
  }

  // Calculate discount amount based on base amount
  double calculateDiscount(double baseAmount) {
    if (!isValid) return 0;
    
    // Check minimum amount requirement
    if (minimumAmount != null && baseAmount < minimumAmount!) {
      return 0;
    }

    double discountAmount = 0;
    
    if (type == DiscountType.percentage) {
      discountAmount = baseAmount * (value / 100);
    } else {
      discountAmount = value;
    }

    // Apply maximum discount cap if set
    if (maximumDiscount != null && discountAmount > maximumDiscount!) {
      discountAmount = maximumDiscount!;
    }

    // Ensure discount doesn't exceed base amount
    if (discountAmount > baseAmount) {
      discountAmount = baseAmount;
    }

    return discountAmount;
  }

  // Check if discount is applicable to a specific item
  bool isApplicableToItem({
    String? itemCategoryId,
    String? itemProductId,
    double? itemPrice,
  }) {
    if (!isValid) return false;

    // Check scope
    switch (scope) {
      case DiscountScope.cart:
        return true; // Cart-level discounts apply to all items
      case DiscountScope.category:
        return categoryId != null && categoryId == itemCategoryId;
      case DiscountScope.item:
        return productId != null && productId == itemProductId;
    }
  }
}

// Coupon model for discount codes
@freezed
class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String code,
    required Discount discount,
    int? usageLimit, // Total usage limit
    int? usageCount, // Current usage count
    int? perCustomerLimit, // Usage limit per customer
    @Default(true) bool isActive,
    DateTime? expiresAt,
    @Default([]) List<String> applicableCategories,
    @Default([]) List<String> applicableProducts,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  const Coupon._();

  // Check if coupon is valid
  bool get isValid {
    if (!isActive) return false;
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) return false;
    if (usageLimit != null && usageCount != null && usageCount! >= usageLimit!) {
      return false;
    }
    return discount.isValid;
  }

  // Check if coupon can be used by a customer
  bool canBeUsedByCustomer(String customerId, int customerUsageCount) {
    if (!isValid) return false;
    if (perCustomerLimit != null && customerUsageCount >= perCustomerLimit!) {
      return false;
    }
    return true;
  }
}