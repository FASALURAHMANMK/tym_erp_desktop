import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/bulk_product_upload_service.dart';
import '../services/product_export_service.dart';
import 'product_image_provider.dart';
import 'product_repository_provider.dart';

// Bulk upload service provider
final bulkUploadServiceProvider = FutureProvider<BulkProductUploadService>((ref) async {
  final repository = await ref.watch(productRepositoryFutureProvider.future);
  final imageService = await ref.watch(productImageServiceProvider.future);

  return BulkProductUploadService(
    productRepository: repository,
    imageService: imageService,
  );
});

// Product export service provider
final productExportServiceProvider = FutureProvider<ProductExportService>((ref) async {
  final repository = await ref.watch(productRepositoryFutureProvider.future);
  
  return ProductExportService(
    productRepository: repository,
  );
});

// Progress tracking
class BulkUploadProgress {
  final int processed;
  final int total;
  final String? currentProduct;
  final String? status;

  BulkUploadProgress({
    this.processed = 0,
    this.total = 0,
    this.currentProduct,
    this.status,
  });

  double get percentage => total > 0 ? (processed / total) : 0;

  BulkUploadProgress copyWith({
    int? processed,
    int? total,
    String? currentProduct,
    String? status,
  }) {
    return BulkUploadProgress(
      processed: processed ?? this.processed,
      total: total ?? this.total,
      currentProduct: currentProduct ?? this.currentProduct,
      status: status ?? this.status,
    );
  }
}

// Progress notifier
class BulkUploadProgressNotifier extends StateNotifier<BulkUploadProgress> {
  BulkUploadProgressNotifier() : super(BulkUploadProgress());

  void updateProgress(
    int processed,
    int total, {
    String? currentProduct,
    String? status,
  }) {
    state = state.copyWith(
      processed: processed,
      total: total,
      currentProduct: currentProduct,
      status: status,
    );
  }

  void reset() {
    state = BulkUploadProgress();
  }
}

// Progress provider
final bulkUploadProgressProvider =
    StateNotifierProvider<BulkUploadProgressNotifier, BulkUploadProgress>((
      ref,
    ) {
      return BulkUploadProgressNotifier();
    });
