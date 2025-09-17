// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerTransaction _$CustomerTransactionFromJson(Map<String, dynamic> json) {
  return _CustomerTransaction.fromJson(json);
}

/// @nodoc
mixin _$CustomerTransaction {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String get customerId =>
      throw _privateConstructorUsedError; // Transaction Details
  String get transactionType =>
      throw _privateConstructorUsedError; // 'sale', 'payment', 'credit_note', 'debit_note', 'opening_balance'
  DateTime get transactionDate =>
      throw _privateConstructorUsedError; // Reference Information
  String? get referenceType =>
      throw _privateConstructorUsedError; // 'order', 'invoice', 'payment', 'manual'
  String? get referenceId => throw _privateConstructorUsedError;
  String? get referenceNumber => throw _privateConstructorUsedError; // Amounts
  double get amount =>
      throw _privateConstructorUsedError; // Positive for debit, negative for credit
  double get balanceBefore => throw _privateConstructorUsedError;
  double get balanceAfter =>
      throw _privateConstructorUsedError; // Payment Details
  String? get paymentMethodId => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;
  DateTime? get paymentDate =>
      throw _privateConstructorUsedError; // Cheque Details
  String? get chequeNumber => throw _privateConstructorUsedError;
  DateTime? get chequeDate => throw _privateConstructorUsedError;
  String? get chequeStatus =>
      throw _privateConstructorUsedError; // 'pending', 'cleared', 'bounced', 'cancelled'
  String? get bankName =>
      throw _privateConstructorUsedError; // Additional Information
  String? get description => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  DateTime? get verifiedAt =>
      throw _privateConstructorUsedError; // Offline sync
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this CustomerTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerTransactionCopyWith<CustomerTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerTransactionCopyWith<$Res> {
  factory $CustomerTransactionCopyWith(
    CustomerTransaction value,
    $Res Function(CustomerTransaction) then,
  ) = _$CustomerTransactionCopyWithImpl<$Res, CustomerTransaction>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String customerId,
    String transactionType,
    DateTime transactionDate,
    String? referenceType,
    String? referenceId,
    String? referenceNumber,
    double amount,
    double balanceBefore,
    double balanceAfter,
    String? paymentMethodId,
    String? paymentReference,
    DateTime? paymentDate,
    String? chequeNumber,
    DateTime? chequeDate,
    String? chequeStatus,
    String? bankName,
    String? description,
    String? notes,
    DateTime createdAt,
    String? createdBy,
    bool isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$CustomerTransactionCopyWithImpl<$Res, $Val extends CustomerTransaction>
    implements $CustomerTransactionCopyWith<$Res> {
  _$CustomerTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? customerId = null,
    Object? transactionType = null,
    Object? transactionDate = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? referenceNumber = freezed,
    Object? amount = null,
    Object? balanceBefore = null,
    Object? balanceAfter = null,
    Object? paymentMethodId = freezed,
    Object? paymentReference = freezed,
    Object? paymentDate = freezed,
    Object? chequeNumber = freezed,
    Object? chequeDate = freezed,
    Object? chequeStatus = freezed,
    Object? bankName = freezed,
    Object? description = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? isVerified = null,
    Object? verifiedBy = freezed,
    Object? verifiedAt = freezed,
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
            customerId:
                null == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String,
            transactionType:
                null == transactionType
                    ? _value.transactionType
                    : transactionType // ignore: cast_nullable_to_non_nullable
                        as String,
            transactionDate:
                null == transactionDate
                    ? _value.transactionDate
                    : transactionDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            referenceType:
                freezed == referenceType
                    ? _value.referenceType
                    : referenceType // ignore: cast_nullable_to_non_nullable
                        as String?,
            referenceId:
                freezed == referenceId
                    ? _value.referenceId
                    : referenceId // ignore: cast_nullable_to_non_nullable
                        as String?,
            referenceNumber:
                freezed == referenceNumber
                    ? _value.referenceNumber
                    : referenceNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as double,
            balanceBefore:
                null == balanceBefore
                    ? _value.balanceBefore
                    : balanceBefore // ignore: cast_nullable_to_non_nullable
                        as double,
            balanceAfter:
                null == balanceAfter
                    ? _value.balanceAfter
                    : balanceAfter // ignore: cast_nullable_to_non_nullable
                        as double,
            paymentMethodId:
                freezed == paymentMethodId
                    ? _value.paymentMethodId
                    : paymentMethodId // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentReference:
                freezed == paymentReference
                    ? _value.paymentReference
                    : paymentReference // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentDate:
                freezed == paymentDate
                    ? _value.paymentDate
                    : paymentDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            chequeNumber:
                freezed == chequeNumber
                    ? _value.chequeNumber
                    : chequeNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            chequeDate:
                freezed == chequeDate
                    ? _value.chequeDate
                    : chequeDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            chequeStatus:
                freezed == chequeStatus
                    ? _value.chequeStatus
                    : chequeStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            bankName:
                freezed == bankName
                    ? _value.bankName
                    : bankName // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
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
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            isVerified:
                null == isVerified
                    ? _value.isVerified
                    : isVerified // ignore: cast_nullable_to_non_nullable
                        as bool,
            verifiedBy:
                freezed == verifiedBy
                    ? _value.verifiedBy
                    : verifiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            verifiedAt:
                freezed == verifiedAt
                    ? _value.verifiedAt
                    : verifiedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CustomerTransactionImplCopyWith<$Res>
    implements $CustomerTransactionCopyWith<$Res> {
  factory _$$CustomerTransactionImplCopyWith(
    _$CustomerTransactionImpl value,
    $Res Function(_$CustomerTransactionImpl) then,
  ) = __$$CustomerTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String customerId,
    String transactionType,
    DateTime transactionDate,
    String? referenceType,
    String? referenceId,
    String? referenceNumber,
    double amount,
    double balanceBefore,
    double balanceAfter,
    String? paymentMethodId,
    String? paymentReference,
    DateTime? paymentDate,
    String? chequeNumber,
    DateTime? chequeDate,
    String? chequeStatus,
    String? bankName,
    String? description,
    String? notes,
    DateTime createdAt,
    String? createdBy,
    bool isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$CustomerTransactionImplCopyWithImpl<$Res>
    extends _$CustomerTransactionCopyWithImpl<$Res, _$CustomerTransactionImpl>
    implements _$$CustomerTransactionImplCopyWith<$Res> {
  __$$CustomerTransactionImplCopyWithImpl(
    _$CustomerTransactionImpl _value,
    $Res Function(_$CustomerTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? customerId = null,
    Object? transactionType = null,
    Object? transactionDate = null,
    Object? referenceType = freezed,
    Object? referenceId = freezed,
    Object? referenceNumber = freezed,
    Object? amount = null,
    Object? balanceBefore = null,
    Object? balanceAfter = null,
    Object? paymentMethodId = freezed,
    Object? paymentReference = freezed,
    Object? paymentDate = freezed,
    Object? chequeNumber = freezed,
    Object? chequeDate = freezed,
    Object? chequeStatus = freezed,
    Object? bankName = freezed,
    Object? description = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? isVerified = null,
    Object? verifiedBy = freezed,
    Object? verifiedAt = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$CustomerTransactionImpl(
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
        customerId:
            null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String,
        transactionType:
            null == transactionType
                ? _value.transactionType
                : transactionType // ignore: cast_nullable_to_non_nullable
                    as String,
        transactionDate:
            null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        referenceType:
            freezed == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                    as String?,
        referenceId:
            freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                    as String?,
        referenceNumber:
            freezed == referenceNumber
                ? _value.referenceNumber
                : referenceNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as double,
        balanceBefore:
            null == balanceBefore
                ? _value.balanceBefore
                : balanceBefore // ignore: cast_nullable_to_non_nullable
                    as double,
        balanceAfter:
            null == balanceAfter
                ? _value.balanceAfter
                : balanceAfter // ignore: cast_nullable_to_non_nullable
                    as double,
        paymentMethodId:
            freezed == paymentMethodId
                ? _value.paymentMethodId
                : paymentMethodId // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentReference:
            freezed == paymentReference
                ? _value.paymentReference
                : paymentReference // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentDate:
            freezed == paymentDate
                ? _value.paymentDate
                : paymentDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        chequeNumber:
            freezed == chequeNumber
                ? _value.chequeNumber
                : chequeNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        chequeDate:
            freezed == chequeDate
                ? _value.chequeDate
                : chequeDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        chequeStatus:
            freezed == chequeStatus
                ? _value.chequeStatus
                : chequeStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        bankName:
            freezed == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
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
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        isVerified:
            null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                    as bool,
        verifiedBy:
            freezed == verifiedBy
                ? _value.verifiedBy
                : verifiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        verifiedAt:
            freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
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
class _$CustomerTransactionImpl extends _CustomerTransaction {
  const _$CustomerTransactionImpl({
    required this.id,
    required this.businessId,
    required this.customerId,
    required this.transactionType,
    required this.transactionDate,
    this.referenceType,
    this.referenceId,
    this.referenceNumber,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.paymentMethodId,
    this.paymentReference,
    this.paymentDate,
    this.chequeNumber,
    this.chequeDate,
    this.chequeStatus = 'pending',
    this.bankName,
    this.description,
    this.notes,
    required this.createdAt,
    this.createdBy,
    this.isVerified = false,
    this.verifiedBy,
    this.verifiedAt,
    this.hasUnsyncedChanges = false,
  }) : super._();

  factory _$CustomerTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String customerId;
  // Transaction Details
  @override
  final String transactionType;
  // 'sale', 'payment', 'credit_note', 'debit_note', 'opening_balance'
  @override
  final DateTime transactionDate;
  // Reference Information
  @override
  final String? referenceType;
  // 'order', 'invoice', 'payment', 'manual'
  @override
  final String? referenceId;
  @override
  final String? referenceNumber;
  // Amounts
  @override
  final double amount;
  // Positive for debit, negative for credit
  @override
  final double balanceBefore;
  @override
  final double balanceAfter;
  // Payment Details
  @override
  final String? paymentMethodId;
  @override
  final String? paymentReference;
  @override
  final DateTime? paymentDate;
  // Cheque Details
  @override
  final String? chequeNumber;
  @override
  final DateTime? chequeDate;
  @override
  @JsonKey()
  final String? chequeStatus;
  // 'pending', 'cleared', 'bounced', 'cancelled'
  @override
  final String? bankName;
  // Additional Information
  @override
  final String? description;
  @override
  final String? notes;
  // Metadata
  @override
  final DateTime createdAt;
  @override
  final String? createdBy;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final String? verifiedBy;
  @override
  final DateTime? verifiedAt;
  // Offline sync
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'CustomerTransaction(id: $id, businessId: $businessId, customerId: $customerId, transactionType: $transactionType, transactionDate: $transactionDate, referenceType: $referenceType, referenceId: $referenceId, referenceNumber: $referenceNumber, amount: $amount, balanceBefore: $balanceBefore, balanceAfter: $balanceAfter, paymentMethodId: $paymentMethodId, paymentReference: $paymentReference, paymentDate: $paymentDate, chequeNumber: $chequeNumber, chequeDate: $chequeDate, chequeStatus: $chequeStatus, bankName: $bankName, description: $description, notes: $notes, createdAt: $createdAt, createdBy: $createdBy, isVerified: $isVerified, verifiedBy: $verifiedBy, verifiedAt: $verifiedAt, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.balanceBefore, balanceBefore) ||
                other.balanceBefore == balanceBefore) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.chequeNumber, chequeNumber) ||
                other.chequeNumber == chequeNumber) &&
            (identical(other.chequeDate, chequeDate) ||
                other.chequeDate == chequeDate) &&
            (identical(other.chequeStatus, chequeStatus) ||
                other.chequeStatus == chequeStatus) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessId,
    customerId,
    transactionType,
    transactionDate,
    referenceType,
    referenceId,
    referenceNumber,
    amount,
    balanceBefore,
    balanceAfter,
    paymentMethodId,
    paymentReference,
    paymentDate,
    chequeNumber,
    chequeDate,
    chequeStatus,
    bankName,
    description,
    notes,
    createdAt,
    createdBy,
    isVerified,
    verifiedBy,
    verifiedAt,
    hasUnsyncedChanges,
  ]);

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerTransactionImplCopyWith<_$CustomerTransactionImpl> get copyWith =>
      __$$CustomerTransactionImplCopyWithImpl<_$CustomerTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerTransactionImplToJson(this);
  }
}

abstract class _CustomerTransaction extends CustomerTransaction {
  const factory _CustomerTransaction({
    required final String id,
    required final String businessId,
    required final String customerId,
    required final String transactionType,
    required final DateTime transactionDate,
    final String? referenceType,
    final String? referenceId,
    final String? referenceNumber,
    required final double amount,
    required final double balanceBefore,
    required final double balanceAfter,
    final String? paymentMethodId,
    final String? paymentReference,
    final DateTime? paymentDate,
    final String? chequeNumber,
    final DateTime? chequeDate,
    final String? chequeStatus,
    final String? bankName,
    final String? description,
    final String? notes,
    required final DateTime createdAt,
    final String? createdBy,
    final bool isVerified,
    final String? verifiedBy,
    final DateTime? verifiedAt,
    final bool hasUnsyncedChanges,
  }) = _$CustomerTransactionImpl;
  const _CustomerTransaction._() : super._();

  factory _CustomerTransaction.fromJson(Map<String, dynamic> json) =
      _$CustomerTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String get customerId; // Transaction Details
  @override
  String get transactionType; // 'sale', 'payment', 'credit_note', 'debit_note', 'opening_balance'
  @override
  DateTime get transactionDate; // Reference Information
  @override
  String? get referenceType; // 'order', 'invoice', 'payment', 'manual'
  @override
  String? get referenceId;
  @override
  String? get referenceNumber; // Amounts
  @override
  double get amount; // Positive for debit, negative for credit
  @override
  double get balanceBefore;
  @override
  double get balanceAfter; // Payment Details
  @override
  String? get paymentMethodId;
  @override
  String? get paymentReference;
  @override
  DateTime? get paymentDate; // Cheque Details
  @override
  String? get chequeNumber;
  @override
  DateTime? get chequeDate;
  @override
  String? get chequeStatus; // 'pending', 'cleared', 'bounced', 'cancelled'
  @override
  String? get bankName; // Additional Information
  @override
  String? get description;
  @override
  String? get notes; // Metadata
  @override
  DateTime get createdAt;
  @override
  String? get createdBy;
  @override
  bool get isVerified;
  @override
  String? get verifiedBy;
  @override
  DateTime? get verifiedAt; // Offline sync
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerTransactionImplCopyWith<_$CustomerTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
