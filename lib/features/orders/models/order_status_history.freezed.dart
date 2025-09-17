// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_status_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderStatusHistory _$OrderStatusHistoryFromJson(Map<String, dynamic> json) {
  return _OrderStatusHistory.fromJson(json);
}

/// @nodoc
mixin _$OrderStatusHistory {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError; // Status Change
  OrderStatus get fromStatus => throw _privateConstructorUsedError;
  OrderStatus get toStatus =>
      throw _privateConstructorUsedError; // Who made the change
  String get changedBy => throw _privateConstructorUsedError; // User ID
  String get changedByName => throw _privateConstructorUsedError; // Snapshot
  String? get changedByRole =>
      throw _privateConstructorUsedError; // Staff role at time of change
  // When
  DateTime get changedAt =>
      throw _privateConstructorUsedError; // Why (optional)
  String? get reason => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Additional context
  String? get deviceId => throw _privateConstructorUsedError;
  String? get ipAddress => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this OrderStatusHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderStatusHistoryCopyWith<OrderStatusHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusHistoryCopyWith<$Res> {
  factory $OrderStatusHistoryCopyWith(
    OrderStatusHistory value,
    $Res Function(OrderStatusHistory) then,
  ) = _$OrderStatusHistoryCopyWithImpl<$Res, OrderStatusHistory>;
  @useResult
  $Res call({
    String id,
    String orderId,
    OrderStatus fromStatus,
    OrderStatus toStatus,
    String changedBy,
    String changedByName,
    String? changedByRole,
    DateTime changedAt,
    String? reason,
    String? notes,
    String? deviceId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$OrderStatusHistoryCopyWithImpl<$Res, $Val extends OrderStatusHistory>
    implements $OrderStatusHistoryCopyWith<$Res> {
  _$OrderStatusHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? changedBy = null,
    Object? changedByName = null,
    Object? changedByRole = freezed,
    Object? changedAt = null,
    Object? reason = freezed,
    Object? notes = freezed,
    Object? deviceId = freezed,
    Object? ipAddress = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            orderId:
                null == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String,
            fromStatus:
                null == fromStatus
                    ? _value.fromStatus
                    : fromStatus // ignore: cast_nullable_to_non_nullable
                        as OrderStatus,
            toStatus:
                null == toStatus
                    ? _value.toStatus
                    : toStatus // ignore: cast_nullable_to_non_nullable
                        as OrderStatus,
            changedBy:
                null == changedBy
                    ? _value.changedBy
                    : changedBy // ignore: cast_nullable_to_non_nullable
                        as String,
            changedByName:
                null == changedByName
                    ? _value.changedByName
                    : changedByName // ignore: cast_nullable_to_non_nullable
                        as String,
            changedByRole:
                freezed == changedByRole
                    ? _value.changedByRole
                    : changedByRole // ignore: cast_nullable_to_non_nullable
                        as String?,
            changedAt:
                null == changedAt
                    ? _value.changedAt
                    : changedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            reason:
                freezed == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceId:
                freezed == deviceId
                    ? _value.deviceId
                    : deviceId // ignore: cast_nullable_to_non_nullable
                        as String?,
            ipAddress:
                freezed == ipAddress
                    ? _value.ipAddress
                    : ipAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderStatusHistoryImplCopyWith<$Res>
    implements $OrderStatusHistoryCopyWith<$Res> {
  factory _$$OrderStatusHistoryImplCopyWith(
    _$OrderStatusHistoryImpl value,
    $Res Function(_$OrderStatusHistoryImpl) then,
  ) = __$$OrderStatusHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    OrderStatus fromStatus,
    OrderStatus toStatus,
    String changedBy,
    String changedByName,
    String? changedByRole,
    DateTime changedAt,
    String? reason,
    String? notes,
    String? deviceId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$OrderStatusHistoryImplCopyWithImpl<$Res>
    extends _$OrderStatusHistoryCopyWithImpl<$Res, _$OrderStatusHistoryImpl>
    implements _$$OrderStatusHistoryImplCopyWith<$Res> {
  __$$OrderStatusHistoryImplCopyWithImpl(
    _$OrderStatusHistoryImpl _value,
    $Res Function(_$OrderStatusHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? changedBy = null,
    Object? changedByName = null,
    Object? changedByRole = freezed,
    Object? changedAt = null,
    Object? reason = freezed,
    Object? notes = freezed,
    Object? deviceId = freezed,
    Object? ipAddress = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$OrderStatusHistoryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        orderId:
            null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String,
        fromStatus:
            null == fromStatus
                ? _value.fromStatus
                : fromStatus // ignore: cast_nullable_to_non_nullable
                    as OrderStatus,
        toStatus:
            null == toStatus
                ? _value.toStatus
                : toStatus // ignore: cast_nullable_to_non_nullable
                    as OrderStatus,
        changedBy:
            null == changedBy
                ? _value.changedBy
                : changedBy // ignore: cast_nullable_to_non_nullable
                    as String,
        changedByName:
            null == changedByName
                ? _value.changedByName
                : changedByName // ignore: cast_nullable_to_non_nullable
                    as String,
        changedByRole:
            freezed == changedByRole
                ? _value.changedByRole
                : changedByRole // ignore: cast_nullable_to_non_nullable
                    as String?,
        changedAt:
            null == changedAt
                ? _value.changedAt
                : changedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        reason:
            freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceId:
            freezed == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                    as String?,
        ipAddress:
            freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderStatusHistoryImpl extends _OrderStatusHistory {
  const _$OrderStatusHistoryImpl({
    required this.id,
    required this.orderId,
    required this.fromStatus,
    required this.toStatus,
    required this.changedBy,
    required this.changedByName,
    this.changedByRole,
    required this.changedAt,
    this.reason,
    this.notes,
    this.deviceId,
    this.ipAddress,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata,
       super._();

  factory _$OrderStatusHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderStatusHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  // Status Change
  @override
  final OrderStatus fromStatus;
  @override
  final OrderStatus toStatus;
  // Who made the change
  @override
  final String changedBy;
  // User ID
  @override
  final String changedByName;
  // Snapshot
  @override
  final String? changedByRole;
  // Staff role at time of change
  // When
  @override
  final DateTime changedAt;
  // Why (optional)
  @override
  final String? reason;
  @override
  final String? notes;
  // Additional context
  @override
  final String? deviceId;
  @override
  final String? ipAddress;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'OrderStatusHistory(id: $id, orderId: $orderId, fromStatus: $fromStatus, toStatus: $toStatus, changedBy: $changedBy, changedByName: $changedByName, changedByRole: $changedByRole, changedAt: $changedAt, reason: $reason, notes: $notes, deviceId: $deviceId, ipAddress: $ipAddress, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderStatusHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.fromStatus, fromStatus) ||
                other.fromStatus == fromStatus) &&
            (identical(other.toStatus, toStatus) ||
                other.toStatus == toStatus) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.changedByName, changedByName) ||
                other.changedByName == changedByName) &&
            (identical(other.changedByRole, changedByRole) ||
                other.changedByRole == changedByRole) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    fromStatus,
    toStatus,
    changedBy,
    changedByName,
    changedByRole,
    changedAt,
    reason,
    notes,
    deviceId,
    ipAddress,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      __$$OrderStatusHistoryImplCopyWithImpl<_$OrderStatusHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderStatusHistoryImplToJson(this);
  }
}

abstract class _OrderStatusHistory extends OrderStatusHistory {
  const factory _OrderStatusHistory({
    required final String id,
    required final String orderId,
    required final OrderStatus fromStatus,
    required final OrderStatus toStatus,
    required final String changedBy,
    required final String changedByName,
    final String? changedByRole,
    required final DateTime changedAt,
    final String? reason,
    final String? notes,
    final String? deviceId,
    final String? ipAddress,
    final Map<String, dynamic>? metadata,
  }) = _$OrderStatusHistoryImpl;
  const _OrderStatusHistory._() : super._();

  factory _OrderStatusHistory.fromJson(Map<String, dynamic> json) =
      _$OrderStatusHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId; // Status Change
  @override
  OrderStatus get fromStatus;
  @override
  OrderStatus get toStatus; // Who made the change
  @override
  String get changedBy; // User ID
  @override
  String get changedByName; // Snapshot
  @override
  String? get changedByRole; // Staff role at time of change
  // When
  @override
  DateTime get changedAt; // Why (optional)
  @override
  String? get reason;
  @override
  String? get notes; // Additional context
  @override
  String? get deviceId;
  @override
  String? get ipAddress;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of OrderStatusHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderStatusHistoryImplCopyWith<_$OrderStatusHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
