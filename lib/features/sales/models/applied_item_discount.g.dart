// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applied_item_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppliedItemDiscountImpl _$$AppliedItemDiscountImplFromJson(
  Map<String, dynamic> json,
) => _$AppliedItemDiscountImpl(
  discountId: json['discountId'] as String,
  discountName: json['discountName'] as String,
  type: $enumDecode(_$DiscountTypeEnumMap, json['type']),
  value: (json['value'] as num).toDouble(),
  calculatedAmount: (json['calculatedAmount'] as num).toDouble(),
  isAutoApplied: json['isAutoApplied'] as bool,
  reason: json['reason'] as String?,
  appliedAt: DateTime.parse(json['appliedAt'] as String),
);

Map<String, dynamic> _$$AppliedItemDiscountImplToJson(
  _$AppliedItemDiscountImpl instance,
) => <String, dynamic>{
  'discountId': instance.discountId,
  'discountName': instance.discountName,
  'type': _$DiscountTypeEnumMap[instance.type]!,
  'value': instance.value,
  'calculatedAmount': instance.calculatedAmount,
  'isAutoApplied': instance.isAutoApplied,
  'reason': instance.reason,
  'appliedAt': instance.appliedAt.toIso8601String(),
};

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 'percentage',
  DiscountType.fixed: 'fixed',
};
