import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/business/providers/business_provider.dart';
import '../../features/erp/models/erp_module.dart';
import '../../features/erp/screens/erp_shell_screen.dart';
import '../../features/erp/screens/modules/dashboard_screen.dart';
import '../../features/sales/screens/new_sell_screen.dart';
import '../../features/sales/screens/sales_screen.dart';
import '../../features/erp/screens/modules/placeholder_screen.dart';
import '../../features/erp/screens/modules/manage_screen.dart';
import '../../features/location/screens/location_management_screen.dart';
import '../../features/location/screens/pos_device_management_screen.dart';
import '../../features/products/screens/product_list_screen.dart';
import '../../features/products/screens/product_form_screen.dart';
import '../../features/products/screens/bulk_product_upload_screen.dart';
import '../../features/products/screens/category_management_screen.dart';
import '../../features/products/screens/brand_management_screen.dart';
import '../../features/sales/screens/price_category_management_screen.dart';
import '../../features/sales/screens/table_management_screen.dart';
import '../../features/sales/screens/tax_management_screen.dart';
import '../../features/sales/screens/discount_management_screen.dart';
import '../../features/charges/screens/charges_management_screen.dart';
import '../../features/payments/screens/payment_methods_screen.dart';
import '../../features/customers/screens/customer_management_screen.dart';
import '../../features/employees/screens/employees_screen.dart';
import '../../features/orders/screens/orders_list_screen.dart';
import '../../features/debug/screens/debug_screen.dart';
import '../../features/orders/presentation/debug_order_screen.dart';
import '../../debug/sync_queue_inspector.dart';
import '../../features/kot_configuration/presentation/screens/kot_configuration_screen.dart';
import '../../features/kot_configuration/presentation/screens/kot_test_screen.dart';
import '../../screens/welcome_screen.dart';
import '../../screens/sign_in_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/create_business_screen.dart';
import '../../screens/select_business_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  final postAuthNavigation = ref.watch(postAuthNavigationProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    redirect: (context, state) {
      final isAuthPage = [
        AppRoutes.welcome,
        AppRoutes.signIn,
        AppRoutes.register,
      ].contains(state.matchedLocation);
      
      final isBusinessSetupPage = [
        AppRoutes.createBusiness,
        AppRoutes.selectBusiness,
      ].contains(state.matchedLocation);
      
      // If user is not authenticated, redirect to welcome (except on auth pages)
      if (!isAuthenticated && !isAuthPage) {
        return AppRoutes.welcome;
      }
      
      // If user is authenticated, handle business flow
      if (isAuthenticated) {
        // If on auth page, redirect based on business state
        if (isAuthPage && postAuthNavigation != null) {
          return postAuthNavigation;
        }
        
        // If trying to access main app without proper business setup
        // BUT don't redirect if we're already going to home and have a selected business
        if (!isAuthPage && !isBusinessSetupPage && postAuthNavigation != null && postAuthNavigation != AppRoutes.home) {
          // Special case: if we're going to home and have a selected business, allow it
          final businessState = ref.read(businessNotifierProvider);
          if (state.matchedLocation == AppRoutes.home && businessState.hasSelectedBusiness) {
            return null; // Allow navigation to home
          }
          return postAuthNavigation;
        }
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      // Authentication Routes
      GoRoute(
        path: AppRoutes.welcome,
        name: AppRouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: AppRouteNames.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Business Setup Routes
      GoRoute(
        path: AppRoutes.createBusiness,
        name: AppRouteNames.createBusiness,
        builder: (context, state) => const CreateBusinessScreen(),
      ),
      GoRoute(
        path: AppRoutes.selectBusiness,
        name: AppRouteNames.selectBusiness,
        builder: (context, state) => const SelectBusinessScreen(),
      ),
      
      // Main ERP Shell with nested routes
      ShellRoute(
        builder: (context, state, child) {
          return ERPShellScreen(
            location: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          // Dashboard (default home route)
          GoRoute(
            path: AppRoutes.home,
            name: AppRouteNames.home,
            builder: (context, state) => const DashboardScreen(),
          ),
          
          // ERP Module Routes
          GoRoute(
            path: ERPModule.sell.route,
            name: ERPModule.sell.name,
            builder: (context, state) => const NewSellScreen(),
          ),
          GoRoute(
            path: ERPModule.sales.route,
            name: ERPModule.sales.name,
            builder: (context, state) => const SalesScreen(),
          ),
          GoRoute(
            path: ERPModule.onlineOrders.route,
            name: ERPModule.onlineOrders.name,
            builder: (context, state) => const OrdersListScreen(),
          ),
          GoRoute(
            path: ERPModule.inventory.route,
            name: ERPModule.inventory.name,
            builder: (context, state) => PlaceholderScreen(module: ERPModule.inventory),
          ),
          GoRoute(
            path: ERPModule.accounts.route,
            name: ERPModule.accounts.name,
            builder: (context, state) => PlaceholderScreen(module: ERPModule.accounts),
          ),
          GoRoute(
            path: ERPModule.customers.route,
            name: ERPModule.customers.name,
            builder: (context, state) => const CustomerManagementScreen(),
          ),
          GoRoute(
            path: ERPModule.employees.route,
            name: ERPModule.employees.name,
            builder: (context, state) => const EmployeesScreen(),
          ),
          GoRoute(
            path: ERPModule.manage.route,
            name: ERPModule.manage.name,
            builder: (context, state) => const ManageScreen(),
          ),
          
          // Location & POS Management Routes
          GoRoute(
            path: '/locations',
            name: AppRouteNames.locations,
            builder: (context, state) => const LocationManagementScreen(),
          ),
          GoRoute(
            path: '/pos-devices',
            name: AppRouteNames.posDevices,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>?;
              final locationId = args?['locationId'] as String?;
              return POSDeviceManagementScreen(locationId: locationId);
            },
          ),
          
          // Product Management Routes
          GoRoute(
            path: '/products',
            name: 'products',
            builder: (context, state) => const ProductListScreen(),
          ),
          GoRoute(
            path: '/products/new',
            name: 'product-new',
            builder: (context, state) => const ProductFormScreen(),
          ),
          GoRoute(
            path: '/products/bulk-upload',
            name: 'product-bulk-upload',
            builder: (context, state) => const BulkProductUploadScreen(),
          ),
          GoRoute(
            path: '/products/edit/:id',
            name: 'product-edit',
            builder: (context, state) {
              final productId = state.pathParameters['id'];
              return ProductFormScreen(productId: productId);
            },
          ),
          GoRoute(
            path: '/categories',
            name: 'categories',
            builder: (context, state) => const CategoryManagementScreen(),
          ),
          GoRoute(
            path: '/brands',
            name: 'brands',
            builder: (context, state) => const BrandManagementScreen(),
          ),
          GoRoute(
            path: '/price-categories',
            name: 'price-categories',
            builder: (context, state) => const PriceCategoryManagementScreen(),
          ),
          GoRoute(
            path: '/table-management',
            name: 'table-management',
            builder: (context, state) => const TableManagementScreen(),
          ),
          // Debug screen (development only)
          GoRoute(
            path: '/debug',
            name: 'debug',
            builder: (context, state) {
              // Import debug screen dynamically
              return const DebugScreen();
            },
          ),
          GoRoute(
            path: '/tax-management',
            name: 'tax-management',
            builder: (context, state) => const TaxManagementScreen(),
          ),
          GoRoute(
            path: '/discount-management',
            name: 'discount-management',
            builder: (context, state) => const DiscountManagementScreen(),
          ),
          GoRoute(
            path: '/charges-management',
            name: 'charges-management',
            builder: (context, state) => const ChargesManagementScreen(),
          ),
          GoRoute(
            path: '/payment-methods',
            name: 'payment-methods',
            builder: (context, state) => const PaymentMethodsScreen(),
          ),
          
          // KOT Configuration Routes
          GoRoute(
            path: '/kot-configuration',
            name: 'kot-configuration',
            builder: (context, state) => const KotConfigurationScreen(),
          ),
          GoRoute(
            path: '/kot-test',
            name: 'kot-test',
            builder: (context, state) => const KotTestScreen(),
          ),
          
          GoRoute(
            path: '/sync-queue',
            name: 'sync-queue',
            builder: (context, state) => const SyncQueueInspector(),
          ),
          GoRoute(
            path: '/debug-orders',
            name: 'debug-orders',
            builder: (context, state) => const DebugOrderScreen(),
          ),
        ],
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.welcome),
              child: const Text('Go to Welcome'),
            ),
          ],
        ),
      ),
    ),
  );
});