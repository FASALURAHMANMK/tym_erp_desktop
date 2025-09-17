import 'package:sqflite/sqflite.dart';
import '../features/location/models/business_location.dart'; // For SyncStatus
import '../core/utils/logger.dart';

/// Utility service for managing default item logic across different entities
/// Centralizes default management to eliminate duplication
class DefaultItemManager {
  static final _logger = Logger('DefaultItemManager');
  /// Unset other default items in a table for a specific parent
  /// Used for locations (per business) and POS devices (per location)
  static Future<void> unsetDefaults(
    Database db,
    String tableName,
    String parentIdColumn,
    String parentId, {
    String? excludeId,
  }) async {
    try {
      String whereClause = '$parentIdColumn = ? AND is_default = ?';
      List<dynamic> whereArgs = [parentId, 1];
      
      if (excludeId != null) {
        whereClause += ' AND id != ?';
        whereArgs.add(excludeId);
      }
      
      await db.update(
        tableName,
        {
          'is_default': 0,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
          'sync_status': SyncStatus.pending.name,
        },
        where: whereClause,
        whereArgs: whereArgs,
      );
      
      _logger.info('Unset defaults in $tableName for $parentIdColumn: $parentId');
    } catch (e) {
      _logger.error('Error unsetting defaults in $tableName', e);
      throw Exception('Failed to unset defaults: $e');
    }
  }

  /// Unset other default locations for a business
  static Future<void> unsetLocationDefaults(
    Database db,
    String businessId, {
    String? excludeLocationId,
  }) async {
    await unsetDefaults(
      db,
      'business_locations',
      'business_id',
      businessId,
      excludeId: excludeLocationId,
    );
  }

  /// Unset other default POS devices for a location
  static Future<void> unsetDeviceDefaults(
    Database db,
    String locationId, {
    String? excludeDeviceId,
  }) async {
    await unsetDefaults(
      db,
      'pos_devices',
      'location_id',
      locationId,
      excludeId: excludeDeviceId,
    );
  }

  /// Set an item as default and unset others
  static Future<void> setAsDefault(
    Database db,
    String tableName,
    String itemId,
    String parentIdColumn,
    String parentId,
  ) async {
    try {
      // First unset other defaults
      await unsetDefaults(db, tableName, parentIdColumn, parentId, excludeId: itemId);
      
      // Then set this item as default
      await db.update(
        tableName,
        {
          'is_default': 1,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
          'sync_status': SyncStatus.pending.name,
        },
        where: 'id = ?',
        whereArgs: [itemId],
      );
      
      _logger.info('Set $tableName item $itemId as default for $parentIdColumn: $parentId');
    } catch (e) {
      _logger.error('Error setting item as default', e);
      throw Exception('Failed to set item as default: $e');
    }
  }

  /// Set location as default for a business
  static Future<void> setLocationAsDefault(
    Database db,
    String locationId,
    String businessId,
  ) async {
    await setAsDefault(
      db,
      'business_locations',
      locationId,
      'business_id',
      businessId,
    );
  }

  /// Set POS device as default for a location
  static Future<void> setDeviceAsDefault(
    Database db,
    String deviceId,
    String locationId,
  ) async {
    await setAsDefault(
      db,
      'pos_devices',
      deviceId,
      'location_id',
      locationId,
    );
  }

  /// Get default item for a parent
  static Future<Map<String, dynamic>?> getDefault(
    Database db,
    String tableName,
    String parentIdColumn,
    String parentId,
  ) async {
    try {
      final result = await db.query(
        tableName,
        where: '$parentIdColumn = ? AND is_default = ? AND is_active = ?',
        whereArgs: [parentId, 1, 1],
        limit: 1,
      );
      
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      _logger.error('Error getting default from $tableName', e);
      return null;
    }
  }

  /// Get default location for a business
  static Future<Map<String, dynamic>?> getDefaultLocation(
    Database db,
    String businessId,
  ) async {
    return await getDefault(
      db,
      'business_locations',
      'business_id',
      businessId,
    );
  }

  /// Get default POS device for a location
  static Future<Map<String, dynamic>?> getDefaultDevice(
    Database db,
    String locationId,
  ) async {
    return await getDefault(
      db,
      'pos_devices',
      'location_id',
      locationId,
    );
  }

  /// Check if item is currently default
  static Future<bool> isDefault(
    Database db,
    String tableName,
    String itemId,
  ) async {
    try {
      final result = await db.query(
        tableName,
        columns: ['is_default'],
        where: 'id = ?',
        whereArgs: [itemId],
        limit: 1,
      );
      
      if (result.isNotEmpty) {
        return result.first['is_default'] == 1;
      }
      return false;
    } catch (e) {
      _logger.error('Error checking if item is default', e);
      return false;
    }
  }

  /// Validate default constraint (only one default per parent)
  /// Returns true if constraint is valid, false otherwise
  static Future<bool> validateDefaultConstraint(
    Database db,
    String tableName,
    String parentIdColumn,
    String parentId,
  ) async {
    try {
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count 
        FROM $tableName 
        WHERE $parentIdColumn = ? AND is_default = ? AND is_active = ?
      ''', [parentId, 1, 1]);
      
      final defaultCount = result.first['count'] as int;
      return defaultCount <= 1; // Should be 0 or 1, never more
    } catch (e) {
      _logger.error('Error validating default constraint', e);
      return false;
    }
  }

  /// Fix default constraint violations (ensure only one default per parent)
  static Future<void> fixDefaultConstraints(
    Database db,
    String tableName,
    String parentIdColumn,
  ) async {
    try {
      // Find parents with multiple defaults
      final violationsResult = await db.rawQuery('''
        SELECT $parentIdColumn, COUNT(*) as count 
        FROM $tableName 
        WHERE is_default = ? AND is_active = ?
        GROUP BY $parentIdColumn
        HAVING COUNT(*) > 1
      ''', [1, 1]);
      
      for (final violation in violationsResult) {
        final parentId = violation[parentIdColumn] as String;
        _logger.warning('Fixing default constraint violation for $parentIdColumn: $parentId');
        
        // Get all defaults for this parent, ordered by created_at
        final defaultItems = await db.query(
          tableName,
          where: '$parentIdColumn = ? AND is_default = ? AND is_active = ?',
          whereArgs: [parentId, 1, 1],
          orderBy: 'created_at ASC',
        );
        
        // Keep the first (oldest) as default, unset others
        for (int i = 1; i < defaultItems.length; i++) {
          final itemId = defaultItems[i]['id'] as String;
          await db.update(
            tableName,
            {
              'is_default': 0,
              'updated_at': DateTime.now().millisecondsSinceEpoch,
              'sync_status': SyncStatus.pending.name,
            },
            where: 'id = ?',
            whereArgs: [itemId],
          );
        }
      }
      
      _logger.info('Fixed default constraint violations in $tableName');
    } catch (e) {
      _logger.error('Error fixing default constraints', e);
    }
  }
}