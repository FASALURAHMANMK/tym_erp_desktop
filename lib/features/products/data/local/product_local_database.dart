import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../../services/sync_queue_service.dart';
import '../../domain/models/product.dart';
import '../../domain/models/product_brand.dart';
import '../../domain/models/product_category.dart';
import '../../domain/models/product_stock.dart';

class ProductLocalDatabase {
  static final _logger = Logger('ProductLocalDatabase');
  final Database database;
  final SyncQueueService syncQueueService;

  ProductLocalDatabase({
    required this.database,
    required this.syncQueueService,
  });

  // Product operations
  Future<List<Product>> getProducts({
    required String businessId,
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? searchQuery,
  }) async {
    String whereClause = 'business_id = ?';
    List<dynamic> whereArgs = [businessId];

    if (categoryId != null) {
      whereClause += ' AND category_id = ?';
      whereArgs.add(categoryId);
    }

    if (brandId != null) {
      whereClause += ' AND brand_id = ?';
      whereArgs.add(brandId);
    }

    if (isActive != null) {
      whereClause += ' AND is_active = ?';
      whereArgs.add(isActive ? 1 : 0);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClause +=
          ' AND (name LIKE ? OR short_code LIKE ? OR barcode LIKE ?)';
      final searchPattern = '%$searchQuery%';
      whereArgs.addAll([searchPattern, searchPattern, searchPattern]);
    }

    final results = await database.query(
      'products',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'display_order ASC, name ASC',
    );

    // Load products with their variations and prices
    final products = <Product>[];
    for (final productJson in results) {
      final product = _productFromLocalJson(productJson);
      final variations = await getProductVariations(product.id);
      products.add(product.copyWith(variations: variations));
    }

    return products;
  }

  Future<Product?> getProductById(String productId) async {
    final results = await database.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final product = _productFromLocalJson(results.first);
    final variations = await getProductVariations(product.id);
    return product.copyWith(variations: variations);
  }

  Future<List<ProductVariation>> getProductVariations(String productId) async {
    final results = await database.query(
      'product_variations',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'display_order ASC, name ASC',
    );

    // Load variations (category price table removed; use selling_price)
    final variations = <ProductVariation>[];
    for (final json in results) {
      final variationId = json['id'] as String;
      // Load table-specific prices for this variation (if any)
      final tablePrices = await _getVariationTablePrices(variationId);

      variations.add(
        _variationFromLocalJson(json, const <String, double>{}, tablePrices),
      );
    }

    return variations;
  }

  // Removed: category price lookup from product_variation_prices

  // Load table-specific price overrides for a variation
  Future<Map<String, double>> _getVariationTablePrices(
    String variationId,
  ) async {
    final results = await database.query(
      'table_price_overrides',
      where: 'variation_id = ? AND is_active = 1',
      whereArgs: [variationId],
    );

    final prices = <String, double>{};
    for (final row in results) {
      final tableId = row['table_id'] as String;
      final price = (row['price'] as num?)?.toDouble() ?? 0.0;
      prices[tableId] = price;
    }

    return prices;
  }

  ProductVariation _variationFromLocalJson(
    Map<String, dynamic> json,
    Map<String, double> categoryPrices,
    Map<String, double> tablePrices,
  ) {
    return ProductVariation(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      barcode: json['barcode'] as String?,
      isDefault: json['is_default'] == 1,
      isActive: json['is_active'] == 1,
      displayOrder: json['display_order'] ?? 0,
      isForSale: json['is_for_sale'] == 1,
      isForPurchase: json['is_for_purchase'] == 1,
      categoryPrices: categoryPrices,
      tablePrices: tablePrices,
    );
  }

  Product _productFromLocalJson(Map<String, dynamic> json) {
    // Parse JSON fields
    final additionalImageUrls =
        json['additional_image_urls'] != null
            ? List<String>.from(jsonDecode(json['additional_image_urls']))
            : <String>[];

    final tags =
        json['tags'] != null
            ? List<String>.from(jsonDecode(json['tags']))
            : <String>[];

    // Convert string enums back to enum values
    final unitOfMeasure = UnitOfMeasure.values.firstWhere(
      (e) => e.name == json['unit_of_measure'],
      orElse: () => UnitOfMeasure.count,
    );

    final productType = ProductType.values.firstWhere(
      (e) => e.name == json['product_type'],
      orElse: () => ProductType.physical,
    );

    return Product(
      id: json['id'],
      businessId: json['business_id'],
      name: json['name'],
      nameInAlternateLanguage: json['name_in_alternate_language'],
      description: json['description'],
      descriptionInAlternateLanguage: json['description_in_alternate_language'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      imageUrl: json['image_url'],
      additionalImageUrls: additionalImageUrls,
      unitOfMeasure: unitOfMeasure,
      barcode: json['barcode'],
      hsn: json['hsn'],
      taxRate: json['tax_rate']?.toDouble() ?? 0.0,
      taxGroupId: json['tax_group_id'],
      taxRateId: json['tax_rate_id'],
      shortCode: json['short_code'],
      tags: tags,
      productType: productType,
      trackInventory: json['track_inventory'] == 1,
      isActive: json['is_active'] == 1,
      displayOrder: json['display_order'] ?? 0,
      availableInPos: json['available_in_pos'] == 1,
      availableInOnlineStore: json['available_in_online_store'] == 1,
      availableInCatalog: json['available_in_catalog'] == 1,
      skipKot: json['skip_kot'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastSyncedAt:
          json['last_synced_at'] != null
              ? DateTime.parse(json['last_synced_at'])
              : null,
      hasUnsyncedChanges: json['has_unsynced_changes'] == 1,
      variations: [], // Will be populated separately
    );
  }

  // Category operations
  Future<List<ProductCategory>> getCategories({
    required String businessId,
    bool? isActive,
  }) async {
    String whereClause = 'business_id = ?';
    List<dynamic> whereArgs = [businessId];

    if (isActive != null) {
      whereClause += ' AND is_active = ?';
      whereArgs.add(isActive ? 1 : 0);
    }

    final results = await database.query(
      'product_categories',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'display_order ASC, name ASC',
    );

    return results.map((json) => _categoryFromLocalJson(json)).toList();
  }

  ProductCategory _categoryFromLocalJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      nameInAlternateLanguage: json['name_in_alternate_language'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      iconName: json['icon_name'] as String?,
      displayOrder: json['display_order'] ?? 0,
      isActive: json['is_active'] == 1,
      parentCategoryId: json['parent_category_id'] as String?,
      defaultKotPrinterId: json['default_kot_printer_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncedAt:
          json['last_synced_at'] != null
              ? DateTime.parse(json['last_synced_at'] as String)
              : null,
      hasUnsyncedChanges: json['has_unsynced_changes'] == 1,
    );
  }

  // Brand operations
  Future<List<ProductBrand>> getBrands({
    required String businessId,
    bool? isActive,
  }) async {
    String whereClause = 'business_id = ?';
    List<dynamic> whereArgs = [businessId];

    if (isActive != null) {
      whereClause += ' AND is_active = ?';
      whereArgs.add(isActive ? 1 : 0);
    }

    final results = await database.query(
      'product_brands',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'display_order ASC, name ASC',
    );

    return results.map((json) => _brandFromLocalJson(json)).toList();
  }

  ProductBrand _brandFromLocalJson(Map<String, dynamic> json) {
    return ProductBrand(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      displayOrder: json['display_order'] ?? 0,
      isActive: json['is_active'] == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncedAt:
          json['last_synced_at'] != null
              ? DateTime.parse(json['last_synced_at'] as String)
              : null,
      hasUnsyncedChanges: json['has_unsynced_changes'] == 1,
    );
  }

  // Stock operations
  Future<List<ProductStock>> getStockLevels({
    required String locationId,
    String? productId,
    bool? lowStockOnly,
  }) async {
    String query = '''
      SELECT ps.*, pv.product_id, pv.name as variation_name
      FROM product_stock ps
      JOIN product_variations pv ON ps.product_variation_id = pv.id
      WHERE ps.location_id = ?
    ''';

    List<dynamic> args = [locationId];

    if (productId != null) {
      query += ' AND pv.product_id = ?';
      args.add(productId);
    }

    if (lowStockOnly == true) {
      query += ' AND ps.current_stock <= ps.alert_quantity';
    }

    query += ' ORDER BY ps.current_stock ASC';

    final results = await database.rawQuery(query, args);

    return results
        .map(
          (json) => ProductStock.fromJson({
            ...json,
            'has_unsynced_changes': json['has_unsynced_changes'] == 1,
          }),
        )
        .toList();
  }

  Future<ProductStock?> getStock({
    required String productVariationId,
    required String locationId,
  }) async {
    final results = await database.query(
      'product_stock',
      where: 'product_variation_id = ? AND location_id = ?',
      whereArgs: [productVariationId, locationId],
      limit: 1,
    );

    if (results.isEmpty) return null;

    return ProductStock.fromJson({
      ...results.first,
      'has_unsynced_changes': results.first['has_unsynced_changes'] == 1,
    });
  }

  // Price management methods

  // Removed: saving category prices to product_variation_prices; use selling_price

  /// Save or update table-specific price overrides
  Future<void> saveTablePrices({
    required String variationId,
    required Map<String, double> tablePrices,
    required String businessId,
  }) async {
    // First, delete existing table prices for this variation
    await database.delete(
      'table_price_overrides',
      where: 'variation_id = ?',
      whereArgs: [variationId],
    );

    // Then insert new prices and queue them for sync
    for (final entry in tablePrices.entries) {
      final tableId = entry.key;
      final price = entry.value;
      final overrideId = const Uuid().v4();
      final now = DateTime.now().toIso8601String();

      final overrideData = {
        'id': overrideId,
        'table_id': tableId,
        'variation_id': variationId,
        'price': price,
        'is_active': 1,
        'created_at': now,
        'updated_at': now,
        'created_by': null, // Let the database use the default or NULL
        'has_unsynced_changes': 1,
      };

      await database.insert(
        'table_price_overrides',
        overrideData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Queue this override for sync
      await syncQueueService.addToQueue(
        'table_price_overrides',
        'INSERT',
        overrideId,
        {
          'id': overrideId,
          'table_id': tableId,
          'variation_id': variationId,
          'price': price,
          'is_active': true,
          'created_at': now,
          'updated_at': now,
          // Don't include created_by field - it will be NULL in database
        },
      );
    }
  }

  /// Delete all prices for a variation (when variation is deleted)
  Future<void> deleteVariationPrices(String variationId) async {
    await database.delete(
      'table_price_overrides',
      where: 'variation_id = ?',
      whereArgs: [variationId],
    );
  }
}
