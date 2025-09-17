// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeSessionImpl _$$EmployeeSessionImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeSessionImpl(
  id: json['id'] as String,
  employeeId: json['employeeId'] as String,
  sessionToken: json['sessionToken'] as String,
  deviceId: json['deviceId'] as String,
  deviceName: json['deviceName'] as String?,
  deviceType: $enumDecodeNullable(_$DeviceTypeEnumMap, json['deviceType']),
  appType: $enumDecodeNullable(_$AppTypeEnumMap, json['appType']),
  appVersion: json['appVersion'] as String?,
  ipAddress: json['ipAddress'] as String?,
  userAgent: json['userAgent'] as String?,
  startedAt: DateTime.parse(json['startedAt'] as String),
  lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
  expiresAt:
      json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
  lastKnownLatitude: (json['lastKnownLatitude'] as num?)?.toDouble(),
  lastKnownLongitude: (json['lastKnownLongitude'] as num?)?.toDouble(),
  lastLocationUpdate:
      json['lastLocationUpdate'] == null
          ? null
          : DateTime.parse(json['lastLocationUpdate'] as String),
  isActive: json['isActive'] as bool? ?? true,
  endedAt:
      json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
  endReason: $enumDecodeNullable(_$SessionEndReasonEnumMap, json['endReason']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$EmployeeSessionImplToJson(
  _$EmployeeSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'sessionToken': instance.sessionToken,
  'deviceId': instance.deviceId,
  'deviceName': instance.deviceName,
  'deviceType': _$DeviceTypeEnumMap[instance.deviceType],
  'appType': _$AppTypeEnumMap[instance.appType],
  'appVersion': instance.appVersion,
  'ipAddress': instance.ipAddress,
  'userAgent': instance.userAgent,
  'startedAt': instance.startedAt.toIso8601String(),
  'lastActivityAt': instance.lastActivityAt.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'lastKnownLatitude': instance.lastKnownLatitude,
  'lastKnownLongitude': instance.lastKnownLongitude,
  'lastLocationUpdate': instance.lastLocationUpdate?.toIso8601String(),
  'isActive': instance.isActive,
  'endedAt': instance.endedAt?.toIso8601String(),
  'endReason': _$SessionEndReasonEnumMap[instance.endReason],
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$DeviceTypeEnumMap = {
  DeviceType.desktop: 'desktop',
  DeviceType.mobile: 'mobile',
  DeviceType.tablet: 'tablet',
  DeviceType.posTerminal: 'pos_terminal',
};

const _$AppTypeEnumMap = {
  AppType.erpDesktop: 'erp_desktop',
  AppType.waiterApp: 'waiter_app',
  AppType.kitchenApp: 'kitchen_app',
  AppType.deliveryApp: 'delivery_app',
};

const _$SessionEndReasonEnumMap = {
  SessionEndReason.logout: 'logout',
  SessionEndReason.timeout: 'timeout',
  SessionEndReason.forced: 'forced',
  SessionEndReason.appClosed: 'app_closed',
  SessionEndReason.networkError: 'network_error',
};
