import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/logger.dart';
import '../models/discount.dart';
import '../providers/discount_provider.dart';
import '../widgets/discount_rule_dialog.dart';

class DiscountManagementScreen extends ConsumerStatefulWidget {
  const DiscountManagementScreen({super.key});

  @override
  ConsumerState<DiscountManagementScreen> createState() =>
      _DiscountManagementScreenState();
}

class _DiscountManagementScreenState
    extends ConsumerState<DiscountManagementScreen>
    with SingleTickerProviderStateMixin {
  static final _logger = Logger('DiscountManagementScreen');

  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount Management'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active Discounts'),
            Tab(text: 'Scheduled'),
            Tab(text: 'Expired'),
          ],
          indicatorColor: theme.colorScheme.onPrimary,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh discount list
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                // Search field
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search discounts...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Filter dropdown
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Types')),
                    DropdownMenuItem(
                      value: 'percentage',
                      child: Text('Percentage'),
                    ),
                    DropdownMenuItem(
                      value: 'fixed',
                      child: Text('Fixed Amount'),
                    ),
                    DropdownMenuItem(
                      value: 'buy_x_get_y',
                      child: Text('Buy X Get Y'),
                    ),
                    DropdownMenuItem(
                      value: 'coupon',
                      child: Text('Coupon Based'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value ?? 'all';
                    });
                  },
                ),
                const SizedBox(width: 16),

                // Add discount button
                ElevatedButton.icon(
                  onPressed: () => _showAddDiscountDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Discount'),
                ),
              ],
            ),
          ),

          // Discount list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active Discounts Tab
                _buildDiscountList(context, 'active'),

                // Scheduled Tab
                _buildDiscountList(context, 'scheduled'),

                // Expired Tab
                _buildDiscountList(context, 'expired'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountList(BuildContext context, String status) {
    final theme = Theme.of(context);
    final discountsAsync = ref.watch(activeDiscountsProvider);

    return discountsAsync.when(
      data: (allDiscounts) {
        // Filter discounts based on status
        var discounts = _filterDiscountsByStatus(allDiscounts, status);
        
        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          discounts = discounts.where((discount) {
            final name = discount.name.toLowerCase();
            final code = discount.couponCode?.toLowerCase() ?? '';
            final query = _searchQuery.toLowerCase();
            return name.contains(query) || code.contains(query);
          }).toList();
        }
        
        // Apply type filter
        if (_selectedFilter != 'all') {
          discounts = discounts.where((discount) {
            switch (_selectedFilter) {
              case 'percentage':
                return discount.type == DiscountType.percentage;
              case 'fixed':
                return discount.type == DiscountType.fixed;
              case 'coupon':
                return discount.couponCode != null;
              default:
                return true;
            }
          }).toList();
        }

        if (discounts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.discount_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${status == 'active' ? 'active' : status} discounts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showAddDiscountDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create First Discount'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: discounts.length,
          itemBuilder: (context, index) {
            final discount = discounts[index];
            return _buildDiscountCard(context, discount);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        _logger.error('Error loading discounts', error, stack);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading discounts',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(activeDiscountsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Discount> _filterDiscountsByStatus(List<Discount> discounts, String status) {
    final now = DateTime.now();
    
    switch (status) {
      case 'active':
        return discounts.where((d) {
          if (!d.isActive) return false;
          if (d.validFrom != null && now.isBefore(d.validFrom!)) return false;
          if (d.validUntil != null && now.isAfter(d.validUntil!)) return false;
          return true;
        }).toList();
      
      case 'scheduled':
        return discounts.where((d) {
          if (!d.isActive) return false;
          if (d.validFrom != null && now.isBefore(d.validFrom!)) return true;
          return false;
        }).toList();
      
      case 'expired':
        return discounts.where((d) {
          if (!d.isActive) return true;
          if (d.validUntil != null && now.isAfter(d.validUntil!)) return true;
          return false;
        }).toList();
      
      default:
        return discounts;
    }
  }

  Widget _buildDiscountCard(
    BuildContext context,
    Discount discount,
  ) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    // Determine status
    String status = 'active';
    if (!discount.isActive) {
      status = 'inactive';
    } else if (discount.validFrom != null && now.isBefore(discount.validFrom!)) {
      status = 'scheduled';
    } else if (discount.validUntil != null && now.isAfter(discount.validUntil!)) {
      status = 'expired';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Discount name and value
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            discount.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Discount value badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              discount.type == DiscountType.percentage
                                  ? '${discount.value}% OFF'
                                  : '₹${discount.value.toStringAsFixed(0)} OFF',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (discount.couponCode != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_number,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Code: ${discount.couponCode}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Status and actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Action buttons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showEditDiscountDialog(context, discount),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () => _duplicateDiscount(context, discount),
                          tooltip: 'Duplicate',
                        ),
                        IconButton(
                          icon: Icon(
                            discount.isActive ? Icons.pause : Icons.play_arrow,
                            size: 20,
                          ),
                          onPressed: () => _toggleDiscountStatus(discount),
                          tooltip: discount.isActive ? 'Deactivate' : 'Activate',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          color: theme.colorScheme.error,
                          onPressed: () => _confirmDeleteDiscount(context, discount),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 24),

            // Details section
            Row(
              children: [
                // Validity period
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Validity',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getValidityText(discount),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Scope
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Applies To',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getScopeText(discount),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Conditions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conditions',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getConditionsText(discount),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Auto Apply
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        discount.isAutoApply ? 'Auto Apply' : 'Manual',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Additional info (if any)
            if (discount.description != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        discount.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
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

  String _getValidityText(Discount discount) {
    if (discount.validFrom == null && discount.validUntil == null) {
      return 'Always valid';
    }
    
    final formatter = DateFormat('MMM dd, yyyy');
    if (discount.validFrom != null && discount.validUntil != null) {
      return '${formatter.format(discount.validFrom!)} - ${formatter.format(discount.validUntil!)}';
    } else if (discount.validFrom != null) {
      return 'From ${formatter.format(discount.validFrom!)}';
    } else {
      return 'Until ${formatter.format(discount.validUntil!)}';
    }
  }

  String _getScopeText(Discount discount) {
    switch (discount.scope) {
      case DiscountScope.cart:
        return 'Entire Cart';
      case DiscountScope.category:
        return discount.categoryId != null ? 'Category' : 'Categories';
      case DiscountScope.item:
        return discount.productId != null ? 'Product' : 'Products';
    }
  }

  String _getConditionsText(Discount discount) {
    final conditions = <String>[];
    
    if (discount.minimumAmount != null) {
      conditions.add('Min ₹${discount.minimumAmount!.toStringAsFixed(0)}');
    }
    
    if (discount.maximumDiscount != null) {
      conditions.add('Max ₹${discount.maximumDiscount!.toStringAsFixed(0)}');
    }
    
    return conditions.isNotEmpty ? conditions.join(', ') : 'None';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'scheduled':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Dialog and action methods
  Future<void> _showAddDiscountDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DiscountRuleDialog(),
    );
    
    if (result == true) {
      // Refresh the list
      ref.invalidate(activeDiscountsProvider);
    }
  }

  Future<void> _showEditDiscountDialog(
    BuildContext context,
    Discount discount,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DiscountRuleDialog(existingDiscount: discount),
    );
    
    if (result == true) {
      // Refresh the list
      ref.invalidate(activeDiscountsProvider);
    }
  }

  Future<void> _duplicateDiscount(BuildContext context, Discount discount) async {
    try {
      final notifier = ref.read(activeDiscountsProvider.notifier);
      
      // Create a duplicate with a new name
      await notifier.addDiscount(
        name: '${discount.name} (Copy)',
        value: discount.value,
        type: discount.type,
        scope: discount.scope,
        code: discount.couponCode != null ? '${discount.couponCode}_COPY' : null,
        description: discount.description,
        minimumAmount: discount.minimumAmount,
        maximumDiscount: discount.maximumDiscount,
        validFrom: discount.validFrom,
        validUntil: discount.validUntil,
        autoApply: discount.isAutoApply,
        requiresCoupon: discount.couponCode != null,
        productIds: discount.productId != null ? [discount.productId!] : null,
        categoryIds: discount.categoryId != null ? [discount.categoryId!] : null,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Discount duplicated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _logger.error('Error duplicating discount', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error duplicating discount: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleDiscountStatus(Discount discount) async {
    try {
      final notifier = ref.read(activeDiscountsProvider.notifier);
      await notifier.toggleDiscountStatus(discount.id, !discount.isActive);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              discount.isActive 
                ? 'Discount deactivated' 
                : 'Discount activated',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _logger.error('Error toggling discount status', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDeleteDiscount(
    BuildContext context,
    Discount discount,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Discount?'),
        content: Text(
          'Are you sure you want to delete "${discount.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              
              try {
                final notifier = ref.read(activeDiscountsProvider.notifier);
                await notifier.deleteDiscount(discount.id);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Discount deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                _logger.error('Error deleting discount', e);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting discount: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
