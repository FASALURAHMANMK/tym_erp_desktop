import 'local_database_service.dart';
import '../core/utils/logger.dart';

/// Utility service for generating unique device codes for POS devices
/// Centralizes device code generation logic to eliminate duplication
class DeviceCodeGenerator {
  static final _logger = Logger('DeviceCodeGenerator');
  static final LocalDatabaseService _dbService = LocalDatabaseService();

  /// Generate unique device code for a business
  /// Returns a simple code like "POS001", "POS002" etc. that's unique within the business
  static Future<String> generateForBusiness(String businessId) async {
    try {
      final db = await _dbService.database;
      
      // Count all POS devices for this business
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count 
        FROM pos_devices pd
        INNER JOIN business_locations bl ON pd.location_id = bl.id
        WHERE bl.business_id = ?
      ''', [businessId]);
      
      final deviceCount = (result.first['count'] as int) + 1;
      return 'POS${deviceCount.toString().padLeft(3, '0')}';
    } catch (e) {
      _logger.error('Error generating device code for business $businessId', e);
      // Fallback to timestamp-based code
      return 'POS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    }
  }

  /// Generate unique device code from location ID
  /// Gets the business ID from location and generates code for that business
  static Future<String> generateForLocation(String locationId) async {
    try {
      final db = await _dbService.database;
      
      // Get business_id from location_id
      final locationResult = await db.query(
        'business_locations',
        columns: ['business_id'],
        where: 'id = ?',
        whereArgs: [locationId],
        limit: 1,
      );
      
      if (locationResult.isEmpty) {
        throw Exception('Location not found');
      }
      
      final businessId = locationResult.first['business_id'] as String;
      return await generateForBusiness(businessId);
    } catch (e) {
      _logger.error('Error generating device code for location $locationId', e);
      // Fallback to timestamp-based code
      return 'POS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    }
  }

  /// Check if device code exists within a specific business
  /// Returns true if the code already exists, false otherwise
  static Future<bool> isCodeUniqueInBusiness(
    String deviceCode, 
    String businessId, {
    String? excludeDeviceId,
  }) async {
    try {
      final db = await _dbService.database;
      
      String whereClause = '''
        pd.device_code = ? AND pd.is_active = ? AND bl.business_id = ?
      ''';
      List<dynamic> whereArgs = [deviceCode, 1, businessId];
      
      // Exclude specific device ID if provided (for updates)
      if (excludeDeviceId != null) {
        whereClause += ' AND pd.id != ?';
        whereArgs.add(excludeDeviceId);
      }
      
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count 
        FROM pos_devices pd
        INNER JOIN business_locations bl ON pd.location_id = bl.id
        WHERE $whereClause
      ''', whereArgs);
      
      final count = result.first['count'] as int;
      return count == 0; // Return true if unique (count is 0)
    } catch (e) {
      _logger.error('Error checking device code uniqueness in business', e);
      return false; // Assume not unique on error for safety
    }
  }

  /// Check if device code exists within a specific location
  /// Returns true if the code already exists, false otherwise  
  static Future<bool> isCodeUniqueInLocation(
    String deviceCode,
    String locationId, {
    String? excludeDeviceId,
  }) async {
    try {
      final db = await _dbService.database;
      
      String whereClause = 'device_code = ? AND location_id = ? AND is_active = ?';
      List<dynamic> whereArgs = [deviceCode, locationId, 1];
      
      // Exclude specific device ID if provided (for updates)
      if (excludeDeviceId != null) {
        whereClause += ' AND id != ?';
        whereArgs.add(excludeDeviceId);
      }
      
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count 
        FROM pos_devices 
        WHERE $whereClause
      ''', whereArgs);
      
      final count = result.first['count'] as int;
      return count == 0; // Return true if unique (count is 0)
    } catch (e) {
      _logger.error('Error checking device code uniqueness in location', e);
      return false; // Assume not unique on error for safety
    }
  }

  /// Validate and generate unique device code
  /// If provided code is unique, returns it; otherwise generates a new one
  static Future<String> validateOrGenerate(
    String? proposedCode,
    String businessId, {
    String? excludeDeviceId,
  }) async {
    // If no code proposed, generate one
    if (proposedCode == null || proposedCode.isEmpty) {
      return await generateForBusiness(businessId);
    }
    
    // Check if proposed code is unique
    final isUnique = await isCodeUniqueInBusiness(
      proposedCode, 
      businessId, 
      excludeDeviceId: excludeDeviceId,
    );
    
    if (isUnique) {
      return proposedCode;
    } else {
      // Generate a new unique code
      return await generateForBusiness(businessId);
    }
  }

  /// Get business device count
  static Future<int> getBusinessDeviceCount(String businessId) async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count FROM pos_devices pd
        INNER JOIN business_locations bl ON pd.location_id = bl.id
        WHERE bl.business_id = ? AND pd.is_active = ? AND bl.is_active = ?
      ''', [businessId, 1, 1]);
      return result.first['count'] as int;
    } catch (e) {
      _logger.error('Error getting business device count', e);
      return 0;
    }
  }

  /// Get location device count
  static Future<int> getLocationDeviceCount(String locationId) async {
    try {
      final db = await _dbService.database;
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count FROM pos_devices 
        WHERE location_id = ? AND is_active = ?
      ''', [locationId, 1]);
      return result.first['count'] as int;
    } catch (e) {
      _logger.error('Error getting location device count', e);
      return 0;
    }
  }

  /// Generate fallback timestamp-based code
  static String generateTimestampCode() {
    return 'POS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  }
}