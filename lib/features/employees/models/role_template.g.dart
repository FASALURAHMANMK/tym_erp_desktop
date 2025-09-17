// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleTemplateImpl _$$RoleTemplateImplFromJson(Map<String, dynamic> json) =>
    _$RoleTemplateImpl(
      id: json['id'] as String,
      roleCode: json['roleCode'] as String,
      roleName: json['roleName'] as String,
      permissions: json['permissions'] as Map<String, dynamic>,
      description: json['description'] as String?,
      isSystemRole: json['isSystemRole'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RoleTemplateImplToJson(_$RoleTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roleCode': instance.roleCode,
      'roleName': instance.roleName,
      'permissions': instance.permissions,
      'description': instance.description,
      'isSystemRole': instance.isSystemRole,
      'createdAt': instance.createdAt.toIso8601String(),
    };
