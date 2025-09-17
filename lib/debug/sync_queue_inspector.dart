import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_database_service.dart';
import '../core/utils/logger.dart';
import 'clean_duplicate_sync_entries.dart';

/// Widget to inspect and manage the sync queue
class SyncQueueInspector extends ConsumerStatefulWidget {
  const SyncQueueInspector({super.key});

  @override
  ConsumerState<SyncQueueInspector> createState() => _SyncQueueInspectorState();
}

class _SyncQueueInspectorState extends ConsumerState<SyncQueueInspector> {
  static final _logger = Logger('SyncQueueInspector');
  List<Map<String, dynamic>> _pendingItems = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSyncQueue();
  }

  Future<void> _loadSyncQueue() async {
    setState(() => _isLoading = true);
    
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get all pending items
      final pendingItems = await db.query(
        'sync_queue',
        orderBy: 'created_at DESC',
      );
      
      // Get stats
      final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue');
      final failedResult = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue WHERE retry_count >= 5');
      
      final byTableResult = await db.rawQuery('''
        SELECT table_name, COUNT(*) as count, MIN(created_at) as oldest
        FROM sync_queue 
        GROUP BY table_name
      ''');
      
      final stats = {
        'total': totalResult.isNotEmpty ? (totalResult.first['count'] ?? 0) : 0,
        'failed': failedResult.isNotEmpty ? (failedResult.first['count'] ?? 0) : 0,
        'by_table': {},
      };
      
      for (final row in byTableResult) {
        final tableName = row['table_name'];
        if (tableName != null) {
          (stats['by_table'] as Map)[tableName] = {
            'count': row['count'] ?? 0,
            'oldest': row['oldest'],
          };
        }
      }
      
      setState(() {
        _pendingItems = pendingItems;
        _stats = stats;
        _isLoading = false;
      });
      
      _logger.info('Loaded ${pendingItems.length} items from sync queue');
    } catch (e, stackTrace) {
      _logger.error('Error loading sync queue', e, stackTrace);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearFailedItems() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      final deleted = await db.delete(
        'sync_queue',
        where: 'retry_count >= ?',
        whereArgs: [5],
      );
      
      _logger.info('Cleared $deleted failed items from sync queue');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cleared $deleted failed items')),
        );
        _loadSyncQueue();
      }
    } catch (e, stackTrace) {
      _logger.error('Error clearing failed items', e, stackTrace);
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      await db.delete(
        'sync_queue',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      _logger.info('Deleted item $id from sync queue');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted')),
        );
        _loadSyncQueue();
      }
    } catch (e, stackTrace) {
      _logger.error('Error deleting item', e, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Queue Inspector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSyncQueue,
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'clear_failed':
                  await _clearFailedItems();
                  break;
                case 'force_retry':
                  final count = await CleanDuplicateSyncEntries.forceRetryPendingItems();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reset retry count for $count items')),
                    );
                    _loadSyncQueue();
                  }
                  break;
                case 'clear_all':
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear All Sync Queue Items?'),
                      content: const Text('This will remove ALL items from the sync queue. This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                          ),
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    final count = await CleanDuplicateSyncEntries.clearAllSyncQueueItems();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cleared $count items from sync queue')),
                      );
                      _loadSyncQueue();
                    }
                  }
                  break;
                case 'print_summary':
                  await CleanDuplicateSyncEntries.printSyncQueueSummary();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Summary printed to console')),
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              if (_stats['failed'] > 0)
                PopupMenuItem(
                  value: 'clear_failed',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text('Clear ${_stats['failed']} Failed Items'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'force_retry',
                child: Row(
                  children: [
                    Icon(Icons.replay),
                    SizedBox(width: 8),
                    Text('Force Retry Pending'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'print_summary',
                child: Row(
                  children: [
                    Icon(Icons.summarize),
                    SizedBox(width: 8),
                    Text('Print Summary to Console'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: theme.colorScheme.error),
                    const SizedBox(width: 8),
                    const Text('Clear ALL Items'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sync Queue Statistics',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total', _stats['total'].toString(), Colors.blue),
                      _buildStatItem('Failed', _stats['failed'].toString(), Colors.red),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'By Table:',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...(_stats['by_table'] as Map).entries.map((entry) {
                    final table = entry.key;
                    final data = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(table),
                          Text('${data['count']} items'),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Items List
          Expanded(
            child: _pendingItems.isEmpty
                ? const Center(
                    child: Text('No items in sync queue'),
                  )
                : ListView.builder(
                    itemCount: _pendingItems.length,
                    itemBuilder: (context, index) {
                      final item = _pendingItems[index];
                      final isFailed = (item['retry_count'] ?? 0) >= 5;
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: isFailed ? theme.colorScheme.errorContainer : null,
                        child: ExpansionTile(
                          title: Text(
                            '${item['table_name']} - ${item['operation']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isFailed ? theme.colorScheme.error : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Record ID: ${item['record_id']}'),
                              Text('Retries: ${item['retry_count']} | Created: ${item['created_at']}'),
                              if (item['error_message'] != null)
                                Text(
                                  'Error: ${item['error_message']}',
                                  style: TextStyle(color: theme.colorScheme.error),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteItem(item['id']),
                            tooltip: 'Delete from queue',
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Full Data:',
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: SelectableText(
                                      _formatJson(item['data']),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                  if (item['error_message'] != null) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'Full Error:',
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        color: theme.colorScheme.error,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.errorContainer,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: SelectableText(
                                        item['error_message'],
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
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
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _formatJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      return 'No data';
    }
    try {
      final decoded = jsonDecode(jsonString);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (e) {
      return jsonString;
    }
  }
}