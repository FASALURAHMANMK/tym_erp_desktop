import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_payment.freezed.dart';

@freezed
class SubscriptionPayment with _$SubscriptionPayment {
  const factory SubscriptionPayment({
    required String id,
    required String subscriptionId,
    required double amount,
    required String currency,
    required String paymentMethod,
    String? paymentReference,
    required DateTime paymentDate,
    String? verifiedBy,
    String? notes,
    required DateTime createdAt,
  }) = _SubscriptionPayment;

  const SubscriptionPayment._();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_id': subscriptionId,
      'amount': amount,
      'currency': currency,
      'payment_method': paymentMethod,
      'payment_reference': paymentReference,
      'payment_date': paymentDate.toIso8601String(),
      'verified_by': verifiedBy,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SubscriptionPayment.fromJson(Map<String, dynamic> json) {
    return SubscriptionPayment(
      id: json['id'] as String,
      subscriptionId: json['subscription_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentReference: json['payment_reference'] as String?,
      paymentDate: DateTime.parse(json['payment_date'] as String),
      verifiedBy: json['verified_by'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

enum PaymentMethod {
  bankTransfer('Bank Transfer'),
  upi('UPI'),
  card('Credit/Debit Card'),
  cash('Cash'),
  cheque('Cheque'),
  gateway('Payment Gateway');

  const PaymentMethod(this.displayName);
  final String displayName;
}

extension SubscriptionPaymentExtension on SubscriptionPayment {
  String get formattedAmount {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'SAR':
        return 'ر.س';
      case 'AED':
        return 'د.إ';
      default:
        return currency;
    }
  }

  bool get isVerified => verifiedBy != null;
}