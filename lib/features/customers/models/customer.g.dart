// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      groupId: json['groupId'] as String?,
      customerCode: json['customerCode'] as String,
      name: json['name'] as String,
      companyName: json['companyName'] as String?,
      customerType: json['customerType'] as String? ?? 'individual',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      alternatePhone: json['alternatePhone'] as String?,
      whatsappNumber: json['whatsappNumber'] as String?,
      website: json['website'] as String?,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      shippingAddressLine1: json['shippingAddressLine1'] as String?,
      shippingAddressLine2: json['shippingAddressLine2'] as String?,
      shippingCity: json['shippingCity'] as String?,
      shippingState: json['shippingState'] as String?,
      shippingPostalCode: json['shippingPostalCode'] as String?,
      shippingCountry: json['shippingCountry'] as String?,
      useBillingForShipping: json['useBillingForShipping'] as bool? ?? true,
      taxId: json['taxId'] as String?,
      taxExempt: json['taxExempt'] as bool? ?? false,
      taxExemptReason: json['taxExemptReason'] as String?,
      creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0,
      currentCredit: (json['currentCredit'] as num?)?.toDouble() ?? 0,
      paymentTerms: (json['paymentTerms'] as num?)?.toInt() ?? 0,
      creditStatus: json['creditStatus'] as String? ?? 'active',
      creditNotes: json['creditNotes'] as String?,
      priceCategoryId: json['priceCategoryId'] as String?,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0,
      loyaltyPoints: (json['loyaltyPoints'] as num?)?.toInt() ?? 0,
      loyaltyTier: json['loyaltyTier'] as String?,
      membershipNumber: json['membershipNumber'] as String?,
      membershipExpiry:
          json['membershipExpiry'] == null
              ? null
              : DateTime.parse(json['membershipExpiry'] as String),
      dateOfBirth:
          json['dateOfBirth'] == null
              ? null
              : DateTime.parse(json['dateOfBirth'] as String),
      anniversaryDate:
          json['anniversaryDate'] == null
              ? null
              : DateTime.parse(json['anniversaryDate'] as String),
      firstPurchaseDate:
          json['firstPurchaseDate'] == null
              ? null
              : DateTime.parse(json['firstPurchaseDate'] as String),
      lastPurchaseDate:
          json['lastPurchaseDate'] == null
              ? null
              : DateTime.parse(json['lastPurchaseDate'] as String),
      totalPurchases: (json['totalPurchases'] as num?)?.toDouble() ?? 0,
      totalPayments: (json['totalPayments'] as num?)?.toDouble() ?? 0,
      purchaseCount: (json['purchaseCount'] as num?)?.toInt() ?? 0,
      averageOrderValue: (json['averageOrderValue'] as num?)?.toDouble() ?? 0,
      preferredContactMethod: json['preferredContactMethod'] as String?,
      languagePreference: json['languagePreference'] as String? ?? 'en',
      currencyPreference: json['currencyPreference'] as String? ?? 'INR',
      marketingConsent: json['marketingConsent'] as bool? ?? false,
      smsConsent: json['smsConsent'] as bool? ?? false,
      emailConsent: json['emailConsent'] as bool? ?? false,
      notes: json['notes'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      isBlacklisted: json['isBlacklisted'] as bool? ?? false,
      blacklistReason: json['blacklistReason'] as String?,
      isVip: json['isVip'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'groupId': instance.groupId,
      'customerCode': instance.customerCode,
      'name': instance.name,
      'companyName': instance.companyName,
      'customerType': instance.customerType,
      'email': instance.email,
      'phone': instance.phone,
      'alternatePhone': instance.alternatePhone,
      'whatsappNumber': instance.whatsappNumber,
      'website': instance.website,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'shippingAddressLine1': instance.shippingAddressLine1,
      'shippingAddressLine2': instance.shippingAddressLine2,
      'shippingCity': instance.shippingCity,
      'shippingState': instance.shippingState,
      'shippingPostalCode': instance.shippingPostalCode,
      'shippingCountry': instance.shippingCountry,
      'useBillingForShipping': instance.useBillingForShipping,
      'taxId': instance.taxId,
      'taxExempt': instance.taxExempt,
      'taxExemptReason': instance.taxExemptReason,
      'creditLimit': instance.creditLimit,
      'currentCredit': instance.currentCredit,
      'paymentTerms': instance.paymentTerms,
      'creditStatus': instance.creditStatus,
      'creditNotes': instance.creditNotes,
      'priceCategoryId': instance.priceCategoryId,
      'discountPercent': instance.discountPercent,
      'loyaltyPoints': instance.loyaltyPoints,
      'loyaltyTier': instance.loyaltyTier,
      'membershipNumber': instance.membershipNumber,
      'membershipExpiry': instance.membershipExpiry?.toIso8601String(),
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'anniversaryDate': instance.anniversaryDate?.toIso8601String(),
      'firstPurchaseDate': instance.firstPurchaseDate?.toIso8601String(),
      'lastPurchaseDate': instance.lastPurchaseDate?.toIso8601String(),
      'totalPurchases': instance.totalPurchases,
      'totalPayments': instance.totalPayments,
      'purchaseCount': instance.purchaseCount,
      'averageOrderValue': instance.averageOrderValue,
      'preferredContactMethod': instance.preferredContactMethod,
      'languagePreference': instance.languagePreference,
      'currencyPreference': instance.currencyPreference,
      'marketingConsent': instance.marketingConsent,
      'smsConsent': instance.smsConsent,
      'emailConsent': instance.emailConsent,
      'notes': instance.notes,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'isBlacklisted': instance.isBlacklisted,
      'blacklistReason': instance.blacklistReason,
      'isVip': instance.isVip,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'lastModifiedBy': instance.lastModifiedBy,
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };
