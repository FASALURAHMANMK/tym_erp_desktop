// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'applied_item_discount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppliedItemDiscount _$AppliedItemDiscountFromJson(Map<String, dynamic> json) {
  return _AppliedItemDiscount.fromJson(json);
}

/// @nodoc
mixin _$AppliedItemDiscount {
  String get discountId => throw _privateConstructorUsedError;
  String get discountName => throw _privateConstructorUsedError;
  DiscountType get type => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get calculatedAmount =>
      throw _privateConstructorUsedError; // The actual discount amount for this item
  bool get isAutoApplied => throw _privateConstructorUsedError;
  String? get reason =>
      throw _privateConstructorUsedError; // Reason for manual discount
  DateTime get appliedAt => throw _privateConstructorUsedError;

  /// Serializes this AppliedItemDiscount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppliedItemDiscount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppliedItemDiscountCopyWith<AppliedItemDiscount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppliedItemDiscountCopyWith<$Res> {
  factory $AppliedItemDiscountCopyWith(
    AppliedItemDiscount value,
    $Res Function(AppliedItemDiscount) then,
  ) = _$AppliedItemDiscountCopyWithImpl<$Res, AppliedItemDiscount>;
  @useResult
  $Res call({
    String discountId,
    String discountName,
    DiscountType type,
    double value,
    double calculatedAmount,
    bool isAutoApplied,
    String? reason,
    DateTime appliedAt,
  });
}

/// @nodoc
class _$AppliedItemDiscountCopyWithImpl<$Res, $Val extends AppliedItemDiscount>
    implements $AppliedItemDiscountCopyWith<$Res> {
  _$AppliedItemDiscountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppliedItemDiscount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountId = null,
    Object? discountName = null,
    Object? type = null,
    Object? value = null,
    Object? calculatedAmount = null,
    Object? isAutoApplied = null,
    Object? reason = freezed,
    Object? appliedAt = null,
  }) {
    return _then(
      _value.copyWith(
            discountId:
                null == discountId
                    ? _value.discountId
                    : discountId // ignore: cast_nullable_to_non_nullable
                        as String,
            discountName:
                null == discountName
                    ? _value.discountName
                    : discountName // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as DiscountType,
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
            calculatedAmount:
                null == calculatedAmount
                    ? _value.calculatedAmount
                    : calculatedAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            isAutoApplied:
                null == isAutoApplied
                    ? _value.isAutoApplied
                    : isAutoApplied // ignore: cast_nullable_to_non_nullable
                        as bool,
            reason:
                freezed == reason
                    ? _value.reason
                    : reason // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedAt:
                null == appliedAt
                    ? _value.appliedAt
                    : appliedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppliedItemDiscountImplCopyWith<$Res>
    implements $AppliedItemDiscountCopyWith<$Res> {
  factory _$$AppliedItemDiscountImplCopyWith(
    _$AppliedItemDiscountImpl value,
    $Res Function(_$AppliedItemDiscountImpl) then,
  ) = __$$AppliedItemDiscountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String discountId,
    String discountName,
    DiscountType type,
    double value,
    double calculatedAmount,
    bool isAutoApplied,
    String? reason,
    DateTime appliedAt,
  });
}

/// @nodoc
class __$$AppliedItemDiscountImplCopyWithImpl<$Res>
    extends _$AppliedItemDiscountCopyWithImpl<$Res, _$AppliedItemDiscountImpl>
    implements _$$AppliedItemDiscountImplCopyWith<$Res> {
  __$$AppliedItemDiscountImplCopyWithImpl(
    _$AppliedItemDiscountImpl _value,
    $Res Function(_$AppliedItemDiscountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppliedItemDiscount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountId = null,
    Object? discountName = null,
    Object? type = null,
    Object? value = null,
    Object? calculatedAmount = null,
    Object? isAutoApplied = null,
    Object? reason = freezed,
    Object? appliedAt = null,
  }) {
    return _then(
      _$AppliedItemDiscountImpl(
        discountId:
            null == discountId
                ? _value.discountId
                : discountId // ignore: cast_nullable_to_non_nullable
                    as String,
        discountName:
            null == discountName
                ? _value.discountName
                : discountName // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as DiscountType,
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
        calculatedAmount:
            null == calculatedAmount
                ? _value.calculatedAmount
                : calculatedAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        isAutoApplied:
            null == isAutoApplied
                ? _value.isAutoApplied
                : isAutoApplied // ignore: cast_nullable_to_non_nullable
                    as bool,
        reason:
            freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedAt:
            null == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppliedItemDiscountImpl extends _AppliedItemDiscount {
  const _$AppliedItemDiscountImpl({
    required this.discountId,
    required this.discountName,
    required this.type,
    required this.value,
    required this.calculatedAmount,
    required this.isAutoApplied,
    this.reason,
    required this.appliedAt,
  }) : super._();

  factory _$AppliedItemDiscountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppliedItemDiscountImplFromJson(json);

  @override
  final String discountId;
  @override
  final String discountName;
  @override
  final DiscountType type;
  @override
  final double value;
  @override
  final double calculatedAmount;
  // The actual discount amount for this item
  @override
  final bool isAutoApplied;
  @override
  final String? reason;
  // Reason for manual discount
  @override
  final DateTime appliedAt;

  @override
  String toString() {
    return 'AppliedItemDiscount(discountId: $discountId, discountName: $discountName, type: $type, value: $value, calculatedAmount: $calculatedAmount, isAutoApplied: $isAutoApplied, reason: $reason, appliedAt: $appliedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppliedItemDiscountImpl &&
            (identical(other.discountId, discountId) ||
                other.discountId == discountId) &&
            (identical(other.discountName, discountName) ||
                other.discountName == discountName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.calculatedAmount, calculatedAmount) ||
                other.calculatedAmount == calculatedAmount) &&
            (identical(other.isAutoApplied, isAutoApplied) ||
                other.isAutoApplied == isAutoApplied) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    discountId,
    discountName,
    type,
    value,
    calculatedAmount,
    isAutoApplied,
    reason,
    appliedAt,
  );

  /// Create a copy of AppliedItemDiscount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppliedItemDiscountImplCopyWith<_$AppliedItemDiscountImpl> get copyWith =>
      __$$AppliedItemDiscountImplCopyWithImpl<_$AppliedItemDiscountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppliedItemDiscountImplToJson(this);
  }
}

abstract class _AppliedItemDiscount extends AppliedItemDiscount {
  const factory _AppliedItemDiscount({
    required final String discountId,
    required final String discountName,
    required final DiscountType type,
    required final double value,
    required final double calculatedAmount,
    required final bool isAutoApplied,
    final String? reason,
    required final DateTime appliedAt,
  }) = _$AppliedItemDiscountImpl;
  const _AppliedItemDiscount._() : super._();

  factory _AppliedItemDiscount.fromJson(Map<String, dynamic> json) =
      _$AppliedItemDiscountImpl.fromJson;

  @override
  String get discountId;
  @override
  String get discountName;
  @override
  DiscountType get type;
  @override
  double get value;
  @override
  double get calculatedAmount; // The actual discount amount for this item
  @override
  bool get isAutoApplied;
  @override
  String? get reason; // Reason for manual discount
  @override
  DateTime get appliedAt;

  /// Create a copy of AppliedItemDiscount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppliedItemDiscountImplCopyWith<_$AppliedItemDiscountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
