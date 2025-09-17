import 'package:freezed_annotation/freezed_annotation.dart';
import 'discount.dart';

part 'applied_item_discount.freezed.dart';
part 'applied_item_discount.g.dart';

@freezed
class AppliedItemDiscount with _$AppliedItemDiscount {
  const factory AppliedItemDiscount({
    required String discountId,
    required String discountName,
    required DiscountType type,
    required double value,
    required double calculatedAmount, // The actual discount amount for this item
    required bool isAutoApplied,
    String? reason, // Reason for manual discount
    required DateTime appliedAt,
  }) = _AppliedItemDiscount;

  factory AppliedItemDiscount.fromJson(Map<String, dynamic> json) =>
      _$AppliedItemDiscountFromJson(json);

  const AppliedItemDiscount._();
}