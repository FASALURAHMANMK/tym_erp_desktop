import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business_subscription.dart';
import '../models/subscription_plan.dart';
import '../../../core/utils/logger.dart';

class SubscriptionPersistenceService {
  static final _logger = Logger('SubscriptionPersistenceService');
  
  static const String _cachedSubscriptionKey = 'cached_subscription';
  static const String _cachedPlansKey = 'cached_subscription_plans';
  static const String _lastSyncKey = 'subscription_last_sync_timestamp';

  // ========== SUBSCRIPTION CACHING ==========

  /// Cache business subscription for offline access
  static Future<void> cacheBusinessSubscription(
    String businessId, 
    BusinessSubscription subscription
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionJson = subscription.toJson();
      await prefs.setString('${_cachedSubscriptionKey}_$businessId', jsonEncode(subscriptionJson));
      await prefs.setInt('${_lastSyncKey}_$businessId', DateTime.now().millisecondsSinceEpoch);
      _logger.info('Cached subscription for business $businessId: ${subscription.status.name}');
    } catch (e) {
      _logger.error('Failed to cache subscription', e);
    }
  }

  /// Get cached business subscription for offline access
  static Future<BusinessSubscription?> getCachedBusinessSubscription(String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('${_cachedSubscriptionKey}_$businessId');
      
      if (cachedData != null) {
        final Map<String, dynamic> subscriptionJson = jsonDecode(cachedData);
        final subscription = BusinessSubscription.fromJson(subscriptionJson);
        _logger.info('Retrieved cached subscription for business $businessId: ${subscription.status.name}');
        return subscription;
      }
      
      _logger.info('No cached subscription found for business $businessId');
      return null;
    } catch (e) {
      _logger.error('Failed to get cached subscription', e);
      return null;
    }
  }

  /// Check if business has cached subscription
  static Future<bool> hasCachedSubscription(String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('${_cachedSubscriptionKey}_$businessId');
    } catch (e) {
      _logger.error('Failed to check cached subscription', e);
      return false;
    }
  }

  /// Clear cached subscription for a business
  static Future<void> clearCachedSubscription(String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_cachedSubscriptionKey}_$businessId');
      await prefs.remove('${_lastSyncKey}_$businessId');
      _logger.info('Cleared cached subscription for business $businessId');
    } catch (e) {
      _logger.error('Failed to clear cached subscription', e);
    }
  }

  // ========== SUBSCRIPTION PLANS CACHING ==========

  /// Cache subscription plans for offline access
  static Future<void> cacheSubscriptionPlans(List<SubscriptionPlan> plans) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final plansJson = plans.map((plan) => plan.toJson()).toList();
      await prefs.setString(_cachedPlansKey, jsonEncode(plansJson));
      await prefs.setInt('${_lastSyncKey}_plans', DateTime.now().millisecondsSinceEpoch);
      _logger.info('Cached ${plans.length} subscription plans for offline access');
    } catch (e) {
      _logger.error('Failed to cache subscription plans', e);
    }
  }

  /// Get cached subscription plans for offline access
  static Future<List<SubscriptionPlan>> getCachedSubscriptionPlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cachedPlansKey);
      
      if (cachedData != null) {
        final List<dynamic> plansJson = jsonDecode(cachedData);
        final plans = plansJson
            .map((json) => SubscriptionPlan.fromJson(json as Map<String, dynamic>))
            .toList();
        _logger.info('Retrieved ${plans.length} cached subscription plans for offline access');
        return plans;
      }
      
      _logger.info('No cached subscription plans found');
      return [];
    } catch (e) {
      _logger.error('Failed to get cached subscription plans', e);
      return [];
    }
  }

  /// Check if subscription plans are cached
  static Future<bool> hasCachedPlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cachedPlansKey);
    } catch (e) {
      _logger.error('Failed to check cached plans', e);
      return false;
    }
  }

  /// Clear cached subscription plans
  static Future<void> clearCachedPlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cachedPlansKey);
      await prefs.remove('${_lastSyncKey}_plans');
      _logger.info('Cleared cached subscription plans');
    } catch (e) {
      _logger.error('Failed to clear cached plans', e);
    }
  }

  // ========== CACHE MANAGEMENT ==========

  /// Get last sync timestamp for subscription data
  static Future<DateTime?> getLastSyncTime(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('${_lastSyncKey}_$key');
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      _logger.error('Failed to get last sync time', e);
      return null;
    }
  }

  /// Check if cached subscription data is stale (older than specified hours)
  static Future<bool> isSubscriptionDataStale(String businessId, {int staleAfterHours = 24}) async {
    final lastSync = await getLastSyncTime(businessId);
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    return difference.inHours > staleAfterHours;
  }

  /// Check if cached plans data is stale
  static Future<bool> isPlansDataStale({int staleAfterHours = 24}) async {
    final lastSync = await getLastSyncTime('plans');
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    return difference.inHours > staleAfterHours;
  }

  /// Clear all subscription cache data
  static Future<void> clearAllSubscriptionCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => 
        key.startsWith(_cachedSubscriptionKey) || 
        key.startsWith(_cachedPlansKey) ||
        key.startsWith('${_lastSyncKey}_')
      ).toList();
      
      for (final key in keys) {
        await prefs.remove(key);
      }
      _logger.info('Cleared all subscription cache data');
    } catch (e) {
      _logger.error('Failed to clear all subscription cache', e);
    }
  }

  /// Cache subscription summary for quick access
  static Future<void> cacheSubscriptionSummary(
    String businessId, 
    Map<String, dynamic> summary
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('subscription_summary_$businessId', jsonEncode(summary));
      _logger.info('Cached subscription summary for business $businessId');
    } catch (e) {
      _logger.error('Failed to cache subscription summary', e);
    }
  }

  /// Get cached subscription summary
  static Future<Map<String, dynamic>?> getCachedSubscriptionSummary(String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('subscription_summary_$businessId');
      
      if (cachedData != null) {
        final summary = jsonDecode(cachedData) as Map<String, dynamic>;
        _logger.info('Retrieved cached subscription summary for business $businessId');
        return summary;
      }
      
      return null;
    } catch (e) {
      _logger.error('Failed to get cached subscription summary', e);
      return null;
    }
  }

  /// Clear cached subscription summary
  static Future<void> clearCachedSubscriptionSummary(String businessId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('subscription_summary_$businessId');
      _logger.info('Cleared cached subscription summary for business $businessId');
    } catch (e) {
      _logger.error('Failed to clear cached subscription summary', e);
    }
  }

  // ========== USER-SPECIFIC CACHE MANAGEMENT ==========

  /// Clear all subscription cache for a specific user (on logout)
  static Future<void> clearUserSubscriptionCache(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get all keys related to subscription cache
      final keys = prefs.getKeys().where((key) => 
        key.startsWith(_cachedSubscriptionKey) || 
        key.startsWith('subscription_summary_') ||
        key.startsWith('${_lastSyncKey}_')
      ).toList();
      
      // Clear subscription-related cache for user's businesses
      for (final key in keys) {
        if (key != _cachedPlansKey && key != '${_lastSyncKey}_plans') {
          await prefs.remove(key);
        }
      }
      
      _logger.info('Cleared subscription cache for user $userId');
    } catch (e) {
      _logger.error('Failed to clear user subscription cache', e);
    }
  }

  /// Check if we have any cached subscription data for offline access
  static Future<bool> hasAnySubscriptionCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      return keys.any((key) => 
        key.startsWith(_cachedSubscriptionKey) || 
        key.startsWith('subscription_summary_')
      );
    } catch (e) {
      _logger.error('Failed to check subscription cache', e);
      return false;
    }
  }
}