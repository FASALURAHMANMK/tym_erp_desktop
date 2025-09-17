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
      printerType: json['printerType'] as String,
      ipAddress: json['ipAddress'] as String?,
      port: json['port'] as String?,
      macAddress: json['macAddress'] as String?,
      deviceName: json['deviceName'] as String?,
      isActive: json['isActive'] as bool,
      isDefault: json['isDefault'] as bool,
      printCopies: (json['printCopies'] as num).toInt(),
      paperSize: json['paperSize'] as String,
      autoCut: json['autoCut'] as bool,
      cashDrawer: json['cashDrawer'] as bool,
      notes: json['notes'] as String?,
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

Map<String, dynamic> _$$KotPrinterImplToJson(_$KotPrinterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'name': instance.name,
      'printerType': instance.printerType,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'macAddress': instance.macAddress,
      'deviceName': instance.deviceName,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'printCopies': instance.printCopies,
      'paperSize': instance.paperSize,
      'autoCut': instance.autoCut,
      'cashDrawer': instance.cashDrawer,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
