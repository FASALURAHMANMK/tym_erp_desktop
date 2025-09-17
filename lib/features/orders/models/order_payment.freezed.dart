// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderPayment _$OrderPaymentFromJson(Map<String, dynamic> json) {
  return _OrderPayment.fromJson(json);
}

/// @nodoc
mixin _$OrderPayment {
  // Identification
  String get id => throw _privateConstructorUsedError;
  String get orderId =>
      throw _privateConstructorUsedError; // Payment Method (snapshot)
  String get paymentMethodId => throw _privateConstructorUsedError;
  String get paymentMethodName => throw _privateConstructorUsedError;
  String get paymentMethodCode => throw _privateConstructorUsedError; // Amounts
  double get amount => throw _privateConstructorUsedError;
  double get tipAmount => throw _privateConstructorUsedError;
  double get processingFee => throw _privateConstructorUsedError;
  double get totalAmount =>
      throw _privateConstructorUsedError; // amount + tipAmount + processingFee
  // Status
  String get status =>
      throw _privateConstructorUsedError; // pending, completed, failed, refunded
  // Reference Information
  String? get referenceNumber =>
      throw _privateConstructorUsedError; // Check number, transaction ID, etc.
  String? get transactionId =>
      throw _privateConstructorUsedError; // Payment gateway transaction ID
  String? get approvalCode =>
      throw _privateConstructorUsedError; // For card payments
  // Card Information (if applicable)
  String? get cardLastFour => throw _privateConstructorUsedError;
  String? get cardType =>
      throw _privateConstructorUsedError; // visa, mastercard, etc.
  // Timestamps
  DateTime get paidAt => throw _privateConstructorUsedError;
  DateTime? get refundedAt =>
      throw _privateConstructorUsedError; // Refund Information
  double get refundedAmount => throw _privateConstructorUsedError;
  String? get refundReason => throw _privateConstructorUsedError;
  String? get refundedBy => throw _privateConstructorUsedError;
  String? get refundTransactionId =>
      throw _privateConstructorUsedError; // Staff Information
  String get processedBy =>
      throw _privateConstructorUsedError; // User ID who processed payment
  String? get processedByName => throw _privateConstructorUsedError; // Snapshot
  // Notes
  String? get notes => throw _privateConstructorUsedError; // Metadata
  Map<String, dynamic>? get metadata =>
      throw _privateConstructorUsedError; // For gateway-specific data
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this OrderPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPaymentCopyWith<OrderPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPaymentCopyWith<$Res> {
  factory $OrderPaymentCopyWith(
    OrderPayment value,
    $Res Function(OrderPayment) then,
  ) = _$OrderPaymentCopyWithImpl<$Res, OrderPayment>;
  @useResult
  $Res call({
    String id,
    String orderId,
    String paymentMethodId,
    String paymentMethodName,
    String paymentMethodCode,
    double amount,
    double tipAmount,
    double processingFee,
    double totalAmount,
    String status,
    String? referenceNumber,
    String? transactionId,
    String? approvalCode,
    String? cardLastFour,
    String? cardType,
    DateTime paidAt,
    DateTime? refundedAt,
    double refundedAmount,
    String? refundReason,
    String? refundedBy,
    String? refundTransactionId,
    String processedBy,
    String? processedByName,
    String? notes,
    Map<String, dynamic>? metadata,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$OrderPaymentCopyWithImpl<$Res, $Val extends OrderPayment>
    implements $OrderPaymentCopyWith<$Res> {
  _$OrderPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? paymentMethodId = null,
    Object? paymentMethodName = null,
    Object? paymentMethodCode = null,
    Object? amount = null,
    Object? tipAmount = null,
    Object? processingFee = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? referenceNumber = freezed,
    Object? transactionId = freezed,
    Object? approvalCode = freezed,
    Object? cardLastFour = freezed,
    Object? cardType = freezed,
    Object? paidAt = null,
    Object? refundedAt = freezed,
    Object? refundedAmount = null,
    Object? refundReason = freezed,
    Object? refundedBy = freezed,
    Object? refundTransactionId = freezed,
    Object? processedBy = null,
    Object? processedByName = freezed,
    Object? notes = freezed,
    Object? metadata = freezed,
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
            orderId:
                null == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String,
            paymentMethodId:
                null == paymentMethodId
                    ? _value.paymentMethodId
                    : paymentMethodId // ignore: cast_nullable_to_non_nullable
                        as String,
            paymentMethodName:
                null == paymentMethodName
                    ? _value.paymentMethodName
                    : paymentMethodName // ignore: cast_nullable_to_non_nullable
                        as String,
            paymentMethodCode:
                null == paymentMethodCode
                    ? _value.paymentMethodCode
                    : paymentMethodCode // ignore: cast_nullable_to_non_nullable
                        as String,
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as double,
            tipAmount:
                null == tipAmount
                    ? _value.tipAmount
                    : tipAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            processingFee:
                null == processingFee
                    ? _value.processingFee
                    : processingFee // ignore: cast_nullable_to_non_nullable
                        as double,
            totalAmount:
                null == totalAmount
                    ? _value.totalAmount
                    : totalAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            referenceNumber:
                freezed == referenceNumber
                    ? _value.referenceNumber
                    : referenceNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            transactionId:
                freezed == transactionId
                    ? _value.transactionId
                    : transactionId // ignore: cast_nullable_to_non_nullable
                        as String?,
            approvalCode:
                freezed == approvalCode
                    ? _value.approvalCode
                    : approvalCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardLastFour:
                freezed == cardLastFour
                    ? _value.cardLastFour
                    : cardLastFour // ignore: cast_nullable_to_non_nullable
                        as String?,
            cardType:
                freezed == cardType
                    ? _value.cardType
                    : cardType // ignore: cast_nullable_to_non_nullable
                        as String?,
            paidAt:
                null == paidAt
                    ? _value.paidAt
                    : paidAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            refundedAt:
                freezed == refundedAt
                    ? _value.refundedAt
                    : refundedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            refundedAmount:
                null == refundedAmount
                    ? _value.refundedAmount
                    : refundedAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            refundReason:
                freezed == refundReason
                    ? _value.refundReason
                    : refundReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            refundedBy:
                freezed == refundedBy
                    ? _value.refundedBy
                    : refundedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            refundTransactionId:
                freezed == refundTransactionId
                    ? _value.refundTransactionId
                    : refundTransactionId // ignore: cast_nullable_to_non_nullable
                        as String?,
            processedBy:
                null == processedBy
                    ? _value.processedBy
                    : processedBy // ignore: cast_nullable_to_non_nullable
                        as String,
            processedByName:
                freezed == processedByName
                    ? _value.processedByName
                    : processedByName // ignore: cast_nullable_to_non_nullable
                        as String?,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
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
abstract class _$$OrderPaymentImplCopyWith<$Res>
    implements $OrderPaymentCopyWith<$Res> {
  factory _$$OrderPaymentImplCopyWith(
    _$OrderPaymentImpl value,
    $Res Function(_$OrderPaymentImpl) then,
  ) = __$$OrderPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    String paymentMethodId,
    String paymentMethodName,
    String paymentMethodCode,
    double amount,
    double tipAmount,
    double processingFee,
    double totalAmount,
    String status,
    String? referenceNumber,
    String? transactionId,
    String? approvalCode,
    String? cardLastFour,
    String? cardType,
    DateTime paidAt,
    DateTime? refundedAt,
    double refundedAmount,
    String? refundReason,
    String? refundedBy,
    String? refundTransactionId,
    String processedBy,
    String? processedByName,
    String? notes,
    Map<String, dynamic>? metadata,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$OrderPaymentImplCopyWithImpl<$Res>
    extends _$OrderPaymentCopyWithImpl<$Res, _$OrderPaymentImpl>
    implements _$$OrderPaymentImplCopyWith<$Res> {
  __$$OrderPaymentImplCopyWithImpl(
    _$OrderPaymentImpl _value,
    $Res Function(_$OrderPaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? paymentMethodId = null,
    Object? paymentMethodName = null,
    Object? paymentMethodCode = null,
    Object? amount = null,
    Object? tipAmount = null,
    Object? processingFee = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? referenceNumber = freezed,
    Object? transactionId = freezed,
    Object? approvalCode = freezed,
    Object? cardLastFour = freezed,
    Object? cardType = freezed,
    Object? paidAt = null,
    Object? refundedAt = freezed,
    Object? refundedAmount = null,
    Object? refundReason = freezed,
    Object? refundedBy = freezed,
    Object? refundTransactionId = freezed,
    Object? processedBy = null,
    Object? processedByName = freezed,
    Object? notes = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$OrderPaymentImpl(
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
        paymentMethodId:
            null == paymentMethodId
                ? _value.paymentMethodId
                : paymentMethodId // ignore: cast_nullable_to_non_nullable
                    as String,
        paymentMethodName:
            null == paymentMethodName
                ? _value.paymentMethodName
                : paymentMethodName // ignore: cast_nullable_to_non_nullable
                    as String,
        paymentMethodCode:
            null == paymentMethodCode
                ? _value.paymentMethodCode
                : paymentMethodCode // ignore: cast_nullable_to_non_nullable
                    as String,
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as double,
        tipAmount:
            null == tipAmount
                ? _value.tipAmount
                : tipAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        processingFee:
            null == processingFee
                ? _value.processingFee
                : processingFee // ignore: cast_nullable_to_non_nullable
                    as double,
        totalAmount:
            null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        referenceNumber:
            freezed == referenceNumber
                ? _value.referenceNumber
                : referenceNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        transactionId:
            freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                    as String?,
        approvalCode:
            freezed == approvalCode
                ? _value.approvalCode
                : approvalCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardLastFour:
            freezed == cardLastFour
                ? _value.cardLastFour
                : cardLastFour // ignore: cast_nullable_to_non_nullable
                    as String?,
        cardType:
            freezed == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                    as String?,
        paidAt:
            null == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        refundedAt:
            freezed == refundedAt
                ? _value.refundedAt
                : refundedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        refundedAmount:
            null == refundedAmount
                ? _value.refundedAmount
                : refundedAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        refundReason:
            freezed == refundReason
                ? _value.refundReason
                : refundReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        refundedBy:
            freezed == refundedBy
                ? _value.refundedBy
                : refundedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        refundTransactionId:
            freezed == refundTransactionId
                ? _value.refundTransactionId
                : refundTransactionId // ignore: cast_nullable_to_non_nullable
                    as String?,
        processedBy:
            null == processedBy
                ? _value.processedBy
                : processedBy // ignore: cast_nullable_to_non_nullable
                    as String,
        processedByName:
            freezed == processedByName
                ? _value.processedByName
                : processedByName // ignore: cast_nullable_to_non_nullable
                    as String?,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
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
@JsonSerializable()
class _$OrderPaymentImpl extends _OrderPayment {
  const _$OrderPaymentImpl({
    required this.id,
    required this.orderId,
    required this.paymentMethodId,
    required this.paymentMethodName,
    required this.paymentMethodCode,
    required this.amount,
    this.tipAmount = 0,
    this.processingFee = 0,
    required this.totalAmount,
    this.status = 'pending',
    this.referenceNumber,
    this.transactionId,
    this.approvalCode,
    this.cardLastFour,
    this.cardType,
    required this.paidAt,
    this.refundedAt,
    this.refundedAmount = 0,
    this.refundReason,
    this.refundedBy,
    this.refundTransactionId,
    required this.processedBy,
    this.processedByName,
    this.notes,
    final Map<String, dynamic>? metadata,
    required this.createdAt,
    required this.updatedAt,
  }) : _metadata = metadata,
       super._();

  factory _$OrderPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderPaymentImplFromJson(json);

  // Identification
  @override
  final String id;
  @override
  final String orderId;
  // Payment Method (snapshot)
  @override
  final String paymentMethodId;
  @override
  final String paymentMethodName;
  @override
  final String paymentMethodCode;
  // Amounts
  @override
  final double amount;
  @override
  @JsonKey()
  final double tipAmount;
  @override
  @JsonKey()
  final double processingFee;
  @override
  final double totalAmount;
  // amount + tipAmount + processingFee
  // Status
  @override
  @JsonKey()
  final String status;
  // pending, completed, failed, refunded
  // Reference Information
  @override
  final String? referenceNumber;
  // Check number, transaction ID, etc.
  @override
  final String? transactionId;
  // Payment gateway transaction ID
  @override
  final String? approvalCode;
  // For card payments
  // Card Information (if applicable)
  @override
  final String? cardLastFour;
  @override
  final String? cardType;
  // visa, mastercard, etc.
  // Timestamps
  @override
  final DateTime paidAt;
  @override
  final DateTime? refundedAt;
  // Refund Information
  @override
  @JsonKey()
  final double refundedAmount;
  @override
  final String? refundReason;
  @override
  final String? refundedBy;
  @override
  final String? refundTransactionId;
  // Staff Information
  @override
  final String processedBy;
  // User ID who processed payment
  @override
  final String? processedByName;
  // Snapshot
  // Notes
  @override
  final String? notes;
  // Metadata
  final Map<String, dynamic>? _metadata;
  // Metadata
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // For gateway-specific data
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'OrderPayment(id: $id, orderId: $orderId, paymentMethodId: $paymentMethodId, paymentMethodName: $paymentMethodName, paymentMethodCode: $paymentMethodCode, amount: $amount, tipAmount: $tipAmount, processingFee: $processingFee, totalAmount: $totalAmount, status: $status, referenceNumber: $referenceNumber, transactionId: $transactionId, approvalCode: $approvalCode, cardLastFour: $cardLastFour, cardType: $cardType, paidAt: $paidAt, refundedAt: $refundedAt, refundedAmount: $refundedAmount, refundReason: $refundReason, refundedBy: $refundedBy, refundTransactionId: $refundTransactionId, processedBy: $processedBy, processedByName: $processedByName, notes: $notes, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.paymentMethodName, paymentMethodName) ||
                other.paymentMethodName == paymentMethodName) &&
            (identical(other.paymentMethodCode, paymentMethodCode) ||
                other.paymentMethodCode == paymentMethodCode) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.tipAmount, tipAmount) ||
                other.tipAmount == tipAmount) &&
            (identical(other.processingFee, processingFee) ||
                other.processingFee == processingFee) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.approvalCode, approvalCode) ||
                other.approvalCode == approvalCode) &&
            (identical(other.cardLastFour, cardLastFour) ||
                other.cardLastFour == cardLastFour) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            (identical(other.refundedAmount, refundedAmount) ||
                other.refundedAmount == refundedAmount) &&
            (identical(other.refundReason, refundReason) ||
                other.refundReason == refundReason) &&
            (identical(other.refundedBy, refundedBy) ||
                other.refundedBy == refundedBy) &&
            (identical(other.refundTransactionId, refundTransactionId) ||
                other.refundTransactionId == refundTransactionId) &&
            (identical(other.processedBy, processedBy) ||
                other.processedBy == processedBy) &&
            (identical(other.processedByName, processedByName) ||
                other.processedByName == processedByName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    orderId,
    paymentMethodId,
    paymentMethodName,
    paymentMethodCode,
    amount,
    tipAmount,
    processingFee,
    totalAmount,
    status,
    referenceNumber,
    transactionId,
    approvalCode,
    cardLastFour,
    cardType,
    paidAt,
    refundedAt,
    refundedAmount,
    refundReason,
    refundedBy,
    refundTransactionId,
    processedBy,
    processedByName,
    notes,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      __$$OrderPaymentImplCopyWithImpl<_$OrderPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPaymentImplToJson(this);
  }
}

abstract class _OrderPayment extends OrderPayment {
  const factory _OrderPayment({
    required final String id,
    required final String orderId,
    required final String paymentMethodId,
    required final String paymentMethodName,
    required final String paymentMethodCode,
    required final double amount,
    final double tipAmount,
    final double processingFee,
    required final double totalAmount,
    final String status,
    final String? referenceNumber,
    final String? transactionId,
    final String? approvalCode,
    final String? cardLastFour,
    final String? cardType,
    required final DateTime paidAt,
    final DateTime? refundedAt,
    final double refundedAmount,
    final String? refundReason,
    final String? refundedBy,
    final String? refundTransactionId,
    required final String processedBy,
    final String? processedByName,
    final String? notes,
    final Map<String, dynamic>? metadata,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$OrderPaymentImpl;
  const _OrderPayment._() : super._();

  factory _OrderPayment.fromJson(Map<String, dynamic> json) =
      _$OrderPaymentImpl.fromJson;

  // Identification
  @override
  String get id;
  @override
  String get orderId; // Payment Method (snapshot)
  @override
  String get paymentMethodId;
  @override
  String get paymentMethodName;
  @override
  String get paymentMethodCode; // Amounts
  @override
  double get amount;
  @override
  double get tipAmount;
  @override
  double get processingFee;
  @override
  double get totalAmount; // amount + tipAmount + processingFee
  // Status
  @override
  String get status; // pending, completed, failed, refunded
  // Reference Information
  @override
  String? get referenceNumber; // Check number, transaction ID, etc.
  @override
  String? get transactionId; // Payment gateway transaction ID
  @override
  String? get approvalCode; // For card payments
  // Card Information (if applicable)
  @override
  String? get cardLastFour;
  @override
  String? get cardType; // visa, mastercard, etc.
  // Timestamps
  @override
  DateTime get paidAt;
  @override
  DateTime? get refundedAt; // Refund Information
  @override
  double get refundedAmount;
  @override
  String? get refundReason;
  @override
  String? get refundedBy;
  @override
  String? get refundTransactionId; // Staff Information
  @override
  String get processedBy; // User ID who processed payment
  @override
  String? get processedByName; // Snapshot
  // Notes
  @override
  String? get notes; // Metadata
  @override
  Map<String, dynamic>? get metadata; // For gateway-specific data
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
