import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sync_service.dart';
import '../services/data_seeding_service.dart';
import '../features/business/providers/business_provider.dart';
import '../core/utils/logger.dart';

/// Provider to track data seeding state and determine if initial download is needed
final dataSeedingStateProvider = StateNotifierProvider<DataSeedingStateNotifier, DataSeedingState>((ref) {
  return DataSeedingStateNotifier(ref);
});

/// State for data seeding
class DataSeedingState {
  final bool isSeeding;
  final bool needsInitialDownload;
  final DataSeedingProgress? progress;
  final String? error;

  DataSeedingState({
    this.isSeeding = false,
    this.needsInitialDownload = false,
    this.progress,
    this.error,
  });

  DataSeedingState copyWith({
    bool? isSeeding,
    bool? needsInitialDownload,
    DataSeedingProgress? progress,
    String? error,
  }) {
    return DataSeedingState(
      isSeeding: isSeeding ?? this.isSeeding,
      needsInitialDownload: needsInitialDownload ?? this.needsInitialDownload,
      progress: progress ?? this.progress,
      error: error,
    );
  }
}

/// State notifier for data seeding
class DataSeedingStateNotifier extends StateNotifier<DataSeedingState> {
  static final _logger = Logger('DataSeedingStateNotifier');
  final Ref _ref;
  
  DataSeedingStateNotifier(this._ref) : super(DataSeedingState());

  /// Check if initial download is needed for the current business
  Future<bool> checkIfInitialDownloadNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedBusiness = _ref.read(selectedBusinessProvider);
      
      if (selectedBusiness == null) {
        return false;
      }
      
      // Check if we've already downloaded data for this business
      final key = 'data_seeded_${selectedBusiness.id}';
      final hasSeededData = prefs.getBool(key) ?? false;
      
      // Also check if we have any local data
      final hasLocalData = await _checkLocalDataExists(selectedBusiness.id);
      
      final needsDownload = !hasSeededData || !hasLocalData;
      
      state = state.copyWith(needsInitialDownload: needsDownload);
      
      return needsDownload;
    } catch (e) {
      _logger.error('Error checking if initial download needed', e);
      return false;
    }
  }
  
  /// Check if local data exists for the business
  Future<bool> _checkLocalDataExists(String businessId) async {
    try {
      // TODO: Check if we have locations, products, etc. in local database
      // For now, return false to always trigger download on first login
      return false;
    } catch (e) {
      _logger.error('Error checking local data', e);
      return false;
    }
  }
  
  /// Start the data seeding process
  Future<void> startDataSeeding() async {
    final selectedBusiness = _ref.read(selectedBusinessProvider);
    if (selectedBusiness == null) {
      _logger.warning('No business selected for data seeding');
      return;
    }
    
    state = state.copyWith(isSeeding: true, error: null);
    
    try {
      final syncService = _ref.read(syncServiceProvider);
      
      // Listen to progress updates
      syncService.dataSeedingProgress?.listen((progress) {
        state = state.copyWith(progress: progress);
        
        if (progress.isComplete) {
          _onSeedingComplete(selectedBusiness.id);
        }
        
        if (progress.error != null) {
          state = state.copyWith(
            error: progress.error,
            isSeeding: false,
          );
        }
      });
      
      // Start the download
      await syncService.downloadInitialData();
      
    } catch (e) {
      _logger.error('Data seeding failed', e);
      state = state.copyWith(
        isSeeding: false,
        error: e.toString(),
      );
    }
  }
  
  /// Mark seeding as complete for the business
  Future<void> _onSeedingComplete(String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'data_seeded_$businessId';
      await prefs.setBool(key, true);
      
      state = state.copyWith(
        isSeeding: false,
        needsInitialDownload: false,
      );
      
      _logger.info('Data seeding marked as complete for business: $businessId');
    } catch (e) {
      _logger.error('Failed to mark seeding as complete', e);
    }
  }
  
  /// Reset the seeding state for a business (useful for force refresh)
  Future<void> resetSeedingState(String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'data_seeded_$businessId';
      await prefs.remove(key);
      
      state = state.copyWith(needsInitialDownload: true);
      
      _logger.info('Reset seeding state for business: $businessId');
    } catch (e) {
      _logger.error('Failed to reset seeding state', e);
    }
  }
}