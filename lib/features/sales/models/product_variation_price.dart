import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_variation_price.freezed.dart';
part 'product_variation_price.g.dart';

@freezed
class ProductVariationPrice with _$ProductVariationPrice {
  const factory ProductVariationPrice({
    required String id,
    required String variationId,
    required String priceCategoryId,
    required double price,
    double? cost,
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _ProductVariationPrice;

  factory ProductVariationPrice.fromJson(Map<String, dynamic> json) =>
      _$ProductVariationPriceFromJson(json);

  const ProductVariationPrice._();

  // Helper methods
  double get margin {
    if (cost == null || cost! <= 0) return 0;
    return ((price - cost!) / cost!) * 100;
  }

  double get profit => cost != null ? price - cost! : 0;

  bool get isProfitable => profit > 0;
}