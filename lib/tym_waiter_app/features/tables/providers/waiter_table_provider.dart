import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/sales/models/table.dart';
import 'waiter_location_provider.dart';

part 'waiter_table_provider.g.dart';

/// Provider for fetching floors and tables from Supabase for waiter app
@riverpod
Future<List<Floor>> waiterFloors(Ref ref) async {
  final logger = Logger('WaiterFloorsProvider');

  // Get the current location for the waiter - use read instead of watch to avoid re-fetching
  final locationAsync = await ref.read(waiterLocationNotifierProvider.future);

  if (locationAsync == null) {
    logger.warning('No location available for waiter');
    return [];
  }

  try {
    final supabase = Supabase.instance.client;

    // Fetch table areas (floors) from Supabase with timeout
    final areasResponse = await supabase
        .from('table_areas')
        .select()
        .eq('business_id', locationAsync.businessId)
        .eq('location_id', locationAsync.id)
        .eq('is_active', true)
        .order('display_order')
        .timeout(const Duration(seconds: 10));

    if (areasResponse.isEmpty) {
      logger.info('No table areas found for location: ${locationAsync.name}');
      return [];
    }

    // Fetch all tables for these areas
    final areaIds = (areasResponse as List).map((area) => area['id']).toList();

    final tablesResponse = await supabase
        .from('tables')
        .select()
        .inFilter('area_id', areaIds)
        .eq('is_active', true)
        .order('table_number')
        .timeout(const Duration(seconds: 10));

    // Convert to Floor objects with their tables
    final floors = <Floor>[];

    for (final areaData in areasResponse) {
      // Get tables for this area
      final areaTables =
          (tablesResponse as List)
              .where((table) => table['area_id'] == areaData['id'])
              .map(
                (tableData) => RestaurantTable(
                  id: tableData['id'],
                  businessId: tableData['business_id'],
                  locationId: tableData['location_id'],
                  floorId: tableData['area_id'], // area_id maps to floorId
                  tableName: tableData['table_name'] ?? 'Table ${tableData['table_number']}',
                  displayName: tableData['display_name'],
                  seatingCapacity: tableData['capacity'] ?? 4,
                  status: _parseTableStatus(tableData['status']),
                  positionX: tableData['x_position']?.toDouble() ?? 0.0,
                  positionY: tableData['y_position']?.toDouble() ?? 0.0,
                  shape: _parseTableShape(tableData['shape']),
                  isActive: tableData['is_active'] ?? true,
                  createdAt: DateTime.parse(tableData['created_at']),
                  updatedAt: DateTime.parse(tableData['updated_at']),
                  // Current order info - will be fetched separately if needed
                  currentOrderId: tableData['current_order_id'],
                  occupiedAt:
                      tableData['occupied_at'] != null
                          ? DateTime.parse(tableData['occupied_at'])
                          : null,
                  occupiedBy: tableData['occupied_by'],
                  currentAmount: tableData['current_amount']?.toDouble(),
                  customerName: tableData['customer_name'],
                  customerPhone: tableData['customer_phone'],
                  displayOrder: tableData['display_order'] ?? 0,
                  notes: tableData['notes'],
                ),
              )
              .toList();

      // Sort tables by display order
      areaTables.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

      floors.add(
        Floor(
          id: areaData['id'],
          businessId: areaData['business_id'],
          locationId: areaData['location_id'],
          name: areaData['name'],
          displayOrder: areaData['display_order'] ?? 0,
          description: areaData['description'],
          isActive: areaData['is_active'] ?? true,
          createdAt: DateTime.parse(areaData['created_at']),
          updatedAt: DateTime.parse(areaData['updated_at']),
          tables: areaTables,
        ),
      );
    }

    // Sort floors by display order
    floors.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    logger.info(
      'Fetched ${floors.length} floors with ${floors.fold(0, (sum, floor) => sum + floor.tables.length)} tables',
    );

    return floors;
  } on TimeoutException catch (e) {
    logger.error('Timeout fetching floors from cloud', e);
    throw Exception('Connection timeout. Please check your internet connection and try again.');
  } catch (e, stackTrace) {
    logger.error('Failed to fetch floors from cloud', e, stackTrace);
    throw Exception('Failed to load tables: ${e.toString()}');
  }
}

// Helper function to parse table status
TableStatus _parseTableStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'free':
      return TableStatus.free;
    case 'occupied':
      return TableStatus.occupied;
    case 'billed':
      return TableStatus.billed;
    case 'reserved':
      return TableStatus.reserved;
    case 'blocked':
      return TableStatus.blocked;
    default:
      return TableStatus.free;
  }
}

// Helper function to parse table shape
TableShape _parseTableShape(String? shape) {
  switch (shape?.toLowerCase()) {
    case 'square':
      return TableShape.square;
    case 'circle':
      return TableShape.circle;
    case 'rectangle':
      return TableShape.rectangle;
    default:
      return TableShape.square;
  }
}
