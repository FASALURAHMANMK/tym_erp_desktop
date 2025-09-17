import '../services/local_database_service.dart';
import '../core/utils/logger.dart';

/// Utility to clean up duplicate sync queue entries
class CleanDuplicateSyncEntries {
  static final _logger = Logger('CleanDuplicateSyncEntries');
  
  /// Remove duplicate price category sync entries that have failed
  static Future<void> cleanFailedPriceCategoryDuplicates() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Find duplicate price category entries with errors
      final duplicates = await db.rawQuery('''
        SELECT * FROM sync_queue 
        WHERE table_name = 'price_categories' 
        AND error_message LIKE '%duplicate key%'
        ORDER BY created_at ASC
      ''');
      
      _logger.info('Found ${duplicates.length} duplicate price category sync entries');
      
      // Delete them
      if (duplicates.isNotEmpty) {
        final ids = duplicates.map((row) => row['id']).toList();
        final placeholders = ids.map((_) => '?').join(',');
        
        final deleted = await db.rawDelete(
          'DELETE FROM sync_queue WHERE id IN ($placeholders)',
          ids,
        );
        
        _logger.info('Deleted $deleted duplicate price category sync entries');
      }
      
      // Also clean up any price category entries that have retry_count >= 5
      final failedDeleted = await db.delete(
        'sync_queue',
        where: 'table_name = ? AND retry_count >= ?',
        whereArgs: ['price_categories', 5],
      );
      
      if (failedDeleted > 0) {
        _logger.info('Deleted $failedDeleted failed price category sync entries');
      }
      
    } catch (e, stackTrace) {
      _logger.error('Error cleaning duplicate sync entries', e, stackTrace);
    }
  }
  
  /// Clean all failed sync entries (use with caution!)
  static Future<void> cleanAllFailedEntries() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      final deleted = await db.delete(
        'sync_queue',
        where: 'retry_count >= ?',
        whereArgs: [5],
      );
      
      _logger.info('Deleted $deleted failed sync entries');
    } catch (e, stackTrace) {
      _logger.error('Error cleaning failed entries', e, stackTrace);
    }
  }
  
  /// Get a summary of what's in the sync queue
  static Future<void> printSyncQueueSummary() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get summary by table
      final summary = await db.rawQuery('''
        SELECT 
          table_name,
          operation,
          COUNT(*) as count,
          SUM(CASE WHEN retry_count >= 5 THEN 1 ELSE 0 END) as failed_count,
          MIN(created_at) as oldest_entry
        FROM sync_queue
        GROUP BY table_name, operation
        ORDER BY table_name, operation
      ''');
      
      _logger.info('========== SYNC QUEUE SUMMARY ==========');
      for (final row in summary) {
        _logger.info('${row['table_name']} - ${row['operation']}:');
        _logger.info('  Total: ${row['count']}, Failed: ${row['failed_count']}');
        _logger.info('  Oldest: ${row['oldest_entry']}');
      }
      _logger.info('=========================================');
      
      // Get detailed info about pending items
      final pendingItems = await db.query(
        'sync_queue',
        where: 'retry_count < 5',
        orderBy: 'created_at DESC',
      );
      
      if (pendingItems.isNotEmpty) {
        _logger.info('========== PENDING ITEMS DETAIL ==========');
        for (final item in pendingItems) {
          _logger.info('Table: ${item['table_name']}, Operation: ${item['operation']}');
          _logger.info('  Record ID: ${item['record_id']}');
          _logger.info('  Retries: ${item['retry_count']}');
          _logger.info('  Error: ${item['error_message'] ?? 'None'}');
          _logger.info('  Created: ${item['created_at']}');
        }
        _logger.info('=========================================');
      }
      
    } catch (e, stackTrace) {
      _logger.error('Error getting sync queue summary', e, stackTrace);
    }
  }
  
  /// Force retry all pending items (reset retry count)
  static Future<int> forceRetryPendingItems() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Reset retry count for all items with retry_count < 5
      final updated = await db.update(
        'sync_queue',
        {
          'retry_count': 0,
          'error_message': null,
        },
        where: 'retry_count < 5',
      );
      
      _logger.info('Reset retry count for $updated pending items');
      return updated;
    } catch (e, stackTrace) {
      _logger.error('Error resetting retry counts', e, stackTrace);
      return 0;
    }
  }
  
  /// Clear ALL items from sync queue (use with extreme caution!)
  static Future<int> clearAllSyncQueueItems() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      final deleted = await db.delete('sync_queue');
      
      _logger.info('Cleared ALL $deleted items from sync queue');
      return deleted;
    } catch (e, stackTrace) {
      _logger.error('Error clearing all sync queue items', e, stackTrace);
      return 0;
    }
  }
}