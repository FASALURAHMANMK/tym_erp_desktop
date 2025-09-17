import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/table.dart';
import '../repositories/table_repository.dart';
import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';

part 'table_provider.g.dart';

final _logger = Logger('TableProvider');
final _uuid = const Uuid();

// Table Repository Provider
final tableRepositoryProvider = FutureProvider<TableRepository>((ref) async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  
  final repository = TableRepository(
    localDatabase: database,
    supabase: Supabase.instance.client,
    syncQueueService: SyncQueueService(),
  );
  
  // Initialize tables
  await repository.initializeLocalTables();
  
  return repository;
});

// Provider for floors and tables by business and location
@riverpod
class Floors extends _$Floors {
  @override
  FutureOr<List<Floor>> build((String, String) params) async {
    final (businessId, locationId) = params;
    
    final repository = await ref.watch(tableRepositoryProvider.future);
    
    // First, try to load from local database
    final localResult = await repository.getFloorsWithTables(
      businessId: businessId,
      locationId: locationId,
    );
    
    // If we have local data, use it (don't download unless explicitly refreshed)
    final localFloors = localResult.fold(
      (error) => <Floor>[],
      (floors) => floors,
    );
    
    // Only download from server if we have no local data
    if (localFloors.isEmpty) {
      try {
        await repository.downloadFloorsAndTables(
          businessId: businessId,
          locationId: locationId,
        );
        
        // Re-load from local database after download
        final result = await repository.getFloorsWithTables(
          businessId: businessId,
          locationId: locationId,
        );
        
        return result.fold(
          (error) => throw Exception(error),
          (floors) => floors,
        );
      } catch (e) {
        _logger.warning('Could not download floors from server, using local data', e);
      }
    }
    
    return localFloors;
  }
  
  // Method to explicitly refresh from server
  Future<void> refreshFromServer() async {
    final (businessId, locationId) = params;
    final repository = await ref.read(tableRepositoryProvider.future);
    
    try {
      await repository.downloadFloorsAndTables(
        businessId: businessId,
        locationId: locationId,
      );
      
      // Invalidate to reload from local database
      ref.invalidateSelf();
    } catch (e) {
      _logger.warning('Could not refresh floors from server', e);
    }
  }
  
  Future<void> addFloor(String name) async {
    final (businessId, locationId) = params;
    final floors = state.valueOrNull ?? [];
    final repository = await ref.read(tableRepositoryProvider.future);
    
    final result = await repository.addFloor(
      id: _uuid.v4(),
      businessId: businessId,
      locationId: locationId,
      name: name,
      displayOrder: floors.length,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (newFloor) {
        state = AsyncValue.data([...floors, newFloor]);
        _logger.info('Added floor: $name');
      },
    );
  }
  
  Future<void> updateFloor(String floorId, String name) async {
    final floors = state.valueOrNull ?? [];
    final repository = await ref.read(tableRepositoryProvider.future);
    
    final result = await repository.updateFloor(
      floorId: floorId,
      name: name,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        state = AsyncValue.data(
          floors.map((floor) {
            if (floor.id == floorId) {
              return floor.copyWith(
                name: name,
                updatedAt: DateTime.now(),
              );
            }
            return floor;
          }).toList(),
        );
        _logger.info('Updated floor: $floorId');
      },
    );
  }
  
  Future<void> deleteFloor(String floorId) async {
    final floors = state.valueOrNull ?? [];
    final repository = await ref.read(tableRepositoryProvider.future);
    
    final result = await repository.deleteFloor(floorId);
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        state = AsyncValue.data(
          floors.where((floor) => floor.id != floorId).toList(),
        );
        _logger.info('Deleted floor: $floorId');
      },
    );
  }
  
  Future<void> addTable({
    required String floorId,
    required String tableName,
    int seatingCapacity = 4,
  }) async {
    final (businessId, locationId) = params;
    final floors = state.valueOrNull ?? [];
    final repository = await ref.read(tableRepositoryProvider.future);
    
    final result = await repository.addTable(
      id: _uuid.v4(),
      businessId: businessId,
      locationId: locationId,
      floorId: floorId,
      tableName: tableName,
      seatingCapacity: seatingCapacity,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (newTable) {
        state = AsyncValue.data(
          floors.map((floor) {
            if (floor.id == floorId) {
              return floor.copyWith(
                tables: [...floor.tables, newTable],
                updatedAt: DateTime.now(),
              );
            }
            return floor;
          }).toList(),
        );
        _logger.info('Added table: $tableName to floor: $floorId');
      },
    );
  }
  
  Future<void> updateTable({
    required String tableId,
    required String tableName,
    String? displayName,
    int? seatingCapacity,
  }) async {
    final floors = state.valueOrNull ?? [];
    final repository = await ref.read(tableRepositoryProvider.future);
    
    final result = await repository.updateTable(
      tableId: tableId,
      tableName: tableName,
      displayName: displayName,
      seatingCapacity: seatingCapacity ?? 4,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        state = AsyncValue.data(
          floors.map((floor) {
            return floor.copyWith(
              tables: floor.tables.map((table) {
                if (table.id == tableId) {
                  return table.copyWith(
                    tableName: tableName,
                    displayName: displayName,
                    seatingCapacity: seatingCapacity ?? table.seatingCapacity,
                    updatedAt: DateTime.now(),
                  );
                }
                return table;
              }).toList(),
              updatedAt: DateTime.now(),
            );
          }).toList(),
        );
        _logger.info('Updated table: $tableId');
      },
    );
  }
  
  Future<void> deleteTable(String tableId) async {
    final floors = state.valueOrNull ?? [];
    final repository = await ref.read(tableRepositoryProvider.future);
    
    final result = await repository.deleteTable(tableId);
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        state = AsyncValue.data(
          floors.map((floor) {
            return floor.copyWith(
              tables: floor.tables.where((table) => table.id != tableId).toList(),
              updatedAt: DateTime.now(),
            );
          }).toList(),
        );
        _logger.info('Deleted table: $tableId');
      },
    );
  }
  
  Future<void> updateTableStatus(String tableId, TableStatus status, {String? orderId}) async {
    final floors = state.valueOrNull ?? [];
    final repository = await ref.read(tableRepositoryProvider.future);
    
    final result = await repository.updateTableStatus(
      tableId: tableId,
      status: status,
      orderId: orderId,
    );
    
    result.fold(
      (error) => throw Exception(error),
      (_) {
        state = AsyncValue.data(
          floors.map((floor) {
            return floor.copyWith(
              tables: floor.tables.map((table) {
                if (table.id == tableId) {
                  return table.copyWith(
                    status: status,
                    occupiedAt: status == TableStatus.occupied ? DateTime.now() : null,
                    updatedAt: DateTime.now(),
                  );
                }
                return table;
              }).toList(),
            );
          }).toList(),
        );
        _logger.info('Updated table status: $tableId to $status');
      },
    );
  }
}

// Helper provider to get all tables for a location
@riverpod
FutureOr<List<RestaurantTable>> allTables(
  Ref ref,
  (String, String) params,
) async {
  final floors = await ref.watch(floorsProvider(params).future);
  final tables = <RestaurantTable>[];
  
  for (final floor in floors) {
    tables.addAll(floor.tables);
  }
  
  return tables;
}

// Helper provider to get free tables
@riverpod
FutureOr<List<RestaurantTable>> freeTables(
  Ref ref,
  (String, String) params,
) async {
  final tables = await ref.watch(allTablesProvider(params).future);
  return tables.where((t) => t.isFree && t.isActive).toList();
}