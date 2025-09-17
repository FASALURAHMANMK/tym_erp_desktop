import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/sales_provider.dart';

class SalesSummaryCards extends StatelessWidget {
  final SalesStatistics statistics;

  const SalesSummaryCards({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Row(
      children: [
        // Total Revenue Card
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Today\'s Revenue',
            value: currencyFormat.format(statistics.totalRevenue),
            icon: Icons.trending_up,
            color: Colors.green,
            subtitle: '${statistics.totalOrders} orders',
          ),
        ),
        const SizedBox(width: 16),

        // Average Order Value Card
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Avg Order Value',
            value: currencyFormat.format(statistics.averageOrderValue),
            icon: Icons.receipt,
            color: Colors.blue,
            subtitle: 'Per order',
          ),
        ),
        const SizedBox(width: 16),

        // Total Tax Card
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Tax Collected',
            value: currencyFormat.format(statistics.totalTax),
            icon: Icons.account_balance,
            color: Colors.orange,
            subtitle: 'Today',
          ),
        ),
        const SizedBox(width: 16),

        // Total Discounts Card
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Discounts Given',
            value: currencyFormat.format(statistics.totalDiscounts),
            icon: Icons.discount,
            color: Colors.red,
            subtitle: 'Total savings',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Icon(
                Icons.more_vert,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
