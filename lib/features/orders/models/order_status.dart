// Order status enum
enum OrderStatus {
  draft,
  confirmed,
  preparing,
  ready,
  served,
  picked,
  completed,
  cancelled,
  refunded,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.draft:
        return 'Draft';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.picked:
        return 'Picked Up';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }
  
  String get value {
    return name;
  }
  
  bool get canModify {
    return this == OrderStatus.draft || this == OrderStatus.confirmed;
  }
  
  bool get canCancel {
    return this != OrderStatus.completed && 
           this != OrderStatus.cancelled && 
           this != OrderStatus.refunded;
  }
  
  bool get isActive {
    return this != OrderStatus.completed && 
           this != OrderStatus.cancelled && 
           this != OrderStatus.refunded;
  }
  
  bool get isFinal {
    return this == OrderStatus.completed || 
           this == OrderStatus.cancelled || 
           this == OrderStatus.refunded;
  }
}

// Order type enum
enum OrderType {
  dineIn,
  takeaway,
  delivery,
  online,
}

extension OrderTypeExtension on OrderType {
  String get displayName {
    switch (this) {
      case OrderType.dineIn:
        return 'Dine In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
      case OrderType.online:
        return 'Online';
    }
  }
  
  String get value {
    return name;
  }
  
  bool get requiresTable {
    return this == OrderType.dineIn;
  }
  
  bool get requiresAddress {
    return this == OrderType.delivery;
  }
}

// Order source enum
enum OrderSource {
  pos,
  online,
  phone,
  kiosk,
}

extension OrderSourceExtension on OrderSource {
  String get displayName {
    switch (this) {
      case OrderSource.pos:
        return 'POS';
      case OrderSource.online:
        return 'Online';
      case OrderSource.phone:
        return 'Phone';
      case OrderSource.kiosk:
        return 'Kiosk';
    }
  }
  
  String get value {
    return name;
  }
}

// Payment status enum
enum PaymentStatus {
  pending,
  partial,
  paid,
  refunded,
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.partial:
        return 'Partial';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }
  
  String get value {
    return name;
  }
  
  bool get isPaid {
    return this == PaymentStatus.paid;
  }
  
  bool get requiresPayment {
    return this == PaymentStatus.pending || this == PaymentStatus.partial;
  }
}

// Kitchen status enum
enum KitchenStatus {
  pending,
  preparing,
  ready,
}

extension KitchenStatusExtension on KitchenStatus {
  String get displayName {
    switch (this) {
      case KitchenStatus.pending:
        return 'Pending';
      case KitchenStatus.preparing:
        return 'Preparing';
      case KitchenStatus.ready:
        return 'Ready';
    }
  }
  
  String get value {
    return name;
  }
}

// Item preparation status
enum PreparationStatus {
  pending,
  preparing,
  ready,
  served,
}

extension PreparationStatusExtension on PreparationStatus {
  String get displayName {
    switch (this) {
      case PreparationStatus.pending:
        return 'Pending';
      case PreparationStatus.preparing:
        return 'Preparing';
      case PreparationStatus.ready:
        return 'Ready';
      case PreparationStatus.served:
        return 'Served';
    }
  }
  
  String get value {
    return name;
  }
}