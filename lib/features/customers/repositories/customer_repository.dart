import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../models/customer.dart';
import '../models/customer_group.dart';
import '../models/customer_transaction.dart';
import '../../../services/database_schema.dart';

class CustomerRepository {
  final Database localDatabase;
  final SupabaseClient supabase;
  final SyncQueueService syncQueueService;
  
  static final _logger = Logger('CustomerRepository');
  static const _uuid = Uuid();

  CustomerRepository({
    required this.localDatabase,
    required this.supabase,
    required this.syncQueueService,
  });

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    // Ensure tables via centralized schema (matches database/schema_sqlite.sql)
    await DatabaseSchema.applySqliteSchema(localDatabase);
  }

  // Get all customers for a business
  Future<Either<String, List<Customer>>> getCustomers({
    required String businessId,
    bool activeOnly = false,
    String? searchQuery,
    String? groupId,
  }) async {
    try {
      String query = 'SELECT * FROM customers WHERE business_id = ?';
      List<dynamic> args = [businessId];
      
      if (activeOnly) {
        query += ' AND is_active = 1';
      }
      
      if (groupId != null) {
        query += ' AND group_id = ?';
        args.add(groupId);
      }
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query += ' AND (name LIKE ? OR customer_code LIKE ? OR phone LIKE ? OR email LIKE ? OR company_name LIKE ?)';
        final searchPattern = '%$searchQuery%';
        args.addAll([searchPattern, searchPattern, searchPattern, searchPattern, searchPattern]);
      }
      
      query += ' ORDER BY name ASC';
      
      final results = await localDatabase.rawQuery(query, args);
      
      if (results.isNotEmpty) {
        final customers = results.map((row) => _customerFromLocalJson(row)).toList();
        _logger.info('Retrieved ${customers.length} customers from local database');
        return Right(customers);
      }
      
      // If no local data and we're online, try to fetch from Supabase
      try {
        var supabaseQuery = supabase
            .from('customers')
            .select()
            .eq('business_id', businessId);
        
        if (activeOnly) {
          supabaseQuery = supabaseQuery.eq('is_active', true);
        }
        
        if (groupId != null) {
          supabaseQuery = supabaseQuery.eq('group_id', groupId);
        }
        
        if (searchQuery != null && searchQuery.isNotEmpty) {
          supabaseQuery = supabaseQuery.or(
            'name.ilike.%$searchQuery%,customer_code.ilike.%$searchQuery%,phone.ilike.%$searchQuery%,email.ilike.%$searchQuery%,company_name.ilike.%$searchQuery%'
          );
        }
        
        final response = await supabaseQuery.order('name', ascending: true);
        
        final customers = (response as List)
            .map((data) => _customerFromSupabaseJson(data))
            .toList();
        
        // Save to local database
        for (final customer in customers) {
          await _saveToLocal(customer);
        }
        
        _logger.info('Retrieved ${customers.length} customers from Supabase');
        return Right(customers);
      } catch (e) {
        _logger.warning('Failed to fetch from Supabase, using empty list: $e');
        return const Right([]);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to get customers', e, stackTrace);
      return Left('Failed to get customers: $e');
    }
  }

  // Ensure walk-in customer exists
  Future<Either<String, Customer>> ensureWalkInCustomer({
    required String businessId,
  }) async {
    try {
      // Check if walk-in customer already exists
      final existing = await localDatabase.query(
        'customers',
        where: 'business_id = ? AND customer_code = ?',
        whereArgs: [businessId, 'WALK-IN'],
      );
      
      if (existing.isNotEmpty) {
        return Right(_customerFromLocalJson(existing.first));
      }
      
      // Create walk-in customer
      final walkInCustomer = Customer.createWalkInCustomer(businessId);
      
      await _saveToLocal(walkInCustomer);
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'customers',
        'INSERT',
        walkInCustomer.id,
        _customerToSupabaseFormat(walkInCustomer),
      );
      
      _logger.info('Created walk-in customer for business: $businessId');
      return Right(walkInCustomer);
    } catch (e, stackTrace) {
      _logger.error('Failed to ensure walk-in customer', e, stackTrace);
      return Left('Failed to ensure walk-in customer: $e');
    }
  }

  // Add a new customer
  Future<Either<String, Customer>> addCustomer({
    required Customer customer,
  }) async {
    try {
      final id = _uuid.v4();
      final customerWithId = customer.copyWith(id: id);
      
      // Save to local database
      await _saveToLocal(customerWithId);
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'customers',
        'INSERT',
        id,
        _customerToSupabaseFormat(customerWithId),
      );
      
      _logger.info('Added customer: ${customer.name}');
      return Right(customerWithId);
    } catch (e, stackTrace) {
      _logger.error('Failed to add customer', e, stackTrace);
      return Left('Failed to add customer: $e');
    }
  }

  // Update a customer
  Future<Either<String, Customer>> updateCustomer({
    required Customer customer,
  }) async {
    try {
      final updatedCustomer = customer.copyWith(
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );
      
      // Update in local database
      await localDatabase.update(
        'customers',
        _customerToLocalJson(updatedCustomer),
        where: 'id = ?',
        whereArgs: [customer.id],
      );
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'customers',
        'UPDATE',
        customer.id,
        _customerToSupabaseFormat(updatedCustomer),
      );
      
      _logger.info('Updated customer: ${customer.name}');
      return Right(updatedCustomer);
    } catch (e, stackTrace) {
      _logger.error('Failed to update customer', e, stackTrace);
      return Left('Failed to update customer: $e');
    }
  }

  // Add a customer transaction
  Future<Either<String, CustomerTransaction>> addTransaction({
    required CustomerTransaction transaction,
    required String customerId,
  }) async {
    try {
      final id = _uuid.v4();
      final transactionWithId = transaction.copyWith(id: id);
      
      // Get current customer balance
      final customerResult = await localDatabase.query(
        'customers',
        where: 'id = ?',
        whereArgs: [customerId],
        limit: 1,
      );
      
      if (customerResult.isEmpty) {
        return Left('Customer not found');
      }
      
      final customer = _customerFromLocalJson(customerResult.first);
      final balanceBefore = customer.currentCredit;
      final balanceAfter = balanceBefore + transaction.amount;
      
      // Update transaction with balances
      final completeTransaction = transactionWithId.copyWith(
        balanceBefore: balanceBefore,
        balanceAfter: balanceAfter,
      );
      
      // Save transaction
      await localDatabase.insert(
        'customer_transactions',
        _transactionToLocalJson(completeTransaction),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      // Update customer balance
      await localDatabase.update(
        'customers',
        {
          'current_credit': balanceAfter,
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [customerId],
      );
      
      // Add both to sync queue
      await syncQueueService.addToQueue(
        'customer_transactions',
        'INSERT',
        id,
        _transactionToSupabaseFormat(completeTransaction),
      );
      
      await syncQueueService.addToQueue(
        'customers',
        'UPDATE',
        customerId,
        {
          'current_credit': balanceAfter,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      
      _logger.info('Added customer transaction: ${transaction.transactionType}');
      return Right(completeTransaction);
    } catch (e, stackTrace) {
      _logger.error('Failed to add customer transaction', e, stackTrace);
      return Left('Failed to add transaction: $e');
    }
  }

  // Get customer transactions
  Future<Either<String, List<CustomerTransaction>>> getCustomerTransactions({
    required String customerId,
    DateTime? fromDate,
    DateTime? toDate,
    String? transactionType,
  }) async {
    try {
      String query = 'SELECT * FROM customer_transactions WHERE customer_id = ?';
      List<dynamic> args = [customerId];
      
      if (fromDate != null) {
        query += ' AND transaction_date >= ?';
        args.add(fromDate.toIso8601String());
      }
      
      if (toDate != null) {
        query += ' AND transaction_date <= ?';
        args.add(toDate.toIso8601String());
      }
      
      if (transactionType != null) {
        query += ' AND transaction_type = ?';
        args.add(transactionType);
      }
      
      query += ' ORDER BY transaction_date DESC, created_at DESC';
      
      final results = await localDatabase.rawQuery(query, args);
      final transactions = results.map((row) => _transactionFromLocalJson(row)).toList();
      
      _logger.info('Retrieved ${transactions.length} transactions for customer');
      return Right(transactions);
    } catch (e, stackTrace) {
      _logger.error('Failed to get customer transactions', e, stackTrace);
      return Left('Failed to get transactions: $e');
    }
  }

  // Check if customer can make credit purchase
  Future<Either<String, bool>> canMakeCreditPurchase({
    required String customerId,
    required double purchaseAmount,
  }) async {
    try {
      final customerResult = await localDatabase.query(
        'customers',
        where: 'id = ?',
        whereArgs: [customerId],
        limit: 1,
      );
      
      if (customerResult.isEmpty) {
        return Left('Customer not found');
      }
      
      final customer = _customerFromLocalJson(customerResult.first);
      
      // Check if customer is blocked
      if (customer.creditStatus == 'blocked' || customer.creditStatus == 'hold') {
        return const Right(false);
      }
      
      // Check if customer is blacklisted
      if (customer.isBlacklisted) {
        return const Right(false);
      }
      
      // If no credit limit, cannot make credit purchase
      if (customer.creditLimit <= 0) {
        return const Right(false);
      }
      
      // Check if purchase would exceed credit limit
      if ((customer.currentCredit + purchaseAmount) > customer.creditLimit) {
        return const Right(false);
      }
      
      return const Right(true);
    } catch (e, stackTrace) {
      _logger.error('Failed to check credit eligibility', e, stackTrace);
      return Left('Failed to check credit: $e');
    }
  }

  // Get customer groups
  Future<Either<String, List<CustomerGroup>>> getCustomerGroups({
    required String businessId,
  }) async {
    try {
      final results = await localDatabase.query(
        'customer_groups',
        where: 'business_id = ? AND is_active = 1',
        whereArgs: [businessId],
        orderBy: 'name ASC',
      );
      
      if (results.isNotEmpty) {
        final groups = results.map((row) => _groupFromLocalJson(row)).toList();
        return Right(groups);
      }
      
      // Try to fetch from Supabase if no local data
      try {
        final response = await supabase
            .from('customer_groups')
            .select()
            .eq('business_id', businessId)
            .eq('is_active', true)
            .order('name', ascending: true);
        
        final groups = (response as List)
            .map((data) => _groupFromSupabaseJson(data))
            .toList();
        
        // Save to local database
        for (final group in groups) {
          await _saveGroupToLocal(group);
        }
        
        return Right(groups);
      } catch (e) {
        _logger.warning('Failed to fetch groups from Supabase: $e');
        return const Right([]);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to get customer groups', e, stackTrace);
      return Left('Failed to get customer groups: $e');
    }
  }

  // Save customer to local database
  Future<void> _saveToLocal(Customer customer) async {
    await localDatabase.insert(
      'customers',
      _customerToLocalJson(customer),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Save customer group to local database
  Future<void> _saveGroupToLocal(CustomerGroup group) async {
    await localDatabase.insert(
      'customer_groups',
      _groupToLocalJson(group),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Convert Customer to local JSON
  Map<String, dynamic> _customerToLocalJson(Customer customer) {
    return {
      'id': customer.id,
      'business_id': customer.businessId,
      'group_id': customer.groupId,
      'customer_code': customer.customerCode,
      'name': customer.name,
      'company_name': customer.companyName,
      'customer_type': customer.customerType,
      'email': customer.email,
      'phone': customer.phone,
      'alternate_phone': customer.alternatePhone,
      'whatsapp_number': customer.whatsappNumber,
      'website': customer.website,
      'address_line1': customer.addressLine1,
      'address_line2': customer.addressLine2,
      'city': customer.city,
      'state': customer.state,
      'postal_code': customer.postalCode,
      'country': customer.country,
      'shipping_address_line1': customer.shippingAddressLine1,
      'shipping_address_line2': customer.shippingAddressLine2,
      'shipping_city': customer.shippingCity,
      'shipping_state': customer.shippingState,
      'shipping_postal_code': customer.shippingPostalCode,
      'shipping_country': customer.shippingCountry,
      'use_billing_for_shipping': customer.useBillingForShipping ? 1 : 0,
      'tax_id': customer.taxId,
      'tax_exempt': customer.taxExempt ? 1 : 0,
      'tax_exempt_reason': customer.taxExemptReason,
      'credit_limit': customer.creditLimit,
      'current_credit': customer.currentCredit,
      'payment_terms': customer.paymentTerms,
      'credit_status': customer.creditStatus,
      'credit_notes': customer.creditNotes,
      'price_category_id': customer.priceCategoryId,
      'discount_percent': customer.discountPercent,
      'loyalty_points': customer.loyaltyPoints,
      'loyalty_tier': customer.loyaltyTier,
      'membership_number': customer.membershipNumber,
      'membership_expiry': customer.membershipExpiry?.toIso8601String(),
      'date_of_birth': customer.dateOfBirth?.toIso8601String(),
      'anniversary_date': customer.anniversaryDate?.toIso8601String(),
      'first_purchase_date': customer.firstPurchaseDate?.toIso8601String(),
      'last_purchase_date': customer.lastPurchaseDate?.toIso8601String(),
      'total_purchases': customer.totalPurchases,
      'total_payments': customer.totalPayments,
      'purchase_count': customer.purchaseCount,
      'average_order_value': customer.averageOrderValue,
      'preferred_contact_method': customer.preferredContactMethod,
      'language_preference': customer.languagePreference,
      'currency_preference': customer.currencyPreference,
      'marketing_consent': customer.marketingConsent ? 1 : 0,
      'sms_consent': customer.smsConsent ? 1 : 0,
      'email_consent': customer.emailConsent ? 1 : 0,
      'notes': customer.notes,
      'tags': jsonEncode(customer.tags),
      'is_active': customer.isActive ? 1 : 0,
      'is_blacklisted': customer.isBlacklisted ? 1 : 0,
      'blacklist_reason': customer.blacklistReason,
      'is_vip': customer.isVip ? 1 : 0,
      'created_at': customer.createdAt.toIso8601String(),
      'updated_at': customer.updatedAt.toIso8601String(),
      'created_by': customer.createdBy,
      'last_modified_by': customer.lastModifiedBy,
      'has_unsynced_changes': customer.hasUnsyncedChanges ? 1 : 0,
    };
  }

  // Convert local JSON to Customer
  Customer _customerFromLocalJson(Map<String, dynamic> json) {
    List<String> tags = [];
    if (json['tags'] != null) {
      final tagsValue = json['tags'];
      if (tagsValue is String && tagsValue.isNotEmpty) {
        try {
          tags = List<String>.from(jsonDecode(tagsValue));
        } catch (e) {
          _logger.warning('Failed to parse tags JSON: $e');
        }
      }
    }
    
    return Customer(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      groupId: json['group_id'] as String?,
      customerCode: json['customer_code'] as String,
      name: json['name'] as String,
      companyName: json['company_name'] as String?,
      customerType: json['customer_type'] as String? ?? 'individual',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      alternatePhone: json['alternate_phone'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      website: json['website'] as String?,
      addressLine1: json['address_line1'] as String?,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      shippingAddressLine1: json['shipping_address_line1'] as String?,
      shippingAddressLine2: json['shipping_address_line2'] as String?,
      shippingCity: json['shipping_city'] as String?,
      shippingState: json['shipping_state'] as String?,
      shippingPostalCode: json['shipping_postal_code'] as String?,
      shippingCountry: json['shipping_country'] as String?,
      useBillingForShipping: (json['use_billing_for_shipping'] as int) == 1,
      taxId: json['tax_id'] as String?,
      taxExempt: (json['tax_exempt'] as int) == 1,
      taxExemptReason: json['tax_exempt_reason'] as String?,
      creditLimit: (json['credit_limit'] as num).toDouble(),
      currentCredit: (json['current_credit'] as num).toDouble(),
      paymentTerms: json['payment_terms'] as int,
      creditStatus: json['credit_status'] as String? ?? 'active',
      creditNotes: json['credit_notes'] as String?,
      priceCategoryId: json['price_category_id'] as String?,
      discountPercent: (json['discount_percent'] as num).toDouble(),
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      loyaltyTier: json['loyalty_tier'] as String?,
      membershipNumber: json['membership_number'] as String?,
      membershipExpiry: json['membership_expiry'] != null 
          ? DateTime.parse(json['membership_expiry'] as String) 
          : null,
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth'] as String) 
          : null,
      anniversaryDate: json['anniversary_date'] != null 
          ? DateTime.parse(json['anniversary_date'] as String) 
          : null,
      firstPurchaseDate: json['first_purchase_date'] != null 
          ? DateTime.parse(json['first_purchase_date'] as String) 
          : null,
      lastPurchaseDate: json['last_purchase_date'] != null 
          ? DateTime.parse(json['last_purchase_date'] as String) 
          : null,
      totalPurchases: (json['total_purchases'] as num).toDouble(),
      totalPayments: (json['total_payments'] as num).toDouble(),
      purchaseCount: json['purchase_count'] as int? ?? 0,
      averageOrderValue: (json['average_order_value'] as num).toDouble(),
      preferredContactMethod: json['preferred_contact_method'] as String?,
      languagePreference: json['language_preference'] as String? ?? 'en',
      currencyPreference: json['currency_preference'] as String? ?? 'INR',
      marketingConsent: (json['marketing_consent'] as int) == 1,
      smsConsent: (json['sms_consent'] as int) == 1,
      emailConsent: (json['email_consent'] as int) == 1,
      notes: json['notes'] as String?,
      tags: tags,
      isActive: (json['is_active'] as int) == 1,
      isBlacklisted: (json['is_blacklisted'] as int) == 1,
      blacklistReason: json['blacklist_reason'] as String?,
      isVip: (json['is_vip'] as int) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      lastModifiedBy: json['last_modified_by'] as String?,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int) == 1,
    );
  }

  // Convert Customer to Supabase format
  Map<String, dynamic> _customerToSupabaseFormat(Customer customer) {
    return {
      'id': customer.id,
      'business_id': customer.businessId,
      'group_id': customer.groupId,
      'customer_code': customer.customerCode,
      'name': customer.name,
      'company_name': customer.companyName,
      'customer_type': customer.customerType,
      'email': customer.email,
      'phone': customer.phone,
      'alternate_phone': customer.alternatePhone,
      'whatsapp_number': customer.whatsappNumber,
      'website': customer.website,
      'address_line1': customer.addressLine1,
      'address_line2': customer.addressLine2,
      'city': customer.city,
      'state': customer.state,
      'postal_code': customer.postalCode,
      'country': customer.country,
      'shipping_address_line1': customer.shippingAddressLine1,
      'shipping_address_line2': customer.shippingAddressLine2,
      'shipping_city': customer.shippingCity,
      'shipping_state': customer.shippingState,
      'shipping_postal_code': customer.shippingPostalCode,
      'shipping_country': customer.shippingCountry,
      'use_billing_for_shipping': customer.useBillingForShipping,
      'tax_id': customer.taxId,
      'tax_exempt': customer.taxExempt,
      'tax_exempt_reason': customer.taxExemptReason,
      'credit_limit': customer.creditLimit,
      'current_credit': customer.currentCredit,
      'payment_terms': customer.paymentTerms,
      'credit_status': customer.creditStatus,
      'credit_notes': customer.creditNotes,
      'price_category_id': customer.priceCategoryId,
      'discount_percent': customer.discountPercent,
      'loyalty_points': customer.loyaltyPoints,
      'loyalty_tier': customer.loyaltyTier,
      'membership_number': customer.membershipNumber,
      'membership_expiry': customer.membershipExpiry?.toIso8601String(),
      'date_of_birth': customer.dateOfBirth?.toIso8601String(),
      'anniversary_date': customer.anniversaryDate?.toIso8601String(),
      'first_purchase_date': customer.firstPurchaseDate?.toIso8601String(),
      'last_purchase_date': customer.lastPurchaseDate?.toIso8601String(),
      'total_purchases': customer.totalPurchases,
      'total_payments': customer.totalPayments,
      'purchase_count': customer.purchaseCount,
      'average_order_value': customer.averageOrderValue,
      'preferred_contact_method': customer.preferredContactMethod,
      'language_preference': customer.languagePreference,
      'currency_preference': customer.currencyPreference,
      'marketing_consent': customer.marketingConsent,
      'sms_consent': customer.smsConsent,
      'email_consent': customer.emailConsent,
      'notes': customer.notes,
      'tags': customer.tags,
      'is_active': customer.isActive,
      'is_blacklisted': customer.isBlacklisted,
      'blacklist_reason': customer.blacklistReason,
      'is_vip': customer.isVip,
      'created_at': customer.createdAt.toIso8601String(),
      'updated_at': customer.updatedAt.toIso8601String(),
      'created_by': customer.createdBy,
      'last_modified_by': customer.lastModifiedBy,
    };
  }

  // Convert Supabase JSON to Customer
  Customer _customerFromSupabaseJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      groupId: json['group_id'] as String?,
      customerCode: json['customer_code'] as String,
      name: json['name'] as String,
      companyName: json['company_name'] as String?,
      customerType: json['customer_type'] as String? ?? 'individual',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      alternatePhone: json['alternate_phone'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      website: json['website'] as String?,
      addressLine1: json['address_line1'] as String?,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      shippingAddressLine1: json['shipping_address_line1'] as String?,
      shippingAddressLine2: json['shipping_address_line2'] as String?,
      shippingCity: json['shipping_city'] as String?,
      shippingState: json['shipping_state'] as String?,
      shippingPostalCode: json['shipping_postal_code'] as String?,
      shippingCountry: json['shipping_country'] as String?,
      useBillingForShipping: json['use_billing_for_shipping'] as bool? ?? true,
      taxId: json['tax_id'] as String?,
      taxExempt: json['tax_exempt'] as bool? ?? false,
      taxExemptReason: json['tax_exempt_reason'] as String?,
      creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0,
      currentCredit: (json['current_credit'] as num?)?.toDouble() ?? 0,
      paymentTerms: json['payment_terms'] as int? ?? 0,
      creditStatus: json['credit_status'] as String? ?? 'active',
      creditNotes: json['credit_notes'] as String?,
      priceCategoryId: json['price_category_id'] as String?,
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      loyaltyTier: json['loyalty_tier'] as String?,
      membershipNumber: json['membership_number'] as String?,
      membershipExpiry: json['membership_expiry'] != null 
          ? DateTime.parse(json['membership_expiry'] as String) 
          : null,
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth'] as String) 
          : null,
      anniversaryDate: json['anniversary_date'] != null 
          ? DateTime.parse(json['anniversary_date'] as String) 
          : null,
      firstPurchaseDate: json['first_purchase_date'] != null 
          ? DateTime.parse(json['first_purchase_date'] as String) 
          : null,
      lastPurchaseDate: json['last_purchase_date'] != null 
          ? DateTime.parse(json['last_purchase_date'] as String) 
          : null,
      totalPurchases: (json['total_purchases'] as num?)?.toDouble() ?? 0,
      totalPayments: (json['total_payments'] as num?)?.toDouble() ?? 0,
      purchaseCount: json['purchase_count'] as int? ?? 0,
      averageOrderValue: (json['average_order_value'] as num?)?.toDouble() ?? 0,
      preferredContactMethod: json['preferred_contact_method'] as String?,
      languagePreference: json['language_preference'] as String? ?? 'en',
      currencyPreference: json['currency_preference'] as String? ?? 'INR',
      marketingConsent: json['marketing_consent'] as bool? ?? false,
      smsConsent: json['sms_consent'] as bool? ?? false,
      emailConsent: json['email_consent'] as bool? ?? false,
      notes: json['notes'] as String?,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List) 
          : [],
      isActive: json['is_active'] as bool? ?? true,
      isBlacklisted: json['is_blacklisted'] as bool? ?? false,
      blacklistReason: json['blacklist_reason'] as String?,
      isVip: json['is_vip'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      lastModifiedBy: json['last_modified_by'] as String?,
      hasUnsyncedChanges: false,
    );
  }

  // Convert CustomerTransaction to local JSON
  Map<String, dynamic> _transactionToLocalJson(CustomerTransaction transaction) {
    return {
      'id': transaction.id,
      'business_id': transaction.businessId,
      'customer_id': transaction.customerId,
      'transaction_type': transaction.transactionType,
      'transaction_date': transaction.transactionDate.toIso8601String(),
      'reference_type': transaction.referenceType,
      'reference_id': transaction.referenceId,
      'reference_number': transaction.referenceNumber,
      'amount': transaction.amount,
      'balance_before': transaction.balanceBefore,
      'balance_after': transaction.balanceAfter,
      'payment_method_id': transaction.paymentMethodId,
      'payment_reference': transaction.paymentReference,
      'payment_date': transaction.paymentDate?.toIso8601String(),
      'cheque_number': transaction.chequeNumber,
      'cheque_date': transaction.chequeDate?.toIso8601String(),
      'cheque_status': transaction.chequeStatus,
      'bank_name': transaction.bankName,
      'description': transaction.description,
      'notes': transaction.notes,
      'created_at': transaction.createdAt.toIso8601String(),
      'created_by': transaction.createdBy,
      'is_verified': transaction.isVerified ? 1 : 0,
      'verified_by': transaction.verifiedBy,
      'verified_at': transaction.verifiedAt?.toIso8601String(),
      'has_unsynced_changes': transaction.hasUnsyncedChanges ? 1 : 0,
    };
  }

  // Convert local JSON to CustomerTransaction
  CustomerTransaction _transactionFromLocalJson(Map<String, dynamic> json) {
    return CustomerTransaction(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      customerId: json['customer_id'] as String,
      transactionType: json['transaction_type'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as String?,
      referenceNumber: json['reference_number'] as String?,
      amount: (json['amount'] as num).toDouble(),
      balanceBefore: (json['balance_before'] as num).toDouble(),
      balanceAfter: (json['balance_after'] as num).toDouble(),
      paymentMethodId: json['payment_method_id'] as String?,
      paymentReference: json['payment_reference'] as String?,
      paymentDate: json['payment_date'] != null 
          ? DateTime.parse(json['payment_date'] as String) 
          : null,
      chequeNumber: json['cheque_number'] as String?,
      chequeDate: json['cheque_date'] != null 
          ? DateTime.parse(json['cheque_date'] as String) 
          : null,
      chequeStatus: json['cheque_status'] as String?,
      bankName: json['bank_name'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String?,
      isVerified: (json['is_verified'] as int) == 1,
      verifiedBy: json['verified_by'] as String?,
      verifiedAt: json['verified_at'] != null 
          ? DateTime.parse(json['verified_at'] as String) 
          : null,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int) == 1,
    );
  }

  // Convert CustomerTransaction to Supabase format
  Map<String, dynamic> _transactionToSupabaseFormat(CustomerTransaction transaction) {
    return {
      'id': transaction.id,
      'business_id': transaction.businessId,
      'customer_id': transaction.customerId,
      'transaction_type': transaction.transactionType,
      'transaction_date': transaction.transactionDate.toIso8601String(),
      'reference_type': transaction.referenceType,
      'reference_id': transaction.referenceId,
      'reference_number': transaction.referenceNumber,
      'amount': transaction.amount,
      'balance_before': transaction.balanceBefore,
      'balance_after': transaction.balanceAfter,
      'payment_method_id': transaction.paymentMethodId,
      'payment_reference': transaction.paymentReference,
      'payment_date': transaction.paymentDate?.toIso8601String(),
      'cheque_number': transaction.chequeNumber,
      'cheque_date': transaction.chequeDate?.toIso8601String(),
      'cheque_status': transaction.chequeStatus,
      'bank_name': transaction.bankName,
      'description': transaction.description,
      'notes': transaction.notes,
      'created_at': transaction.createdAt.toIso8601String(),
      'created_by': transaction.createdBy,
      'is_verified': transaction.isVerified,
      'verified_by': transaction.verifiedBy,
      'verified_at': transaction.verifiedAt?.toIso8601String(),
    };
  }

  // Convert CustomerGroup to local JSON
  Map<String, dynamic> _groupToLocalJson(CustomerGroup group) {
    return {
      'id': group.id,
      'business_id': group.businessId,
      'name': group.name,
      'code': group.code,
      'description': group.description,
      'color': group.color,
      'discount_percent': group.discountPercent,
      'credit_limit': group.creditLimit,
      'payment_terms': group.paymentTerms,
      'is_active': group.isActive ? 1 : 0,
      'created_at': group.createdAt.toIso8601String(),
      'updated_at': group.updatedAt.toIso8601String(),
      'created_by': group.createdBy,
      'has_unsynced_changes': group.hasUnsyncedChanges ? 1 : 0,
    };
  }

  // Convert local JSON to CustomerGroup
  CustomerGroup _groupFromLocalJson(Map<String, dynamic> json) {
    return CustomerGroup(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
      discountPercent: (json['discount_percent'] as num).toDouble(),
      creditLimit: (json['credit_limit'] as num).toDouble(),
      paymentTerms: json['payment_terms'] as int,
      isActive: (json['is_active'] as int) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int) == 1,
    );
  }

  // Convert Supabase JSON to CustomerGroup
  CustomerGroup _groupFromSupabaseJson(Map<String, dynamic> json) {
    return CustomerGroup(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
      creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0,
      paymentTerms: json['payment_terms'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      hasUnsyncedChanges: false,
    );
  }
}
