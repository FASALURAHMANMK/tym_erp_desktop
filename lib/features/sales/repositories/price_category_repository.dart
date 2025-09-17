import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/exceptions/offline_first_exceptions.dart';
import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../models/price_category.dart';
import '../models/product_variation_price.dart';

class PriceCategoryRepository {
  static final _logger = Logger('PriceCategoryRepository');

  final LocalDatabaseService _localDb;
  final SupabaseClient _supabase;
  final SyncQueueService _syncQueueService;
  final _uuid = const Uuid();
  final _connectivity = Connectivity();

  PriceCategoryRepository({
    required LocalDatabaseService localDb,
    required SupabaseClient supabase,
    required SyncQueueService syncQueueService,
  }) : _localDb = localDb,
       _supabase = supabase,
       _syncQueueService = syncQueueService;

  // ==================== PRICE CATEGORIES ====================

  /// Get all price categories for a business location
  Future<Either<OfflineFirstException, List<PriceCategory>>>
  getPriceCategories({
    required String businessId,
    required String locationId,
    bool includeInactive = false,
  }) async {
    try {
      final db = await _localDb.database;

      String query = '''
        SELECT * FROM price_categories 
        WHERE business_id = ? AND location_id = ?
      ''';

      List<dynamic> args = [businessId, locationId];

      if (!includeInactive) {
        query += ' AND is_active = 1';
      }

      query += ' ORDER BY display_order ASC, name ASC';

      final results = await db.rawQuery(query, args);

      final categories =
          results.map((row) {
            return PriceCategory.fromJson(_convertFromDatabase(row));
          }).toList();

      return Right(categories);
    } catch (e, stackTrace) {
      _logger.error('Error getting price categories', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get price categories',
          'getPriceCategories',
          tableName: 'price_categories',
          originalError: e,
        ),
      );
    }
  }

  /// Create a new price category
  Future<Either<OfflineFirstException, PriceCategory>> createPriceCategory({
    required String businessId,
    required String locationId,
    required String name,
    required PriceCategoryType type,
    String? description,
    String? iconName,
    String? colorHex,
    bool isDefault = false,
    int displayOrder = 0,
  }) async {
    try {
      final db = await _localDb.database;
      final id = _uuid.v4();
      final now = DateTime.now();
      final userId = _supabase.auth.currentUser?.id;

      final category = PriceCategory(
        id: id,
        businessId: businessId,
        locationId: locationId,
        name: name,
        type: type,
        description: description,
        isDefault: isDefault,
        isActive: true,
        isVisible: true,
        displayOrder: displayOrder,
        iconName: iconName,
        colorHex: colorHex,
        settings: {},
        createdAt: now,
        updatedAt: now,
        createdBy: userId,
        hasUnsyncedChanges: true,
      );

      // Insert into local database
      await db.insert(
        'price_categories',
        _convertToDatabase(category.toJson()),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'price_categories',
        'INSERT',
        id,
        category.toJson(),
      );

      // Don't sync immediately - let the background sync handle it
      // This avoids foreign key errors when location hasn't synced yet
      _logger.info('Price category queued for sync: $name');

      return Right(category);
    } catch (e, stackTrace) {
      _logger.error('Error creating price category', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to create price category',
          'createPriceCategory',
          tableName: 'price_categories',
          originalError: e,
        ),
      );
    }
  }

  /// Update a price category
  Future<Either<OfflineFirstException, PriceCategory>> updatePriceCategory(
    PriceCategory category,
  ) async {
    try {
      final db = await _localDb.database;
      final updatedCategory = category.copyWith(
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );

      // Update in local database
      await db.update(
        'price_categories',
        _convertToDatabase(updatedCategory.toJson()),
        where: 'id = ?',
        whereArgs: [category.id],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'price_categories',
        'UPDATE',
        category.id,
        updatedCategory.toJson(),
      );

      // Don't sync immediately - let the background sync handle it
      _logger.info('Price category update queued for sync: ${category.id}');

      return Right(updatedCategory);
    } catch (e, stackTrace) {
      _logger.error('Error updating price category', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to update price category',
          'updatePriceCategory',
          tableName: 'price_categories',
          originalError: e,
        ),
      );
    }
  }

  /// Delete a price category (soft delete)
  Future<Either<OfflineFirstException, void>> deletePriceCategory(
    String categoryId,
  ) async {
    try {
      // First check if it's a default Dine-In category
      final db = await _localDb.database;
      final existing = await db.query(
        'price_categories',
        where: 'id = ?',
        whereArgs: [categoryId],
        limit: 1,
      );

      if (existing.isEmpty) {
        return Left(BusinessLogicException(
          'Price category not found',
          'deletePriceCategory',
          entityType: 'price_category',
        ));
      }

      final category = PriceCategory.fromJson(
        _convertFromDatabase(existing.first),
      );

      if (category.isDefault && category.type == PriceCategoryType.dineIn) {
        return Left(
          ValidationException(
            'Cannot delete default Dine-In category',
            'deletePriceCategory',
            fieldName: 'type',
            fieldValue: 'dine_in',
          ),
        );
      }

      // Soft delete by setting is_active to false
      final updatedCategory = category.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );

      await db.update(
        'price_categories',
        _convertToDatabase(updatedCategory.toJson()),
        where: 'id = ?',
        whereArgs: [categoryId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'price_categories',
        'UPDATE',
        categoryId,
        updatedCategory.toJson(),
      );

      // Try to sync immediately if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        _syncToSupabase(updatedCategory);
      }

      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Error deleting price category', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to delete price category',
          'deletePriceCategory',
          tableName: 'price_categories',
          originalError: e,
        ),
      );
    }
  }

  // ==================== PRODUCT VARIATION PRICES ====================

  /// Get variation prices for a product
  Future<Either<OfflineFirstException, List<ProductVariationPrice>>>
  getVariationPrices({required String variationId}) async {
    try {
      final db = await _localDb.database;

      final results = await db.query(
        'product_variation_prices',
        where: 'variation_id = ? AND is_active = 1',
        whereArgs: [variationId],
      );

      final prices =
          results.map((row) {
            return ProductVariationPrice.fromJson(_convertFromDatabase(row));
          }).toList();

      return Right(prices);
    } catch (e, stackTrace) {
      _logger.error('Error getting variation prices', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get variation prices',
          'getVariationPrices',
          tableName: 'product_variation_prices',
          originalError: e,
        ),
      );
    }
  }

  /// Set price for a variation in a category
  Future<Either<OfflineFirstException, ProductVariationPrice>>
  setVariationPrice({
    required String variationId,
    required String priceCategoryId,
    required double price,
    double? cost,
  }) async {
    try {
      final db = await _localDb.database;
      final now = DateTime.now();
      final userId = _supabase.auth.currentUser?.id;

      // Check if price already exists
      final existing = await db.query(
        'product_variation_prices',
        where: 'variation_id = ? AND price_category_id = ?',
        whereArgs: [variationId, priceCategoryId],
        limit: 1,
      );

      ProductVariationPrice variationPrice;

      if (existing.isNotEmpty) {
        // Update existing
        final existingPrice = ProductVariationPrice.fromJson(
          _convertFromDatabase(existing.first),
        );

        variationPrice = existingPrice.copyWith(
          price: price,
          cost: cost,
          updatedAt: now,
          hasUnsyncedChanges: true,
        );

        await db.update(
          'product_variation_prices',
          _convertToDatabase(variationPrice.toJson()),
          where: 'id = ?',
          whereArgs: [existingPrice.id],
        );

        await _syncQueueService.addToQueue(
          'product_variation_prices',
          'UPDATE',
          existingPrice.id,
          variationPrice.toJson(),
        );
      } else {
        // Create new
        final id = _uuid.v4();

        variationPrice = ProductVariationPrice(
          id: id,
          variationId: variationId,
          priceCategoryId: priceCategoryId,
          price: price,
          cost: cost,
          isActive: true,
          createdAt: now,
          updatedAt: now,
          createdBy: userId,
          hasUnsyncedChanges: true,
        );

        await db.insert(
          'product_variation_prices',
          _convertToDatabase(variationPrice.toJson()),
        );

        await _syncQueueService.addToQueue(
          'product_variation_prices',
          'INSERT',
          id,
          variationPrice.toJson(),
        );
      }

      // Try to sync immediately if online
      final connectivityResult = await _connectivity.checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        _syncVariationPriceToSupabase(variationPrice);
      }

      return Right(variationPrice);
    } catch (e, stackTrace) {
      _logger.error('Error setting variation price', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to set variation price',
          'setVariationPrice',
          tableName: 'product_variation_prices',
          originalError: e,
        ),
      );
    }
  }

  // ==================== DEFAULT CATEGORIES CREATION ====================

  /// Create default price categories for a new business location
  Future<Either<OfflineFirstException, List<PriceCategory>>>
  createDefaultCategories({
    required String businessId,
    required String locationId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      final now = DateTime.now();

      final defaultCategories = [
        PriceCategory(
          id: _uuid.v4(),
          businessId: businessId,
          locationId: locationId,
          name: 'Dine-In',
          type: PriceCategoryType.dineIn,
          description: 'For customers dining in the restaurant',
          isDefault: true,
          isActive: true,
          isVisible: true,
          displayOrder: 1,
          iconName: 'restaurant',
          colorHex: '#4CAF50',
          settings: {},
          createdAt: now,
          updatedAt: now,
          createdBy: userId,
          hasUnsyncedChanges: true,
        ),
        PriceCategory(
          id: _uuid.v4(),
          businessId: businessId,
          locationId: locationId,
          name: 'Parcel',
          type: PriceCategoryType.takeaway,
          description: 'For takeaway orders',
          isDefault: true,
          isActive: true,
          isVisible: true,
          displayOrder: 2,
          iconName: 'takeout_dining',
          colorHex: '#FF9800',
          settings: {},
          createdAt: now,
          updatedAt: now,
          createdBy: userId,
          hasUnsyncedChanges: true,
        ),
        PriceCategory(
          id: _uuid.v4(),
          businessId: businessId,
          locationId: locationId,
          name: 'Delivery',
          type: PriceCategoryType.delivery,
          description: 'For delivery orders',
          isDefault: true,
          isActive: true,
          isVisible: true,
          displayOrder: 3,
          iconName: 'delivery_dining',
          colorHex: '#2196F3',
          settings: {},
          createdAt: now,
          updatedAt: now,
          createdBy: userId,
          hasUnsyncedChanges: true,
        ),
      ];

      final db = await _localDb.database;

      // Track which categories were actually inserted
      final insertedCategories = <PriceCategory>[];

      // Insert all categories in a transaction
      await db.transaction((txn) async {
        for (final category in defaultCategories) {
          // Check if category already exists
          final existing = await txn.query(
            'price_categories',
            where: 'business_id = ? AND location_id = ? AND type = ?',
            whereArgs: [businessId, locationId, category.type.name],
            limit: 1,
          );
          
          if (existing.isEmpty) {
            // Only insert if it doesn't exist
            await txn.insert(
              'price_categories',
              _convertToDatabase(category.toJson()),
            );
            insertedCategories.add(category);
            _logger.info('Created price category: ${category.name} (${category.type})');
          } else {
            _logger.info('Price category already exists: ${category.type.name}, skipping');
          }
        }
      });

      // Queue for sync ONLY the categories that were actually inserted
      for (final category in insertedCategories) {
        await _syncQueueService.addToQueue(
          'price_categories',
          'INSERT',
          category.id,
          category.toJson(),
        );
      }

      // Don't sync immediately - let the background sync handle it
      // This avoids foreign key errors when location hasn't synced yet
      _logger.info('Default price categories queued for sync');

      // Return the categories that were actually created
      // If no categories were created (all already existed), fetch and return existing ones
      if (insertedCategories.isEmpty) {
        _logger.info('All default categories already existed, fetching existing ones');
        final existing = await db.query(
          'price_categories',
          where: 'business_id = ? AND location_id = ?',
          whereArgs: [businessId, locationId],
        );
        
        final existingCategories = existing.map((row) {
          final json = _convertFromDatabase(row);
          return PriceCategory.fromJson(json);
        }).toList();
        
        return Right(existingCategories);
      }

      return Right(insertedCategories);
    } catch (e, stackTrace) {
      _logger.error('Error creating default categories', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to create default categories',
          'createDefaultCategories',
          tableName: 'price_categories',
          originalError: e,
        ),
      );
    }
  }

  // ==================== SYNC METHODS ====================

  /// Sync price category to Supabase
  Future<void> _syncToSupabase(PriceCategory category) async {
    try {
      final data = _convertToSupabaseFormat(category.toJson());

      await _supabase
          .from('price_categories')
          .upsert(data)
          .eq('id', category.id);

      // Mark as synced in local database
      final db = await _localDb.database;
      await db.update(
        'price_categories',
        {
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [category.id],
      );

      // Remove from sync queue
      // Note: SyncQueueService doesn't have removeFromQueue method, we'll use removeItem
      // This would require tracking the queue item ID, for now we'll skip this

      _logger.info('Price category synced successfully: ${category.id}');
    } catch (e, stackTrace) {
      _logger.error('Error syncing price category to Supabase', e, stackTrace);
    }
  }

  /// Sync variation price to Supabase
  Future<void> _syncVariationPriceToSupabase(
    ProductVariationPrice price,
  ) async {
    try {
      final data = _convertToSupabaseFormat(price.toJson());

      await _supabase
          .from('product_variation_prices')
          .upsert(data)
          .eq('id', price.id);

      // Mark as synced in local database
      final db = await _localDb.database;
      await db.update(
        'product_variation_prices',
        {
          'has_unsynced_changes': 0,
          'last_synced_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [price.id],
      );

      // Remove from sync queue
      // Note: SyncQueueService doesn't have removeFromQueue method, we'll use removeItem
      // This would require tracking the queue item ID, for now we'll skip this

      _logger.info('Variation price synced successfully: ${price.id}');
    } catch (e, stackTrace) {
      _logger.error('Error syncing variation price to Supabase', e, stackTrace);
    }
  }

  // ==================== HELPER METHODS ====================

  /// Convert from database format to model format
  Map<String, dynamic> _convertFromDatabase(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // Convert integer booleans to actual booleans
    final boolFields = [
      'is_default',
      'is_active',
      'is_visible',
      'has_unsynced_changes',
    ];

    for (final field in boolFields) {
      if (converted.containsKey(field)) {
        converted[field] = converted[field] == 1;
      }
    }

    // Convert camelCase field names
    converted['isDefault'] = converted.remove('is_default') ?? false;
    converted['isActive'] = converted.remove('is_active') ?? true;
    converted['isVisible'] = converted.remove('is_visible') ?? true;
    converted['hasUnsyncedChanges'] =
        converted.remove('has_unsynced_changes') ?? false;
    converted['businessId'] = converted.remove('business_id');
    converted['locationId'] = converted.remove('location_id');
    converted['displayOrder'] = converted.remove('display_order') ?? 0;
    converted['iconName'] = converted.remove('icon_name');
    converted['colorHex'] = converted.remove('color_hex');
    converted['createdAt'] = converted.remove('created_at');
    converted['updatedAt'] = converted.remove('updated_at');
    converted['createdBy'] = converted.remove('created_by');
    converted['lastSyncedAt'] = converted.remove('last_synced_at');

    // Parse JSON settings
    if (converted['settings'] is String) {
      try {
        converted['settings'] = jsonDecode(converted['settings']);
      } catch (_) {
        converted['settings'] = {};
      }
    }

    // Keep dates as strings - the model's fromJson will handle parsing
    // The generated code expects strings and will call DateTime.parse() itself

    return converted;
  }

  /// Convert to database format
  Map<String, dynamic> _convertToDatabase(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // Convert booleans to integers
    final boolFields = [
      'isDefault',
      'isActive',
      'isVisible',
      'hasUnsyncedChanges',
    ];

    for (final field in boolFields) {
      if (converted.containsKey(field)) {
        converted[field] = converted[field] ? 1 : 0;
      }
    }

    // Convert to snake_case field names
    converted['is_default'] = converted.remove('isDefault');
    converted['is_active'] = converted.remove('isActive');
    converted['is_visible'] = converted.remove('isVisible');
    converted['has_unsynced_changes'] = converted.remove('hasUnsyncedChanges');
    converted['business_id'] = converted.remove('businessId');
    converted['location_id'] = converted.remove('locationId');
    converted['display_order'] = converted.remove('displayOrder');
    converted['icon_name'] = converted.remove('iconName');
    converted['color_hex'] = converted.remove('colorHex');
    converted['created_at'] = converted.remove('createdAt')?.toString();
    converted['updated_at'] = converted.remove('updatedAt')?.toString();
    converted['created_by'] = converted.remove('createdBy');
    converted['last_synced_at'] = converted.remove('lastSyncedAt')?.toString();

    // Convert settings to JSON string
    if (converted['settings'] != null && converted['settings'] is! String) {
      converted['settings'] = jsonEncode(converted['settings']);
    }

    return converted;
  }

  /// Convert to Supabase format (snake_case)
  Map<String, dynamic> _convertToSupabaseFormat(Map<String, dynamic> data) {
    final converted = Map<String, dynamic>.from(data);

    // Convert to snake_case field names
    converted['is_default'] = converted.remove('isDefault');
    converted['is_active'] = converted.remove('isActive');
    converted['is_visible'] = converted.remove('isVisible');
    converted['business_id'] = converted.remove('businessId');
    converted['location_id'] = converted.remove('locationId');
    converted['display_order'] = converted.remove('displayOrder');
    converted['icon_name'] = converted.remove('iconName');
    converted['color_hex'] = converted.remove('colorHex');
    converted['created_at'] = converted.remove('createdAt')?.toString();
    converted['updated_at'] = converted.remove('updatedAt')?.toString();
    converted['created_by'] = converted.remove('createdBy');

    // Remove local-only fields that don't exist in Supabase
    converted.remove('hasUnsyncedChanges');
    converted.remove('has_unsynced_changes');
    converted.remove('lastSyncedAt');
    converted.remove('last_synced_at');

    return converted;
  }
}
