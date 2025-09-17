import 'package:flutter/material.dart';
import '../../../../features/sales/models/table.dart';

/// Individual table card widget for displaying table information
class TableCard extends StatelessWidget {
  final RestaurantTable table;
  final VoidCallback onTap;

  const TableCard({
    super.key,
    required this.table,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(table.status),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(table.status),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Table icon and number
              Column(
                children: [
                  Icon(
                    _getTableIcon(table.shape),
                    size: 48,
                    color: _getIconColor(table.status),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    table.displayName ?? table.tableName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(table.status),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: _getTextColor(table.status).withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${table.seatingCapacity} seats',
                        style: TextStyle(
                          fontSize: 12,
                          color: _getTextColor(table.status).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Status and additional info
              Column(
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusBadgeColor(table.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(table.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusBadgeTextColor(table.status),
                      ),
                    ),
                  ),
                  
                  // Additional info based on status
                  if (table.isOccupied || table.isBilled) ...[
                    const SizedBox(height: 8),
                    if (table.customerName != null)
                      Text(
                        table.customerName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getTextColor(table.status).withValues(alpha: 0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (table.occupiedTimeDisplay.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: _getTextColor(table.status).withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            table.occupiedTimeDisplay,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getTextColor(table.status).withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (table.currentAmount != null && table.currentAmount! > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '₹${table.currentAmount!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(table.status),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(TableStatus status) {
    switch (status) {
      case TableStatus.free:
        return Colors.green.shade50;
      case TableStatus.occupied:
        return Colors.red.shade50;
      case TableStatus.billed:
        return Colors.orange.shade50;
      case TableStatus.blocked:
        return Colors.grey.shade200;
      case TableStatus.reserved:
        return Colors.blue.shade50;
    }
  }

  Color _getBorderColor(TableStatus status) {
    switch (status) {
      case TableStatus.free:
        return Colors.green.shade300;
      case TableStatus.occupied:
        return Colors.red.shade300;
      case TableStatus.billed:
        return Colors.orange.shade300;
      case TableStatus.blocked:
        return Colors.grey.shade400;
      case TableStatus.reserved:
        return Colors.blue.shade300;
    }
  }

  Color _getIconColor(TableStatus status) {
    switch (status) {
      case TableStatus.free:
        return Colors.green.shade700;
      case TableStatus.occupied:
        return Colors.red.shade700;
      case TableStatus.billed:
        return Colors.orange.shade700;
      case TableStatus.blocked:
        return Colors.grey.shade600;
      case TableStatus.reserved:
        return Colors.blue.shade700;
    }
  }

  Color _getTextColor(TableStatus status) {
    switch (status) {
      case TableStatus.free:
        return Colors.green.shade900;
      case TableStatus.occupied:
        return Colors.red.shade900;
      case TableStatus.billed:
        return Colors.orange.shade900;
      case TableStatus.blocked:
        return Colors.grey.shade800;
      case TableStatus.reserved:
        return Colors.blue.shade900;
    }
  }

  Color _getStatusBadgeColor(TableStatus status) {
    switch (status) {
      case TableStatus.free:
        return Colors.green;
      case TableStatus.occupied:
        return Colors.red;
      case TableStatus.billed:
        return Colors.orange;
      case TableStatus.blocked:
        return Colors.grey;
      case TableStatus.reserved:
        return Colors.blue;
    }
  }

  Color _getStatusBadgeTextColor(TableStatus status) {
    return Colors.white;
  }

  IconData _getTableIcon(TableShape shape) {
    switch (shape) {
      case TableShape.square:
      case TableShape.rectangle:
        return Icons.crop_square;
      case TableShape.circle:
      case TableShape.oval:
        return Icons.circle_outlined;
    }
  }

  String _getStatusText(TableStatus status) {
    switch (status) {
      case TableStatus.free:
        return 'FREE';
      case TableStatus.occupied:
        return 'OCCUPIED';
      case TableStatus.billed:
        return 'BILLED';
      case TableStatus.blocked:
        return 'BLOCKED';
      case TableStatus.reserved:
        return 'RESERVED';
    }
  }
}