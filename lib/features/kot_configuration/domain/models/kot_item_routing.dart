import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_item_routing.freezed.dart';
part 'kot_item_routing.g.dart';

@freezed
class KotItemRouting with _$KotItemRouting {
  const factory KotItemRouting({
    required String id,
    required String businessId,
    required String locationId,
    required String stationId,
    String? categoryId, // route all items in category
    String? productId, // route specific product
    String? variationId, // route specific variation
    required int priority, // routing priority (higher = more specific)
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _KotItemRouting;

  factory KotItemRouting.fromJson(Map<String, dynamic> json) =>
      _$KotItemRoutingFromJson(json);
}