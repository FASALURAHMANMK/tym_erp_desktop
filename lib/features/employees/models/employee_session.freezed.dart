// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmployeeSession _$EmployeeSessionFromJson(Map<String, dynamic> json) {
  return _EmployeeSession.fromJson(json);
}

/// @nodoc
mixin _$EmployeeSession {
  String get id => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError; // Session Info
  String get sessionToken => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  DeviceType? get deviceType => throw _privateConstructorUsedError;
  AppType? get appType => throw _privateConstructorUsedError;
  String? get appVersion => throw _privateConstructorUsedError; // Network Info
  String? get ipAddress => throw _privateConstructorUsedError;
  String? get userAgent => throw _privateConstructorUsedError; // Activity
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime get lastActivityAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt =>
      throw _privateConstructorUsedError; // Location tracking (for mobile apps)
  double? get lastKnownLatitude => throw _privateConstructorUsedError;
  double? get lastKnownLongitude => throw _privateConstructorUsedError;
  DateTime? get lastLocationUpdate =>
      throw _privateConstructorUsedError; // Status
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  SessionEndReason? get endReason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this EmployeeSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeSessionCopyWith<EmployeeSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeSessionCopyWith<$Res> {
  factory $EmployeeSessionCopyWith(
    EmployeeSession value,
    $Res Function(EmployeeSession) then,
  ) = _$EmployeeSessionCopyWithImpl<$Res, EmployeeSession>;
  @useResult
  $Res call({
    String id,
    String employeeId,
    String sessionToken,
    String deviceId,
    String? deviceName,
    DeviceType? deviceType,
    AppType? appType,
    String? appVersion,
    String? ipAddress,
    String? userAgent,
    DateTime startedAt,
    DateTime lastActivityAt,
    DateTime? expiresAt,
    double? lastKnownLatitude,
    double? lastKnownLongitude,
    DateTime? lastLocationUpdate,
    bool isActive,
    DateTime? endedAt,
    SessionEndReason? endReason,
    DateTime createdAt,
  });
}

/// @nodoc
class _$EmployeeSessionCopyWithImpl<$Res, $Val extends EmployeeSession>
    implements $EmployeeSessionCopyWith<$Res> {
  _$EmployeeSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? sessionToken = null,
    Object? deviceId = null,
    Object? deviceName = freezed,
    Object? deviceType = freezed,
    Object? appType = freezed,
    Object? appVersion = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? startedAt = null,
    Object? lastActivityAt = null,
    Object? expiresAt = freezed,
    Object? lastKnownLatitude = freezed,
    Object? lastKnownLongitude = freezed,
    Object? lastLocationUpdate = freezed,
    Object? isActive = null,
    Object? endedAt = freezed,
    Object? endReason = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            employeeId:
                null == employeeId
                    ? _value.employeeId
                    : employeeId // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionToken:
                null == sessionToken
                    ? _value.sessionToken
                    : sessionToken // ignore: cast_nullable_to_non_nullable
                        as String,
            deviceId:
                null == deviceId
                    ? _value.deviceId
                    : deviceId // ignore: cast_nullable_to_non_nullable
                        as String,
            deviceName:
                freezed == deviceName
                    ? _value.deviceName
                    : deviceName // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceType:
                freezed == deviceType
                    ? _value.deviceType
                    : deviceType // ignore: cast_nullable_to_non_nullable
                        as DeviceType?,
            appType:
                freezed == appType
                    ? _value.appType
                    : appType // ignore: cast_nullable_to_non_nullable
                        as AppType?,
            appVersion:
                freezed == appVersion
                    ? _value.appVersion
                    : appVersion // ignore: cast_nullable_to_non_nullable
                        as String?,
            ipAddress:
                freezed == ipAddress
                    ? _value.ipAddress
                    : ipAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            userAgent:
                freezed == userAgent
                    ? _value.userAgent
                    : userAgent // ignore: cast_nullable_to_non_nullable
                        as String?,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastActivityAt:
                null == lastActivityAt
                    ? _value.lastActivityAt
                    : lastActivityAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            expiresAt:
                freezed == expiresAt
                    ? _value.expiresAt
                    : expiresAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastKnownLatitude:
                freezed == lastKnownLatitude
                    ? _value.lastKnownLatitude
                    : lastKnownLatitude // ignore: cast_nullable_to_non_nullable
                        as double?,
            lastKnownLongitude:
                freezed == lastKnownLongitude
                    ? _value.lastKnownLongitude
                    : lastKnownLongitude // ignore: cast_nullable_to_non_nullable
                        as double?,
            lastLocationUpdate:
                freezed == lastLocationUpdate
                    ? _value.lastLocationUpdate
                    : lastLocationUpdate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            endedAt:
                freezed == endedAt
                    ? _value.endedAt
                    : endedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endReason:
                freezed == endReason
                    ? _value.endReason
                    : endReason // ignore: cast_nullable_to_non_nullable
                        as SessionEndReason?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeSessionImplCopyWith<$Res>
    implements $EmployeeSessionCopyWith<$Res> {
  factory _$$EmployeeSessionImplCopyWith(
    _$EmployeeSessionImpl value,
    $Res Function(_$EmployeeSessionImpl) then,
  ) = __$$EmployeeSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String employeeId,
    String sessionToken,
    String deviceId,
    String? deviceName,
    DeviceType? deviceType,
    AppType? appType,
    String? appVersion,
    String? ipAddress,
    String? userAgent,
    DateTime startedAt,
    DateTime lastActivityAt,
    DateTime? expiresAt,
    double? lastKnownLatitude,
    double? lastKnownLongitude,
    DateTime? lastLocationUpdate,
    bool isActive,
    DateTime? endedAt,
    SessionEndReason? endReason,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$EmployeeSessionImplCopyWithImpl<$Res>
    extends _$EmployeeSessionCopyWithImpl<$Res, _$EmployeeSessionImpl>
    implements _$$EmployeeSessionImplCopyWith<$Res> {
  __$$EmployeeSessionImplCopyWithImpl(
    _$EmployeeSessionImpl _value,
    $Res Function(_$EmployeeSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? sessionToken = null,
    Object? deviceId = null,
    Object? deviceName = freezed,
    Object? deviceType = freezed,
    Object? appType = freezed,
    Object? appVersion = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? startedAt = null,
    Object? lastActivityAt = null,
    Object? expiresAt = freezed,
    Object? lastKnownLatitude = freezed,
    Object? lastKnownLongitude = freezed,
    Object? lastLocationUpdate = freezed,
    Object? isActive = null,
    Object? endedAt = freezed,
    Object? endReason = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$EmployeeSessionImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        employeeId:
            null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionToken:
            null == sessionToken
                ? _value.sessionToken
                : sessionToken // ignore: cast_nullable_to_non_nullable
                    as String,
        deviceId:
            null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                    as String,
        deviceName:
            freezed == deviceName
                ? _value.deviceName
                : deviceName // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceType:
            freezed == deviceType
                ? _value.deviceType
                : deviceType // ignore: cast_nullable_to_non_nullable
                    as DeviceType?,
        appType:
            freezed == appType
                ? _value.appType
                : appType // ignore: cast_nullable_to_non_nullable
                    as AppType?,
        appVersion:
            freezed == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                    as String?,
        ipAddress:
            freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        userAgent:
            freezed == userAgent
                ? _value.userAgent
                : userAgent // ignore: cast_nullable_to_non_nullable
                    as String?,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastActivityAt:
            null == lastActivityAt
                ? _value.lastActivityAt
                : lastActivityAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        expiresAt:
            freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastKnownLatitude:
            freezed == lastKnownLatitude
                ? _value.lastKnownLatitude
                : lastKnownLatitude // ignore: cast_nullable_to_non_nullable
                    as double?,
        lastKnownLongitude:
            freezed == lastKnownLongitude
                ? _value.lastKnownLongitude
                : lastKnownLongitude // ignore: cast_nullable_to_non_nullable
                    as double?,
        lastLocationUpdate:
            freezed == lastLocationUpdate
                ? _value.lastLocationUpdate
                : lastLocationUpdate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        endedAt:
            freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endReason:
            freezed == endReason
                ? _value.endReason
                : endReason // ignore: cast_nullable_to_non_nullable
                    as SessionEndReason?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeSessionImpl extends _EmployeeSession {
  const _$EmployeeSessionImpl({
    required this.id,
    required this.employeeId,
    required this.sessionToken,
    required this.deviceId,
    this.deviceName,
    this.deviceType,
    this.appType,
    this.appVersion,
    this.ipAddress,
    this.userAgent,
    required this.startedAt,
    required this.lastActivityAt,
    this.expiresAt,
    this.lastKnownLatitude,
    this.lastKnownLongitude,
    this.lastLocationUpdate,
    this.isActive = true,
    this.endedAt,
    this.endReason,
    required this.createdAt,
  }) : super._();

  factory _$EmployeeSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String employeeId;
  // Session Info
  @override
  final String sessionToken;
  @override
  final String deviceId;
  @override
  final String? deviceName;
  @override
  final DeviceType? deviceType;
  @override
  final AppType? appType;
  @override
  final String? appVersion;
  // Network Info
  @override
  final String? ipAddress;
  @override
  final String? userAgent;
  // Activity
  @override
  final DateTime startedAt;
  @override
  final DateTime lastActivityAt;
  @override
  final DateTime? expiresAt;
  // Location tracking (for mobile apps)
  @override
  final double? lastKnownLatitude;
  @override
  final double? lastKnownLongitude;
  @override
  final DateTime? lastLocationUpdate;
  // Status
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? endedAt;
  @override
  final SessionEndReason? endReason;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'EmployeeSession(id: $id, employeeId: $employeeId, sessionToken: $sessionToken, deviceId: $deviceId, deviceName: $deviceName, deviceType: $deviceType, appType: $appType, appVersion: $appVersion, ipAddress: $ipAddress, userAgent: $userAgent, startedAt: $startedAt, lastActivityAt: $lastActivityAt, expiresAt: $expiresAt, lastKnownLatitude: $lastKnownLatitude, lastKnownLongitude: $lastKnownLongitude, lastLocationUpdate: $lastLocationUpdate, isActive: $isActive, endedAt: $endedAt, endReason: $endReason, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.sessionToken, sessionToken) ||
                other.sessionToken == sessionToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.appType, appType) || other.appType == appType) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.lastKnownLatitude, lastKnownLatitude) ||
                other.lastKnownLatitude == lastKnownLatitude) &&
            (identical(other.lastKnownLongitude, lastKnownLongitude) ||
                other.lastKnownLongitude == lastKnownLongitude) &&
            (identical(other.lastLocationUpdate, lastLocationUpdate) ||
                other.lastLocationUpdate == lastLocationUpdate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.endReason, endReason) ||
                other.endReason == endReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    employeeId,
    sessionToken,
    deviceId,
    deviceName,
    deviceType,
    appType,
    appVersion,
    ipAddress,
    userAgent,
    startedAt,
    lastActivityAt,
    expiresAt,
    lastKnownLatitude,
    lastKnownLongitude,
    lastLocationUpdate,
    isActive,
    endedAt,
    endReason,
    createdAt,
  ]);

  /// Create a copy of EmployeeSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeSessionImplCopyWith<_$EmployeeSessionImpl> get copyWith =>
      __$$EmployeeSessionImplCopyWithImpl<_$EmployeeSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeSessionImplToJson(this);
  }
}

abstract class _EmployeeSession extends EmployeeSession {
  const factory _EmployeeSession({
    required final String id,
    required final String employeeId,
    required final String sessionToken,
    required final String deviceId,
    final String? deviceName,
    final DeviceType? deviceType,
    final AppType? appType,
    final String? appVersion,
    final String? ipAddress,
    final String? userAgent,
    required final DateTime startedAt,
    required final DateTime lastActivityAt,
    final DateTime? expiresAt,
    final double? lastKnownLatitude,
    final double? lastKnownLongitude,
    final DateTime? lastLocationUpdate,
    final bool isActive,
    final DateTime? endedAt,
    final SessionEndReason? endReason,
    required final DateTime createdAt,
  }) = _$EmployeeSessionImpl;
  const _EmployeeSession._() : super._();

  factory _EmployeeSession.fromJson(Map<String, dynamic> json) =
      _$EmployeeSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get employeeId; // Session Info
  @override
  String get sessionToken;
  @override
  String get deviceId;
  @override
  String? get deviceName;
  @override
  DeviceType? get deviceType;
  @override
  AppType? get appType;
  @override
  String? get appVersion; // Network Info
  @override
  String? get ipAddress;
  @override
  String? get userAgent; // Activity
  @override
  DateTime get startedAt;
  @override
  DateTime get lastActivityAt;
  @override
  DateTime? get expiresAt; // Location tracking (for mobile apps)
  @override
  double? get lastKnownLatitude;
  @override
  double? get lastKnownLongitude;
  @override
  DateTime? get lastLocationUpdate; // Status
  @override
  bool get isActive;
  @override
  DateTime? get endedAt;
  @override
  SessionEndReason? get endReason;
  @override
  DateTime get createdAt;

  /// Create a copy of EmployeeSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeSessionImplCopyWith<_$EmployeeSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
