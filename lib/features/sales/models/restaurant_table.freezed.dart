// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RestaurantTable _$RestaurantTableFromJson(Map<String, dynamic> json) {
  return _RestaurantTable.fromJson(json);
}

/// @nodoc
mixin _$RestaurantTable {
  String get id => throw _privateConstructorUsedError;
  String get areaId => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get tableNumber => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  TableStatus get status => throw _privateConstructorUsedError;
  String? get currentOrderId => throw _privateConstructorUsedError;
  int get positionX => throw _privateConstructorUsedError;
  int get positionY => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  TableShape get shape => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isBookable => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastOccupiedAt => throw _privateConstructorUsedError;
  DateTime? get lastClearedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this RestaurantTable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantTableCopyWith<RestaurantTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantTableCopyWith<$Res> {
  factory $RestaurantTableCopyWith(
    RestaurantTable value,
    $Res Function(RestaurantTable) then,
  ) = _$RestaurantTableCopyWithImpl<$Res, RestaurantTable>;
  @useResult
  $Res call({
    String id,
    String areaId,
    String businessId,
    String locationId,
    String tableNumber,
    String? displayName,
    int capacity,
    TableStatus status,
    String? currentOrderId,
    int positionX,
    int positionY,
    int width,
    int height,
    TableShape shape,
    bool isActive,
    bool isBookable,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastOccupiedAt,
    DateTime? lastClearedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$RestaurantTableCopyWithImpl<$Res, $Val extends RestaurantTable>
    implements $RestaurantTableCopyWith<$Res> {
  _$RestaurantTableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? areaId = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? tableNumber = null,
    Object? displayName = freezed,
    Object? capacity = null,
    Object? status = null,
    Object? currentOrderId = freezed,
    Object? positionX = null,
    Object? positionY = null,
    Object? width = null,
    Object? height = null,
    Object? shape = null,
    Object? isActive = null,
    Object? isBookable = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastOccupiedAt = freezed,
    Object? lastClearedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            areaId:
                null == areaId
                    ? _value.areaId
                    : areaId // ignore: cast_nullable_to_non_nullable
                        as String,
            businessId:
                null == businessId
                    ? _value.businessId
                    : businessId // ignore: cast_nullable_to_non_nullable
                        as String,
            locationId:
                null == locationId
                    ? _value.locationId
                    : locationId // ignore: cast_nullable_to_non_nullable
                        as String,
            tableNumber:
                null == tableNumber
                    ? _value.tableNumber
                    : tableNumber // ignore: cast_nullable_to_non_nullable
                        as String,
            displayName:
                freezed == displayName
                    ? _value.displayName
                    : displayName // ignore: cast_nullable_to_non_nullable
                        as String?,
            capacity:
                null == capacity
                    ? _value.capacity
                    : capacity // ignore: cast_nullable_to_non_nullable
                        as int,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as TableStatus,
            currentOrderId:
                freezed == currentOrderId
                    ? _value.currentOrderId
                    : currentOrderId // ignore: cast_nullable_to_non_nullable
                        as String?,
            positionX:
                null == positionX
                    ? _value.positionX
                    : positionX // ignore: cast_nullable_to_non_nullable
                        as int,
            positionY:
                null == positionY
                    ? _value.positionY
                    : positionY // ignore: cast_nullable_to_non_nullable
                        as int,
            width:
                null == width
                    ? _value.width
                    : width // ignore: cast_nullable_to_non_nullable
                        as int,
            height:
                null == height
                    ? _value.height
                    : height // ignore: cast_nullable_to_non_nullable
                        as int,
            shape:
                null == shape
                    ? _value.shape
                    : shape // ignore: cast_nullable_to_non_nullable
                        as TableShape,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isBookable:
                null == isBookable
                    ? _value.isBookable
                    : isBookable // ignore: cast_nullable_to_non_nullable
                        as bool,
            settings:
                null == settings
                    ? _value.settings
                    : settings // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastOccupiedAt:
                freezed == lastOccupiedAt
                    ? _value.lastOccupiedAt
                    : lastOccupiedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastClearedAt:
                freezed == lastClearedAt
                    ? _value.lastClearedAt
                    : lastClearedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastSyncedAt:
                freezed == lastSyncedAt
                    ? _value.lastSyncedAt
                    : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            hasUnsyncedChanges:
                null == hasUnsyncedChanges
                    ? _value.hasUnsyncedChanges
                    : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RestaurantTableImplCopyWith<$Res>
    implements $RestaurantTableCopyWith<$Res> {
  factory _$$RestaurantTableImplCopyWith(
    _$RestaurantTableImpl value,
    $Res Function(_$RestaurantTableImpl) then,
  ) = __$$RestaurantTableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String areaId,
    String businessId,
    String locationId,
    String tableNumber,
    String? displayName,
    int capacity,
    TableStatus status,
    String? currentOrderId,
    int positionX,
    int positionY,
    int width,
    int height,
    TableShape shape,
    bool isActive,
    bool isBookable,
    Map<String, dynamic> settings,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastOccupiedAt,
    DateTime? lastClearedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$RestaurantTableImplCopyWithImpl<$Res>
    extends _$RestaurantTableCopyWithImpl<$Res, _$RestaurantTableImpl>
    implements _$$RestaurantTableImplCopyWith<$Res> {
  __$$RestaurantTableImplCopyWithImpl(
    _$RestaurantTableImpl _value,
    $Res Function(_$RestaurantTableImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? areaId = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? tableNumber = null,
    Object? displayName = freezed,
    Object? capacity = null,
    Object? status = null,
    Object? currentOrderId = freezed,
    Object? positionX = null,
    Object? positionY = null,
    Object? width = null,
    Object? height = null,
    Object? shape = null,
    Object? isActive = null,
    Object? isBookable = null,
    Object? settings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastOccupiedAt = freezed,
    Object? lastClearedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$RestaurantTableImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        areaId:
            null == areaId
                ? _value.areaId
                : areaId // ignore: cast_nullable_to_non_nullable
                    as String,
        businessId:
            null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                    as String,
        locationId:
            null == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                    as String,
        tableNumber:
            null == tableNumber
                ? _value.tableNumber
                : tableNumber // ignore: cast_nullable_to_non_nullable
                    as String,
        displayName:
            freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String?,
        capacity:
            null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                    as int,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as TableStatus,
        currentOrderId:
            freezed == currentOrderId
                ? _value.currentOrderId
                : currentOrderId // ignore: cast_nullable_to_non_nullable
                    as String?,
        positionX:
            null == positionX
                ? _value.positionX
                : positionX // ignore: cast_nullable_to_non_nullable
                    as int,
        positionY:
            null == positionY
                ? _value.positionY
                : positionY // ignore: cast_nullable_to_non_nullable
                    as int,
        width:
            null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                    as int,
        height:
            null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                    as int,
        shape:
            null == shape
                ? _value.shape
                : shape // ignore: cast_nullable_to_non_nullable
                    as TableShape,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isBookable:
            null == isBookable
                ? _value.isBookable
                : isBookable // ignore: cast_nullable_to_non_nullable
                    as bool,
        settings:
            null == settings
                ? _value._settings
                : settings // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastOccupiedAt:
            freezed == lastOccupiedAt
                ? _value.lastOccupiedAt
                : lastOccupiedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastClearedAt:
            freezed == lastClearedAt
                ? _value.lastClearedAt
                : lastClearedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastSyncedAt:
            freezed == lastSyncedAt
                ? _value.lastSyncedAt
                : lastSyncedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        hasUnsyncedChanges:
            null == hasUnsyncedChanges
                ? _value.hasUnsyncedChanges
                : hasUnsyncedChanges // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantTableImpl extends _RestaurantTable {
  const _$RestaurantTableImpl({
    required this.id,
    required this.areaId,
    required this.businessId,
    required this.locationId,
    required this.tableNumber,
    this.displayName,
    this.capacity = 4,
    this.status = TableStatus.free,
    this.currentOrderId,
    this.positionX = 0,
    this.positionY = 0,
    this.width = 100,
    this.height = 100,
    this.shape = TableShape.rectangle,
    this.isActive = true,
    this.isBookable = true,
    final Map<String, dynamic> settings = const {},
    required this.createdAt,
    required this.updatedAt,
    this.lastOccupiedAt,
    this.lastClearedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : _settings = settings,
       super._();

  factory _$RestaurantTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantTableImplFromJson(json);

  @override
  final String id;
  @override
  final String areaId;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String tableNumber;
  @override
  final String? displayName;
  @override
  @JsonKey()
  final int capacity;
  @override
  @JsonKey()
  final TableStatus status;
  @override
  final String? currentOrderId;
  @override
  @JsonKey()
  final int positionX;
  @override
  @JsonKey()
  final int positionY;
  @override
  @JsonKey()
  final int width;
  @override
  @JsonKey()
  final int height;
  @override
  @JsonKey()
  final TableShape shape;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isBookable;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastOccupiedAt;
  @override
  final DateTime? lastClearedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'RestaurantTable(id: $id, areaId: $areaId, businessId: $businessId, locationId: $locationId, tableNumber: $tableNumber, displayName: $displayName, capacity: $capacity, status: $status, currentOrderId: $currentOrderId, positionX: $positionX, positionY: $positionY, width: $width, height: $height, shape: $shape, isActive: $isActive, isBookable: $isBookable, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, lastOccupiedAt: $lastOccupiedAt, lastClearedAt: $lastClearedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantTableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentOrderId, currentOrderId) ||
                other.currentOrderId == currentOrderId) &&
            (identical(other.positionX, positionX) ||
                other.positionX == positionX) &&
            (identical(other.positionY, positionY) ||
                other.positionY == positionY) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.shape, shape) || other.shape == shape) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isBookable, isBookable) ||
                other.isBookable == isBookable) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastOccupiedAt, lastOccupiedAt) ||
                other.lastOccupiedAt == lastOccupiedAt) &&
            (identical(other.lastClearedAt, lastClearedAt) ||
                other.lastClearedAt == lastClearedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    areaId,
    businessId,
    locationId,
    tableNumber,
    displayName,
    capacity,
    status,
    currentOrderId,
    positionX,
    positionY,
    width,
    height,
    shape,
    isActive,
    isBookable,
    const DeepCollectionEquality().hash(_settings),
    createdAt,
    updatedAt,
    lastOccupiedAt,
    lastClearedAt,
    lastSyncedAt,
    hasUnsyncedChanges,
  ]);

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      __$$RestaurantTableImplCopyWithImpl<_$RestaurantTableImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantTableImplToJson(this);
  }
}

abstract class _RestaurantTable extends RestaurantTable {
  const factory _RestaurantTable({
    required final String id,
    required final String areaId,
    required final String businessId,
    required final String locationId,
    required final String tableNumber,
    final String? displayName,
    final int capacity,
    final TableStatus status,
    final String? currentOrderId,
    final int positionX,
    final int positionY,
    final int width,
    final int height,
    final TableShape shape,
    final bool isActive,
    final bool isBookable,
    final Map<String, dynamic> settings,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastOccupiedAt,
    final DateTime? lastClearedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$RestaurantTableImpl;
  const _RestaurantTable._() : super._();

  factory _RestaurantTable.fromJson(Map<String, dynamic> json) =
      _$RestaurantTableImpl.fromJson;

  @override
  String get id;
  @override
  String get areaId;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get tableNumber;
  @override
  String? get displayName;
  @override
  int get capacity;
  @override
  TableStatus get status;
  @override
  String? get currentOrderId;
  @override
  int get positionX;
  @override
  int get positionY;
  @override
  int get width;
  @override
  int get height;
  @override
  TableShape get shape;
  @override
  bool get isActive;
  @override
  bool get isBookable;
  @override
  Map<String, dynamic> get settings;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastOccupiedAt;
  @override
  DateTime? get lastClearedAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of RestaurantTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantTableImplCopyWith<_$RestaurantTableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
