// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscountImpl _$$DiscountImplFromJson(Map<String, dynamic> json) =>
    _$DiscountImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      type:
          $enumDecodeNullable(_$DiscountTypeEnumMap, json['type']) ??
          DiscountType.percentage,
      scope:
          $enumDecodeNullable(_$DiscountScopeEnumMap, json['scope']) ??
          DiscountScope.cart,
      minimumAmount: (json['minimumAmount'] as num?)?.toDouble(),
      maximumDiscount: (json['maximumDiscount'] as num?)?.toDouble(),
      categoryId: json['categoryId'] as String?,
      productId: json['productId'] as String?,
      couponCode: json['couponCode'] as String?,
      validFrom:
          json['validFrom'] == null
              ? null
              : DateTime.parse(json['validFrom'] as String),
      validUntil:
          json['validUntil'] == null
              ? null
              : DateTime.parse(json['validUntil'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isAutoApply: json['isAutoApply'] as bool? ?? false,
      description: json['description'] as String?,
      conditions: json['conditions'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DiscountImplToJson(_$DiscountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'type': _$DiscountTypeEnumMap[instance.type]!,
      'scope': _$DiscountScopeEnumMap[instance.scope]!,
      'minimumAmount': instance.minimumAmount,
      'maximumDiscount': instance.maximumDiscount,
      'categoryId': instance.categoryId,
      'productId': instance.productId,
      'couponCode': instance.couponCode,
      'validFrom': instance.validFrom?.toIso8601String(),
      'validUntil': instance.validUntil?.toIso8601String(),
      'isActive': instance.isActive,
      'isAutoApply': instance.isAutoApply,
      'description': instance.description,
      'conditions': instance.conditions,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 'percentage',
  DiscountType.fixed: 'fixed',
};

const _$DiscountScopeEnumMap = {
  DiscountScope.item: 'item',
  DiscountScope.cart: 'cart',
  DiscountScope.category: 'category',
};

_$CouponImpl _$$CouponImplFromJson(Map<String, dynamic> json) => _$CouponImpl(
  id: json['id'] as String,
  code: json['code'] as String,
  discount: Discount.fromJson(json['discount'] as Map<String, dynamic>),
  usageLimit: (json['usageLimit'] as num?)?.toInt(),
  usageCount: (json['usageCount'] as num?)?.toInt(),
  perCustomerLimit: (json['perCustomerLimit'] as num?)?.toInt(),
  isActive: json['isActive'] as bool? ?? true,
  expiresAt:
      json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
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
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CouponImplToJson(_$CouponImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discount': instance.discount,
      'usageLimit': instance.usageLimit,
      'usageCount': instance.usageCount,
      'perCustomerLimit': instance.perCustomerLimit,
      'isActive': instance.isActive,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'applicableCategories': instance.applicableCategories,
      'applicableProducts': instance.applicableProducts,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
