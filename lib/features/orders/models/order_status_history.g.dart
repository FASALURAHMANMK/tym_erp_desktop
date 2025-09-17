// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderStatusHistoryImpl _$$OrderStatusHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$OrderStatusHistoryImpl(
  id: json['id'] as String,
  orderId: json['orderId'] as String,
  fromStatus: $enumDecode(_$OrderStatusEnumMap, json['fromStatus']),
  toStatus: $enumDecode(_$OrderStatusEnumMap, json['toStatus']),
  changedBy: json['changedBy'] as String,
  changedByName: json['changedByName'] as String,
  changedByRole: json['changedByRole'] as String?,
  changedAt: DateTime.parse(json['changedAt'] as String),
  reason: json['reason'] as String?,
  notes: json['notes'] as String?,
  deviceId: json['deviceId'] as String?,
  ipAddress: json['ipAddress'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$OrderStatusHistoryImplToJson(
  _$OrderStatusHistoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'fromStatus': _$OrderStatusEnumMap[instance.fromStatus]!,
  'toStatus': _$OrderStatusEnumMap[instance.toStatus]!,
  'changedBy': instance.changedBy,
  'changedByName': instance.changedByName,
  'changedByRole': instance.changedByRole,
  'changedAt': instance.changedAt.toIso8601String(),
  'reason': instance.reason,
  'notes': instance.notes,
  'deviceId': instance.deviceId,
  'ipAddress': instance.ipAddress,
  'metadata': instance.metadata,
};

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.served: 'served',
  OrderStatus.picked: 'picked',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.refunded: 'refunded',
};
