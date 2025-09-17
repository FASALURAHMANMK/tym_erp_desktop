// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerGroupImpl _$$CustomerGroupImplFromJson(Map<String, dynamic> json) =>
    _$CustomerGroupImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0,
      creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0,
      paymentTerms: (json['paymentTerms'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$CustomerGroupImplToJson(_$CustomerGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'color': instance.color,
      'discountPercent': instance.discountPercent,
      'creditLimit': instance.creditLimit,
      'paymentTerms': instance.paymentTerms,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
