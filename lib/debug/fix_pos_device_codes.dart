import 'dart:convert';
import '../services/local_database_service.dart';
import '../core/utils/logger.dart';

/// Utility to fix POS device code conflicts
class FixPOSDeviceCodes {
  static final _logger = Logger('FixPOSDeviceCodes');
  
  /// Fix duplicate POS device codes in sync queue
  static Future<void> fixDuplicateDeviceCodes() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Find POS device sync items with duplicate key errors
      final failedItems = await db.query(
        'sync_queue',
        where: 'table_name = ? AND error_message LIKE ?',
        whereArgs: ['pos_devices', '%duplicate key%device_code%'],
      );
      
      _logger.info('Found ${failedItems.length} POS device items with duplicate code errors');
      
      for (final item in failedItems) {
        try {
          final dataString = item['data'] as String?;
          if (dataString == null) continue;
          
          final data = jsonDecode(dataString) as Map<String, dynamic>;
          final deviceId = item['record_id'] as String;
          final oldCode = data['device_code'] ?? data['deviceCode'];
          
          // Get the location and business info
          final deviceResult = await db.query(
            'pos_devices',
            where: 'id = ?',
            whereArgs: [deviceId],
            limit: 1,
          );
          
          if (deviceResult.isEmpty) {
            _logger.warning('Device not found in local DB: $deviceId');
            continue;
          }
          
          final device = deviceResult.first;
          final locationId = device['location_id'] as String;
          
          // Get business ID from location
          final locationResult = await db.query(
            'business_locations',
            columns: ['business_id'],
            where: 'id = ?',
            whereArgs: [locationId],
            limit: 1,
          );
          
          if (locationResult.isEmpty) {
            _logger.warning('Location not found: $locationId');
            continue;
          }
          
          final businessId = locationResult.first['business_id'] as String;
          
          // Generate a new unique code
          final businessShortId = businessId.substring(0, 6).toUpperCase();
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final newCode = 'POS-$businessShortId-${timestamp.substring(timestamp.length - 6)}';
          
          _logger.info('Changing device code from $oldCode to $newCode for device $deviceId');
          
          // Update the local database
          await db.update(
            'pos_devices',
            {'device_code': newCode},
            where: 'id = ?',
            whereArgs: [deviceId],
          );
          
          // Update the sync queue data
          data['device_code'] = newCode;
          data.remove('deviceCode'); // Remove camelCase version
          
          await db.update(
            'sync_queue',
            {
              'data': jsonEncode(data),
              'retry_count': 0,
              'error_message': null,
            },
            where: 'id = ?',
            whereArgs: [item['id']],
          );
          
          _logger.info('Fixed device code for $deviceId');
        } catch (e) {
          _logger.error('Error fixing device ${item['record_id']}', e);
        }
      }
      
      _logger.info('Device code fix completed');
      
    } catch (e, stackTrace) {
      _logger.error('Error fixing POS device codes', e, stackTrace);
    }
  }
  
  /// List all POS devices and their codes
  static Future<void> listAllDeviceCodes() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get all POS devices with location and business info
      final devices = await db.rawQuery('''
        SELECT 
          pd.id,
          pd.device_code,
          pd.device_name,
          bl.name as location_name,
          bl.business_id
        FROM pos_devices pd
        INNER JOIN business_locations bl ON pd.location_id = bl.id
        WHERE pd.is_active = 1
        ORDER BY bl.business_id, pd.device_code
      ''');
      
      _logger.info('========== ALL POS DEVICES ==========');
      String? lastBusinessId;
      
      for (final device in devices) {
        final businessId = device['business_id'] as String;
        
        if (businessId != lastBusinessId) {
          _logger.info('--- Business: ${businessId.substring(0, 8)}... ---');
          lastBusinessId = businessId;
        }
        
        _logger.info('  ${device['device_code']}: ${device['device_name']} @ ${device['location_name']}');
      }
      
      _logger.info('Total devices: ${devices.length}');
      _logger.info('=====================================');
      
      // Check for duplicate codes
      final duplicates = await db.rawQuery('''
        SELECT device_code, COUNT(*) as count
        FROM pos_devices
        WHERE is_active = 1
        GROUP BY device_code
        HAVING COUNT(*) > 1
      ''');
      
      if (duplicates.isNotEmpty) {
        _logger.warning('DUPLICATE DEVICE CODES FOUND:');
        for (final dup in duplicates) {
          _logger.warning('  ${dup['device_code']}: ${dup['count']} occurrences');
        }
      } else {
        _logger.info('No duplicate device codes found locally');
      }
      
    } catch (e, stackTrace) {
      _logger.error('Error listing device codes', e, stackTrace);
    }
  }
  
  /// Regenerate all device codes to simple format (POS001, POS002, etc.)
  static Future<void> regenerateAllDeviceCodes() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get all active POS devices
      final devices = await db.rawQuery('''
        SELECT 
          pd.*,
          bl.business_id
        FROM pos_devices pd
        INNER JOIN business_locations bl ON pd.location_id = bl.id
        WHERE pd.is_active = 1
        ORDER BY bl.business_id, pd.created_at
      ''');
      
      _logger.info('Regenerating codes for ${devices.length} devices');
      
      final businessCounters = <String, int>{};
      
      for (final device in devices) {
        final deviceId = device['id'] as String;
        final businessId = device['business_id'] as String;
        
        // Get counter for this business
        final counter = (businessCounters[businessId] ?? 0) + 1;
        businessCounters[businessId] = counter;
        
        // Generate simple code like POS001, POS002
        final newCode = 'POS${counter.toString().padLeft(3, '0')}';
        
        // Update the device
        await db.update(
          'pos_devices',
          {
            'device_code': newCode,
            'sync_status': 'pending',
          },
          where: 'id = ?',
          whereArgs: [deviceId],
        );
        
        _logger.info('Updated device $deviceId to code $newCode');
        
        // Also update any sync queue entries for this device
        final syncItems = await db.query(
          'sync_queue',
          where: 'table_name = ? AND record_id = ?',
          whereArgs: ['pos_devices', deviceId],
        );
        
        for (final syncItem in syncItems) {
          final dataString = syncItem['data'] as String?;
          if (dataString != null) {
            final data = jsonDecode(dataString) as Map<String, dynamic>;
            data['device_code'] = newCode;
            data.remove('deviceCode');
            
            await db.update(
              'sync_queue',
              {
                'data': jsonEncode(data),
                'retry_count': 0,
                'error_message': null,
              },
              where: 'id = ?',
              whereArgs: [syncItem['id']],
            );
          }
        }
      }
      
      _logger.info('Successfully regenerated all device codes');
      
    } catch (e, stackTrace) {
      _logger.error('Error regenerating device codes', e, stackTrace);
    }
  }
  
  /// Reset a single device code to simple format for stuck sync queue items
  static Future<void> resetStuckDeviceCode() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Find the stuck POS device in sync queue
      final stuckItems = await db.query(
        'sync_queue',
        where: 'table_name = ? AND error_message LIKE ?',
        whereArgs: ['pos_devices', '%duplicate key%device_code%'],
      );
      
      if (stuckItems.isEmpty) {
        _logger.info('No stuck POS device items found');
        return;
      }
      
      for (final item in stuckItems) {
        final deviceId = item['record_id'] as String;
        
        // Simply set to POS001 for each stuck device
        // Since constraint will be removed, this is safe
        final newCode = 'POS001';
        
        // Update local device
        await db.update(
          'pos_devices',
          {'device_code': newCode},
          where: 'id = ?',
          whereArgs: [deviceId],
        );
        
        // Update sync queue data
        final dataString = item['data'] as String?;
        if (dataString != null) {
          final data = jsonDecode(dataString) as Map<String, dynamic>;
          data['device_code'] = newCode;
          data.remove('deviceCode');
          
          await db.update(
            'sync_queue',
            {
              'data': jsonEncode(data),
              'retry_count': 0,
              'error_message': null,
            },
            where: 'id = ?',
            whereArgs: [item['id']],
          );
        }
        
        _logger.info('Reset device code to $newCode for device $deviceId');
      }
      
    } catch (e, stackTrace) {
      _logger.error('Error resetting stuck device code', e, stackTrace);
    }
  }
}