import '../services/local_database_service.dart';
import '../core/utils/logger.dart';

/// Debug utility to check what's in the sync queue
class SyncQueueDebugger {
  static final _logger = Logger('SyncQueueDebugger');
  
  static Future<void> checkPendingItems() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get all pending items
      final pendingItems = await db.query(
        'sync_queue',
        orderBy: 'created_at ASC',
      );
      
      _logger.info('============ SYNC QUEUE STATUS ============');
      _logger.info('Total pending items: ${pendingItems.length}');
      
      if (pendingItems.isNotEmpty) {
        // Group by table
        final Map<String, List<Map<String, dynamic>>> groupedByTable = {};
        
        for (final item in pendingItems) {
          final tableName = item['table_name'] as String;
          groupedByTable.putIfAbsent(tableName, () => []).add(item);
        }
        
        // Print details for each table
        for (final entry in groupedByTable.entries) {
          _logger.info('\nTable: ${entry.key}');
          _logger.info('  Count: ${entry.value.length}');
          
          for (final item in entry.value) {
            _logger.info('  - ID: ${item['id']}');
            _logger.info('    Record ID: ${item['record_id']}');
            _logger.info('    Operation: ${item['operation']}');
            _logger.info('    Retry Count: ${item['retry_count']}');
            _logger.info('    Created: ${item['created_at']}');
            if (item['last_error'] != null) {
              _logger.info('    Last Error: ${item['last_error']}');
            }
            
            // Parse and show partial data
            try {
              final data = item['data'] as String?;
              if (data != null && data.isNotEmpty) {
                _logger.info('    Data preview: ${data.substring(0, data.length > 100 ? 100 : data.length)}...');
              }
            } catch (e) {
              _logger.info('    Data: Unable to parse');
            }
          }
        }
      }
      
      // Check for failed items (retry_count >= 5)
      final failedItems = await db.query(
        'sync_queue',
        where: 'retry_count >= ?',
        whereArgs: [5],
      );
      
      if (failedItems.isNotEmpty) {
        _logger.warning('\n============ FAILED ITEMS ============');
        _logger.warning('Items that have failed too many times: ${failedItems.length}');
        for (final item in failedItems) {
          _logger.warning('  - Table: ${item['table_name']}, Record: ${item['record_id']}');
          _logger.warning('    Last Error: ${item['last_error']}');
        }
      }
      
      _logger.info('=========================================');
      
    } catch (e, stackTrace) {
      _logger.error('Error checking sync queue', e, stackTrace);
    }
  }
  
  /// Clear specific items from sync queue (use with caution!)
  static Future<void> clearFailedItems() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      final deleted = await db.delete(
        'sync_queue',
        where: 'retry_count >= ?',
        whereArgs: [5],
      );
      
      _logger.info('Cleared $deleted failed items from sync queue');
    } catch (e, stackTrace) {
      _logger.error('Error clearing failed items', e, stackTrace);
    }
  }
  
  /// Get detailed stats about sync queue
  static Future<Map<String, dynamic>> getDetailedStats() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      final stats = <String, dynamic>{};
      
      // Total count
      final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue');
      stats['total'] = totalResult.first['count'];
      
      // By table
      final byTableResult = await db.rawQuery('''
        SELECT table_name, COUNT(*) as count, MIN(created_at) as oldest
        FROM sync_queue 
        GROUP BY table_name
      ''');
      
      stats['by_table'] = {};
      for (final row in byTableResult) {
        stats['by_table'][row['table_name']] = {
          'count': row['count'],
          'oldest': row['oldest'],
        };
      }
      
      // By operation
      final byOperationResult = await db.rawQuery('''
        SELECT operation, COUNT(*) as count
        FROM sync_queue 
        GROUP BY operation
      ''');
      
      stats['by_operation'] = {};
      for (final row in byOperationResult) {
        stats['by_operation'][row['operation']] = row['count'];
      }
      
      // Failed items
      final failedResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM sync_queue WHERE retry_count >= 5'
      );
      stats['failed'] = failedResult.first['count'];
      
      // Items with errors
      final errorResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM sync_queue WHERE last_error IS NOT NULL'
      );
      stats['with_errors'] = errorResult.first['count'];
      
      return stats;
    } catch (e, stackTrace) {
      _logger.error('Error getting detailed stats', e, stackTrace);
      return {};
    }
  }
}