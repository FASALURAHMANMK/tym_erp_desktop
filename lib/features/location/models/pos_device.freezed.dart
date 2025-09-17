// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pos_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$POSDevice {
  String get id => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;
  String get deviceCode =>
      throw _privateConstructorUsedError; // Unique code like POS001, POS002
  String? get description => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get lastSyncAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Create a copy of POSDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POSDeviceCopyWith<POSDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POSDeviceCopyWith<$Res> {
  factory $POSDeviceCopyWith(POSDevice value, $Res Function(POSDevice) then) =
      _$POSDeviceCopyWithImpl<$Res, POSDevice>;
  @useResult
  $Res call({
    String id,
    String locationId,
    String deviceName,
    String deviceCode,
    String? description,
    bool isDefault,
    bool isActive,
    DateTime? lastSyncAt,
    DateTime createdAt,
    DateTime updatedAt,
    SyncStatus syncStatus,
  });
}

/// @nodoc
class _$POSDeviceCopyWithImpl<$Res, $Val extends POSDevice>
    implements $POSDeviceCopyWith<$Res> {
  _$POSDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POSDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? locationId = null,
    Object? deviceName = null,
    Object? deviceCode = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? lastSyncAt = freezed,
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
            locationId:
                null == locationId
                    ? _value.locationId
                    : locationId // ignore: cast_nullable_to_non_nullable
                        as String,
            deviceName:
                null == deviceName
                    ? _value.deviceName
                    : deviceName // ignore: cast_nullable_to_non_nullable
                        as String,
            deviceCode:
                null == deviceCode
                    ? _value.deviceCode
                    : deviceCode // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
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
            lastSyncAt:
                freezed == lastSyncAt
                    ? _value.lastSyncAt
                    : lastSyncAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$POSDeviceImplCopyWith<$Res>
    implements $POSDeviceCopyWith<$Res> {
  factory _$$POSDeviceImplCopyWith(
    _$POSDeviceImpl value,
    $Res Function(_$POSDeviceImpl) then,
  ) = __$$POSDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String locationId,
    String deviceName,
    String deviceCode,
    String? description,
    bool isDefault,
    bool isActive,
    DateTime? lastSyncAt,
    DateTime createdAt,
    DateTime updatedAt,
    SyncStatus syncStatus,
  });
}

/// @nodoc
class __$$POSDeviceImplCopyWithImpl<$Res>
    extends _$POSDeviceCopyWithImpl<$Res, _$POSDeviceImpl>
    implements _$$POSDeviceImplCopyWith<$Res> {
  __$$POSDeviceImplCopyWithImpl(
    _$POSDeviceImpl _value,
    $Res Function(_$POSDeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of POSDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? locationId = null,
    Object? deviceName = null,
    Object? deviceCode = null,
    Object? description = freezed,
    Object? isDefault = null,
    Object? isActive = null,
    Object? lastSyncAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _$POSDeviceImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        locationId:
            null == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                    as String,
        deviceName:
            null == deviceName
                ? _value.deviceName
                : deviceName // ignore: cast_nullable_to_non_nullable
                    as String,
        deviceCode:
            null == deviceCode
                ? _value.deviceCode
                : deviceCode // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
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
        lastSyncAt:
            freezed == lastSyncAt
                ? _value.lastSyncAt
                : lastSyncAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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

class _$POSDeviceImpl extends _POSDevice {
  const _$POSDeviceImpl({
    required this.id,
    required this.locationId,
    required this.deviceName,
    required this.deviceCode,
    this.description,
    required this.isDefault,
    required this.isActive,
    this.lastSyncAt,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  }) : super._();

  @override
  final String id;
  @override
  final String locationId;
  @override
  final String deviceName;
  @override
  final String deviceCode;
  // Unique code like POS001, POS002
  @override
  final String? description;
  @override
  final bool isDefault;
  @override
  final bool isActive;
  @override
  final DateTime? lastSyncAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'POSDevice(id: $id, locationId: $locationId, deviceName: $deviceName, deviceCode: $deviceCode, description: $description, isDefault: $isDefault, isActive: $isActive, lastSyncAt: $lastSyncAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POSDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.deviceCode, deviceCode) ||
                other.deviceCode == deviceCode) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
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
    locationId,
    deviceName,
    deviceCode,
    description,
    isDefault,
    isActive,
    lastSyncAt,
    createdAt,
    updatedAt,
    syncStatus,
  );

  /// Create a copy of POSDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POSDeviceImplCopyWith<_$POSDeviceImpl> get copyWith =>
      __$$POSDeviceImplCopyWithImpl<_$POSDeviceImpl>(this, _$identity);
}

abstract class _POSDevice extends POSDevice {
  const factory _POSDevice({
    required final String id,
    required final String locationId,
    required final String deviceName,
    required final String deviceCode,
    final String? description,
    required final bool isDefault,
    required final bool isActive,
    final DateTime? lastSyncAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final SyncStatus syncStatus,
  }) = _$POSDeviceImpl;
  const _POSDevice._() : super._();

  @override
  String get id;
  @override
  String get locationId;
  @override
  String get deviceName;
  @override
  String get deviceCode; // Unique code like POS001, POS002
  @override
  String? get description;
  @override
  bool get isDefault;
  @override
  bool get isActive;
  @override
  DateTime? get lastSyncAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  SyncStatus get syncStatus;

  /// Create a copy of POSDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POSDeviceImplCopyWith<_$POSDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
