import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_charge.freezed.dart';
part 'order_charge.g.dart';

@freezed
class OrderCharge with _$OrderCharge {
  const factory OrderCharge({
    required String id,
    required String orderId,
    String? chargeId, // Reference to charges table (null for manual charges)
    required String chargeCode,
    required String chargeName,
    required String chargeType, // service, delivery, packaging, custom, etc.
    required String calculationType, // fixed, percentage, tiered, formula
    required double baseAmount, // Amount on which charge was calculated
    required double chargeRate, // Rate or percentage value
    required double chargeAmount, // Calculated charge amount
    @Default(false) bool isTaxable,
    @Default(false) bool isManual, // True for manually added charges
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _OrderCharge;

  factory OrderCharge.fromJson(Map<String, dynamic> json) => 
      _$OrderChargeFromJson(json);
}