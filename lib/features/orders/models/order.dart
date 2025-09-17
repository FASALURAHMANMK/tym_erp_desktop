import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_status.dart';
import 'order_item.dart';
import 'order_payment.dart';
import 'order_discount.dart';
import 'order_charge.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  @JsonSerializable(explicitToJson: true)
  const factory Order({
    // Identification
    required String id,
    required String orderNumber,
    required String businessId,
    required String locationId,
    required String posDeviceId,
    
    // Order Type & Context
    @Default(OrderType.dineIn) OrderType orderType,
    String? priceCategoryName, // Original price category name for reporting (e.g., "Catering", "VIP Service")
    @Default(OrderSource.pos) OrderSource orderSource,
    String? tableId,
    String? tableName, // Snapshot for display
    
    // Customer Information
    required String customerId,
    required String customerName, // Snapshot
    String? customerPhone, // Snapshot
    String? customerEmail, // Snapshot
    
    // Delivery Information (for delivery orders)
    String? deliveryAddressLine1,
    String? deliveryAddressLine2,
    String? deliveryCity,
    String? deliveryPostalCode,
    String? deliveryPhone,
    String? deliveryInstructions,
    
    // Timing
    required DateTime orderedAt,
    DateTime? confirmedAt,
    DateTime? preparedAt,
    DateTime? readyAt,
    DateTime? servedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? estimatedReadyTime,
    
    // Order Items
    @Default([]) List<OrderItem> items,
    
    // Pricing (all amounts are final calculated values)
    @Default(0) double subtotal,
    @Default(0) double discountAmount,
    @Default(0) double taxAmount,
    @Default(0) double chargesAmount, // Total of all charges
    @Default(0) double deliveryCharge, // Deprecated - use charges list
    @Default(0) double serviceCharge, // Deprecated - use charges list
    @Default(0) double tipAmount,
    @Default(0) double roundOffAmount,
    required double total,
    
    // Discounts Applied
    @Default([]) List<OrderDiscount> orderDiscounts,
    
    // Charges Applied
    @Default([]) List<OrderCharge> orderCharges,
    
    // Payment
    @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    @Default([]) List<OrderPayment> payments,
    @Default(0) double totalPaid,
    @Default(0) double changeAmount,
    
    // Status
    @Default(OrderStatus.draft) OrderStatus status,
    KitchenStatus? kitchenStatus,
    
    // Staff Information
    required String createdBy, // User ID
    String? createdByName, // Snapshot
    String? servedBy, // Waiter ID
    String? servedByName, // Snapshot
    @Default([]) List<String> preparedBy, // Kitchen staff IDs
    
    // Notes
    String? customerNotes,
    String? kitchenNotes,
    String? internalNotes,
    String? cancellationReason,
    
    // Token/Queue Number (for takeaway/quick service)
    String? tokenNumber,
    
    // Metadata
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
    
    // Additional flags
    @Default(false) bool isPriority,
    @Default(false) bool isVoid,
    String? voidReason,
    DateTime? voidedAt,
    String? voidedBy,
    
    // Analytics fields (calculated)
    int? preparationTimeMinutes,
    int? serviceTimeMinutes,
    int? totalTimeMinutes,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  
  // Helper methods
  const Order._();
  
  // Check if order can be edited
  bool get canEdit {
    return status == OrderStatus.draft || status == OrderStatus.confirmed;
  }
  
  // Check if order can be cancelled
  bool get canCancel {
    return !status.isFinal && !isVoid;
  }
  
  // Check if payment is complete
  bool get isPaymentComplete {
    return paymentStatus == PaymentStatus.paid;
  }
  
  // Check if order is active
  bool get isActive {
    return status.isActive && !isVoid;
  }
  
  // Get remaining payment amount
  double get remainingPayment {
    final remaining = total - totalPaid;
    return remaining > 0 ? remaining : 0;
  }
  
  // Check if order requires kitchen preparation
  bool get requiresKitchen {
    return items.any((item) => !item.skipKot);
  }
  
  // Get item count
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity.toInt());
  }
  
  // Get unique item count
  int get uniqueItemCount {
    return items.length;
  }
  
  // Calculate service time
  Duration? get serviceDuration {
    if (orderedAt != null && completedAt != null) {
      return completedAt!.difference(orderedAt);
    }
    return null;
  }
  
  // Calculate preparation time
  Duration? get preparationDuration {
    if (confirmedAt != null && readyAt != null) {
      return readyAt!.difference(confirmedAt!);
    }
    return null;
  }
  
  // Get status color (for UI)
  String get statusColor {
    switch (status) {
      case OrderStatus.draft:
        return 'grey';
      case OrderStatus.confirmed:
        return 'blue';
      case OrderStatus.preparing:
        return 'orange';
      case OrderStatus.ready:
        return 'green';
      case OrderStatus.served:
      case OrderStatus.picked:
        return 'teal';
      case OrderStatus.completed:
        return 'green';
      case OrderStatus.cancelled:
        return 'red';
      case OrderStatus.refunded:
        return 'purple';
    }
  }
  
  // Get display status based on order type
  String get displayStatus {
    if (orderType == OrderType.dineIn && status == OrderStatus.completed) {
      return 'Served';
    } else if (orderType == OrderType.takeaway && status == OrderStatus.completed) {
      return 'Picked Up';
    }
    return status.displayName;
  }
  
  // Generate order title for display
  String get displayTitle {
    if (orderType == OrderType.dineIn && tableName != null) {
      return '$tableName - $orderNumber';
    } else if (tokenNumber != null) {
      return 'Token: $tokenNumber - $orderNumber';
    }
    return orderNumber;
  }
  
  // Check if order needs attention (for alerts)
  bool get needsAttention {
    // Order is ready but not served/picked
    if (status == OrderStatus.ready) {
      return true;
    }
    
    // Payment pending for too long
    if (paymentStatus == PaymentStatus.pending && 
        orderedAt.difference(DateTime.now()).inMinutes > 30) {
      return true;
    }
    
    // Taking too long to prepare
    if (status == OrderStatus.preparing && estimatedReadyTime != null &&
        DateTime.now().isAfter(estimatedReadyTime!)) {
      return true;
    }
    
    return false;
  }
}