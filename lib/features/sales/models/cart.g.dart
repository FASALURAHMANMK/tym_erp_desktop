// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartImpl _$$CartImplFromJson(Map<String, dynamic> json) => _$CartImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String,
  posDeviceId: json['posDeviceId'] as String,
  priceCategoryId: json['priceCategoryId'] as String,
  priceCategoryName: json['priceCategoryName'] as String?,
  customerId: json['customerId'] as String?,
  customerName: json['customerName'] as String?,
  customerPhone: json['customerPhone'] as String?,
  tableId: json['tableId'] as String?,
  tableName: json['tableName'] as String?,
  orderId: json['orderId'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
  orderDiscountAmount: (json['orderDiscountAmount'] as num?)?.toDouble() ?? 0.0,
  orderDiscountPercent:
      (json['orderDiscountPercent'] as num?)?.toDouble() ?? 0.0,
  orderDiscountReason: json['orderDiscountReason'] as String?,
  manualDiscountApplied: json['manualDiscountApplied'] as bool? ?? false,
  appliedCharges:
      (json['appliedCharges'] as List<dynamic>?)
          ?.map((e) => AppliedCharge.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalChargesAmount: (json['totalChargesAmount'] as num?)?.toDouble() ?? 0.0,
  taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
  totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
  roundOffAmount: (json['roundOffAmount'] as num?)?.toDouble() ?? 0.0,
  status:
      $enumDecodeNullable(_$CartStatusEnumMap, json['status']) ??
      CartStatus.active,
  notes: json['notes'] as String?,
  referenceNumber: json['referenceNumber'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  completedAt:
      json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
  createdBy: json['createdBy'] as String?,
);

Map<String, dynamic> _$$CartImplToJson(_$CartImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'posDeviceId': instance.posDeviceId,
      'priceCategoryId': instance.priceCategoryId,
      'priceCategoryName': instance.priceCategoryName,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'tableId': instance.tableId,
      'tableName': instance.tableName,
      'orderId': instance.orderId,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'orderDiscountAmount': instance.orderDiscountAmount,
      'orderDiscountPercent': instance.orderDiscountPercent,
      'orderDiscountReason': instance.orderDiscountReason,
      'manualDiscountApplied': instance.manualDiscountApplied,
      'appliedCharges': instance.appliedCharges,
      'totalChargesAmount': instance.totalChargesAmount,
      'taxAmount': instance.taxAmount,
      'totalAmount': instance.totalAmount,
      'roundOffAmount': instance.roundOffAmount,
      'status': _$CartStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'referenceNumber': instance.referenceNumber,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$CartStatusEnumMap = {
  CartStatus.active: 'active',
  CartStatus.onHold: 'on_hold',
  CartStatus.completed: 'completed',
  CartStatus.cancelled: 'cancelled',
};
