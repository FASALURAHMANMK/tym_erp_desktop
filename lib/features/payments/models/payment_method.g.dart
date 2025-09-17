// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodImpl _$$PaymentMethodImplFromJson(Map<String, dynamic> json) =>
    _$PaymentMethodImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      icon: json['icon'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      requiresReference: json['requiresReference'] as bool? ?? false,
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$PaymentMethodImplToJson(_$PaymentMethodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'code': instance.code,
      'icon': instance.icon,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'requiresReference': instance.requiresReference,
      'requiresApproval': instance.requiresApproval,
      'displayOrder': instance.displayOrder,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
