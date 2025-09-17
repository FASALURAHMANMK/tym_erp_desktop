import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import 'price_category_sync_service.dart';
import 'product_price_sync_service.dart';

/// Background sync manager for all sales-related data
class SalesBackgroundSync {
  static final _logger = Logger('SalesBackgroundSync');
  
  final PriceCategorySyncService _priceCategorySyncService;
  final ProductPriceSyncService _productPriceSyncService;
  final _connectivity = Connectivity();
  
  Timer? _syncTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _connectivityPollTimer;
  bool _isSyncing = false;
  
  SalesBackgroundSync()
      : _priceCategorySyncService = PriceCategorySyncService(),
        _productPriceSyncService = ProductPriceSyncService();
  
  /// Start background sync with periodic timer
  void startPeriodicSync({Duration interval = const Duration(seconds: 30)}) {
    _logger.info('Starting periodic sync for sales data');
    
    // Cancel existing timer if any
    stopPeriodicSync();
    
    // Initialize product price sync service
    _productPriceSyncService.initialize();
    
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
    _productPriceSyncService.dispose();
    _logger.info('Stopped periodic sync for sales data');
  }
  
  /// Perform sync operation for all sales data
  Future<void> _performSync() async {
    if (_isSyncing) {
      _logger.debug('Sync already in progress, skipping');
      return;
    }
    
    _isSyncing = true;
    try {
      // Sync price categories first (since prices depend on them)
      await _priceCategorySyncService.processSyncQueue();
      
      // Then sync product prices
      await _productPriceSyncService.processSyncQueue();
      
      // TODO: Add sync for tables and table areas when implemented
      
    } catch (e) {
      _logger.error('Error during periodic sync', e);
    } finally {
      _isSyncing = false;
    }
  }
  
  /// Manual sync trigger
  Future<void> syncNow() async {
    _logger.info('Manual sync triggered for sales data');
    await _performSync();
  }
  
  /// Download initial sales data for a business
  Future<void> downloadInitialData(String businessId) async {
    try {
      _logger.info('Downloading initial sales data for business: $businessId');
      
      // Price categories are created automatically on business/location creation
      // But we should still sync any pending changes
      await _priceCategorySyncService.syncPendingCategoriesForBusiness(businessId);
      
      // Download product prices from cloud
      await _productPriceSyncService.downloadPricesForBusiness(businessId);
      
      _logger.info('Initial sales data download completed');
    } catch (e) {
      _logger.error('Error downloading initial sales data', e);
    }
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

/// Provider for sales background sync manager
final salesBackgroundSyncProvider = Provider<SalesBackgroundSync>((ref) {
  final sync = SalesBackgroundSync();
  
  // Start periodic sync when provider is created
  sync.startPeriodicSync();
  
  // Stop sync when provider is disposed
  ref.onDispose(() {
    sync.dispose();
  });
  
  return sync;
});
