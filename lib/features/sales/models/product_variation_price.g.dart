// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variation_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductVariationPriceImpl _$$ProductVariationPriceImplFromJson(
  Map<String, dynamic> json,
) => _$ProductVariationPriceImpl(
  id: json['id'] as String,
  variationId: json['variationId'] as String,
  priceCategoryId: json['priceCategoryId'] as String,
  price: (json['price'] as num).toDouble(),
  cost: (json['cost'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  lastSyncedAt:
      json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
  hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
);

Map<String, dynamic> _$$ProductVariationPriceImplToJson(
  _$ProductVariationPriceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'variationId': instance.variationId,
  'priceCategoryId': instance.priceCategoryId,
  'price': instance.price,
  'cost': instance.cost,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};
