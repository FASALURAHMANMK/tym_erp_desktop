// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerTransactionImpl _$$CustomerTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerTransactionImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  customerId: json['customerId'] as String,
  transactionType: json['transactionType'] as String,
  transactionDate: DateTime.parse(json['transactionDate'] as String),
  referenceType: json['referenceType'] as String?,
  referenceId: json['referenceId'] as String?,
  referenceNumber: json['referenceNumber'] as String?,
  amount: (json['amount'] as num).toDouble(),
  balanceBefore: (json['balanceBefore'] as num).toDouble(),
  balanceAfter: (json['balanceAfter'] as num).toDouble(),
  paymentMethodId: json['paymentMethodId'] as String?,
  paymentReference: json['paymentReference'] as String?,
  paymentDate:
      json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
  chequeNumber: json['chequeNumber'] as String?,
  chequeDate:
      json['chequeDate'] == null
          ? null
          : DateTime.parse(json['chequeDate'] as String),
  chequeStatus: json['chequeStatus'] as String? ?? 'pending',
  bankName: json['bankName'] as String?,
  description: json['description'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  createdBy: json['createdBy'] as String?,
  isVerified: json['isVerified'] as bool? ?? false,
  verifiedBy: json['verifiedBy'] as String?,
  verifiedAt:
      json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
  hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
);

Map<String, dynamic> _$$CustomerTransactionImplToJson(
  _$CustomerTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'customerId': instance.customerId,
  'transactionType': instance.transactionType,
  'transactionDate': instance.transactionDate.toIso8601String(),
  'referenceType': instance.referenceType,
  'referenceId': instance.referenceId,
  'referenceNumber': instance.referenceNumber,
  'amount': instance.amount,
  'balanceBefore': instance.balanceBefore,
  'balanceAfter': instance.balanceAfter,
  'paymentMethodId': instance.paymentMethodId,
  'paymentReference': instance.paymentReference,
  'paymentDate': instance.paymentDate?.toIso8601String(),
  'chequeNumber': instance.chequeNumber,
  'chequeDate': instance.chequeDate?.toIso8601String(),
  'chequeStatus': instance.chequeStatus,
  'bankName': instance.bankName,
  'description': instance.description,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'isVerified': instance.isVerified,
  'verifiedBy': instance.verifiedBy,
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};
