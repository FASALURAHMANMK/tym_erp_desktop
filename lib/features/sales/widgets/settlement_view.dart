import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/logger.dart';

class SettlementView extends ConsumerStatefulWidget {
  const SettlementView({super.key});

  @override
  ConsumerState<SettlementView> createState() => _SettlementViewState();
}

class _SettlementViewState extends ConsumerState<SettlementView> {
  static final _logger = Logger('SettlementView');
  
  String _selectedFilter = 'today';
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Header with filters
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Settlements',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Export button
                  IconButton(
                    onPressed: () {
                      // TODO: Export settlements
                    },
                    icon: const Icon(Icons.download),
                    tooltip: 'Export',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Filter chips
              Row(
                children: [
                  _FilterChip(
                    label: 'Today',
                    isSelected: _selectedFilter == 'today',
                    onTap: () => setState(() => _selectedFilter = 'today'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Yesterday',
                    isSelected: _selectedFilter == 'yesterday',
                    onTap: () => setState(() => _selectedFilter = 'yesterday'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'This Week',
                    isSelected: _selectedFilter == 'week',
                    onTap: () => setState(() => _selectedFilter = 'week'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'This Month',
                    isSelected: _selectedFilter == 'month',
                    onTap: () => setState(() => _selectedFilter = 'month'),
                  ),
                  const Spacer(),
                  // Date range picker
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Show date range picker
                    },
                    icon: const Icon(Icons.date_range),
                    label: const Text('Custom Range'),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Summary cards
        Container(
          padding: const EdgeInsets.all(16),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Total Sales',
                  value: '₹0.00',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: 'Total Orders',
                  value: '0',
                  icon: Icons.receipt,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: 'Avg Order Value',
                  value: '₹0.00',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: 'Cash',
                  value: '₹0.00',
                  icon: Icons.money,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryCard(
                  title: 'Card',
                  value: '₹0.00',
                  icon: Icons.credit_card,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
        
        // Settlement list
        Expanded(
          child: _buildEmptyState(theme),
          // TODO: Replace with actual list when settlements exist
          // child: ListView.builder(
          //   padding: const EdgeInsets.all(16),
          //   itemCount: settlements.length,
          //   itemBuilder: (context, index) {
          //     return _SettlementCard(settlement: settlements[index]);
          //   },
          // ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No settlements found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete orders to see settlements here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : null,
          border: Border.all(
            color: isSelected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected 
              ? theme.colorScheme.onPrimary 
              : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for settlement card
class _SettlementCard extends StatelessWidget {
  final Map<String, dynamic> settlement;
  
  const _SettlementCard({required this.settlement});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: View settlement details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Order info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${settlement['orderId']}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      settlement['customerName'] ?? 'Walk-in Customer',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      settlement['time'] ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Payment info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _getPaymentIcon(settlement['paymentMethod']),
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      settlement['paymentMethod'] ?? 'Cash',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${settlement['amount']}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Completed',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  // TODO: Handle actions
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 8),
                        Text('View'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'print',
                    child: Row(
                      children: [
                        Icon(Icons.print, size: 20),
                        SizedBox(width: 8),
                        Text('Print'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'refund',
                    child: Row(
                      children: [
                        Icon(Icons.replay, size: 20),
                        SizedBox(width: 8),
                        Text('Refund'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getPaymentIcon(String? method) {
    switch (method?.toLowerCase()) {
      case 'card':
        return Icons.credit_card;
      case 'upi':
        return Icons.qr_code;
      case 'online':
        return Icons.language;
      default:
        return Icons.money;
    }
  }
}