import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/waiter_constants.dart';
import '../features/auth/providers/waiter_auth_provider.dart';

/// Bottom navigation shell for waiter app
/// Provides persistent bottom navigation across waiter screens
class WaiterShell extends ConsumerStatefulWidget {
  final Widget child;

  const WaiterShell({super.key, required this.child});

  @override
  ConsumerState<WaiterShell> createState() => _WaiterShellState();
}

class _WaiterShellState extends ConsumerState<WaiterShell> {
  int _selectedIndex = 0;

  // Navigation destinations
  final List<BottomNavigationBarItem> _destinations = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.table_restaurant),
      label: 'Tables',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long),
      label: 'Orders',
    ),
    const BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  // Routes corresponding to each tab
  final List<String> _routes = [
    WaiterConstants.dashboardRoute,
    WaiterConstants.tablesRoute,
    WaiterConstants.ordersRoute,
    WaiterConstants.paymentsRoute,
    WaiterConstants.profileRoute,
  ];

  void _onDestinationSelected(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      // Navigate to the corresponding route
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isWaiterAuthenticatedProvider);

    // Update selected index based on current location
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
    _updateSelectedIndex(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar:
          isAuthenticated
              ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onDestinationSelected,
                items: _destinations,
              )
              : null,

      // Optional: Add floating action button for quick order taking
      floatingActionButton:
          isAuthenticated &&
                  _selectedIndex !=
                      2 // Don't show on Orders tab
              ? FloatingActionButton(
                onPressed: () {
                  context.go(WaiterConstants.ordersRoute);
                },
                tooltip: 'New Order',
                child: const Icon(Icons.add_shopping_cart),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _updateSelectedIndex(String location) {
    int newIndex = 0;

    if (location.startsWith(WaiterConstants.dashboardRoute)) {
      newIndex = 0;
    } else if (location.startsWith(WaiterConstants.tablesRoute)) {
      newIndex = 1;
    } else if (location.startsWith(WaiterConstants.ordersRoute)) {
      newIndex = 2;
    } else if (location.startsWith(WaiterConstants.paymentsRoute)) {
      newIndex = 3;
    } else if (location.startsWith(WaiterConstants.profileRoute)) {
      newIndex = 4;
    }

    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }
}

/// Placeholder screens for tabs not yet implemented
class PlaceholderScreen extends ConsumerWidget {
  final String title;
  final IconData icon;
  final String message;
  final Color color;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.message,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWaiter = ref.watch(currentWaiterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          // User avatar
          if (currentWaiter != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  (currentWaiter.displayName ?? 'W')
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 120, color: color.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Coming Soon in Phase ${_getPhaseNumber(title)}',
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getPhaseNumber(String title) {
    switch (title.toLowerCase()) {
      case 'tables':
        return 2;
      case 'orders':
        return 3;
      case 'payments':
        return 5;
      case 'profile':
        return 6;
      default:
        return 2;
    }
  }
}

// Specific placeholder screens
class TablesPlaceholderScreen extends PlaceholderScreen {
  const TablesPlaceholderScreen({super.key})
    : super(
        title: 'Tables',
        icon: Icons.table_restaurant,
        message:
            'Manage your restaurant tables, view status, and assign orders. Coming in Phase 2!',
        color: Colors.green,
      );
}

class OrdersPlaceholderScreen extends PlaceholderScreen {
  const OrdersPlaceholderScreen({super.key})
    : super(
        title: 'Orders',
        icon: Icons.receipt_long,
        message:
            'Take orders, manage items, and track order status. The heart of your waiter workflow!',
        color: Colors.orange,
      );
}

class PaymentsPlaceholderScreen extends PlaceholderScreen {
  const PaymentsPlaceholderScreen({super.key})
    : super(
        title: 'Payments',
        icon: Icons.payment,
        message:
            'Process payments, handle tips, and manage receipts. Secure and fast checkout experience!',
        color: Colors.purple,
      );
}

class ProfilePlaceholderScreen extends ConsumerWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWaiter = ref.watch(currentWaiterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out waiter
              await ref.read(waiterAuthStateProvider.notifier).signOut();

              // Navigate back to main app
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User info
              if (currentWaiter != null) ...[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo,
                  child: Text(
                    (currentWaiter.displayName ?? 'W')
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currentWaiter.displayName ?? 'Waiter',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentWaiter.employeeCode,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
              ],

              Icon(
                Icons.person,
                size: 120,
                color: Colors.indigo.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              const Text(
                'Profile Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'View your profile, manage shift settings, and track your performance statistics.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Logout button
              ElevatedButton.icon(
                onPressed: () async {
                  // Sign out waiter
                  await ref.read(waiterAuthStateProvider.notifier).signOut();

                  // Navigate back to main app
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('End Shift & Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.indigo.withValues(alpha: 0.3),
                  ),
                ),
                child: const Text(
                  'Coming Soon in Phase 6',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16), // Extra padding at bottom
            ],
          ),
        ),
      ),
    );
  }
}
