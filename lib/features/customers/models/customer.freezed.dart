// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  String get id => throw _privateConstructorUsedError;
  String get businessId => throw _privateConstructorUsedError;
  String? get groupId =>
      throw _privateConstructorUsedError; // Basic Information
  String get customerCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get companyName => throw _privateConstructorUsedError;
  String get customerType =>
      throw _privateConstructorUsedError; // 'individual', 'company', 'walk_in'
  // Contact Information
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get alternatePhone => throw _privateConstructorUsedError;
  String? get whatsappNumber =>
      throw _privateConstructorUsedError; // Dedicated WhatsApp number for marketing & orders
  String? get website =>
      throw _privateConstructorUsedError; // Address Information
  String? get addressLine1 => throw _privateConstructorUsedError;
  String? get addressLine2 => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError; // Shipping Address
  String? get shippingAddressLine1 => throw _privateConstructorUsedError;
  String? get shippingAddressLine2 => throw _privateConstructorUsedError;
  String? get shippingCity => throw _privateConstructorUsedError;
  String? get shippingState => throw _privateConstructorUsedError;
  String? get shippingPostalCode => throw _privateConstructorUsedError;
  String? get shippingCountry => throw _privateConstructorUsedError;
  bool get useBillingForShipping =>
      throw _privateConstructorUsedError; // Tax Information
  String? get taxId => throw _privateConstructorUsedError;
  bool get taxExempt => throw _privateConstructorUsedError;
  String? get taxExemptReason =>
      throw _privateConstructorUsedError; // Credit Management
  double get creditLimit => throw _privateConstructorUsedError;
  double get currentCredit => throw _privateConstructorUsedError;
  int get paymentTerms => throw _privateConstructorUsedError; // Days
  String get creditStatus =>
      throw _privateConstructorUsedError; // 'active', 'hold', 'blocked'
  String? get creditNotes =>
      throw _privateConstructorUsedError; // Pricing & Discounts
  String? get priceCategoryId => throw _privateConstructorUsedError;
  double get discountPercent =>
      throw _privateConstructorUsedError; // Loyalty & Rewards
  int get loyaltyPoints => throw _privateConstructorUsedError;
  String? get loyaltyTier => throw _privateConstructorUsedError;
  String? get membershipNumber => throw _privateConstructorUsedError;
  DateTime? get membershipExpiry =>
      throw _privateConstructorUsedError; // Important Dates
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  DateTime? get anniversaryDate => throw _privateConstructorUsedError;
  DateTime? get firstPurchaseDate => throw _privateConstructorUsedError;
  DateTime? get lastPurchaseDate =>
      throw _privateConstructorUsedError; // Business Metrics
  double get totalPurchases => throw _privateConstructorUsedError;
  double get totalPayments => throw _privateConstructorUsedError;
  int get purchaseCount => throw _privateConstructorUsedError;
  double get averageOrderValue =>
      throw _privateConstructorUsedError; // Preferences
  String? get preferredContactMethod =>
      throw _privateConstructorUsedError; // 'email', 'phone', 'sms', 'whatsapp'
  String get languagePreference => throw _privateConstructorUsedError;
  String get currencyPreference => throw _privateConstructorUsedError;
  bool get marketingConsent => throw _privateConstructorUsedError;
  bool get smsConsent => throw _privateConstructorUsedError;
  bool get emailConsent => throw _privateConstructorUsedError; // Internal Notes
  String? get notes => throw _privateConstructorUsedError;
  List<String> get tags =>
      throw _privateConstructorUsedError; // Status and Flags
  bool get isActive => throw _privateConstructorUsedError;
  bool get isBlacklisted => throw _privateConstructorUsedError;
  String? get blacklistReason => throw _privateConstructorUsedError;
  bool get isVip => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get lastModifiedBy =>
      throw _privateConstructorUsedError; // Offline sync
  bool get hasUnsyncedChanges => throw _privateConstructorUsedError;

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call({
    String id,
    String businessId,
    String? groupId,
    String customerCode,
    String name,
    String? companyName,
    String customerType,
    String? email,
    String? phone,
    String? alternatePhone,
    String? whatsappNumber,
    String? website,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? shippingAddressLine1,
    String? shippingAddressLine2,
    String? shippingCity,
    String? shippingState,
    String? shippingPostalCode,
    String? shippingCountry,
    bool useBillingForShipping,
    String? taxId,
    bool taxExempt,
    String? taxExemptReason,
    double creditLimit,
    double currentCredit,
    int paymentTerms,
    String creditStatus,
    String? creditNotes,
    String? priceCategoryId,
    double discountPercent,
    int loyaltyPoints,
    String? loyaltyTier,
    String? membershipNumber,
    DateTime? membershipExpiry,
    DateTime? dateOfBirth,
    DateTime? anniversaryDate,
    DateTime? firstPurchaseDate,
    DateTime? lastPurchaseDate,
    double totalPurchases,
    double totalPayments,
    int purchaseCount,
    double averageOrderValue,
    String? preferredContactMethod,
    String languagePreference,
    String currencyPreference,
    bool marketingConsent,
    bool smsConsent,
    bool emailConsent,
    String? notes,
    List<String> tags,
    bool isActive,
    bool isBlacklisted,
    String? blacklistReason,
    bool isVip,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    String? lastModifiedBy,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? groupId = freezed,
    Object? customerCode = null,
    Object? name = null,
    Object? companyName = freezed,
    Object? customerType = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? alternatePhone = freezed,
    Object? whatsappNumber = freezed,
    Object? website = freezed,
    Object? addressLine1 = freezed,
    Object? addressLine2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? shippingAddressLine1 = freezed,
    Object? shippingAddressLine2 = freezed,
    Object? shippingCity = freezed,
    Object? shippingState = freezed,
    Object? shippingPostalCode = freezed,
    Object? shippingCountry = freezed,
    Object? useBillingForShipping = null,
    Object? taxId = freezed,
    Object? taxExempt = null,
    Object? taxExemptReason = freezed,
    Object? creditLimit = null,
    Object? currentCredit = null,
    Object? paymentTerms = null,
    Object? creditStatus = null,
    Object? creditNotes = freezed,
    Object? priceCategoryId = freezed,
    Object? discountPercent = null,
    Object? loyaltyPoints = null,
    Object? loyaltyTier = freezed,
    Object? membershipNumber = freezed,
    Object? membershipExpiry = freezed,
    Object? dateOfBirth = freezed,
    Object? anniversaryDate = freezed,
    Object? firstPurchaseDate = freezed,
    Object? lastPurchaseDate = freezed,
    Object? totalPurchases = null,
    Object? totalPayments = null,
    Object? purchaseCount = null,
    Object? averageOrderValue = null,
    Object? preferredContactMethod = freezed,
    Object? languagePreference = null,
    Object? currencyPreference = null,
    Object? marketingConsent = null,
    Object? smsConsent = null,
    Object? emailConsent = null,
    Object? notes = freezed,
    Object? tags = null,
    Object? isActive = null,
    Object? isBlacklisted = null,
    Object? blacklistReason = freezed,
    Object? isVip = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? lastModifiedBy = freezed,
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
            groupId:
                freezed == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerCode:
                null == customerCode
                    ? _value.customerCode
                    : customerCode // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            companyName:
                freezed == companyName
                    ? _value.companyName
                    : companyName // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerType:
                null == customerType
                    ? _value.customerType
                    : customerType // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            alternatePhone:
                freezed == alternatePhone
                    ? _value.alternatePhone
                    : alternatePhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            whatsappNumber:
                freezed == whatsappNumber
                    ? _value.whatsappNumber
                    : whatsappNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            website:
                freezed == website
                    ? _value.website
                    : website // ignore: cast_nullable_to_non_nullable
                        as String?,
            addressLine1:
                freezed == addressLine1
                    ? _value.addressLine1
                    : addressLine1 // ignore: cast_nullable_to_non_nullable
                        as String?,
            addressLine2:
                freezed == addressLine2
                    ? _value.addressLine2
                    : addressLine2 // ignore: cast_nullable_to_non_nullable
                        as String?,
            city:
                freezed == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String?,
            state:
                freezed == state
                    ? _value.state
                    : state // ignore: cast_nullable_to_non_nullable
                        as String?,
            postalCode:
                freezed == postalCode
                    ? _value.postalCode
                    : postalCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            country:
                freezed == country
                    ? _value.country
                    : country // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingAddressLine1:
                freezed == shippingAddressLine1
                    ? _value.shippingAddressLine1
                    : shippingAddressLine1 // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingAddressLine2:
                freezed == shippingAddressLine2
                    ? _value.shippingAddressLine2
                    : shippingAddressLine2 // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingCity:
                freezed == shippingCity
                    ? _value.shippingCity
                    : shippingCity // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingState:
                freezed == shippingState
                    ? _value.shippingState
                    : shippingState // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingPostalCode:
                freezed == shippingPostalCode
                    ? _value.shippingPostalCode
                    : shippingPostalCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingCountry:
                freezed == shippingCountry
                    ? _value.shippingCountry
                    : shippingCountry // ignore: cast_nullable_to_non_nullable
                        as String?,
            useBillingForShipping:
                null == useBillingForShipping
                    ? _value.useBillingForShipping
                    : useBillingForShipping // ignore: cast_nullable_to_non_nullable
                        as bool,
            taxId:
                freezed == taxId
                    ? _value.taxId
                    : taxId // ignore: cast_nullable_to_non_nullable
                        as String?,
            taxExempt:
                null == taxExempt
                    ? _value.taxExempt
                    : taxExempt // ignore: cast_nullable_to_non_nullable
                        as bool,
            taxExemptReason:
                freezed == taxExemptReason
                    ? _value.taxExemptReason
                    : taxExemptReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            creditLimit:
                null == creditLimit
                    ? _value.creditLimit
                    : creditLimit // ignore: cast_nullable_to_non_nullable
                        as double,
            currentCredit:
                null == currentCredit
                    ? _value.currentCredit
                    : currentCredit // ignore: cast_nullable_to_non_nullable
                        as double,
            paymentTerms:
                null == paymentTerms
                    ? _value.paymentTerms
                    : paymentTerms // ignore: cast_nullable_to_non_nullable
                        as int,
            creditStatus:
                null == creditStatus
                    ? _value.creditStatus
                    : creditStatus // ignore: cast_nullable_to_non_nullable
                        as String,
            creditNotes:
                freezed == creditNotes
                    ? _value.creditNotes
                    : creditNotes // ignore: cast_nullable_to_non_nullable
                        as String?,
            priceCategoryId:
                freezed == priceCategoryId
                    ? _value.priceCategoryId
                    : priceCategoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            discountPercent:
                null == discountPercent
                    ? _value.discountPercent
                    : discountPercent // ignore: cast_nullable_to_non_nullable
                        as double,
            loyaltyPoints:
                null == loyaltyPoints
                    ? _value.loyaltyPoints
                    : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                        as int,
            loyaltyTier:
                freezed == loyaltyTier
                    ? _value.loyaltyTier
                    : loyaltyTier // ignore: cast_nullable_to_non_nullable
                        as String?,
            membershipNumber:
                freezed == membershipNumber
                    ? _value.membershipNumber
                    : membershipNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            membershipExpiry:
                freezed == membershipExpiry
                    ? _value.membershipExpiry
                    : membershipExpiry // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            dateOfBirth:
                freezed == dateOfBirth
                    ? _value.dateOfBirth
                    : dateOfBirth // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            anniversaryDate:
                freezed == anniversaryDate
                    ? _value.anniversaryDate
                    : anniversaryDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            firstPurchaseDate:
                freezed == firstPurchaseDate
                    ? _value.firstPurchaseDate
                    : firstPurchaseDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            lastPurchaseDate:
                freezed == lastPurchaseDate
                    ? _value.lastPurchaseDate
                    : lastPurchaseDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            totalPurchases:
                null == totalPurchases
                    ? _value.totalPurchases
                    : totalPurchases // ignore: cast_nullable_to_non_nullable
                        as double,
            totalPayments:
                null == totalPayments
                    ? _value.totalPayments
                    : totalPayments // ignore: cast_nullable_to_non_nullable
                        as double,
            purchaseCount:
                null == purchaseCount
                    ? _value.purchaseCount
                    : purchaseCount // ignore: cast_nullable_to_non_nullable
                        as int,
            averageOrderValue:
                null == averageOrderValue
                    ? _value.averageOrderValue
                    : averageOrderValue // ignore: cast_nullable_to_non_nullable
                        as double,
            preferredContactMethod:
                freezed == preferredContactMethod
                    ? _value.preferredContactMethod
                    : preferredContactMethod // ignore: cast_nullable_to_non_nullable
                        as String?,
            languagePreference:
                null == languagePreference
                    ? _value.languagePreference
                    : languagePreference // ignore: cast_nullable_to_non_nullable
                        as String,
            currencyPreference:
                null == currencyPreference
                    ? _value.currencyPreference
                    : currencyPreference // ignore: cast_nullable_to_non_nullable
                        as String,
            marketingConsent:
                null == marketingConsent
                    ? _value.marketingConsent
                    : marketingConsent // ignore: cast_nullable_to_non_nullable
                        as bool,
            smsConsent:
                null == smsConsent
                    ? _value.smsConsent
                    : smsConsent // ignore: cast_nullable_to_non_nullable
                        as bool,
            emailConsent:
                null == emailConsent
                    ? _value.emailConsent
                    : emailConsent // ignore: cast_nullable_to_non_nullable
                        as bool,
            notes:
                freezed == notes
                    ? _value.notes
                    : notes // ignore: cast_nullable_to_non_nullable
                        as String?,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            isBlacklisted:
                null == isBlacklisted
                    ? _value.isBlacklisted
                    : isBlacklisted // ignore: cast_nullable_to_non_nullable
                        as bool,
            blacklistReason:
                freezed == blacklistReason
                    ? _value.blacklistReason
                    : blacklistReason // ignore: cast_nullable_to_non_nullable
                        as String?,
            isVip:
                null == isVip
                    ? _value.isVip
                    : isVip // ignore: cast_nullable_to_non_nullable
                        as bool,
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
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastModifiedBy:
                freezed == lastModifiedBy
                    ? _value.lastModifiedBy
                    : lastModifiedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
    _$CustomerImpl value,
    $Res Function(_$CustomerImpl) then,
  ) = __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessId,
    String? groupId,
    String customerCode,
    String name,
    String? companyName,
    String customerType,
    String? email,
    String? phone,
    String? alternatePhone,
    String? whatsappNumber,
    String? website,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? shippingAddressLine1,
    String? shippingAddressLine2,
    String? shippingCity,
    String? shippingState,
    String? shippingPostalCode,
    String? shippingCountry,
    bool useBillingForShipping,
    String? taxId,
    bool taxExempt,
    String? taxExemptReason,
    double creditLimit,
    double currentCredit,
    int paymentTerms,
    String creditStatus,
    String? creditNotes,
    String? priceCategoryId,
    double discountPercent,
    int loyaltyPoints,
    String? loyaltyTier,
    String? membershipNumber,
    DateTime? membershipExpiry,
    DateTime? dateOfBirth,
    DateTime? anniversaryDate,
    DateTime? firstPurchaseDate,
    DateTime? lastPurchaseDate,
    double totalPurchases,
    double totalPayments,
    int purchaseCount,
    double averageOrderValue,
    String? preferredContactMethod,
    String languagePreference,
    String currencyPreference,
    bool marketingConsent,
    bool smsConsent,
    bool emailConsent,
    String? notes,
    List<String> tags,
    bool isActive,
    bool isBlacklisted,
    String? blacklistReason,
    bool isVip,
    DateTime createdAt,
    DateTime updatedAt,
    String? createdBy,
    String? lastModifiedBy,
    bool hasUnsyncedChanges,
  });
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
    _$CustomerImpl _value,
    $Res Function(_$CustomerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? groupId = freezed,
    Object? customerCode = null,
    Object? name = null,
    Object? companyName = freezed,
    Object? customerType = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? alternatePhone = freezed,
    Object? whatsappNumber = freezed,
    Object? website = freezed,
    Object? addressLine1 = freezed,
    Object? addressLine2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? shippingAddressLine1 = freezed,
    Object? shippingAddressLine2 = freezed,
    Object? shippingCity = freezed,
    Object? shippingState = freezed,
    Object? shippingPostalCode = freezed,
    Object? shippingCountry = freezed,
    Object? useBillingForShipping = null,
    Object? taxId = freezed,
    Object? taxExempt = null,
    Object? taxExemptReason = freezed,
    Object? creditLimit = null,
    Object? currentCredit = null,
    Object? paymentTerms = null,
    Object? creditStatus = null,
    Object? creditNotes = freezed,
    Object? priceCategoryId = freezed,
    Object? discountPercent = null,
    Object? loyaltyPoints = null,
    Object? loyaltyTier = freezed,
    Object? membershipNumber = freezed,
    Object? membershipExpiry = freezed,
    Object? dateOfBirth = freezed,
    Object? anniversaryDate = freezed,
    Object? firstPurchaseDate = freezed,
    Object? lastPurchaseDate = freezed,
    Object? totalPurchases = null,
    Object? totalPayments = null,
    Object? purchaseCount = null,
    Object? averageOrderValue = null,
    Object? preferredContactMethod = freezed,
    Object? languagePreference = null,
    Object? currencyPreference = null,
    Object? marketingConsent = null,
    Object? smsConsent = null,
    Object? emailConsent = null,
    Object? notes = freezed,
    Object? tags = null,
    Object? isActive = null,
    Object? isBlacklisted = null,
    Object? blacklistReason = freezed,
    Object? isVip = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? lastModifiedBy = freezed,
    Object? hasUnsyncedChanges = null,
  }) {
    return _then(
      _$CustomerImpl(
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
        groupId:
            freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerCode:
            null == customerCode
                ? _value.customerCode
                : customerCode // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        companyName:
            freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerType:
            null == customerType
                ? _value.customerType
                : customerType // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        alternatePhone:
            freezed == alternatePhone
                ? _value.alternatePhone
                : alternatePhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        whatsappNumber:
            freezed == whatsappNumber
                ? _value.whatsappNumber
                : whatsappNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        website:
            freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                    as String?,
        addressLine1:
            freezed == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                    as String?,
        addressLine2:
            freezed == addressLine2
                ? _value.addressLine2
                : addressLine2 // ignore: cast_nullable_to_non_nullable
                    as String?,
        city:
            freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String?,
        state:
            freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                    as String?,
        postalCode:
            freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        country:
            freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingAddressLine1:
            freezed == shippingAddressLine1
                ? _value.shippingAddressLine1
                : shippingAddressLine1 // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingAddressLine2:
            freezed == shippingAddressLine2
                ? _value.shippingAddressLine2
                : shippingAddressLine2 // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingCity:
            freezed == shippingCity
                ? _value.shippingCity
                : shippingCity // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingState:
            freezed == shippingState
                ? _value.shippingState
                : shippingState // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingPostalCode:
            freezed == shippingPostalCode
                ? _value.shippingPostalCode
                : shippingPostalCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingCountry:
            freezed == shippingCountry
                ? _value.shippingCountry
                : shippingCountry // ignore: cast_nullable_to_non_nullable
                    as String?,
        useBillingForShipping:
            null == useBillingForShipping
                ? _value.useBillingForShipping
                : useBillingForShipping // ignore: cast_nullable_to_non_nullable
                    as bool,
        taxId:
            freezed == taxId
                ? _value.taxId
                : taxId // ignore: cast_nullable_to_non_nullable
                    as String?,
        taxExempt:
            null == taxExempt
                ? _value.taxExempt
                : taxExempt // ignore: cast_nullable_to_non_nullable
                    as bool,
        taxExemptReason:
            freezed == taxExemptReason
                ? _value.taxExemptReason
                : taxExemptReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        creditLimit:
            null == creditLimit
                ? _value.creditLimit
                : creditLimit // ignore: cast_nullable_to_non_nullable
                    as double,
        currentCredit:
            null == currentCredit
                ? _value.currentCredit
                : currentCredit // ignore: cast_nullable_to_non_nullable
                    as double,
        paymentTerms:
            null == paymentTerms
                ? _value.paymentTerms
                : paymentTerms // ignore: cast_nullable_to_non_nullable
                    as int,
        creditStatus:
            null == creditStatus
                ? _value.creditStatus
                : creditStatus // ignore: cast_nullable_to_non_nullable
                    as String,
        creditNotes:
            freezed == creditNotes
                ? _value.creditNotes
                : creditNotes // ignore: cast_nullable_to_non_nullable
                    as String?,
        priceCategoryId:
            freezed == priceCategoryId
                ? _value.priceCategoryId
                : priceCategoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        discountPercent:
            null == discountPercent
                ? _value.discountPercent
                : discountPercent // ignore: cast_nullable_to_non_nullable
                    as double,
        loyaltyPoints:
            null == loyaltyPoints
                ? _value.loyaltyPoints
                : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                    as int,
        loyaltyTier:
            freezed == loyaltyTier
                ? _value.loyaltyTier
                : loyaltyTier // ignore: cast_nullable_to_non_nullable
                    as String?,
        membershipNumber:
            freezed == membershipNumber
                ? _value.membershipNumber
                : membershipNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        membershipExpiry:
            freezed == membershipExpiry
                ? _value.membershipExpiry
                : membershipExpiry // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        dateOfBirth:
            freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        anniversaryDate:
            freezed == anniversaryDate
                ? _value.anniversaryDate
                : anniversaryDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        firstPurchaseDate:
            freezed == firstPurchaseDate
                ? _value.firstPurchaseDate
                : firstPurchaseDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        lastPurchaseDate:
            freezed == lastPurchaseDate
                ? _value.lastPurchaseDate
                : lastPurchaseDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        totalPurchases:
            null == totalPurchases
                ? _value.totalPurchases
                : totalPurchases // ignore: cast_nullable_to_non_nullable
                    as double,
        totalPayments:
            null == totalPayments
                ? _value.totalPayments
                : totalPayments // ignore: cast_nullable_to_non_nullable
                    as double,
        purchaseCount:
            null == purchaseCount
                ? _value.purchaseCount
                : purchaseCount // ignore: cast_nullable_to_non_nullable
                    as int,
        averageOrderValue:
            null == averageOrderValue
                ? _value.averageOrderValue
                : averageOrderValue // ignore: cast_nullable_to_non_nullable
                    as double,
        preferredContactMethod:
            freezed == preferredContactMethod
                ? _value.preferredContactMethod
                : preferredContactMethod // ignore: cast_nullable_to_non_nullable
                    as String?,
        languagePreference:
            null == languagePreference
                ? _value.languagePreference
                : languagePreference // ignore: cast_nullable_to_non_nullable
                    as String,
        currencyPreference:
            null == currencyPreference
                ? _value.currencyPreference
                : currencyPreference // ignore: cast_nullable_to_non_nullable
                    as String,
        marketingConsent:
            null == marketingConsent
                ? _value.marketingConsent
                : marketingConsent // ignore: cast_nullable_to_non_nullable
                    as bool,
        smsConsent:
            null == smsConsent
                ? _value.smsConsent
                : smsConsent // ignore: cast_nullable_to_non_nullable
                    as bool,
        emailConsent:
            null == emailConsent
                ? _value.emailConsent
                : emailConsent // ignore: cast_nullable_to_non_nullable
                    as bool,
        notes:
            freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                    as String?,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        isBlacklisted:
            null == isBlacklisted
                ? _value.isBlacklisted
                : isBlacklisted // ignore: cast_nullable_to_non_nullable
                    as bool,
        blacklistReason:
            freezed == blacklistReason
                ? _value.blacklistReason
                : blacklistReason // ignore: cast_nullable_to_non_nullable
                    as String?,
        isVip:
            null == isVip
                ? _value.isVip
                : isVip // ignore: cast_nullable_to_non_nullable
                    as bool,
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
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastModifiedBy:
            freezed == lastModifiedBy
                ? _value.lastModifiedBy
                : lastModifiedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$CustomerImpl extends _Customer {
  const _$CustomerImpl({
    required this.id,
    required this.businessId,
    this.groupId,
    required this.customerCode,
    required this.name,
    this.companyName,
    this.customerType = 'individual',
    this.email,
    this.phone,
    this.alternatePhone,
    this.whatsappNumber,
    this.website,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.shippingAddressLine1,
    this.shippingAddressLine2,
    this.shippingCity,
    this.shippingState,
    this.shippingPostalCode,
    this.shippingCountry,
    this.useBillingForShipping = true,
    this.taxId,
    this.taxExempt = false,
    this.taxExemptReason,
    this.creditLimit = 0,
    this.currentCredit = 0,
    this.paymentTerms = 0,
    this.creditStatus = 'active',
    this.creditNotes,
    this.priceCategoryId,
    this.discountPercent = 0,
    this.loyaltyPoints = 0,
    this.loyaltyTier,
    this.membershipNumber,
    this.membershipExpiry,
    this.dateOfBirth,
    this.anniversaryDate,
    this.firstPurchaseDate,
    this.lastPurchaseDate,
    this.totalPurchases = 0,
    this.totalPayments = 0,
    this.purchaseCount = 0,
    this.averageOrderValue = 0,
    this.preferredContactMethod,
    this.languagePreference = 'en',
    this.currencyPreference = 'INR',
    this.marketingConsent = false,
    this.smsConsent = false,
    this.emailConsent = false,
    this.notes,
    final List<String> tags = const [],
    this.isActive = true,
    this.isBlacklisted = false,
    this.blacklistReason,
    this.isVip = false,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.lastModifiedBy,
    this.hasUnsyncedChanges = false,
  }) : _tags = tags,
       super._();

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  final String id;
  @override
  final String businessId;
  @override
  final String? groupId;
  // Basic Information
  @override
  final String customerCode;
  @override
  final String name;
  @override
  final String? companyName;
  @override
  @JsonKey()
  final String customerType;
  // 'individual', 'company', 'walk_in'
  // Contact Information
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? alternatePhone;
  @override
  final String? whatsappNumber;
  // Dedicated WhatsApp number for marketing & orders
  @override
  final String? website;
  // Address Information
  @override
  final String? addressLine1;
  @override
  final String? addressLine2;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? postalCode;
  @override
  final String? country;
  // Shipping Address
  @override
  final String? shippingAddressLine1;
  @override
  final String? shippingAddressLine2;
  @override
  final String? shippingCity;
  @override
  final String? shippingState;
  @override
  final String? shippingPostalCode;
  @override
  final String? shippingCountry;
  @override
  @JsonKey()
  final bool useBillingForShipping;
  // Tax Information
  @override
  final String? taxId;
  @override
  @JsonKey()
  final bool taxExempt;
  @override
  final String? taxExemptReason;
  // Credit Management
  @override
  @JsonKey()
  final double creditLimit;
  @override
  @JsonKey()
  final double currentCredit;
  @override
  @JsonKey()
  final int paymentTerms;
  // Days
  @override
  @JsonKey()
  final String creditStatus;
  // 'active', 'hold', 'blocked'
  @override
  final String? creditNotes;
  // Pricing & Discounts
  @override
  final String? priceCategoryId;
  @override
  @JsonKey()
  final double discountPercent;
  // Loyalty & Rewards
  @override
  @JsonKey()
  final int loyaltyPoints;
  @override
  final String? loyaltyTier;
  @override
  final String? membershipNumber;
  @override
  final DateTime? membershipExpiry;
  // Important Dates
  @override
  final DateTime? dateOfBirth;
  @override
  final DateTime? anniversaryDate;
  @override
  final DateTime? firstPurchaseDate;
  @override
  final DateTime? lastPurchaseDate;
  // Business Metrics
  @override
  @JsonKey()
  final double totalPurchases;
  @override
  @JsonKey()
  final double totalPayments;
  @override
  @JsonKey()
  final int purchaseCount;
  @override
  @JsonKey()
  final double averageOrderValue;
  // Preferences
  @override
  final String? preferredContactMethod;
  // 'email', 'phone', 'sms', 'whatsapp'
  @override
  @JsonKey()
  final String languagePreference;
  @override
  @JsonKey()
  final String currencyPreference;
  @override
  @JsonKey()
  final bool marketingConsent;
  @override
  @JsonKey()
  final bool smsConsent;
  @override
  @JsonKey()
  final bool emailConsent;
  // Internal Notes
  @override
  final String? notes;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  // Status and Flags
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isBlacklisted;
  @override
  final String? blacklistReason;
  @override
  @JsonKey()
  final bool isVip;
  // Metadata
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;
  @override
  final String? lastModifiedBy;
  // Offline sync
  @override
  @JsonKey()
  final bool hasUnsyncedChanges;

  @override
  String toString() {
    return 'Customer(id: $id, businessId: $businessId, groupId: $groupId, customerCode: $customerCode, name: $name, companyName: $companyName, customerType: $customerType, email: $email, phone: $phone, alternatePhone: $alternatePhone, whatsappNumber: $whatsappNumber, website: $website, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, postalCode: $postalCode, country: $country, shippingAddressLine1: $shippingAddressLine1, shippingAddressLine2: $shippingAddressLine2, shippingCity: $shippingCity, shippingState: $shippingState, shippingPostalCode: $shippingPostalCode, shippingCountry: $shippingCountry, useBillingForShipping: $useBillingForShipping, taxId: $taxId, taxExempt: $taxExempt, taxExemptReason: $taxExemptReason, creditLimit: $creditLimit, currentCredit: $currentCredit, paymentTerms: $paymentTerms, creditStatus: $creditStatus, creditNotes: $creditNotes, priceCategoryId: $priceCategoryId, discountPercent: $discountPercent, loyaltyPoints: $loyaltyPoints, loyaltyTier: $loyaltyTier, membershipNumber: $membershipNumber, membershipExpiry: $membershipExpiry, dateOfBirth: $dateOfBirth, anniversaryDate: $anniversaryDate, firstPurchaseDate: $firstPurchaseDate, lastPurchaseDate: $lastPurchaseDate, totalPurchases: $totalPurchases, totalPayments: $totalPayments, purchaseCount: $purchaseCount, averageOrderValue: $averageOrderValue, preferredContactMethod: $preferredContactMethod, languagePreference: $languagePreference, currencyPreference: $currencyPreference, marketingConsent: $marketingConsent, smsConsent: $smsConsent, emailConsent: $emailConsent, notes: $notes, tags: $tags, isActive: $isActive, isBlacklisted: $isBlacklisted, blacklistReason: $blacklistReason, isVip: $isVip, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, hasUnsyncedChanges: $hasUnsyncedChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.customerCode, customerCode) ||
                other.customerCode == customerCode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.customerType, customerType) ||
                other.customerType == customerType) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.alternatePhone, alternatePhone) ||
                other.alternatePhone == alternatePhone) &&
            (identical(other.whatsappNumber, whatsappNumber) ||
                other.whatsappNumber == whatsappNumber) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.shippingAddressLine1, shippingAddressLine1) ||
                other.shippingAddressLine1 == shippingAddressLine1) &&
            (identical(other.shippingAddressLine2, shippingAddressLine2) ||
                other.shippingAddressLine2 == shippingAddressLine2) &&
            (identical(other.shippingCity, shippingCity) ||
                other.shippingCity == shippingCity) &&
            (identical(other.shippingState, shippingState) ||
                other.shippingState == shippingState) &&
            (identical(other.shippingPostalCode, shippingPostalCode) ||
                other.shippingPostalCode == shippingPostalCode) &&
            (identical(other.shippingCountry, shippingCountry) ||
                other.shippingCountry == shippingCountry) &&
            (identical(other.useBillingForShipping, useBillingForShipping) ||
                other.useBillingForShipping == useBillingForShipping) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.taxExempt, taxExempt) ||
                other.taxExempt == taxExempt) &&
            (identical(other.taxExemptReason, taxExemptReason) ||
                other.taxExemptReason == taxExemptReason) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.currentCredit, currentCredit) ||
                other.currentCredit == currentCredit) &&
            (identical(other.paymentTerms, paymentTerms) ||
                other.paymentTerms == paymentTerms) &&
            (identical(other.creditStatus, creditStatus) ||
                other.creditStatus == creditStatus) &&
            (identical(other.creditNotes, creditNotes) ||
                other.creditNotes == creditNotes) &&
            (identical(other.priceCategoryId, priceCategoryId) ||
                other.priceCategoryId == priceCategoryId) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.loyaltyPoints, loyaltyPoints) ||
                other.loyaltyPoints == loyaltyPoints) &&
            (identical(other.loyaltyTier, loyaltyTier) ||
                other.loyaltyTier == loyaltyTier) &&
            (identical(other.membershipNumber, membershipNumber) ||
                other.membershipNumber == membershipNumber) &&
            (identical(other.membershipExpiry, membershipExpiry) ||
                other.membershipExpiry == membershipExpiry) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.anniversaryDate, anniversaryDate) ||
                other.anniversaryDate == anniversaryDate) &&
            (identical(other.firstPurchaseDate, firstPurchaseDate) ||
                other.firstPurchaseDate == firstPurchaseDate) &&
            (identical(other.lastPurchaseDate, lastPurchaseDate) ||
                other.lastPurchaseDate == lastPurchaseDate) &&
            (identical(other.totalPurchases, totalPurchases) ||
                other.totalPurchases == totalPurchases) &&
            (identical(other.totalPayments, totalPayments) ||
                other.totalPayments == totalPayments) &&
            (identical(other.purchaseCount, purchaseCount) ||
                other.purchaseCount == purchaseCount) &&
            (identical(other.averageOrderValue, averageOrderValue) ||
                other.averageOrderValue == averageOrderValue) &&
            (identical(other.preferredContactMethod, preferredContactMethod) ||
                other.preferredContactMethod == preferredContactMethod) &&
            (identical(other.languagePreference, languagePreference) ||
                other.languagePreference == languagePreference) &&
            (identical(other.currencyPreference, currencyPreference) ||
                other.currencyPreference == currencyPreference) &&
            (identical(other.marketingConsent, marketingConsent) ||
                other.marketingConsent == marketingConsent) &&
            (identical(other.smsConsent, smsConsent) ||
                other.smsConsent == smsConsent) &&
            (identical(other.emailConsent, emailConsent) ||
                other.emailConsent == emailConsent) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isBlacklisted, isBlacklisted) ||
                other.isBlacklisted == isBlacklisted) &&
            (identical(other.blacklistReason, blacklistReason) ||
                other.blacklistReason == blacklistReason) &&
            (identical(other.isVip, isVip) || other.isVip == isVip) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy) &&
            (identical(other.hasUnsyncedChanges, hasUnsyncedChanges) ||
                other.hasUnsyncedChanges == hasUnsyncedChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessId,
    groupId,
    customerCode,
    name,
    companyName,
    customerType,
    email,
    phone,
    alternatePhone,
    whatsappNumber,
    website,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    shippingAddressLine1,
    shippingAddressLine2,
    shippingCity,
    shippingState,
    shippingPostalCode,
    shippingCountry,
    useBillingForShipping,
    taxId,
    taxExempt,
    taxExemptReason,
    creditLimit,
    currentCredit,
    paymentTerms,
    creditStatus,
    creditNotes,
    priceCategoryId,
    discountPercent,
    loyaltyPoints,
    loyaltyTier,
    membershipNumber,
    membershipExpiry,
    dateOfBirth,
    anniversaryDate,
    firstPurchaseDate,
    lastPurchaseDate,
    totalPurchases,
    totalPayments,
    purchaseCount,
    averageOrderValue,
    preferredContactMethod,
    languagePreference,
    currencyPreference,
    marketingConsent,
    smsConsent,
    emailConsent,
    notes,
    const DeepCollectionEquality().hash(_tags),
    isActive,
    isBlacklisted,
    blacklistReason,
    isVip,
    createdAt,
    updatedAt,
    createdBy,
    lastModifiedBy,
    hasUnsyncedChanges,
  ]);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerImplToJson(this);
  }
}

abstract class _Customer extends Customer {
  const factory _Customer({
    required final String id,
    required final String businessId,
    final String? groupId,
    required final String customerCode,
    required final String name,
    final String? companyName,
    final String customerType,
    final String? email,
    final String? phone,
    final String? alternatePhone,
    final String? whatsappNumber,
    final String? website,
    final String? addressLine1,
    final String? addressLine2,
    final String? city,
    final String? state,
    final String? postalCode,
    final String? country,
    final String? shippingAddressLine1,
    final String? shippingAddressLine2,
    final String? shippingCity,
    final String? shippingState,
    final String? shippingPostalCode,
    final String? shippingCountry,
    final bool useBillingForShipping,
    final String? taxId,
    final bool taxExempt,
    final String? taxExemptReason,
    final double creditLimit,
    final double currentCredit,
    final int paymentTerms,
    final String creditStatus,
    final String? creditNotes,
    final String? priceCategoryId,
    final double discountPercent,
    final int loyaltyPoints,
    final String? loyaltyTier,
    final String? membershipNumber,
    final DateTime? membershipExpiry,
    final DateTime? dateOfBirth,
    final DateTime? anniversaryDate,
    final DateTime? firstPurchaseDate,
    final DateTime? lastPurchaseDate,
    final double totalPurchases,
    final double totalPayments,
    final int purchaseCount,
    final double averageOrderValue,
    final String? preferredContactMethod,
    final String languagePreference,
    final String currencyPreference,
    final bool marketingConsent,
    final bool smsConsent,
    final bool emailConsent,
    final String? notes,
    final List<String> tags,
    final bool isActive,
    final bool isBlacklisted,
    final String? blacklistReason,
    final bool isVip,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? createdBy,
    final String? lastModifiedBy,
    final bool hasUnsyncedChanges,
  }) = _$CustomerImpl;
  const _Customer._() : super._();

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  String get id;
  @override
  String get businessId;
  @override
  String? get groupId; // Basic Information
  @override
  String get customerCode;
  @override
  String get name;
  @override
  String? get companyName;
  @override
  String get customerType; // 'individual', 'company', 'walk_in'
  // Contact Information
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get alternatePhone;
  @override
  String? get whatsappNumber; // Dedicated WhatsApp number for marketing & orders
  @override
  String? get website; // Address Information
  @override
  String? get addressLine1;
  @override
  String? get addressLine2;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get postalCode;
  @override
  String? get country; // Shipping Address
  @override
  String? get shippingAddressLine1;
  @override
  String? get shippingAddressLine2;
  @override
  String? get shippingCity;
  @override
  String? get shippingState;
  @override
  String? get shippingPostalCode;
  @override
  String? get shippingCountry;
  @override
  bool get useBillingForShipping; // Tax Information
  @override
  String? get taxId;
  @override
  bool get taxExempt;
  @override
  String? get taxExemptReason; // Credit Management
  @override
  double get creditLimit;
  @override
  double get currentCredit;
  @override
  int get paymentTerms; // Days
  @override
  String get creditStatus; // 'active', 'hold', 'blocked'
  @override
  String? get creditNotes; // Pricing & Discounts
  @override
  String? get priceCategoryId;
  @override
  double get discountPercent; // Loyalty & Rewards
  @override
  int get loyaltyPoints;
  @override
  String? get loyaltyTier;
  @override
  String? get membershipNumber;
  @override
  DateTime? get membershipExpiry; // Important Dates
  @override
  DateTime? get dateOfBirth;
  @override
  DateTime? get anniversaryDate;
  @override
  DateTime? get firstPurchaseDate;
  @override
  DateTime? get lastPurchaseDate; // Business Metrics
  @override
  double get totalPurchases;
  @override
  double get totalPayments;
  @override
  int get purchaseCount;
  @override
  double get averageOrderValue; // Preferences
  @override
  String? get preferredContactMethod; // 'email', 'phone', 'sms', 'whatsapp'
  @override
  String get languagePreference;
  @override
  String get currencyPreference;
  @override
  bool get marketingConsent;
  @override
  bool get smsConsent;
  @override
  bool get emailConsent; // Internal Notes
  @override
  String? get notes;
  @override
  List<String> get tags; // Status and Flags
  @override
  bool get isActive;
  @override
  bool get isBlacklisted;
  @override
  String? get blacklistReason;
  @override
  bool get isVip; // Metadata
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get lastModifiedBy; // Offline sync
  @override
  bool get hasUnsyncedChanges;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
