// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_price_override.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TablePriceOverride _$TablePriceOverrideFromJson(Map<String, dynamic> json) {
  return _TablePriceOverride.fromJson(json);
}

/// @nodoc
mixin _$TablePriceOverride {
  String get id => throw _privateConstructorUsedError;
  String get tableId => throw _privateConstructorUsedError;
  String get variationId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get validFrom => throw _privateConstructorUsedError;
  DateTime? get validUntil => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this TablePriceOverride to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TablePriceOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TablePriceOverrideCopyWith<TablePriceOverride> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TablePriceOverrideCopyWith<$Res> {
  factory $TablePriceOverrideCopyWith(
    TablePriceOverride value,
    $Res Function(TablePriceOverride) then,
  ) = _$TablePriceOverrideCopyWithImpl<$Res, TablePriceOverride>;
  @useResult
  $Res call({
    String id,
    String tableId,
    String variationId,
    double price,
    bool isActive,
    DateTime? validFrom,
    DateTime? validUntil,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$TablePriceOverrideCopyWithImpl<$Res, $Val extends TablePriceOverride>
    implements $TablePriceOverrideCopyWith<$Res> {
  _$TablePriceOverrideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TablePriceOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableId = null,
    Object? variationId = null,
    Object? price = null,
    Object? isActive = null,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
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
            tableId:
                null == tableId
                    ? _value.tableId
                    : tableId // ignore: cast_nullable_to_non_nullable
                        as String,
            variationId:
                null == variationId
                    ? _value.variationId
                    : variationId // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            validFrom:
                freezed == validFrom
                    ? _value.validFrom
                    : validFrom // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            validUntil:
                freezed == validUntil
                    ? _value.validUntil
                    : validUntil // ignore: cast_nullable_to_non_nullable
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
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$TablePriceOverrideImplCopyWith<$Res>
    implements $TablePriceOverrideCopyWith<$Res> {
  factory _$$TablePriceOverrideImplCopyWith(
    _$TablePriceOverrideImpl value,
    $Res Function(_$TablePriceOverrideImpl) then,
  ) = __$$TablePriceOverrideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tableId,
    String variationId,
    double price,
    bool isActive,
    DateTime? validFrom,
    DateTime? validUntil,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$TablePriceOverrideImplCopyWithImpl<$Res>
    extends _$TablePriceOverrideCopyWithImpl<$Res, _$TablePriceOverrideImpl>
    implements _$$TablePriceOverrideImplCopyWith<$Res> {
  __$$TablePriceOverrideImplCopyWithImpl(
    _$TablePriceOverrideImpl _value,
    $Res Function(_$TablePriceOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TablePriceOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableId = null,
    Object? variationId = null,
    Object? price = null,
    Object? isActive = null,
    Object? validFrom = freezed,
    Object? validUntil = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? lastSyncedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$TablePriceOverrideImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        tableId:
            null == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                    as String,
        variationId:
            null == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        validFrom:
            freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        validUntil:
            freezed == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
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
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$TablePriceOverrideImpl extends _TablePriceOverride {
  const _$TablePriceOverrideImpl({
    required this.id,
    required this.tableId,
    required this.variationId,
    required this.price,
    this.isActive = true,
    this.validFrom,
    this.validUntil,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.lastSyncedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$TablePriceOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$TablePriceOverrideImplFromJson(json);

  @override
  final String id;
  @override
  final String tableId;
  @override
  final String variationId;
  @override
  final double price;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? validFrom;
  @override
  final DateTime? validUntil;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;
  @override
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'TablePriceOverride(id: $id, tableId: $tableId, variationId: $variationId, price: $price, isActive: $isActive, validFrom: $validFrom, validUntil: $validUntil, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastSyncedAt: $lastSyncedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TablePriceOverrideImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
    tableId,
    variationId,
    price,
    isActive,
    validFrom,
    validUntil,
    createdAt,
    updatedAt,
    createdBy,
    lastSyncedAt,
    hasUnsyncedChanges,
  );

  /// Create a copy of TablePriceOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TablePriceOverrideImplCopyWith<_$TablePriceOverrideImpl> get copyWith =>
      __$$TablePriceOverrideImplCopyWithImpl<_$TablePriceOverrideImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TablePriceOverrideImplToJson(this);
  }
}

abstract class _TablePriceOverride extends TablePriceOverride {
  const factory _TablePriceOverride({
    required final String id,
    required final String tableId,
    required final String variationId,
    required final double price,
    final bool isActive,
    final DateTime? validFrom,
    final DateTime? validUntil,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
    final DateTime? lastSyncedAt,
    final bool hasUnsyncedChanges,
  }) = _$TablePriceOverrideImpl;
  const _TablePriceOverride._() : super._();

  factory _TablePriceOverride.fromJson(Map<String, dynamic> json) =
      _$TablePriceOverrideImpl.fromJson;

  @override
  String get id;
  @override
  String get tableId;
  @override
  String get variationId;
  @override
  double get price;
  @override
  bool get isActive;
  @override
  DateTime? get validFrom;
  @override
  DateTime? get validUntil;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;
  @override
  DateTime? get lastSyncedAt;
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of TablePriceOverride
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TablePriceOverrideImplCopyWith<_$TablePriceOverrideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
