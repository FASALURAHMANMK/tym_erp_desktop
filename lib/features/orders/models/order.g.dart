// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String,
  posDeviceId: json['posDeviceId'] as String,
  orderType:
      $enumDecodeNullable(_$OrderTypeEnumMap, json['orderType']) ??
      OrderType.dineIn,
  priceCategoryName: json['priceCategoryName'] as String?,
  orderSource:
      $enumDecodeNullable(_$OrderSourceEnumMap, json['orderSource']) ??
      OrderSource.pos,
  tableId: json['tableId'] as String?,
  tableName: json['tableName'] as String?,
  customerId: json['customerId'] as String,
  customerName: json['customerName'] as String,
  customerPhone: json['customerPhone'] as String?,
  customerEmail: json['customerEmail'] as String?,
  deliveryAddressLine1: json['deliveryAddressLine1'] as String?,
  deliveryAddressLine2: json['deliveryAddressLine2'] as String?,
  deliveryCity: json['deliveryCity'] as String?,
  deliveryPostalCode: json['deliveryPostalCode'] as String?,
  deliveryPhone: json['deliveryPhone'] as String?,
  deliveryInstructions: json['deliveryInstructions'] as String?,
  orderedAt: DateTime.parse(json['orderedAt'] as String),
  confirmedAt:
      json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
  preparedAt:
      json['preparedAt'] == null
          ? null
          : DateTime.parse(json['preparedAt'] as String),
  readyAt:
      json['readyAt'] == null
          ? null
          : DateTime.parse(json['readyAt'] as String),
  servedAt:
      json['servedAt'] == null
          ? null
          : DateTime.parse(json['servedAt'] as String),
  completedAt:
      json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
  cancelledAt:
      json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
  estimatedReadyTime:
      json['estimatedReadyTime'] == null
          ? null
          : DateTime.parse(json['estimatedReadyTime'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
  discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
  taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0,
  chargesAmount: (json['chargesAmount'] as num?)?.toDouble() ?? 0,
  deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0,
  serviceCharge: (json['serviceCharge'] as num?)?.toDouble() ?? 0,
  tipAmount: (json['tipAmount'] as num?)?.toDouble() ?? 0,
  roundOffAmount: (json['roundOffAmount'] as num?)?.toDouble() ?? 0,
  total: (json['total'] as num).toDouble(),
  orderDiscounts:
      (json['orderDiscounts'] as List<dynamic>?)
          ?.map((e) => OrderDiscount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  orderCharges:
      (json['orderCharges'] as List<dynamic>?)
          ?.map((e) => OrderCharge.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  paymentStatus:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
      PaymentStatus.pending,
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => OrderPayment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0,
  changeAmount: (json['changeAmount'] as num?)?.toDouble() ?? 0,
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.draft,
  kitchenStatus: $enumDecodeNullable(
    _$KitchenStatusEnumMap,
    json['kitchenStatus'],
  ),
  createdBy: json['createdBy'] as String,
  createdByName: json['createdByName'] as String?,
  servedBy: json['servedBy'] as String?,
  servedByName: json['servedByName'] as String?,
  preparedBy:
      (json['preparedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  customerNotes: json['customerNotes'] as String?,
  kitchenNotes: json['kitchenNotes'] as String?,
  internalNotes: json['internalNotes'] as String?,
  cancellationReason: json['cancellationReason'] as String?,
  tokenNumber: json['tokenNumber'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastSyncedAt:
      json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
  hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
  isPriority: json['isPriority'] as bool? ?? false,
  isVoid: json['isVoid'] as bool? ?? false,
  voidReason: json['voidReason'] as String?,
  voidedAt:
      json['voidedAt'] == null
          ? null
          : DateTime.parse(json['voidedAt'] as String),
  voidedBy: json['voidedBy'] as String?,
  preparationTimeMinutes: (json['preparationTimeMinutes'] as num?)?.toInt(),
  serviceTimeMinutes: (json['serviceTimeMinutes'] as num?)?.toInt(),
  totalTimeMinutes: (json['totalTimeMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'posDeviceId': instance.posDeviceId,
      'orderType': _$OrderTypeEnumMap[instance.orderType]!,
      'priceCategoryName': instance.priceCategoryName,
      'orderSource': _$OrderSourceEnumMap[instance.orderSource]!,
      'tableId': instance.tableId,
      'tableName': instance.tableName,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerEmail': instance.customerEmail,
      'deliveryAddressLine1': instance.deliveryAddressLine1,
      'deliveryAddressLine2': instance.deliveryAddressLine2,
      'deliveryCity': instance.deliveryCity,
      'deliveryPostalCode': instance.deliveryPostalCode,
      'deliveryPhone': instance.deliveryPhone,
      'deliveryInstructions': instance.deliveryInstructions,
      'orderedAt': instance.orderedAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'preparedAt': instance.preparedAt?.toIso8601String(),
      'readyAt': instance.readyAt?.toIso8601String(),
      'servedAt': instance.servedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'estimatedReadyTime': instance.estimatedReadyTime?.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'subtotal': instance.subtotal,
      'discountAmount': instance.discountAmount,
      'taxAmount': instance.taxAmount,
      'chargesAmount': instance.chargesAmount,
      'deliveryCharge': instance.deliveryCharge,
      'serviceCharge': instance.serviceCharge,
      'tipAmount': instance.tipAmount,
      'roundOffAmount': instance.roundOffAmount,
      'total': instance.total,
      'orderDiscounts': instance.orderDiscounts.map((e) => e.toJson()).toList(),
      'orderCharges': instance.orderCharges.map((e) => e.toJson()).toList(),
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'payments': instance.payments.map((e) => e.toJson()).toList(),
      'totalPaid': instance.totalPaid,
      'changeAmount': instance.changeAmount,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'kitchenStatus': _$KitchenStatusEnumMap[instance.kitchenStatus],
      'createdBy': instance.createdBy,
      'createdByName': instance.createdByName,
      'servedBy': instance.servedBy,
      'servedByName': instance.servedByName,
      'preparedBy': instance.preparedBy,
      'customerNotes': instance.customerNotes,
      'kitchenNotes': instance.kitchenNotes,
      'internalNotes': instance.internalNotes,
      'cancellationReason': instance.cancellationReason,
      'tokenNumber': instance.tokenNumber,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
      'isPriority': instance.isPriority,
      'isVoid': instance.isVoid,
      'voidReason': instance.voidReason,
      'voidedAt': instance.voidedAt?.toIso8601String(),
      'voidedBy': instance.voidedBy,
      'preparationTimeMinutes': instance.preparationTimeMinutes,
      'serviceTimeMinutes': instance.serviceTimeMinutes,
      'totalTimeMinutes': instance.totalTimeMinutes,
    };

const _$OrderTypeEnumMap = {
  OrderType.dineIn: 'dineIn',
  OrderType.takeaway: 'takeaway',
  OrderType.delivery: 'delivery',
  OrderType.online: 'online',
};

const _$OrderSourceEnumMap = {
  OrderSource.pos: 'pos',
  OrderSource.online: 'online',
  OrderSource.phone: 'phone',
  OrderSource.kiosk: 'kiosk',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.partial: 'partial',
  PaymentStatus.paid: 'paid',
  PaymentStatus.refunded: 'refunded',
};

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.served: 'served',
  OrderStatus.picked: 'picked',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.refunded: 'refunded',
};

const _$KitchenStatusEnumMap = {
  KitchenStatus.pending: 'pending',
  KitchenStatus.preparing: 'preparing',
  KitchenStatus.ready: 'ready',
};
