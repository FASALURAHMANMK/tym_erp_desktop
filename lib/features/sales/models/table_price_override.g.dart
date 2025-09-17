// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_price_override.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TablePriceOverrideImpl _$$TablePriceOverrideImplFromJson(
  Map<String, dynamic> json,
) => _$TablePriceOverrideImpl(
  id: json['id'] as String,
  tableId: json['tableId'] as String,
  variationId: json['variationId'] as String,
  price: (json['price'] as num).toDouble(),
  isActive: json['isActive'] as bool? ?? true,
  validFrom:
      json['validFrom'] == null
          ? null
          : DateTime.parse(json['validFrom'] as String),
  validUntil:
      json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  lastSyncedAt:
      json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
  hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
);

Map<String, dynamic> _$$TablePriceOverrideImplToJson(
  _$TablePriceOverrideImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'tableId': instance.tableId,
  'variationId': instance.variationId,
  'price': instance.price,
  'isActive': instance.isActive,
  'validFrom': instance.validFrom?.toIso8601String(),
  'validUntil': instance.validUntil?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};
