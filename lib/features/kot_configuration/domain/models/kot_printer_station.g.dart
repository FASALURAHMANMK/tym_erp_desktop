// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_printer_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KotPrinterStationImpl _$$KotPrinterStationImplFromJson(
  Map<String, dynamic> json,
) => _$KotPrinterStationImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String,
  printerId: json['printerId'] as String,
  stationId: json['stationId'] as String,
  isActive: json['isActive'] as bool,
  priority: (json['priority'] as num).toInt(),
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

Map<String, dynamic> _$$KotPrinterStationImplToJson(
  _$KotPrinterStationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'locationId': instance.locationId,
  'printerId': instance.printerId,
  'stationId': instance.stationId,
  'isActive': instance.isActive,
  'priority': instance.priority,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};
