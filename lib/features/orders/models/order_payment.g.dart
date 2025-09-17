// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderPaymentImpl _$$OrderPaymentImplFromJson(Map<String, dynamic> json) =>
    _$OrderPaymentImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
      paymentMethodName: json['paymentMethodName'] as String,
      paymentMethodCode: json['paymentMethodCode'] as String,
      amount: (json['amount'] as num).toDouble(),
      tipAmount: (json['tipAmount'] as num?)?.toDouble() ?? 0,
      processingFee: (json['processingFee'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      referenceNumber: json['referenceNumber'] as String?,
      transactionId: json['transactionId'] as String?,
      approvalCode: json['approvalCode'] as String?,
      cardLastFour: json['cardLastFour'] as String?,
      cardType: json['cardType'] as String?,
      paidAt: DateTime.parse(json['paidAt'] as String),
      refundedAt:
          json['refundedAt'] == null
              ? null
              : DateTime.parse(json['refundedAt'] as String),
      refundedAmount: (json['refundedAmount'] as num?)?.toDouble() ?? 0,
      refundReason: json['refundReason'] as String?,
      refundedBy: json['refundedBy'] as String?,
      refundTransactionId: json['refundTransactionId'] as String?,
      processedBy: json['processedBy'] as String,
      processedByName: json['processedByName'] as String?,
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OrderPaymentImplToJson(_$OrderPaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'paymentMethodId': instance.paymentMethodId,
      'paymentMethodName': instance.paymentMethodName,
      'paymentMethodCode': instance.paymentMethodCode,
      'amount': instance.amount,
      'tipAmount': instance.tipAmount,
      'processingFee': instance.processingFee,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'referenceNumber': instance.referenceNumber,
      'transactionId': instance.transactionId,
      'approvalCode': instance.approvalCode,
      'cardLastFour': instance.cardLastFour,
      'cardType': instance.cardType,
      'paidAt': instance.paidAt.toIso8601String(),
      'refundedAt': instance.refundedAt?.toIso8601String(),
      'refundedAmount': instance.refundedAmount,
      'refundReason': instance.refundReason,
      'refundedBy': instance.refundedBy,
      'refundTransactionId': instance.refundTransactionId,
      'processedBy': instance.processedBy,
      'processedByName': instance.processedByName,
      'notes': instance.notes,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
