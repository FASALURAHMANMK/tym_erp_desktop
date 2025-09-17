import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String businessId,
    String? groupId,
    
    // Basic Information
    required String customerCode,
    required String name,
    String? companyName,
    @Default('individual') String customerType, // 'individual', 'company', 'walk_in'
    
    // Contact Information
    String? email,
    String? phone,
    String? alternatePhone,
    String? whatsappNumber,  // Dedicated WhatsApp number for marketing & orders
    String? website,
    
    // Address Information
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    
    // Shipping Address
    String? shippingAddressLine1,
    String? shippingAddressLine2,
    String? shippingCity,
    String? shippingState,
    String? shippingPostalCode,
    String? shippingCountry,
    @Default(true) bool useBillingForShipping,
    
    // Tax Information
    String? taxId,
    @Default(false) bool taxExempt,
    String? taxExemptReason,
    
    // Credit Management
    @Default(0) double creditLimit,
    @Default(0) double currentCredit,
    @Default(0) int paymentTerms, // Days
    @Default('active') String creditStatus, // 'active', 'hold', 'blocked'
    String? creditNotes,
    
    // Pricing & Discounts
    String? priceCategoryId,
    @Default(0) double discountPercent,
    
    // Loyalty & Rewards
    @Default(0) int loyaltyPoints,
    String? loyaltyTier,
    String? membershipNumber,
    DateTime? membershipExpiry,
    
    // Important Dates
    DateTime? dateOfBirth,
    DateTime? anniversaryDate,
    DateTime? firstPurchaseDate,
    DateTime? lastPurchaseDate,
    
    // Business Metrics
    @Default(0) double totalPurchases,
    @Default(0) double totalPayments,
    @Default(0) int purchaseCount,
    @Default(0) double averageOrderValue,
    
    // Preferences
    String? preferredContactMethod, // 'email', 'phone', 'sms', 'whatsapp'
    @Default('en') String languagePreference,
    @Default('INR') String currencyPreference,
    @Default(false) bool marketingConsent,
    @Default(false) bool smsConsent,
    @Default(false) bool emailConsent,
    
    // Internal Notes
    String? notes,
    @Default([]) List<String> tags,
    
    // Status and Flags
    @Default(true) bool isActive,
    @Default(false) bool isBlacklisted,
    String? blacklistReason,
    @Default(false) bool isVip,
    
    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    String? lastModifiedBy,
    
    // Offline sync
    @Default(false) bool hasUnsyncedChanges,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  
  // Helper methods
  const Customer._();
  
  bool get canExtendCredit {
    if (creditStatus == 'blocked' || creditStatus == 'hold') return false;
    if (creditLimit <= 0) return false;
    return currentCredit < creditLimit;
  }
  
  double get availableCredit {
    if (creditLimit <= 0) return 0;
    final available = creditLimit - currentCredit;
    return available > 0 ? available : 0;
  }
  
  bool get isOverCreditLimit {
    return creditLimit > 0 && currentCredit > creditLimit;
  }
  
  String get displayName {
    if (companyName != null && companyName!.isNotEmpty) {
      return '$companyName ($name)';
    }
    return name;
  }
  
  String get fullAddress {
    final parts = <String>[];
    if (addressLine1 != null) parts.add(addressLine1!);
    if (addressLine2 != null) parts.add(addressLine2!);
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (postalCode != null) parts.add(postalCode!);
    if (country != null) parts.add(country!);
    return parts.join(', ');
  }
  
  String get fullShippingAddress {
    if (useBillingForShipping) return fullAddress;
    
    final parts = <String>[];
    if (shippingAddressLine1 != null) parts.add(shippingAddressLine1!);
    if (shippingAddressLine2 != null) parts.add(shippingAddressLine2!);
    if (shippingCity != null) parts.add(shippingCity!);
    if (shippingState != null) parts.add(shippingState!);
    if (shippingPostalCode != null) parts.add(shippingPostalCode!);
    if (shippingCountry != null) parts.add(shippingCountry!);
    return parts.join(', ');
  }
  
  // WhatsApp helpers
  String? get effectiveWhatsAppNumber {
    // Return WhatsApp number if available, otherwise use primary phone
    return whatsappNumber?.isNotEmpty == true ? whatsappNumber : phone;
  }
  
  bool get hasWhatsApp {
    return effectiveWhatsAppNumber?.isNotEmpty == true;
  }
  
  String? get formattedWhatsAppNumber {
    final number = effectiveWhatsAppNumber;
    if (number == null) return null;
    
    // Remove any non-digit characters
    final cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Ensure it starts with country code (default to India +91 if not present)
    if (!cleaned.startsWith('+')) {
      if (cleaned.length == 10) {
        // Indian number without country code
        return '+91$cleaned';
      }
      // Already has country code without +
      return '+$cleaned';
    }
    
    return cleaned;
  }
  
  String? get whatsAppUrl {
    final number = formattedWhatsAppNumber;
    if (number == null) return null;
    return 'https://wa.me/${number.substring(1)}'; // Remove + for URL
  }
  
  bool get canReceiveWhatsAppMarketing {
    return hasWhatsApp && marketingConsent && preferredContactMethod == 'whatsapp';
  }
  
  // Create default walk-in customer
  static Customer createWalkInCustomer(String businessId) {
    final now = DateTime.now();
    // Use a deterministic UUID v5 based on business ID for walk-in customer
    // This ensures the same walk-in customer ID for the same business
    const namespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8'; // Standard namespace UUID
    final walkInId = const Uuid().v5(namespace, 'walk_in_$businessId');
    
    return Customer(
      id: walkInId,
      businessId: businessId,
      customerCode: 'WALK-IN',
      name: 'Walk-in Customer',
      customerType: 'walk_in',
      creditLimit: 0,
      paymentTerms: 0,
      createdAt: now,
      updatedAt: now,
    );
  }
}