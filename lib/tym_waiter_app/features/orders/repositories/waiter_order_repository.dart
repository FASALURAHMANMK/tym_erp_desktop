import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/customers/models/customer.dart';
import '../../../../features/orders/models/order.dart';
import '../../../../features/orders/models/order_item.dart';
import '../../../../features/orders/models/order_status.dart';
import '../../../../features/sales/models/cart.dart';
import '../../../../features/sales/models/cart_item.dart';

/// Repository for managing orders in the waiter app
/// This repository directly interacts with Supabase (cloud-first approach)
class WaiterOrderRepository {
  static final _logger = Logger('WaiterOrderRepository');
  static const _uuid = Uuid();
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Generate order number based on business prefix and sequence
  Future<String> _generateOrderNumber(String businessId, String locationId) async {
    try {
      // Get the next order sequence for this location
      final today = DateTime.now().toIso8601String().substring(0, 10);
      
      // Get today's order count
      final response = await _supabase
          .from('orders')
          .select('order_number')
          .eq('business_id', businessId)
          .eq('location_id', locationId)
          .gte('created_at', '$today 00:00:00')
          .lte('created_at', '$today 23:59:59')
          .order('created_at', ascending: false)
          .limit(1);

      int sequence = 1;
      if (response.isNotEmpty) {
        // Extract sequence from last order number
        final lastOrderNumber = response.first['order_number'] as String;
        final parts = lastOrderNumber.split('-');
        if (parts.length > 1) {
          sequence = (int.tryParse(parts.last) ?? 0) + 1;
        }
      }

      // Format: YYYYMMDD-XXXX
      final dateStr = today.replaceAll('-', '');
      return '$dateStr-${sequence.toString().padLeft(4, '0')}';
    } catch (e) {
      _logger.error('Error generating order number', e);
      // Fallback to UUID-based number
      return 'ORD-${_uuid.v4().substring(0, 8).toUpperCase()}';
    }
  }

  /// Get or create walk-in customer for the business
  Future<String> _ensureWalkInCustomer(String businessId) async {
    try {
      // Use deterministic UUID for walk-in customer (same as desktop app)
      const namespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
      final walkInId = const Uuid().v5(namespace, 'walk_in_$businessId');
      
      // Check if walk-in customer exists in Supabase
      final response = await _supabase
          .from('customers')
          .select()
          .eq('id', walkInId)
          .maybeSingle();
      
      if (response != null) {
        return walkInId;
      }
      
      // Create walk-in customer if it doesn't exist
      final walkInCustomer = Customer.createWalkInCustomer(businessId);
      
      // Try to insert, but if RLS policy fails, just return the ID
      // The desktop app will eventually create and sync the customer
      try {
        await _supabase.from('customers').insert({
          'id': walkInCustomer.id,
          'business_id': walkInCustomer.businessId,
          'customer_code': walkInCustomer.customerCode,
          'name': walkInCustomer.name,
          'customer_type': walkInCustomer.customerType,
          'credit_limit': 0,
          'payment_terms': 0,
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        _logger.info('Created walk-in customer for business: $businessId');
      } catch (insertError) {
        _logger.warning('Could not create walk-in customer (RLS policy), using deterministic ID: $insertError');
        // Still return the deterministic ID - it will work once the customer exists
      }
      
      return walkInCustomer.id;
    } catch (e) {
      _logger.error('Error ensuring walk-in customer', e);
      // Use deterministic UUID even on error
      const namespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
      return const Uuid().v5(namespace, 'walk_in_$businessId');
    }
  }
  

  /// Create a new order from cart
  Future<Order> createOrder({
    required Cart cart,
    required OrderStatus initialStatus,
    required String waiterId,
    String? waiterName,
    String? kitchenNotes,
  }) async {
    try {
      _logger.info('Creating order with status: ${initialStatus.displayName}');

      // Generate order ID and number
      final orderId = _uuid.v4();
      final orderNumber = await _generateOrderNumber(
        cart.businessId,
        cart.locationId,
      );
      
      // Prepare order data
      final now = DateTime.now();
      final orderData = {
        'id': orderId,
        'order_number': orderNumber,
        'business_id': cart.businessId,
        'location_id': cart.locationId,
        // pos_device_id is intentionally not set for waiter-created orders
        // It will be set when payment is processed at a POS terminal
        'order_type': 'dineIn',
        'order_source': 'pos',
        'table_id': cart.tableId,
        'table_name': cart.tableName,
        'customer_id': cart.customerId ?? await _ensureWalkInCustomer(cart.businessId),
        'customer_name': cart.customerName ?? 'Walk-in Customer',
        'customer_phone': cart.customerPhone,
        'ordered_at': now.toIso8601String(),
        'status': initialStatus.value,
        'payment_status': 'pending',
        'subtotal': cart.calculatedSubtotal,
        'discount_amount': cart.totalDiscountAmount,
        'tax_amount': cart.totalTaxAmount,
        'charges_amount': cart.totalChargesAmount,
        'total': cart.calculatedTotal,
        'created_by': waiterId,
        'created_by_name': waiterName,
        'served_by': waiterId,
        'served_by_name': waiterName,
        'kitchen_notes': kitchenNotes,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      // Set status-specific timestamps
      if (initialStatus == OrderStatus.confirmed) {
        orderData['confirmed_at'] = now.toIso8601String();
        orderData['kitchen_status'] = 'pending';
      } else if (initialStatus == OrderStatus.served) {
        orderData['confirmed_at'] = now.toIso8601String();
        orderData['served_at'] = now.toIso8601String();
        orderData['kitchen_status'] = 'ready';
      }

      // Insert order
      await _supabase.from('orders').insert(orderData);

      // Prepare order items
      final orderItems = <Map<String, dynamic>>[];
      for (var i = 0; i < cart.items.length; i++) {
        final item = cart.items[i];
        final itemData = {
          'id': _uuid.v4(),
          'order_id': orderId,
          'product_id': item.productId,
          'variation_id': item.variationId,
          'product_name': item.productName,
          'variation_name': item.variationName,
          'product_code': item.productCode,
          'sku': item.sku,
          'unit_of_measure': item.unitOfMeasure,
          'quantity': item.quantity,
          'unit_price': item.unitPrice,
          'discount_amount': item.discountAmount,
          'discount_percent': item.discountPercent,
          'tax_rate': item.taxRate,
          'tax_amount': item.taxAmount,
          'subtotal': item.lineSubtotal,
          'total': item.lineTotal,
          'special_instructions': item.specialInstructions,
          'category': item.categoryName,
          'category_id': item.categoryId,
          'display_order': i,
          'preparation_status': 'pending',
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        // Mark items as KOT printed if status is confirmed or served
        if (initialStatus == OrderStatus.confirmed || 
            initialStatus == OrderStatus.served) {
          itemData['kot_printed'] = true;
          itemData['kot_printed_at'] = now.toIso8601String();
          itemData['kot_number'] = orderNumber; // Use order number as KOT number
        }

        orderItems.add(itemData);
      }

      // Insert order items
      if (orderItems.isNotEmpty) {
        await _supabase.from('order_items').insert(orderItems);
      }

      // Update table status if this is a dine-in order
      if (cart.tableId != null) {
        await _updateTableStatus(cart.tableId!, orderId, initialStatus);
      }

      _logger.info('Order created successfully: $orderNumber');
      
      // Get the actual customer ID used
      final actualCustomerId = orderData['customer_id'] as String;

      // Construct and return the Order object
      return Order(
        id: orderId,
        orderNumber: orderNumber,
        businessId: cart.businessId,
        locationId: cart.locationId,
        posDeviceId: '', // Empty string for waiter-created orders
        orderType: OrderType.dineIn,
        orderSource: OrderSource.pos,
        tableId: cart.tableId,
        tableName: cart.tableName,
        customerId: actualCustomerId,
        customerName: cart.customerName ?? 'Walk-in Customer',
        customerPhone: cart.customerPhone,
        orderedAt: now,
        confirmedAt: initialStatus == OrderStatus.confirmed ? now : null,
        servedAt: initialStatus == OrderStatus.served ? now : null,
        items: cart.items.map((item) => OrderItem(
          id: _uuid.v4(),
          orderId: orderId,
          productId: item.productId,
          variationId: item.variationId,
          productName: item.productName,
          variationName: item.variationName,
          productCode: item.productCode,
          sku: item.sku,
          unitOfMeasure: item.unitOfMeasure,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          discountAmount: item.discountAmount,
          discountPercent: item.discountPercent,
          taxRate: item.taxRate,
          taxAmount: item.taxAmount,
          subtotal: item.lineSubtotal,
          total: item.lineTotal,
          specialInstructions: item.specialInstructions,
          category: item.categoryName,
          categoryId: item.categoryId,
          preparationStatus: PreparationStatus.pending,
          kotPrinted: initialStatus == OrderStatus.confirmed || 
                      initialStatus == OrderStatus.served,
          kotPrintedAt: (initialStatus == OrderStatus.confirmed || 
                        initialStatus == OrderStatus.served) ? now : null,
          kotNumber: (initialStatus == OrderStatus.confirmed || 
                     initialStatus == OrderStatus.served) ? orderNumber : null,
          createdAt: now,
          updatedAt: now,
        )).toList(),
        subtotal: cart.calculatedSubtotal,
        discountAmount: cart.totalDiscountAmount,
        taxAmount: cart.totalTaxAmount,
        chargesAmount: cart.totalChargesAmount,
        total: cart.calculatedTotal,
        status: initialStatus,
        paymentStatus: PaymentStatus.pending,
        kitchenStatus: initialStatus == OrderStatus.confirmed 
            ? KitchenStatus.pending 
            : null,
        createdBy: waiterId,
        createdByName: waiterName,
        servedBy: waiterId,
        servedByName: waiterName,
        kitchenNotes: kitchenNotes,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      _logger.error('Error creating order', e);
      throw Exception('Failed to create order: $e');
    }
  }

  /// Update table status based on order status
  Future<void> _updateTableStatus(
    String tableId,
    String orderId,
    OrderStatus orderStatus,
  ) async {
    try {
      String status;
      switch (orderStatus) {
        case OrderStatus.draft:
        case OrderStatus.confirmed:
        case OrderStatus.preparing:
        case OrderStatus.ready:
          status = 'occupied';
          break;
        case OrderStatus.served:
          status = 'billed';
          break;
        case OrderStatus.completed:
        case OrderStatus.cancelled:
        case OrderStatus.refunded:
          status = 'free';
          break;
        default:
          status = 'occupied';
      }

      await _supabase
          .from('tables')
          .update({
            'status': status,
            'current_order_id': orderStatus.isActive ? orderId : null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', tableId);

      _logger.info('Updated table $tableId status to $status');
    } catch (e) {
      _logger.error('Error updating table status', e);
      // Don't throw - table status update is not critical
    }
  }

  /// Get orders for a table
  Future<List<Order>> getTableOrders(String tableId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            *,
            order_items(*)
          ''')
          .eq('table_id', tableId)
          .inFilter('status', ['draft', 'confirmed', 'served'])
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => _orderFromSupabase(json))
          .toList();
    } catch (e) {
      _logger.error('Error fetching table orders', e);
      throw Exception('Failed to fetch table orders: $e');
    }
  }

  /// Convert Supabase response to Order model
  Order _orderFromSupabase(Map<String, dynamic> data) {
    // Parse order items
    final items = <OrderItem>[];
    if (data['order_items'] != null) {
      for (final itemData in data['order_items'] as List) {
        items.add(OrderItem(
          id: itemData['id'],
          orderId: itemData['order_id'],
          productId: itemData['product_id'],
          variationId: itemData['variation_id'],
          productName: itemData['product_name'],
          variationName: itemData['variation_name'],
          productCode: itemData['product_code'],
          sku: itemData['sku'],
          unitOfMeasure: itemData['unit_of_measure'],
          quantity: (itemData['quantity'] as num).toDouble(),
          unitPrice: (itemData['unit_price'] as num).toDouble(),
          discountAmount: (itemData['discount_amount'] as num?)?.toDouble() ?? 0,
          discountPercent: (itemData['discount_percent'] as num?)?.toDouble() ?? 0,
          taxRate: (itemData['tax_rate'] as num?)?.toDouble() ?? 0,
          taxAmount: (itemData['tax_amount'] as num?)?.toDouble() ?? 0,
          subtotal: (itemData['subtotal'] as num?)?.toDouble() ?? 0,
          total: (itemData['total'] as num?)?.toDouble() ?? 0,
          specialInstructions: itemData['special_instructions'],
          category: itemData['category'],
          categoryId: itemData['category_id'],
          displayOrder: itemData['display_order'] ?? 0,
          preparationStatus: PreparationStatus.values.firstWhere(
            (s) => s.value == itemData['preparation_status'],
            orElse: () => PreparationStatus.pending,
          ),
          kotPrinted: itemData['kot_printed'] ?? false,
          kotPrintedAt: itemData['kot_printed_at'] != null
              ? DateTime.parse(itemData['kot_printed_at'])
              : null,
          kotNumber: itemData['kot_number'],
          createdAt: DateTime.parse(itemData['created_at']),
          updatedAt: DateTime.parse(itemData['updated_at']),
        ));
      }
    }

    return Order(
      id: data['id'],
      orderNumber: data['order_number'],
      businessId: data['business_id'],
      locationId: data['location_id'],
      posDeviceId: data['pos_device_id'] ?? '', // Handle null POS device ID
      orderType: OrderType.values.firstWhere(
        (t) => t.value == data['order_type'],
        orElse: () => OrderType.dineIn,
      ),
      orderSource: OrderSource.values.firstWhere(
        (s) => s.value == data['order_source'],
        orElse: () => OrderSource.pos,
      ),
      tableId: data['table_id'],
      tableName: data['table_name'],
      customerId: data['customer_id'],
      customerName: data['customer_name'],
      customerPhone: data['customer_phone'],
      orderedAt: DateTime.parse(data['ordered_at']),
      confirmedAt: data['confirmed_at'] != null
          ? DateTime.parse(data['confirmed_at'])
          : null,
      servedAt: data['served_at'] != null
          ? DateTime.parse(data['served_at'])
          : null,
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'])
          : null,
      items: items,
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0,
      discountAmount: (data['discount_amount'] as num?)?.toDouble() ?? 0,
      taxAmount: (data['tax_amount'] as num?)?.toDouble() ?? 0,
      chargesAmount: (data['charges_amount'] as num?)?.toDouble() ?? 0,
      total: (data['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.value == data['status'],
        orElse: () => OrderStatus.draft,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (s) => s.value == data['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      kitchenStatus: data['kitchen_status'] != null
          ? KitchenStatus.values.firstWhere(
              (s) => s.value == data['kitchen_status'],
              orElse: () => KitchenStatus.pending,
            )
          : null,
      totalPaid: (data['total_paid'] as num?)?.toDouble() ?? 0,
      createdBy: data['created_by'],
      createdByName: data['created_by_name'],
      servedBy: data['served_by'],
      servedByName: data['served_by_name'],
      kitchenNotes: data['kitchen_notes'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }
}