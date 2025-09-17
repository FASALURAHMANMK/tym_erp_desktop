// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChargeImpl _$$ChargeImplFromJson(Map<String, dynamic> json) => _$ChargeImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String?,
  code: json['code'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  chargeType: $enumDecode(_$ChargeTypeEnumMap, json['chargeType']),
  calculationType: $enumDecode(
    _$CalculationTypeEnumMap,
    json['calculationType'],
  ),
  value: (json['value'] as num?)?.toDouble(),
  scope:
      $enumDecodeNullable(_$ChargeScopeEnumMap, json['scope']) ??
      ChargeScope.order,
  autoApply: json['autoApply'] as bool? ?? false,
  isMandatory: json['isMandatory'] as bool? ?? false,
  isTaxable: json['isTaxable'] as bool? ?? true,
  applyBeforeDiscount: json['applyBeforeDiscount'] as bool? ?? false,
  minimumOrderValue: (json['minimumOrderValue'] as num?)?.toDouble(),
  maximumOrderValue: (json['maximumOrderValue'] as num?)?.toDouble(),
  validFrom:
      json['validFrom'] == null
          ? null
          : DateTime.parse(json['validFrom'] as String),
  validUntil:
      json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
  applicableDays:
      (json['applicableDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  applicableTimeSlots: json['applicableTimeSlots'] as Map<String, dynamic>?,
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
  excludedCategories:
      (json['excludedCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  excludedProducts:
      (json['excludedProducts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  applicableCustomerGroups:
      (json['applicableCustomerGroups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  excludedCustomerGroups:
      (json['excludedCustomerGroups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
  showInPos: json['showInPos'] as bool? ?? true,
  showInInvoice: json['showInInvoice'] as bool? ?? true,
  showInOnline: json['showInOnline'] as bool? ?? true,
  iconName: json['iconName'] as String?,
  colorHex: json['colorHex'] as String?,
  tiers:
      (json['tiers'] as List<dynamic>?)
          ?.map((e) => ChargeTier.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  formula:
      json['formula'] == null
          ? null
          : ChargeFormula.fromJson(json['formula'] as Map<String, dynamic>),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
);

Map<String, dynamic> _$$ChargeImplToJson(_$ChargeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'locationId': instance.locationId,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'chargeType': _$ChargeTypeEnumMap[instance.chargeType]!,
      'calculationType': _$CalculationTypeEnumMap[instance.calculationType]!,
      'value': instance.value,
      'scope': _$ChargeScopeEnumMap[instance.scope]!,
      'autoApply': instance.autoApply,
      'isMandatory': instance.isMandatory,
      'isTaxable': instance.isTaxable,
      'applyBeforeDiscount': instance.applyBeforeDiscount,
      'minimumOrderValue': instance.minimumOrderValue,
      'maximumOrderValue': instance.maximumOrderValue,
      'validFrom': instance.validFrom?.toIso8601String(),
      'validUntil': instance.validUntil?.toIso8601String(),
      'applicableDays': instance.applicableDays,
      'applicableTimeSlots': instance.applicableTimeSlots,
      'applicableCategories': instance.applicableCategories,
      'applicableProducts': instance.applicableProducts,
      'excludedCategories': instance.excludedCategories,
      'excludedProducts': instance.excludedProducts,
      'applicableCustomerGroups': instance.applicableCustomerGroups,
      'excludedCustomerGroups': instance.excludedCustomerGroups,
      'displayOrder': instance.displayOrder,
      'showInPos': instance.showInPos,
      'showInInvoice': instance.showInInvoice,
      'showInOnline': instance.showInOnline,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
      'tiers': instance.tiers,
      'formula': instance.formula,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$ChargeTypeEnumMap = {
  ChargeType.service: 'service',
  ChargeType.delivery: 'delivery',
  ChargeType.packaging: 'packaging',
  ChargeType.convenience: 'convenience',
  ChargeType.custom: 'custom',
};

const _$CalculationTypeEnumMap = {
  CalculationType.fixed: 'fixed',
  CalculationType.percentage: 'percentage',
  CalculationType.tiered: 'tiered',
  CalculationType.formula: 'formula',
};

const _$ChargeScopeEnumMap = {
  ChargeScope.order: 'order',
  ChargeScope.item: 'item',
  ChargeScope.category: 'category',
  ChargeScope.customer: 'customer',
};

_$ChargeTierImpl _$$ChargeTierImplFromJson(Map<String, dynamic> json) =>
    _$ChargeTierImpl(
      id: json['id'] as String,
      chargeId: json['chargeId'] as String,
      tierName: json['tierName'] as String?,
      minValue: (json['minValue'] as num).toDouble(),
      maxValue: (json['maxValue'] as num?)?.toDouble(),
      chargeValue: (json['chargeValue'] as num).toDouble(),
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChargeTierImplToJson(_$ChargeTierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chargeId': instance.chargeId,
      'tierName': instance.tierName,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'chargeValue': instance.chargeValue,
      'displayOrder': instance.displayOrder,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$ChargeFormulaImpl _$$ChargeFormulaImplFromJson(Map<String, dynamic> json) =>
    _$ChargeFormulaImpl(
      id: json['id'] as String,
      chargeId: json['chargeId'] as String,
      baseAmount: (json['baseAmount'] as num?)?.toDouble() ?? 0,
      variableRate: (json['variableRate'] as num?)?.toDouble() ?? 0,
      variableType: json['variableType'] as String?,
      minCharge: (json['minCharge'] as num?)?.toDouble(),
      maxCharge: (json['maxCharge'] as num?)?.toDouble(),
      formulaExpression: json['formulaExpression'] as String?,
      customVariables: json['customVariables'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChargeFormulaImplToJson(_$ChargeFormulaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chargeId': instance.chargeId,
      'baseAmount': instance.baseAmount,
      'variableRate': instance.variableRate,
      'variableType': instance.variableType,
      'minCharge': instance.minCharge,
      'maxCharge': instance.maxCharge,
      'formulaExpression': instance.formulaExpression,
      'customVariables': instance.customVariables,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$AppliedChargeImpl _$$AppliedChargeImplFromJson(Map<String, dynamic> json) =>
    _$AppliedChargeImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      chargeId: json['chargeId'] as String?,
      chargeCode: json['chargeCode'] as String,
      chargeName: json['chargeName'] as String,
      chargeType: json['chargeType'] as String,
      calculationType: json['calculationType'] as String,
      baseAmount: (json['baseAmount'] as num?)?.toDouble(),
      chargeRate: (json['chargeRate'] as num?)?.toDouble(),
      chargeAmount: (json['chargeAmount'] as num).toDouble(),
      isTaxable: json['isTaxable'] as bool? ?? true,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0,
      isManual: json['isManual'] as bool? ?? false,
      originalAmount: (json['originalAmount'] as num?)?.toDouble(),
      adjustmentReason: json['adjustmentReason'] as String?,
      addedBy: json['addedBy'] as String?,
      removedBy: json['removedBy'] as String?,
      isRemoved: json['isRemoved'] as bool? ?? false,
      removedAt:
          json['removedAt'] == null
              ? null
              : DateTime.parse(json['removedAt'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AppliedChargeImplToJson(_$AppliedChargeImpl instance) =>
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
      'taxAmount': instance.taxAmount,
      'isManual': instance.isManual,
      'originalAmount': instance.originalAmount,
      'adjustmentReason': instance.adjustmentReason,
      'addedBy': instance.addedBy,
      'removedBy': instance.removedBy,
      'isRemoved': instance.isRemoved,
      'removedAt': instance.removedAt?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CustomerChargeExemptionImpl _$$CustomerChargeExemptionImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerChargeExemptionImpl(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  chargeId: json['chargeId'] as String,
  businessId: json['businessId'] as String,
  exemptionType: json['exemptionType'] as String,
  exemptionValue: (json['exemptionValue'] as num?)?.toDouble(),
  reason: json['reason'] as String?,
  validFrom:
      json['validFrom'] == null
          ? null
          : DateTime.parse(json['validFrom'] as String),
  validUntil:
      json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
  isActive: json['isActive'] as bool? ?? true,
  approvedBy: json['approvedBy'] as String?,
  approvedAt:
      json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CustomerChargeExemptionImplToJson(
  _$CustomerChargeExemptionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'customerId': instance.customerId,
  'chargeId': instance.chargeId,
  'businessId': instance.businessId,
  'exemptionType': instance.exemptionType,
  'exemptionValue': instance.exemptionValue,
  'reason': instance.reason,
  'validFrom': instance.validFrom?.toIso8601String(),
  'validUntil': instance.validUntil?.toIso8601String(),
  'isActive': instance.isActive,
  'approvedBy': instance.approvedBy,
  'approvedAt': instance.approvedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
