// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table.dart';

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
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get floorId => throw _privateConstructorUsedError;
  String get tableName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  int get seatingCapacity => throw _privateConstructorUsedError;
  TableStatus get status => throw _privateConstructorUsedError;
  TableShape get shape => throw _privateConstructorUsedError;
  String? get currentOrderId => throw _privateConstructorUsedError;
  DateTime? get occupiedAt => throw _privateConstructorUsedError;
  String? get occupiedBy =>
      throw _privateConstructorUsedError; // Waiter/Staff ID
  double? get currentAmount => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get customerPhone => throw _privateConstructorUsedError;
  double get positionX =>
      throw _privateConstructorUsedError; // For visual layout
  double get positionY =>
      throw _privateConstructorUsedError; // For visual layout
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError; // Visual color
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
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
    String businessId,
    String locationId,
    String floorId,
    String tableName,
    String? displayName,
    int seatingCapacity,
    TableStatus status,
    TableShape shape,
    String? currentOrderId,
    DateTime? occupiedAt,
    String? occupiedBy,
    double? currentAmount,
    String? customerName,
    String? customerPhone,
    double positionX,
    double positionY,
    double width,
    double height,
    String colorHex,
    bool isActive,
    int displayOrder,
    String? notes,
    Map<String, dynamic> metadata,
    DateTime createdAt,
    DateTime updatedAt,
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
    Object? businessId = null,
    Object? locationId = null,
    Object? floorId = null,
    Object? tableName = null,
    Object? displayName = freezed,
    Object? seatingCapacity = null,
    Object? status = null,
    Object? shape = null,
    Object? currentOrderId = freezed,
    Object? occupiedAt = freezed,
    Object? occupiedBy = freezed,
    Object? currentAmount = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? positionX = null,
    Object? positionY = null,
    Object? width = null,
    Object? height = null,
    Object? colorHex = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? notes = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            floorId:
                null == floorId
                    ? _value.floorId
                    : floorId // ignore: cast_nullable_to_non_nullable
                        as String,
            tableName:
                null == tableName
                    ? _value.tableName
                    : tableName // ignore: cast_nullable_to_non_nullable
                        as String,
            displayName:
                freezed == displayName
                    ? _value.displayName
                    : displayName // ignore: cast_nullable_to_non_nullable
                        as String?,
            seatingCapacity:
                null == seatingCapacity
                    ? _value.seatingCapacity
                    : seatingCapacity // ignore: cast_nullable_to_non_nullable
                        as int,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as TableStatus,
            shape:
                null == shape
                    ? _value.shape
                    : shape // ignore: cast_nullable_to_non_nullable
                        as TableShape,
            currentOrderId:
                freezed == currentOrderId
                    ? _value.currentOrderId
                    : currentOrderId // ignore: cast_nullable_to_non_nullable
                        as String?,
            occupiedAt:
                freezed == occupiedAt
                    ? _value.occupiedAt
                    : occupiedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            occupiedBy:
                freezed == occupiedBy
                    ? _value.occupiedBy
                    : occupiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentAmount:
                freezed == currentAmount
                    ? _value.currentAmount
                    : currentAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            customerName:
                freezed == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerPhone:
                freezed == customerPhone
                    ? _value.customerPhone
                    : customerPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            positionX:
                null == positionX
                    ? _value.positionX
                    : positionX // ignore: cast_nullable_to_non_nullable
                        as double,
            positionY:
                null == positionY
                    ? _value.positionY
                    : positionY // ignore: cast_nullable_to_non_nullable
                        as double,
            width:
                null == width
                    ? _value.width
                    : width // ignore: cast_nullable_to_non_nullable
                        as double,
            height:
                null == height
                    ? _value.height
                    : height // ignore: cast_nullable_to_non_nullable
                        as double,
            colorHex:
                null == colorHex
                    ? _value.colorHex
                    : colorHex // ignore: cast_nullable_to_non_nullable
                        as String,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                null == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
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
    String businessId,
    String locationId,
    String floorId,
    String tableName,
    String? displayName,
    int seatingCapacity,
    TableStatus status,
    TableShape shape,
    String? currentOrderId,
    DateTime? occupiedAt,
    String? occupiedBy,
    double? currentAmount,
    String? customerName,
    String? customerPhone,
    double positionX,
    double positionY,
    double width,
    double height,
    String colorHex,
    bool isActive,
    int displayOrder,
    String? notes,
    Map<String, dynamic> metadata,
    DateTime createdAt,
    DateTime updatedAt,
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
    Object? businessId = null,
    Object? locationId = null,
    Object? floorId = null,
    Object? tableName = null,
    Object? displayName = freezed,
    Object? seatingCapacity = null,
    Object? status = null,
    Object? shape = null,
    Object? currentOrderId = freezed,
    Object? occupiedAt = freezed,
    Object? occupiedBy = freezed,
    Object? currentAmount = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? positionX = null,
    Object? positionY = null,
    Object? width = null,
    Object? height = null,
    Object? colorHex = null,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? notes = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
        floorId:
            null == floorId
                ? _value.floorId
                : floorId // ignore: cast_nullable_to_non_nullable
                    as String,
        tableName:
            null == tableName
                ? _value.tableName
                : tableName // ignore: cast_nullable_to_non_nullable
                    as String,
        displayName:
            freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String?,
        seatingCapacity:
            null == seatingCapacity
                ? _value.seatingCapacity
                : seatingCapacity // ignore: cast_nullable_to_non_nullable
                    as int,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as TableStatus,
        shape:
            null == shape
                ? _value.shape
                : shape // ignore: cast_nullable_to_non_nullable
                    as TableShape,
        currentOrderId:
            freezed == currentOrderId
                ? _value.currentOrderId
                : currentOrderId // ignore: cast_nullable_to_non_nullable
                    as String?,
        occupiedAt:
            freezed == occupiedAt
                ? _value.occupiedAt
                : occupiedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        occupiedBy:
            freezed == occupiedBy
                ? _value.occupiedBy
                : occupiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentAmount:
            freezed == currentAmount
                ? _value.currentAmount
                : currentAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        customerName:
            freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerPhone:
            freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        positionX:
            null == positionX
                ? _value.positionX
                : positionX // ignore: cast_nullable_to_non_nullable
                    as double,
        positionY:
            null == positionY
                ? _value.positionY
                : positionY // ignore: cast_nullable_to_non_nullable
                    as double,
        width:
            null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                    as double,
        height:
            null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                    as double,
        colorHex:
            null == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                    as String,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            null == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
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
    required this.businessId,
    required this.locationId,
    required this.floorId,
    required this.tableName,
    this.displayName,
    this.seatingCapacity = 4,
    this.status = TableStatus.free,
    this.shape = TableShape.square,
    this.currentOrderId,
    this.occupiedAt,
    this.occupiedBy,
    this.currentAmount,
    this.customerName,
    this.customerPhone,
    this.positionX = 0,
    this.positionY = 0,
    this.width = 100,
    this.height = 100,
    this.colorHex = '#4CAF50',
    this.isActive = true,
    this.displayOrder = 0,
    this.notes,
    final Map<String, dynamic> metadata = const {},
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : _metadata = metadata,
       super._();

  factory _$RestaurantTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantTableImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String floorId;
  @override
  final String tableName;
  @override
  final String? displayName;
  @override
  @JsonKey()
  final int seatingCapacity;
  @override
  @JsonKey()
  final TableStatus status;
  @override
  @JsonKey()
  final TableShape shape;
  @override
  final String? currentOrderId;
  @override
  final DateTime? occupiedAt;
  @override
  final String? occupiedBy;
  // Waiter/Staff ID
  @override
  final double? currentAmount;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  @JsonKey()
  final double positionX;
  // For visual layout
  @override
  @JsonKey()
  final double positionY;
  // For visual layout
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final String colorHex;
  // Visual color
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final String? notes;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'RestaurantTable(id: $id, businessId: $businessId, locationId: $locationId, floorId: $floorId, tableName: $tableName, displayName: $displayName, seatingCapacity: $seatingCapacity, status: $status, shape: $shape, currentOrderId: $currentOrderId, occupiedAt: $occupiedAt, occupiedBy: $occupiedBy, currentAmount: $currentAmount, customerName: $customerName, customerPhone: $customerPhone, positionX: $positionX, positionY: $positionY, width: $width, height: $height, colorHex: $colorHex, isActive: $isActive, displayOrder: $displayOrder, notes: $notes, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantTableImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.floorId, floorId) || other.floorId == floorId) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.seatingCapacity, seatingCapacity) ||
                other.seatingCapacity == seatingCapacity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.shape, shape) || other.shape == shape) &&
            (identical(other.currentOrderId, currentOrderId) ||
                other.currentOrderId == currentOrderId) &&
            (identical(other.occupiedAt, occupiedAt) ||
                other.occupiedAt == occupiedAt) &&
            (identical(other.occupiedBy, occupiedBy) ||
                other.occupiedBy == occupiedBy) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.positionX, positionX) ||
                other.positionX == positionX) &&
            (identical(other.positionY, positionY) ||
                other.positionY == positionY) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
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
    businessId,
    locationId,
    floorId,
    tableName,
    displayName,
    seatingCapacity,
    status,
    shape,
    currentOrderId,
    occupiedAt,
    occupiedBy,
    currentAmount,
    customerName,
    customerPhone,
    positionX,
    positionY,
    width,
    height,
    colorHex,
    isActive,
    displayOrder,
    notes,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
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
    required final String businessId,
    required final String locationId,
    required final String floorId,
    required final String tableName,
    final String? displayName,
    final int seatingCapacity,
    final TableStatus status,
    final TableShape shape,
    final String? currentOrderId,
    final DateTime? occupiedAt,
    final String? occupiedBy,
    final double? currentAmount,
    final String? customerName,
    final String? customerPhone,
    final double positionX,
    final double positionY,
    final double width,
    final double height,
    final String colorHex,
    final bool isActive,
    final int displayOrder,
    final String? notes,
    final Map<String, dynamic> metadata,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$RestaurantTableImpl;
  const _RestaurantTable._() : super._();

  factory _RestaurantTable.fromJson(Map<String, dynamic> json) =
      _$RestaurantTableImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get floorId;
  @override
  String get tableName;
  @override
  String? get displayName;
  @override
  int get seatingCapacity;
  @override
  TableStatus get status;
  @override
  TableShape get shape;
  @override
  String? get currentOrderId;
  @override
  DateTime? get occupiedAt;
  @override
  String? get occupiedBy; // Waiter/Staff ID
  @override
  double? get currentAmount;
  @override
  String? get customerName;
  @override
  String? get customerPhone;
  @override
  double get positionX; // For visual layout
  @override
  double get positionY; // For visual layout
  @override
  double get width;
  @override
  double get height;
  @override
  String get colorHex; // Visual color
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  String? get notes;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
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

Floor _$FloorFromJson(Map<String, dynamic> json) {
  return _Floor.fromJson(json);
}

/// @nodoc
mixin _$Floor {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<RestaurantTable> get tables => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Floor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Floor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FloorCopyWith<Floor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FloorCopyWith<$Res> {
  factory $FloorCopyWith(Floor value, $Res Function(Floor) then) =
      _$FloorCopyWithImpl<$Res, Floor>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String? description,
    int displayOrder,
    bool isActive,
    List<RestaurantTable> tables,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$FloorCopyWithImpl<$Res, $Val extends Floor>
    implements $FloorCopyWith<$Res> {
  _$FloorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Floor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? description = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
    Object? tables = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            displayOrder:
                null == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            tables:
                null == tables
                    ? _value.tables
                    : tables // ignore: cast_nullable_to_non_nullable
                        as List<RestaurantTable>,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FloorImplCopyWith<$Res> implements $FloorCopyWith<$Res> {
  factory _$$FloorImplCopyWith(
    _$FloorImpl value,
    $Res Function(_$FloorImpl) then,
  ) = __$$FloorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String? description,
    int displayOrder,
    bool isActive,
    List<RestaurantTable> tables,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$FloorImplCopyWithImpl<$Res>
    extends _$FloorCopyWithImpl<$Res, _$FloorImpl>
    implements _$$FloorImplCopyWith<$Res> {
  __$$FloorImplCopyWithImpl(
    _$FloorImpl _value,
    $Res Function(_$FloorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Floor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? description = freezed,
    Object? displayOrder = null,
    Object? isActive = null,
    Object? tables = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$FloorImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayOrder:
            null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        tables:
            null == tables
                ? _value._tables
                : tables // ignore: cast_nullable_to_non_nullable
                    as List<RestaurantTable>,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FloorImpl extends _Floor {
  const _$FloorImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.name,
    this.description,
    this.displayOrder = 0,
    this.isActive = true,
    final List<RestaurantTable> tables = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _tables = tables,
       super._();

  factory _$FloorImpl.fromJson(Map<String, dynamic> json) =>
      _$$FloorImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool isActive;
  final List<RestaurantTable> _tables;
  @override
  @JsonKey()
  List<RestaurantTable> get tables {
    if (_tables is EqualUnmodifiableListView) return _tables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tables);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Floor(id: $id, businessId: $businessId, locationId: $locationId, name: $name, description: $description, displayOrder: $displayOrder, isActive: $isActive, tables: $tables, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FloorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._tables, _tables) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    locationId,
    name,
    description,
    displayOrder,
    isActive,
    const DeepCollectionEquality().hash(_tables),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Floor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FloorImplCopyWith<_$FloorImpl> get copyWith =>
      __$$FloorImplCopyWithImpl<_$FloorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FloorImplToJson(this);
  }
}

abstract class _Floor extends Floor {
  const factory _Floor({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String name,
    final String? description,
    final int displayOrder,
    final bool isActive,
    final List<RestaurantTable> tables,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$FloorImpl;
  const _Floor._() : super._();

  factory _Floor.fromJson(Map<String, dynamic> json) = _$FloorImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get name;
  @override
  String? get description;
  @override
  int get displayOrder;
  @override
  bool get isActive;
  @override
  List<RestaurantTable> get tables;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Floor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FloorImplCopyWith<_$FloorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
