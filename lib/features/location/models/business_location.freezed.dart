// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BusinessLocation {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Create a copy of BusinessLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessLocationCopyWith<BusinessLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessLocationCopyWith<$Res> {
  factory $BusinessLocationCopyWith(
    BusinessLocation value,
    $Res Function(BusinessLocation) then,
  ) = _$BusinessLocationCopyWithImpl<$Res, BusinessLocation>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? address,
    String? phone,
    bool isDefault,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    SyncStatus syncStatus,
  });
}

/// @nodoc
class _$BusinessLocationCopyWithImpl<$Res, $Val extends BusinessLocation>
    implements $BusinessLocationCopyWith<$Res> {
  _$BusinessLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? syncStatus = null,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
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
            syncStatus:
                null == syncStatus
                    ? _value.syncStatus
                    : syncStatus // ignore: cast_nullable_to_non_nullable
                        as SyncStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusinessLocationImplCopyWith<$Res>
    implements $BusinessLocationCopyWith<$Res> {
  factory _$$BusinessLocationImplCopyWith(
    _$BusinessLocationImpl value,
    $Res Function(_$BusinessLocationImpl) then,
  ) = __$$BusinessLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String name,
    String? address,
    String? phone,
    bool isDefault,
    bool isActive,
    DateTime createdAt,
    DateTime updatedAt,
    SyncStatus syncStatus,
  });
}

/// @nodoc
class __$$BusinessLocationImplCopyWithImpl<$Res>
    extends _$BusinessLocationCopyWithImpl<$Res, _$BusinessLocationImpl>
    implements _$$BusinessLocationImplCopyWith<$Res> {
  __$$BusinessLocationImplCopyWithImpl(
    _$BusinessLocationImpl _value,
    $Res Function(_$BusinessLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _$BusinessLocationImpl(
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
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
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
        syncStatus:
            null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                    as SyncStatus,
      ),
    );
  }
}

/// @nodoc

class _$BusinessLocationImpl extends _BusinessLocation {
  const _$BusinessLocationImpl({
    required this.id,
    required this.businessId,
    required this.name,
    this.address,
    this.phone,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  }) : super._();

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final bool isDefault;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'BusinessLocation(id: $id, businessId: $businessId, name: $name, address: $address, phone: $phone, isDefault: $isDefault, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    name,
    address,
    phone,
    isDefault,
    isActive,
    createdAt,
    updatedAt,
    syncStatus,
  );

  /// Create a copy of BusinessLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessLocationImplCopyWith<_$BusinessLocationImpl> get copyWith =>
      __$$BusinessLocationImplCopyWithImpl<_$BusinessLocationImpl>(
        this,
        _$identity,
      );
}

abstract class _BusinessLocation extends BusinessLocation {
  const factory _BusinessLocation({
    required final String id,
    required final String businessId,
    required final String name,
    final String? address,
    final String? phone,
    required final bool isDefault,
    required final bool isActive,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final SyncStatus syncStatus,
  }) = _$BusinessLocationImpl;
  const _BusinessLocation._() : super._();

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get name;
  @override
  String? get address;
  @override
  String? get phone;
  @override
  bool get isDefault;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  SyncStatus get syncStatus;

  /// Create a copy of BusinessLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessLocationImplCopyWith<_$BusinessLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
