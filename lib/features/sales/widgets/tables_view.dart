import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/table.dart';
import '../providers/table_provider.dart';
import '../providers/cart_provider.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';
import '../../../core/utils/logger.dart';

class TablesView extends ConsumerStatefulWidget {
  const TablesView({super.key});

  @override
  ConsumerState<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends ConsumerState<TablesView> {
  static final _logger = Logger('TablesView');
  String? _selectedFloorId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);

    return selectedLocationAsync.when(
      data: (selectedLocation) {
        if (selectedBusiness == null || selectedLocation == null) {
          return const Center(
            child: Text('Please select a business and location'),
          );
        }

        final floorsAsync = ref.watch(
          floorsProvider((selectedBusiness.id, selectedLocation.id)),
        );

        return floorsAsync.when(
          data: (floors) {
            if (floors.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No floors configured',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please configure floors in Table Management',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Select first floor by default
            if (_selectedFloorId == null && floors.isNotEmpty) {
              _selectedFloorId = floors.first.id;
            }

            final selectedFloor = floors.firstWhere(
              (f) => f.id == _selectedFloorId,
              orElse: () => floors.first,
            );

            return Column(
              children: [
                // Floor selector
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: floors.length,
                    itemBuilder: (context, index) {
                      final floor = floors[index];
                      final isSelected = floor.id == _selectedFloorId;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(floor.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFloorId = floor.id;
                              });
                            }
                          },
                          avatar: CircleAvatar(
                            backgroundColor: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerHighest,
                            child: Text(
                              floor.tables.length.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Tables grid
                Expanded(
                  child: selectedFloor.tables.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.table_restaurant,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tables in ${selectedFloor.name}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: selectedFloor.tables.length,
                          itemBuilder: (context, index) {
                            final table = selectedFloor.tables[index];
                            return _buildTableCard(context, table);
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading tables: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(floorsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading location: $error'),
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, RestaurantTable table) {
    final theme = Theme.of(context);
    final statusColor =
        Color(int.parse(table.statusColorHex.replaceFirst('#', '0xFF')));

    return Card(
      color: statusColor.withValues(alpha: 0.9),
      child: InkWell(
        onTap: () => _onTableTap(context, table),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Table name
              Text(
                table.displayText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              
              // Seating capacity
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${table.seatingCapacity}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status text
              if (table.status != TableStatus.free) ...[
                const SizedBox(height: 8),
                Text(
                  table.statusText.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              
              // Time occupied
              if (table.occupiedAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  _getOccupiedDuration(table.occupiedAt!),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
              
              // Current amount
              if (table.currentAmount != null && table.currentAmount! > 0) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${table.currentAmount!.toStringAsFixed(2)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getOccupiedDuration(DateTime occupiedAt) {
    final duration = DateTime.now().difference(occupiedAt);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  void _onTableTap(BuildContext context, RestaurantTable table) {
    if (table.isFree) {
      // Start new order for this table
      _startNewOrder(context, table);
    } else if (table.status == TableStatus.occupied) {
      // Load existing order for this table
      _loadExistingOrder(context, table);
    } else if (table.status == TableStatus.billed) {
      // Show billed order details
      _showBilledOrder(context, table);
    } else {
      // Table is blocked or reserved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Table ${table.displayText} is ${table.statusText}'),
        ),
      );
    }
  }

  void _startNewOrder(BuildContext context, RestaurantTable table) {
    // Set the selected table in cart
    ref.read(selectedTableProvider.notifier).selectTable(table);
    
    // Clear cart for new order
    ref.read(cartNotifierProvider.notifier).clearCart();
    
    // Set table in cart
    ref.read(cartNotifierProvider.notifier).setTable(
      tableId: table.id,
      tableName: '${table.displayText} (${table.seatingCapacity} seats)',
    );
    
    // Update table status to occupied
    final selectedBusiness = ref.read(selectedBusinessProvider);
    final selectedLocation = ref.read(selectedLocationNotifierProvider).valueOrNull;
    
    if (selectedBusiness != null && selectedLocation != null) {
      ref.read(floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier)
        .updateTableStatus(table.id, TableStatus.occupied);
    }
    
    _logger.info('Starting new order for table ${table.displayText}');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected table ${table.displayText} for new order'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _loadExistingOrder(BuildContext context, RestaurantTable table) {
    // TODO: Load existing order from database
    _logger.info('Loading existing order for table ${table.displayText}');
    
    // Set the selected table
    ref.read(selectedTableProvider.notifier).selectTable(table);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading order for table ${table.displayText}'),
      ),
    );
  }

  void _showBilledOrder(BuildContext context, RestaurantTable table) {
    // TODO: Show billed order details
    _logger.info('Showing billed order for table ${table.displayText}');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Table ${table.displayText} - Billed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Amount: ₹${table.currentAmount?.toStringAsFixed(2) ?? '0.00'}'),
            const SizedBox(height: 16),
            const Text('This table has been billed and is awaiting payment.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Mark table as free after payment
              _markTableAsFree(context, table);
            },
            child: const Text('Mark as Paid'),
          ),
        ],
      ),
    );
  }

  void _markTableAsFree(BuildContext context, RestaurantTable table) {
    final selectedBusiness = ref.read(selectedBusinessProvider);
    final selectedLocation = ref.read(selectedLocationNotifierProvider).valueOrNull;
    
    if (selectedBusiness != null && selectedLocation != null) {
      ref.read(floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier)
        .updateTableStatus(table.id, TableStatus.free);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Table ${table.displayText} is now free'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

// Provider for selected table
final selectedTableProvider = StateNotifierProvider<SelectedTableNotifier, RestaurantTable?>((ref) {
  return SelectedTableNotifier();
});

class SelectedTableNotifier extends StateNotifier<RestaurantTable?> {
  SelectedTableNotifier() : super(null);
  
  void selectTable(RestaurantTable table) {
    state = table;
  }
  
  void clearTable() {
    state = null;
  }
}