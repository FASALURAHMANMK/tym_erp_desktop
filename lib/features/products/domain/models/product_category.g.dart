// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductCategoryImpl _$$ProductCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$ProductCategoryImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  name: json['name'] as String,
  nameInAlternateLanguage: json['nameInAlternateLanguage'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  iconName: json['iconName'] as String?,
  displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
  parentCategoryId: json['parentCategoryId'] as String?,
  defaultKotPrinterId: json['defaultKotPrinterId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastSyncedAt:
      json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
  hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
);

Map<String, dynamic> _$$ProductCategoryImplToJson(
  _$ProductCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'name': instance.name,
  'nameInAlternateLanguage': instance.nameInAlternateLanguage,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'iconName': instance.iconName,
  'displayOrder': instance.displayOrder,
  'isActive': instance.isActive,
  'parentCategoryId': instance.parentCategoryId,
  'defaultKotPrinterId': instance.defaultKotPrinterId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};
