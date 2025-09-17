import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method.freezed.dart';
part 'payment_method.g.dart';

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required String businessId,
    required String name,
    required String code, // Unique code like 'cash', 'card', 'upi'
    String? icon, // Icon identifier for UI
    @Default(true) bool isActive,
    @Default(false) bool isDefault, // For system default payment methods
    @Default(false) bool requiresReference, // If true, requires reference number
    @Default(false) bool requiresApproval, // If true, requires manager approval
    @Default(0) int displayOrder,
    @Default({}) Map<String, dynamic> settings, // Additional settings
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    @Default(false) bool hasUnsyncedChanges, // For offline sync
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  const PaymentMethod._();

  // Check if this is a system default payment method
  bool get isSystemDefault => isDefault && ['cash', 'card', 'customer_credit', 'cheque'].contains(code);

  // Get display icon based on code
  String get displayIcon {
    if (icon != null && icon!.isNotEmpty) return icon!;
    
    switch (code) {
      case 'cash':
        return 'cash';
      case 'card':
        return 'credit_card';
      case 'customer_credit':
        return 'account_balance';
      case 'cheque':
        return 'receipt';
      case 'upi':
        return 'smartphone';
      case 'bank_transfer':
        return 'account_balance_wallet';
      case 'wallet':
        return 'wallet';
      default:
        return 'payment';
    }
  }

  // Create default payment methods
  static List<PaymentMethod> createDefaults(String businessId) {
    final now = DateTime.now();
    return [
      PaymentMethod(
        id: 'default_cash_$businessId',
        businessId: businessId,
        name: 'Cash',
        code: 'cash',
        icon: 'cash',
        isDefault: true,
        displayOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      PaymentMethod(
        id: 'default_card_$businessId',
        businessId: businessId,
        name: 'Card',
        code: 'card',
        icon: 'credit_card',
        isDefault: true,
        displayOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      PaymentMethod(
        id: 'default_customer_credit_$businessId',
        businessId: businessId,
        name: 'Customer Credit',
        code: 'customer_credit',
        icon: 'account_balance',
        isDefault: true,
        displayOrder: 3,
        createdAt: now,
        updatedAt: now,
      ),
      PaymentMethod(
        id: 'default_cheque_$businessId',
        businessId: businessId,
        name: 'Cheque',
        code: 'cheque',
        icon: 'receipt',
        isDefault: true,
        requiresReference: true,
        displayOrder: 4,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}