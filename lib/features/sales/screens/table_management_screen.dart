import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/table.dart';
import '../providers/table_provider.dart';
import '../../business/providers/business_provider.dart';
import '../../location/providers/location_provider.dart';

class TableManagementScreen extends ConsumerStatefulWidget {
  const TableManagementScreen({super.key});

  @override
  ConsumerState<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends ConsumerState<TableManagementScreen> {
  String? _selectedFloorId;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    final selectedLocationAsync = ref.watch(selectedLocationNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Management'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh tables
              ref.invalidate(floorsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: selectedLocationAsync.when(
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
                return _buildEmptyState(context, selectedBusiness.id, selectedLocation.id);
              }
              
              // Select first floor by default
              if (_selectedFloorId == null && floors.isNotEmpty) {
                _selectedFloorId = floors.first.id;
              }
              
              final selectedFloor = floors.firstWhere(
                (f) => f.id == _selectedFloorId,
                orElse: () => floors.first,
              );
              
              return Row(
                children: [
                  // Left sidebar - Floor list
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      border: Border(
                        right: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Floor header
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Floors',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _showAddFloorDialog(
                                  context,
                                  selectedBusiness.id,
                                  selectedLocation.id,
                                ),
                                tooltip: 'Add Floor',
                              ),
                            ],
                          ),
                        ),
                        // Floor list
                        Expanded(
                          child: ListView.builder(
                            itemCount: floors.length,
                            itemBuilder: (context, index) {
                              final floor = floors[index];
                              final isSelected = floor.id == _selectedFloorId;
                              
                              return ListTile(
                                selected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedFloorId = floor.id;
                                  });
                                },
                                title: Text(floor.name),
                                subtitle: Text(
                                  '${floor.tables.length} tables',
                                  style: theme.textTheme.bodySmall,
                                ),
                                trailing: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'edit':
                                        _showEditFloorDialog(context, floor);
                                        break;
                                      case 'delete':
                                        _confirmDeleteFloor(context, floor);
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 20),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, size: 20),
                                          SizedBox(width: 8),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Right side - Table grid
                  Expanded(
                    child: Column(
                      children: [
                        // Table header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${selectedFloor.name} - Tables',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton.icon(
                                onPressed: () => _showAddTableDialog(
                                  context,
                                  selectedBusiness.id,
                                  selectedLocation.id,
                                  selectedFloor.id,
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Table'),
                              ),
                            ],
                          ),
                        ),
                        
                        // Table grid
                        Expanded(
                          child: selectedFloor.tables.isEmpty
                            ? Center(
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
                                      'No tables in ${selectedFloor.name}',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Add tables to get started',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  Text('Error loading floors: $error'),
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
      ),
    );
  }
  
  Widget _buildEmptyState(BuildContext context, String businessId, String locationId) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_restaurant,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No floors configured',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding a floor',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddFloorDialog(context, businessId, locationId),
            icon: const Icon(Icons.add),
            label: const Text('Add First Floor'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTableCard(BuildContext context, RestaurantTable table) {
    final theme = Theme.of(context);
    final statusColor = Color(int.parse(table.statusColorHex.replaceFirst('#', '0xFF')));
    
    return Card(
      color: statusColor.withValues(alpha: 0.9),
      child: InkWell(
        onTap: () => _showEditTableDialog(context, table),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                table.displayText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${table.seatingCapacity} seats',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    color: Colors.white,
                    onPressed: () => _showEditTableDialog(context, table),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18),
                    color: Colors.white,
                    onPressed: () => _confirmDeleteTable(context, table),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAddFloorDialog(BuildContext context, String businessId, String locationId) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Floor'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Floor Name',
            hintText: 'e.g., Ground Floor, First Floor',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                ref.read(floorsProvider((businessId, locationId)).notifier)
                  .addFloor(nameController.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  void _showEditFloorDialog(BuildContext context, Floor floor) {
    final nameController = TextEditingController(text: floor.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Floor'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Floor Name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final selectedBusiness = ref.read(selectedBusinessProvider);
                final selectedLocation = ref.read(selectedLocationNotifierProvider).valueOrNull;
                if (selectedBusiness != null && selectedLocation != null) {
                  ref.read(floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier)
                    .updateFloor(floor.id, nameController.text.trim());
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
  
  void _confirmDeleteFloor(BuildContext context, Floor floor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Floor?'),
        content: Text(
          'Are you sure you want to delete "${floor.name}"?\n'
          'This will also delete all ${floor.tables.length} tables in this floor.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final selectedBusiness = ref.read(selectedBusinessProvider);
              final selectedLocation = ref.read(selectedLocationNotifierProvider).valueOrNull;
              if (selectedBusiness != null && selectedLocation != null) {
                ref.read(floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier)
                  .deleteFloor(floor.id);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  void _showAddTableDialog(
    BuildContext context,
    String businessId,
    String locationId,
    String floorId,
  ) {
    final nameController = TextEditingController();
    final seatsController = TextEditingController(text: '4');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Table'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Table Name',
                hintText: 'e.g., T1, Table 1',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: seatsController,
              decoration: const InputDecoration(
                labelText: 'Seating Capacity',
                hintText: 'Number of seats',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final seats = int.tryParse(seatsController.text) ?? 4;
                ref.read(floorsProvider((businessId, locationId)).notifier)
                  .addTable(
                    floorId: floorId,
                    tableName: nameController.text.trim(),
                    seatingCapacity: seats,
                  );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  void _showEditTableDialog(BuildContext context, RestaurantTable table) {
    final nameController = TextEditingController(text: table.tableName);
    final displayNameController = TextEditingController(text: table.displayName);
    final seatsController = TextEditingController(text: table.seatingCapacity.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Table'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Table Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name (optional)',
                hintText: 'Leave empty to use table name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: seatsController,
              decoration: const InputDecoration(
                labelText: 'Seating Capacity',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final selectedBusiness = ref.read(selectedBusinessProvider);
                final selectedLocation = ref.read(selectedLocationNotifierProvider).valueOrNull;
                if (selectedBusiness != null && selectedLocation != null) {
                  final seats = int.tryParse(seatsController.text) ?? table.seatingCapacity;
                  ref.read(floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier)
                    .updateTable(
                      tableId: table.id,
                      tableName: nameController.text.trim(),
                      displayName: displayNameController.text.trim().isEmpty 
                        ? null 
                        : displayNameController.text.trim(),
                      seatingCapacity: seats,
                    );
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
  
  void _confirmDeleteTable(BuildContext context, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Table?'),
        content: Text('Are you sure you want to delete "${table.displayText}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final selectedBusiness = ref.read(selectedBusinessProvider);
              final selectedLocation = ref.read(selectedLocationNotifierProvider).valueOrNull;
              if (selectedBusiness != null && selectedLocation != null) {
                ref.read(floorsProvider((selectedBusiness.id, selectedLocation.id)).notifier)
                  .deleteTable(table.id);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}