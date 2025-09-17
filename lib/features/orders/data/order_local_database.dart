import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../core/utils/logger.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/order_payment.dart';
import '../models/order_discount.dart';
import '../models/order_charge.dart';
import '../models/order_status.dart';
import '../../../services/database_schema.dart';

class OrderLocalDatabase {
  static final _logger = Logger('OrderLocalDatabase');
  final Database database;

  OrderLocalDatabase({required this.database});

  // Initialize order tables
  static Future<void> initializeTables(Database db) async {
    try {
      await DatabaseSchema.applySqliteSchema(db);
      _logger.info('Order tables ensured via bundled schema');
    } catch (e) {
      _logger.error('Failed to ensure order tables via schema', e);
      rethrow;
    }
  }

  // Save order locally
  Future<void> saveOrder(Order order) async {
    try {
      // Convert complex fields to JSON
      final orderMap = order.toJson();
      
      // Remove nested objects that are handled separately in normalized tables
      orderMap.remove('items');
      orderMap.remove('payments');
      orderMap.remove('orderDiscounts');
      orderMap.remove('orderCharges');
      orderMap.remove('statusHistory');
      
      // Fix field naming from camelCase to snake_case
      orderMap['order_number'] = orderMap.remove('orderNumber');
      orderMap['business_id'] = orderMap.remove('businessId');
      orderMap['location_id'] = orderMap.remove('locationId');
      orderMap['pos_device_id'] = orderMap.remove('posDeviceId');
      orderMap['price_category_name'] = orderMap.remove('priceCategoryName');
      orderMap['table_id'] = orderMap.remove('tableId');
      orderMap['table_name'] = orderMap.remove('tableName');
      orderMap['customer_id'] = orderMap.remove('customerId');
      orderMap['customer_name'] = orderMap.remove('customerName');
      orderMap['customer_phone'] = orderMap.remove('customerPhone');
      orderMap['customer_email'] = orderMap.remove('customerEmail');
      orderMap['delivery_address_line1'] = orderMap.remove('deliveryAddressLine1');
      orderMap['delivery_address_line2'] = orderMap.remove('deliveryAddressLine2');
      orderMap['delivery_city'] = orderMap.remove('deliveryCity');
      orderMap['delivery_postal_code'] = orderMap.remove('deliveryPostalCode');
      orderMap['delivery_phone'] = orderMap.remove('deliveryPhone');
      orderMap['delivery_instructions'] = orderMap.remove('deliveryInstructions');
      orderMap['discount_amount'] = orderMap.remove('discountAmount');
      orderMap['tax_amount'] = orderMap.remove('taxAmount');
      orderMap['charges_amount'] = orderMap.remove('chargesAmount');
      orderMap['delivery_charge'] = orderMap.remove('deliveryCharge');
      orderMap['service_charge'] = orderMap.remove('serviceCharge');
      orderMap['tip_amount'] = orderMap.remove('tipAmount');
      orderMap['round_off_amount'] = orderMap.remove('roundOffAmount');
      orderMap['total_paid'] = orderMap.remove('totalPaid');
      orderMap['change_amount'] = orderMap.remove('changeAmount');
      orderMap['created_by'] = orderMap.remove('createdBy');
      orderMap['created_by_name'] = orderMap.remove('createdByName');
      orderMap['served_by'] = orderMap.remove('servedBy');
      orderMap['served_by_name'] = orderMap.remove('servedByName');
      orderMap['customer_notes'] = orderMap.remove('customerNotes');
      orderMap['kitchen_notes'] = orderMap.remove('kitchenNotes');
      orderMap['internal_notes'] = orderMap.remove('internalNotes');
      orderMap['cancellation_reason'] = orderMap.remove('cancellationReason');
      orderMap['token_number'] = orderMap.remove('tokenNumber');
      orderMap['void_reason'] = orderMap.remove('voidReason');
      orderMap['voided_by'] = orderMap.remove('voidedBy');
      orderMap['preparation_time_minutes'] = orderMap.remove('preparationTimeMinutes');
      orderMap['service_time_minutes'] = orderMap.remove('serviceTimeMinutes');
      orderMap['total_time_minutes'] = orderMap.remove('totalTimeMinutes');
      
      // Do not store JSON blobs in orders table; related rows are saved in child tables
      
      // Remove DateTime objects from the map (they need to be converted to strings)
      orderMap.remove('orderedAt');
      orderMap.remove('confirmedAt');
      orderMap.remove('preparedAt');
      orderMap.remove('readyAt');
      orderMap.remove('servedAt');
      orderMap.remove('completedAt');
      orderMap.remove('cancelledAt');
      orderMap.remove('estimatedReadyTime');
      orderMap.remove('createdAt');
      orderMap.remove('updatedAt');
      orderMap.remove('lastSyncedAt');
      orderMap.remove('voidedAt');
      
      // Convert DateTime fields to ISO strings
      orderMap['ordered_at'] = order.orderedAt.toIso8601String();
      orderMap['created_at'] = order.createdAt.toIso8601String();
      orderMap['updated_at'] = order.updatedAt.toIso8601String();
      
      // Convert other DateTime fields if not null
      if (order.confirmedAt != null) orderMap['confirmed_at'] = order.confirmedAt!.toIso8601String();
      if (order.preparedAt != null) orderMap['prepared_at'] = order.preparedAt!.toIso8601String();
      if (order.readyAt != null) orderMap['ready_at'] = order.readyAt!.toIso8601String();
      if (order.servedAt != null) orderMap['served_at'] = order.servedAt!.toIso8601String();
      if (order.completedAt != null) orderMap['completed_at'] = order.completedAt!.toIso8601String();
      if (order.cancelledAt != null) orderMap['cancelled_at'] = order.cancelledAt!.toIso8601String();
      if (order.estimatedReadyTime != null) orderMap['estimated_ready_time'] = order.estimatedReadyTime!.toIso8601String();
      if (order.lastSyncedAt != null) orderMap['last_synced_at'] = order.lastSyncedAt!.toIso8601String();
      if (order.voidedAt != null) orderMap['voided_at'] = order.voidedAt!.toIso8601String();
      
      // Convert enum fields to strings (remove the original enum values first)
      orderMap.remove('orderType');
      orderMap.remove('orderSource');
      orderMap.remove('status');
      orderMap.remove('paymentStatus');
      orderMap.remove('kitchenStatus');
      
      orderMap['order_type'] = order.orderType.value;
      orderMap['order_source'] = order.orderSource.value;
      orderMap['status'] = order.status.value;
      orderMap['payment_status'] = order.paymentStatus.value;
      if (order.kitchenStatus != null) orderMap['kitchen_status'] = order.kitchenStatus!.value;
      
      // Convert bool to int for SQLite
      orderMap['has_unsynced_changes'] = order.hasUnsyncedChanges ? 1 : 0;
      orderMap['is_priority'] = order.isPriority ? 1 : 0;
      orderMap['is_void'] = order.isVoid ? 1 : 0;
      
      // Remove any remaining complex types that might have been added by toJson()
      orderMap.remove('preparedBy');  // Already handled as JSON string above
      orderMap.remove('hasUnsyncedChanges');  // Already handled as int above  
      orderMap.remove('isPriority');  // Already handled as int above
      orderMap.remove('isVoid');  // Already handled as int above
      
      // No JSON payloads in orders table; children saved below
      
      // Insert or replace order
      await database.insert(
        'orders',
        orderMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      // Save order items separately
      for (final item in order.items) {
        await saveOrderItem(item);
      }
      
      // Save payments separately
      for (final payment in order.payments) {
        await saveOrderPayment(payment);
      }
      
      // Save discounts separately
      for (final discount in order.orderDiscounts) {
        await saveOrderDiscount(discount);
      }
      
      // Save charges separately
      for (final charge in order.orderCharges) {
        await saveOrderCharge(charge);
      }
      
      _logger.info('Order saved locally: ${order.orderNumber}');
    } catch (e) {
      _logger.error('Failed to save order locally', e);
      rethrow;
    }
  }

  // Save order item
  Future<void> saveOrderItem(OrderItem item) async {
    try {
      final itemMap = item.toJson();
      
      // Remove nested objects and complex types
      itemMap.remove('modifiers');  // Will be stored as JSON string
      itemMap.remove('preparationStatus');  // Will be stored as string value
      
      // Fix field naming from camelCase to snake_case
      itemMap['order_id'] = itemMap.remove('orderId');
      itemMap['product_id'] = itemMap.remove('productId');
      itemMap['variation_id'] = itemMap.remove('variationId');
      itemMap['product_name'] = itemMap.remove('productName');
      itemMap['variation_name'] = itemMap.remove('variationName');
      itemMap['product_code'] = itemMap.remove('productCode');
      itemMap['unit_of_measure'] = itemMap.remove('unitOfMeasure');
      itemMap['unit_price'] = itemMap.remove('unitPrice');
      itemMap['modifiers_price'] = itemMap.remove('modifiersPrice');
      itemMap['special_instructions'] = itemMap.remove('specialInstructions');
      itemMap['discount_amount'] = itemMap.remove('discountAmount');
      itemMap['discount_percent'] = itemMap.remove('discountPercent');
      itemMap['discount_reason'] = itemMap.remove('discountReason');
      itemMap['applied_discount_id'] = itemMap.remove('appliedDiscountId');
      itemMap['tax_rate'] = itemMap.remove('taxRate');
      itemMap['tax_amount'] = itemMap.remove('taxAmount');
      itemMap['tax_group_id'] = itemMap.remove('taxGroupId');
      itemMap['tax_group_name'] = itemMap.remove('taxGroupName');
      itemMap['kot_printed_at'] = itemMap.remove('kotPrintedAt');
      itemMap['kot_number'] = itemMap.remove('kotNumber');
      itemMap['prepared_at'] = itemMap.remove('preparedAt');
      itemMap['prepared_by'] = itemMap.remove('preparedBy');
      itemMap['served_at'] = itemMap.remove('servedAt');
      itemMap['served_by'] = itemMap.remove('servedBy');
      itemMap['voided_at'] = itemMap.remove('voidedAt');
      itemMap['voided_by'] = itemMap.remove('voidedBy');
      itemMap['void_reason'] = itemMap.remove('voidReason');
      itemMap['complimentary_reason'] = itemMap.remove('complimentaryReason');
      itemMap['returned_quantity'] = itemMap.remove('returnedQuantity');
      itemMap['returned_at'] = itemMap.remove('returnedAt');
      itemMap['return_reason'] = itemMap.remove('returnReason');
      itemMap['refunded_amount'] = itemMap.remove('refundedAmount');
      itemMap['display_order'] = itemMap.remove('displayOrder');
      itemMap['category_id'] = itemMap.remove('categoryId');
      itemMap['item_notes'] = itemMap.remove('itemNotes');
      
      // Convert complex fields to JSON strings
      itemMap['modifiers'] = jsonEncode(item.modifiers.map((e) => e.toJson()).toList());
      
      // Remove DateTime objects from the map (they need to be converted to strings)
      itemMap.remove('createdAt');
      itemMap.remove('updatedAt');
      
      // Convert DateTime fields to ISO strings
      itemMap['created_at'] = item.createdAt.toIso8601String();
      itemMap['updated_at'] = item.updatedAt.toIso8601String();
      
      if (item.kotPrintedAt != null) itemMap['kot_printed_at'] = item.kotPrintedAt!.toIso8601String();
      if (item.preparedAt != null) itemMap['prepared_at'] = item.preparedAt!.toIso8601String();
      if (item.servedAt != null) itemMap['served_at'] = item.servedAt!.toIso8601String();
      if (item.voidedAt != null) itemMap['voided_at'] = item.voidedAt!.toIso8601String();
      if (item.returnedAt != null) itemMap['returned_at'] = item.returnedAt!.toIso8601String();
      
      // Convert enum fields to strings
      itemMap['preparation_status'] = item.preparationStatus.value;
      
      // Remove boolean fields from the map (they need to be converted to int)
      itemMap.remove('skipKot');
      itemMap.remove('kotPrinted');
      itemMap.remove('isVoided');
      itemMap.remove('isComplimentary');
      itemMap.remove('isReturned');
      
      // Convert bool to int for SQLite
      itemMap['skip_kot'] = item.skipKot ? 1 : 0;
      itemMap['kot_printed'] = item.kotPrinted ? 1 : 0;
      itemMap['is_voided'] = item.isVoided ? 1 : 0;
      itemMap['is_complimentary'] = item.isComplimentary ? 1 : 0;
      itemMap['is_returned'] = item.isReturned ? 1 : 0;
      
      await database.insert(
        'order_items',
        itemMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.error('Failed to save order item', e);
      rethrow;
    }
  }

  // Save order payment
  Future<void> saveOrderPayment(OrderPayment payment) async {
    try {
      final paymentMap = payment.toJson();
      
      // Fix field naming from camelCase to snake_case
      paymentMap['order_id'] = paymentMap.remove('orderId');
      paymentMap['payment_method_id'] = paymentMap.remove('paymentMethodId');
      paymentMap['payment_method_name'] = paymentMap.remove('paymentMethodName');
      paymentMap['payment_method_code'] = paymentMap.remove('paymentMethodCode');
      paymentMap['tip_amount'] = paymentMap.remove('tipAmount');
      paymentMap['processing_fee'] = paymentMap.remove('processingFee');
      paymentMap['total_amount'] = paymentMap.remove('totalAmount');
      paymentMap['reference_number'] = paymentMap.remove('referenceNumber');
      paymentMap['transaction_id'] = paymentMap.remove('transactionId');
      paymentMap['approval_code'] = paymentMap.remove('approvalCode');
      paymentMap['card_last_four'] = paymentMap.remove('cardLastFour');
      paymentMap['card_type'] = paymentMap.remove('cardType');
      paymentMap['refunded_at'] = paymentMap.remove('refundedAt');
      paymentMap['refunded_amount'] = paymentMap.remove('refundedAmount');
      paymentMap['refund_reason'] = paymentMap.remove('refundReason');
      paymentMap['refunded_by'] = paymentMap.remove('refundedBy');
      paymentMap['refund_transaction_id'] = paymentMap.remove('refundTransactionId');
      paymentMap['processed_by'] = paymentMap.remove('processedBy');
      paymentMap['processed_by_name'] = paymentMap.remove('processedByName');
      
      // Remove DateTime objects from the map (they need to be converted to strings)
      paymentMap.remove('paidAt');
      paymentMap.remove('createdAt');
      paymentMap.remove('updatedAt');
      
      // Convert DateTime fields to ISO strings
      paymentMap['paid_at'] = payment.paidAt.toIso8601String();
      paymentMap['created_at'] = payment.createdAt.toIso8601String();
      paymentMap['updated_at'] = payment.updatedAt.toIso8601String();
      
      if (payment.refundedAt != null) paymentMap['refunded_at'] = payment.refundedAt!.toIso8601String();
      
      // Convert metadata to JSON string
      if (payment.metadata != null) paymentMap['metadata'] = jsonEncode(payment.metadata);
      
      await database.insert(
        'order_payments',
        paymentMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.error('Failed to save order payment', e);
      rethrow;
    }
  }

  // Save order discount
  Future<void> saveOrderDiscount(OrderDiscount discount) async {
    try {
      final discountMap = discount.toJson();
      
      // Fix field naming from camelCase to snake_case
      discountMap['order_id'] = discountMap.remove('orderId');
      discountMap['discount_id'] = discountMap.remove('discountId');
      discountMap['discount_name'] = discountMap.remove('discountName');
      discountMap['discount_code'] = discountMap.remove('discountCode');
      discountMap['discount_type'] = discountMap.remove('discountType');
      discountMap['applied_to'] = discountMap.remove('appliedTo');
      discountMap['discount_percent'] = discountMap.remove('discountPercent');
      discountMap['discount_amount'] = discountMap.remove('discountAmount');
      discountMap['maximum_discount'] = discountMap.remove('maximumDiscount');
      discountMap['applied_amount'] = discountMap.remove('appliedAmount');
      discountMap['minimum_purchase'] = discountMap.remove('minimumPurchase');
      discountMap['minimum_quantity'] = discountMap.remove('minimumQuantity');
      // Remove the fields first to get their values
      final applicableCategories = discountMap.remove('applicableCategories');
      final applicableProducts = discountMap.remove('applicableProducts');
      discountMap['application_method'] = discountMap.remove('applicationMethod');
      discountMap['coupon_code'] = discountMap.remove('couponCode');
      discountMap['applied_by'] = discountMap.remove('appliedBy');
      discountMap['applied_by_name'] = discountMap.remove('appliedByName');
      discountMap['authorized_by'] = discountMap.remove('authorizedBy');
      
      // Remove DateTime objects from the map (they need to be converted to strings)
      discountMap.remove('appliedAt');
      
      // Convert DateTime fields to ISO strings
      discountMap['applied_at'] = discount.appliedAt.toIso8601String();
      
      // Convert arrays to JSON strings
      discountMap['applicable_categories'] = jsonEncode(applicableCategories ?? []);
      discountMap['applicable_products'] = jsonEncode(applicableProducts ?? []);
      
      // Convert metadata to JSON string
      if (discount.metadata != null) discountMap['metadata'] = jsonEncode(discount.metadata);
      
      await database.insert(
        'order_discounts',
        discountMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.error('Failed to save order discount', e);
      rethrow;
    }
  }

  // Get order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      final results = await database.query(
        'orders',
        where: 'id = ?',
        whereArgs: [orderId],
      );
      
      if (results.isEmpty) return null;

      // Build base order
      final baseOrder = _orderFromLocalJson(results.first);

      // Hydrate children from normalized tables
      final items = await getOrderItems(orderId);
      final payments = await getOrderPayments(orderId);
      final discounts = await getOrderDiscounts(orderId);
      final charges = await getOrderCharges(orderId);

      return baseOrder.copyWith(
        items: items,
        payments: payments,
        orderDiscounts: discounts,
        orderCharges: charges,
      );
    } catch (e) {
      _logger.error('Failed to get order by ID', e);
      return null;
    }
  }

  // Get orders for business
  Future<List<Order>> getOrdersForBusiness(
    String businessId, {
      String? locationId,
      String? status,
      String? paymentStatus,
      DateTime? fromDate,
      DateTime? toDate,
      int? limit,
      int? offset,
  }) async {
    try {
      String query = 'SELECT * FROM orders WHERE business_id = ?';
      List<dynamic> args = [businessId];
      
      if (locationId != null) {
        query += ' AND location_id = ?';
        args.add(locationId);
      }
      
      // When both status and paymentStatus are provided, treat as (status = ? OR payment_status = ?)
      // This ensures fully paid orders are included even if their status wasn't updated to completed yet.
      if (status != null && paymentStatus != null) {
        query += ' AND (status = ? OR payment_status = ?)';
        args.add(status);
        args.add(paymentStatus);
      } else if (status != null) {
        query += ' AND status = ?';
        args.add(status);
      } else if (paymentStatus != null) {
        query += ' AND payment_status = ?';
        args.add(paymentStatus);
      }
      
      if (fromDate != null) {
        query += ' AND ordered_at >= ?';
        args.add(fromDate.toIso8601String());
      }
      
      if (toDate != null) {
        query += ' AND ordered_at <= ?';
        args.add(toDate.toIso8601String());
      }
      
      query += ' ORDER BY ordered_at DESC';
      
      if (limit != null) {
        query += ' LIMIT ?';
        args.add(limit);
      }
      
      if (offset != null) {
        query += ' OFFSET ?';
        args.add(offset);
      }
      
      final results = await database.rawQuery(query, args);

      // Convert and hydrate each order with children from normalized tables
      final orders = <Order>[];
      for (final row in results) {
        final orderId = row['id'] as String;
        final base = _orderFromLocalJson(row);
        final items = await getOrderItems(orderId);
        final payments = await getOrderPayments(orderId);
        final discounts = await getOrderDiscounts(orderId);
        final charges = await getOrderCharges(orderId);
        orders.add(
          base.copyWith(
            items: items,
            payments: payments,
            orderDiscounts: discounts,
            orderCharges: charges,
          ),
        );
      }
      return orders;
    } catch (e) {
      _logger.error('Failed to get orders for business', e);
      return [];
    }
  }

  // Get active orders (not completed/cancelled/refunded)
  Future<List<Order>> getActiveOrders(String businessId, String locationId) async {
    try {
      final results = await database.query(
        'orders',
        where: 'business_id = ? AND location_id = ? AND status NOT IN (?, ?, ?)',
        whereArgs: [businessId, locationId, 'completed', 'cancelled', 'refunded'],
        orderBy: 'ordered_at DESC',
      );

      final orders = <Order>[];
      for (final row in results) {
        final orderId = row['id'] as String;
        final base = _orderFromLocalJson(row);
        final items = await getOrderItems(orderId);
        final payments = await getOrderPayments(orderId);
        final discounts = await getOrderDiscounts(orderId);
        final charges = await getOrderCharges(orderId);
        orders.add(base.copyWith(
          items: items,
          payments: payments,
          orderDiscounts: discounts,
          orderCharges: charges,
        ));
      }
      return orders;
    } catch (e) {
      _logger.error('Failed to get active orders', e);
      return [];
    }
  }

  // Get today's orders
  Future<List<Order>> getTodaysOrders(String businessId, String locationId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final results = await database.query(
        'orders',
        where: 'business_id = ? AND location_id = ? AND ordered_at >= ? AND ordered_at < ?',
        whereArgs: [
          businessId,
          locationId,
          startOfDay.toIso8601String(),
          endOfDay.toIso8601String(),
        ],
        orderBy: 'ordered_at DESC',
      );

      final orders = <Order>[];
      for (final row in results) {
        final orderId = row['id'] as String;
        final base = _orderFromLocalJson(row);
        final items = await getOrderItems(orderId);
        final payments = await getOrderPayments(orderId);
        final discounts = await getOrderDiscounts(orderId);
        final charges = await getOrderCharges(orderId);
        orders.add(base.copyWith(
          items: items,
          payments: payments,
          orderDiscounts: discounts,
          orderCharges: charges,
        ));
      }
      return orders;
    } catch (e) {
      _logger.error('Failed to get today\'s orders', e);
      return [];
    }
  }

  // Get next order number
  Future<String> getNextOrderNumber(String businessId) async {
    try {
      // Get the highest order number for the business
      // Using a different approach to find the max order number
      final result = await database.rawQuery('''
        SELECT order_number FROM orders 
        WHERE business_id = ? 
        AND order_number LIKE 'ORD-%'
      ''', [businessId]);
      
      if (result.isEmpty) {
        // First order for this business
        return 'ORD-0001';
      }
      
      // Find the highest number from all order numbers
      int maxNumber = 0;
      for (final row in result) {
        final orderNumber = row['order_number'] as String;
        final parts = orderNumber.split('-');
        if (parts.length >= 2) {
          final numberPart = int.tryParse(parts.last) ?? 0;
          if (numberPart > maxNumber) {
            maxNumber = numberPart;
          }
        }
      }
      
      final nextNumber = maxNumber + 1;
      return 'ORD-${nextNumber.toString().padLeft(4, '0')}';
    } catch (e) {
      _logger.error('Failed to get next order number', e);
      // Return a timestamp-based order number as fallback
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      return 'ORD-${timestamp.substring(timestamp.length - 8)}';
    }
  }

  // Helper method to parse JSON fields that might be strings or already decoded (legacy fallback)
  dynamic _parseJsonField(dynamic field, dynamic defaultValue) {
    if (field == null) return defaultValue;
    
    // If it's already a decoded object/list, return it as is
    if (field is List || field is Map) {
      return field;
    }
    
    // If it's a string, decode it
    if (field is String) {
      // Empty string check
      if (field.isEmpty) return defaultValue;
      
      try {
        return jsonDecode(field);
      } catch (e) {
        // Check if this is corrupted data that looks like Dart object toString()
        // e.g., [{id: value, ...}] instead of [{"id": "value", ...}]
        if (field.contains('{id:') || field.contains('[{')) {
          _logger.warning('Found corrupted JSON data (likely toString() output), returning empty list');
          _logger.warning('Corrupted data sample: ${field.substring(0, field.length > 100 ? 100 : field.length)}...');
          // Return empty list for corrupted order items
          return defaultValue;
        }
        // For other parse errors, also return default
        return defaultValue;
      }
    }
    
    return defaultValue;
  }

  // Convert snake_case order item from database to camelCase for model
  Map<String, dynamic> _orderItemFromSnakeCase(Map<String, dynamic> item) {
    // Handle null values properly - convert to appropriate defaults
    return {
      'id': item['id'],
      'orderId': item['order_id'],
      'productId': item['product_id'],
      'variationId': item['variation_id'],
      'productName': item['product_name'],
      'variationName': item['variation_name'],
      'productCode': item['product_code'],  // Can be null
      'sku': item['sku'],  // Can be null
      'unitOfMeasure': item['unit_of_measure'],  // Can be null
      'quantity': item['quantity'],
      'unitPrice': item['unit_price'],
      'modifiersPrice': item['modifiers_price'],
      'modifiers': _parseJsonField(item['modifiers'], []),
      'specialInstructions': item['special_instructions'],
      'discountAmount': item['discount_amount'],
      'discountPercent': item['discount_percent'],
      'discountReason': item['discount_reason'],
      'appliedDiscountId': item['applied_discount_id'],
      'taxRate': item['tax_rate'],
      'taxAmount': item['tax_amount'],
      'taxGroupId': item['tax_group_id'],
      'taxGroupName': item['tax_group_name'],
      'subtotal': item['subtotal'],
      'total': item['total'],
      // Convert SQLite integer flags (0/1) to proper booleans expected by JSON model
      'skipKot': item['skip_kot'] == 1 || item['skip_kot'] == true,
      'kotPrinted': item['kot_printed'] == 1 || item['kot_printed'] == true,
      'kotPrintedAt': item['kot_printed_at'],
      'kotNumber': item['kot_number'],
      'preparationStatus': item['preparation_status'],
      'preparedAt': item['prepared_at'],
      'preparedBy': item['prepared_by'],
      'station': item['station'],
      'servedAt': item['served_at'],
      'servedBy': item['served_by'],
      'isVoided': item['is_voided'] == 1 || item['is_voided'] == true,
      'voidedAt': item['voided_at'],
      'voidedBy': item['voided_by'],
      'voidReason': item['void_reason'],
      'isComplimentary': item['is_complimentary'] == 1 || item['is_complimentary'] == true,
      'complimentaryReason': item['complimentary_reason'],
      'isReturned': item['is_returned'] == 1 || item['is_returned'] == true,
      'returnedQuantity': item['returned_quantity'],
      'returnedAt': item['returned_at'],
      'returnReason': item['return_reason'],
      'refundedAmount': item['refunded_amount'],
      'displayOrder': item['display_order'],
      'category': item['category'],
      'categoryId': item['category_id'],  // Can be null
      'itemNotes': item['item_notes'],
      'createdAt': item['created_at'],
      'updatedAt': item['updated_at'],
    };
  }

  // Convert local JSON row (orders table) to Order model without children; children are hydrated by callers
  Order _orderFromLocalJson(Map<String, dynamic> json) {
    try {
      // Log raw data for debugging
      if (json['id'] != null) {
        _logger.debug('Converting order ${json['id']} from local JSON');
      }
      
      // Legacy fields (prepared_by) may be present as JSON; not used going forward
      final preparedBy = _parseJsonField(json['prepared_by'], []) as List;
    
    return Order(
      id: json['id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      businessId: json['business_id'] ?? '',
      locationId: json['location_id'] ?? '',
      posDeviceId: json['pos_device_id'] ?? '',
      orderType: OrderType.values.firstWhere(
        (e) => e.value == json['order_type'],
        orElse: () => OrderType.takeaway,
      ),
      priceCategoryName: json['price_category_name'],
      orderSource: OrderSource.values.firstWhere(
        (e) => e.value == json['order_source'],
        orElse: () => OrderSource.pos,
      ),
      tableId: json['table_id'],
      tableName: json['table_name'],
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? 'Unknown',
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      deliveryAddressLine1: json['delivery_address_line1'],
      deliveryAddressLine2: json['delivery_address_line2'],
      deliveryCity: json['delivery_city'],
      deliveryPostalCode: json['delivery_postal_code'],
      deliveryPhone: json['delivery_phone'],
      deliveryInstructions: json['delivery_instructions'],
      orderedAt: json['ordered_at'] != null ? DateTime.parse(json['ordered_at']) : DateTime.now(),
      confirmedAt: json['confirmed_at'] != null && json['confirmed_at'] != '' ? DateTime.parse(json['confirmed_at']) : null,
      preparedAt: json['prepared_at'] != null && json['prepared_at'] != '' ? DateTime.parse(json['prepared_at']) : null,
      readyAt: json['ready_at'] != null && json['ready_at'] != '' ? DateTime.parse(json['ready_at']) : null,
      servedAt: json['served_at'] != null && json['served_at'] != '' ? DateTime.parse(json['served_at']) : null,
      completedAt: json['completed_at'] != null && json['completed_at'] != '' ? DateTime.parse(json['completed_at']) : null,
      cancelledAt: json['cancelled_at'] != null && json['cancelled_at'] != '' ? DateTime.parse(json['cancelled_at']) : null,
      estimatedReadyTime: json['estimated_ready_time'] != null && json['estimated_ready_time'] != '' ? DateTime.parse(json['estimated_ready_time']) : null,
      subtotal: json['subtotal']?.toDouble() ?? 0,
      discountAmount: json['discount_amount']?.toDouble() ?? 0,
      taxAmount: json['tax_amount']?.toDouble() ?? 0,
      chargesAmount: json['charges_amount']?.toDouble() ?? 0, // Added missing field
      deliveryCharge: json['delivery_charge']?.toDouble() ?? 0,
      serviceCharge: json['service_charge']?.toDouble() ?? 0,
      tipAmount: json['tip_amount']?.toDouble() ?? 0,
      roundOffAmount: json['round_off_amount']?.toDouble() ?? 0,
      total: json['total']?.toDouble() ?? 0,
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.value == json['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      totalPaid: json['total_paid']?.toDouble() ?? 0,
      changeAmount: json['change_amount']?.toDouble() ?? 0,
      status: OrderStatus.values.firstWhere(
        (e) => e.value == json['status'],
        orElse: () => OrderStatus.draft,
      ),
      kitchenStatus: json['kitchen_status'] != null 
          ? KitchenStatus.values.firstWhere(
              (e) => e.value == json['kitchen_status'],
              orElse: () => KitchenStatus.pending,
            )
          : null,
      createdBy: json['created_by'] ?? '', // Handle null with empty string
      createdByName: json['created_by_name'] ?? '', // Handle null with empty string
      servedBy: json['served_by'],
      servedByName: json['served_by_name'],
      preparedBy: preparedBy.cast<String>(),
      customerNotes: json['customer_notes'],
      kitchenNotes: json['kitchen_notes'],
      internalNotes: json['internal_notes'],
      cancellationReason: json['cancellation_reason'],
      tokenNumber: json['token_number'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      lastSyncedAt: json['last_synced_at'] != null && json['last_synced_at'] != '' ? DateTime.parse(json['last_synced_at']) : null,
      hasUnsyncedChanges: json['has_unsynced_changes'] == 1,
      isPriority: json['is_priority'] == 1,
      isVoid: json['is_void'] == 1,
      voidReason: json['void_reason'],
      voidedAt: json['voided_at'] != null && json['voided_at'] != '' ? DateTime.parse(json['voided_at']) : null,
      voidedBy: json['voided_by'],
      preparationTimeMinutes: json['preparation_time_minutes'],
      serviceTimeMinutes: json['service_time_minutes'],
      totalTimeMinutes: json['total_time_minutes'],
      // Children are loaded from normalized tables by the callers
      items: const [],
      payments: const [],
      orderDiscounts: const [],
      orderCharges: const [],
    );
    } catch (e, stackTrace) {
      _logger.error('Failed to convert order from local JSON', e, stackTrace);
      _logger.error('JSON data that failed:', json);
      rethrow;
    }
  }

  // Child loaders from normalized tables
  Future<List<OrderItem>> getOrderItems(String orderId) async {
    try {
      final rows = await database.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
        orderBy: 'display_order ASC, created_at ASC',
      );
      final items = rows.map((row) => _orderItemFromSnakeCase(row)).toList();
      return items.map((e) => OrderItem.fromJson(e)).toList();
    } catch (e) {
      _logger.error('Failed to load order items for $orderId', e);
      return [];
    }
  }

  Future<List<OrderPayment>> getOrderPayments(String orderId) async {
    try {
      final rows = await database.query(
        'order_payments',
        where: 'order_id = ?',
        whereArgs: [orderId],
        orderBy: 'paid_at ASC',
      );
      return rows.map((p) {
        final m = <String, dynamic>{
          'id': p['id'],
          'orderId': p['order_id'],
          'paymentMethodId': p['payment_method_id'],
          'paymentMethodName': p['payment_method_name'],
          'paymentMethodCode': p['payment_method_code'],
          'amount': (p['amount'] as num?)?.toDouble() ?? 0,
          'tipAmount': (p['tip_amount'] as num?)?.toDouble() ?? 0,
          'processingFee': (p['processing_fee'] as num?)?.toDouble() ?? 0,
          'totalAmount': (p['total_amount'] as num?)?.toDouble() ?? 0,
          'status': p['status'],
          'referenceNumber': p['reference_number'],
          'transactionId': p['transaction_id'],
          'approvalCode': p['approval_code'],
          'cardLastFour': p['card_last_four'],
          'cardType': p['card_type'],
          'paidAt': p['paid_at'],
          'refundedAt': p['refunded_at'],
          'refundedAmount': (p['refunded_amount'] as num?)?.toDouble() ?? 0,
          'refundReason': p['refund_reason'],
          'refundedBy': p['refunded_by'],
          'refundTransactionId': p['refund_transaction_id'],
          'processedBy': p['processed_by'],
          'processedByName': p['processed_by_name'],
          'notes': p['notes'],
          // metadata is stored as TEXT JSON; may be null
        };
        if (p['metadata'] != null) {
          try { m['metadata'] = jsonDecode(p['metadata'] as String); } catch (_) {}
        }
        // Convert date strings to ISO as expected by fromJson
        if (m['paidAt'] is String == false && p['paid_at'] != null) {
          m['paidAt'] = p['paid_at'];
        }
        return OrderPayment.fromJson(m);
      }).toList();
    } catch (e) {
      _logger.error('Failed to load order payments for $orderId', e);
      return [];
    }
  }

  Future<List<OrderDiscount>> getOrderDiscounts(String orderId) async {
    try {
      final rows = await database.query(
        'order_discounts',
        where: 'order_id = ?',
        whereArgs: [orderId],
        orderBy: 'applied_at ASC',
      );
      return rows.map((d) {
        final m = <String, dynamic>{
          'id': d['id'],
          'orderId': d['order_id'],
          'discountId': d['discount_id'],
          'discountName': d['discount_name'],
          'discountCode': d['discount_code'],
          'discountType': d['discount_type'],
          'appliedTo': d['applied_to'],
          'discountPercent': (d['discount_percent'] as num?)?.toDouble() ?? 0,
          'discountAmount': (d['discount_amount'] as num?)?.toDouble() ?? 0,
          'maximumDiscount': (d['maximum_discount'] as num?)?.toDouble() ?? 0,
          'appliedAmount': (d['applied_amount'] as num?)?.toDouble() ?? 0,
          'minimumPurchase': (d['minimum_purchase'] as num?)?.toDouble() ?? 0,
          'minimumQuantity': d['minimum_quantity'],
          'applicationMethod': d['application_method'],
          'couponCode': d['coupon_code'],
          'appliedBy': d['applied_by'],
          'appliedByName': d['applied_by_name'],
          'reason': d['reason'],
          'authorizedBy': d['authorized_by'],
          'appliedAt': d['applied_at'],
        };
        if (d['applicable_categories'] != null) {
          try { m['applicableCategories'] = jsonDecode(d['applicable_categories'] as String); } catch (_) {}
        }
        if (d['applicable_products'] != null) {
          try { m['applicableProducts'] = jsonDecode(d['applicable_products'] as String); } catch (_) {}
        }
        if (d['metadata'] != null) {
          try { m['metadata'] = jsonDecode(d['metadata'] as String); } catch (_) {}
        }
        return OrderDiscount.fromJson(m);
      }).toList();
    } catch (e) {
      _logger.error('Failed to load order discounts for $orderId', e);
      return [];
    }
  }

  Future<List<OrderCharge>> getOrderCharges(String orderId) async {
    try {
      final rows = await database.query(
        'order_charges',
        where: 'order_id = ?',
        whereArgs: [orderId],
        orderBy: 'created_at ASC',
      );
      return rows.map((c) {
        final m = <String, dynamic>{
          'id': c['id'],
          'orderId': c['order_id'],
          'chargeId': c['charge_id'],
          'chargeCode': c['charge_code'],
          'chargeName': c['charge_name'],
          'chargeType': c['charge_type'],
          'calculationType': c['calculation_type'],
          'baseAmount': (c['base_amount'] as num?)?.toDouble() ?? 0,
          'chargeRate': (c['charge_rate'] as num?)?.toDouble() ?? 0,
          'chargeAmount': (c['charge_amount'] as num?)?.toDouble() ?? 0,
          'isTaxable': (c['is_taxable'] == 1) || (c['is_taxable'] == true),
          'isManual': (c['is_manual'] == 1) || (c['is_manual'] == true),
          'createdAt': c['created_at'],
          'updatedAt': c['updated_at'],
        };
        return OrderCharge.fromJson(m);
      }).toList();
    } catch (e) {
      _logger.error('Failed to load order charges for $orderId', e);
      return [];
    }
  }
  
  // Save order charge
  Future<void> saveOrderCharge(OrderCharge charge) async {
    try {
      final chargeMap = charge.toJson();
      
      // Fix field naming from camelCase to snake_case
      chargeMap['order_id'] = chargeMap.remove('orderId');
      chargeMap['charge_id'] = chargeMap.remove('chargeId');
      chargeMap['charge_code'] = chargeMap.remove('chargeCode');
      chargeMap['charge_name'] = chargeMap.remove('chargeName');
      chargeMap['charge_type'] = chargeMap.remove('chargeType');
      chargeMap['calculation_type'] = chargeMap.remove('calculationType');
      chargeMap['base_amount'] = chargeMap.remove('baseAmount');
      chargeMap['charge_rate'] = chargeMap.remove('chargeRate');
      chargeMap['charge_amount'] = chargeMap.remove('chargeAmount');
      chargeMap['is_taxable'] = chargeMap.remove('isTaxable') == true ? 1 : 0;
      chargeMap['is_manual'] = chargeMap.remove('isManual') == true ? 1 : 0;
      
      // Remove DateTime objects from the map (they need to be converted to strings)
      chargeMap.remove('createdAt');
      chargeMap.remove('updatedAt');
      
      // Convert DateTime fields to ISO strings
      chargeMap['created_at'] = charge.createdAt.toIso8601String();
      if (charge.updatedAt != null) {
        chargeMap['updated_at'] = charge.updatedAt!.toIso8601String();
      }
      
      // Set sync tracking fields
      chargeMap['has_unsynced_changes'] = 1;
      
      await database.insert(
        'order_charges',
        chargeMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.info('Order charge saved: ${charge.chargeName}');
    } catch (e) {
      _logger.error('Failed to save order charge', e);
      rethrow;
    }
  }
}
