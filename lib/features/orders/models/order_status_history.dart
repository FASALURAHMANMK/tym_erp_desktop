import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_status.dart';

part 'order_status_history.freezed.dart';
part 'order_status_history.g.dart';

@freezed
class OrderStatusHistory with _$OrderStatusHistory {
  const factory OrderStatusHistory({
    required String id,
    required String orderId,
    
    // Status Change
    required OrderStatus fromStatus,
    required OrderStatus toStatus,
    
    // Who made the change
    required String changedBy, // User ID
    required String changedByName, // Snapshot
    String? changedByRole, // Staff role at time of change
    
    // When
    required DateTime changedAt,
    
    // Why (optional)
    String? reason,
    String? notes,
    
    // Additional context
    String? deviceId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) = _OrderStatusHistory;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) => 
      _$OrderStatusHistoryFromJson(json);
  
  const OrderStatusHistory._();
  
  // Get display text for the change
  String get displayText {
    return 'Changed from ${fromStatus.displayName} to ${toStatus.displayName}';
  }
  
  // Check if this was a cancellation
  bool get isCancellation => toStatus == OrderStatus.cancelled;
  
  // Check if this was a completion
  bool get isCompletion => toStatus == OrderStatus.completed;
  
  // Check if this was a refund
  bool get isRefund => toStatus == OrderStatus.refunded;
  
  // Get action text
  String get actionText {
    if (isCancellation) return 'Cancelled';
    if (isCompletion) return 'Completed';
    if (isRefund) return 'Refunded';
    
    switch (toStatus) {
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Started Preparing';
      case OrderStatus.ready:
        return 'Marked Ready';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.picked:
        return 'Picked Up';
      default:
        return 'Updated';
    }
  }
}