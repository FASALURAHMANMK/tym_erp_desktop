/// Route paths for the application
class AppRoutes {
  // Authentication routes
  static const String welcome = '/';
  static const String signIn = '/sign-in';
  static const String register = '/register';
  
  // Business setup routes
  static const String createBusiness = '/create-business';
  static const String selectBusiness = '/select-business';
  
  // Main app routes
  static const String home = '/home';
  
  // Location & POS management routes
  static const String locations = '/home/locations';
  static const String posDevices = '/home/pos-devices';
  
  // Future ERP module routes
  static const String inventory = '/inventory';
  static const String sales = '/sales';
  static const String purchase = '/purchase';
  static const String customers = '/customers';
  static const String suppliers = '/suppliers';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String users = '/users';
  
  // Nested routes examples
  static const String inventoryAdd = '/inventory/add';
  static const String inventoryEdit = '/inventory/edit';
  static const String salesCreate = '/sales/create';
  static const String customerDetails = '/customers/details';
}

/// Route names for type-safe navigation
class AppRouteNames {
  // Authentication routes
  static const String welcome = 'welcome';
  static const String signIn = 'signIn';
  static const String register = 'register';
  
  // Business setup routes
  static const String createBusiness = 'createBusiness';
  static const String selectBusiness = 'selectBusiness';
  
  // Main app routes
  static const String home = 'home';
  
  // Location & POS management routes
  static const String locations = 'locations';
  static const String posDevices = 'posDevices';
  
  // Future ERP module routes
  static const String inventory = 'inventory';
  static const String sales = 'sales';
  static const String purchase = 'purchase';
  static const String customers = 'customers';
  static const String suppliers = 'suppliers';
  static const String reports = 'reports';
  static const String settings = 'settings';
  static const String users = 'users';
  
  // Nested routes
  static const String inventoryAdd = 'inventoryAdd';
  static const String inventoryEdit = 'inventoryEdit';
  static const String salesCreate = 'salesCreate';
  static const String customerDetails = 'customerDetails';
}