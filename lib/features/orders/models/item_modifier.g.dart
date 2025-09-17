// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemModifierImpl _$$ItemModifierImplFromJson(Map<String, dynamic> json) =>
    _$ItemModifierImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      groupName: json['groupName'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$$ItemModifierImplToJson(_$ItemModifierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'groupName': instance.groupName,
      'isRequired': instance.isRequired,
    };
