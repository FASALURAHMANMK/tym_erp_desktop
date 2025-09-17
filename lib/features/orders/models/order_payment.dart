import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_payment.freezed.dart';
part 'order_payment.g.dart';

@freezed
class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    // Identification
    required String id,
    required String orderId,
    
    // Payment Method (snapshot)
    required String paymentMethodId,
    required String paymentMethodName,
    required String paymentMethodCode,
    
    // Amounts
    required double amount,
    @Default(0) double tipAmount,
    @Default(0) double processingFee,
    required double totalAmount, // amount + tipAmount + processingFee
    
    // Status
    @Default('pending') String status, // pending, completed, failed, refunded
    
    // Reference Information
    String? referenceNumber, // Check number, transaction ID, etc.
    String? transactionId, // Payment gateway transaction ID
    String? approvalCode, // For card payments
    
    // Card Information (if applicable)
    String? cardLastFour,
    String? cardType, // visa, mastercard, etc.
    
    // Timestamps
    required DateTime paidAt,
    DateTime? refundedAt,
    
    // Refund Information
    @Default(0) double refundedAmount,
    String? refundReason,
    String? refundedBy,
    String? refundTransactionId,
    
    // Staff Information
    required String processedBy, // User ID who processed payment
    String? processedByName, // Snapshot
    
    // Notes
    String? notes,
    
    // Metadata
    Map<String, dynamic>? metadata, // For gateway-specific data
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderPayment;

  factory OrderPayment.fromJson(Map<String, dynamic> json) => 
      _$OrderPaymentFromJson(json);
  
  const OrderPayment._();
  
  // Check if payment is successful
  bool get isSuccessful => status == 'completed';
  
  // Check if payment is refunded
  bool get isRefunded => status == 'refunded' || refundedAmount > 0;
  
  // Check if payment is pending
  bool get isPending => status == 'pending';
  
  // Check if payment failed
  bool get isFailed => status == 'failed';
  
  // Get remaining amount after refund
  double get remainingAmount => totalAmount - refundedAmount;
  
  // Check if fully refunded
  bool get isFullyRefunded => refundedAmount >= totalAmount;
  
  // Check if partially refunded
  bool get isPartiallyRefunded => refundedAmount > 0 && refundedAmount < totalAmount;
  
  // Check if payment requires reference
  bool get requiresReference {
    return paymentMethodCode != 'cash' && paymentMethodCode != 'customer_credit';
  }
  
  // Get status color for UI
  String get statusColor {
    switch (status) {
      case 'pending':
        return 'orange';
      case 'completed':
        return 'green';
      case 'failed':
        return 'red';
      case 'refunded':
        return 'purple';
      default:
        return 'grey';
    }
  }
  
  // Get display status
  String get displayStatus {
    if (isPartiallyRefunded) {
      return 'Partial Refund';
    }
    if (isFullyRefunded) {
      return 'Refunded';
    }
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Paid';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }
}