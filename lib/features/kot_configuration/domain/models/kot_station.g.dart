// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KotStationImpl _$$KotStationImplFromJson(Map<String, dynamic> json) =>
    _$KotStationImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      locationId: json['locationId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool,
      displayOrder: (json['displayOrder'] as num).toInt(),
      color: json['color'] as String?,
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

Map<String, dynamic> _$$KotStationImplToJson(_$KotStationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'isActive': instance.isActive,
      'displayOrder': instance.displayOrder,
      'color': instance.color,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
