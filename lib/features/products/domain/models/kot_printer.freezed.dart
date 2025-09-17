// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kot_printer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KotPrinter _$KotPrinterFromJson(Map<String, dynamic> json) {
  return _KotPrinter.fromJson(json);
}

/// @nodoc
mixin _$KotPrinter {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  PrinterType get type => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError; // Sync fields
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this KotPrinter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KotPrinter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KotPrinterCopyWith<KotPrinter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KotPrinterCopyWith<$Res> {
  factory $KotPrinterCopyWith(
    KotPrinter value,
    $Res Function(KotPrinter) then,
  ) = _$KotPrinterCopyWithImpl<$Res, KotPrinter>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String ipAddress,
    int port,
    PrinterType type,
    String? description,
    bool isActive,
    bool isDefault,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$KotPrinterCopyWithImpl<$Res, $Val extends KotPrinter>
    implements $KotPrinterCopyWith<$Res> {
  _$KotPrinterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KotPrinter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? type = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? isDefault = null,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            ipAddress:
                null == ipAddress
                    ? _value.ipAddress
                    : ipAddress // ignore: cast_nullable_to_non_nullable
                        as String,
            port:
                null == port
                    ? _value.port
                    : port // ignore: cast_nullable_to_non_nullable
                        as int,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as PrinterType,
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
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
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
abstract class _$$KotPrinterImplCopyWith<$Res>
    implements $KotPrinterCopyWith<$Res> {
  factory _$$KotPrinterImplCopyWith(
    _$KotPrinterImpl value,
    $Res Function(_$KotPrinterImpl) then,
  ) = __$$KotPrinterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String locationId,
    String name,
    String ipAddress,
    int port,
    PrinterType type,
    String? description,
    bool isActive,
    bool isDefault,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$KotPrinterImplCopyWithImpl<$Res>
    extends _$KotPrinterCopyWithImpl<$Res, _$KotPrinterImpl>
    implements _$$KotPrinterImplCopyWith<$Res> {
  __$$KotPrinterImplCopyWithImpl(
    _$KotPrinterImpl _value,
    $Res Function(_$KotPrinterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KotPrinter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? locationId = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? type = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$KotPrinterImpl(
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
        ipAddress:
            null == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                    as String,
        port:
            null == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                    as int,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as PrinterType,
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
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
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
class _$KotPrinterImpl extends _KotPrinter {
  const _$KotPrinterImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.name,
    required this.ipAddress,
    this.port = 9100,
    this.type = PrinterType.network,
    this.description,
    this.isActive = true,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$KotPrinterImpl.fromJson(Map<String, dynamic> json) =>
      _$$KotPrinterImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String locationId;
  @override
  final String name;
  @override
  final String ipAddress;
  @override
  @JsonKey()
  final int port;
  @override
  @JsonKey()
  final PrinterType type;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isDefault;
  // Sync fields
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
    return 'KotPrinter(id: $id, businessId: $businessId, locationId: $locationId, name: $name, ipAddress: $ipAddress, port: $port, type: $type, description: $description, isActive: $isActive, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KotPrinterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
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
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    locationId,
    name,
    ipAddress,
    port,
    type,
    description,
    isActive,
    isDefault,
    createdAt,
    updatedAt,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of KotPrinter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KotPrinterImplCopyWith<_$KotPrinterImpl> get copyWith =>
      __$$KotPrinterImplCopyWithImpl<_$KotPrinterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KotPrinterImplToJson(this);
  }
}

abstract class _KotPrinter extends KotPrinter {
  const factory _KotPrinter({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String name,
    required final String ipAddress,
    final int port,
    final PrinterType type,
    final String? description,
    final bool isActive,
    final bool isDefault,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$KotPrinterImpl;
  const _KotPrinter._() : super._();

  factory _KotPrinter.fromJson(Map<String, dynamic> json) =
      _$KotPrinterImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get locationId;
  @override
  String get name;
  @override
  String get ipAddress;
  @override
  int get port;
  @override
  PrinterType get type;
  @override
  String? get description;
  @override
  bool get isActive;
  @override
  bool get isDefault; // Sync fields
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of KotPrinter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotPrinterImplCopyWith<_$KotPrinterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
