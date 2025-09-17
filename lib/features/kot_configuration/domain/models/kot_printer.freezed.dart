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
  String get printerType =>
      throw _privateConstructorUsedError; // network, bluetooth, usb
  String? get ipAddress => throw _privateConstructorUsedError;
  String? get port => throw _privateConstructorUsedError;
  String? get macAddress => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  int get printCopies => throw _privateConstructorUsedError;
  String get paperSize => throw _privateConstructorUsedError; // 58mm, 80mm
  bool get autoCut => throw _privateConstructorUsedError;
  bool get cashDrawer => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
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
    String printerType,
    String? ipAddress,
    String? port,
    String? macAddress,
    String? deviceName,
    bool isActive,
    bool isDefault,
    int printCopies,
    String paperSize,
    bool autoCut,
    bool cashDrawer,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? printerType = null,
    Object? ipAddress = freezed,
    Object? port = freezed,
    Object? macAddress = freezed,
    Object? deviceName = freezed,
    Object? isActive = null,
    Object? isDefault = null,
    Object? printCopies = null,
    Object? paperSize = null,
    Object? autoCut = null,
    Object? cashDrawer = null,
    Object? notes = freezed,
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
            printerType:
                null == printerType
                    ? _value.printerType
                    : printerType // ignore: cast_nullable_to_non_nullable
                        as String,
            ipAddress:
                freezed == ipAddress
                    ? _value.ipAddress
                    : ipAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            port:
                freezed == port
                    ? _value.port
                    : port // ignore: cast_nullable_to_non_nullable
                        as String?,
            macAddress:
                freezed == macAddress
                    ? _value.macAddress
                    : macAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            deviceName:
                freezed == deviceName
                    ? _value.deviceName
                    : deviceName // ignore: cast_nullable_to_non_nullable
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
            printCopies:
                null == printCopies
                    ? _value.printCopies
                    : printCopies // ignore: cast_nullable_to_non_nullable
                        as int,
            paperSize:
                null == paperSize
                    ? _value.paperSize
                    : paperSize // ignore: cast_nullable_to_non_nullable
                        as String,
            autoCut:
                null == autoCut
                    ? _value.autoCut
                    : autoCut // ignore: cast_nullable_to_non_nullable
                        as bool,
            cashDrawer:
                null == cashDrawer
                    ? _value.cashDrawer
                    : cashDrawer // ignore: cast_nullable_to_non_nullable
                        as bool,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
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
    String printerType,
    String? ipAddress,
    String? port,
    String? macAddress,
    String? deviceName,
    bool isActive,
    bool isDefault,
    int printCopies,
    String paperSize,
    bool autoCut,
    bool cashDrawer,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    Object? printerType = null,
    Object? ipAddress = freezed,
    Object? port = freezed,
    Object? macAddress = freezed,
    Object? deviceName = freezed,
    Object? isActive = null,
    Object? isDefault = null,
    Object? printCopies = null,
    Object? paperSize = null,
    Object? autoCut = null,
    Object? cashDrawer = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
        printerType:
            null == printerType
                ? _value.printerType
                : printerType // ignore: cast_nullable_to_non_nullable
                    as String,
        ipAddress:
            freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        port:
            freezed == port
                ? _value.port
                : port // ignore: cast_nullable_to_non_nullable
                    as String?,
        macAddress:
            freezed == macAddress
                ? _value.macAddress
                : macAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        deviceName:
            freezed == deviceName
                ? _value.deviceName
                : deviceName // ignore: cast_nullable_to_non_nullable
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
        printCopies:
            null == printCopies
                ? _value.printCopies
                : printCopies // ignore: cast_nullable_to_non_nullable
                    as int,
        paperSize:
            null == paperSize
                ? _value.paperSize
                : paperSize // ignore: cast_nullable_to_non_nullable
                    as String,
        autoCut:
            null == autoCut
                ? _value.autoCut
                : autoCut // ignore: cast_nullable_to_non_nullable
                    as bool,
        cashDrawer:
            null == cashDrawer
                ? _value.cashDrawer
                : cashDrawer // ignore: cast_nullable_to_non_nullable
                    as bool,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
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
class _$KotPrinterImpl implements _KotPrinter {
  const _$KotPrinterImpl({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.name,
    required this.printerType,
    this.ipAddress,
    this.port,
    this.macAddress,
    this.deviceName,
    required this.isActive,
    required this.isDefault,
    required this.printCopies,
    required this.paperSize,
    required this.autoCut,
    required this.cashDrawer,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.hasUnsyncedChanges = false,
  });

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
  final String printerType;
  // network, bluetooth, usb
  @override
  final String? ipAddress;
  @override
  final String? port;
  @override
  final String? macAddress;
  @override
  final String? deviceName;
  @override
  final bool isActive;
  @override
  final bool isDefault;
  @override
  final int printCopies;
  @override
  final String paperSize;
  // 58mm, 80mm
  @override
  final bool autoCut;
  @override
  final bool cashDrawer;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'KotPrinter(id: $id, businessId: $businessId, locationId: $locationId, name: $name, printerType: $printerType, ipAddress: $ipAddress, port: $port, macAddress: $macAddress, deviceName: $deviceName, isActive: $isActive, isDefault: $isDefault, printCopies: $printCopies, paperSize: $paperSize, autoCut: $autoCut, cashDrawer: $cashDrawer, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
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
            (identical(other.printerType, printerType) ||
                other.printerType == printerType) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.printCopies, printCopies) ||
                other.printCopies == printCopies) &&
            (identical(other.paperSize, paperSize) ||
                other.paperSize == paperSize) &&
            (identical(other.autoCut, autoCut) || other.autoCut == autoCut) &&
            (identical(other.cashDrawer, cashDrawer) ||
                other.cashDrawer == cashDrawer) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
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
    name,
    printerType,
    ipAddress,
    port,
    macAddress,
    deviceName,
    isActive,
    isDefault,
    printCopies,
    paperSize,
    autoCut,
    cashDrawer,
    notes,
    createdAt,
    updatedAt,
    hasUnsyncedChanges,
  ]);

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

abstract class _KotPrinter implements KotPrinter {
  const factory _KotPrinter({
    required final String id,
    required final String businessId,
    required final String locationId,
    required final String name,
    required final String printerType,
    final String? ipAddress,
    final String? port,
    final String? macAddress,
    final String? deviceName,
    required final bool isActive,
    required final bool isDefault,
    required final int printCopies,
    required final String paperSize,
    required final bool autoCut,
    required final bool cashDrawer,
    final String? notes,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final bool hasUnsyncedChanges,
  }) = _$KotPrinterImpl;

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
  String get printerType; // network, bluetooth, usb
  @override
  String? get ipAddress;
  @override
  String? get port;
  @override
  String? get macAddress;
  @override
  String? get deviceName;
  @override
  bool get isActive;
  @override
  bool get isDefault;
  @override
  int get printCopies;
  @override
  String get paperSize; // 58mm, 80mm
  @override
  bool get autoCut;
  @override
  bool get cashDrawer;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of KotPrinter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotPrinterImplCopyWith<_$KotPrinterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
