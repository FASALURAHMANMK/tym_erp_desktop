import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_subscription.freezed.dart';

@freezed
class BusinessSubscription with _$BusinessSubscription {
  const factory BusinessSubscription({
    required String id,
    required String businessId,
    required String planId,
    required SubscriptionStatus status,
    DateTime? trialStartDate,
    DateTime? trialEndDate,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    required bool autoRenew,
    String? paymentMethod,
    required String currency,
    double? amountPaid,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BusinessSubscription;

  const BusinessSubscription._();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'plan_id': planId,
      'status': status.name,
      'trial_start_date': trialStartDate?.toIso8601String(),
      'trial_end_date': trialEndDate?.toIso8601String(),
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'auto_renew': autoRenew,
      'payment_method': paymentMethod,
      'currency': currency,
      'amount_paid': amountPaid,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static String _ensureUtcFormat(String dateString) {
    // If the string already ends with 'Z', don't add another one
    return dateString.endsWith('Z') ? dateString : '${dateString}Z';
  }

  factory BusinessSubscription.fromJson(Map<String, dynamic> json) {
    return BusinessSubscription(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      planId: json['plan_id'] as String,
      status: SubscriptionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => SubscriptionStatus.trial,
      ),
      trialStartDate:
          json['trial_start_date'] != null
              ? DateTime.parse(_ensureUtcFormat(json['trial_start_date'] as String))
              : null,
      trialEndDate:
          json['trial_end_date'] != null
              ? DateTime.parse(_ensureUtcFormat(json['trial_end_date'] as String))
              : null,
      subscriptionStartDate:
          json['subscription_start_date'] != null
              ? DateTime.parse(_ensureUtcFormat(json['subscription_start_date'] as String))
              : null,
      subscriptionEndDate:
          json['subscription_end_date'] != null
              ? DateTime.parse(_ensureUtcFormat(json['subscription_end_date'] as String))
              : null,
      autoRenew: json['auto_renew'] as bool? ?? false,
      paymentMethod: json['payment_method'] as String?,
      currency: json['currency'] as String? ?? 'INR',
      amountPaid: (json['amount_paid'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

enum SubscriptionStatus {
  trial('Trial', 'Active trial period'),
  active('Active', 'Subscription is active'),
  expired('Expired', 'Subscription has expired'),
  cancelled('Cancelled', 'Subscription was cancelled'),
  suspended('Suspended', 'Subscription is suspended');

  const SubscriptionStatus(this.displayName, this.description);
  final String displayName;
  final String description;

  bool get isActive =>
      this == SubscriptionStatus.active || this == SubscriptionStatus.trial;
  bool get requiresPayment => this == SubscriptionStatus.expired;
  bool get canUseERP => isActive;
}

extension BusinessSubscriptionExtension on BusinessSubscription {
  bool get isTrialActive {
    if (status != SubscriptionStatus.trial) return false;
    if (trialEndDate == null) return false;
    
    final nowLocal = DateTime.now();
    final trialEndLocal = trialEndDate!.toLocal();
    return nowLocal.isBefore(trialEndLocal);
  }

  bool get isSubscriptionActive {
    if (status != SubscriptionStatus.active) return false;
    if (subscriptionEndDate == null) return false;
    return DateTime.now().isBefore(subscriptionEndDate!.toLocal());
  }

  bool get canAccessERP {
    return isTrialActive || isSubscriptionActive;
  }

  int get daysRemaining {
    final endDate =
        status == SubscriptionStatus.trial ? trialEndDate : subscriptionEndDate;

    if (endDate == null) return 0;

    final now = DateTime.now();
    final endDateLocal = endDate.toLocal();
    if (now.isAfter(endDateLocal)) return 0;

    return endDateLocal.difference(now).inDays;
  }

  bool get isExpiringSoon {
    return daysRemaining <= 7 && daysRemaining > 0;
  }

  String get statusMessage {
    switch (status) {
      case SubscriptionStatus.trial:
        if (isTrialActive) {
          return 'Trial period - $daysRemaining days remaining';
        } else {
          return 'Trial period expired';
        }
      case SubscriptionStatus.active:
        if (isSubscriptionActive) {
          return 'Active subscription - $daysRemaining days remaining';
        } else {
          return 'Subscription expired';
        }
      case SubscriptionStatus.expired:
        return 'Subscription expired - Please renew to continue';
      case SubscriptionStatus.cancelled:
        return 'Subscription cancelled';
      case SubscriptionStatus.suspended:
        return 'Subscription suspended - Contact support';
    }
  }
}
