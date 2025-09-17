// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_routing_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KotRoutingRuleImpl _$$KotRoutingRuleImplFromJson(Map<String, dynamic> json) =>
    _$KotRoutingRuleImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      printerId: json['printerId'] as String,
      instruction: json['instruction'] as String?,
      copies: (json['copies'] as num?)?.toInt() ?? 1,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      orderType: json['orderType'] as String?,
      timeRange: json['timeRange'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt:
          json['lastSyncedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncedAt'] as String),
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$KotRoutingRuleImplToJson(
  _$KotRoutingRuleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'printerId': instance.printerId,
  'instruction': instance.instruction,
  'copies': instance.copies,
  'priority': instance.priority,
  'isActive': instance.isActive,
  'orderType': instance.orderType,
  'timeRange': instance.timeRange,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};
