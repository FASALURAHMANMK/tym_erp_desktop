// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantTableImpl _$$RestaurantTableImplFromJson(
  Map<String, dynamic> json,
) => _$RestaurantTableImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String,
  floorId: json['floorId'] as String,
  tableName: json['tableName'] as String,
  displayName: json['displayName'] as String?,
  seatingCapacity: (json['seatingCapacity'] as num?)?.toInt() ?? 4,
  status:
      $enumDecodeNullable(_$TableStatusEnumMap, json['status']) ??
      TableStatus.free,
  shape:
      $enumDecodeNullable(_$TableShapeEnumMap, json['shape']) ??
      TableShape.square,
  currentOrderId: json['currentOrderId'] as String?,
  occupiedAt:
      json['occupiedAt'] == null
          ? null
          : DateTime.parse(json['occupiedAt'] as String),
  occupiedBy: json['occupiedBy'] as String?,
  currentAmount: (json['currentAmount'] as num?)?.toDouble(),
  customerName: json['customerName'] as String?,
  customerPhone: json['customerPhone'] as String?,
  positionX: (json['positionX'] as num?)?.toDouble() ?? 0,
  positionY: (json['positionY'] as num?)?.toDouble() ?? 0,
  width: (json['width'] as num?)?.toDouble() ?? 100,
  height: (json['height'] as num?)?.toDouble() ?? 100,
  colorHex: json['colorHex'] as String? ?? '#4CAF50',
  isActive: json['isActive'] as bool? ?? true,
  displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
  notes: json['notes'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
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
  'businessId': instance.businessId,
  'locationId': instance.locationId,
  'floorId': instance.floorId,
  'tableName': instance.tableName,
  'displayName': instance.displayName,
  'seatingCapacity': instance.seatingCapacity,
  'status': _$TableStatusEnumMap[instance.status]!,
  'shape': _$TableShapeEnumMap[instance.shape]!,
  'currentOrderId': instance.currentOrderId,
  'occupiedAt': instance.occupiedAt?.toIso8601String(),
  'occupiedBy': instance.occupiedBy,
  'currentAmount': instance.currentAmount,
  'customerName': instance.customerName,
  'customerPhone': instance.customerPhone,
  'positionX': instance.positionX,
  'positionY': instance.positionY,
  'width': instance.width,
  'height': instance.height,
  'colorHex': instance.colorHex,
  'isActive': instance.isActive,
  'displayOrder': instance.displayOrder,
  'notes': instance.notes,
  'metadata': instance.metadata,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};

const _$TableStatusEnumMap = {
  TableStatus.free: 'free',
  TableStatus.occupied: 'occupied',
  TableStatus.billed: 'billed',
  TableStatus.blocked: 'blocked',
  TableStatus.reserved: 'reserved',
};

const _$TableShapeEnumMap = {
  TableShape.square: 'square',
  TableShape.rectangle: 'rectangle',
  TableShape.circle: 'circle',
  TableShape.oval: 'oval',
};

_$FloorImpl _$$FloorImplFromJson(Map<String, dynamic> json) => _$FloorImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
  tables:
      (json['tables'] as List<dynamic>?)
          ?.map((e) => RestaurantTable.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$FloorImplToJson(_$FloorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'name': instance.name,
      'description': instance.description,
      'displayOrder': instance.displayOrder,
      'isActive': instance.isActive,
      'tables': instance.tables,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
