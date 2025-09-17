import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/sales/models/table.dart';
import '../core/constants/waiter_constants.dart';
import '../features/auth/providers/waiter_auth_provider.dart';
import '../features/auth/screens/waiter_login_screen.dart';
import '../features/cart/screens/waiter_cart_screen.dart';
import '../features/dashboard/screens/waiter_dashboard_screen.dart';
import '../features/products/screens/waiter_products_screen.dart';
import '../features/tables/screens/table_list_screen.dart';
import 'waiter_shell.dart';

/// Router provider for waiter application
final waiterRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isWaiterAuthenticatedProvider);
  
  return GoRouter(
    initialLocation: WaiterConstants.loginRoute,
    redirect: (context, state) {
      final isAuthPage = state.matchedLocation == WaiterConstants.loginRoute;
      
      // Debug logging
      debugPrint('WaiterRouter: isAuthenticated=$isAuthenticated, location=${state.matchedLocation}');
      
      // If not authenticated and not on auth page, redirect to login
      if (!isAuthenticated && !isAuthPage) {
        debugPrint('WaiterRouter: Redirecting to login (not authenticated)');
        return WaiterConstants.loginRoute;
      }
      
      // If authenticated and on auth page, redirect to dashboard
      if (isAuthenticated && isAuthPage) {
        debugPrint('WaiterRouter: Redirecting to dashboard (authenticated)');
        return WaiterConstants.dashboardRoute;
      }
      
      // No redirect needed
      debugPrint('WaiterRouter: No redirect needed');
      return null;
    },
    routes: [
      // Login route (no shell)
      GoRoute(
        path: WaiterConstants.loginRoute,
        builder: (context, state) => const WaiterLoginScreen(),
      ),
      
      // Shell routes with bottom navigation
      ShellRoute(
        builder: (context, state, child) => WaiterShell(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: WaiterConstants.dashboardRoute,
            builder: (context, state) => const WaiterDashboardScreen(),
          ),
          
          // Tables with sub-routes
          GoRoute(
            path: WaiterConstants.tablesRoute,
            builder: (context, state) => const TableListScreen(),
            routes: [
              // Product selection for a table
              GoRoute(
                path: ':tableId/products',
                builder: (context, state) {
                  final table = state.extra as RestaurantTable?;
                  if (table == null) {
                    // Fallback if table is not passed
                    return const Scaffold(
                      body: Center(
                        child: Text('Table information not available'),
                      ),
                    );
                  }
                  return WaiterProductsScreen(table: table);
                },
              ),
              // Cart view for a table
              GoRoute(
                path: ':tableId/cart',
                builder: (context, state) {
                  final table = state.extra as RestaurantTable?;
                  if (table == null) {
                    // Fallback if table is not passed
                    return const Scaffold(
                      body: Center(
                        child: Text('Table information not available'),
                      ),
                    );
                  }
                  return WaiterCartScreen(table: table);
                },
              ),
              // Payment for a table
              GoRoute(
                path: ':tableId/payment',
                builder: (context, state) {
                  final tableId = state.pathParameters['tableId']!;
                  // TODO: Implement payment screen
                  return Scaffold(
                    appBar: AppBar(title: const Text('Payment')),
                    body: Center(
                      child: Text('Payment for table $tableId'),
                    ),
                  );
                },
              ),
            ],
          ),
          
          // Orders (placeholder for now)
          GoRoute(
            path: WaiterConstants.ordersRoute,
            builder: (context, state) => const OrdersPlaceholderScreen(),
          ),
          
          // Payments (placeholder for now)
          GoRoute(
            path: WaiterConstants.paymentsRoute,
            builder: (context, state) => const PaymentsPlaceholderScreen(),
          ),
          
          // Profile (placeholder for now)
          GoRoute(
            path: WaiterConstants.profileRoute,
            builder: (context, state) => const ProfilePlaceholderScreen(),
          ),
        ],
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error: ${state.error}',
              style: const TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(WaiterConstants.loginRoute),
              child: const Text('Return to Login'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Navigation helper methods for waiter app
class WaiterNavigation {
  
  /// Navigate to dashboard
  static void toDashboard(BuildContext context) {
    context.go(WaiterConstants.dashboardRoute);
  }
  
  /// Navigate to tables
  static void toTables(BuildContext context) {
    context.go(WaiterConstants.tablesRoute);
  }
  
  /// Navigate to orders
  static void toOrders(BuildContext context) {
    context.go(WaiterConstants.ordersRoute);
  }
  
  /// Navigate to payments
  static void toPayments(BuildContext context) {
    context.go(WaiterConstants.paymentsRoute);
  }
  
  /// Navigate to profile
  static void toProfile(BuildContext context) {
    context.go(WaiterConstants.profileRoute);
  }
  
  /// Navigate to login
  static void toLogin(BuildContext context) {
    context.go(WaiterConstants.loginRoute);
  }
  
  /// Check if currently on specific route
  static bool isOnRoute(BuildContext context, String route) {
    final location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
    return location == route;
  }
  
  /// Get current route
  static String getCurrentRoute(BuildContext context) {
    return GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
  }
}