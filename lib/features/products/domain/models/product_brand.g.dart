// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductBrandImpl _$$ProductBrandImplFromJson(Map<String, dynamic> json) =>
    _$ProductBrandImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt:
          json['lastSyncedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncedAt'] as String),
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProductBrandImplToJson(_$ProductBrandImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'displayOrder': instance.displayOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
