// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceCategoryImpl _$$PriceCategoryImplFromJson(Map<String, dynamic> json) =>
    _$PriceCategoryImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      locationId: json['locationId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$PriceCategoryTypeEnumMap, json['type']),
      description: json['description'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      isVisible: json['isVisible'] as bool? ?? true,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      iconName: json['iconName'] as String?,
      colorHex: json['colorHex'] as String?,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      lastSyncedAt:
          json['lastSyncedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncedAt'] as String),
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$PriceCategoryImplToJson(_$PriceCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'name': instance.name,
      'type': _$PriceCategoryTypeEnumMap[instance.type]!,
      'description': instance.description,
      'isDefault': instance.isDefault,
      'isActive': instance.isActive,
      'isVisible': instance.isVisible,
      'displayOrder': instance.displayOrder,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };

const _$PriceCategoryTypeEnumMap = {
  PriceCategoryType.dineIn: 'dine_in',
  PriceCategoryType.takeaway: 'takeaway',
  PriceCategoryType.delivery: 'delivery',
  PriceCategoryType.catering: 'catering',
  PriceCategoryType.custom: 'custom',
};
