import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/logger.dart';
import 'local_database_service.dart';
import 'sync_queue_service.dart';

/// Generic sync processor that handles sync queue items for any table
class GenericSyncProcessor {
  static final _logger = Logger('GenericSyncProcessor');
  
  final LocalDatabaseService _localDb = LocalDatabaseService();
  final SyncQueueService _syncQueueService = SyncQueueService();
  final SupabaseClient _supabase = Supabase.instance.client;
  final _connectivity = Connectivity();
  
  bool _isProcessing = false;

  // Singleton pattern
  static final GenericSyncProcessor _instance = GenericSyncProcessor._internal();
  factory GenericSyncProcessor() => _instance;
  GenericSyncProcessor._internal();

  /// Process all pending items in the sync queue
  Future<void> processSyncQueue() async {
    if (_isProcessing) {
      _logger.debug('Sync already in progress, skipping');
      return;
    }
    
    _isProcessing = true;
    
    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _logger.info('No internet connection, skipping sync');
        return;
      }

      // Get items that are ready based on backoff
      var pendingItems = await _syncQueueService.getReadyItems();

      // Skip product-related tables here so specialized product sync can handle them
      // This avoids duplicate/conflicting operations (especially for variations)
      const productTablesToSkip = <String>{
        'product_categories', 'product_brands', 'products', 'product_variations', 'product_stock'
      };
      pendingItems = pendingItems
          .where((item) => !productTablesToSkip.contains((item['table_name'] as String?) ?? ''))
          .toList();
      
      if (pendingItems.isNotEmpty) {
        _logger.info('Processing ${pendingItems.length} pending sync items');
        
        // Group items by table for batch processing
        final itemsByTable = <String, List<Map<String, dynamic>>>{};
        for (final item in pendingItems) {
          final tableName = item['table_name'] as String;
          itemsByTable.putIfAbsent(tableName, () => []).add(item);
        }
        
        // Process each table's items
        for (final entry in itemsByTable.entries) {
          await _processTableItems(entry.key, entry.value);
        }
      } else {
        _logger.debug('No pending items to sync');
      }
    } catch (e, stackTrace) {
      _logger.error('Error processing sync queue', e, stackTrace);
    } finally {
      _isProcessing = false;
    }
  }

  /// Process sync items for a specific table
  Future<void> _processTableItems(String tableName, List<Map<String, dynamic>> items) async {
    _logger.info('Processing ${items.length} items for table: $tableName');
    
    for (final item in items) {
      await _processSyncItem(tableName, item);
    }
  }

  /// Process a single sync item
  Future<void> _processSyncItem(String tableName, Map<String, dynamic> item) async {
    try {
      final data = jsonDecode(item['data'] as String) as Map<String, dynamic>;
      final operation = item['operation'] as String;
      final recordId = item['record_id'] as String;
      
      // Convert data to Supabase format (snake_case)
      final supabaseData = _convertToSupabaseFormat(tableName, data);

      // Perform the sync operation
      switch (operation.toUpperCase()) {
        case 'INSERT':
        case 'CREATE':
          await _syncInsert(tableName, recordId, supabaseData);
          break;
        case 'UPDATE':
          await _syncUpdate(tableName, recordId, supabaseData);
          break;
        case 'DELETE':
          await _syncDelete(tableName, recordId);
          break;
        default:
          _logger.warning('Unknown sync operation: $operation');
      }

      // Remove from sync queue on success
      await _syncQueueService.removeItem(item['id'] as String);
      
      // Mark as synced in local database
      await _markAsSynced(tableName, recordId);
      
      _logger.info('Successfully synced $tableName: $recordId');
    } catch (e) {
      final errorMessage = e.toString();
      _logger.error('Error processing sync item ${item['id']}', e);
      
      // Update retry count with error message
      await _syncQueueService.updateRetryCount(
        item['id'] as String,
        errorMessage,
      );
    }
  }

  /// Sync INSERT operation
  Future<void> _syncInsert(String table, String recordId, Map<String, dynamic> data) async {
    try {
      // For orders table, always use upsert to handle duplicate order numbers
      // This is because order numbers can be duplicated based on business rules
      // (e.g., daily reset, per-POS sequences)
      if (table == 'orders') {
        await _supabase.from(table).upsert(data);
        _logger.info('Upserted $table to cloud: $recordId');
      } else {
        await _supabase.from(table).insert(data);
        _logger.info('Inserted $table to cloud: $recordId');
      }
    } catch (e) {
      if (e.toString().contains('duplicate key')) {
        // Record already exists, try update instead
        _logger.info('$table already exists in cloud, updating instead');
        await _syncUpdate(table, recordId, data);
      } else {
        rethrow;
      }
    }
  }

  /// Sync UPDATE operation
  Future<void> _syncUpdate(String table, String recordId, Map<String, dynamic> data) async {
    await _supabase
        .from(table)
        .update(data)
        .eq('id', recordId);
    
    _logger.info('Updated $table in cloud: $recordId');
  }

  /// Sync DELETE operation
  Future<void> _syncDelete(String table, String recordId) async {
    await _supabase
        .from(table)
        .delete()
        .eq('id', recordId);
    
    _logger.info('Deleted $table in cloud: $recordId');
  }

  /// Mark a record as synced in local database
  Future<void> _markAsSynced(String table, String recordId) async {
    try {
      final db = await _localDb.database;
      
      // Check if the table has sync tracking columns
      final tableInfo = await db.rawQuery('PRAGMA table_info($table)');
      final hasUnsyncedColumn = tableInfo.any((col) => 
        col['name'] == 'has_unsynced_changes' || col['name'] == 'sync_status'
      );
      
      if (hasUnsyncedColumn) {
        final updates = <String, dynamic>{};
        
        // Check which column exists
        if (tableInfo.any((col) => col['name'] == 'has_unsynced_changes')) {
          updates['has_unsynced_changes'] = 0;
        }
        if (tableInfo.any((col) => col['name'] == 'sync_status')) {
          updates['sync_status'] = 'synced';
        }
        if (tableInfo.any((col) => col['name'] == 'last_synced_at')) {
          updates['last_synced_at'] = DateTime.now().toIso8601String();
        }
        
        if (updates.isNotEmpty) {
          await db.update(
            table,
            updates,
            where: 'id = ?',
            whereArgs: [recordId],
          );
        }
      }
    } catch (e) {
      _logger.error('Error marking $table as synced', e);
    }
  }

  /// Convert data to Supabase format (camelCase to snake_case)
  Map<String, dynamic> _convertToSupabaseFormat(String tableName, Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);
    
    // Generic field conversions that apply to most tables
    final commonConversions = {
      'businessId': 'business_id',
      'locationId': 'location_id',
      'deviceId': 'device_id',
      'deviceCode': 'device_code',
      'deviceName': 'device_name',
      'isDefault': 'is_default',
      'isActive': 'is_active',
      'isVisible': 'is_visible',
      'createdAt': 'created_at',
      'updatedAt': 'updated_at',
      'createdBy': 'created_by',
      'syncStatus': 'sync_status',
      'lastSyncedAt': 'last_synced_at',
      'hasUnsyncedChanges': 'has_unsynced_changes',
      'positionX': 'position_x',
      'positionY': 'position_y',
      'seatingCapacity': 'seating_capacity',
      // Product-specific fields
      'categoryId': 'category_id',
      'brandId': 'brand_id',
      'parentCategoryId': 'parent_category_id',
      // Fix for product categories and brands
      'defaultKotPrinterId': 'default_kot_printer_id',
      'logoUrl': 'logo_url',
      'colorHex': 'color_hex',
      'iconName': 'icon_name',
      'imageUrl': 'image_url',
      'additionalImageUrls': 'additional_image_urls',
      'unitOfMeasure': 'unit_of_measure',
      'taxRate': 'tax_rate',
      'taxGroupId': 'tax_group_id',
      'taxRateId': 'tax_rate_id',
      'shortCode': 'short_code',
      'productType': 'product_type',
      'trackInventory': 'track_inventory',
      'displayOrder': 'display_order',
      'availableInPos': 'available_in_pos',
      'availableInOnlineStore': 'available_in_online_store',
      'availableInCatalog': 'available_in_catalog',
      'skipKot': 'skip_kot',
      'nameInAlternateLanguage': 'name_in_alternate_language',
      'descriptionInAlternateLanguage': 'description_in_alternate_language',
      // Product variation fields
      'productId': 'product_id',
      'sellingPrice': 'selling_price',
      'purchasePrice': 'purchase_price',
      'isForSale': 'is_for_sale',
      'isForPurchase': 'is_for_purchase',
      // Price fields
      'variationId': 'variation_id',
      'priceCategoryId': 'price_category_id',
      'priceCategoryName': 'price_category_name',
      'tableId': 'table_id',
      // Customer fields
      'customerCode': 'customer_code',
      'isWalkIn': 'is_walk_in',
      'discountPercentage': 'discount_percentage',
      // Order-specific fields
      'orderNumber': 'order_number',
      'posDeviceId': 'pos_device_id',
      'orderType': 'order_type',
      'priceCategoryName': 'price_category_name',
      'orderSource': 'order_source',
      'customerId': 'customer_id',
      'customerName': 'customer_name',
      'customerPhone': 'customer_phone',
      'customerEmail': 'customer_email',
      'deliveryAddressLine1': 'delivery_address_line1',
      'deliveryAddressLine2': 'delivery_address_line2',
      'deliveryCity': 'delivery_city',
      'deliveryPostalCode': 'delivery_postal_code',
      'deliveryPhone': 'delivery_phone',
      'deliveryInstructions': 'delivery_instructions',
      'orderedAt': 'ordered_at',
      'confirmedAt': 'confirmed_at',
      'preparedAt': 'prepared_at',
      'readyAt': 'ready_at',
      'servedAt': 'served_at',
      'completedAt': 'completed_at',
      'cancelledAt': 'cancelled_at',
      'estimatedReadyTime': 'estimated_ready_time',
      'discountAmount': 'discount_amount',
      'deliveryCharge': 'delivery_charge',
      'serviceCharge': 'service_charge',
      'tipAmount': 'tip_amount',
      'roundOffAmount': 'round_off_amount',
      'paymentStatus': 'payment_status',
      'totalPaid': 'total_paid',
      'changeAmount': 'change_amount',
      'kitchenStatus': 'kitchen_status',
      'createdByName': 'created_by_name',
      'servedBy': 'served_by',
      'servedByName': 'served_by_name',
      'preparedBy': 'prepared_by',
      'customerNotes': 'customer_notes',
      'kitchenNotes': 'kitchen_notes',
      'internalNotes': 'internal_notes',
      'cancellationReason': 'cancellation_reason',
      'tokenNumber': 'token_number',
      'lastSyncedAt': 'last_synced_at',
      'hasUnsyncedChanges': 'has_unsynced_changes',
      'isPriority': 'is_priority',
      'isVoid': 'is_void',
      'voidReason': 'void_reason',
      'voidedAt': 'voided_at',
      'voidedBy': 'voided_by',
      'preparationTimeMinutes': 'preparation_time_minutes',
      'serviceTimeMinutes': 'service_time_minutes',
      'totalTimeMinutes': 'total_time_minutes',
      // Order item fields
      'orderId': 'order_id',
      'productName': 'product_name',
      'variationName': 'variation_name',
      'productCode': 'product_code',
      'unitOfMeasure': 'unit_of_measure',
      'unitPrice': 'unit_price',
      'modifiersPrice': 'modifiers_price',
      'specialInstructions': 'special_instructions',
      'discountReason': 'discount_reason',
      'appliedDiscountId': 'applied_discount_id',
      'taxGroupId': 'tax_group_id',
      'taxGroupName': 'tax_group_name',
      'skipKot': 'skip_kot',
      'kotPrinted': 'kot_printed',
      'kotPrintedAt': 'kot_printed_at',
      'kotNumber': 'kot_number',
      'preparationStatus': 'preparation_status',
      'isVoided': 'is_voided',
      'voidedAt': 'voided_at',
      'voidedBy': 'voided_by',
      'voidReason': 'void_reason',
      'isComplimentary': 'is_complimentary',
      'complimentaryReason': 'complimentary_reason',
      'isReturned': 'is_returned',
      'returnedQuantity': 'returned_quantity',
      'returnedAt': 'returned_at',
      'returnReason': 'return_reason',
      'refundedAmount': 'refunded_amount',
      // KOT Configuration fields
      'printerId': 'printer_id',
      'stationId': 'station_id',
      'printerType': 'printer_type',
      'ipAddress': 'ip_address',
      'macAddress': 'mac_address',
      'deviceName': 'device_name',
      'printCopies': 'print_copies',
      'paperSize': 'paper_size',
      'autoCut': 'auto_cut',
      'cashDrawer': 'cash_drawer',
      'itemNotes': 'item_notes',
      // Payment method fields
      'requiresReference': 'requires_reference',
      'requiresApproval': 'requires_approval',
      // Customer fields
      'whatsappNumber': 'whatsapp_number',
      'alternatePhone': 'alternate_phone',
      'companyName': 'company_name',
      // Charge fields
      'chargeType': 'charge_type',
      'calculationType': 'calculation_type',
      'chargeId': 'charge_id',
      'chargeCode': 'charge_code',
      'chargeName': 'charge_name',
      'chargeRate': 'charge_rate',
      'chargeAmount': 'charge_amount',
      'chargesAmount': 'charges_amount',
      'baseAmount': 'base_amount',
      'minValue': 'min_value',
      'maxValue': 'max_value',
      'chargeValue': 'charge_value',
      'tierName': 'tier_name',
      'variableRate': 'variable_rate',
      'variableType': 'variable_type',
      'minCharge': 'min_charge',
      'maxCharge': 'max_charge',
      'formulaExpression': 'formula_expression',
      'customVariables': 'custom_variables',
      'autoApply': 'auto_apply',
      'isMandatory': 'is_mandatory',
      'isTaxable': 'is_taxable',
      'applyBeforeDiscount': 'apply_before_discount',
      'minimumOrderValue': 'minimum_order_value',
      'maximumOrderValue': 'maximum_order_value',
      'validFrom': 'valid_from',
      'validUntil': 'valid_until',
      'applicableDays': 'applicable_days',
      'applicableTimeSlots': 'applicable_time_slots',
      'applicableCategories': 'applicable_categories',
      'applicableProducts': 'applicable_products',
      'excludedCategories': 'excluded_categories',
      'excludedProducts': 'excluded_products',
      'applicableCustomerGroups': 'applicable_customer_groups',
      'excludedCustomerGroups': 'excluded_customer_groups',
      'showInPos': 'show_in_pos',
      'showInInvoice': 'show_in_invoice',
      'showInOnline': 'show_in_online',
      'taxAmount': 'tax_amount',
      'isManual': 'is_manual',
      'originalAmount': 'original_amount',
      'adjustmentReason': 'adjustment_reason',
      'addedBy': 'added_by',
      'removedBy': 'removed_by',
      'isRemoved': 'is_removed',
      'removedAt': 'removed_at',
      'exemptionType': 'exemption_type',
      'exemptionValue': 'exemption_value',
      'approvedBy': 'approved_by',
      'approvedAt': 'approved_at',
      'customerType': 'customer_type',
      'addressLine1': 'address_line1',
      'addressLine2': 'address_line2',
      'postalCode': 'postal_code',
      'shippingAddressLine1': 'shipping_address_line1',
      'shippingAddressLine2': 'shipping_address_line2',
      'shippingCity': 'shipping_city',
      'shippingState': 'shipping_state',
      'shippingPostalCode': 'shipping_postal_code',
      'shippingCountry': 'shipping_country',
      'useBillingForShipping': 'use_billing_for_shipping',
      'taxExempt': 'tax_exempt',
      'taxExemptReason': 'tax_exempt_reason',
      'creditLimit': 'credit_limit',
      'currentCredit': 'current_credit',
      'paymentTerms': 'payment_terms',
      'creditStatus': 'credit_status',
      'creditNotes': 'credit_notes',
      'discountPercent': 'discount_percent',
      'loyaltyPoints': 'loyalty_points',
      'loyaltyTier': 'loyalty_tier',
      'membershipNumber': 'membership_number',
      'membershipExpiry': 'membership_expiry',
      'dateOfBirth': 'date_of_birth',
      'anniversaryDate': 'anniversary_date',
      'firstPurchaseDate': 'first_purchase_date',
      'lastPurchaseDate': 'last_purchase_date',
      'totalPurchases': 'total_purchases',
      'totalPayments': 'total_payments',
      'purchaseCount': 'purchase_count',
      'averageOrderValue': 'average_order_value',
      'preferredContactMethod': 'preferred_contact_method',
      'languagePreference': 'language_preference',
      'currencyPreference': 'currency_preference',
      'marketingConsent': 'marketing_consent',
      'smsConsent': 'sms_consent',
      'emailConsent': 'email_consent',
      'isBlacklisted': 'is_blacklisted',
      'blacklistReason': 'blacklist_reason',
      'isVip': 'is_vip',
      'lastModifiedBy': 'last_modified_by',
      // Table-specific fields
      'tableName': 'table_number',
      'tableNumber': 'table_number',
      'displayName': 'display_name',
      'floorId': 'area_id',
      'areaId': 'area_id',
      'currentOrderId': 'current_order_id',
      'occupiedAt': 'occupied_at',
      'occupiedBy': 'occupied_by',
      'currentAmount': 'current_amount',
      'customerName': 'customer_name',
      'customerPhone': 'customer_phone',
      'isBookable': 'is_bookable',
      'lastOccupiedAt': 'last_occupied_at',
      'lastClearedAt': 'last_cleared_at',
    };
    
    // Apply conversions
    for (final entry in commonConversions.entries) {
      if (converted.containsKey(entry.key)) {
        converted[entry.value] = converted.remove(entry.key);
      }
    }
    
    // Convert DateTime objects and milliseconds to ISO strings
    for (final key in converted.keys.toList()) {
      final value = converted[key];
      if (value is DateTime) {
        converted[key] = value.toIso8601String();
      } else if (key.contains('_at') && value is int) {
        // Convert milliseconds to ISO string for timestamp fields
        converted[key] = DateTime.fromMillisecondsSinceEpoch(value).toIso8601String();
      } else if (key.contains('_at') && value is String && value.length > 10 && !value.contains('-')) {
        // If it's a timestamp string that looks like milliseconds
        try {
          final millis = int.parse(value);
          converted[key] = DateTime.fromMillisecondsSinceEpoch(millis).toIso8601String();
        } catch (e) {
          // Keep original value if parsing fails
        }
      }
    }
    
    // Handle created_by field - remove if it's 'system' or empty
    final createdBy = converted['created_by'];
    if (createdBy == 'system' || createdBy == '') {
        converted['created_by'] = null;
    }
    
    // Convert empty string UUID fields to null
    final uuidFields = [
      'business_id', 'location_id', 'category_id', 'brand_id', 'parent_category_id',
      'product_id', 'variation_id', 'tax_group_id', 'tax_rate_id', 'charge_id',
      'price_category_id', 'table_id', 'area_id', 'floor_id', 'order_id',
      'customer_id', 'applied_discount_id', 'device_id', 'pos_device_id',
      'current_order_id', 'default_kot_printer_id', 'created_by', 'updated_by',
      'approved_by', 'added_by', 'removed_by', 'occupied_by', 'last_modified_by'
    ];
    
    for (final field in uuidFields) {
      if (converted.containsKey(field) && converted[field] == '') {
        converted[field] = null;
      }
    }
    
    // Remove local-only fields that don't exist in Supabase
    converted.remove('has_unsynced_changes');
    converted.remove('last_synced_at');
    converted.remove('sync_status');
    converted.remove('syncStatus');
    converted.remove('hasUnsyncedChanges');
    converted.remove('lastSyncedAt');
    converted.remove('variations'); // Variations are stored in separate table
    converted.remove('taxRates'); // Tax rates are stored in separate table
    
    return converted;
  }

  /// Dispose of resources
  void dispose() {
    // Nothing to dispose currently
  }
}
