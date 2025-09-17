// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaxGroupImpl _$$TaxGroupImplFromJson(Map<String, dynamic> json) =>
    _$TaxGroupImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      taxRates:
          (json['taxRates'] as List<dynamic>?)
              ?.map((e) => TaxRate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaxGroupImplToJson(_$TaxGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'description': instance.description,
      'isDefault': instance.isDefault,
      'isActive': instance.isActive,
      'displayOrder': instance.displayOrder,
      'taxRates': instance.taxRates,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TaxRateImpl _$$TaxRateImplFromJson(Map<String, dynamic> json) =>
    _$TaxRateImpl(
      id: json['id'] as String,
      taxGroupId: json['taxGroupId'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      rate: (json['rate'] as num).toDouble(),
      type:
          $enumDecodeNullable(_$TaxTypeEnumMap, json['type']) ??
          TaxType.percentage,
      calculationMethod:
          $enumDecodeNullable(
            _$TaxCalculationMethodEnumMap,
            json['calculationMethod'],
          ) ??
          TaxCalculationMethod.exclusive,
      isActive: json['isActive'] as bool? ?? true,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      applyOn: json['applyOn'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaxRateImplToJson(_$TaxRateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taxGroupId': instance.taxGroupId,
      'businessId': instance.businessId,
      'name': instance.name,
      'rate': instance.rate,
      'type': _$TaxTypeEnumMap[instance.type]!,
      'calculationMethod':
          _$TaxCalculationMethodEnumMap[instance.calculationMethod]!,
      'isActive': instance.isActive,
      'displayOrder': instance.displayOrder,
      'applyOn': instance.applyOn,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TaxTypeEnumMap = {
  TaxType.percentage: 'percentage',
  TaxType.fixed: 'fixed',
};

const _$TaxCalculationMethodEnumMap = {
  TaxCalculationMethod.exclusive: 'exclusive',
  TaxCalculationMethod.inclusive: 'inclusive',
};

_$TaxConfigImpl _$$TaxConfigImplFromJson(Map<String, dynamic> json) =>
    _$TaxConfigImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      rate: (json['rate'] as num).toDouble(),
      type:
          $enumDecodeNullable(_$TaxTypeEnumMap, json['type']) ??
          TaxType.percentage,
      calculationMethod:
          $enumDecodeNullable(
            _$TaxCalculationMethodEnumMap,
            json['calculationMethod'],
          ) ??
          TaxCalculationMethod.exclusive,
      isActive: json['isActive'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      description: json['description'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaxConfigImplToJson(_$TaxConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'rate': instance.rate,
      'type': _$TaxTypeEnumMap[instance.type]!,
      'calculationMethod':
          _$TaxCalculationMethodEnumMap[instance.calculationMethod]!,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
      'description': instance.description,
      'displayOrder': instance.displayOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$MultipleTaxConfigImpl _$$MultipleTaxConfigImplFromJson(
  Map<String, dynamic> json,
) => _$MultipleTaxConfigImpl(
  taxes:
      (json['taxes'] as List<dynamic>)
          .map((e) => TaxConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
  compoundTax: json['compoundTax'] as bool? ?? false,
);

Map<String, dynamic> _$$MultipleTaxConfigImplToJson(
  _$MultipleTaxConfigImpl instance,
) => <String, dynamic>{
  'taxes': instance.taxes,
  'compoundTax': instance.compoundTax,
};
