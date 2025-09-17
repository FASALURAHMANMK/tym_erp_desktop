import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/exceptions/offline_first_exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../../../services/sync_queue_service.dart';
import '../../domain/models/product.dart';
import '../../domain/models/product_brand.dart';
import '../../domain/models/product_category.dart';
import '../../domain/models/product_stock.dart';
import '../../domain/repositories/product_repository.dart';
import '../local/product_local_database.dart';

class OfflineFirstProductRepository implements ProductRepository {
  final SupabaseClient _supabase;
  final ProductLocalDatabase _localDatabase;
  final SyncQueueService _syncQueueService;
  final Logger _logger;
  final _uuid = const Uuid();

  OfflineFirstProductRepository({
    required SupabaseClient supabase,
    required ProductLocalDatabase localDatabase,
    required SyncQueueService syncQueueService,
    required Logger logger,
  }) : _supabase = supabase,
       _localDatabase = localDatabase,
       _syncQueueService = syncQueueService,
       _logger = logger;

  // Product operations
  @override
  Future<Either<OfflineFirstException, List<Product>>> getProducts({
    required String businessId,
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? searchQuery,
  }) async {
    try {
      // Always get from local database first
      final localProducts = await _localDatabase.getProducts(
        businessId: businessId,
        categoryId: categoryId,
        brandId: brandId,
        isActive: isActive,
        searchQuery: searchQuery,
      );

      // Get variations for each product
      final productsWithVariations = <Product>[];
      for (final product in localProducts) {
        final variations = await _localDatabase.getProductVariations(
          product.id,
        );
        productsWithVariations.add(product.copyWith(variations: variations));
      }

      return Right(productsWithVariations);
    } catch (e) {
      _logger.error('Error getting products', e);
      return Left(
        LocalDatabaseException(
          'Failed to get products',
          'getProducts',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, Product>> getProductById(
    String productId,
  ) async {
    try {
      final product = await _localDatabase.getProductById(productId);
      if (product == null) {
        return Left(
          ValidationException(
            'Product not found',
            'getProductById',
            fieldName: 'productId',
            fieldValue: productId,
          ),
        );
      }

      final variations = await _localDatabase.getProductVariations(productId);
      return Right(product.copyWith(variations: variations));
    } catch (e) {
      _logger.error('Error getting product by ID', e);
      return Left(
        LocalDatabaseException(
          'Failed to get product',
          'getProductById',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, Product>> createProduct(
    Product product,
  ) async {
    try {
      final now = DateTime.now();
      final productId = product.id.isEmpty ? _uuid.v4() : product.id;
      
      // Generate IDs for variations if they don't have them
      final variationsWithIds = product.variations.map((variation) {
        return variation.copyWith(
          id: variation.id.isEmpty ? _uuid.v4() : variation.id,
          productId: productId,
        );
      }).toList();
      
      final newProduct = product.copyWith(
        id: productId,
        variations: variationsWithIds,
        createdAt: now,
        updatedAt: now,
        hasUnsyncedChanges: true,
      );

      // Ensure at least one variation exists
      if (newProduct.variations.isEmpty) {
        throw ArgumentError('Product must have at least one variation');
      }

      // Save to local database with transaction
      await _localDatabase.database.transaction((txn) async {
        // Save product
        await txn.insert(
          'products',
          _productToDatabase(newProduct),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Save variations
        for (final variation in newProduct.variations) {
          await txn.insert(
            'product_variations',
            _variationToDatabase(variation),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      
      // Save variation prices (outside transaction to avoid deadlocks)
      for (final variation in newProduct.variations) {
        // Category-based prices removed; keep table-specific overrides
        if (variation.tablePrices.isNotEmpty) {
          await _localDatabase.saveTablePrices(
            variationId: variation.id,
            tablePrices: variation.tablePrices,
            businessId: newProduct.businessId,
          );
        }
      }

      // Queue for sync
      await _syncQueueService.addToQueue(
        'products',
        'CREATE',
        newProduct.id,
        newProduct.toJson(),
      );
      
      // Queue variations for sync
      for (final variation in newProduct.variations) {
        await _syncQueueService.addToQueue(
          'product_variations',
          'CREATE',
          variation.id,
          {
            'id': variation.id,
            'product_id': variation.productId,
            'name': variation.name,
            'sku': variation.sku?.isNotEmpty == true ? variation.sku : 'SKU-${variation.id.substring(0, 8)}', // Generate SKU if empty
            'mrp': variation.mrp, // MRP is required, no need for fallback
            'selling_price': variation.sellingPrice,
            'purchase_price': variation.purchasePrice,
            'barcode': variation.barcode,
            'is_default': variation.isDefault,
            'is_for_sale': variation.isForSale,
            'is_for_purchase': variation.isForPurchase,
            'is_active': variation.isActive,
            'display_order': variation.displayOrder,
          },
        );
      }

      return Right(newProduct);
    } catch (e) {
      _logger.error('Error creating product', e);
      return Left(
        LocalDatabaseException(
          'Failed to create product',
          'createProduct',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, Product>> updateProduct(
    Product product,
  ) async {
    try {
      // Find removed variations (for proper cloud deletion when needed)
      final existingVariations = await _localDatabase.getProductVariations(product.id);
      final existingIds = existingVariations.map((v) => v.id).toSet();

      // Ensure variations have proper IDs
      final variationsWithIds = product.variations.map((variation) {
        return variation.copyWith(
          id: variation.id.isEmpty ? _uuid.v4() : variation.id,
          productId: product.id,
        );
      }).toList();
      
      final updatedProduct = product.copyWith(
        variations: variationsWithIds,
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );

      // Update in local database with transaction
      await _localDatabase.database.transaction((txn) async {
        // Update product
        await txn.update(
          'products',
          _productToDatabase(updatedProduct),
          where: 'id = ?',
          whereArgs: [updatedProduct.id],
        );

        // Delete existing variations
        await txn.delete(
          'product_variations',
          where: 'product_id = ?',
          whereArgs: [updatedProduct.id],
        );

        // Insert updated variations
        for (final variation in updatedProduct.variations) {
          await txn.insert(
            'product_variations',
            _variationToDatabase(variation),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      // Queue deletes for variations that were removed
      try {
        final newIds = updatedProduct.variations.map((v) => v.id).toSet();
        final removed = existingIds.difference(newIds);
        for (final removedId in removed) {
          await _syncQueueService.addToQueue(
            'product_variations',
            'DELETE',
            removedId,
            {'id': removedId},
          );
        }
      } catch (e) {
        _logger.warning('Failed to queue removed variations for delete: $e');
      }
      
      // Save table-specific prices (outside transaction to avoid deadlocks)
      for (final variation in updatedProduct.variations) {
        if (variation.tablePrices.isNotEmpty) {
          await _localDatabase.saveTablePrices(
            variationId: variation.id,
            tablePrices: variation.tablePrices,
            businessId: updatedProduct.businessId,
          );
        }
      }

      // Queue for sync
      await _syncQueueService.addToQueue(
        'products',
        'UPDATE',
        updatedProduct.id,
        updatedProduct.toJson(),
      );
      
      // Queue variations for sync
      for (final variation in updatedProduct.variations) {
        await _syncQueueService.addToQueue(
          'product_variations',
          'UPDATE',
          variation.id,
          {
            'id': variation.id,
            'product_id': variation.productId,
            'name': variation.name,
            'sku': variation.sku?.isNotEmpty == true ? variation.sku : 'SKU-${variation.id.substring(0, 8)}', // Generate SKU if empty
            'mrp': variation.mrp, // MRP is required, no need for fallback
            'selling_price': variation.sellingPrice,
            'purchase_price': variation.purchasePrice,
            'barcode': variation.barcode,
            'is_default': variation.isDefault,
            'is_for_sale': variation.isForSale,
            'is_for_purchase': variation.isForPurchase,
            'is_active': variation.isActive,
            'display_order': variation.displayOrder,
          },
        );
      }

      return Right(updatedProduct);
    } catch (e) {
      _logger.error('Error updating product', e);
      return Left(
        LocalDatabaseException(
          'Failed to update product',
          'updateProduct',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, void>> deleteProduct(
    String productId,
  ) async {
    try {
      // Soft delete by marking as inactive
      await _localDatabase.database.update(
        'products',
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [productId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue('products', 'DELETE', productId, {
        'id': productId,
      });

      return const Right(null);
    } catch (e) {
      _logger.error('Error deleting product', e);
      return Left(
        LocalDatabaseException(
          'Failed to delete product',
          'deleteProduct',
          originalError: e,
        ),
      );
    }
  }

  // Product variation operations
  @override
  Future<Either<OfflineFirstException, Product>> addProductVariation({
    required String productId,
    required ProductVariation variation,
  }) async {
    try {
      // Get existing product
      final productResult = await getProductById(productId);
      if (productResult.isLeft()) {
        return Left(
          ValidationException(
            'Product not found',
            'getProductById',
            fieldName: 'productId',
            fieldValue: productId,
          ),
        );
      }

      final product = productResult.getOrElse(() => throw Exception());

      // Add new variation
      final newVariation = variation.copyWith(
        id:
            variation.id.isEmpty
                ? _uuid.v4()
                : variation.id,
        productId: productId,
        displayOrder: product.variations.length,
      );

      final updatedVariations = [...product.variations, newVariation];
      final updatedProduct = product.copyWith(
        variations: updatedVariations,
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );

      // Save to database
      await _localDatabase.database.insert(
        'product_variations',
        _variationToDatabase(newVariation),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      // Save table-specific prices
      if (newVariation.tablePrices.isNotEmpty) {
        await _localDatabase.saveTablePrices(
          variationId: newVariation.id,
          tablePrices: newVariation.tablePrices,
          businessId: product.businessId,
        );
      }

      // Update product to mark as changed
      await _localDatabase.database.update(
        'products',
        {
          'updated_at': updatedProduct.updatedAt.toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [productId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_variations',
        'CREATE',
        newVariation.id,
        newVariation.toJson(),
      );

      return Right(updatedProduct);
    } catch (e) {
      _logger.error('Error adding product variation', e);
      return Left(
        LocalDatabaseException(
          'Failed to add product variation',
          'addProductVariation',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, Product>> updateProductVariation({
    required String productId,
    required ProductVariation variation,
  }) async {
    try {
      // Update variation
      await _localDatabase.database.update(
        'product_variations',
        _variationToDatabase(variation),
        where: 'id = ?',
        whereArgs: [variation.id],
      );
      
      // Get the business ID from the product
      final productResult = await getProductById(productId);
      if (productResult.isRight()) {
        final product = productResult.getOrElse(() => throw Exception());
        
        // Update table-specific prices
        if (variation.tablePrices.isNotEmpty) {
          await _localDatabase.saveTablePrices(
            variationId: variation.id,
            tablePrices: variation.tablePrices,
            businessId: product.businessId,
          );
        }
      }

      // Update product timestamp
      await _localDatabase.database.update(
        'products',
        {
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [productId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_variations',
        'UPDATE',
        variation.id,
        variation.toJson(),
      );

      // Return updated product
      return getProductById(productId);
    } catch (e) {
      _logger.error('Error updating product variation', e);
      return Left(
        LocalDatabaseException(
          'Failed to update product variation',
          'updateProductVariation',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, Product>> deleteProductVariation({
    required String productId,
    required String variationId,
  }) async {
    try {
      // Get product to check variation count
      final productResult = await getProductById(productId);
      if (productResult.isLeft()) {
        return Left(
          ValidationException(
            'Product not found',
            'getProductById',
            fieldName: 'productId',
            fieldValue: productId,
          ),
        );
      }

      final product = productResult.getOrElse(() => throw Exception());

      // Don't allow deleting the last variation
      if (product.variations.length <= 1) {
        return Left(
          ValidationException(
            'Cannot delete the last variation',
            'deleteProductVariation',
            fieldName: 'variationCount',
            fieldValue: product.variations.length,
          ),
        );
      }

      // Delete variation
      await _localDatabase.database.delete(
        'product_variations',
        where: 'id = ?',
        whereArgs: [variationId],
      );
      
      // Delete all prices for this variation
      await _localDatabase.deleteVariationPrices(variationId);

      // Update product timestamp
      await _localDatabase.database.update(
        'products',
        {
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [productId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_variations',
        'DELETE',
        variationId,
        {'id': variationId},
      );

      // Return updated product
      return getProductById(productId);
    } catch (e) {
      _logger.error('Error deleting product variation', e);
      return Left(
        LocalDatabaseException(
          'Failed to delete product variation',
          'deleteProductVariation',
          originalError: e,
        ),
      );
    }
  }

  // Category operations
  @override
  Future<Either<OfflineFirstException, List<ProductCategory>>> getCategories({
    required String businessId,
    bool? isActive,
  }) async {
    try {
      final categories = await _localDatabase.getCategories(
        businessId: businessId,
        isActive: isActive,
      );
      return Right(categories);
    } catch (e) {
      _logger.error('Error getting categories', e);
      return Left(
        LocalDatabaseException(
          'Failed to get categories',
          'getCategories',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, ProductCategory>> createCategory(
    ProductCategory category,
  ) async {
    try {
      final now = DateTime.now();
      final newCategory = category.copyWith(
        id: category.id.isEmpty ? _uuid.v4() : category.id,
        createdAt: now,
        updatedAt: now,
        hasUnsyncedChanges: true,
      );

      // Save to local database
      await _localDatabase.database.insert(
        'product_categories',
        _categoryToDatabase(newCategory),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_categories',
        'CREATE',
        newCategory.id,
        newCategory.toJson(),
      );

      return Right(newCategory);
    } catch (e) {
      _logger.error('Error creating category', e);
      return Left(
        LocalDatabaseException(
          'Failed to create category',
          'createCategory',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, ProductCategory>> updateCategory(
    ProductCategory category,
  ) async {
    try {
      final updatedCategory = category.copyWith(
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );

      await _localDatabase.database.update(
        'product_categories',
        _categoryToDatabase(updatedCategory),
        where: 'id = ?',
        whereArgs: [updatedCategory.id],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_categories',
        'UPDATE',
        updatedCategory.id,
        updatedCategory.toJson(),
      );

      return Right(updatedCategory);
    } catch (e) {
      _logger.error('Error updating category', e);
      return Left(
        LocalDatabaseException(
          'Failed to update category',
          'updateCategory',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, void>> deleteCategory(
    String categoryId,
  ) async {
    try {
      // Check if category has products
      final products = await _localDatabase.getProducts(
        businessId: '', // Will be filtered by categoryId
        categoryId: categoryId,
      );

      if (products.isNotEmpty) {
        return Left(
          ValidationException(
            'Cannot delete category with products',
            'deleteCategory',
            fieldName: 'productCount',
            fieldValue: products.length,
          ),
        );
      }

      // Soft delete
      await _localDatabase.database.update(
        'product_categories',
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [categoryId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_categories',
        'DELETE',
        categoryId,
        {'id': categoryId},
      );

      return const Right(null);
    } catch (e) {
      _logger.error('Error deleting category', e);
      return Left(
        LocalDatabaseException(
          'Failed to delete category',
          'deleteCategory',
          originalError: e,
        ),
      );
    }
  }

  // Brand operations
  @override
  Future<Either<OfflineFirstException, List<ProductBrand>>> getBrands({
    required String businessId,
    bool? isActive,
  }) async {
    try {
      final brands = await _localDatabase.getBrands(
        businessId: businessId,
        isActive: isActive,
      );
      return Right(brands);
    } catch (e) {
      _logger.error('Error getting brands', e);
      return Left(
        LocalDatabaseException(
          'Failed to get brands',
          'getBrands',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, ProductBrand>> createBrand(
    ProductBrand brand,
  ) async {
    try {
      final now = DateTime.now();
      final newBrand = brand.copyWith(
        id: brand.id.isEmpty ? _uuid.v4() : brand.id,
        createdAt: now,
        updatedAt: now,
        hasUnsyncedChanges: true,
      );

      // Save to local database
      await _localDatabase.database.insert(
        'product_brands',
        _brandToDatabase(newBrand),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_brands',
        'CREATE',
        newBrand.id,
        newBrand.toJson(),
      );

      return Right(newBrand);
    } catch (e) {
      _logger.error('Error creating brand', e);
      return Left(
        LocalDatabaseException(
          'Failed to create brand',
          'createBrand',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, ProductBrand>> updateBrand(
    ProductBrand brand,
  ) async {
    try {
      final updatedBrand = brand.copyWith(
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );

      await _localDatabase.database.update(
        'product_brands',
        _brandToDatabase(updatedBrand),
        where: 'id = ?',
        whereArgs: [updatedBrand.id],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_brands',
        'UPDATE',
        updatedBrand.id,
        updatedBrand.toJson(),
      );

      return Right(updatedBrand);
    } catch (e) {
      _logger.error('Error updating brand', e);
      return Left(
        LocalDatabaseException(
          'Failed to update brand',
          'updateBrand',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, void>> deleteBrand(
    String brandId,
  ) async {
    try {
      // Check if brand has products
      final products = await _localDatabase.getProducts(
        businessId: '', // Will be filtered by brandId
        brandId: brandId,
      );

      if (products.isNotEmpty) {
        return Left(
          ValidationException(
            'Cannot delete brand with products',
            'deleteBrand',
            fieldName: 'productCount',
            fieldValue: products.length,
          ),
        );
      }

      // Soft delete
      await _localDatabase.database.update(
        'product_brands',
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [brandId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue('product_brands', 'DELETE', brandId, {
        'id': brandId,
      });

      return const Right(null);
    } catch (e) {
      _logger.error('Error deleting brand', e);
      return Left(
        LocalDatabaseException(
          'Failed to delete brand',
          'deleteBrand',
          originalError: e,
        ),
      );
    }
  }

  // Stock operations
  @override
  Future<Either<OfflineFirstException, List<ProductStock>>> getStockLevels({
    required String locationId,
    String? productId,
    bool? lowStockOnly,
  }) async {
    try {
      final stockLevels = await _localDatabase.getStockLevels(
        locationId: locationId,
        productId: productId,
        lowStockOnly: lowStockOnly,
      );
      return Right(stockLevels);
    } catch (e) {
      _logger.error('Error getting stock levels', e);
      return Left(
        LocalDatabaseException(
          'Failed to get stock levels',
          'getStockLevels',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, ProductStock>> updateStock({
    required String productVariationId,
    required String locationId,
    required double quantity,
    required String operation,
  }) async {
    try {
      // Get existing stock or create new
      var stock = await _localDatabase.getStock(
        productVariationId: productVariationId,
        locationId: locationId,
      );

      final now = DateTime.now();
      // Create new stock entry if doesn't exist
      stock ??= ProductStock(
        id: _uuid.v4(),
        productVariationId: productVariationId,
        locationId: locationId,
        currentStock: 0,
        lastUpdated: now,
      );

      // Calculate new stock based on operation
      double newStock;
      switch (operation) {
        case 'set':
          newStock = quantity;
          break;
        case 'add':
          newStock = stock.currentStock + quantity;
          break;
        case 'subtract':
          newStock = stock.currentStock - quantity;
          break;
        default:
          throw ArgumentError('Invalid stock operation: $operation');
      }

      // Update stock
      final updatedStock = stock.copyWith(
        currentStock: newStock,
        lastUpdated: now,
        hasUnsyncedChanges: true,
      );

      // Save to database
      await _localDatabase.database.insert(
        'product_stock',
        updatedStock.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_stock',
        stock.id == updatedStock.id ? 'UPDATE' : 'CREATE',
        updatedStock.id,
        updatedStock.toJson(),
      );

      return Right(updatedStock);
    } catch (e) {
      _logger.error('Error updating stock', e);
      return Left(
        LocalDatabaseException(
          'Failed to update stock',
          'updateStock',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, void>> setStockAlertLevel({
    required String productVariationId,
    required String locationId,
    required double alertQuantity,
  }) async {
    try {
      await _localDatabase.database.update(
        'product_stock',
        {'alert_quantity': alertQuantity, 'has_unsynced_changes': 1},
        where: 'product_variation_id = ? AND location_id = ?',
        whereArgs: [productVariationId, locationId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_stock',
        'UPDATE',
        '${productVariationId}_$locationId',
        {
          'product_variation_id': productVariationId,
          'location_id': locationId,
          'alert_quantity': alertQuantity,
        },
      );

      return const Right(null);
    } catch (e) {
      _logger.error('Error setting stock alert level', e);
      return Left(
        LocalDatabaseException(
          'Failed to set stock alert level',
          'setStockAlertLevel',
          originalError: e,
        ),
      );
    }
  }

  // Sync operations
  @override
  Future<Either<OfflineFirstException, void>> syncProducts({
    required String businessId,
  }) async {
    try {
      // TODO: Implement proper sync logic
      // For now, sync is handled through the sync queue
      // Individual operations are queued and will be synced when online

      // In the future, implement:
      // 1. Get pending items from sync queue
      // 2. Process each item based on operation type
      // 3. Handle conflicts and retries
      // 4. Update local database with synced status

      return const Right(null);
    } catch (e) {
      _logger.error('Error syncing products', e);
      return Left(
        SyncException(
          'Failed to sync products',
          'syncProducts',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<OfflineFirstException, void>> syncPendingChanges() async {
    try {
      _logger.info('Starting sync of pending product changes');

      // Get all pending changes from sync queue
      final pendingChanges = await _syncQueueService.getPendingItems();

      for (final item in pendingChanges) {
        // Skip non-product items - they'll be handled by their own sync services
        final tableName = item['table_name'] as String;
        if (!['product_categories', 'product_brands', 'products', 'product_variations', 'product_stock'].contains(tableName)) {
          continue; // Skip items that aren't product-related
        }
        
        // Skip items that have failed too many times
        final retryCount = item['retry_count'] as int? ?? 0;
        if (retryCount >= 5) {
          _logger.warning('Skipping sync item ${item['id']} - too many retries ($retryCount)');
          continue;
        }
        
        try {
          switch (tableName) {
            case 'product_categories':
              await _syncCategory(item);
              break;
            case 'product_brands':
              await _syncBrand(item);
              break;
            case 'products':
              await _syncProduct(item);
              break;
            case 'product_variations':
              await _syncVariation(item);
              break;
            case 'product_stock':
              await _syncStock(item);
              break;
            default:
              // This shouldn't happen due to the filter above, but just in case
              _logger.warning('Unknown table in product sync: $tableName');
              continue;
          }

          // Mark as synced only if we processed it
          await _syncQueueService.removeItem(item['id']);
        } catch (e) {
          _logger.error('Error syncing item ${item['id']}', e);
          // Update retry count
          await _syncQueueService.updateRetryCount(item['id'], e.toString());
          // Continue with other items
        }
      }

      return const Right(null);
    } catch (e) {
      _logger.error('Error syncing pending changes', e);
      return Left(
        SyncException(
          'Failed to sync pending changes',
          'syncPendingChanges',
          originalError: e,
        ),
      );
    }
  }

  Future<void> _syncCategory(Map<String, dynamic> syncItem) async {
    switch (syncItem['operation']) {
      case 'DELETE':
        await _supabase
            .from('product_categories')
            .delete()
            .eq('id', syncItem['record_id']);
        return;
    }

    // For CREATE/UPDATE operations
    Map<String, dynamic> data;
    try {
      // Try to parse as JSON
      data = jsonDecode(syncItem['data']);
    } catch (e) {
      // If JSON decode fails, skip this item as it's old format
      _logger.error('Skipping old format sync item: ${syncItem['id']}');
      return;
    }

    // Convert to Supabase format (snake_case field names)
    final supabaseData = {
      'id': data['id'],
      'business_id': data['businessId'] ?? data['business_id'],
      'name': data['name'],
      'name_in_alternate_language': data['nameInAlternateLanguage'] ?? data['name_in_alternate_language'],
      'description': data['description'],
      'image_url': data['imageUrl'] ?? data['image_url'],
      'icon_name': data['iconName'] ?? data['icon_name'],
      'display_order': data['displayOrder'] ?? data['display_order'] ?? 0,
      'is_active': data['isActive'] ?? data['is_active'] ?? true,
      'parent_category_id': data['parentCategoryId'] ?? data['parent_category_id'],
      'default_kot_printer_id': data['defaultKotPrinterId'] ?? data['default_kot_printer_id'],
      'created_at': data['createdAt'] ?? data['created_at'],
      'updated_at': data['updatedAt'] ?? data['updated_at'],
    };

    await _supabase.from('product_categories').upsert(supabaseData);
  }

  Future<void> _syncBrand(Map<String, dynamic> syncItem) async {
    switch (syncItem['operation']) {
      case 'DELETE':
        await _supabase
            .from('product_brands')
            .delete()
            .eq('id', syncItem['record_id']);
        return;
    }

    // For CREATE/UPDATE operations
    Map<String, dynamic> data;
    try {
      data = jsonDecode(syncItem['data']);
    } catch (e) {
      _logger.error('Skipping old format sync item: ${syncItem['id']}');
      return;
    }

    // Convert to Supabase format (snake_case field names)
    final supabaseData = {
      'id': data['id'],
      'business_id': data['businessId'] ?? data['business_id'],
      'name': data['name'],
      'description': data['description'],
      'logo_url': data['logoUrl'] ?? data['logo_url'],
      'display_order': data['displayOrder'] ?? data['display_order'] ?? 0,
      'is_active': data['isActive'] ?? data['is_active'] ?? true,
      'created_at': data['createdAt'] ?? data['created_at'],
      'updated_at': data['updatedAt'] ?? data['updated_at'],
    };

    await _supabase.from('product_brands').upsert(supabaseData);
  }

  Future<void> _syncProduct(Map<String, dynamic> syncItem) async {
    final data = jsonDecode(syncItem['data']);
    final productData = Map<String, dynamic>.from(data);
    
    _logger.info('Syncing product ${syncItem['record_id']} - ${syncItem['operation']}');
    
    // Extract variations
    final variations = productData.remove('variations') as List<dynamic>?;
    
    // Convert to snake_case for Supabase
    final supabaseData = _productToSupabaseFormat(productData);

    switch (syncItem['operation']) {
      case 'CREATE':
      case 'UPDATE':
        // Sync product
        await _supabase.from('products').upsert(supabaseData);
        
        // Sync variations if present
        if (variations != null && variations.isNotEmpty) {
          _logger.info('Syncing ${variations.length} variations for product ${syncItem['record_id']}');
          
          final variationData = variations.map((v) {
            final varData = Map<String, dynamic>.from(v);
            final formatted = _variationToSupabaseFormat(varData);
            _logger.info('Variation SKU: ${formatted['sku']}, Name: ${formatted['name']}');
            return formatted;
          }).toList();
          
          try {
            // Always delete existing variations first to ensure clean state
            await _supabase
                .from('product_variations')
                .delete()
                .eq('product_id', syncItem['record_id']);
            
            // Insert new variations
            await _supabase.from('product_variations').insert(variationData);
            _logger.info('Successfully synced variations for product ${syncItem['record_id']}');
          } catch (e) {
            _logger.error('Error syncing variations: $e');
            rethrow;
          }
        }
        break;
      case 'DELETE':
        // Delete variations first (cascade)
        await _supabase
            .from('product_variations')
            .delete()
            .eq('product_id', syncItem['record_id']);
            
        // Then delete product
        await _supabase
            .from('products')
            .delete()
            .eq('id', syncItem['record_id']);
        break;
    }
  }

  Future<void> _syncVariation(Map<String, dynamic> syncItem) async {
    final data = jsonDecode(syncItem['data']);

    switch (syncItem['operation']) {
      case 'CREATE':
      case 'UPDATE':
        try {
          final supabaseData = _variationToSupabaseFormat(Map<String, dynamic>.from(data));
          await _supabase.from('product_variations').upsert(supabaseData);
        } catch (e) {
          _logger.error('Error upserting variation with data: $data');
          rethrow;
        }
        break;
      case 'DELETE':
        await _supabase
            .from('product_variations')
            .delete()
            .eq('id', syncItem['record_id']);
        break;
    }
  }

  Future<void> _syncStock(Map<String, dynamic> syncItem) async {
    final data = jsonDecode(syncItem['data']);

    switch (syncItem['operation']) {
      case 'CREATE':
      case 'UPDATE':
        await _supabase.from('product_stock').upsert(data);
        break;
      case 'DELETE':
        await _supabase
            .from('product_stock')
            .delete()
            .eq('id', syncItem['record_id']);
        break;
    }
  }

  @override
  Future<Either<OfflineFirstException, void>> downloadProductsForBusiness({
    required String businessId,
  }) async {
    try {
      // Download categories
      final categoriesResponse = await _supabase
          .from('product_categories')
          .select()
          .eq('business_id', businessId);

      final categoriesList = categoriesResponse as List? ?? [];
      _logger.info('Downloaded ${categoriesList.length} categories from cloud');

      for (final categoryData in categoriesList) {
        try {
          // Convert snake_case to camelCase for model
          final categoryJson = {
            'id': categoryData['id'],
            'businessId': categoryData['business_id'],
            'name': categoryData['name'] ?? '',
            'nameInAlternateLanguage': categoryData['name_in_alternate_language'],
            'description': categoryData['description'],
            'imageUrl': categoryData['image_url'],
            'iconName': categoryData['icon_name'],
            'displayOrder': categoryData['display_order'] ?? 0,
            'isActive': categoryData['is_active'] ?? true,
            'createdAt': categoryData['created_at'],
            'updatedAt': categoryData['updated_at'],
          };
          
          final category = ProductCategory.fromJson(categoryJson);
          await _localDatabase.database.insert(
            'product_categories',
            _categoryToDatabase(category),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } catch (e) {
          _logger.error('Error processing category ${categoryData['id']}: $e');
        }
      }

      // Download brands
      final brandsResponse = await _supabase
          .from('product_brands')
          .select()
          .eq('business_id', businessId);

      final brandsList = brandsResponse as List? ?? [];
      _logger.info('Downloaded ${brandsList.length} brands from cloud');

      for (final brandData in brandsList) {
        try {
          // Convert snake_case to camelCase for model
          final brandJson = {
            'id': brandData['id'],
            'businessId': brandData['business_id'],
            'name': brandData['name'] ?? '',
            'description': brandData['description'],
            'logoUrl': brandData['logo_url'],
            'displayOrder': brandData['display_order'] ?? 0,
            'isActive': brandData['is_active'] ?? true,
            'createdAt': brandData['created_at'],
            'updatedAt': brandData['updated_at'],
          };
          
          final brand = ProductBrand.fromJson(brandJson);
          await _localDatabase.database.insert(
            'product_brands',
            _brandToDatabase(brand),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } catch (e) {
          _logger.error('Error processing brand ${brandData['id']}: $e');
        }
      }

      // Download products with variations
      final productsResponse = await _supabase
          .from('products')
          .select('*, product_variations(*)')
          .eq('business_id', businessId);

      final productsList = productsResponse as List? ?? [];
      _logger.info('Downloaded ${productsList.length} products from cloud');

      for (final productData in productsList) {
        try {
          // Extract variations
          final variationsData = productData['product_variations'] as List? ?? [];
          final productDataCopy = Map<String, dynamic>.from(productData);
          productDataCopy.remove('product_variations');

          // Log the data for debugging
          _logger.info('Processing product data: ${productDataCopy['id']}');
          _logger.info('Product data fields: ${productDataCopy.keys.toList()}');
          
          // Convert snake_case fields from Supabase to camelCase for model
          final productJson = {
            'id': productDataCopy['id'],
            'businessId': productDataCopy['business_id'],
            'name': productDataCopy['name'] ?? '',
            'nameInAlternateLanguage': productDataCopy['name_in_alternate_language'],
            'description': productDataCopy['description'],
            'descriptionInAlternateLanguage': productDataCopy['description_in_alternate_language'],
            'categoryId': productDataCopy['category_id'],
            'brandId': productDataCopy['brand_id'],
            'imageUrl': productDataCopy['image_url'],
            'additionalImageUrls': productDataCopy['additional_image_urls'] is String
                ? jsonDecode(productDataCopy['additional_image_urls'])
                : productDataCopy['additional_image_urls'] ?? [],
            'unitOfMeasure': productDataCopy['unit_of_measure'] ?? 'piece',
            'barcode': productDataCopy['barcode'],
            'hsn': productDataCopy['hsn'],
            'taxRate': productDataCopy['tax_rate'] ?? 0.0,
            'taxGroupId': productDataCopy['tax_group_id'],
            'taxRateId': productDataCopy['tax_rate_id'],
            'shortCode': productDataCopy['short_code'],
            'tags': productDataCopy['tags'] is String
                ? jsonDecode(productDataCopy['tags'])
                : productDataCopy['tags'] ?? [],
            'productType': productDataCopy['product_type'] ?? 'physical',
            'trackInventory': productDataCopy['track_inventory'] ?? true,
            'isActive': productDataCopy['is_active'] ?? true,
            'displayOrder': productDataCopy['display_order'] ?? 0,
            'availableInPos': productDataCopy['available_in_pos'] ?? true,
            'availableInOnlineStore': productDataCopy['available_in_online_store'] ?? false,
            'availableInCatalog': productDataCopy['available_in_catalog'] ?? true,
            'skipKot': productDataCopy['skip_kot'] ?? false,
            'createdAt': productDataCopy['created_at'],
            'updatedAt': productDataCopy['updated_at'],
            'variations': [], // Will be added separately
          };
          
          // Save product
          final product = Product.fromJson(productJson);
          await _localDatabase.database.insert(
            'products',
            _productToDatabase(product),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          // Save variations
          for (final varData in variationsData) {
            try {
              final varDataCopy = Map<String, dynamic>.from(varData);
              
              // Convert snake_case fields from Supabase to camelCase for model
              final variationJson = {
                'id': varDataCopy['id'],
                'productId': varDataCopy['product_id'],
                'name': varDataCopy['name'] ?? '',
                'sku': varDataCopy['sku'],
                'mrp': varDataCopy['mrp'] ?? 0.0,
                'sellingPrice': varDataCopy['selling_price'] ?? (varDataCopy['price'] ?? 0.0),
                'purchasePrice': varDataCopy['purchase_price'],
                'barcode': varDataCopy['barcode'],
                'isDefault': varDataCopy['is_default'] ?? false,
                'isActive': varDataCopy['is_active'] ?? true,
                'displayOrder': varDataCopy['display_order'] ?? 0,
                'isForSale': varDataCopy['is_for_sale'] ?? true,
                'isForPurchase': varDataCopy['is_for_purchase'] ?? true,
              };
              
              final variation = ProductVariation.fromJson(variationJson);
              await _localDatabase.database.insert(
                'product_variations',
                _variationToDatabase(variation),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            } catch (e) {
              _logger.error('Error processing variation: $e');
            }
          }
          
          // Log warning if product has no variations
          if (variationsData.isEmpty) {
            _logger.warning('Product ${productDataCopy['id']} has no variations');
          }
        } catch (e) {
          _logger.error('Error processing product ${productData['id']}: $e');
          // Continue with other products
        }
      }

      // Download stock levels for all locations
      final locationsResponse = await _supabase
          .from('business_locations')
          .select('id')
          .eq('business_id', businessId);

      for (final location in locationsResponse as List) {
        final stockResponse = await _supabase
            .from('product_stock')
            .select()
            .eq('location_id', location['id']);

        for (final stockData in stockResponse as List) {
          final stock = ProductStock.fromJson(stockData);
          await _localDatabase.database.insert(
            'product_stock',
            stock.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Error downloading products', e);
      _logger.error('Stack trace:', stackTrace);
      return Left(
        CloudServiceException(
          'Failed to download products',
          'downloadProductsForBusiness',
          originalError: e,
        ),
      );
    }
  }

  // Helper method to convert category to database format
  Map<String, dynamic> _categoryToDatabase(ProductCategory category) {
    return {
      'id': category.id,
      'business_id': category.businessId,
      'name': category.name,
      'name_in_alternate_language': category.nameInAlternateLanguage,
      'description': category.description,
      'image_url': category.imageUrl,
      'icon_name': category.iconName,
      'display_order': category.displayOrder,
      'is_active': category.isActive ? 1 : 0,
      'parent_category_id': category.parentCategoryId,
      'default_kot_printer_id': category.defaultKotPrinterId,
      'created_at': category.createdAt.toIso8601String(),
      'updated_at': category.updatedAt.toIso8601String(),
      'last_synced_at': category.lastSyncedAt?.toIso8601String(),
      'has_unsynced_changes': category.hasUnsyncedChanges ? 1 : 0,
    };
  }

  // Helper method to convert brand to database format
  Map<String, dynamic> _brandToDatabase(ProductBrand brand) {
    return {
      'id': brand.id,
      'business_id': brand.businessId,
      'name': brand.name,
      'description': brand.description,
      'logo_url': brand.logoUrl,
      'display_order': brand.displayOrder,
      'is_active': brand.isActive ? 1 : 0,
      'created_at': brand.createdAt.toIso8601String(),
      'updated_at': brand.updatedAt.toIso8601String(),
      'last_synced_at': brand.lastSyncedAt?.toIso8601String(),
      'has_unsynced_changes': brand.hasUnsyncedChanges ? 1 : 0,
    };
  }

  // Helper method to convert product to database format
  Map<String, dynamic> _productToDatabase(Product product) {
    return {
      'id': product.id,
      'business_id': product.businessId,
      'name': product.name,
      'name_in_alternate_language': product.nameInAlternateLanguage,
      'description': product.description,
      'description_in_alternate_language':
          product.descriptionInAlternateLanguage,
      'category_id': product.categoryId,
      'brand_id': product.brandId,
      'image_url': product.imageUrl,
      'additional_image_urls': jsonEncode(product.additionalImageUrls),
      'unit_of_measure': product.unitOfMeasure.name,
      'barcode': product.barcode,
      'hsn': product.hsn,
      'tax_rate': product.taxRate,
      'tax_group_id': product.taxGroupId,
      'tax_rate_id': product.taxRateId,
      'short_code': product.shortCode,
      'tags': jsonEncode(product.tags),
      'product_type': product.productType.name,
      'track_inventory': product.trackInventory ? 1 : 0,
      'is_active': product.isActive ? 1 : 0,
      'display_order': product.displayOrder,
      'available_in_pos': product.availableInPos ? 1 : 0,
      'available_in_online_store': product.availableInOnlineStore ? 1 : 0,
      'available_in_catalog': product.availableInCatalog ? 1 : 0,
      'skip_kot': product.skipKot ? 1 : 0,
      'created_at': product.createdAt.toIso8601String(),
      'updated_at': product.updatedAt.toIso8601String(),
      'last_synced_at': product.lastSyncedAt?.toIso8601String(),
      'has_unsynced_changes': product.hasUnsyncedChanges ? 1 : 0,
    };
  }

  // Helper method to convert product variation to database format
  Map<String, dynamic> _variationToDatabase(ProductVariation variation) {
    return {
      'id': variation.id,
      'product_id': variation.productId,
      'name': variation.name,
      'sku': variation.sku,
      'mrp': variation.mrp,
      'selling_price': variation.sellingPrice,
      'purchase_price': variation.purchasePrice,
      'barcode': variation.barcode,
      'is_default': variation.isDefault ? 1 : 0,
      'is_active': variation.isActive ? 1 : 0,
      'display_order': variation.displayOrder,
      'is_for_sale': variation.isForSale ? 1 : 0,
      'is_for_purchase': variation.isForPurchase ? 1 : 0,
    };
  }
  
  // Helper method to convert product to Supabase format
  Map<String, dynamic> _productToSupabaseFormat(Map<String, dynamic> data) {
    // Process image URLs - don't sync local paths to cloud
    final imageUrl = data['imageUrl'] ?? data['image_url'];
    final processedImageUrl = (imageUrl != null && imageUrl.toString().startsWith('http'))
        ? imageUrl
        : null; // Don't sync local paths
    
    // Process additional image URLs
    var additionalImageUrls = data['additionalImageUrls'] ?? data['additional_image_urls'];
    if (additionalImageUrls != null) {
      List<String> processedUrls = [];
      
      // Parse if it's a JSON string
      if (additionalImageUrls is String) {
        try {
          if (additionalImageUrls.startsWith('[')) {
            // Parse JSON array
            additionalImageUrls = _parseJsonArray(additionalImageUrls);
          } else {
            additionalImageUrls = [];
          }
        } catch (e) {
          _logger.warning('Failed to parse additional image URLs: $e');
          additionalImageUrls = [];
        }
      }
      
      // Filter out local paths
      if (additionalImageUrls is List) {
        for (final url in additionalImageUrls) {
          final urlStr = url.toString();
          if (urlStr.startsWith('http')) {
            processedUrls.add(urlStr);
          }
        }
      }
      
      additionalImageUrls = processedUrls.isEmpty ? null : processedUrls;
    }
    
    return {
      'id': data['id'],
      'business_id': data['businessId'] ?? data['business_id'],
      'name': data['name'],
      'name_in_alternate_language': data['nameInAlternateLanguage'] ?? data['name_in_alternate_language'],
      'description': data['description'],
      'description_in_alternate_language': data['descriptionInAlternateLanguage'] ?? data['description_in_alternate_language'],
      'category_id': data['categoryId'] ?? data['category_id'],
      'brand_id': data['brandId'] ?? data['brand_id'],
      'image_url': processedImageUrl,
      'additional_image_urls': additionalImageUrls,
      'unit_of_measure': data['unitOfMeasure'] ?? data['unit_of_measure'],
      'barcode': data['barcode'],
      'hsn': data['hsn'],
      'tax_rate': data['taxRate'] ?? data['tax_rate'],
      'tax_group_id': data['taxGroupId'] ?? data['tax_group_id'],
      'tax_rate_id': data['taxRateId'] ?? data['tax_rate_id'],
      'short_code': data['shortCode'] ?? data['short_code'],
      'tags': data['tags'],
      'product_type': data['productType'] ?? data['product_type'],
      'track_inventory': data['trackInventory'] ?? data['track_inventory'],
      'is_active': data['isActive'] ?? data['is_active'],
      'display_order': data['displayOrder'] ?? data['display_order'],
      'available_in_pos': data['availableInPos'] ?? data['available_in_pos'],
      'available_in_online_store': data['availableInOnlineStore'] ?? data['available_in_online_store'],
      'available_in_catalog': data['availableInCatalog'] ?? data['available_in_catalog'],
      'skip_kot': data['skipKot'] ?? data['skip_kot'],
      'created_at': data['createdAt'] ?? data['created_at'],
      'updated_at': data['updatedAt'] ?? data['updated_at'],
    };
  }
  
  // Helper to parse JSON array strings
  List<String> _parseJsonArray(String jsonString) {
    final cleaned = jsonString.trim();
    if (cleaned == '[]') return [];
    
    if (cleaned.startsWith('[') && cleaned.endsWith(']')) {
      final content = cleaned.substring(1, cleaned.length - 1);
      if (content.isEmpty) return [];
      
      final items = <String>[];
      var current = '';
      var inQuotes = false;
      
      for (int i = 0; i < content.length; i++) {
        final char = content[i];
        if (char == '"' && (i == 0 || content[i - 1] != '\\')) {
          inQuotes = !inQuotes;
        } else if (char == ',' && !inQuotes) {
          final item = current.trim();
          if (item.isNotEmpty) {
            items.add(item.replaceAll('"', ''));
          }
          current = '';
        } else {
          current += char;
        }
      }
      
      if (current.isNotEmpty) {
        items.add(current.trim().replaceAll('"', ''));
      }
      
      return items;
    }
    
    return [];
  }
  
  // Helper method to convert variation to Supabase format
  Map<String, dynamic> _variationToSupabaseFormat(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'product_id': data['productId'] ?? data['product_id'],
      'name': data['name'],
      'sku': (data['sku'] != null && data['sku'].toString().trim().isNotEmpty) 
          ? data['sku'] 
          : null, // Convert empty strings to null
      'mrp': data['mrp'],
      'selling_price': data['sellingPrice'] ?? data['selling_price'],
      'purchase_price': data['purchasePrice'] ?? data['purchase_price'],
      'barcode': (data['barcode'] != null && data['barcode'].toString().trim().isNotEmpty) 
          ? data['barcode'] 
          : null, // Convert empty strings to null
      'is_default': data['isDefault'] ?? data['is_default'],
      'is_active': data['isActive'] ?? data['is_active'],
      'display_order': data['displayOrder'] ?? data['display_order'],
      'is_for_sale': data['isForSale'] ?? data['is_for_sale'],
      'is_for_purchase': data['isForPurchase'] ?? data['is_for_purchase'],
    };
  }
  
  @override
  Future<int> getPendingChangesCount() async {
    try {
      final items = await _syncQueueService.getPendingItems();
      // Count only product-related sync items
      return items.where((item) => 
        item['table_name'] == 'products' ||
        item['table_name'] == 'product_categories' ||
        item['table_name'] == 'product_brands'
      ).length;
    } catch (e) {
      _logger.error('Error getting pending changes count', e);
      return 0;
    }
  }
}
