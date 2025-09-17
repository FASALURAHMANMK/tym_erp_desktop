import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../models/subscription_plan.dart';
import '../models/business_subscription.dart';
import '../models/subscription_payment.dart';

part 'subscription_provider.g.dart';

@riverpod
SubscriptionService subscriptionService(Ref ref) {
  return SubscriptionService();
}

@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  FutureOr<List<SubscriptionPlan>> build() async {
    return await ref.read(subscriptionServiceProvider).getSubscriptionPlans();
  }

  Future<void> refreshPlans() async {
    state = const AsyncValue.loading();
    try {
      final plans = await ref.read(subscriptionServiceProvider).getSubscriptionPlans();
      state = AsyncValue.data(plans);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

@riverpod
class BusinessSubscriptionNotifier extends _$BusinessSubscriptionNotifier {
  @override
  FutureOr<BusinessSubscription?> build(String businessId) async {
    return await ref.read(subscriptionServiceProvider).getBusinessSubscription(businessId);
  }

  Future<void> createTrialSubscription(String businessId) async {
    state = const AsyncValue.loading();
    try {
      final subscription = await ref.read(subscriptionServiceProvider)
          .createTrialSubscription(businessId);
      state = AsyncValue.data(subscription);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> updateSubscriptionStatus({
    required String subscriptionId,
    required SubscriptionStatus status,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    double? amountPaid,
    String? paymentMethod,
  }) async {
    state = const AsyncValue.loading();
    try {
      final subscription = await ref.read(subscriptionServiceProvider)
          .updateSubscriptionStatus(
            subscriptionId: subscriptionId,
            status: status,
            subscriptionStartDate: subscriptionStartDate,
            subscriptionEndDate: subscriptionEndDate,
            amountPaid: amountPaid,
            paymentMethod: paymentMethod,
          );
      state = AsyncValue.data(subscription);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refreshSubscription(String businessId) async {
    state = const AsyncValue.loading();
    try {
      final subscription = await ref.read(subscriptionServiceProvider)
          .getBusinessSubscription(businessId);
      state = AsyncValue.data(subscription);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

@riverpod
Future<bool> canAccessERP(Ref ref, String businessId) async {
  return await ref.read(subscriptionServiceProvider).canBusinessAccessERP(businessId);
}

@riverpod
Future<Map<String, dynamic>> subscriptionSummary(
  Ref ref, 
  String businessId,
) async {
  return await ref.read(subscriptionServiceProvider).getSubscriptionSummary(businessId);
}

@riverpod
class PaymentHistoryNotifier extends _$PaymentHistoryNotifier {
  @override
  FutureOr<List<SubscriptionPayment>> build(String subscriptionId) async {
    return await ref.read(subscriptionServiceProvider).getPaymentHistory(subscriptionId);
  }

  Future<void> recordPayment({
    required String subscriptionId,
    required double amount,
    required String currency,
    required String paymentMethod,
    String? paymentReference,
    String? notes,
    String? verifiedBy,
  }) async {
    try {
      await ref.read(subscriptionServiceProvider).recordPayment(
        subscriptionId: subscriptionId,
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
        paymentReference: paymentReference,
        notes: notes,
        verifiedBy: verifiedBy,
      );
      
      // Refresh the payment history
      await refreshPaymentHistory(subscriptionId);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refreshPaymentHistory(String subscriptionId) async {
    state = const AsyncValue.loading();
    try {
      final payments = await ref.read(subscriptionServiceProvider)
          .getPaymentHistory(subscriptionId);
      state = AsyncValue.data(payments);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

@riverpod
Future<Map<String, dynamic>> revenueReport(
  Ref ref, {
  DateTime? startDate,
  DateTime? endDate,
}) async {
  return await ref.read(subscriptionServiceProvider).getRevenueReport(
    startDate: startDate,
    endDate: endDate,
  );
}