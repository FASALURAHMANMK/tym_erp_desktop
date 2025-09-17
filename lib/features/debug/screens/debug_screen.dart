import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/generic_sync_processor.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../business/providers/business_provider.dart';

/// Debug and Development Assistance Screen
/// This screen provides various utilities for development and debugging
class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  static final _logger = Logger('DebugScreen');
  final _localDb = LocalDatabaseService();
  final _syncQueue = SyncQueueService();
  final _supabase = Supabase.instance.client;
  
  bool _isLoading = false;
  String _statusMessage = '';
  List<Map<String, dynamic>> _syncQueueItems = [];
  Map<String, int> _tableRecordCounts = {};

  @override
  void initState() {
    super.initState();
    _loadDebugData();
  }

  Future<void> _loadDebugData() async {
    setState(() => _isLoading = true);
    try {
      // Load sync queue items
      _syncQueueItems = await _syncQueue.getPendingItems();
      
      // Load record counts for various tables
      final database = await _localDb.database;
      final tables = [
        'businesses', 'locations', 'pos_devices', 'products', 'product_variations',
        'product_categories', 'product_brands', 'orders', 'order_items', 'customers',
        'tables', 'table_areas', 'employees', 'payment_methods', 'price_categories',
        'discounts', 'charges', 'tax_groups', 'tax_rates', 'sync_queue'
      ];
      
      _tableRecordCounts = {};
      for (final table in tables) {
        try {
          final count = Sqflite.firstIntValue(
            await database.rawQuery('SELECT COUNT(*) FROM $table')
          ) ?? 0;
          _tableRecordCounts[table] = count;
        } catch (e) {
          // Table might not exist
          _tableRecordCounts[table] = -1;
        }
      }
      
      setState(() => _statusMessage = 'Debug data loaded');
    } catch (e) {
      setState(() => _statusMessage = 'Error loading debug data: $e');
      _logger.error('Error loading debug data', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Clear ALL local data - complete reset
  Future<void> _clearAllLocalData() async {
    final confirmed = await _showConfirmationDialog(
      'Clear All Local Data',
      'This will DELETE all local data including:\n'
      '• All cached businesses, locations, products\n'
      '• All orders and transactions\n'
      '• All sync queue items\n'
      '• All user preferences\n\n'
      'This action cannot be undone. Continue?',
      isDangerous: true,
    );
    
    if (!confirmed) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing all local data...';
    });
    
    try {
      final database = await _localDb.database;
      
      // Get all table names
      final tables = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      );
      
      // Delete all data from each table
      for (final table in tables) {
        final tableName = table['name'] as String;
        await database.delete(tableName);
        _logger.info('Cleared table: $tableName');
      }
      
      setState(() => _statusMessage = 'All local data cleared successfully');
      await _loadDebugData();
    } catch (e) {
      setState(() => _statusMessage = 'Error clearing data: $e');
      _logger.error('Error clearing all local data', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Clear sync queue
  Future<void> _clearSyncQueue() async {
    final confirmed = await _showConfirmationDialog(
      'Clear Sync Queue',
      'This will remove all pending sync items. Data will not be synced to cloud. Continue?',
    );
    
    if (!confirmed) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing sync queue...';
    });
    
    try {
      final database = await _localDb.database;
      await database.delete('sync_queue');
      
      setState(() => _statusMessage = 'Sync queue cleared');
      await _loadDebugData();
    } catch (e) {
      setState(() => _statusMessage = 'Error clearing sync queue: $e');
      _logger.error('Error clearing sync queue', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Force sync all pending items
  Future<void> _forceSyncAll() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Starting force sync...';
    });
    
    try {
      // Use GenericSyncProcessor
      final syncProcessor = GenericSyncProcessor();
      await syncProcessor.processSyncQueue();
      
      setState(() => _statusMessage = 'Force sync completed');
      await _loadDebugData();
    } catch (e) {
      setState(() => _statusMessage = 'Error during sync: $e');
      _logger.error('Error during force sync', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Clear specific table
  Future<void> _clearTable(String tableName) async {
    final confirmed = await _showConfirmationDialog(
      'Clear Table: $tableName',
      'This will delete all records from the $tableName table. Continue?',
    );
    
    if (!confirmed) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing $tableName...';
    });
    
    try {
      final database = await _localDb.database;
      await database.delete(tableName);
      
      setState(() => _statusMessage = 'Table $tableName cleared');
      await _loadDebugData();
    } catch (e) {
      setState(() => _statusMessage = 'Error clearing table: $e');
      _logger.error('Error clearing table $tableName', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Fix corrupted orders (remove malformed JSON)
  Future<void> _fixCorruptedOrders() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking for corrupted orders...';
    });
    
    try {
      final database = await _localDb.database;
      
      // Find corrupted orders
      final corruptedOrders = await database.rawQuery(
        "SELECT id, order_number FROM orders WHERE items LIKE '%{id:%' OR (items LIKE '%{%' AND items NOT LIKE '%\"%')"
      );
      
      if (corruptedOrders.isEmpty) {
        setState(() => _statusMessage = 'No corrupted orders found');
        return;
      }
      
      final confirmed = await _showConfirmationDialog(
        'Fix Corrupted Orders',
        'Found ${corruptedOrders.length} corrupted orders. Delete them?',
        isDangerous: true,
      );
      
      if (!confirmed) return;
      
      // Delete corrupted orders
      await database.execute(
        "DELETE FROM orders WHERE items LIKE '%{id:%' OR (items LIKE '%{%' AND items NOT LIKE '%\"%')"
      );
      
      setState(() => _statusMessage = 'Deleted ${corruptedOrders.length} corrupted orders');
      await _loadDebugData();
    } catch (e) {
      setState(() => _statusMessage = 'Error fixing corrupted orders: $e');
      _logger.error('Error fixing corrupted orders', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Reset user session (logout and clear auth)
  Future<void> _resetUserSession() async {
    final confirmed = await _showConfirmationDialog(
      'Reset User Session',
      'This will log you out and clear all authentication data. Continue?',
    );
    
    if (!confirmed) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'Resetting user session...';
    });
    
    try {
      await _supabase.auth.signOut();
      setState(() => _statusMessage = 'User session reset. Please log in again.');
    } catch (e) {
      setState(() => _statusMessage = 'Error resetting session: $e');
      _logger.error('Error resetting user session', e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Show confirmation dialog
  Future<bool> _showConfirmationDialog(
    String title,
    String message, {
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDangerous
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  )
                : null,
            child: Text(isDangerous ? 'Delete' : 'Confirm'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final selectedBusiness = ref.watch(selectedBusinessProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug & Development Tools'),
        backgroundColor: theme.colorScheme.errorContainer,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warning banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Development Mode - Use with caution!',
                            style: TextStyle(
                              color: theme.colorScheme.onErrorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Status message
                  if (_statusMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Current context info
                  _buildSection(
                    'Current Context',
                    [
                      _buildInfoRow('User', currentUser?.email ?? 'Not logged in'),
                      _buildInfoRow('Business', selectedBusiness?.name ?? 'None selected'),
                      _buildInfoRow('Business ID', selectedBusiness?.id ?? 'N/A'),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Database statistics
                  _buildSection(
                    'Local Database Statistics',
                    _tableRecordCounts.entries.map((entry) {
                      final color = entry.value == -1
                          ? theme.colorScheme.error
                          : entry.value == 0
                          ? theme.colorScheme.onSurface.withOpacity(0.5)
                          : theme.colorScheme.onSurface;
                      
                      return _buildInfoRow(
                        entry.key,
                        entry.value == -1 ? 'Not found' : '${entry.value} records',
                        valueColor: color,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Sync queue info
                  _buildSection(
                    'Sync Queue (${_syncQueueItems.length} pending)',
                    _syncQueueItems.isEmpty
                        ? [const Text('No pending sync items')]
                        : _syncQueueItems.take(5).map((item) {
                            return Text(
                              '${item['operation']} ${item['table_name']} - ${item['record_id']}',
                              style: theme.textTheme.bodySmall,
                            );
                          }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action buttons
                  Text(
                    'Debug Actions',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildActionButton(
                        'Refresh Data',
                        Icons.refresh,
                        _loadDebugData,
                      ),
                      _buildActionButton(
                        'Force Sync All',
                        Icons.cloud_upload,
                        _forceSyncAll,
                      ),
                      _buildActionButton(
                        'Clear Sync Queue',
                        Icons.clear_all,
                        _clearSyncQueue,
                        isDestructive: true,
                      ),
                      _buildActionButton(
                        'Fix Corrupted Orders',
                        Icons.healing,
                        _fixCorruptedOrders,
                      ),
                      _buildActionButton(
                        'Reset User Session',
                        Icons.logout,
                        _resetUserSession,
                        isDestructive: true,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Dangerous actions
                  Text(
                    'Dangerous Actions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildActionButton(
                        'CLEAR ALL LOCAL DATA',
                        Icons.delete_forever,
                        _clearAllLocalData,
                        isDangerous: true,
                      ),
                      ..._tableRecordCounts.entries
                          .where((e) => e.value > 0)
                          .map((e) => _buildActionButton(
                                'Clear ${e.key}',
                                Icons.delete_outline,
                                () => _clearTable(e.key),
                                isDestructive: true,
                              )),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
    bool isDangerous = false,
  }) {
    final theme = Theme.of(context);
    final backgroundColor = isDangerous
        ? theme.colorScheme.error
        : isDestructive
        ? theme.colorScheme.errorContainer
        : null;
    
    final foregroundColor = isDangerous
        ? theme.colorScheme.onError
        : isDestructive
        ? theme.colorScheme.onErrorContainer
        : null;
    
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }
}