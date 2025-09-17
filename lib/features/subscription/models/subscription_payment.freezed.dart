// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SubscriptionPayment {
  String get id => throw _privateConstructorUsedError;
  String get subscriptionId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;
  DateTime get paymentDate => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionPaymentCopyWith<SubscriptionPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionPaymentCopyWith<$Res> {
  factory $SubscriptionPaymentCopyWith(
    SubscriptionPayment value,
    $Res Function(SubscriptionPayment) then,
  ) = _$SubscriptionPaymentCopyWithImpl<$Res, SubscriptionPayment>;
  @useResult
  $Res call({
    String id,
    String subscriptionId,
    double amount,
    String currency,
    String paymentMethod,
    String? paymentReference,
    DateTime paymentDate,
    String? verifiedBy,
    String? notes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SubscriptionPaymentCopyWithImpl<$Res, $Val extends SubscriptionPayment>
    implements $SubscriptionPaymentCopyWith<$Res> {
  _$SubscriptionPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subscriptionId = null,
    Object? amount = null,
    Object? currency = null,
    Object? paymentMethod = null,
    Object? paymentReference = freezed,
    Object? paymentDate = null,
    Object? verifiedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            subscriptionId:
                null == subscriptionId
                    ? _value.subscriptionId
                    : subscriptionId // ignore: cast_nullable_to_non_nullable
                        as String,
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as double,
            currency:
                null == currency
                    ? _value.currency
                    : currency // ignore: cast_nullable_to_non_nullable
                        as String,
            paymentMethod:
                null == paymentMethod
                    ? _value.paymentMethod
                    : paymentMethod // ignore: cast_nullable_to_non_nullable
                        as String,
            paymentReference:
                freezed == paymentReference
                    ? _value.paymentReference
                    : paymentReference // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentDate:
                null == paymentDate
                    ? _value.paymentDate
                    : paymentDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            verifiedBy:
                freezed == verifiedBy
                    ? _value.verifiedBy
                    : verifiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$SubscriptionPaymentImplCopyWith<$Res>
    implements $SubscriptionPaymentCopyWith<$Res> {
  factory _$$SubscriptionPaymentImplCopyWith(
    _$SubscriptionPaymentImpl value,
    $Res Function(_$SubscriptionPaymentImpl) then,
  ) = __$$SubscriptionPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String subscriptionId,
    double amount,
    String currency,
    String paymentMethod,
    String? paymentReference,
    DateTime paymentDate,
    String? verifiedBy,
    String? notes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SubscriptionPaymentImplCopyWithImpl<$Res>
    extends _$SubscriptionPaymentCopyWithImpl<$Res, _$SubscriptionPaymentImpl>
    implements _$$SubscriptionPaymentImplCopyWith<$Res> {
  __$$SubscriptionPaymentImplCopyWithImpl(
    _$SubscriptionPaymentImpl _value,
    $Res Function(_$SubscriptionPaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subscriptionId = null,
    Object? amount = null,
    Object? currency = null,
    Object? paymentMethod = null,
    Object? paymentReference = freezed,
    Object? paymentDate = null,
    Object? verifiedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$SubscriptionPaymentImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        subscriptionId:
            null == subscriptionId
                ? _value.subscriptionId
                : subscriptionId // ignore: cast_nullable_to_non_nullable
                    as String,
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as double,
        currency:
            null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                    as String,
        paymentMethod:
            null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                    as String,
        paymentReference:
            freezed == paymentReference
                ? _value.paymentReference
                : paymentReference // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentDate:
            null == paymentDate
                ? _value.paymentDate
                : paymentDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        verifiedBy:
            freezed == verifiedBy
                ? _value.verifiedBy
                : verifiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
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

class _$SubscriptionPaymentImpl extends _SubscriptionPayment {
  const _$SubscriptionPaymentImpl({
    required this.id,
    required this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    this.paymentReference,
    required this.paymentDate,
    this.verifiedBy,
    this.notes,
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  final String subscriptionId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String paymentMethod;
  @override
  final String? paymentReference;
  @override
  final DateTime paymentDate;
  @override
  final String? verifiedBy;
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SubscriptionPayment(id: $id, subscriptionId: $subscriptionId, amount: $amount, currency: $currency, paymentMethod: $paymentMethod, paymentReference: $paymentReference, paymentDate: $paymentDate, verifiedBy: $verifiedBy, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    subscriptionId,
    amount,
    currency,
    paymentMethod,
    paymentReference,
    paymentDate,
    verifiedBy,
    notes,
    createdAt,
  );

  /// Create a copy of SubscriptionPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionPaymentImplCopyWith<_$SubscriptionPaymentImpl> get copyWith =>
      __$$SubscriptionPaymentImplCopyWithImpl<_$SubscriptionPaymentImpl>(
        this,
        _$identity,
      );
}

abstract class _SubscriptionPayment extends SubscriptionPayment {
  const factory _SubscriptionPayment({
    required final String id,
    required final String subscriptionId,
    required final double amount,
    required final String currency,
    required final String paymentMethod,
    final String? paymentReference,
    required final DateTime paymentDate,
    final String? verifiedBy,
    final String? notes,
    required final DateTime createdAt,
  }) = _$SubscriptionPaymentImpl;
  const _SubscriptionPayment._() : super._();

  @override
  String get id;
  @override
  String get subscriptionId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get paymentMethod;
  @override
  String? get paymentReference;
  @override
  DateTime get paymentDate;
  @override
  String? get verifiedBy;
  @override
  String? get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of SubscriptionPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionPaymentImplCopyWith<_$SubscriptionPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
