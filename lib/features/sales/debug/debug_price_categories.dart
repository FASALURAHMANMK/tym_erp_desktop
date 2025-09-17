import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';

/// Debug function to check price categories in the database
class DebugPriceCategories {
  static final _logger = Logger('DebugPriceCategories');
  
  /// Print all price categories in the database
  static Future<void> printAllPriceCategories() async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get all price categories
      final categories = await db.query('price_categories');
      
      _logger.info('Found ${categories.length} price categories in database:');
      
      for (final category in categories) {
        _logger.info('----------------------------------------');
        _logger.info('ID: ${category['id']}');
        _logger.info('Name: ${category['name']}');
        _logger.info('Type: ${category['type']}');
        _logger.info('Business ID: ${category['business_id']}');
        _logger.info('Location ID: ${category['location_id']}');
        _logger.info('Is Default: ${category['is_default'] == 1}');
        _logger.info('Is Active: ${category['is_active'] == 1}');
        _logger.info('Has Unsynced Changes: ${category['has_unsynced_changes'] == 1}');
        _logger.info('Created At: ${category['created_at']}');
      }
      
      if (categories.isEmpty) {
        _logger.warning('No price categories found in database');
      }
      
      // Also check sync queue
      final syncQueue = await db.query(
        'sync_queue', 
        where: 'table_name = ?',
        whereArgs: ['price_categories']
      );
      
      _logger.info('----------------------------------------');
      _logger.info('Sync queue has ${syncQueue.length} pending price category syncs');
      
      for (final item in syncQueue) {
        _logger.info('  - ${item['operation']} ${item['record_id']}, retries: ${item['retry_count']}');
        if (item['error_message'] != null) {
          _logger.info('    Error: ${item['error_message']}');
        }
      }
      
    } catch (e, stackTrace) {
      _logger.error('Error checking price categories', e, stackTrace);
    }
  }
  
  /// Check price categories for a specific business
  static Future<void> checkBusinessPriceCategories(String businessId) async {
    try {
      final dbService = LocalDatabaseService();
      final db = await dbService.database;
      
      // Get locations for this business
      final locations = await db.query(
        'business_locations',
        where: 'business_id = ?',
        whereArgs: [businessId]
      );
      
      _logger.info('Business $businessId has ${locations.length} locations');
      
      for (final location in locations) {
        final locationId = location['id'] as String;
        final locationName = location['name'] as String;
        
        // Get price categories for this location
        final categories = await db.query(
          'price_categories',
          where: 'business_id = ? AND location_id = ?',
          whereArgs: [businessId, locationId]
        );
        
        _logger.info('Location "$locationName" has ${categories.length} price categories:');
        for (final category in categories) {
          _logger.info('  - ${category['name']} (${category['type']})');
        }
      }
      
    } catch (e, stackTrace) {
      _logger.error('Error checking business price categories', e, stackTrace);
    }
  }
}