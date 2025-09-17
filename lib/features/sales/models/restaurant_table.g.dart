// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantTableImpl _$$RestaurantTableImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantTableImpl(
  id: json['id'] as String,
  areaId: json['areaId'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String,
  tableNumber: json['tableNumber'] as String,
  displayName: json['displayName'] as String?,
  capacity: (json['capacity'] as num?)?.toInt() ?? 4,
  status:
      $enumDecodeNullable(_$TableStatusEnumMap, json['status']) ??
      TableStatus.free,
  currentOrderId: json['currentOrderId'] as String?,
  positionX: (json['positionX'] as num?)?.toInt() ?? 0,
  positionY: (json['positionY'] as num?)?.toInt() ?? 0,
  width: (json['width'] as num?)?.toInt() ?? 100,
  height: (json['height'] as num?)?.toInt() ?? 100,
  shape:
      $enumDecodeNullable(_$TableShapeEnumMap, json['shape']) ??
      TableShape.rectangle,
  isActive: json['isActive'] as bool? ?? true,
  isBookable: json['isBookable'] as bool? ?? true,
  settings: json['settings'] as Map<String, dynamic>? ?? const {},
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastOccupiedAt:
      json['lastOccupiedAt'] == null
          ? null
          : DateTime.parse(json['lastOccupiedAt'] as String),
  lastClearedAt:
      json['lastClearedAt'] == null
          ? null
          : DateTime.parse(json['lastClearedAt'] as String),
  lastSyncedAt:
      json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
  hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
);

Map<String, dynamic> _$$RestaurantTableImplToJson(
  _$RestaurantTableImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'areaId': instance.areaId,
  'businessId': instance.businessId,
  'locationId': instance.locationId,
  'tableNumber': instance.tableNumber,
  'displayName': instance.displayName,
  'capacity': instance.capacity,
  'status': _$TableStatusEnumMap[instance.status]!,
  'currentOrderId': instance.currentOrderId,
  'positionX': instance.positionX,
  'positionY': instance.positionY,
  'width': instance.width,
  'height': instance.height,
  'shape': _$TableShapeEnumMap[instance.shape]!,
  'isActive': instance.isActive,
  'isBookable': instance.isBookable,
  'settings': instance.settings,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'lastOccupiedAt': instance.lastOccupiedAt?.toIso8601String(),
  'lastClearedAt': instance.lastClearedAt?.toIso8601String(),
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};

const _$TableStatusEnumMap = {
  TableStatus.free: 'free',
  TableStatus.occupied: 'occupied',
  TableStatus.billed: 'billed',
  TableStatus.blocked: 'blocked',
  TableStatus.reserved: 'reserved',
  TableStatus.cleaning: 'cleaning',
};

const _$TableShapeEnumMap = {
  TableShape.rectangle: 'rectangle',
  TableShape.circle: 'circle',
  TableShape.square: 'square',
};
