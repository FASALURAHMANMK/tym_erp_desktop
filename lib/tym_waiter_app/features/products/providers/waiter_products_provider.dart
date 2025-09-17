import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/logger.dart';
import '../../../../features/products/domain/models/product.dart';
import '../../../../features/products/domain/models/product_category.dart';
import '../../auth/providers/waiter_auth_provider.dart';

part 'waiter_products_provider.g.dart';

/// Fetch product categories from Supabase
@riverpod
Future<List<ProductCategory>> waiterProductCategories(Ref ref) async {
  final waiter = ref.watch(currentWaiterProvider);
  if (waiter == null) {
    throw Exception('No waiter logged in');
  }

  final logger = Logger('WaiterProductCategoriesProvider');
  final supabase = Supabase.instance.client;

  try {
    logger.info('Fetching product categories for business: ${waiter.businessId}');

    final response = await supabase
        .from('product_categories')
        .select()
        .eq('business_id', waiter.businessId)
        .eq('is_active', true)
        .order('display_order', ascending: true)
        .order('name', ascending: true);

    logger.info('Fetched ${response.length} categories');

    return (response as List)
        .map((json) => ProductCategory.fromJson(_convertCategoryFromSupabase(json)))
        .toList();
  } catch (e) {
    logger.error('Error fetching product categories', e);
    throw Exception('Failed to load categories: $e');
  }
}

/// Fetch products by category from Supabase
@riverpod
Future<List<Product>> waiterProductsByCategory(
  Ref ref,
  String? categoryId,
) async {
  final waiter = ref.watch(currentWaiterProvider);
  if (waiter == null) {
    throw Exception('No waiter logged in');
  }

  final logger = Logger('WaiterProductsByCategoryProvider');
  final supabase = Supabase.instance.client;

  try {
    logger.info('Fetching products for waiter ${waiter.displayName} (${waiter.employeeCode}), business: ${waiter.businessId}, category: $categoryId');

    // Build query
    var query = supabase
        .from('products')
        .select('''
          *,
          product_variations(*)
        ''')
        .eq('business_id', waiter.businessId)
        .eq('is_active', true);

    // Filter by category if provided
    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.eq('category_id', categoryId);
    }

    // Order by name
    final response = await query.order('name', ascending: true);

    logger.info('Query executed. Response type: ${response.runtimeType}, length: ${response.length}');
    logger.info('Fetched ${response.length} products for business ${waiter.businessId}');
    
    if (response.isEmpty) {
      logger.warning('No products found in Supabase for business ${waiter.businessId}');
      logger.info('Check: 1) Products are synced, 2) RLS policies allow employee access, 3) Business ID matches');
      
      // Try a simple test query
      try {
        final testQuery = await supabase
            .from('products')
            .select('id, name, business_id')
            .limit(1);
        logger.info('Test query result (any product): ${testQuery.isNotEmpty ? "Found products" : "No products at all"}');
      } catch (e) {
        logger.error('Test query failed', e);
      }
    }

    // Parse products with variations
    final products = <Product>[];
    for (final productJson in response as List) {
      try {
        // Convert snake_case fields from Supabase to camelCase for the model
        final convertedJson = _convertFromSupabaseFormat(productJson);
        
        // Parse product with converted JSON
        final product = Product.fromJson(convertedJson);
        
        // Get variations from the product
        final variations = product.variations;
        
        // Only add products with active variations
        if (variations.isNotEmpty) {
          products.add(product);
          logger.debug('Added product: ${product.name} with ${variations.length} variations');
        } else {
          logger.warning('Skipping product ${product.name} - no variations');
        }
      } catch (e, stack) {
        logger.error('Failed to parse product', e, stack);
        logger.error('Product JSON was: $productJson');
      }
    }

    logger.info('Returning ${products.length} products after parsing');
    return products;
  } catch (e) {
    logger.error('Error fetching products', e);
    throw Exception('Failed to load products: $e');
  }
}

/// Search products by name or SKU
@riverpod
Future<List<Product>> waiterProductSearch(
  Ref ref,
  String searchQuery,
) async {
  if (searchQuery.isEmpty) return [];

  final waiter = ref.watch(currentWaiterProvider);
  if (waiter == null) {
    throw Exception('No waiter logged in');
  }

  final logger = Logger('WaiterProductSearchProvider');
  final supabase = Supabase.instance.client;

  try {
    logger.info('Searching products for: $searchQuery');

    // Search in products and variations
    final response = await supabase
        .from('products')
        .select('''
          *,
          product_variations(*)
        ''')
        .eq('business_id', waiter.businessId)
        .eq('is_active', true)
        .or('name.ilike.%$searchQuery%,sku.ilike.%$searchQuery%,barcode.ilike.%$searchQuery%')
        .order('name', ascending: true)
        .limit(20);

    logger.info('Found ${response.length} products');

    // Parse products with variations
    final products = <Product>[];
    for (final productJson in response as List) {
      // Parse product directly (variations are included)
      final product = Product.fromJson(productJson);
      
      // Get variations from the product
      final variations = product.variations;
      
      // Only add products with active variations
      if (variations.isNotEmpty) {
        products.add(product);
      }
    }

    return products;
  } catch (e) {
    logger.error('Error searching products', e);
    throw Exception('Failed to search products: $e');
  }
}

/// Get variation prices for the dine-in price category
@riverpod
Future<Map<String, double>> waiterVariationPrices(Ref ref) async {
  final waiter = ref.watch(currentWaiterProvider);
  if (waiter == null) {
    throw Exception('No waiter logged in');
  }

  final logger = Logger('WaiterVariationPricesProvider');
  final supabase = Supabase.instance.client;

  try {
    // First get the dine-in price category for this location
    final locationId = ref.read(waiterSelectedLocationProvider)?.id;
    if (locationId == null) {
      logger.warning('No location selected, using default prices');
      return {};
    }

    // Get price category for dine-in
    final priceCategoryResponse = await supabase
        .from('price_categories')
        .select()
        .eq('business_id', waiter.businessId)
        .eq('location_id', locationId)
        .eq('type', 'dine_in')
        .eq('is_active', true)
        .single();

    final priceCategoryId = priceCategoryResponse['id'] as String;
    
    logger.info('Using dine-in price category: $priceCategoryId');

    // Get all variation prices for this category
    final pricesResponse = await supabase
        .from('product_variation_prices')
        .select()
        .eq('price_category_id', priceCategoryId)
        .eq('is_active', true);

    // Create a map of variation_id -> price
    final priceMap = <String, double>{};
    for (final priceData in pricesResponse as List) {
      final variationId = priceData['variation_id'] as String;
      final price = (priceData['price'] as num).toDouble();
      priceMap[variationId] = price;
    }

    logger.info('Loaded prices for ${priceMap.length} variations');
    return priceMap;
  } catch (e) {
    logger.error('Error fetching variation prices', e);
    // Return empty map on error - products will use their default prices
    return {};
  }
}

/// Selected location provider for waiter (from waiter_location_provider)
final waiterSelectedLocationProvider = StateProvider<dynamic>((ref) {
  // This will be set from the waiter location provider
  return null;
});

/// Convert snake_case fields from Supabase to camelCase for the Product model
Map<String, dynamic> _convertFromSupabaseFormat(Map<String, dynamic> data) {
  // Convert product fields
  final converted = {
    'id': data['id'],
    'businessId': data['business_id'],
    'name': data['name'],
    'nameInAlternateLanguage': data['name_in_alternate_language'],
    'description': data['description'],
    'descriptionInAlternateLanguage': data['description_in_alternate_language'],
    'categoryId': data['category_id'],
    'brandId': data['brand_id'],
    'imageUrl': data['image_url'],
    'additionalImageUrls': data['additional_image_urls'] ?? [],
    'unitOfMeasure': data['unit_of_measure'],
    'barcode': data['barcode'],
    'hsn': data['hsn'],
    'taxRate': data['tax_rate'],
    'shortCode': data['short_code'],
    'tags': data['tags'] ?? [],
    'productType': data['product_type'],
    'trackInventory': data['track_inventory'],
    'isActive': data['is_active'],
    'displayOrder': data['display_order'],
    'availableInPos': data['available_in_pos'],
    'availableInOnlineStore': data['available_in_online_store'],
    'availableInCatalog': data['available_in_catalog'],
    'skipKot': data['skip_kot'],
    'createdAt': data['created_at'],
    'updatedAt': data['updated_at'],
    'lastSyncedAt': data['last_synced_at'],
    'hasUnsyncedChanges': data['has_unsynced_changes'],
    'taxGroupId': data['tax_group_id'],
    'taxRateId': data['tax_rate_id'],
    // SKU is required, provide default if null
    'sku': data['sku'] ?? 'SKU-${data['id']?.toString().substring(0, 8) ?? 'unknown'}',
  };
  
  // Convert variations if present
  if (data['product_variations'] != null) {
    converted['variations'] = (data['product_variations'] as List)
        .map((v) => _convertVariationFromSupabase(v))
        .toList();
  } else {
    converted['variations'] = [];
  }
  
  return converted;
}

/// Convert variation fields from snake_case to camelCase
Map<String, dynamic> _convertVariationFromSupabase(Map<String, dynamic> data) {
  return {
    'id': data['id'],
    'productId': data['product_id'],
    'sku': data['sku'] ?? 'SKU-${data['id']?.toString().substring(0, 8) ?? 'unknown'}',
    'name': data['name'],
    'barcode': data['barcode'],
    'price': data['price'] ?? data['selling_price'] ?? 0.0,
    'sellingPrice': data['selling_price'] ?? 0.0,
    'purchasePrice': data['purchase_price'],
    'compareAtPrice': data['compare_at_price'],
    'cost': data['cost'] ?? 0.0,
    'mrp': data['mrp'] ?? 0.0,
    'weight': data['weight'],
    'weightUnit': data['weight_unit'],
    'inventoryQuantity': data['inventory_quantity'] ?? 0,
    'lowStockAlertQuantity': data['low_stock_alert_quantity'] ?? 10,
    'trackInventory': data['track_inventory'] ?? false,
    'isDefault': data['is_default'] ?? false,
    'isActive': data['is_active'] ?? true,
    'isForSale': data['is_for_sale'] ?? true,
    'isForPurchase': data['is_for_purchase'] ?? false,
    'displayOrder': data['display_order'] ?? 0,
    'createdAt': data['created_at'],
    'updatedAt': data['updated_at'],
  };
}

/// Convert category fields from snake_case to camelCase
Map<String, dynamic> _convertCategoryFromSupabase(Map<String, dynamic> data) {
  return {
    'id': data['id'],
    'businessId': data['business_id'],
    'name': data['name'],
    'nameInAlternateLanguage': data['name_in_alternate_language'],
    'description': data['description'],
    'parentCategoryId': data['parent_category_id'],
    'imageUrl': data['image_url'],
    'iconName': data['icon_name'],
    'colorHex': data['color_hex'],
    'displayOrder': data['display_order'],
    'isActive': data['is_active'] ?? true,
    'availableInPos': data['available_in_pos'] ?? true,
    'availableInOnlineStore': data['available_in_online_store'] ?? false,
    'defaultKotPrinterId': data['default_kot_printer_id'],
    'createdAt': data['created_at'],
    'updatedAt': data['updated_at'],
  };
}