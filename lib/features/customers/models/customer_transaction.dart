import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_transaction.freezed.dart';
part 'customer_transaction.g.dart';

@freezed
class CustomerTransaction with _$CustomerTransaction {
  const factory CustomerTransaction({
    required String id,
    required String businessId,
    required String customerId,
    
    // Transaction Details
    required String transactionType, // 'sale', 'payment', 'credit_note', 'debit_note', 'opening_balance'
    required DateTime transactionDate,
    
    // Reference Information
    String? referenceType, // 'order', 'invoice', 'payment', 'manual'
    String? referenceId,
    String? referenceNumber,
    
    // Amounts
    required double amount, // Positive for debit, negative for credit
    required double balanceBefore,
    required double balanceAfter,
    
    // Payment Details
    String? paymentMethodId,
    String? paymentReference,
    DateTime? paymentDate,
    
    // Cheque Details
    String? chequeNumber,
    DateTime? chequeDate,
    @Default('pending') String? chequeStatus, // 'pending', 'cleared', 'bounced', 'cancelled'
    String? bankName,
    
    // Additional Information
    String? description,
    String? notes,
    
    // Metadata
    required DateTime createdAt,
    String? createdBy,
    @Default(false) bool isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    
    // Offline sync
    @Default(false) bool hasUnsyncedChanges,
  }) = _CustomerTransaction;

  factory CustomerTransaction.fromJson(Map<String, dynamic> json) =>
      _$CustomerTransactionFromJson(json);
  
  // Helper methods
  const CustomerTransaction._();
  
  bool get isDebit => amount > 0;
  bool get isCredit => amount < 0;
  
  String get transactionTypeDisplay {
    switch (transactionType) {
      case 'sale':
        return 'Sale';
      case 'payment':
        return 'Payment';
      case 'credit_note':
        return 'Credit Note';
      case 'debit_note':
        return 'Debit Note';
      case 'opening_balance':
        return 'Opening Balance';
      default:
        return transactionType;
    }
  }
  
  String get chequeStatusDisplay {
    switch (chequeStatus) {
      case 'pending':
        return 'Pending';
      case 'cleared':
        return 'Cleared';
      case 'bounced':
        return 'Bounced';
      case 'cancelled':
        return 'Cancelled';
      default:
        return chequeStatus ?? '';
    }
  }
  
  bool get isChequeTransaction => chequeNumber != null && chequeNumber!.isNotEmpty;
  bool get isPendingCheque => isChequeTransaction && chequeStatus == 'pending';
}