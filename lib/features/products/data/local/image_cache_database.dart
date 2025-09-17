import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/logger.dart';
import '../../../../services/database_schema.dart';

class ImageCacheDatabase {
  static final _logger = Logger('ImageCacheDatabase');
  final Database _database;
  final _uuid = const Uuid();
  
  ImageCacheDatabase({required Database database}) : _database = database;
  
  /// Initialize image cache tables
  static Future<void> initializeTables(Database db) async {
    try {
      await DatabaseSchema.applySqliteSchema(db);
      _logger.info('Image cache tables ensured via bundled schema');
    } catch (e, stackTrace) {
      _logger.error('Failed to ensure image cache tables', e, stackTrace);
      rethrow;
    }
  }
  
  /// Add image to cache
  Future<void> addImageToCache({
    required String productId,
    required String businessId,
    required String imageType,
    required String localPath,
    String? remotePath,
    int? fileSize,
    String? mimeType,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();
      
      await _database.insert(
        'image_cache',
        {
          'id': id,
          'product_id': productId,
          'business_id': businessId,
          'image_type': imageType,
          'local_path': localPath,
          'remote_url': remotePath,
          'file_size': fileSize,
          'mime_type': mimeType,
          'is_uploaded': remotePath != null ? 1 : 0,
          'upload_attempts': 0,
          'created_at': now,
          'updated_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.info('Image added to cache: $localPath');
    } catch (e, stackTrace) {
      _logger.error('Failed to add image to cache', e, stackTrace);
      rethrow;
    }
  }
  
  /// Update image upload status
  Future<void> updateImageUploadStatus({
    required String localPath,
    required String remoteUrl,
    required bool isUploaded,
  }) async {
    try {
      await _database.update(
        'image_cache',
        {
          'remote_url': remoteUrl,
          'is_uploaded': isUploaded ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'local_path = ?',
        whereArgs: [localPath],
      );
      
      _logger.info('Image upload status updated: $localPath');
    } catch (e, stackTrace) {
      _logger.error('Failed to update image upload status', e, stackTrace);
      rethrow;
    }
  }
  
  /// Get cached image by remote URL or local path
  Future<Map<String, dynamic>?> getCachedImage({String? remoteUrl, String? localPath}) async {
    try {
      if (remoteUrl == null && localPath == null) return null;
      
      final results = await _database.query(
        'image_cache',
        where: remoteUrl != null ? 'remote_url = ?' : 'local_path = ?',
        whereArgs: [remoteUrl ?? localPath],
        limit: 1,
      );
      
      return results.isNotEmpty ? results.first : null;
    } catch (e, stackTrace) {
      _logger.error('Failed to get cached image', e, stackTrace);
      return null;
    }
  }
  
  /// Get all cached images for a product
  Future<List<Map<String, dynamic>>> getProductImages(String productId) async {
    try {
      return await _database.query(
        'image_cache',
        where: 'product_id = ?',
        whereArgs: [productId],
        orderBy: 'image_type DESC, created_at ASC', // Main image first
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to get product images', e, stackTrace);
      return [];
    }
  }
  
  /// Remove image from cache
  Future<void> removeFromCache({required String localPath}) async {
    try {
      await _database.delete(
        'image_cache',
        where: 'local_path = ?',
        whereArgs: [localPath],
      );
      
      _logger.info('Image removed from cache: $localPath');
    } catch (e, stackTrace) {
      _logger.error('Failed to remove image from cache', e, stackTrace);
    }
  }
  
  /// Add to sync queue
  Future<void> addToSyncQueue({
    required String productId,
    required String operation,
    String? localPath,
    String? remotePath,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();
      
      await _database.insert(
        'image_sync_queue',
        {
          'id': id,
          'product_id': productId,
          'operation': operation,
          'local_path': localPath,
          'remote_path': remotePath,
          'retry_count': 0,
          'max_retries': 3,
          'created_at': now,
          'completed_at': null,
        },
      );
      
      _logger.info('Added to sync queue: $operation for product $productId');
    } catch (e, stackTrace) {
      _logger.error('Failed to add to sync queue', e, stackTrace);
      rethrow;
    }
  }
  
  /// Get pending uploads from sync queue
  Future<List<Map<String, dynamic>>> getPendingUploads() async {
    try {
      return await _database.query(
        'image_sync_queue',
        where: 'operation = ? AND completed_at IS NULL AND retry_count < max_retries',
        whereArgs: ['upload'],
        orderBy: 'created_at ASC',
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to get pending uploads', e, stackTrace);
      return [];
    }
  }
  
  /// Get pending deletes from sync queue
  Future<List<Map<String, dynamic>>> getPendingDeletes() async {
    try {
      return await _database.query(
        'image_sync_queue',
        where: 'operation = ? AND completed_at IS NULL AND retry_count < max_retries',
        whereArgs: ['delete'],
        orderBy: 'created_at ASC',
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to get pending deletes', e, stackTrace);
      return [];
    }
  }
  
  /// Increment sync retry count
  Future<void> incrementSyncRetry({required String id}) async {
    try {
      await _database.rawUpdate(
        'UPDATE image_sync_queue SET retry_count = retry_count + 1 WHERE id = ?',
        [id],
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to increment sync retry', e, stackTrace);
    }
  }
  
  /// Remove from sync queue
  Future<void> removeFromSyncQueue({required String id}) async {
    try {
      await _database.update(
        'image_sync_queue',
        {'completed_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );
      
      _logger.info('Removed from sync queue: $id');
    } catch (e, stackTrace) {
      _logger.error('Failed to remove from sync queue', e, stackTrace);
    }
  }
  
  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final totalImages = Sqflite.firstIntValue(
        await _database.rawQuery('SELECT COUNT(*) FROM image_cache'),
      ) ?? 0;
      
      final uploadedImages = Sqflite.firstIntValue(
        await _database.rawQuery('SELECT COUNT(*) FROM image_cache WHERE is_uploaded = 1'),
      ) ?? 0;
      
      final pendingUploads = Sqflite.firstIntValue(
        await _database.rawQuery('SELECT COUNT(*) FROM image_sync_queue WHERE operation = "upload" AND completed_at IS NULL'),
      ) ?? 0;
      
      final totalSize = Sqflite.firstIntValue(
        await _database.rawQuery('SELECT SUM(file_size) FROM image_cache'),
      ) ?? 0;
      
      return {
        'total_images': totalImages,
        'uploaded_images': uploadedImages,
        'pending_uploads': pendingUploads,
        'total_size_bytes': totalSize,
        'total_size_mb': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e, stackTrace) {
      _logger.error('Failed to get cache stats', e, stackTrace);
      return {};
    }
  }
  
  /// Clear all cache for a business
  Future<void> clearBusinessCache(String businessId) async {
    try {
      await _database.delete(
        'image_cache',
        where: 'business_id = ?',
        whereArgs: [businessId],
      );
      
      _logger.info('Cleared cache for business: $businessId');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear business cache', e, stackTrace);
    }
  }
  
  /// Clear old completed sync queue items
  Future<void> clearOldSyncQueueItems({int daysOld = 7}) async {
    try {
      final cutoffDate = DateTime.now()
          .subtract(Duration(days: daysOld))
          .toIso8601String();
      
      await _database.delete(
        'image_sync_queue',
        where: 'completed_at IS NOT NULL AND completed_at < ?',
        whereArgs: [cutoffDate],
      );
      
      _logger.info('Cleared old sync queue items');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear old sync queue items', e, stackTrace);
    }
  }
}
