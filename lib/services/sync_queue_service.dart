import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'local_database_service.dart';
import '../core/utils/logger.dart';

/// Service for managing the sync queue operations
/// Centralizes all sync queue logic to eliminate duplication across services
class SyncQueueService {
  static final _logger = Logger('SyncQueueService');
  static const int _defaultMaxRetries = 5;
  static const int _baseBackoffSeconds = 5; // exponential backoff base
  
  final LocalDatabaseService _dbService = LocalDatabaseService();
  final Uuid _uuid = const Uuid();

  // Singleton pattern
  static final SyncQueueService _instance = SyncQueueService._internal();
  factory SyncQueueService() => _instance;
  SyncQueueService._internal();

  /// Add an operation to the sync queue
  Future<void> addToQueue(
    String tableName,
    String operation,
    String recordId,
    Map<String, dynamic> data,
  ) async {
    try {
      final db = await _dbService.database;
      await db.insert('sync_queue', {
        'id': _uuid.v4(),
        'table_name': tableName,
        'operation': operation,
        'record_id': recordId,
        'data': jsonEncode(data), // Convert to JSON string for storage
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'retry_count': 0,
      });
      
      _logger.info('Added to sync queue: $operation $tableName record $recordId');
    } catch (e) {
      _logger.error('Error adding to sync queue', e);
      throw Exception('Failed to add operation to sync queue: $e');
    }
  }

  /// Get all pending sync queue items
  Future<List<Map<String, dynamic>>> getPendingItems() async {
    try {
      final db = await _dbService.database;
      return await db.query(
        'sync_queue',
        orderBy: 'created_at ASC',
      );
    } catch (e) {
      _logger.error('Error getting pending sync items', e);
      return [];
    }
  }

  /// Get pending items that are ready to be attempted (based on backoff)
  Future<List<Map<String, dynamic>>> getReadyItems({int? limit}) async {
    try {
      final db = await _dbService.database;
      final now = DateTime.now().millisecondsSinceEpoch;
      return await db.query(
        'sync_queue',
        where: 'next_attempt_at IS NULL OR next_attempt_at <= ?',
        whereArgs: [now],
        orderBy: 'created_at ASC',
        limit: limit,
      );
    } catch (e) {
      _logger.error('Error getting ready sync items', e);
      return [];
    }
  }

  /// Get only the count of pending items (fast path for UI/status)
  Future<int> getPendingCount() async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue');
      final count = result.first['count'];
      if (count is int) return count;
      if (count is num) return count.toInt();
      return 0;
    } catch (e) {
      _logger.error('Error getting pending sync count', e);
      return 0;
    }
  }

  /// Get the count of pending items for a specific table
  Future<int> getPendingCountForTable(String tableName) async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM sync_queue WHERE table_name = ?',
        [tableName],
      );
      final count = result.first['count'];
      if (count is int) return count;
      if (count is num) return count.toInt();
      return 0;
    } catch (e) {
      _logger.error('Error getting pending sync count for table $tableName', e);
      return 0;
    }
  }

  /// Get pending sync items for a specific table
  Future<List<Map<String, dynamic>>> getPendingItemsForTable(String tableName) async {
    try {
      final db = await _dbService.database;
      return await db.query(
        'sync_queue',
        where: 'table_name = ?',
        whereArgs: [tableName],
        orderBy: 'created_at ASC',
      );
    } catch (e) {
      _logger.error('Error getting pending sync items for table $tableName', e);
      return [];
    }
  }

  /// Remove a sync queue item after successful sync
  Future<void> removeItem(String queueItemId) async {
    try {
      final db = await _dbService.database;
      await db.delete(
        'sync_queue',
        where: 'id = ?',
        whereArgs: [queueItemId],
      );
      
      _logger.info('Removed sync queue item: $queueItemId');
    } catch (e) {
      _logger.error('Error removing sync queue item', e);
    }
  }

  /// Update retry count and error message for a sync queue item
  Future<void> updateRetryCount(
    String queueItemId,
    String errorMessage, {
    int maxRetries = _defaultMaxRetries,
  }) async {
    try {
      final db = await _dbService.database;
      // First get current retry count
      final current = await db.query(
        'sync_queue',
        columns: ['retry_count'],
        where: 'id = ?',
        whereArgs: [queueItemId],
      );
      
      if (current.isNotEmpty) {
        final currentRetryCount = current.first['retry_count'] as int? ?? 0;
        final nextRetry = currentRetryCount + 1;

        if (nextRetry >= maxRetries) {
          await moveToDeadLetter(queueItemId, errorMessage, retryCount: nextRetry);
          return;
        }

        // Exponential backoff with cap
        final delaySeconds = math.min(
          _baseBackoffSeconds * math.pow(2, currentRetryCount).toInt(),
          3600,
        );
        final now = DateTime.now().millisecondsSinceEpoch;
        final nextAttempt = now + delaySeconds * 1000;

        await db.update(
          'sync_queue',
          {
            'retry_count': nextRetry,
            'error_message': errorMessage,
            'last_attempt_at': now,
            'next_attempt_at': nextAttempt,
          },
          where: 'id = ?',
          whereArgs: [queueItemId],
        );
      }
      
      _logger.info('Updated retry count for sync queue item: $queueItemId');
    } catch (e) {
      _logger.error('Error updating sync queue retry count', e);
    }
  }

  /// Move a sync queue item to dead letter table and remove from queue
  Future<void> moveToDeadLetter(
    String queueItemId,
    String errorMessage, {
    int? retryCount,
  }) async {
    try {
      final db = await _dbService.database;
      final rows = await db.query(
        'sync_queue',
        where: 'id = ?',
        whereArgs: [queueItemId],
      );
      if (rows.isEmpty) return;

      final row = rows.first;
      final failedAt = DateTime.now().millisecondsSinceEpoch;
      await db.insert('sync_dead_letter', {
        'id': row['id'],
        'table_name': row['table_name'],
        'operation': row['operation'],
        'record_id': row['record_id'],
        'data': row['data'],
        'created_at': row['created_at'],
        'retry_count': retryCount ?? (row['retry_count'] as int? ?? 0),
        'error_message': errorMessage,
        'failed_at': failedAt,
      });

      await db.delete(
        'sync_queue',
        where: 'id = ?',
        whereArgs: [queueItemId],
      );

      _logger.warning('Moved sync item to dead letter: $queueItemId');
    } catch (e) {
      _logger.error('Error moving item to dead letter', e);
    }
  }

  /// Get pending items for a table that are ready now
  Future<List<Map<String, dynamic>>> getReadyItemsForTable(String tableName) async {
    try {
      final db = await _dbService.database;
      final now = DateTime.now().millisecondsSinceEpoch;
      return await db.query(
        'sync_queue',
        where: '(table_name = ?) AND (next_attempt_at IS NULL OR next_attempt_at <= ?)',
        whereArgs: [tableName, now],
        orderBy: 'created_at ASC',
      );
    } catch (e) {
      _logger.error('Error getting ready items for table $tableName', e);
      return [];
    }
  }

  /// Get failed sync items (high retry count)
  Future<List<Map<String, dynamic>>> getFailedItems({int maxRetries = 5}) async {
    try {
      final db = await _dbService.database;
      return await db.query(
        'sync_queue',
        where: 'retry_count >= ?',
        whereArgs: [maxRetries],
        orderBy: 'created_at ASC',
      );
    } catch (e) {
      _logger.error('Error getting failed sync items', e);
      return [];
    }
  }

  /// Clear all sync queue items (use with caution)
  Future<void> clearQueue() async {
    try {
      final db = await _dbService.database;
      await db.delete('sync_queue');
      _logger.info('Sync queue cleared');
    } catch (e) {
      _logger.error('Error clearing sync queue', e);
    }
  }

  /// Get sync queue statistics
  Future<Map<String, int>> getQueueStats() async {
    try {
      final db = await _dbService.database;
      
      final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue');
      final total = totalResult.first['count'] as int;
      
      final failedResult = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue WHERE retry_count >= 5');
      final failed = failedResult.first['count'] as int;

      final deadLetterResult = await db.rawQuery('SELECT COUNT(*) as count FROM sync_dead_letter');
      final dead = deadLetterResult.first['count'] as int;
      
      final byTableResult = await db.rawQuery('''
        SELECT table_name, COUNT(*) as count 
        FROM sync_queue 
        GROUP BY table_name
      ''');
      
      final byTable = <String, int>{};
      for (final row in byTableResult) {
        byTable[row['table_name'] as String] = row['count'] as int;
      }
      
      return {
        'total': total,
        'failed': failed,
        'dead_letter': dead,
        'business_locations': byTable['business_locations'] ?? 0,
        'pos_devices': byTable['pos_devices'] ?? 0,
      };
    } catch (e) {
      _logger.error('Error getting sync queue stats', e);
      return {
        'total': 0,
        'failed': 0,
        'dead_letter': 0,
        'business_locations': 0,
        'pos_devices': 0,
      };
    }
  }
}

/// Provider for sync queue service
final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  return SyncQueueService();
});
