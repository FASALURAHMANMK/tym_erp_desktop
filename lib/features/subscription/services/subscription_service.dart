import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/subscription_plan.dart';
import '../models/business_subscription.dart';
import '../models/subscription_payment.dart';
import '../../business/models/business_model.dart';
import 'subscription_persistence_service.dart';
import '../../../core/utils/logger.dart';

class SubscriptionService {
  static final _logger = Logger('SubscriptionService');
  
  final SupabaseClient _supabase = Supabase.instance.client;
  
  static const int trialDays = 14; // 14 days trial period

  // Get all subscription plans with offline caching support
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      // Try to fetch from database first (online)
      final response = await _supabase
          .from('subscription_plans')
          .select()
          .eq('is_active', true)
          .order('duration_months');

      final plans = (response as List<dynamic>)
          .map((json) => SubscriptionPlan.fromJson(json))
          .toList();

      // If no plans exist, create default ones
      if (plans.isEmpty) {
        _logger.info('No subscription plans found, creating default plans...');
        await _createDefaultPlans();
        return await getSubscriptionPlans(); // Retry after creating plans
      }

      // Cache plans for offline access
      await SubscriptionPersistenceService.cacheSubscriptionPlans(plans);
      _logger.info('Fetched ${plans.length} subscription plans online and cached them');

      return plans;
    } catch (e) {
      _logger.error('Error fetching subscription plans online', e);
      _logger.info('Attempting to load cached subscription plans for offline access...');
      
      // Try to get cached plans first
      final cachedPlans = await SubscriptionPersistenceService.getCachedSubscriptionPlans();
      if (cachedPlans.isNotEmpty) {
        _logger.info('Loaded ${cachedPlans.length} subscription plans from offline cache');
        return cachedPlans;
      }
      
      // Fall back to default plans if no cache available
      _logger.info('No cached plans available, using default offline plans');
      return _getDefaultPlansOffline();
    }
  }

  // Create default subscription plans if they don't exist
  Future<void> _createDefaultPlans() async {
    try {
      final defaultPlans = [
        {
          'name': 'monthly',
          'duration_months': 1,
          'price_inr': 500.00,
          'price_sar': 50.00,
          'price_aed': 50.00,
          'features': {
            'max_users': 5,
            'max_transactions_per_month': 1000,
            'storage_gb': 1,
            'features': ['billing', 'inventory', 'basic_reports', 'customer_management']
          },
          'is_active': true,
        },
        {
          'name': 'yearly',
          'duration_months': 12,
          'price_inr': 5000.00,
          'price_sar': 500.00,
          'price_aed': 500.00,
          'features': {
            'max_users': 5,
            'max_transactions_per_month': 12000,
            'storage_gb': 10,
            'features': ['billing', 'inventory', 'advanced_reports', 'customer_management', 'analytics', 'multi_location']
          },
          'is_active': true,
        }
      ];

      await _supabase.from('subscription_plans').insert(defaultPlans);
      _logger.info('Default subscription plans created successfully');
    } catch (e) {
      _logger.error('Error creating default plans', e);
      // Continue without throwing error
    }
  }

  // Get offline default plans if database is not available
  List<SubscriptionPlan> _getDefaultPlansOffline() {
    final now = DateTime.now();
    return [
      SubscriptionPlan(
        id: 'offline-monthly',
        name: 'monthly',
        durationMonths: 1,
        priceInr: 500.00,
        priceSar: 50.00,
        priceAed: 50.00,
        features: const {
          'max_users': 5,
          'max_transactions_per_month': 1000,
          'storage_gb': 1,
          'features': ['billing', 'inventory', 'basic_reports', 'customer_management']
        },
        isActive: true,
        createdAt: now,
      ),
      SubscriptionPlan(
        id: 'offline-yearly',
        name: 'yearly',
        durationMonths: 12,
        priceInr: 5000.00,
        priceSar: 500.00,
        priceAed: 500.00,
        features: const {
          'max_users': 5,
          'max_transactions_per_month': 12000,
          'storage_gb': 10,
          'features': ['billing', 'inventory', 'advanced_reports', 'customer_management', 'analytics', 'multi_location']
        },
        isActive: true,
        createdAt: now,
      ),
    ];
  }

  // Get business subscription status with offline caching support
  Future<BusinessSubscription?> getBusinessSubscription(String businessId) async {
    try {
      // Try to fetch from database first (online)
      final response = await _supabase
          .from('business_subscriptions')
          .select()
          .eq('business_id', businessId)
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      final subscription = BusinessSubscription.fromJson(response);
      
      // Cache subscription for offline access
      await SubscriptionPersistenceService.cacheBusinessSubscription(businessId, subscription);
      _logger.info('Fetched subscription for business $businessId online and cached it');
      
      return subscription;
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        // No subscription found - check cache for any previously cached subscription
        _logger.info('No subscription found online for business $businessId, checking cache...');
        final cachedSubscription = await SubscriptionPersistenceService.getCachedBusinessSubscription(businessId);
        return cachedSubscription;
      }
      
      _logger.error('Error fetching business subscription online', e);
      _logger.info('Attempting to load cached subscription for offline access...');
      
      // Try to get cached subscription
      final cachedSubscription = await SubscriptionPersistenceService.getCachedBusinessSubscription(businessId);
      if (cachedSubscription != null) {
        _logger.info('Loaded cached subscription for business $businessId: ${cachedSubscription.status.name}');
        return cachedSubscription;
      }
      
      // If no cache available, return null (no subscription)
      _logger.info('No cached subscription available for business $businessId');
      return null;
    }
  }

  // Create trial subscription for new business
  Future<BusinessSubscription> createTrialSubscription(String businessId) async {
    try {
      // Try using the secure function first
      try {
        final response = await _supabase.rpc(
          'create_trial_subscription_for_business',
          params: {'business_uuid': businessId},
        );

        if (response != null) {
          final subscription = BusinessSubscription.fromJson(response as Map<String, dynamic>);
          
          // Cache the newly created subscription
          await SubscriptionPersistenceService.cacheBusinessSubscription(businessId, subscription);
          _logger.info('Created trial subscription via RPC and cached it for business $businessId');
          
          return subscription;
        } else {
          throw Exception('Function returned null');
        }
      } catch (rpcError) {
        _logger.warning('RPC function failed, trying direct insert', rpcError);
        
        // Fallback to direct insert
        return await _createTrialSubscriptionDirect(businessId);
      }
    } catch (e) {
      _logger.error('Error creating trial subscription', e);
      throw Exception('Failed to create trial subscription');
    }
  }

  // Direct insert fallback method
  Future<BusinessSubscription> _createTrialSubscriptionDirect(String businessId) async {
    // Get the monthly plan (default for trial)
    final plans = await getSubscriptionPlans();
    final monthlyPlan = plans.firstWhere(
      (plan) => plan.durationMonths == 1,
      orElse: () => throw Exception('Monthly plan not found'),
    );

    final now = DateTime.now();
    final trialEnd = now.add(const Duration(days: trialDays));

    final subscriptionData = {
      'business_id': businessId,
      'plan_id': monthlyPlan.id,
      'status': SubscriptionStatus.trial.name,
      'trial_start_date': now.toIso8601String(),
      'trial_end_date': trialEnd.toIso8601String(),
      'auto_renew': false,
      'currency': 'INR', // Default currency
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    final response = await _supabase
        .from('business_subscriptions')
        .insert(subscriptionData)
        .select()
        .single();

    final subscription = BusinessSubscription.fromJson(response);
    
    // Cache the newly created subscription
    await SubscriptionPersistenceService.cacheBusinessSubscription(businessId, subscription);
    _logger.info('Created trial subscription via direct insert and cached it for business $businessId');
    
    return subscription;
  }

  // Update subscription status
  Future<BusinessSubscription> updateSubscriptionStatus({
    required String subscriptionId,
    required SubscriptionStatus status,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    double? amountPaid,
    String? paymentMethod,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (subscriptionStartDate != null) {
        updateData['subscription_start_date'] = subscriptionStartDate.toIso8601String();
      }
      if (subscriptionEndDate != null) {
        updateData['subscription_end_date'] = subscriptionEndDate.toIso8601String();
      }
      if (amountPaid != null) {
        updateData['amount_paid'] = amountPaid;
      }
      if (paymentMethod != null) {
        updateData['payment_method'] = paymentMethod;
      }

      final response = await _supabase
          .from('business_subscriptions')
          .update(updateData)
          .eq('id', subscriptionId)
          .select()
          .single();

      return BusinessSubscription.fromJson(response);
    } catch (e) {
      _logger.error('Error updating subscription status', e);
      throw Exception('Failed to update subscription status');
    }
  }

  // Record payment
  Future<SubscriptionPayment> recordPayment({
    required String subscriptionId,
    required double amount,
    required String currency,
    required String paymentMethod,
    String? paymentReference,
    String? notes,
    String? verifiedBy,
  }) async {
    try {
      final paymentData = {
        'subscription_id': subscriptionId,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
        'payment_reference': paymentReference,
        'payment_date': DateTime.now().toIso8601String(),
        'notes': notes,
        'verified_by': verifiedBy,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('subscription_payments')
          .insert(paymentData)
          .select()
          .single();

      return SubscriptionPayment.fromJson(response);
    } catch (e) {
      _logger.error('Error recording payment', e);
      throw Exception('Failed to record payment');
    }
  }

  // Get payment history for a subscription
  Future<List<SubscriptionPayment>> getPaymentHistory(String subscriptionId) async {
    try {
      final response = await _supabase
          .from('subscription_payments')
          .select()
          .eq('subscription_id', subscriptionId)
          .order('payment_date', ascending: false);

      return (response as List<dynamic>)
          .map((json) => SubscriptionPayment.fromJson(json))
          .toList();
    } catch (e) {
      _logger.error('Error fetching payment history', e);
      throw Exception('Failed to fetch payment history');
    }
  }

  // Check if business can access ERP features
  Future<bool> canBusinessAccessERP(String businessId) async {
    try {
      final subscription = await getBusinessSubscription(businessId);
      
      if (subscription == null) {
        // No subscription found - create trial
        await createTrialSubscription(businessId);
        return true;
      }

      return subscription.canAccessERP;
    } catch (e) {
      _logger.error('Error checking ERP access', e);
      return false; // Deny access on error
    }
  }

  // Get subscription summary for dashboard with caching support
  Future<Map<String, dynamic>> getSubscriptionSummary(String businessId) async {
    try {
      final subscription = await getBusinessSubscription(businessId);
      
      Map<String, dynamic> summary;
      
      if (subscription == null) {
        summary = {
          'hasSubscription': false,
          'status': 'No Subscription',
          'daysRemaining': 0,
          'canAccess': false,
          'isTrialAvailable': true,
        };
      } else {
        summary = {
          'hasSubscription': true,
          'status': subscription.status.displayName,
          'statusMessage': subscription.statusMessage,
          'daysRemaining': subscription.daysRemaining,
          'canAccess': subscription.canAccessERP,
          'isExpiringSoon': subscription.isExpiringSoon,
          'isTrialActive': subscription.isTrialActive,
          'subscriptionId': subscription.id,
        };
      }

      // Cache the summary for quick offline access
      await SubscriptionPersistenceService.cacheSubscriptionSummary(businessId, summary);
      
      return summary;
    } catch (e) {
      _logger.error('Error getting subscription summary online', e);
      _logger.info('Attempting to load cached subscription summary...');
      
      // Try to get cached summary
      final cachedSummary = await SubscriptionPersistenceService.getCachedSubscriptionSummary(businessId);
      if (cachedSummary != null) {
        _logger.info('Loaded cached subscription summary for business $businessId');
        return cachedSummary;
      }
      
      // Return error summary if no cache available
      return {
        'hasSubscription': false,
        'status': 'Error',
        'daysRemaining': 0,
        'canAccess': false,
        'error': e.toString(),
      };
    }
  }

  // Get currency for business based on location/country
  String getCurrencyForBusiness(BusinessModel business) {
    // You can implement location-based currency detection here
    // For now, using a simple approach based on business address/phone
    final address = business.address?.toLowerCase() ?? '';
    final phone = business.phone ?? '';

    if (address.contains('saudi') || 
        address.contains('riyadh') || 
        address.contains('jeddah') ||
        phone.startsWith('+966')) {
      return 'SAR';
    }
    
    if (address.contains('uae') || 
        address.contains('dubai') || 
        address.contains('abu dhabi') ||
        phone.startsWith('+971')) {
      return 'AED';
    }
    
    // Default to INR for India and others
    return 'INR';
  }

  // Admin functions for revenue reporting
  Future<Map<String, dynamic>> getRevenueReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      startDate ??= DateTime.now().subtract(const Duration(days: 30));
      endDate ??= DateTime.now();

      final response = await _supabase
          .from('subscription_payments')
          .select('amount, currency, payment_date')
          .gte('payment_date', startDate.toIso8601String())
          .lte('payment_date', endDate.toIso8601String());

      final payments = response as List<dynamic>;
      
      double totalRevenue = 0;
      Map<String, double> currencyBreakdown = {};
      
      for (final payment in payments) {
        final amount = payment['amount'] as double;
        final currency = payment['currency'] as String;
        
        totalRevenue += amount;
        currencyBreakdown[currency] = (currencyBreakdown[currency] ?? 0) + amount;
      }

      return {
        'totalRevenue': totalRevenue,
        'currencyBreakdown': currencyBreakdown,
        'paymentCount': payments.length,
        'period': {
          'start': startDate.toIso8601String(),
          'end': endDate.toIso8601String(),
        }
      };
    } catch (e) {
      _logger.error('Error generating revenue report', e);
      throw Exception('Failed to generate revenue report');
    }
  }
}