// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_screen_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellScreenPreferencesImpl _$$SellScreenPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$SellScreenPreferencesImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  locationId: json['locationId'] as String,
  showOnHoldTab: json['showOnHoldTab'] as bool? ?? true,
  showSettlementTab: json['showSettlementTab'] as bool? ?? true,
  defaultPriceCategoryId: json['defaultPriceCategoryId'] as String?,
  productViewMode:
      $enumDecodeNullable(_$ProductViewModeEnumMap, json['productViewMode']) ??
      ProductViewMode.grid,
  gridColumns: (json['gridColumns'] as num?)?.toInt() ?? 4,
  showQuickSale: json['showQuickSale'] as bool? ?? true,
  showAddExpense: json['showAddExpense'] as bool? ?? false,
  settings: json['settings'] as Map<String, dynamic>? ?? const {},
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastSyncedAt:
      json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
  hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
);

Map<String, dynamic> _$$SellScreenPreferencesImplToJson(
  _$SellScreenPreferencesImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'locationId': instance.locationId,
  'showOnHoldTab': instance.showOnHoldTab,
  'showSettlementTab': instance.showSettlementTab,
  'defaultPriceCategoryId': instance.defaultPriceCategoryId,
  'productViewMode': _$ProductViewModeEnumMap[instance.productViewMode]!,
  'gridColumns': instance.gridColumns,
  'showQuickSale': instance.showQuickSale,
  'showAddExpense': instance.showAddExpense,
  'settings': instance.settings,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'hasUnsyncedChanges': instance.hasUnsyncedChanges,
};

const _$ProductViewModeEnumMap = {
  ProductViewMode.grid: 'grid',
  ProductViewMode.list: 'list',
};
