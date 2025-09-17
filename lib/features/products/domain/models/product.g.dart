// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      nameInAlternateLanguage: json['nameInAlternateLanguage'] as String?,
      description: json['description'] as String?,
      descriptionInAlternateLanguage:
          json['descriptionInAlternateLanguage'] as String?,
      categoryId: json['categoryId'] as String,
      brandId: json['brandId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      additionalImageUrls:
          (json['additionalImageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      unitOfMeasure:
          $enumDecodeNullable(_$UnitOfMeasureEnumMap, json['unitOfMeasure']) ??
          UnitOfMeasure.count,
      barcode: json['barcode'] as String?,
      hsn: json['hsn'] as String?,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0.0,
      taxGroupId: json['taxGroupId'] as String?,
      taxRateId: json['taxRateId'] as String?,
      shortCode: json['shortCode'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      productType:
          $enumDecodeNullable(_$ProductTypeEnumMap, json['productType']) ??
          ProductType.physical,
      trackInventory: json['trackInventory'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      availableInPos: json['availableInPos'] as bool? ?? true,
      availableInOnlineStore: json['availableInOnlineStore'] as bool? ?? false,
      availableInCatalog: json['availableInCatalog'] as bool? ?? true,
      skipKot: json['skipKot'] as bool? ?? false,
      variations:
          (json['variations'] as List<dynamic>)
              .map((e) => ProductVariation.fromJson(e as Map<String, dynamic>))
              .toList(),
      lastSyncedAt:
          json['lastSyncedAt'] == null
              ? null
              : DateTime.parse(json['lastSyncedAt'] as String),
      hasUnsyncedChanges: json['hasUnsyncedChanges'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'name': instance.name,
      'nameInAlternateLanguage': instance.nameInAlternateLanguage,
      'description': instance.description,
      'descriptionInAlternateLanguage': instance.descriptionInAlternateLanguage,
      'categoryId': instance.categoryId,
      'brandId': instance.brandId,
      'imageUrl': instance.imageUrl,
      'additionalImageUrls': instance.additionalImageUrls,
      'unitOfMeasure': _$UnitOfMeasureEnumMap[instance.unitOfMeasure]!,
      'barcode': instance.barcode,
      'hsn': instance.hsn,
      'taxRate': instance.taxRate,
      'taxGroupId': instance.taxGroupId,
      'taxRateId': instance.taxRateId,
      'shortCode': instance.shortCode,
      'tags': instance.tags,
      'productType': _$ProductTypeEnumMap[instance.productType]!,
      'trackInventory': instance.trackInventory,
      'isActive': instance.isActive,
      'displayOrder': instance.displayOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'availableInPos': instance.availableInPos,
      'availableInOnlineStore': instance.availableInOnlineStore,
      'availableInCatalog': instance.availableInCatalog,
      'skipKot': instance.skipKot,
      'variations': instance.variations,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'hasUnsyncedChanges': instance.hasUnsyncedChanges,
    };

const _$UnitOfMeasureEnumMap = {
  UnitOfMeasure.count: 'count',
  UnitOfMeasure.kg: 'kg',
  UnitOfMeasure.gram: 'gram',
  UnitOfMeasure.liter: 'liter',
  UnitOfMeasure.ml: 'ml',
  UnitOfMeasure.meter: 'meter',
  UnitOfMeasure.cm: 'cm',
  UnitOfMeasure.piece: 'piece',
  UnitOfMeasure.box: 'box',
  UnitOfMeasure.dozen: 'dozen',
  UnitOfMeasure.pack: 'pack',
};

const _$ProductTypeEnumMap = {
  ProductType.physical: 'physical',
  ProductType.service: 'service',
  ProductType.digital: 'digital',
};

_$ProductVariationImpl _$$ProductVariationImplFromJson(
  Map<String, dynamic> json,
) => _$ProductVariationImpl(
  id: json['id'] as String,
  productId: json['productId'] as String,
  name: json['name'] as String,
  sku: json['sku'] as String?,
  mrp: (json['mrp'] as num).toDouble(),
  sellingPrice: (json['sellingPrice'] as num).toDouble(),
  purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
  barcode: json['barcode'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
  isForSale: json['isForSale'] as bool? ?? true,
  isForPurchase: json['isForPurchase'] as bool? ?? false,
  categoryPrices:
      (json['categoryPrices'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  tablePrices:
      (json['tablePrices'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
);

Map<String, dynamic> _$$ProductVariationImplToJson(
  _$ProductVariationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'name': instance.name,
  'sku': instance.sku,
  'mrp': instance.mrp,
  'sellingPrice': instance.sellingPrice,
  'purchasePrice': instance.purchasePrice,
  'barcode': instance.barcode,
  'isDefault': instance.isDefault,
  'isActive': instance.isActive,
  'displayOrder': instance.displayOrder,
  'isForSale': instance.isForSale,
  'isForPurchase': instance.isForPurchase,
  'categoryPrices': instance.categoryPrices,
  'tablePrices': instance.tablePrices,
};
