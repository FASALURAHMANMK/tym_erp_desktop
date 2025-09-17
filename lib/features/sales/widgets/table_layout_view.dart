import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/price_category.dart';
import '../models/table.dart';
import '../../../core/utils/logger.dart';

class TableLayoutView extends ConsumerStatefulWidget {
  final PriceCategory priceCategory;
  
  const TableLayoutView({
    super.key,
    required this.priceCategory,
  });

  @override
  ConsumerState<TableLayoutView> createState() => _TableLayoutViewState();
}

class _TableLayoutViewState extends ConsumerState<TableLayoutView> {
  static final _logger = Logger('TableLayoutView');
  
  String? _selectedFloor;
  
  // TODO: Replace with actual floor/table data from provider
  final List<Floor> _mockFloors = [
    Floor(
      id: '1',
      businessId: 'b1',
      locationId: 'l1',
      name: 'Ground Floor',
      displayOrder: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tables: [
        RestaurantTable(
          id: 't1',
          businessId: 'b1',
          locationId: 'l1',
          floorId: '1',
          tableName: 'G1',
          status: TableStatus.occupied,
          occupiedAt: DateTime.now().subtract(const Duration(minutes: 22)),
          currentAmount: 14.00,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        RestaurantTable(
          id: 't2',
          businessId: 'b1',
          locationId: 'l1',
          floorId: '1',
          tableName: 'G2',
          status: TableStatus.free,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        RestaurantTable(
          id: 't3',
          businessId: 'b1',
          locationId: 'l1',
          floorId: '1',
          tableName: 'G3',
          status: TableStatus.free,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        RestaurantTable(
          id: 't4',
          businessId: 'b1',
          locationId: 'l1',
          floorId: '1',
          tableName: 'G4',
          status: TableStatus.free,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
    ),
    Floor(
      id: '2',
      businessId: 'b1',
      locationId: 'l1',
      name: 'First Floor',
      displayOrder: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tables: [
        RestaurantTable(
          id: 't5',
          businessId: 'b1',
          locationId: 'l1',
          floorId: '2',
          tableName: 'F1',
          status: TableStatus.free,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        RestaurantTable(
          id: 't6',
          businessId: 'b1',
          locationId: 'l1',
          floorId: '2',
          tableName: 'F2',
          status: TableStatus.billed,
          occupiedAt: DateTime.now().subtract(const Duration(minutes: 12)),
          currentAmount: 23.00,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        RestaurantTable(
          id: 't7',
          businessId: 'b1',
          locationId: 'l1',
          floorId: '2',
          tableName: 'F3',
          status: TableStatus.free,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _selectedFloor = 'all';
  }
  
  List<Floor> get _visibleFloors {
    if (_selectedFloor == 'all') {
      return _mockFloors;
    }
    return _mockFloors.where((f) => f.id == _selectedFloor).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Floor selector and search bar
        Container(
          padding: const EdgeInsets.all(16),
          color: theme.colorScheme.surface,
          child: Row(
            children: [
              // Floor dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedFloor,
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('All Floors'),
                    ),
                    ..._mockFloors.map((floor) => DropdownMenuItem(
                      value: floor.id,
                      child: Text(floor.name),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFloor = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Search field
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search table...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Table grid
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _visibleFloors.length,
            itemBuilder: (context, index) {
              final floor = _visibleFloors[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Floor header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      floor.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Table grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: floor.tables.length,
                    itemBuilder: (context, tableIndex) {
                      final table = floor.tables[tableIndex];
                      return _TableCard(
                        table: table,
                        onTap: () => _onTableTapped(table),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
        
        // Legend
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: const Color(0xFF4CAF50),
                label: 'Free',
              ),
              const SizedBox(width: 24),
              _LegendItem(
                color: const Color(0xFFFF5252),
                label: 'Occupied',
              ),
              const SizedBox(width: 24),
              _LegendItem(
                color: const Color(0xFFFFC107),
                label: 'Billed',
              ),
              const SizedBox(width: 24),
              _LegendItem(
                color: const Color(0xFF9E9E9E),
                label: 'Blocked',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _onTableTapped(RestaurantTable table) {
    _logger.info('Table tapped: ${table.tableName} - ${table.status}');
    
    // TODO: Handle table selection
    // - If free: Start new order for table
    // - If occupied: Show existing order
    // - If billed: Show bill/allow payment
  }
}

class _TableCard extends StatelessWidget {
  final RestaurantTable table;
  final VoidCallback onTap;
  
  const _TableCard({
    required this.table,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = Color(int.parse(table.statusColorHex.replaceFirst('#', '0xFF')));
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
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
                  
                  // Show amount if occupied/billed
                  if (table.currentAmount != null && table.currentAmount! > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      '₹${table.currentAmount!.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Time indicator for occupied tables
            if (table.occupiedAt != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        table.occupiedTimeDisplay,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Action buttons
            if (table.status != TableStatus.free)
              Positioned(
                bottom: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TableActionButton(
                      icon: Icons.print,
                      onTap: () {
                        // TODO: Print KOT/Bill
                      },
                    ),
                    const SizedBox(width: 4),
                    _TableActionButton(
                      icon: Icons.check,
                      onTap: () {
                        // TODO: Complete/Settle
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TableActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  
  const _TableActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  
  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}