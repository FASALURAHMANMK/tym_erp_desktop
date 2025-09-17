// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDiscountImpl _$$OrderDiscountImplFromJson(Map<String, dynamic> json) =>
    _$OrderDiscountImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      discountId: json['discountId'] as String,
      discountName: json['discountName'] as String,
      discountCode: json['discountCode'] as String,
      discountType: json['discountType'] as String,
      appliedTo: json['appliedTo'] as String,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      maximumDiscount: (json['maximumDiscount'] as num?)?.toDouble() ?? 0,
      appliedAmount: (json['appliedAmount'] as num).toDouble(),
      minimumPurchase: (json['minimumPurchase'] as num?)?.toDouble() ?? 0,
      minimumQuantity: (json['minimumQuantity'] as num?)?.toInt() ?? 0,
      applicableCategories:
          (json['applicableCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      applicableProducts:
          (json['applicableProducts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      applicationMethod: json['applicationMethod'] as String? ?? 'auto',
      couponCode: json['couponCode'] as String?,
      appliedBy: json['appliedBy'] as String?,
      appliedByName: json['appliedByName'] as String?,
      reason: json['reason'] as String?,
      authorizedBy: json['authorizedBy'] as String?,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$OrderDiscountImplToJson(_$OrderDiscountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'discountId': instance.discountId,
      'discountName': instance.discountName,
      'discountCode': instance.discountCode,
      'discountType': instance.discountType,
      'appliedTo': instance.appliedTo,
      'discountPercent': instance.discountPercent,
      'discountAmount': instance.discountAmount,
      'maximumDiscount': instance.maximumDiscount,
      'appliedAmount': instance.appliedAmount,
      'minimumPurchase': instance.minimumPurchase,
      'minimumQuantity': instance.minimumQuantity,
      'applicableCategories': instance.applicableCategories,
      'applicableProducts': instance.applicableProducts,
      'applicationMethod': instance.applicationMethod,
      'couponCode': instance.couponCode,
      'appliedBy': instance.appliedBy,
      'appliedByName': instance.appliedByName,
      'reason': instance.reason,
      'authorizedBy': instance.authorizedBy,
      'appliedAt': instance.appliedAt.toIso8601String(),
      'metadata': instance.metadata,
    };
