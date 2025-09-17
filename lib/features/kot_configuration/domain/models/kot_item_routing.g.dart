// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_item_routing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KotItemRoutingImpl _$$KotItemRoutingImplFromJson(Map<String, dynamic> json) =>
    _$KotItemRoutingImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      locationId: json['locationId'] as String,
      stationId: json['stationId'] as String,
      categoryId: json['categoryId'] as String?,
      productId: json['productId'] as String?,
      variationId: json['variationId'] as String?,
      priority: (json['priority'] as num).toInt(),
      isActive: json['isActive'] as bool,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$KotItemRoutingImplToJson(
  _$KotItemRoutingImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'locationId': instance.locationId,
  'stationId': instance.stationId,
  'categoryId': instance.categoryId,
  'productId': instance.productId,
  'variationId': instance.variationId,
  'priority': instance.priority,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};
