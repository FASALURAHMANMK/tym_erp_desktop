// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductStockImpl _$$ProductStockImplFromJson(Map<String, dynamic> json) =>
    _$ProductStockImpl(
      id: json['id'] as String,
      productVariationId: json['productVariationId'] as String,
      locationId: json['locationId'] as String,
      currentStock: (json['currentStock'] as num).toDouble(),
      reservedStock: (json['reservedStock'] as num?)?.toDouble() ?? 0.0,
      alertQuantity: (json['alertQuantity'] as num?)?.toDouble() ?? 10.0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      lastSyncedAt:
          json['lastSyncedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncedAt'] as String),
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProductStockImplToJson(_$ProductStockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productVariationId': instance.productVariationId,
      'locationId': instance.locationId,
      'currentStock': instance.currentStock,
      'reservedStock': instance.reservedStock,
      'alertQuantity': instance.alertQuantity,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
