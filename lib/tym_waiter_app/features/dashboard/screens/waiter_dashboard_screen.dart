import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/employees/models/employee.dart';
import '../../../core/constants/waiter_constants.dart';
import '../../../core/utils/waiter_helpers.dart';
import '../../auth/providers/waiter_auth_provider.dart';

/// Main dashboard screen for waiters
/// Shows shift overview, active orders, and quick actions
class WaiterDashboardScreen extends ConsumerWidget {
  const WaiterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWaiter = ref.watch(currentWaiterProvider);
    final waiterSession = ref.watch(waiterSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Sync status indicator
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              WaiterHelpers.showInfoSnackbar(context, 'Syncing data...');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: WaiterHelpers.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              _buildWelcomeHeader(currentWaiter, waiterSession),

              const SizedBox(height: 24),

              // Shift summary card
              _buildShiftSummaryCard(waiterSession),

              const SizedBox(height: 20),

              // Today's stats
              _buildTodayStatsCard(),

              const SizedBox(height: 20),

              // Quick actions
              _buildQuickActions(context),

              const SizedBox(height: 20),

              // Recent alerts/notifications
              _buildAlertsSection(context),

              const SizedBox(height: 20),

              // Active orders preview
              _buildActiveOrdersPreview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(Employee? waiter, WaiterSession? session) {
    final greeting = _getGreeting();
    final waiterName = waiter?.displayName ?? 'Waiter';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text(
                WaiterHelpers.getInitials(waiterName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Welcome text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $waiterName! 👋',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session != null
                        ? 'Shift Started: ${_formatTime(session.shiftStartTime)}'
                        : 'Ready to start your shift',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftSummaryCard(WaiterSession? session) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Current Shift',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        session?.isActive == true
                            ? Colors.green
                            : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session?.isActive == true ? 'ACTIVE' : 'NOT STARTED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (session != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Duration',
                      WaiterHelpers.formatDuration(session.shiftDuration),
                      Icons.timer,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Started',
                      _formatTime(session.shiftStartTime),
                      Icons.play_arrow,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    Icon(Icons.work_outline, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Shift not started',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Today\'s Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Tables Served',
                    '12',
                    Icons.table_restaurant,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Active Orders',
                    '3',
                    Icons.receipt_long,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Tips Earned',
                    '\$45.50',
                    Icons.monetization_on,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Revenue',
                    '\$324.75',
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.flash_on, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionButton(
                  'View Tables',
                  Icons.table_view,
                  Colors.blue,
                  () => WaiterHelpers.showInfoSnackbar(
                    context,
                    'Opening tables view...',
                  ),
                ),
                _buildActionButton(
                  'Take Order',
                  Icons.add_shopping_cart,
                  Colors.green,
                  () => WaiterHelpers.showInfoSnackbar(
                    context,
                    'Opening order form...',
                  ),
                ),
                _buildActionButton(
                  'Process Payment',
                  Icons.payment,
                  Colors.purple,
                  () => WaiterHelpers.showInfoSnackbar(
                    context,
                    'Opening payment...',
                  ),
                ),
                _buildActionButton(
                  'Menu',
                  Icons.restaurant_menu,
                  Colors.orange,
                  () => WaiterHelpers.showInfoSnackbar(
                    context,
                    'Opening menu...',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(BuildContext context) {
    final alerts = [
      {
        'type': 'order_ready',
        'message': 'Table 7 - Order Ready',
        'time': '2m ago',
      },
      {
        'type': 'bill_request',
        'message': 'Table 12 - Requested Bill',
        'time': '5m ago',
      },
      {
        'type': 'kitchen',
        'message': 'Kitchen - Order #234 Ready',
        'time': '8m ago',
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Alerts & Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (alerts.isEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No new alerts',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ...alerts.map(
                (alert) => _buildAlertItem(
                  context,
                  alert['message']!,
                  alert['time']!,
                  _getAlertIcon(alert['type']!),
                  _getAlertColor(alert['type']!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrdersPreview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Active Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sample orders
            _buildOrderItem('Table 5', 'Draft', 2, '\$28.50', Colors.grey),
            _buildOrderItem('Table 8', 'Confirmed', 4, '\$65.75', Colors.blue),
            _buildOrderItem('Table 12', 'Ready', 3, '\$42.25', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    String message,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
    String table,
    String status,
    int items,
    String total,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  table,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$items items',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(total, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'order_ready':
        return Icons.restaurant;
      case 'bill_request':
        return Icons.receipt;
      case 'kitchen':
        return Icons.kitchen;
      default:
        return Icons.info;
    }
  }

  Color _getAlertColor(String type) {
    switch (type) {
      case 'order_ready':
        return Colors.green;
      case 'bill_request':
        return Colors.orange;
      case 'kitchen':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
