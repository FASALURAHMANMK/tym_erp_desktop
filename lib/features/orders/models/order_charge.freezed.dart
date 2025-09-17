// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_charge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderCharge _$OrderChargeFromJson(Map<String, dynamic> json) {
  return _OrderCharge.fromJson(json);
}

/// @nodoc
mixin _$OrderCharge {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String? get chargeId =>
      throw _privateConstructorUsedError; // Reference to charges table (null for manual charges)
  String get chargeCode => throw _privateConstructorUsedError;
  String get chargeName => throw _privateConstructorUsedError;
  String get chargeType =>
      throw _privateConstructorUsedError; // service, delivery, packaging, custom, etc.
  String get calculationType =>
      throw _privateConstructorUsedError; // fixed, percentage, tiered, formula
  double get baseAmount =>
      throw _privateConstructorUsedError; // Amount on which charge was calculated
  double get chargeRate =>
      throw _privateConstructorUsedError; // Rate or percentage value
  double get chargeAmount =>
      throw _privateConstructorUsedError; // Calculated charge amount
  bool get isTaxable => throw _privateConstructorUsedError;
  bool get isManual =>
      throw _privateConstructorUsedError; // True for manually added charges
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderCharge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderCharge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderChargeCopyWith<OrderCharge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderChargeCopyWith<$Res> {
  factory $OrderChargeCopyWith(
    OrderCharge value,
    $Res Function(OrderCharge) then,
  ) = _$OrderChargeCopyWithImpl<$Res, OrderCharge>;
  @useResult
  $Res call({
    String id,
    String orderId,
    String? chargeId,
    String chargeCode,
    String chargeName,
    String chargeType,
    String calculationType,
    double baseAmount,
    double chargeRate,
    double chargeAmount,
    bool isTaxable,
    bool isManual,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$OrderChargeCopyWithImpl<$Res, $Val extends OrderCharge>
    implements $OrderChargeCopyWith<$Res> {
  _$OrderChargeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCharge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? chargeId = freezed,
    Object? chargeCode = null,
    Object? chargeName = null,
    Object? chargeType = null,
    Object? calculationType = null,
    Object? baseAmount = null,
    Object? chargeRate = null,
    Object? chargeAmount = null,
    Object? isTaxable = null,
    Object? isManual = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
            chargeId:
                freezed == chargeId
                    ? _value.chargeId
                    : chargeId // ignore: cast_nullable_to_non_nullable
                        as String?,
            chargeCode:
                null == chargeCode
                    ? _value.chargeCode
                    : chargeCode // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeName:
                null == chargeName
                    ? _value.chargeName
                    : chargeName // ignore: cast_nullable_to_non_nullable
                        as String,
            chargeType:
                null == chargeType
                    ? _value.chargeType
                    : chargeType // ignore: cast_nullable_to_non_nullable
                        as String,
            calculationType:
                null == calculationType
                    ? _value.calculationType
                    : calculationType // ignore: cast_nullable_to_non_nullable
                        as String,
            baseAmount:
                null == baseAmount
                    ? _value.baseAmount
                    : baseAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            chargeRate:
                null == chargeRate
                    ? _value.chargeRate
                    : chargeRate // ignore: cast_nullable_to_non_nullable
                        as double,
            chargeAmount:
                null == chargeAmount
                    ? _value.chargeAmount
                    : chargeAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            isTaxable:
                null == isTaxable
                    ? _value.isTaxable
                    : isTaxable // ignore: cast_nullable_to_non_nullable
                        as bool,
            isManual:
                null == isManual
                    ? _value.isManual
                    : isManual // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderChargeImplCopyWith<$Res>
    implements $OrderChargeCopyWith<$Res> {
  factory _$$OrderChargeImplCopyWith(
    _$OrderChargeImpl value,
    $Res Function(_$OrderChargeImpl) then,
  ) = __$$OrderChargeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    String? chargeId,
    String chargeCode,
    String chargeName,
    String chargeType,
    String calculationType,
    double baseAmount,
    double chargeRate,
    double chargeAmount,
    bool isTaxable,
    bool isManual,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$OrderChargeImplCopyWithImpl<$Res>
    extends _$OrderChargeCopyWithImpl<$Res, _$OrderChargeImpl>
    implements _$$OrderChargeImplCopyWith<$Res> {
  __$$OrderChargeImplCopyWithImpl(
    _$OrderChargeImpl _value,
    $Res Function(_$OrderChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderCharge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? chargeId = freezed,
    Object? chargeCode = null,
    Object? chargeName = null,
    Object? chargeType = null,
    Object? calculationType = null,
    Object? baseAmount = null,
    Object? chargeRate = null,
    Object? chargeAmount = null,
    Object? isTaxable = null,
    Object? isManual = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$OrderChargeImpl(
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
        chargeId:
            freezed == chargeId
                ? _value.chargeId
                : chargeId // ignore: cast_nullable_to_non_nullable
                    as String?,
        chargeCode:
            null == chargeCode
                ? _value.chargeCode
                : chargeCode // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeName:
            null == chargeName
                ? _value.chargeName
                : chargeName // ignore: cast_nullable_to_non_nullable
                    as String,
        chargeType:
            null == chargeType
                ? _value.chargeType
                : chargeType // ignore: cast_nullable_to_non_nullable
                    as String,
        calculationType:
            null == calculationType
                ? _value.calculationType
                : calculationType // ignore: cast_nullable_to_non_nullable
                    as String,
        baseAmount:
            null == baseAmount
                ? _value.baseAmount
                : baseAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        chargeRate:
            null == chargeRate
                ? _value.chargeRate
                : chargeRate // ignore: cast_nullable_to_non_nullable
                    as double,
        chargeAmount:
            null == chargeAmount
                ? _value.chargeAmount
                : chargeAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        isTaxable:
            null == isTaxable
                ? _value.isTaxable
                : isTaxable // ignore: cast_nullable_to_non_nullable
                    as bool,
        isManual:
            null == isManual
                ? _value.isManual
                : isManual // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderChargeImpl implements _OrderCharge {
  const _$OrderChargeImpl({
    required this.id,
    required this.orderId,
    this.chargeId,
    required this.chargeCode,
    required this.chargeName,
    required this.chargeType,
    required this.calculationType,
    required this.baseAmount,
    required this.chargeRate,
    required this.chargeAmount,
    this.isTaxable = false,
    this.isManual = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory _$OrderChargeImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderChargeImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final String? chargeId;
  // Reference to charges table (null for manual charges)
  @override
  final String chargeCode;
  @override
  final String chargeName;
  @override
  final String chargeType;
  // service, delivery, packaging, custom, etc.
  @override
  final String calculationType;
  // fixed, percentage, tiered, formula
  @override
  final double baseAmount;
  // Amount on which charge was calculated
  @override
  final double chargeRate;
  // Rate or percentage value
  @override
  final double chargeAmount;
  // Calculated charge amount
  @override
  @JsonKey()
  final bool isTaxable;
  @override
  @JsonKey()
  final bool isManual;
  // True for manually added charges
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'OrderCharge(id: $id, orderId: $orderId, chargeId: $chargeId, chargeCode: $chargeCode, chargeName: $chargeName, chargeType: $chargeType, calculationType: $calculationType, baseAmount: $baseAmount, chargeRate: $chargeRate, chargeAmount: $chargeAmount, isTaxable: $isTaxable, isManual: $isManual, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderChargeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.chargeId, chargeId) ||
                other.chargeId == chargeId) &&
            (identical(other.chargeCode, chargeCode) ||
                other.chargeCode == chargeCode) &&
            (identical(other.chargeName, chargeName) ||
                other.chargeName == chargeName) &&
            (identical(other.chargeType, chargeType) ||
                other.chargeType == chargeType) &&
            (identical(other.calculationType, calculationType) ||
                other.calculationType == calculationType) &&
            (identical(other.baseAmount, baseAmount) ||
                other.baseAmount == baseAmount) &&
            (identical(other.chargeRate, chargeRate) ||
                other.chargeRate == chargeRate) &&
            (identical(other.chargeAmount, chargeAmount) ||
                other.chargeAmount == chargeAmount) &&
            (identical(other.isTaxable, isTaxable) ||
                other.isTaxable == isTaxable) &&
            (identical(other.isManual, isManual) ||
                other.isManual == isManual) &&
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
    orderId,
    chargeId,
    chargeCode,
    chargeName,
    chargeType,
    calculationType,
    baseAmount,
    chargeRate,
    chargeAmount,
    isTaxable,
    isManual,
    createdAt,
    updatedAt,
  );

  /// Create a copy of OrderCharge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderChargeImplCopyWith<_$OrderChargeImpl> get copyWith =>
      __$$OrderChargeImplCopyWithImpl<_$OrderChargeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderChargeImplToJson(this);
  }
}

abstract class _OrderCharge implements OrderCharge {
  const factory _OrderCharge({
    required final String id,
    required final String orderId,
    final String? chargeId,
    required final String chargeCode,
    required final String chargeName,
    required final String chargeType,
    required final String calculationType,
    required final double baseAmount,
    required final double chargeRate,
    required final double chargeAmount,
    final bool isTaxable,
    final bool isManual,
    required final DateTime createdAt,
    final DateTime? updatedAt,
  }) = _$OrderChargeImpl;

  factory _OrderCharge.fromJson(Map<String, dynamic> json) =
      _$OrderChargeImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String? get chargeId; // Reference to charges table (null for manual charges)
  @override
  String get chargeCode;
  @override
  String get chargeName;
  @override
  String get chargeType; // service, delivery, packaging, custom, etc.
  @override
  String get calculationType; // fixed, percentage, tiered, formula
  @override
  double get baseAmount; // Amount on which charge was calculated
  @override
  double get chargeRate; // Rate or percentage value
  @override
  double get chargeAmount; // Calculated charge amount
  @override
  bool get isTaxable;
  @override
  bool get isManual; // True for manually added charges
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of OrderCharge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderChargeImplCopyWith<_$OrderChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
