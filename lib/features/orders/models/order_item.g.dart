// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      variationId: json['variationId'] as String,
      productName: json['productName'] as String,
      variationName: json['variationName'] as String,
      productCode: json['productCode'] as String?,
      sku: json['sku'] as String?,
      unitOfMeasure: json['unitOfMeasure'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      modifiersPrice: (json['modifiersPrice'] as num?)?.toDouble() ?? 0,
      modifiers:
          (json['modifiers'] as List<dynamic>?)
              ?.map((e) => ItemModifier.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      specialInstructions: json['specialInstructions'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0,
      discountReason: json['discountReason'] as String?,
      appliedDiscountId: json['appliedDiscountId'] as String?,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0,
      taxGroupId: json['taxGroupId'] as String?,
      taxGroupName: json['taxGroupName'] as String?,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      skipKot: json['skipKot'] as bool? ?? false,
      kotPrinted: json['kotPrinted'] as bool? ?? false,
      kotPrintedAt:
          json['kotPrintedAt'] == null
              ? null
              : DateTime.parse(json['kotPrintedAt'] as String),
      kotNumber: json['kotNumber'] as String?,
      preparationStatus:
          $enumDecodeNullable(
            _$PreparationStatusEnumMap,
            json['preparationStatus'],
          ) ??
          PreparationStatus.pending,
      preparedAt:
          json['preparedAt'] == null
              ? null
              : DateTime.parse(json['preparedAt'] as String),
      preparedBy: json['preparedBy'] as String?,
      station: json['station'] as String?,
      servedAt:
          json['servedAt'] == null
              ? null
              : DateTime.parse(json['servedAt'] as String),
      servedBy: json['servedBy'] as String?,
      isVoided: json['isVoided'] as bool? ?? false,
      voidedAt:
          json['voidedAt'] == null
              ? null
              : DateTime.parse(json['voidedAt'] as String),
      voidedBy: json['voidedBy'] as String?,
      voidReason: json['voidReason'] as String?,
      isComplimentary: json['isComplimentary'] as bool? ?? false,
      complimentaryReason: json['complimentaryReason'] as String?,
      isReturned: json['isReturned'] as bool? ?? false,
      returnedQuantity: (json['returnedQuantity'] as num?)?.toDouble() ?? 0,
      returnedAt:
          json['returnedAt'] == null
              ? null
              : DateTime.parse(json['returnedAt'] as String),
      returnReason: json['returnReason'] as String?,
      refundedAmount: (json['refundedAmount'] as num?)?.toDouble() ?? 0,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      category: json['category'] as String?,
      categoryId: json['categoryId'] as String?,
      itemNotes: json['itemNotes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OrderItemImplToJson(
  _$OrderItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'productId': instance.productId,
  'variationId': instance.variationId,
  'productName': instance.productName,
  'variationName': instance.variationName,
  'productCode': instance.productCode,
  'sku': instance.sku,
  'unitOfMeasure': instance.unitOfMeasure,
  'quantity': instance.quantity,
  'unitPrice': instance.unitPrice,
  'modifiersPrice': instance.modifiersPrice,
  'modifiers': instance.modifiers,
  'specialInstructions': instance.specialInstructions,
  'discountAmount': instance.discountAmount,
  'discountPercent': instance.discountPercent,
  'discountReason': instance.discountReason,
  'appliedDiscountId': instance.appliedDiscountId,
  'taxRate': instance.taxRate,
  'taxAmount': instance.taxAmount,
  'taxGroupId': instance.taxGroupId,
  'taxGroupName': instance.taxGroupName,
  'subtotal': instance.subtotal,
  'total': instance.total,
  'skipKot': instance.skipKot,
  'kotPrinted': instance.kotPrinted,
  'kotPrintedAt': instance.kotPrintedAt?.toIso8601String(),
  'kotNumber': instance.kotNumber,
  'preparationStatus': _$PreparationStatusEnumMap[instance.preparationStatus]!,
  'preparedAt': instance.preparedAt?.toIso8601String(),
  'preparedBy': instance.preparedBy,
  'station': instance.station,
  'servedAt': instance.servedAt?.toIso8601String(),
  'servedBy': instance.servedBy,
  'isVoided': instance.isVoided,
  'voidedAt': instance.voidedAt?.toIso8601String(),
  'voidedBy': instance.voidedBy,
  'voidReason': instance.voidReason,
  'isComplimentary': instance.isComplimentary,
  'complimentaryReason': instance.complimentaryReason,
  'isReturned': instance.isReturned,
  'returnedQuantity': instance.returnedQuantity,
  'returnedAt': instance.returnedAt?.toIso8601String(),
  'returnReason': instance.returnReason,
  'refundedAmount': instance.refundedAmount,
  'displayOrder': instance.displayOrder,
  'category': instance.category,
  'categoryId': instance.categoryId,
  'itemNotes': instance.itemNotes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$PreparationStatusEnumMap = {
  PreparationStatus.pending: 'pending',
  PreparationStatus.preparing: 'preparing',
  PreparationStatus.ready: 'ready',
  PreparationStatus.served: 'served',
};
