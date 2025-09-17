// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kot_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KotStation _$KotStationFromJson(Map<String, dynamic> json) {
  return _KotStation.fromJson(json);
}

/// @nodoc
mixin _$KotStation {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // kitchen, bar, bakery, grill, etc.
  String? get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  String? get color =>
      throw _privateConstructorUsedError; // hex color for visual identification
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this KotStation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KotStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KotStationCopyWith<KotStation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KotStationCopyWith<$Res> {
  factory $KotStationCopyWith(
    KotStation value,
    $Res Function(KotStation) then,
  ) = _$KotStationCopyWithImpl<$Res, KotStation>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String type,
    String? description,
    bool isActive,
    int displayOrder,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$KotStationCopyWithImpl<$Res, $Val extends KotStation>
    implements $KotStationCopyWith<$Res> {
  _$KotStationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KotStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? color = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            color:
                freezed == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$KotStationImplCopyWith<$Res>
    implements $KotStationCopyWith<$Res> {
  factory _$$KotStationImplCopyWith(
    _$KotStationImpl value,
    $Res Function(_$KotStationImpl) then,
  ) = __$$KotStationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String type,
    String? description,
    bool isActive,
    int displayOrder,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$KotStationImplCopyWithImpl<$Res>
    extends _$KotStationCopyWithImpl<$Res, _$KotStationImpl>
    implements _$$KotStationImplCopyWith<$Res> {
  __$$KotStationImplCopyWithImpl(
    _$KotStationImpl _value,
    $Res Function(_$KotStationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KotStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? color = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$KotStationImpl(
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
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        color:
            freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
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
class _$KotStationImpl implements _KotStation {
  const _$KotStationImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.name,
    required this.type,
    this.description,
    required this.isActive,
    required this.displayOrder,
    this.color,
    this.createdAt,
    this.updatedAt,
    this.hasUnsyncedChanges = false,
  });

  factory _$KotStationImpl.fromJson(Map<String, dynamic> json) =>
      _$$KotStationImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String name;
  @override
  final String type;
  // kitchen, bar, bakery, grill, etc.
  @override
  final String? description;
  @override
  final bool isActive;
  @override
  final int displayOrder;
  @override
  final String? color;
  // hex color for visual identification
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'KotStation(id: $id, businessId: $businessId, locationId: $locationId, name: $name, type: $type, description: $description, isActive: $isActive, displayOrder: $displayOrder, color: $color, createdAt: $createdAt, updatedAt: $updatedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KotStationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    locationId,
    name,
    type,
    description,
    isActive,
    displayOrder,
    color,
    createdAt,
    updatedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of KotStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KotStationImplCopyWith<_$KotStationImpl> get copyWith =>
      __$$KotStationImplCopyWithImpl<_$KotStationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KotStationImplToJson(this);
  }
}

abstract class _KotStation implements KotStation {
  const factory _KotStation({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String name,
    required final String type,
    final String? description,
    required final bool isActive,
    required final int displayOrder,
    final String? color,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final bool hasUnsyncedChanges,
  }) = _$KotStationImpl;

  factory _KotStation.fromJson(Map<String, dynamic> json) =
      _$KotStationImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get name;
  @override
  String get type; // kitchen, bar, bakery, grill, etc.
  @override
  String? get description;
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  String? get color; // hex color for visual identification
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of KotStation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotStationImplCopyWith<_$KotStationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
