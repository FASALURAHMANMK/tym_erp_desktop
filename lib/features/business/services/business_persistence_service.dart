import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business_model.dart';
import '../../../core/utils/logger.dart';

class BusinessPersistenceService {
  static final _logger = Logger('BusinessPersistenceService');
  static const String _selectedBusinessKey = 'selected_business_id';
  static const String _selectedBusinessDataKey = 'selected_business_data';
  static const String _cachedBusinessesKey = 'cached_businesses';
  static const String _lastSyncKey = 'last_sync_timestamp';

  /// Save the selected business ID and data to persistent storage
  static Future<void> saveSelectedBusiness(BusinessModel business) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedBusinessKey, business.id);
      await prefs.setString(_selectedBusinessDataKey, business.toJson().toString());
    } catch (e) {
      // Log error but don't throw - persistence failure shouldn't break the app
      _logger.error('Failed to save selected business', e);
    }
  }

  /// Get the saved selected business ID
  static Future<String?> getSelectedBusinessId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_selectedBusinessKey);
    } catch (e) {
      _logger.error('Failed to get selected business ID', e);
      return null;
    }
  }

  /// Clear the saved selected business (on sign out or business change)
  static Future<void> clearSelectedBusiness() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_selectedBusinessKey);
      await prefs.remove(_selectedBusinessDataKey);
    } catch (e) {
      _logger.error('Failed to clear selected business', e);
    }
  }

  /// Check if user has a persisted selected business
  static Future<bool> hasSelectedBusiness() async {
    final businessId = await getSelectedBusinessId();
    return businessId != null && businessId.isNotEmpty;
  }

  /// Save user's last selected business for a specific user
  /// This ensures each user has their own persisted business selection
  static Future<void> saveUserSelectedBusiness(String userId, BusinessModel business) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_selectedBusinessKey}_$userId', business.id);
      await prefs.setString('${_selectedBusinessDataKey}_$userId', business.toJson().toString());
    } catch (e) {
      _logger.error('Failed to save user selected business', e);
    }
  }

  /// Get user's last selected business ID
  static Future<String?> getUserSelectedBusinessId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('${_selectedBusinessKey}_$userId');
    } catch (e) {
      _logger.error('Failed to get user selected business ID', e);
      return null;
    }
  }

  /// Clear user's selected business
  static Future<void> clearUserSelectedBusiness(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_selectedBusinessKey}_$userId');
      await prefs.remove('${_selectedBusinessDataKey}_$userId');
    } catch (e) {
      _logger.error('Failed to clear user selected business', e);
    }
  }

  /// Clear all business preferences (useful for complete reset)
  static Future<void> clearAllBusinessPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => 
        key.startsWith(_selectedBusinessKey) || 
        key.startsWith(_selectedBusinessDataKey) ||
        key.startsWith(_cachedBusinessesKey) ||
        key.startsWith(_lastSyncKey)
      ).toList();
      
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      _logger.error('Failed to clear all business preferences', e);
    }
  }

  // ========== OFFLINE BUSINESS CACHING ==========

  /// Cache user's businesses for offline access
  static Future<void> cacheUserBusinesses(String userId, List<BusinessModel> businesses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final businessesJson = businesses.map((business) => business.toJson()).toList();
      await prefs.setString('${_cachedBusinessesKey}_$userId', jsonEncode(businessesJson));
      await prefs.setInt('${_lastSyncKey}_$userId', DateTime.now().millisecondsSinceEpoch);
      _logger.info('Cached ${businesses.length} businesses for offline access');
    } catch (e) {
      _logger.error('Failed to cache businesses', e);
    }
  }

  /// Get cached businesses for offline access
  static Future<List<BusinessModel>> getCachedUserBusinesses(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('${_cachedBusinessesKey}_$userId');
      
      if (cachedData != null) {
        final List<dynamic> businessesJson = jsonDecode(cachedData);
        final businesses = businessesJson
            .map((json) => BusinessModel.fromJson(json as Map<String, dynamic>))
            .toList();
        _logger.info('Retrieved ${businesses.length} cached businesses for offline access');
        return businesses;
      }
      
      _logger.info('No cached businesses found for user $userId');
      return [];
    } catch (e) {
      _logger.error('Failed to get cached businesses', e);
      return [];
    }
  }

  /// Check if user has cached businesses
  static Future<bool> hasCachedBusinesses(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('${_cachedBusinessesKey}_$userId');
    } catch (e) {
      _logger.error('Failed to check cached businesses', e);
      return false;
    }
  }

  /// Get last sync timestamp for cached data
  static Future<DateTime?> getLastSyncTime(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('${_lastSyncKey}_$userId');
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      _logger.error('Failed to get last sync time', e);
      return null;
    }
  }

  /// Clear cached businesses for a user
  static Future<void> clearCachedBusinesses(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_cachedBusinessesKey}_$userId');
      await prefs.remove('${_lastSyncKey}_$userId');
      _logger.info('Cleared cached businesses for user $userId');
    } catch (e) {
      _logger.error('Failed to clear cached businesses', e);
    }
  }

  /// Check if cached data is stale (older than specified hours)
  static Future<bool> isCachedDataStale(String userId, {int staleAfterHours = 24}) async {
    final lastSync = await getLastSyncTime(userId);
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    return difference.inHours > staleAfterHours;
  }
}