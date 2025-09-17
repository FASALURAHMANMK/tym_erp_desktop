import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../models/table.dart';
import '../../../services/database_schema.dart';

class TableRepository {
  final Database _localDatabase;
  final SupabaseClient _supabase;
  final SyncQueueService _syncQueueService;
  final _logger = Logger('TableRepository');

  TableRepository({
    required Database localDatabase,
    required SupabaseClient supabase,
    required SyncQueueService syncQueueService,
  }) : _localDatabase = localDatabase,
       _supabase = supabase,
       _syncQueueService = syncQueueService;

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    await DatabaseSchema.applySqliteSchema(_localDatabase);
  }

  // Get floors with tables for a location
  Future<Either<String, List<Floor>>> getFloorsWithTables({
    required String businessId,
    required String locationId,
  }) async {
    try {
      // First get areas (floors)
      final areas = await _localDatabase.query(
        'table_areas',
        where: 'business_id = ? AND location_id = ? AND is_active = ?',
        whereArgs: [businessId, locationId, 1],
        orderBy: 'display_order ASC, name ASC',
      );

      final floorList = <Floor>[];

      for (final areaData in areas) {
        // Get tables for this area
        final tables = await _localDatabase.query(
          'tables',
          where: 'area_id = ? AND is_active = ?',
          whereArgs: [areaData['id'], 1],
          orderBy: 'table_number ASC',
        );

        final tableList =
            tables
                .map(
                  (tableData) => RestaurantTable(
                    id: tableData['id'] as String,
                    businessId: tableData['business_id'] as String,
                    locationId: tableData['location_id'] as String,
                    floorId: tableData['area_id'] as String,
                    tableName: tableData['table_number'] as String,
                    displayName: tableData['display_name'] as String?,
                    seatingCapacity: tableData['capacity'] as int? ?? 4,
                    status: TableStatus.values.firstWhere(
                      (s) => s.name == tableData['status'],
                      orElse: () => TableStatus.free,
                    ),
                    shape: TableShape.values.firstWhere(
                      (s) => s.name == tableData['shape'],
                      orElse: () => TableShape.square,
                    ),
                    positionX: (tableData['position_x'] as int? ?? 0).toDouble(),
                    positionY: (tableData['position_y'] as int? ?? 0).toDouble(),
                    width: (tableData['width'] as int? ?? 100).toDouble(),
                    height: (tableData['height'] as int? ?? 100).toDouble(),
                    isActive: (tableData['is_active'] as int?) == 1,
                    occupiedAt:
                        tableData['last_occupied_at'] != null
                            ? DateTime.parse(tableData['last_occupied_at'] as String)
                            : null,
                    currentOrderId: tableData['current_order_id'] as String?,
                    currentAmount: null, // current_amount doesn't exist in tables table
                    createdAt: DateTime.parse(
                      tableData['created_at'] as String,
                    ),
                    updatedAt: DateTime.parse(
                      tableData['updated_at'] as String,
                    ),
                  ),
                )
                .toList();

        floorList.add(
          Floor(
            id: areaData['id'] as String,
            businessId: areaData['business_id'] as String,
            locationId: areaData['location_id'] as String,
            name: areaData['name'] as String,
            description: areaData['description'] as String?,
            displayOrder: areaData['display_order'] as int? ?? 0,
            isActive: (areaData['is_active'] as int?) == 1,
            tables: tableList,
            createdAt: DateTime.parse(areaData['created_at'] as String),
            updatedAt: DateTime.parse(areaData['updated_at'] as String),
          ),
        );
      }

      return Right(floorList);
    } catch (e) {
      _logger.error('Error getting floors with tables', e);
      return Left('Failed to load floors: $e');
    }
  }

  // Add floor
  Future<Either<String, Floor>> addFloor({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    required int displayOrder,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      final floor = Floor(
        id: id,
        businessId: businessId,
        locationId: locationId,
        name: name,
        displayOrder: displayOrder,
        isActive: true,
        tables: [],
        createdAt: DateTime.parse(now),
        updatedAt: DateTime.parse(now),
      );

      await _localDatabase.insert('table_areas', {
        'id': id,
        'business_id': businessId,
        'location_id': locationId,
        'name': name,
        'display_order': displayOrder,
        'is_active': 1,
        'created_at': now,
        'updated_at': now,
      });

      // Queue for sync
      await _syncQueueService.addToQueue(
        'table_areas',
        'create',
        id,
        {
          'id': id,
          'business_id': businessId,
          'location_id': locationId,
          'name': name,
          'display_order': displayOrder,
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        },
      );

      _logger.info('Added floor: $name');
      return Right(floor);
    } catch (e) {
      _logger.error('Error adding floor', e);
      return Left('Failed to add floor: $e');
    }
  }

  // Update floor
  Future<Either<String, void>> updateFloor({
    required String floorId,
    required String name,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      await _localDatabase.update(
        'table_areas',
        {'name': name, 'updated_at': now},
        where: 'id = ?',
        whereArgs: [floorId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'table_areas',
        'update',
        floorId,
        {'name': name, 'updated_at': now},
      );

      _logger.info('Updated floor: $floorId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error updating floor', e);
      return Left('Failed to update floor: $e');
    }
  }

  // Delete floor
  Future<Either<String, void>> deleteFloor(String floorId) async {
    try {
      // First delete all tables in this floor
      await _localDatabase.delete(
        'tables',
        where: 'floor_id = ?',
        whereArgs: [floorId],
      );

      // Then delete the floor
      await _localDatabase.delete(
        'table_areas',
        where: 'id = ?',
        whereArgs: [floorId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'table_areas',
        'delete',
        floorId,
        {'id': floorId},
      );

      _logger.info('Deleted floor: $floorId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error deleting floor', e);
      return Left('Failed to delete floor: $e');
    }
  }

  // Add table
  Future<Either<String, RestaurantTable>> addTable({
    required String id,
    required String businessId,
    required String locationId,
    required String floorId,
    required String tableName,
    required int seatingCapacity,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      final table = RestaurantTable(
        id: id,
        businessId: businessId,
        locationId: locationId,
        floorId: floorId,
        tableName: tableName,
        seatingCapacity: seatingCapacity,
        status: TableStatus.free,
        shape: TableShape.square,
        isActive: true,
        createdAt: DateTime.parse(now),
        updatedAt: DateTime.parse(now),
      );

      await _localDatabase.insert('tables', {
        'id': id,
        'area_id': floorId,  // Note: floorId is actually the area_id
        'business_id': businessId,
        'location_id': locationId,
        'table_number': tableName,
        'capacity': seatingCapacity,
        'status': 'free',
        'shape': 'rectangle',
        'is_active': 1,
        'created_at': now,
        'updated_at': now,
      });

      // Queue for sync
      await _syncQueueService.addToQueue(
        'tables',
        'create',
        id,
        {
          'id': id,
          'area_id': floorId,  // Note: floorId is actually the area_id
          'business_id': businessId,
          'location_id': locationId,
          'table_number': tableName,
          'capacity': seatingCapacity,
          'status': 'free',
          'shape': 'rectangle',
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        },
      );

      _logger.info('Added table: $tableName');
      return Right(table);
    } catch (e) {
      _logger.error('Error adding table', e);
      return Left('Failed to add table: $e');
    }
  }

  // Update table
  Future<Either<String, void>> updateTable({
    required String tableId,
    required String tableName,
    String? displayName,
    required int seatingCapacity,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();

      await _localDatabase.update(
        'tables',
        {
          'table_number': tableName,
          'display_name': displayName,
          'capacity': seatingCapacity,
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [tableId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'tables',
        'update',
        tableId,
        {
          'table_number': tableName,
          'display_name': displayName,
          'capacity': seatingCapacity,
          'updated_at': now,
        },
      );

      _logger.info('Updated table: $tableId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error updating table', e);
      return Left('Failed to update table: $e');
    }
  }

  // Delete table
  Future<Either<String, void>> deleteTable(String tableId) async {
    try {
      await _localDatabase.delete(
        'tables',
        where: 'id = ?',
        whereArgs: [tableId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'tables',
        'delete',
        tableId,
        {'id': tableId},
      );

      _logger.info('Deleted table: $tableId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error deleting table', e);
      return Left('Failed to delete table: $e');
    }
  }

  // Update table status
  Future<Either<String, void>> updateTableStatus({
    required String tableId,
    required TableStatus status,
    String? orderId,
    double? amount,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      // First, get the existing table data to ensure we have all required fields
      final existingTable = await _localDatabase.query(
        'tables',
        where: 'id = ?',
        whereArgs: [tableId],
        limit: 1,
      );
      
      if (existingTable.isEmpty) {
        return Left('Table not found: $tableId');
      }
      
      final tableData = existingTable.first;

      await _localDatabase.update(
        'tables',
        {
          'status': status.name,
          'last_occupied_at': status == TableStatus.occupied ? now : null,
          'current_order_id': orderId,
          // Note: current_amount doesn't exist in tables table
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [tableId],
      );

      // Queue for sync with ALL required fields
      await _syncQueueService.addToQueue(
        'tables',
        'update',
        tableId,
        {
          'id': tableId,
          'area_id': tableData['area_id'], // Include the required area_id
          'business_id': tableData['business_id'],
          'location_id': tableData['location_id'],
          'table_number': tableData['table_number'],
          'display_name': tableData['display_name'],
          'capacity': tableData['capacity'],
          'status': status.name,
          'current_order_id': orderId,
          'position_x': tableData['position_x'],
          'position_y': tableData['position_y'],
          'width': tableData['width'],
          'height': tableData['height'],
          'shape': tableData['shape'],
          'is_active': tableData['is_active'],
          'is_bookable': tableData['is_bookable'],
          'settings': tableData['settings'],
          'last_occupied_at': status == TableStatus.occupied ? now : tableData['last_occupied_at'],
          'last_cleared_at': tableData['last_cleared_at'],
          'created_at': tableData['created_at'],
          'updated_at': now,
        },
      );

      _logger.info('Updated table status: $tableId to ${status.name}');
      return const Right(null);
    } catch (e) {
      _logger.error('Error updating table status', e);
      return Left('Failed to update table status: $e');
    }
  }

  // Download floors and tables from Supabase
  Future<Either<String, void>> downloadFloorsAndTables({
    required String businessId,
    required String locationId,
  }) async {
    try {
      // Download areas
      final areasResponse = await _supabase
          .from('table_areas')
          .select()
          .eq('business_id', businessId)
          .eq('location_id', locationId);

      // Download tables
      final tablesResponse = await _supabase
          .from('tables')
          .select()
          .eq('business_id', businessId)
          .eq('location_id', locationId);

      // Clear existing local data
      await _localDatabase.delete(
        'table_areas',
        where: 'business_id = ? AND location_id = ?',
        whereArgs: [businessId, locationId],
      );
      await _localDatabase.delete(
        'tables',
        where: 'business_id = ? AND location_id = ?',
        whereArgs: [businessId, locationId],
      );

      // Insert areas
      for (final area in areasResponse as List) {
        await _localDatabase.insert('table_areas', {
          'id': area['id'],
          'business_id': area['business_id'],
          'location_id': area['location_id'],
          'name': area['name'],
          'description': area['description'],
          'display_order': area['display_order'] ?? 0,
          'is_active': area['is_active'] == true ? 1 : 0,
          'layout_config': area['layout_config'] != null 
              ? (area['layout_config'] is String 
                  ? area['layout_config'] 
                  : jsonEncode(area['layout_config']))
              : null,
          'created_at': area['created_at'],
          'updated_at': area['updated_at'],
        });
      }

      // Insert tables
      for (final table in tablesResponse as List) {
        await _localDatabase.insert('tables', {
          'id': table['id'],
          'area_id': table['area_id'],
          'business_id': table['business_id'],
          'location_id': table['location_id'],
          'table_number': table['table_number'],
          'display_name': table['display_name'],
          'capacity': table['capacity'] ?? 4,
          'status': table['status'] ?? 'free',
          'current_order_id': table['current_order_id'],
          'shape': table['shape'] ?? 'rectangle',
          'position_x': table['position_x'],
          'position_y': table['position_y'],
          'width': table['width'],
          'height': table['height'],
          'is_active': table['is_active'] == true ? 1 : 0,
          'is_bookable': table['is_bookable'] == true ? 1 : 0,
          'settings': table['settings'] != null 
              ? (table['settings'] is String 
                  ? table['settings'] 
                  : jsonEncode(table['settings']))
              : null,
          'last_occupied_at': table['last_occupied_at'],
          'last_cleared_at': table['last_cleared_at'],
          'created_at': table['created_at'],
          'updated_at': table['updated_at'],
        });
      }

      _logger.info(
        'Downloaded ${areasResponse.length} areas and ${tablesResponse.length} tables',
      );
      return const Right(null);
    } catch (e) {
      _logger.error('Error downloading floors and tables', e);
      return Left('Failed to download floors and tables: $e');
    }
  }

  // Sync pending changes
  Future<void> syncPendingChanges() async {
    try {
      // Note: Since we're not tracking sync_status locally anymore,
      // we rely on the sync queue service to track what needs syncing
      // This method can be called to force sync all data if needed
      
      // Get all local areas
      final pendingAreas = await _localDatabase.query(
        'table_areas',
      );

      for (final area in pendingAreas) {
        try {
          await _supabase.from('table_areas').upsert({
            'id': area['id'],
            'business_id': area['business_id'],
            'location_id': area['location_id'],
            'name': area['name'],
            'description': area['description'],
            'display_order': area['display_order'],
            'is_active': area['is_active'] == 1,
            'layout_config': area['layout_config'] != null
                ? (area['layout_config'] is String
                    ? jsonDecode(area['layout_config'] as String)
                    : area['layout_config'])
                : null,
            'created_at': area['created_at'],
            'updated_at': area['updated_at'],
          });

          // No need to update sync status locally anymore
        } catch (e) {
          _logger.error('Error syncing area ${area['id']}', e);
        }
      }

      // Get all local tables
      final pendingTables = await _localDatabase.query(
        'tables',
      );

      for (final table in pendingTables) {
        try {
          await _supabase.from('tables').upsert({
            'id': table['id'],
            'area_id': table['area_id'],
            'business_id': table['business_id'],
            'location_id': table['location_id'],
            'table_number': table['table_number'],
            'display_name': table['display_name'],
            'capacity': table['capacity'],
            'status': table['status'],
            'current_order_id': table['current_order_id'],
            'position_x': table['position_x'],
            'position_y': table['position_y'],
            'width': table['width'],
            'height': table['height'],
            'shape': table['shape'],
            'is_active': table['is_active'] == 1,
            'is_bookable': table['is_bookable'] == 1,
            'settings': table['settings'] != null
                ? (table['settings'] is String
                    ? jsonDecode(table['settings'] as String)
                    : table['settings'])
                : null,
            'created_at': table['created_at'],
            'updated_at': table['updated_at'],
            'last_occupied_at': table['last_occupied_at'],
            'last_cleared_at': table['last_cleared_at'],
          });

          // No need to update sync status locally anymore
        } catch (e) {
          _logger.error('Error syncing table ${table['id']}', e);
        }
      }
    } catch (e) {
      _logger.error('Error syncing pending changes', e);
    }
  }
}
