// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(
  Map<String, dynamic> json,
) => _$CartItemImpl(
  id: json['id'] as String,
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  categoryId: json['categoryId'] as String?,
  categoryName: json['categoryName'] as String?,
  variationId: json['variationId'] as String,
  variationName: json['variationName'] as String,
  productImage: json['productImage'] as String?,
  productCode: json['productCode'] as String?,
  sku: json['sku'] as String?,
  unitOfMeasure: json['unitOfMeasure'] as String?,
  quantity: (json['quantity'] as num).toDouble(),
  unitPrice: (json['unitPrice'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
  discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
  discountReason: json['discountReason'] as String?,
  appliedDiscountId: json['appliedDiscountId'] as String?,
  appliedDiscounts:
      (json['appliedDiscounts'] as List<dynamic>?)
          ?.map((e) => AppliedItemDiscount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  manuallyRemovedDiscounts: json['manuallyRemovedDiscounts'] as bool? ?? false,
  taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
  taxPercent: (json['taxPercent'] as num?)?.toDouble() ?? 0.0,
  taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0.0,
  taxGroupId: json['taxGroupId'] as String?,
  taxGroupName: json['taxGroupName'] as String?,
  notes: json['notes'] as String?,
  specialInstructions: json['specialInstructions'] as String?,
  skipKot: json['skipKot'] as bool? ?? false,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  addedAt: DateTime.parse(json['addedAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'variationId': instance.variationId,
      'variationName': instance.variationName,
      'productImage': instance.productImage,
      'productCode': instance.productCode,
      'sku': instance.sku,
      'unitOfMeasure': instance.unitOfMeasure,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'originalPrice': instance.originalPrice,
      'discountAmount': instance.discountAmount,
      'discountPercent': instance.discountPercent,
      'discountReason': instance.discountReason,
      'appliedDiscountId': instance.appliedDiscountId,
      'appliedDiscounts': instance.appliedDiscounts,
      'manuallyRemovedDiscounts': instance.manuallyRemovedDiscounts,
      'taxAmount': instance.taxAmount,
      'taxPercent': instance.taxPercent,
      'taxRate': instance.taxRate,
      'taxGroupId': instance.taxGroupId,
      'taxGroupName': instance.taxGroupName,
      'notes': instance.notes,
      'specialInstructions': instance.specialInstructions,
      'skipKot': instance.skipKot,
      'metadata': instance.metadata,
      'addedAt': instance.addedAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
