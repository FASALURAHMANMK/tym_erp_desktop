// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_printer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KotPrinterImpl _$$KotPrinterImplFromJson(Map<String, dynamic> json) =>
    _$KotPrinterImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      locationId: json['locationId'] as String,
      name: json['name'] as String,
      ipAddress: json['ipAddress'] as String,
      port: (json['port'] as num?)?.toInt() ?? 9100,
      type:
          $enumDecodeNullable(_$PrinterTypeEnumMap, json['type']) ??
          PrinterType.network,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt:
          json['lastSyncedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncedAt'] as String),
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$KotPrinterImplToJson(_$KotPrinterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'name': instance.name,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'type': _$PrinterTypeEnumMap[instance.type]!,
      'description': instance.description,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };

const _$PrinterTypeEnumMap = {
  PrinterType.network: 'network',
  PrinterType.usb: 'usb',
  PrinterType.bluetooth: 'bluetooth',
};
