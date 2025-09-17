import 'dart:convert';
import '../services/local_database_service.dart';
import '../core/utils/logger.dart';

/// Utility to fix DateTime format issues in sync queue
class FixDateTimeSyncQueue {
  static final _logger = Logger('FixDateTimeSyncQueue');
  
  /// Fix all DateTime fields in sync queue data
  static Future<void> fixAllDateTimeFields() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get all sync queue items
      final items = await db.query('sync_queue');
      
      _logger.info('Found ${items.length} items in sync queue to check');
      
      int fixedCount = 0;
      
      for (final item in items) {
        final dataString = item['data'] as String?;
        if (dataString == null || dataString.isEmpty) continue;
        
        try {
          // Parse the JSON data
          final data = jsonDecode(dataString) as Map<String, dynamic>;
          bool needsUpdate = false;
          
          // Fix common DateTime fields
          final dateTimeFields = [
            'created_at', 'updated_at', 'last_synced_at', 
            'createdAt', 'updatedAt', 'lastSyncedAt'
          ];
          
          for (final field in dateTimeFields) {
            if (data.containsKey(field)) {
              final value = data[field];
              
              // Check if it's a millisecond timestamp (number or string of numbers)
              if (value is int || (value is String && value.length > 10 && !value.contains('-'))) {
                // Convert to ISO 8601 string
                final millis = value is int ? value : int.parse(value);
                data[field] = DateTime.fromMillisecondsSinceEpoch(millis).toIso8601String();
                needsUpdate = true;
                _logger.info('Fixed $field in ${item['table_name']} record ${item['record_id']}');
              }
            }
          }
          
          // Also convert camelCase to snake_case for Supabase
          final conversions = {
            'businessId': 'business_id',
            'locationId': 'location_id',
            'deviceId': 'device_id',
            'deviceCode': 'device_code',
            'deviceName': 'device_name',
            'isDefault': 'is_default',
            'isActive': 'is_active',
            'createdBy': 'created_by',
            'positionX': 'position_x',
            'positionY': 'position_y',
            'seatingCapacity': 'seating_capacity',
          };
          
          for (final entry in conversions.entries) {
            if (data.containsKey(entry.key)) {
              data[entry.value] = data.remove(entry.key);
              needsUpdate = true;
            }
          }
          
          // Remove local-only fields
          final localOnlyFields = [
            'has_unsynced_changes', 'last_synced_at', 'sync_status',
            'hasUnsyncedChanges', 'lastSyncedAt', 'syncStatus'
          ];
          
          for (final field in localOnlyFields) {
            if (data.containsKey(field)) {
              data.remove(field);
              needsUpdate = true;
            }
          }
          
          // Handle created_by field - remove if it's 'system' or empty
          final createdBy = data['created_by'] ?? data['createdBy'];
          if (createdBy == 'system' || createdBy == '') {
            data['created_by'] = null;
            data.remove('createdBy');
            needsUpdate = true;
          }
          
          // Update the sync queue item if needed
          if (needsUpdate) {
            await db.update(
              'sync_queue',
              {'data': jsonEncode(data)},
              where: 'id = ?',
              whereArgs: [item['id']],
            );
            fixedCount++;
          }
        } catch (e) {
          _logger.error('Error processing item ${item['id']}', e);
        }
      }
      
      _logger.info('Fixed $fixedCount sync queue items');
      
      // Also reset retry counts for items that may have failed due to DateTime issues
      final resetCount = await db.update(
        'sync_queue',
        {
          'retry_count': 0,
          'error_message': null,
        },
        where: 'error_message LIKE ? OR error_message LIKE ?',
        whereArgs: ['%date/time field value out of range%', '%invalid input syntax for type timestamp%'],
      );
      
      _logger.info('Reset retry count for $resetCount items that had DateTime errors');
      
    } catch (e, stackTrace) {
      _logger.error('Error fixing DateTime fields', e, stackTrace);
    }
  }
  
  /// Print detailed info about sync queue items with DateTime issues
  static Future<void> analyzeDateTimeIssues() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get items with DateTime-related errors
      final errorItems = await db.query(
        'sync_queue',
        where: 'error_message LIKE ? OR error_message LIKE ?',
        whereArgs: ['%date/time%', '%timestamp%'],
      );
      
      _logger.info('========== DATETIME ISSUES IN SYNC QUEUE ==========');
      _logger.info('Found ${errorItems.length} items with DateTime errors');
      
      for (final item in errorItems) {
        _logger.info('---');
        _logger.info('Table: ${item['table_name']}, Operation: ${item['operation']}');
        _logger.info('Record ID: ${item['record_id']}');
        _logger.info('Error: ${item['error_message']}');
        
        final dataString = item['data'] as String?;
        if (dataString != null) {
          try {
            final data = jsonDecode(dataString) as Map<String, dynamic>;
            
            // Check for problematic fields
            for (final entry in data.entries) {
              final key = entry.key;
              final value = entry.value;
              
              if (key.contains('_at') || key.contains('At')) {
                _logger.info('  $key: $value (${value.runtimeType})');
                
                // Check if it looks like milliseconds
                if (value is int || (value is String && value.length > 10 && !value.contains('-'))) {
                  _logger.warning('    ^ This looks like milliseconds, should be ISO 8601');
                }
              }
            }
          } catch (e) {
            _logger.error('Could not parse data', e);
          }
        }
      }
      
      _logger.info('====================================================');
      
    } catch (e, stackTrace) {
      _logger.error('Error analyzing DateTime issues', e, stackTrace);
    }
  }
}