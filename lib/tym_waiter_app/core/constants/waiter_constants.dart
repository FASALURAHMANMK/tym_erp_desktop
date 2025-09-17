/// Constants specific to the waiter application
class WaiterConstants {
  // App Information
  static const String appName = 'TYM Waiter';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double minTouchTarget = 48.0;
  static const double cardElevation = 4.0;
  static const double borderRadius = 12.0;
  
  // Navigation
  static const int bottomNavAnimationDuration = 300;
  
  // Order Management
  static const int maxItemsPerOrder = 50;
  static const int orderRefreshInterval = 5; // seconds
  
  // Table Management
  static const double tableCardSize = 80.0;
  static const int maxTablesPerRow = 4;
  
  // Performance
  static const int syncInterval = 30; // seconds
  static const int maxRetryAttempts = 3;
  
  // Routes
  static const String loginRoute = '/waiter/login';
  static const String dashboardRoute = '/waiter/dashboard';
  static const String tablesRoute = '/waiter/tables';
  static const String ordersRoute = '/waiter/orders';
  static const String paymentsRoute = '/waiter/payments';
  static const String profileRoute = '/waiter/profile';
}

/// Waiter-specific error messages
class WaiterErrorMessages {
  static const String networkError = 'Network connection issue. Working offline.';
  static const String syncError = 'Sync failed. Changes saved locally.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String orderError = 'Could not process order. Please try again.';
  static const String tableError = 'Could not update table status.';
  static const String paymentError = 'Payment processing failed.';
}

/// Waiter-specific success messages
class WaiterSuccessMessages {
  static const String orderSaved = 'Order saved successfully';
  static const String orderSent = 'Order sent to kitchen';
  static const String paymentProcessed = 'Payment processed successfully';
  static const String tableUpdated = 'Table status updated';
  static const String syncCompleted = 'Data synchronized';
}