import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_category.freezed.dart';
part 'price_category.g.dart';

enum PriceCategoryType {
  @JsonValue('dine_in')
  dineIn,
  @JsonValue('takeaway')
  takeaway,
  @JsonValue('delivery')
  delivery,
  @JsonValue('catering')
  catering,
  @JsonValue('custom')
  custom,
}

@freezed
class PriceCategory with _$PriceCategory {
  const factory PriceCategory({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    required PriceCategoryType type,
    String? description,
    @Default(false) bool isDefault,
    @Default(true) bool isActive,
    @Default(true) bool isVisible,
    @Default(0) int displayOrder,
    String? iconName,
    String? colorHex,
    @Default({}) Map<String, dynamic> settings,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _PriceCategory;

  factory PriceCategory.fromJson(Map<String, dynamic> json) =>
      _$PriceCategoryFromJson(json);

  const PriceCategory._();

  // Helper methods
  bool get isDineIn => type == PriceCategoryType.dineIn;
  bool get isTakeaway => type == PriceCategoryType.takeaway;
  bool get isDelivery => type == PriceCategoryType.delivery;
  bool get isCatering => type == PriceCategoryType.catering;
  bool get isCustom => type == PriceCategoryType.custom;

  // Check if this category can be deleted (Dine-In cannot be deleted)
  bool get canDelete => !isDefault || type != PriceCategoryType.dineIn;

  // Get display name with fallback
  String get displayName => name.isNotEmpty ? name : 'Unnamed Category';

  // Get icon name with fallback based on type
  String get effectiveIconName {
    if (iconName != null && iconName!.isNotEmpty) return iconName!;
    
    switch (type) {
      case PriceCategoryType.dineIn:
        return 'restaurant';
      case PriceCategoryType.takeaway:
        return 'takeout_dining';
      case PriceCategoryType.delivery:
        return 'delivery_dining';
      case PriceCategoryType.catering:
        return 'catering';
      case PriceCategoryType.custom:
        return 'category';
    }
  }

  // Get color with fallback based on type
  String get effectiveColorHex {
    if (colorHex != null && colorHex!.isNotEmpty) return colorHex!;
    
    switch (type) {
      case PriceCategoryType.dineIn:
        return '#4CAF50'; // Green
      case PriceCategoryType.takeaway:
        return '#FF9800'; // Orange
      case PriceCategoryType.delivery:
        return '#2196F3'; // Blue
      case PriceCategoryType.catering:
        return '#9C27B0'; // Purple
      case PriceCategoryType.custom:
        return '#607D8B'; // Blue Grey
    }
  }
}