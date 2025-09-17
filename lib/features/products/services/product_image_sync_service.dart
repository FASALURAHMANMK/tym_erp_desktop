import 'dart:async';
import 'dart:convert';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../data/local/image_cache_database.dart';
import '../data/local/product_local_database.dart';
import 'product_image_service.dart';

/// Service to handle syncing of product image URLs from local to remote
/// This ensures products always have the correct URLs after images upload
class ProductImageSyncService {
  static final _logger = Logger('ProductImageSyncService');
  final ProductImageService _imageService;
  final ImageCacheDatabase _imageCacheDb;
  // ignore: unused_field
  final ProductLocalDatabase _productDb;
  final LocalDatabaseService _localDb;

  Timer? _syncTimer;
  bool _isSyncing = false;

  ProductImageSyncService({
    required ProductImageService imageService,
    required ImageCacheDatabase imageCacheDb,
    required ProductLocalDatabase productDb,
    required LocalDatabaseService localDb,
  }) : _imageService = imageService,
       _imageCacheDb = imageCacheDb,
       _productDb = productDb,
       _localDb = localDb;

  /// Start periodic sync of images and URL updates
  void startPeriodicSync({Duration interval = const Duration(seconds: 30)}) {
    stopPeriodicSync();
    _syncTimer = Timer.periodic(interval, (_) => syncImagesAndUpdateProducts());
    _logger.info('Started periodic image sync with interval: $interval');
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _logger.info('Stopped periodic image sync');
  }

  /// Main sync method that uploads images and updates product URLs
  Future<void> syncImagesAndUpdateProducts() async {
    if (_isSyncing) {
      _logger.info('Sync already in progress, skipping');
      return;
    }

    _isSyncing = true;
    try {
      _logger.info('Starting image sync and product URL update');

      // Step 1: Upload pending images
      await _imageService.syncPendingUploads();

      // Step 2: Get all products with local image URLs
      final productsWithLocalImages = await _getProductsWithLocalImages();
      _logger.info(
        'Found ${productsWithLocalImages.length} products with local images',
      );

      // Step 3: Update each product's URLs
      for (final product in productsWithLocalImages) {
        await _updateProductImageUrls(product);
      }

      _logger.info('Completed image sync and product URL update');
    } catch (e, stackTrace) {
      _logger.error('Error during image sync', e, stackTrace);
    } finally {
      _isSyncing = false;
    }
  }

  /// Get all products that have local image paths
  Future<List<Map<String, dynamic>>> _getProductsWithLocalImages() async {
    try {
      final db = await _localDb.database;

      // Query products where image URLs don't start with http
      final products = await db.rawQuery('''
        SELECT id, image_url, additional_image_urls 
        FROM products 
        WHERE (image_url IS NOT NULL AND image_url NOT LIKE 'http%')
           OR (additional_image_urls IS NOT NULL AND additional_image_urls NOT LIKE '%http%')
      ''');

      return products;
    } catch (e, stackTrace) {
      _logger.error('Error getting products with local images', e, stackTrace);
      return [];
    }
  }

  /// Update a product's image URLs from local to remote
  Future<void> _updateProductImageUrls(Map<String, dynamic> product) async {
    try {
      final productId = product['id'] as String;
      var mainImageUrl = product['image_url'] as String?;
      var additionalImageUrls = product['additional_image_urls'] as String?;

      bool hasUpdates = false;
      String? updatedMainUrl;
      List<String> updatedAdditionalUrls = [];

      // Check and update main image URL
      if (mainImageUrl != null && !mainImageUrl.startsWith('http')) {
        final remoteUrl = await _getRemoteUrlForLocalPath(mainImageUrl);
        if (remoteUrl != null) {
          updatedMainUrl = remoteUrl;
          hasUpdates = true;
          _logger.info('Updated main image URL for product $productId');
        } else {
          updatedMainUrl = mainImageUrl; // Keep local path if not uploaded yet
        }
      } else {
        updatedMainUrl = mainImageUrl;
      }

      // Check and update additional image URLs
      if (additionalImageUrls != null && additionalImageUrls.isNotEmpty) {
        // Parse JSON array
        List<dynamic> urls = [];
        try {
          if (additionalImageUrls.startsWith('[')) {
            urls = jsonDecode(additionalImageUrls);
          }
        } catch (e) {
          _logger.warning('Failed to parse additional image URLs: $e');
        }

        for (final url in urls) {
          final urlStr = url.toString();
          if (!urlStr.startsWith('http')) {
            final remoteUrl = await _getRemoteUrlForLocalPath(urlStr);
            if (remoteUrl != null) {
              updatedAdditionalUrls.add(remoteUrl);
              hasUpdates = true;
            } else {
              updatedAdditionalUrls.add(
                urlStr,
              ); // Keep local path if not uploaded yet
            }
          } else {
            updatedAdditionalUrls.add(urlStr);
          }
        }
      }

      // Update product if URLs changed
      if (hasUpdates) {
        await _updateProductInDatabase(
          productId: productId,
          mainImageUrl: updatedMainUrl,
          additionalImageUrls: updatedAdditionalUrls,
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Error updating product image URLs', e, stackTrace);
    }
  }

  /// Get remote URL for a local path from image cache
  Future<String?> _getRemoteUrlForLocalPath(String localPath) async {
    try {
      final cachedImage = await _imageCacheDb.getCachedImage(
        localPath: localPath,
      );
      if (cachedImage != null && cachedImage['is_uploaded'] == 1) {
        return cachedImage['remote_url'] as String?;
      }
      return null;
    } catch (e) {
      _logger.error('Error getting remote URL for local path', e);
      return null;
    }
  }

  /// Update product URLs in database
  Future<void> _updateProductInDatabase({
    required String productId,
    required String? mainImageUrl,
    required List<String> additionalImageUrls,
  }) async {
    try {
      final db = await _localDb.database;

      // Convert additional URLs to JSON string
      final additionalUrlsJson =
          additionalImageUrls.isEmpty ? '[]' : jsonEncode(additionalImageUrls);

      await db.update(
        'products',
        {
          'image_url': mainImageUrl,
          'additional_image_urls': additionalUrlsJson,
          'updated_at': DateTime.now().toIso8601String(),
          // Don't mark as unsynced since we're just updating URLs
        },
        where: 'id = ?',
        whereArgs: [productId],
      );

      _logger.info('Updated image URLs for product: $productId');
    } catch (e, stackTrace) {
      _logger.error('Error updating product in database', e, stackTrace);
    }
  }

  /// Clean up method
  void dispose() {
    stopPeriodicSync();
  }
}
