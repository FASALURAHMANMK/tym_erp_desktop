import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/exceptions/offline_first_exceptions.dart';
import '../../../core/utils/logger.dart';
import '../data/local/image_cache_database.dart';

class ProductImageService {
  static final _logger = Logger('ProductImageService');
  final SupabaseClient _supabase;
  final ImageCacheDatabase _cacheDb;
  final _uuid = const Uuid();

  static const String bucketName = 'product-images';
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int targetImageSize = 1024 * 1024; // 1MB after compression
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  ];

  ProductImageService({
    required SupabaseClient supabase,
    required ImageCacheDatabase cacheDb,
  }) : _supabase = supabase,
       _cacheDb = cacheDb;

  /// Pick and upload a product image
  Future<Either<OfflineFirstException, String>> pickAndUploadImage({
    required String businessId,
    required String productId,
    required bool isMainImage,
  }) async {
    try {
      _logger.info('Starting image picker for product: $productId');
      
      // Pick image file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      
      _logger.info('File picker result: ${result != null ? "Files: ${result.files.length}" : "null"}');

      if (result == null || result.files.isEmpty) {
        // User cancelled - don't treat as error
        _logger.info('User cancelled image selection');
        return const Right(''); // Empty string indicates cancellation
      }

      final file = result.files.first;

      // Validate file
      if (file.path == null) {
        return Left(ValidationException('Invalid file path', 'pickImage'));
      }

      if (file.size > maxImageSize) {
        return Left(ValidationException('Image size exceeds 5MB limit', 'pickImage'));
      }

      // Process and upload
      return await uploadImage(
        filePath: file.path!,
        businessId: businessId,
        productId: productId,
        isMainImage: isMainImage,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to pick and upload image', e, stackTrace);
      return Left(BusinessLogicException('Failed to pick image: ${e.toString()}', 'pickImage'));
    }
  }
  
  /// Pick and upload multiple images at once
  Future<Either<OfflineFirstException, List<String>>> pickAndUploadMultipleImages({
    required String businessId,
    required String productId,
  }) async {
    try {
      _logger.info('Starting multi-image picker for product: $productId');
      
      // Pick multiple image files
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      
      _logger.info('File picker result: ${result != null ? "Files: ${result.files.length}" : "null"}');

      if (result == null || result.files.isEmpty) {
        // User cancelled - don't treat as error
        _logger.info('User cancelled image selection');
        return const Right([]); // Empty list indicates cancellation
      }

      final uploadedUrls = <String>[];
      final errors = <String>[];

      // Process each file
      for (int i = 0; i < result.files.length; i++) {
        final file = result.files[i];
        
        // Validate file
        if (file.path == null) {
          errors.add('File ${i + 1}: Invalid file path');
          continue;
        }

        if (file.size > maxImageSize) {
          errors.add('File ${file.name}: Exceeds 5MB limit');
          continue;
        }

        // Upload image (all as additional images initially)
        final uploadResult = await uploadImage(
          filePath: file.path!,
          businessId: businessId,
          productId: productId,
          isMainImage: false, // All uploaded as additional initially
        );
        
        uploadResult.fold(
          (error) => errors.add('File ${file.name}: ${error.message}'),
          (url) => uploadedUrls.add(url),
        );
      }
      
      // If some files failed but some succeeded, still return the successful ones
      if (uploadedUrls.isNotEmpty) {
        if (errors.isNotEmpty) {
          _logger.warning('Some images failed to upload: ${errors.join(', ')}');
        }
        return Right(uploadedUrls);
      } else if (errors.isNotEmpty) {
        return Left(BusinessLogicException(
          'Failed to upload images: ${errors.join(', ')}',
          'pickMultipleImages',
        ));
      } else {
        return const Right([]);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to pick and upload multiple images', e, stackTrace);
      return Left(BusinessLogicException(
        'Failed to pick images: ${e.toString()}',
        'pickMultipleImages',
      ));
    }
  }

  /// Upload an image file
  Future<Either<OfflineFirstException, String>> uploadImage({
    required String filePath,
    required String businessId,
    required String productId,
    required bool isMainImage,
  }) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return Left(ValidationException('File does not exist', 'uploadImage'));
      }

      // Compress image if needed
      final compressedBytes = await _compressImage(file);

      // Generate unique filename
      final extension = path.extension(filePath).toLowerCase();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imageType =
          isMainImage ? 'main' : 'additional_${_uuid.v4().substring(0, 8)}';
      final fileName = '${productId}_${imageType}_$timestamp$extension';
      final storagePath = '$businessId/$productId/$fileName';

      // Save to local cache first
      final localPath = await _saveToLocalCache(
        bytes: compressedBytes,
        businessId: businessId,
        productId: productId,
        fileName: fileName,
      );

      // Add to cache database
      await _cacheDb.addImageToCache(
        productId: productId,
        businessId: businessId,
        imageType: isMainImage ? 'main' : 'additional',
        localPath: localPath,
        remotePath: storagePath,
        fileSize: compressedBytes.length,
        mimeType: _getMimeType(extension),
      );

      // Try to upload to Supabase if online
      final uploadResult = await _uploadToSupabase(
        bytes: compressedBytes,
        storagePath: storagePath,
      );

      if (uploadResult.isRight()) {
        // Update cache with remote URL
        final remoteUrl = uploadResult.getOrElse(() => '');
        await _cacheDb.updateImageUploadStatus(
          localPath: localPath,
          remoteUrl: remoteUrl,
          isUploaded: true,
        );
        return Right(remoteUrl);
      } else {
        // Queue for later sync if upload failed
        await _cacheDb.addToSyncQueue(
          productId: productId,
          operation: 'upload',
          localPath: localPath,
          remotePath: storagePath,
        );

        // Return local path for offline use
        return Right(localPath);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to upload image', e, stackTrace);
      return Left(BusinessLogicException('Failed to upload image: ${e.toString()}', 'uploadImage'));
    }
  }

  /// Compress image to target size
  Future<Uint8List> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();

      // Skip compression if already small enough
      if (bytes.length <= targetImageSize) {
        return bytes;
      }

      // Compress image
      final compressed = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1024,
        minHeight: 1024,
        quality: 85,
        keepExif: false,
      );

      _logger.info(
        'Image compressed from ${bytes.length} to ${compressed.length} bytes',
      );
      return compressed;
    } catch (e, stackTrace) {
      _logger.error('Failed to compress image', e, stackTrace);
      // Return original if compression fails
      return await file.readAsBytes();
    }
  }

  /// Save image to local cache
  Future<String> _saveToLocalCache({
    required Uint8List bytes,
    required String businessId,
    required String productId,
    required String fileName,
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory(
        '${appDir.path}/product_images/$businessId/$productId',
      );

      // Create directory if it doesn't exist
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      // Save file
      final file = File('${cacheDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e, stackTrace) {
      _logger.error('Failed to save to local cache', e, stackTrace);
      rethrow;
    }
  }

  /// Upload image to Supabase Storage
  Future<Either<OfflineFirstException, String>> _uploadToSupabase({
    required Uint8List bytes,
    required String storagePath,
  }) async {
    try {
      // Check if we have internet connection
      // This is a simple check - you might want to use connectivity_plus

      await _supabase.storage.from(bucketName).uploadBinary(storagePath, bytes);

      // Get public URL
      final publicUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(storagePath);

      _logger.info('Image uploaded to Supabase: $publicUrl');
      return Right(publicUrl);
    } catch (e) {
      _logger.warning('Failed to upload to Supabase (will retry later): $e');
      return Left(CloudServiceException('Failed to upload to cloud: ${e.toString()}', 'uploadToSupabase'));
    }
  }

  /// Delete an image
  Future<Either<OfflineFirstException, void>> deleteImage({
    required String imageUrl,
    required String productId,
  }) async {
    try {
      // Check if it's a local path or remote URL
      final isLocal = !imageUrl.startsWith('http');

      if (isLocal) {
        // Delete local file
        final file = File(imageUrl);
        if (await file.exists()) {
          await file.delete();
        }

        // Remove from cache database
        await _cacheDb.removeFromCache(localPath: imageUrl);
      } else {
        // Extract storage path from URL
        final uri = Uri.parse(imageUrl);
        final pathSegments = uri.pathSegments;
        final storageIndex = pathSegments.indexOf('product-images');

        if (storageIndex != -1 && storageIndex < pathSegments.length - 1) {
          final storagePath = pathSegments.sublist(storageIndex + 1).join('/');

          // Delete from Supabase
          await _supabase.storage.from(bucketName).remove([storagePath]);

          // Delete local cache if exists
          final cachedImage = await _cacheDb.getCachedImage(
            remoteUrl: imageUrl,
          );
          if (cachedImage != null) {
            final localFile = File(cachedImage['local_path']);
            if (await localFile.exists()) {
              await localFile.delete();
            }
            await _cacheDb.removeFromCache(
              localPath: cachedImage['local_path'],
            );
          }
        }
      }

      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete image', e, stackTrace);
      return Left(BusinessLogicException('Failed to delete image: ${e.toString()}', 'deleteImage'));
    }
  }

  /// Get image (from cache or download)
  Future<Either<OfflineFirstException, String>> getImage(String imageUrl) async {
    try {
      // Check if it's already a local path
      if (!imageUrl.startsWith('http')) {
        final file = File(imageUrl);
        if (await file.exists()) {
          return Right(imageUrl);
        }
        return Left(ValidationException('Local image not found', 'getImage'));
      }

      // Check local cache
      final cachedImage = await _cacheDb.getCachedImage(remoteUrl: imageUrl);
      if (cachedImage != null) {
        final localPath = cachedImage['local_path'];
        final file = File(localPath);
        if (await file.exists()) {
          return Right(localPath);
        }
      }

      // Download from Supabase
      final uri = Uri.parse(imageUrl);
      final response = await _supabase.storage
          .from(bucketName)
          .download(uri.pathSegments.last);

      // Save to cache
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(imageUrl);
      final localPath = '${appDir.path}/product_images/cache/$fileName';
      final file = File(localPath);

      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }

      await file.writeAsBytes(response);

      return Right(localPath);
    } catch (e, stackTrace) {
      _logger.error('Failed to get image', e, stackTrace);
      return Left(BusinessLogicException('Failed to get image: ${e.toString()}', 'getImage'));
    }
  }

  /// Sync pending image uploads
  Future<void> syncPendingUploads() async {
    try {
      final pendingUploads = await _cacheDb.getPendingUploads();

      for (final upload in pendingUploads) {
        final localPath = upload['local_path'];
        final remotePath = upload['remote_path'];

        final file = File(localPath);
        if (!await file.exists()) {
          // Remove from queue if file doesn't exist
          await _cacheDb.removeFromSyncQueue(id: upload['id']);
          continue;
        }

        final bytes = await file.readAsBytes();
        final result = await _uploadToSupabase(
          bytes: bytes,
          storagePath: remotePath,
        );

        if (result.isRight()) {
          // Update cache and remove from queue
          final remoteUrl = result.getOrElse(() => '');
          await _cacheDb.updateImageUploadStatus(
            localPath: localPath,
            remoteUrl: remoteUrl,
            isUploaded: true,
          );
          await _cacheDb.removeFromSyncQueue(id: upload['id']);
        } else {
          // Increment retry count
          await _cacheDb.incrementSyncRetry(id: upload['id']);
        }
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to sync pending uploads', e, stackTrace);
    }
  }

  /// Clean up old cached images
  Future<void> cleanupCache({int maxCacheSizeMB = 100}) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${appDir.path}/product_images');

      if (!await cacheDir.exists()) {
        return;
      }

      // Calculate total cache size
      int totalSize = 0;
      final files = <FileSystemEntity>[];

      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          files.add(entity);
          totalSize += await entity.length();
        }
      }

      final maxSize = maxCacheSizeMB * 1024 * 1024;

      if (totalSize > maxSize) {
        // Sort files by last modified (oldest first)
        files.sort((a, b) {
          final aModified = (a as File).lastModifiedSync();
          final bModified = (b as File).lastModifiedSync();
          return aModified.compareTo(bModified);
        });

        // Delete oldest files until under limit
        for (final file in files) {
          if (totalSize <= maxSize) break;

          final fileSize = await (file as File).length();
          await file.delete();
          totalSize -= fileSize;

          // Remove from cache database
          await _cacheDb.removeFromCache(localPath: file.path);
        }

        _logger.info(
          'Cache cleanup completed. New size: ${totalSize ~/ 1024}KB',
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to cleanup cache', e, stackTrace);
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}
