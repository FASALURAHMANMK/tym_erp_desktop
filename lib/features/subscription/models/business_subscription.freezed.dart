// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BusinessSubscription {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get planId => throw _privateConstructorUsedError;
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  DateTime? get trialStartDate => throw _privateConstructorUsedError;
  DateTime? get trialEndDate => throw _privateConstructorUsedError;
  DateTime? get subscriptionStartDate => throw _privateConstructorUsedError;
  DateTime? get subscriptionEndDate => throw _privateConstructorUsedError;
  bool get autoRenew => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  double? get amountPaid => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of BusinessSubscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessSubscriptionCopyWith<BusinessSubscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessSubscriptionCopyWith<$Res> {
  factory $BusinessSubscriptionCopyWith(
    BusinessSubscription value,
    $Res Function(BusinessSubscription) then,
  ) = _$BusinessSubscriptionCopyWithImpl<$Res, BusinessSubscription>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String planId,
    SubscriptionStatus status,
    DateTime? trialStartDate,
    DateTime? trialEndDate,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    bool autoRenew,
    String? paymentMethod,
    String currency,
    double? amountPaid,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$BusinessSubscriptionCopyWithImpl<
  $Res,
  $Val extends BusinessSubscription
>
    implements $BusinessSubscriptionCopyWith<$Res> {
  _$BusinessSubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessSubscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? planId = null,
    Object? status = null,
    Object? trialStartDate = freezed,
    Object? trialEndDate = freezed,
    Object? subscriptionStartDate = freezed,
    Object? subscriptionEndDate = freezed,
    Object? autoRenew = null,
    Object? paymentMethod = freezed,
    Object? currency = null,
    Object? amountPaid = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            planId:
                null == planId
                    ? _value.planId
                    : planId // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as SubscriptionStatus,
            trialStartDate:
                freezed == trialStartDate
                    ? _value.trialStartDate
                    : trialStartDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            trialEndDate:
                freezed == trialEndDate
                    ? _value.trialEndDate
                    : trialEndDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            subscriptionStartDate:
                freezed == subscriptionStartDate
                    ? _value.subscriptionStartDate
                    : subscriptionStartDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            subscriptionEndDate:
                freezed == subscriptionEndDate
                    ? _value.subscriptionEndDate
                    : subscriptionEndDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            autoRenew:
                null == autoRenew
                    ? _value.autoRenew
                    : autoRenew // ignore: cast_nullable_to_non_nullable
                        as bool,
            paymentMethod:
                freezed == paymentMethod
                    ? _value.paymentMethod
                    : paymentMethod // ignore: cast_nullable_to_non_nullable
                        as String?,
            currency:
                null == currency
                    ? _value.currency
                    : currency // ignore: cast_nullable_to_non_nullable
                        as String,
            amountPaid:
                freezed == amountPaid
                    ? _value.amountPaid
                    : amountPaid // ignore: cast_nullable_to_non_nullable
                        as double?,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusinessSubscriptionImplCopyWith<$Res>
    implements $BusinessSubscriptionCopyWith<$Res> {
  factory _$$BusinessSubscriptionImplCopyWith(
    _$BusinessSubscriptionImpl value,
    $Res Function(_$BusinessSubscriptionImpl) then,
  ) = __$$BusinessSubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String planId,
    SubscriptionStatus status,
    DateTime? trialStartDate,
    DateTime? trialEndDate,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    bool autoRenew,
    String? paymentMethod,
    String currency,
    double? amountPaid,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$BusinessSubscriptionImplCopyWithImpl<$Res>
    extends _$BusinessSubscriptionCopyWithImpl<$Res, _$BusinessSubscriptionImpl>
    implements _$$BusinessSubscriptionImplCopyWith<$Res> {
  __$$BusinessSubscriptionImplCopyWithImpl(
    _$BusinessSubscriptionImpl _value,
    $Res Function(_$BusinessSubscriptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessSubscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? planId = null,
    Object? status = null,
    Object? trialStartDate = freezed,
    Object? trialEndDate = freezed,
    Object? subscriptionStartDate = freezed,
    Object? subscriptionEndDate = freezed,
    Object? autoRenew = null,
    Object? paymentMethod = freezed,
    Object? currency = null,
    Object? amountPaid = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BusinessSubscriptionImpl(
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
        planId:
            null == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as SubscriptionStatus,
        trialStartDate:
            freezed == trialStartDate
                ? _value.trialStartDate
                : trialStartDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        trialEndDate:
            freezed == trialEndDate
                ? _value.trialEndDate
                : trialEndDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        subscriptionStartDate:
            freezed == subscriptionStartDate
                ? _value.subscriptionStartDate
                : subscriptionStartDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        subscriptionEndDate:
            freezed == subscriptionEndDate
                ? _value.subscriptionEndDate
                : subscriptionEndDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        autoRenew:
            null == autoRenew
                ? _value.autoRenew
                : autoRenew // ignore: cast_nullable_to_non_nullable
                    as bool,
        paymentMethod:
            freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                    as String?,
        currency:
            null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                    as String,
        amountPaid:
            freezed == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                    as double?,
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
      ),
    );
  }
}

/// @nodoc

class _$BusinessSubscriptionImpl extends _BusinessSubscription {
  const _$BusinessSubscriptionImpl({
    required this.id,
    required this.businessId,
    required this.planId,
    required this.status,
    this.trialStartDate,
    this.trialEndDate,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    required this.autoRenew,
    this.paymentMethod,
    required this.currency,
    this.amountPaid,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String planId;
  @override
  final SubscriptionStatus status;
  @override
  final DateTime? trialStartDate;
  @override
  final DateTime? trialEndDate;
  @override
  final DateTime? subscriptionStartDate;
  @override
  final DateTime? subscriptionEndDate;
  @override
  final bool autoRenew;
  @override
  final String? paymentMethod;
  @override
  final String currency;
  @override
  final double? amountPaid;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BusinessSubscription(id: $id, businessId: $businessId, planId: $planId, status: $status, trialStartDate: $trialStartDate, trialEndDate: $trialEndDate, subscriptionStartDate: $subscriptionStartDate, subscriptionEndDate: $subscriptionEndDate, autoRenew: $autoRenew, paymentMethod: $paymentMethod, currency: $currency, amountPaid: $amountPaid, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessSubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.trialStartDate, trialStartDate) ||
                other.trialStartDate == trialStartDate) &&
            (identical(other.trialEndDate, trialEndDate) ||
                other.trialEndDate == trialEndDate) &&
            (identical(other.subscriptionStartDate, subscriptionStartDate) ||
                other.subscriptionStartDate == subscriptionStartDate) &&
            (identical(other.subscriptionEndDate, subscriptionEndDate) ||
                other.subscriptionEndDate == subscriptionEndDate) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    planId,
    status,
    trialStartDate,
    trialEndDate,
    subscriptionStartDate,
    subscriptionEndDate,
    autoRenew,
    paymentMethod,
    currency,
    amountPaid,
    createdAt,
    updatedAt,
  );

  /// Create a copy of BusinessSubscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessSubscriptionImplCopyWith<_$BusinessSubscriptionImpl>
  get copyWith =>
      __$$BusinessSubscriptionImplCopyWithImpl<_$BusinessSubscriptionImpl>(
        this,
        _$identity,
      );
}

abstract class _BusinessSubscription extends BusinessSubscription {
  const factory _BusinessSubscription({
    required final String id,
    required final String businessId,
    required final String planId,
    required final SubscriptionStatus status,
    final DateTime? trialStartDate,
    final DateTime? trialEndDate,
    final DateTime? subscriptionStartDate,
    final DateTime? subscriptionEndDate,
    required final bool autoRenew,
    final String? paymentMethod,
    required final String currency,
    final double? amountPaid,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$BusinessSubscriptionImpl;
  const _BusinessSubscription._() : super._();

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get planId;
  @override
  SubscriptionStatus get status;
  @override
  DateTime? get trialStartDate;
  @override
  DateTime? get trialEndDate;
  @override
  DateTime? get subscriptionStartDate;
  @override
  DateTime? get subscriptionEndDate;
  @override
  bool get autoRenew;
  @override
  String? get paymentMethod;
  @override
  String get currency;
  @override
  double? get amountPaid;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of BusinessSubscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessSubscriptionImplCopyWith<_$BusinessSubscriptionImpl>
  get copyWith => throw _privateConstructorUsedError;
}
