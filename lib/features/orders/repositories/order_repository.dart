import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../../customers/models/customer.dart';
import '../../sales/models/cart.dart';
import '../data/order_local_database.dart';
import '../models/item_modifier.dart';
import '../models/order.dart' as order_model;
import '../models/order_charge.dart';
import '../models/order_discount.dart';
import '../models/order_item.dart';
import '../models/order_payment.dart';
import '../models/order_status.dart';
import '../models/order_status_history.dart';

class OrderRepository {
  static final _logger = Logger('OrderRepository');
  static const _uuid = Uuid();

  final Database localDatabase;
  final SupabaseClient supabase;
  final SyncQueueService syncQueueService;
  final OrderLocalDatabase _localDb;

  OrderRepository({
    required this.localDatabase,
    required this.supabase,
    required this.syncQueueService,
  }) : _localDb = OrderLocalDatabase(database: localDatabase);

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    await OrderLocalDatabase.initializeTables(localDatabase);
  }

  // Convert cart to order
  Future<Either<String, order_model.Order>> createOrderFromCart({
    required Cart cart,
    required Customer customer,
    required String businessId,
    required String locationId,
    required String posDeviceId,
    required String userId,
    required String userName,
    required List<Map<String, dynamic>> payments,
    OrderType orderType = OrderType.takeaway,
    String? priceCategoryName,
    String? tableId,
    String? tableName,
    String? customerNotes,
    String? kitchenNotes,
  }) async {
    try {
      // Generate order number
      final orderNumber = await _localDb.getNextOrderNumber(businessId);
      final orderId = _uuid.v4();
      final now = DateTime.now();

      // Calculate totals from cart
      final subtotal = cart.calculatedSubtotal;
      final discountAmount = cart.totalDiscounts;
      final chargesAmount = cart.calculatedChargesAmount;
      final taxAmount = cart.totalTaxAmount;
      final total = cart.calculatedTotal;

      // Convert cart items to order items
      final orderItems = <OrderItem>[];
      int displayOrder = 0;

      for (final cartItem in cart.items) {
        final orderItemId = _uuid.v4();

        // Convert cart item modifiers to order item modifiers
        final modifiers = <ItemModifier>[];
        // TODO: Add modifier support when cart items have modifiers

        final orderItem = OrderItem(
          id: orderItemId,
          orderId: orderId,
          productId: cartItem.productId,
          variationId: cartItem.variationId,
          productName: cartItem.productName,
          variationName: cartItem.variationName,
          productCode: cartItem.productCode,
          sku: cartItem.sku,
          unitOfMeasure: cartItem.unitOfMeasure,
          quantity: cartItem.quantity,
          unitPrice: cartItem.unitPrice,
          modifiersPrice: 0,
          // TODO: Calculate from modifiers
          modifiers: modifiers,
          specialInstructions: cartItem.specialInstructions,
          discountAmount: cartItem.effectiveDiscountAmount,
          discountPercent: cartItem.discountPercent,
          discountReason: cartItem.discountReason,
          appliedDiscountId: cartItem.appliedDiscountId,
          taxRate: cartItem.taxRate,
          taxAmount: cartItem.taxAmount,
          taxGroupId: cartItem.taxGroupId,
          taxGroupName: cartItem.taxGroupName,
          subtotal: cartItem.subtotal,
          total: cartItem.lineTotal,
          skipKot: cartItem.skipKot,
          displayOrder: displayOrder++,
          category: cartItem.categoryName,
          categoryId: cartItem.categoryId,
          createdAt: now,
          updatedAt: now,
        );

        orderItems.add(orderItem);
      }

      // Convert payment information to order payments
      final orderPayments = <OrderPayment>[];
      double totalPaid = 0;

      for (final paymentData in payments) {
        final paymentId = _uuid.v4();
        final amount = (paymentData['amount'] as num).toDouble();
        final tipAmount = (paymentData['tipAmount'] ?? 0 as num).toDouble();
        final totalAmount = amount + tipAmount;

        totalPaid += totalAmount;

        final orderPayment = OrderPayment(
          id: paymentId,
          orderId: orderId,
          paymentMethodId: paymentData['methodId'] as String,
          paymentMethodName: paymentData['methodName'] as String,
          paymentMethodCode: paymentData['methodCode'] as String,
          amount: amount,
          tipAmount: tipAmount,
          totalAmount: totalAmount,
          status: 'completed',
          referenceNumber: paymentData['referenceNumber'] as String?,
          transactionId: paymentData['transactionId'] as String?,
          paidAt: now,
          processedBy: userId,
          processedByName: userName,
          createdAt: now,
          updatedAt: now,
        );

        orderPayments.add(orderPayment);
      }

      // Convert cart discounts to order discounts
      final orderDiscounts = <OrderDiscount>[];

      // Add order-level discount if present
      if (cart.orderDiscountAmount > 0 || cart.orderDiscountPercent > 0) {
        final discountId = _uuid.v4();

        final orderDiscount = OrderDiscount(
          id: discountId,
          orderId: orderId,
          discountId: discountId,
          // Use same ID since this is a manual discount
          discountName: 'Order Discount',
          discountCode: 'MANUAL',
          discountType: cart.orderDiscountPercent > 0 ? 'percentage' : 'fixed',
          appliedTo: 'order',
          discountPercent: cart.orderDiscountPercent,
          discountAmount: cart.orderDiscountAmount,
          appliedAmount: cart.effectiveOrderDiscount,
          minimumPurchase: 0,
          applicationMethod: 'manual',
          couponCode: null,
          appliedAt: now,
        );

        orderDiscounts.add(orderDiscount);
      }

      // Convert cart charges to order charges
      final orderCharges = <OrderCharge>[];
      for (final appliedCharge in cart.appliedCharges) {
        final orderCharge = OrderCharge(
          id: _uuid.v4(),
          orderId: orderId,
          chargeId: appliedCharge.chargeId,
          chargeCode: appliedCharge.chargeCode ?? 'MANUAL',
          chargeName: appliedCharge.chargeName,
          chargeType: appliedCharge.chargeType ?? 'custom',
          calculationType: appliedCharge.calculationType ?? 'fixed',
          baseAmount: appliedCharge.baseAmount ?? 0.0,
          chargeRate: appliedCharge.chargeRate ?? 0.0,
          chargeAmount: appliedCharge.chargeAmount,
          isTaxable: appliedCharge.isTaxable,
          isManual: appliedCharge.isManual,
          createdAt: now,
        );
        orderCharges.add(orderCharge);
      }

      // Calculate payment status
      final paymentStatus =
          totalPaid >= total
              ? PaymentStatus.paid
              : totalPaid > 0
              ? PaymentStatus.partial
              : PaymentStatus.pending;

      // Calculate change amount
      final changeAmount = totalPaid > total ? totalPaid - total : 0.0;

      // Determine initial order status
      final orderStatus =
          paymentStatus == PaymentStatus.paid
              ? OrderStatus.completed  // Fully paid orders are completed
              : paymentStatus == PaymentStatus.partial
              ? OrderStatus.confirmed  // Partially paid orders are confirmed
              : OrderStatus.draft;     // Unpaid orders are draft

      // Create the order
      final order = order_model.Order(
        id: orderId,
        orderNumber: orderNumber,
        businessId: businessId,
        locationId: locationId,
        posDeviceId: posDeviceId,
        orderType: orderType,
        priceCategoryName: priceCategoryName,
        orderSource: OrderSource.pos,
        tableId: tableId,
        tableName: tableName,
        customerId: customer.id,
        customerName: customer.name,
        customerPhone: customer.phone,
        customerEmail: customer.email,
        orderedAt: now,
        confirmedAt: orderStatus == OrderStatus.confirmed || orderStatus == OrderStatus.completed ? now : null,
        completedAt: orderStatus == OrderStatus.completed ? now : null,
        subtotal: subtotal,
        discountAmount: discountAmount,
        taxAmount: taxAmount,
        chargesAmount: chargesAmount,
        total: total,
        paymentStatus: paymentStatus,
        totalPaid: totalPaid,
        changeAmount: changeAmount,
        status: orderStatus,
        createdBy: userId,
        createdByName: userName,
        customerNotes: customerNotes,
        kitchenNotes: kitchenNotes,
        tokenNumber:
            orderType == OrderType.takeaway ? _generateTokenNumber() : null,
        tipAmount: 0.0,
        createdAt: now,
        updatedAt: now,
        hasUnsyncedChanges: true,
        items: orderItems,
        payments: orderPayments,
        orderDiscounts: orderDiscounts,
        orderCharges: orderCharges,
      );

      // Save order locally
      await _localDb.saveOrder(order);

      // Add to sync queue (this is a new order)
      await _addOrderToSyncQueue(order, isNewOrder: true);

      // Create status history entry
      await _createStatusHistory(
        orderId: orderId,
        fromStatus: OrderStatus.draft,
        toStatus: orderStatus,
        changedBy: userId,
        changedByName: userName,
        reason: 'Order created',
      );

      _logger.info('Order created successfully: $orderNumber');
      return Right(order);
    } catch (e, stackTrace) {
      _logger.error('Failed to create order from cart', e, stackTrace);
      return Left('Failed to create order: $e');
    }
  }

  // Get order by ID
  Future<Either<String, order_model.Order?>> getOrderById(
    String orderId,
  ) async {
    try {
      final order = await _localDb.getOrderById(orderId);
      return Right(order);
    } catch (e) {
      _logger.error('Failed to get order by ID', e);
      return Left('Failed to get order: $e');
    }
  }

  // Get orders for business
  Future<Either<String, List<order_model.Order>>> getOrders({
    required String businessId,
    String? locationId,
    String? status,
    String? paymentStatus,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final orders = await _localDb.getOrdersForBusiness(
        businessId,
        locationId: locationId,
        status: status,
        paymentStatus: paymentStatus,
        fromDate: fromDate,
        toDate: toDate,
        limit: limit,
        offset: offset,
      );

      return Right(orders);
    } catch (e) {
      _logger.error('Failed to get orders', e);
      return Left('Failed to get orders: $e');
    }
  }

  // Get active orders
  Future<Either<String, List<order_model.Order>>> getActiveOrders({
    required String businessId,
    required String locationId,
  }) async {
    try {
      final orders = await _localDb.getActiveOrders(businessId, locationId);
      return Right(orders);
    } catch (e) {
      _logger.error('Failed to get active orders', e);
      return Left('Failed to get active orders: $e');
    }
  }

  // Get today's orders
  Future<Either<String, List<order_model.Order>>> getTodaysOrders({
    required String businessId,
    required String locationId,
  }) async {
    try {
      final orders = await _localDb.getTodaysOrders(businessId, locationId);
      return Right(orders);
    } catch (e) {
      _logger.error('Failed to get today\'s orders', e);
      return Left('Failed to get today\'s orders: $e');
    }
  }
  
  // Get active orders for a specific table
  Future<Either<String, List<order_model.Order>>> getTableOrders({
    required String businessId,
    required String locationId,
    required String tableId,
  }) async {
    try {
      // Get active orders for this table (not completed or cancelled)
      final query = '''
        SELECT * FROM orders 
        WHERE business_id = ? 
        AND location_id = ? 
        AND table_id = ?
        AND status NOT IN ('completed', 'cancelled')
        ORDER BY created_at DESC
      ''';
      
      final results = await localDatabase.rawQuery(
        query,
        [businessId, locationId, tableId],
      );
      
      final orders = <order_model.Order>[];
      for (final row in results) {
        // Convert from local JSON format
        final order = await _localDb.getOrderById(row['id'] as String);
        if (order != null) {
          orders.add(order);
        }
      }
      
      _logger.info('Loaded ${orders.length} orders for table $tableId');
      return Right(orders);
    } catch (e) {
      _logger.error('Error getting table orders', e);
      return Left('Failed to get table orders: $e');
    }
  }

  // Update order status
  Future<Either<String, order_model.Order>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
    required String userId,
    required String userName,
    String? reason,
  }) async {
    try {
      // Get existing order
      final orderResult = await getOrderById(orderId);

      return orderResult.fold((error) => Left(error), (order) async {
        if (order == null) {
          return Left('Order not found');
        }

        // Validate status transition
        if (!_isValidStatusTransition(order.status, newStatus)) {
          return Left(
            'Invalid status transition from ${order.status.displayName} to ${newStatus.displayName}',
          );
        }

        final now = DateTime.now();

        // Update order with new status and timestamps
        final updatedOrder = order.copyWith(
          status: newStatus,
          confirmedAt:
              newStatus == OrderStatus.confirmed && order.confirmedAt == null
                  ? now
                  : order.confirmedAt,
          preparedAt:
              newStatus == OrderStatus.preparing && order.preparedAt == null
                  ? now
                  : order.preparedAt,
          readyAt:
              newStatus == OrderStatus.ready && order.readyAt == null
                  ? now
                  : order.readyAt,
          servedAt:
              newStatus == OrderStatus.served && order.servedAt == null
                  ? now
                  : order.servedAt,
          completedAt:
              newStatus == OrderStatus.completed && order.completedAt == null
                  ? now
                  : order.completedAt,
          cancelledAt:
              newStatus == OrderStatus.cancelled && order.cancelledAt == null
                  ? now
                  : order.cancelledAt,
          cancellationReason:
              newStatus == OrderStatus.cancelled
                  ? reason
                  : order.cancellationReason,
          updatedAt: now,
          hasUnsyncedChanges: true,
        );

        // Save updated order
        await _localDb.saveOrder(updatedOrder);

        // Add to sync queue
        await _addOrderToSyncQueue(updatedOrder);

        // Create status history entry
        await _createStatusHistory(
          orderId: orderId,
          fromStatus: order.status,
          toStatus: newStatus,
          changedBy: userId,
          changedByName: userName,
          reason: reason,
        );

        _logger.info(
          'Order status updated: $orderId from ${order.status} to $newStatus',
        );
        return Right(updatedOrder);
      });
    } catch (e) {
      _logger.error('Failed to update order status', e);
      return Left('Failed to update order status: $e');
    }
  }

  // Validate status transition
  bool _isValidStatusTransition(OrderStatus from, OrderStatus to) {
    // Define valid transitions
    final validTransitions = {
      OrderStatus.draft: [
        OrderStatus.confirmed, 
        OrderStatus.served,  // Allow direct billing from draft
        OrderStatus.completed, // Allow direct payment completion from draft
        OrderStatus.cancelled,
      ],
      OrderStatus.confirmed: [
        OrderStatus.preparing, 
        OrderStatus.served,  // Allow billing from confirmed
        OrderStatus.cancelled,
      ],
      OrderStatus.preparing: [OrderStatus.ready, OrderStatus.cancelled],
      OrderStatus.ready: [
        OrderStatus.served,
        OrderStatus.picked,
        OrderStatus.cancelled,
      ],
      OrderStatus.served: [OrderStatus.completed],
      OrderStatus.picked: [OrderStatus.completed],
      OrderStatus.completed: [OrderStatus.refunded],
      OrderStatus.cancelled: <OrderStatus>[],
      OrderStatus.refunded: <OrderStatus>[],
    };

    return validTransitions[from]?.contains(to) ?? false;
  }

  // Generate token number for takeaway orders
  String _generateTokenNumber() {
    // Generate a 3-digit token number for the day
    // In production, this should be sequential per day
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    return random.toString().padLeft(3, '0');
  }

  // Add order to sync queue
  Future<void> _addOrderToSyncQueue(order_model.Order order, {bool isNewOrder = false, Set<String>? existingItemIds}) async {
    try {
      // Convert to snake_case for Supabase
      final orderData = _orderToSupabaseFormat(order);

      // Use INSERT for new orders, UPDATE for existing ones
      // The sync processor will handle duplicate order numbers using upsert for INSERT operations
      final operation = isNewOrder ? 'INSERT' : 'UPDATE';
      
      await syncQueueService.addToQueue(
        'orders',
        operation,
        order.id,
        orderData,
      );

      // Add items to sync queue
      for (final item in order.items) {
        final itemData = _orderItemToSupabaseFormat(item);
        
        // For existing orders, check if item was in the original order
        // If existingItemIds is provided and contains this item ID, it's an update
        final isExistingItem = !isNewOrder && existingItemIds?.contains(item.id) == true;
        
        await syncQueueService.addToQueue(
          'order_items',
          isExistingItem ? 'UPDATE' : 'INSERT',
          item.id,
          itemData,
        );
      }

      // Add payments to sync queue
      for (final payment in order.payments) {
        final paymentData = _orderPaymentToSupabaseFormat(payment);
        await syncQueueService.addToQueue(
          'order_payments',
          'INSERT',
          payment.id,
          paymentData,
        );
      }

      // Add discounts to sync queue
      for (final discount in order.orderDiscounts) {
        final discountData = _orderDiscountToSupabaseFormat(discount);
        await syncQueueService.addToQueue(
          'order_discounts',
          'INSERT',
          discount.id,
          discountData,
        );
      }

      // Add charges to sync queue
      for (final charge in order.orderCharges) {
        final chargeData = _orderChargeToSupabaseFormat(charge);
        await syncQueueService.addToQueue(
          'order_charges',
          'INSERT',
          charge.id,
          chargeData,
        );
      }
    } catch (e) {
      _logger.error('Failed to add order to sync queue', e);
    }
  }

  // Update order items for existing order
  Future<Either<String, order_model.Order>> updateOrderItems({
    required String orderId,
    required Cart cart,
    required String userId,
    required String userName,
  }) async {
    try {
      // Get existing order
      final orderResult = await getOrderById(orderId);
      
      return orderResult.fold((error) => Left(error), (existingOrder) async {
        if (existingOrder == null) {
          return Left('Order not found');
        }
        
        // Check if order can be edited
        if (!existingOrder.canEdit) {
          return Left('Order cannot be edited in status: ${existingOrder.status.displayName}');
        }
        
        final now = DateTime.now();
        
        // Calculate new totals from cart
        final subtotal = cart.calculatedSubtotal;
        final discountAmount = cart.totalDiscounts;
        final chargesAmount = cart.calculatedChargesAmount;
        final taxAmount = cart.totalTaxAmount;
        final total = cart.calculatedTotal;
        
        // Convert cart items to order items
        final orderItems = <OrderItem>[];
        int displayOrder = 0;
        
        // Map to track existing order items by product/variation for quantity updates
        final existingItemsMap = <String, OrderItem>{};
        for (final item in existingOrder.items) {
          final key = '${item.productId}_${item.variationId}';
          existingItemsMap[key] = item;
        }
        
        for (final cartItem in cart.items) {
          // Check if this item already exists in the order (by metadata or product/variation key)
          final orderItemId = cartItem.metadata['orderItemId'] as String? ?? 
                             existingItemsMap['${cartItem.productId}_${cartItem.variationId}']?.id ?? 
                             _uuid.v4();
          
          final orderItem = OrderItem(
            id: orderItemId,
            orderId: orderId,
            productId: cartItem.productId,
            variationId: cartItem.variationId,
            productName: cartItem.productName,
            variationName: cartItem.variationName,
            productCode: cartItem.productCode,
            sku: cartItem.sku,
            unitOfMeasure: cartItem.unitOfMeasure,
            quantity: cartItem.quantity,
            unitPrice: cartItem.unitPrice,
            modifiersPrice: 0,
            modifiers: [],
            specialInstructions: cartItem.specialInstructions,
            discountAmount: cartItem.effectiveDiscountAmount,
            discountPercent: cartItem.discountPercent,
            discountReason: cartItem.discountReason,
            appliedDiscountId: cartItem.appliedDiscountId,
            taxRate: cartItem.taxRate,
            taxAmount: cartItem.taxAmount,
            skipKot: cartItem.skipKot,
            subtotal: cartItem.subtotal,
            total: cartItem.lineTotal,
            displayOrder: displayOrder++,
            preparationStatus: PreparationStatus.pending,
            createdAt: now,
            updatedAt: now,
          );
          
          orderItems.add(orderItem);
        }
        
        // Update order with new items and totals
        final updatedOrder = existingOrder.copyWith(
          items: orderItems,
          subtotal: subtotal,
          discountAmount: discountAmount,
          taxAmount: taxAmount,
          chargesAmount: chargesAmount,
          total: total,
          updatedAt: now,
          hasUnsyncedChanges: true,
        );
        
        // Save updated order to local database
        await _localDb.saveOrder(updatedOrder);
        
        // Delete old order items from local database
        await localDatabase.delete(
          'order_items',
          where: 'order_id = ?',
          whereArgs: [orderId],
        );
        
        // Save new order items
        for (final item in orderItems) {
          await _localDb.saveOrderItem(item);
        }
        
        // Add to sync queue with existing item IDs for proper INSERT/UPDATE handling
        final existingItemIds = existingOrder.items.map((item) => item.id).toSet();
        await _addOrderToSyncQueue(updatedOrder, existingItemIds: existingItemIds);
        
        _logger.info('Order items updated for order: $orderId');
        return Right(updatedOrder);
      });
    } catch (e) {
      _logger.error('Failed to update order items', e);
      return Left('Failed to update order items: $e');
    }
  }

  // Create status history entry
  Future<void> _createStatusHistory({
    required String orderId,
    required OrderStatus fromStatus,
    required OrderStatus toStatus,
    required String changedBy,
    required String changedByName,
    String? reason,
    String? notes,
  }) async {
    try {
      final historyId = _uuid.v4();
      final now = DateTime.now();

      final history = OrderStatusHistory(
        id: historyId,
        orderId: orderId,
        fromStatus: fromStatus,
        toStatus: toStatus,
        changedBy: changedBy,
        changedByName: changedByName,
        changedAt: now,
        reason: reason,
        notes: notes,
      );

      // Save to local database
      final historyMap = history.toJson();

      // Fix field naming from camelCase to snake_case
      historyMap['order_id'] = historyMap.remove('orderId');
      historyMap['from_status'] = historyMap.remove('fromStatus');
      historyMap['to_status'] = historyMap.remove('toStatus');
      historyMap['changed_by'] = historyMap.remove('changedBy');
      historyMap['changed_by_name'] = historyMap.remove('changedByName');
      historyMap['changed_by_role'] = historyMap.remove('changedByRole');
      historyMap['device_id'] = historyMap.remove('deviceId');
      historyMap['ip_address'] = historyMap.remove('ipAddress');

      // Remove DateTime object and convert to string
      historyMap.remove('changedAt');
      historyMap['changed_at'] = now.toIso8601String();

      // Override enum values with string values
      historyMap['from_status'] = fromStatus.value;
      historyMap['to_status'] = toStatus.value;

      await localDatabase.insert('order_status_history', historyMap);

      // Add to sync queue
      await syncQueueService.addToQueue(
        'order_status_history',
        'INSERT',
        historyId,
        _orderStatusHistoryToSupabaseFormat(history),
      );
    } catch (e) {
      _logger.error('Failed to create status history', e);
    }
  }

  // Format conversion methods for Supabase
  Map<String, dynamic> _orderToSupabaseFormat(order_model.Order order) {
    return {
      'id': order.id,
      'order_number': order.orderNumber,
      'business_id': order.businessId,
      'location_id': order.locationId,
      'pos_device_id': order.posDeviceId,
      'order_type': order.orderType.value,
      'price_category_name': order.priceCategoryName,
      'order_source': order.orderSource.value,
      'table_id': order.tableId,
      'table_name': order.tableName,
      'customer_id': order.customerId,
      'customer_name': order.customerName,
      'customer_phone': order.customerPhone,
      'customer_email': order.customerEmail,
      'delivery_address_line1': order.deliveryAddressLine1,
      'delivery_address_line2': order.deliveryAddressLine2,
      'delivery_city': order.deliveryCity,
      'delivery_postal_code': order.deliveryPostalCode,
      'delivery_phone': order.deliveryPhone,
      'delivery_instructions': order.deliveryInstructions,
      'ordered_at': order.orderedAt.toIso8601String(),
      'confirmed_at': order.confirmedAt?.toIso8601String(),
      'prepared_at': order.preparedAt?.toIso8601String(),
      'ready_at': order.readyAt?.toIso8601String(),
      'served_at': order.servedAt?.toIso8601String(),
      'completed_at': order.completedAt?.toIso8601String(),
      'cancelled_at': order.cancelledAt?.toIso8601String(),
      'estimated_ready_time': order.estimatedReadyTime?.toIso8601String(),
      'subtotal': order.subtotal,
      'discount_amount': order.discountAmount,
      'tax_amount': order.taxAmount,
      'charges_amount': order.chargesAmount,
      'delivery_charge': order.deliveryCharge,
      'service_charge': order.serviceCharge,
      'tip_amount': order.tipAmount,
      'round_off_amount': order.roundOffAmount,
      'total': order.total,
      'payment_status': order.paymentStatus.value,
      'total_paid': order.totalPaid,
      'change_amount': order.changeAmount,
      'status': order.status.value,
      'kitchen_status': order.kitchenStatus?.value,
      'created_by': order.createdBy,
      'created_by_name': order.createdByName,
      'served_by': order.servedBy,
      'served_by_name': order.servedByName,
      'customer_notes': order.customerNotes,
      'kitchen_notes': order.kitchenNotes,
      'internal_notes': order.internalNotes,
      'cancellation_reason': order.cancellationReason,
      'token_number': order.tokenNumber,
      'created_at': order.createdAt.toIso8601String(),
      'updated_at': order.updatedAt.toIso8601String(),
      'is_priority': order.isPriority,
      'is_void': order.isVoid,
      'void_reason': order.voidReason,
      'voided_at': order.voidedAt?.toIso8601String(),
      'voided_by': order.voidedBy,
      'preparation_time_minutes': order.preparationTimeMinutes,
      'service_time_minutes': order.serviceTimeMinutes,
      'total_time_minutes': order.totalTimeMinutes,
    };
  }

  Map<String, dynamic> _orderItemToSupabaseFormat(OrderItem item) {
    return {
      'id': item.id,
      'order_id': item.orderId,
      'product_id': item.productId,
      'variation_id': item.variationId,
      'product_name': item.productName,
      'variation_name': item.variationName,
      'product_code': item.productCode,
      'sku': item.sku,
      'unit_of_measure': item.unitOfMeasure,
      'quantity': item.quantity,
      'unit_price': item.unitPrice,
      'modifiers_price': item.modifiersPrice,
      'modifiers': item.modifiers.map((m) => m.toJson()).toList(),
      'special_instructions': item.specialInstructions,
      'discount_amount': item.discountAmount,
      'discount_percent': item.discountPercent,
      'discount_reason': item.discountReason,
      'applied_discount_id': item.appliedDiscountId,
      'tax_rate': item.taxRate,
      'tax_amount': item.taxAmount,
      'tax_group_id': item.taxGroupId,
      'tax_group_name': item.taxGroupName,
      'subtotal': item.subtotal,
      'total': item.total,
      'skip_kot': item.skipKot,
      'kot_printed': item.kotPrinted,
      'kot_printed_at': item.kotPrintedAt?.toIso8601String(),
      'kot_number': item.kotNumber,
      'preparation_status': item.preparationStatus.value,
      'prepared_at': item.preparedAt?.toIso8601String(),
      'prepared_by': item.preparedBy,
      'station': item.station,
      'served_at': item.servedAt?.toIso8601String(),
      'served_by': item.servedBy,
      'is_voided': item.isVoided,
      'voided_at': item.voidedAt?.toIso8601String(),
      'voided_by': item.voidedBy,
      'void_reason': item.voidReason,
      'is_complimentary': item.isComplimentary,
      'complimentary_reason': item.complimentaryReason,
      'is_returned': item.isReturned,
      'returned_quantity': item.returnedQuantity,
      'returned_at': item.returnedAt?.toIso8601String(),
      'return_reason': item.returnReason,
      'refunded_amount': item.refundedAmount,
      'display_order': item.displayOrder,
      'category': item.category,
      'category_id': item.categoryId,
      'item_notes': item.itemNotes,
      'created_at': item.createdAt.toIso8601String(),
      'updated_at': item.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _orderPaymentToSupabaseFormat(OrderPayment payment) {
    return {
      'id': payment.id,
      'order_id': payment.orderId,
      'payment_method_id': payment.paymentMethodId,
      'payment_method_name': payment.paymentMethodName,
      'payment_method_code': payment.paymentMethodCode,
      'amount': payment.amount,
      'tip_amount': payment.tipAmount,
      'processing_fee': payment.processingFee,
      'total_amount': payment.totalAmount,
      'status': payment.status,
      'reference_number': payment.referenceNumber,
      'transaction_id': payment.transactionId,
      'approval_code': payment.approvalCode,
      'card_last_four': payment.cardLastFour,
      'card_type': payment.cardType,
      'paid_at': payment.paidAt.toIso8601String(),
      'refunded_at': payment.refundedAt?.toIso8601String(),
      'refunded_amount': payment.refundedAmount,
      'refund_reason': payment.refundReason,
      'refunded_by': payment.refundedBy,
      'refund_transaction_id': payment.refundTransactionId,
      'processed_by': payment.processedBy,
      'processed_by_name': payment.processedByName,
      'notes': payment.notes,
      'metadata': payment.metadata,
      'created_at': payment.createdAt.toIso8601String(),
      'updated_at': payment.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _orderDiscountToSupabaseFormat(OrderDiscount discount) {
    return {
      'id': discount.id,
      'order_id': discount.orderId,
      'discount_id': discount.discountId,
      'discount_name': discount.discountName,
      'discount_code': discount.discountCode,
      'discount_type': discount.discountType,
      'applied_to': discount.appliedTo,
      'discount_percent': discount.discountPercent,
      'discount_amount': discount.discountAmount,
      'maximum_discount': discount.maximumDiscount,
      'applied_amount': discount.appliedAmount,
      'minimum_purchase': discount.minimumPurchase,
      'minimum_quantity': discount.minimumQuantity,
      'applicable_categories': discount.applicableCategories,
      'applicable_products': discount.applicableProducts,
      'application_method': discount.applicationMethod,
      'coupon_code': discount.couponCode,
      'applied_by': discount.appliedBy,
      'applied_by_name': discount.appliedByName,
      'reason': discount.reason,
      'authorized_by': discount.authorizedBy,
      'applied_at': discount.appliedAt.toIso8601String(),
      'metadata': discount.metadata,
    };
  }

  Map<String, dynamic> _orderChargeToSupabaseFormat(OrderCharge charge) {
    return {
      'id': charge.id,
      'order_id': charge.orderId,
      'charge_id': charge.chargeId,
      'charge_code': charge.chargeCode,
      'charge_name': charge.chargeName,
      'charge_type': charge.chargeType,
      'calculation_type': charge.calculationType,
      'base_amount': charge.baseAmount,
      'charge_rate': charge.chargeRate,
      'charge_amount': charge.chargeAmount,
      'is_taxable': charge.isTaxable,
      'is_manual': charge.isManual,
      'created_at': charge.createdAt.toIso8601String(),
      'updated_at': charge.updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> _orderStatusHistoryToSupabaseFormat(
    OrderStatusHistory history,
  ) {
    return {
      'id': history.id,
      'order_id': history.orderId,
      'from_status': history.fromStatus.value,
      'to_status': history.toStatus.value,
      'changed_by': history.changedBy,
      'changed_by_name': history.changedByName,
      'changed_by_role': history.changedByRole,
      'changed_at': history.changedAt.toIso8601String(),
      'reason': history.reason,
      'notes': history.notes,
      'device_id': history.deviceId,
      'ip_address': history.ipAddress,
      'metadata': history.metadata,
    };
  }
}
