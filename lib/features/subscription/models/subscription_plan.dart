import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_plan.freezed.dart';

@freezed
class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required String id,
    required String name,
    required int durationMonths,
    required double priceInr,
    required double priceSar,
    required double priceAed,
    required Map<String, dynamic> features,
    required bool isActive,
    required DateTime createdAt,
  }) = _SubscriptionPlan;

  const SubscriptionPlan._();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration_months': durationMonths,
      'price_inr': priceInr,
      'price_sar': priceSar,
      'price_aed': priceAed,
      'features': features,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      durationMonths: json['duration_months'] as int,
      priceInr: (json['price_inr'] as num?)?.toDouble() ?? 0.0,
      priceSar: (json['price_sar'] as num?)?.toDouble() ?? 0.0,
      priceAed: (json['price_aed'] as num?)?.toDouble() ?? 0.0,
      features: json['features'] as Map<String, dynamic>? ?? {},
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

}

enum SubscriptionPlanType {
  monthly('Monthly', 1),
  yearly('Yearly', 12);

  const SubscriptionPlanType(this.displayName, this.months);
  final String displayName;
  final int months;
}

extension SubscriptionPlanExtension on SubscriptionPlan {
  SubscriptionPlanType get planType {
    switch (durationMonths) {
      case 1:
        return SubscriptionPlanType.monthly;
      case 12:
        return SubscriptionPlanType.yearly;
      default:
        return SubscriptionPlanType.monthly;
    }
  }

  double getPriceForCurrency(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return priceInr;
      case 'SAR':
        return priceSar;
      case 'AED':
        return priceAed;
      default:
        return priceInr;
    }
  }

  String getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'SAR':
        return 'ر.س';
      case 'AED':
        return 'د.إ';
      default:
        return '₹';
    }
  }
}