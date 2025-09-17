import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/local_database_service.dart';
import '../data/local/image_cache_database.dart';
import '../services/product_image_service.dart';

// Local database service instance (singleton)
final _localDatabaseService = LocalDatabaseService();

// Image cache database provider - now async to handle initialization properly
final imageCacheDatabaseProvider = FutureProvider<ImageCacheDatabase>((ref) async {
  final db = await _localDatabaseService.database;
  return ImageCacheDatabase(database: db);
});

// Product image service provider - also async to handle database initialization
final productImageServiceProvider = FutureProvider<ProductImageService>((ref) async {
  final supabase = Supabase.instance.client;
  final cacheDb = await ref.watch(imageCacheDatabaseProvider.future);
  
  return ProductImageService(
    supabase: supabase,
    cacheDb: cacheDb,
  );
});

// Image sync notifier for background sync
class ImageSyncNotifier extends StateNotifier<bool> {
  final ProductImageService? _imageService;
  
  ImageSyncNotifier(this._imageService) : super(false);
  
  Future<void> syncPendingImages() async {
    if (_imageService == null) return; // Service not initialized
    if (state) return; // Already syncing
    
    state = true;
    try {
      await _imageService.syncPendingUploads();
    } finally {
      state = false;
    }
  }
  
  Future<void> cleanupCache() async {
    if (_imageService == null) return; // Service not initialized
    await _imageService.cleanupCache();
  }
}

// Image sync provider - now handles async service initialization
final imageSyncProvider = StateNotifierProvider<ImageSyncNotifier, bool>((ref) {
  final imageServiceAsync = ref.watch(productImageServiceProvider);
  
  // Return a no-op notifier while loading
  return imageServiceAsync.when(
    data: (service) => ImageSyncNotifier(service),
    loading: () => ImageSyncNotifier(null), // Modified to handle null
    error: (error, stack) => ImageSyncNotifier(null),
  );
});

// Product images state for a specific product
class ProductImagesState {
  final String? mainImageUrl;
  final List<String> additionalImageUrls;
  final bool isLoading;
  final String? error;
  
  const ProductImagesState({
    this.mainImageUrl,
    this.additionalImageUrls = const [],
    this.isLoading = false,
    this.error,
  });
  
  ProductImagesState copyWith({
    String? mainImageUrl,
    List<String>? additionalImageUrls,
    bool? isLoading,
    String? error,
  }) {
    return ProductImagesState(
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      additionalImageUrls: additionalImageUrls ?? this.additionalImageUrls,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Product images notifier
class ProductImagesNotifier extends StateNotifier<ProductImagesState> {
  final String productId;
  final ImageCacheDatabase? _cacheDb;
  
  ProductImagesNotifier({
    required this.productId,
    required ImageCacheDatabase cacheDb,
  }) : _cacheDb = cacheDb,
       super(const ProductImagesState(isLoading: true)) {
    _loadImages();
  }
  
  // Constructor for loading state
  ProductImagesNotifier.loading(this.productId)
      : _cacheDb = null,
        super(const ProductImagesState(isLoading: true));
  
  // Constructor for error state
  ProductImagesNotifier.error(this.productId, String errorMessage)
      : _cacheDb = null,
        super(ProductImagesState(isLoading: false, error: errorMessage));
  
  Future<void> _loadImages() async {
    if (_cacheDb == null) {
      state = const ProductImagesState(
        isLoading: false,
        error: 'Database not initialized',
      );
      return;
    }
    
    try {
      final images = await _cacheDb.getProductImages(productId);
      
      String? mainImage;
      List<String> additionalImages = [];
      
      for (final image in images) {
        final url = image['remote_url'] ?? image['local_path'];
        if (image['image_type'] == 'main') {
          mainImage = url;
        } else {
          additionalImages.add(url);
        }
      }
      
      state = ProductImagesState(
        mainImageUrl: mainImage,
        additionalImageUrls: additionalImages,
        isLoading: false,
      );
    } catch (e) {
      state = ProductImagesState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  void updateMainImage(String? imageUrl) {
    state = state.copyWith(mainImageUrl: imageUrl);
  }
  
  void updateAdditionalImages(List<String> imageUrls) {
    state = state.copyWith(additionalImageUrls: imageUrls);
  }
  
  void addAdditionalImage(String imageUrl) {
    final updatedList = [...state.additionalImageUrls, imageUrl];
    state = state.copyWith(additionalImageUrls: updatedList);
  }
  
  void removeAdditionalImage(int index) {
    if (index < 0 || index >= state.additionalImageUrls.length) return;
    
    final updatedList = [...state.additionalImageUrls];
    updatedList.removeAt(index);
    state = state.copyWith(additionalImageUrls: updatedList);
  }
  
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadImages();
  }
}

// Product images provider family - now handles async database initialization
final productImagesProvider = StateNotifierProvider.family<
  ProductImagesNotifier,
  ProductImagesState,
  String
>((ref, productId) {
  final cacheDbAsync = ref.watch(imageCacheDatabaseProvider);
  
  // Return a loading state while database initializes
  return cacheDbAsync.when(
    data: (cacheDb) => ProductImagesNotifier(
      productId: productId,
      cacheDb: cacheDb,
    ),
    loading: () => ProductImagesNotifier.loading(productId),
    error: (error, stack) => ProductImagesNotifier.error(productId, error.toString()),
  );
});

// Image cache stats provider - now handles async database properly
final imageCacheStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final cacheDb = await ref.watch(imageCacheDatabaseProvider.future);
  return await cacheDb.getCacheStats();
});

// Auto sync provider - triggers sync when network is available
final autoImageSyncProvider = Provider<void>((ref) {
  // Listen to connectivity changes
  ref.listen<AsyncValue<bool>>(connectivityProvider, (previous, next) {
    next.whenData((isOnline) async {
      if (isOnline) {
        // Trigger sync when coming online
        final syncNotifier = ref.read(imageSyncProvider.notifier);
        await syncNotifier.syncPendingImages();
      }
    });
  });
});

// Connectivity provider (placeholder - you should implement this with connectivity_plus)
final connectivityProvider = StreamProvider<bool>((ref) async* {
  // This is a simplified version
  // In production, use connectivity_plus package to monitor real connectivity
  yield true; // Assume online for now
  
  // Example with connectivity_plus:
  // final connectivity = Connectivity();
  // await for (final result in connectivity.onConnectivityChanged) {
  //   yield result != ConnectivityResult.none;
  // }
});