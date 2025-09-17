// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_charge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderChargeImpl _$$OrderChargeImplFromJson(Map<String, dynamic> json) =>
    _$OrderChargeImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      chargeId: json['chargeId'] as String?,
      chargeCode: json['chargeCode'] as String,
      chargeName: json['chargeName'] as String,
      chargeType: json['chargeType'] as String,
      calculationType: json['calculationType'] as String,
      baseAmount: (json['baseAmount'] as num).toDouble(),
      chargeRate: (json['chargeRate'] as num).toDouble(),
      chargeAmount: (json['chargeAmount'] as num).toDouble(),
      isTaxable: json['isTaxable'] as bool? ?? false,
      isManual: json['isManual'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OrderChargeImplToJson(_$OrderChargeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'chargeId': instance.chargeId,
      'chargeCode': instance.chargeCode,
      'chargeName': instance.chargeName,
      'chargeType': instance.chargeType,
      'calculationType': instance.calculationType,
      'baseAmount': instance.baseAmount,
      'chargeRate': instance.chargeRate,
      'chargeAmount': instance.chargeAmount,
      'isTaxable': instance.isTaxable,
      'isManual': instance.isManual,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
