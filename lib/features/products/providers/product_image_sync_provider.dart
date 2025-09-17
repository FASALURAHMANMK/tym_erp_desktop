import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../data/local/product_local_database.dart';
import '../services/product_image_sync_service.dart';
import 'product_image_provider.dart';

// Provider for the image sync service
final productImageSyncServiceProvider = FutureProvider<ProductImageSyncService>(
  (ref) async {
    final imageService = await ref.watch(productImageServiceProvider.future);
    final imageCacheDb = await ref.watch(imageCacheDatabaseProvider.future);

    // Get local database instance
    final localDb = LocalDatabaseService();
    final db = await localDb.database;

    // Create sync queue service
    final syncQueueService = SyncQueueService();

    // Create product local database
    final productDb = ProductLocalDatabase(
      database: db,
      syncQueueService: syncQueueService,
    );

    return ProductImageSyncService(
      imageService: imageService,
      imageCacheDb: imageCacheDb,
      productDb: productDb,
      localDb: localDb,
    );
  },
);

// State notifier for managing sync status
class ImageSyncStatusNotifier extends StateNotifier<ImageSyncStatus> {
  final ProductImageSyncService? _syncService;

  ImageSyncStatusNotifier(this._syncService) : super(ImageSyncStatus.idle) {
    // Start periodic sync if service is available
    _syncService?.startPeriodicSync(interval: const Duration(seconds: 30));
  }

  Future<void> triggerSync() async {
    if (_syncService == null || state == ImageSyncStatus.syncing) return;

    state = ImageSyncStatus.syncing;
    try {
      await _syncService.syncImagesAndUpdateProducts();
      state = ImageSyncStatus.success;

      // Reset to idle after a short delay
      await Future.delayed(const Duration(seconds: 2));
      state = ImageSyncStatus.idle;
    } catch (e) {
      state = ImageSyncStatus.error;

      // Reset to idle after showing error
      await Future.delayed(const Duration(seconds: 3));
      state = ImageSyncStatus.idle;
    }
  }

  void stopSync() {
    _syncService?.stopPeriodicSync();
  }

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }
}

// Enum for sync status
enum ImageSyncStatus { idle, syncing, success, error }

// Provider for image sync status
final imageSyncStatusProvider =
    StateNotifierProvider<ImageSyncStatusNotifier, ImageSyncStatus>((ref) {
      final syncServiceAsync = ref.watch(productImageSyncServiceProvider);

      return syncServiceAsync.when(
        data: (service) => ImageSyncStatusNotifier(service),
        loading: () => ImageSyncStatusNotifier(null),
        error: (error, stack) => ImageSyncStatusNotifier(null),
      );
    });

// Auto-dispose provider that starts sync when app is running
final autoImageSyncInitProvider = Provider<void>((ref) {
  // Watch the sync status provider to ensure it's initialized
  ref.watch(imageSyncStatusProvider);

  // Clean up when provider is disposed
  ref.onDispose(() {
    ref.read(imageSyncStatusProvider.notifier).stopSync();
  });
});
