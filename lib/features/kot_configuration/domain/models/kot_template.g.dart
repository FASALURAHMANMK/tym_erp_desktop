// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KotTemplateImpl _$$KotTemplateImplFromJson(Map<String, dynamic> json) =>
    _$KotTemplateImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      locationId: json['locationId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      isActive: json['isActive'] as bool,
      isDefault: json['isDefault'] as bool,
      description: json['description'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
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

Map<String, dynamic> _$$KotTemplateImplToJson(_$KotTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'name': instance.name,
      'type': instance.type,
      'content': instance.content,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'description': instance.description,
      'settings': instance.settings,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
