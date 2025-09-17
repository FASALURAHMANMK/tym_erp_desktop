import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../data/local/product_local_database.dart';
import '../data/repositories/offline_first_product_repository.dart';
import '../domain/repositories/product_repository.dart';

// Product Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ref.watch(productRepositoryInitializerProvider);
});

// Product Repository Initializer Provider (handles async initialization)
final productRepositoryInitializerProvider = Provider<ProductRepository>((ref) {
  final supabase = Supabase.instance.client;
  final localDatabaseService = LocalDatabaseService();
  final logger = Logger('ProductRepository');
  
  // Initialize services synchronously
  final syncQueueService = SyncQueueService();
  
  return localDatabaseService.database.then((database) {
    final productLocalDatabase = ProductLocalDatabase(
      database: database,
      syncQueueService: syncQueueService,
    );
    
    return OfflineFirstProductRepository(
      supabase: supabase,
      localDatabase: productLocalDatabase,
      syncQueueService: syncQueueService,
      logger: logger,
    );
  }) as ProductRepository; // This is a simplified approach
});

// Alternative: Future Provider for proper async handling
final productRepositoryFutureProvider = FutureProvider<ProductRepository>((ref) async {
  final supabase = Supabase.instance.client;
  final localDatabaseService = LocalDatabaseService();
  final logger = Logger('ProductRepository');
  final syncQueueService = SyncQueueService();
  
  final database = await localDatabaseService.database;
  final productLocalDatabase = ProductLocalDatabase(
    database: database,
    syncQueueService: syncQueueService,
  );
  
  return OfflineFirstProductRepository(
    supabase: supabase,
    localDatabase: productLocalDatabase,
    syncQueueService: syncQueueService,
    logger: logger,
  );
});