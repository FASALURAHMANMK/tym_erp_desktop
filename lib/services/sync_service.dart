import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/logger.dart';
import '../features/business/models/business_model.dart';
import '../features/business/providers/business_provider.dart';
import '../features/products/providers/product_repository_provider.dart';
import 'sync_queue_service.dart';
import 'generic_sync_processor.dart';
import 'data_seeding_service.dart';
import 'local_database_service.dart';

part 'sync_service.g.dart';

/// Comprehensive sync service that handles:
/// - Auto-sync when online
/// - Manual sync triggers
/// - Initial data download
/// - Real-time listeners
/// - Network connectivity monitoring
class SyncService {
  final SupabaseClient _supabase;
  final SyncQueueService _syncQueueService;
  final Connectivity _connectivity;
  final Logger _logger;
  final Ref _ref;
  late final DataSeedingService _dataSeedingService;

  Timer? _syncTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _realtimeSubscription;
  Timer? _connectivityPollTimer;
  
  bool _isSyncing = false;
  bool _isOnline = false;
  DateTime? _lastSyncTime;
  
  // Progress stream for data seeding
  Stream<DataSeedingProgress>? get dataSeedingProgress => _dataSeedingService.progressStream;

  SyncService({
    required SupabaseClient supabase,
    required SyncQueueService syncQueueService,
    required Connectivity connectivity,
    required Logger logger,
    required Ref ref,
  })  : _supabase = supabase,
        _syncQueueService = syncQueueService,
        _connectivity = connectivity,
        _logger = logger,
        _ref = ref {
    // Initialize data seeding service
    _dataSeedingService = DataSeedingService(
      supabase: _supabase,
      localDb: LocalDatabaseService(),
    );
  }

  /// Initialize sync service and start monitoring
  Future<void> initialize() async {
    _logger.info('Initializing sync service');

    // Check initial connectivity
    await _checkConnectivity();

    // Start monitoring connectivity changes with graceful fallback
    await _startConnectivityMonitoring();

    // Start periodic sync timer (every 30 seconds when online)
    _startSyncTimer();

    // Set up real-time listeners for the current business
    await _setupRealtimeListeners();
  }

  Future<void> _startConnectivityMonitoring() async {
    // Avoid platform stream issues by using polling only
    await _startConnectivityPolling();
  }

  Future<void> _startConnectivityPolling() async {
    _connectivityPollTimer?.cancel();
    _connectivityPollTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      try {
        final results = await _connectivity.checkConnectivity();
        final online = results.any((result) =>
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet);
        if (online != _isOnline) {
          final wasOnline = _isOnline;
          _isOnline = online;
          _logger.info('Connectivity (polled) changed: $_isOnline');
          if (!wasOnline && _isOnline) {
            await performSync();
          }
        }
      } catch (e) {
        // Polling failed; ignore and try next tick
      }
    });
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline = results.any((result) => 
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet
    );
  }

  /// Start periodic sync timer
  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_isOnline && !_isSyncing) {
        await performSync();
      }
    });
  }

  /// Set up real-time listeners for current business
  Future<void> _setupRealtimeListeners() async {
    final selectedBusiness = _ref.read(selectedBusinessProvider);
    if (selectedBusiness == null) return;

    _logger.info('Setting up real-time listeners for business: ${selectedBusiness.id}');

    // Cancel existing subscription
    await _realtimeSubscription?.cancel();

    // Listen to product-related changes
    _realtimeSubscription = _supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('business_id', selectedBusiness.id)
        .listen((data) async {
          _logger.info('Real-time product update received');
          await _handleRealtimeUpdate('products', data);
        });

    // Note: For multiple tables, you'd need separate subscriptions
    // Supabase currently doesn't support listening to multiple tables in one subscription
  }

  /// Handle real-time updates from Supabase
  Future<void> _handleRealtimeUpdate(String tableName, List<Map<String, dynamic>> data) async {
    try {
      _logger.info('Processing real-time update for $tableName');
      
      // Get the appropriate repository and trigger refresh
      switch (tableName) {
        case 'products':
          // Trigger a refresh of local data
          // This would need to be implemented in the repository
          // For now, we rely on the providers to refresh their data
          break;
        // Add other cases as needed
      }
    } catch (e) {
      _logger.error('Error handling real-time update', e);
    }
  }

  /// Perform a full sync operation
  Future<SyncResult> performSync() async {
    if (_isSyncing) {
      _logger.info('Sync already in progress, skipping');
      return SyncResult(success: false, message: 'Sync already in progress');
    }

    if (!_isOnline) {
      _logger.info('No internet connection, skipping sync');
      return SyncResult(success: false, message: 'No internet connection');
    }

    _isSyncing = true;
    _logger.info('Starting sync operation');

    try {
      final selectedBusiness = _ref.read(selectedBusinessProvider);
      if (selectedBusiness == null) {
        return SyncResult(success: false, message: 'No business selected');
      }

      // 1. Upload pending changes
      await _uploadPendingChanges();

      // 2. Download latest data from cloud
      await _downloadLatestData(selectedBusiness);

      _lastSyncTime = DateTime.now();
      _logger.info('Sync completed successfully');

      return SyncResult(
        success: true, 
        message: 'Sync completed',
        syncedAt: _lastSyncTime,
      );
    } catch (e) {
      _logger.error('Sync failed', e);
      return SyncResult(
        success: false, 
        message: 'Sync failed: ${e.toString()}',
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Upload all pending changes from sync queue
  Future<void> _uploadPendingChanges() async {
    _logger.info('Uploading pending changes');

    try {
      // First, sync product-related changes through the repository
      // (This handles product-specific logic like variations & cleanup)
      try {
        final productRepo = await _ref.read(productRepositoryFutureProvider.future);
        final productSyncResult = await productRepo.syncPendingChanges();
        productSyncResult.fold(
          (failure) => _logger.error('Product sync failed: ${failure.message}'),
          (_) => _logger.info('Product sync completed'),
        );
      } catch (e) {
        _logger.error('Product sync error', e);
        // Continue even if product sync fails
      }

      // Then, use the generic sync processor to handle remaining tables in queue
      // This includes business_locations, pos_devices, prices, etc.
      final genericProcessor = GenericSyncProcessor();
      await genericProcessor.processSyncQueue();
      _logger.info('Generic sync queue processing completed');
    } catch (e) {
      _logger.error('Error during upload', e);
      rethrow;
    }
  }

  /// Download latest data from cloud - Now comprehensive!
  Future<void> _downloadLatestData(BusinessModel business) async {
    _logger.info('Starting comprehensive data download for business: ${business.id}');

    try {
      // Use the comprehensive data seeding service
      await _dataSeedingService.seedBusinessData(business);
      
      _logger.info('Comprehensive data download completed successfully');
    } catch (e) {
      _logger.error('Error during comprehensive download', e);
      // Don't rethrow - app should work offline even if download fails
      // Individual providers will still attempt lazy loading as fallback
    }
  }

  /// Download initial data when user logs in
  Future<void> downloadInitialData() async {
    _logger.info('Downloading initial data after login');

    final selectedBusiness = _ref.read(selectedBusinessProvider);
    if (selectedBusiness == null) {
      _logger.warning('No business selected for initial download');
      return;
    }

    try {
      await _downloadLatestData(selectedBusiness);
      _logger.info('Initial data download completed');
    } catch (e) {
      _logger.error('Initial data download failed', e);
      // Don't throw - app should work offline
    }
  }

  /// Get current sync status
  SyncStatus get status => SyncStatus(
    isOnline: _isOnline,
    isSyncing: _isSyncing,
    lastSyncTime: _lastSyncTime,
    pendingChangesCount: _syncQueueService.getPendingCount(),
  );

  /// Dispose of resources
  void dispose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    _realtimeSubscription?.cancel();
    _connectivityPollTimer?.cancel();
    _dataSeedingService.dispose();
  }
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String message;
  final DateTime? syncedAt;

  SyncResult({
    required this.success,
    required this.message,
    this.syncedAt,
  });
}

/// Current sync status
class SyncStatus {
  final bool isOnline;
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final Future<int> pendingChangesCount;

  SyncStatus({
    required this.isOnline,
    required this.isSyncing,
    this.lastSyncTime,
    required this.pendingChangesCount,
  });
}

/// Provider for sync service
@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) {
  final supabase = Supabase.instance.client;
  final syncQueueService = ref.watch(syncQueueServiceProvider);
  
  final service = SyncService(
    supabase: supabase,
    syncQueueService: syncQueueService,
    connectivity: Connectivity(),
    logger: Logger('SyncService'),
    ref: ref,
  );

  // Initialize the service
  service.initialize();

  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
}

/// Provider for sync status stream
@riverpod
Stream<SyncStatus> syncStatus(Ref ref) {
  final service = ref.watch(syncServiceProvider);
  
  // Create a stream that emits status updates
  return Stream.periodic(const Duration(seconds: 1), (_) {
    return service.status;
  });
}

/// Provider for manual sync trigger
@riverpod
Future<SyncResult> performManualSync(Ref ref) async {
  final service = ref.watch(syncServiceProvider);
  return service.performSync();
}
