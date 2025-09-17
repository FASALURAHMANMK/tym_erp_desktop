import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import 'price_category_sync_service.dart';

/// Background sync manager for price categories
class PriceCategoryBackgroundSync {
  static final _logger = Logger('PriceCategoryBackgroundSync');
  
  final PriceCategorySyncService _syncService;
  final _connectivity = Connectivity();
  
  Timer? _syncTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _connectivityPollTimer;
  bool _isSyncing = false;
  
  PriceCategoryBackgroundSync()
      : _syncService = PriceCategorySyncService();
  
  /// Start background sync with periodic timer
  void startPeriodicSync({Duration interval = const Duration(seconds: 30)}) {
    _logger.info('Starting periodic sync for price categories');
    
    // Cancel existing timer if any
    stopPeriodicSync();
    
    // Set up periodic sync
    _syncTimer = Timer.periodic(interval, (_) {
      _performSync();
    });
    
    // Use polling-only to avoid platform stream issues
    _startConnectivityPolling();
    
    // Perform initial sync
    _performSync();
  }
  
  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _connectivityPollTimer?.cancel();
    _connectivityPollTimer = null;
    _logger.info('Stopped periodic sync for price categories');
  }
  
  /// Perform sync operation
  Future<void> _performSync() async {
    if (_isSyncing) {
      _logger.debug('Sync already in progress, skipping');
      return;
    }
    
    _isSyncing = true;
    try {
      await _syncService.processSyncQueue();
    } catch (e) {
      _logger.error('Error during periodic sync', e);
    } finally {
      _isSyncing = false;
    }
  }
  
  /// Manual sync trigger
  Future<void> syncNow() async {
    _logger.info('Manual sync triggered for price categories');
    await _performSync();
  }
  
  /// Dispose resources
  void dispose() {
    stopPeriodicSync();
  }

  void _startConnectivityPolling() {
    _connectivityPollTimer?.cancel();
    _connectivityPollTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      try {
        final results = await _connectivity.checkConnectivity();
        if (!results.contains(ConnectivityResult.none)) {
          _performSync();
        }
      } catch (_) {}
    });
  }
}

/// Provider for background sync manager
final priceCategoryBackgroundSyncProvider = Provider<PriceCategoryBackgroundSync>((ref) {
  final sync = PriceCategoryBackgroundSync();
  
  // Start periodic sync when provider is created
  sync.startPeriodicSync();
  
  // Stop sync when provider is disposed
  ref.onDispose(() {
    sync.dispose();
  });
  
  return sync;
});

/// Auto-start background sync provider
/// Add this to main providers that should always be active
final priceCategoryAutoSyncProvider = Provider<void>((ref) {
  // Just watch the background sync provider to keep it alive
  ref.watch(priceCategoryBackgroundSyncProvider);
});
