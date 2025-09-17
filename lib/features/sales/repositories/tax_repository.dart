import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../models/tax_config.dart';
import '../../../services/database_schema.dart';

class TaxRepository {
  final Database _localDatabase;
  final SupabaseClient _supabase;
  final SyncQueueService _syncQueueService;
  final _logger = Logger('TaxRepository');
  final _uuid = const Uuid();

  TaxRepository({
    required Database localDatabase,
    required SupabaseClient supabase,
    required SyncQueueService syncQueueService,
  })  : _localDatabase = localDatabase,
        _supabase = supabase,
        _syncQueueService = syncQueueService;

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    // Ensure tables via centralized schema (matches database/schema_sqlite.sql)
    await DatabaseSchema.applySqliteSchema(_localDatabase);
  }

  // Get all tax groups for a business
  Future<Either<String, List<TaxGroup>>> getTaxGroups(String businessId) async {
    try {
      final groups = await _localDatabase.query(
        'tax_groups',
        where: 'business_id = ? AND is_active = ?',
        whereArgs: [businessId, 1],
        orderBy: 'display_order ASC, name ASC',
      );

      final taxGroups = <TaxGroup>[];
      for (final groupData in groups) {
        // Get tax rates for this group
        final rates = await _localDatabase.query(
          'tax_rates',
          where: 'tax_group_id = ? AND is_active = ?',
          whereArgs: [groupData['id'], 1],
          orderBy: 'display_order ASC, name ASC',
        );

        final taxRates = rates.map((rateData) => TaxRate(
              id: rateData['id'] as String,
              taxGroupId: rateData['tax_group_id'] as String,
              businessId: rateData['business_id'] as String,
              name: rateData['name'] as String,
              rate: (rateData['rate'] as num).toDouble(),
              type: TaxType.values.firstWhere(
                (t) => t.name == rateData['type'],
                orElse: () => TaxType.percentage,
              ),
              calculationMethod: TaxCalculationMethod.values.firstWhere(
                (m) => m.name == rateData['calculation_method'],
                orElse: () => TaxCalculationMethod.exclusive,
              ),
              isActive: (rateData['is_active'] as int?) == 1,
              displayOrder: rateData['display_order'] as int? ?? 0,
              applyOn: rateData['apply_on'] as String?,
              createdAt: DateTime.parse(rateData['created_at'] as String),
              updatedAt: DateTime.parse(rateData['updated_at'] as String),
            )).toList();

        taxGroups.add(TaxGroup(
          id: groupData['id'] as String,
          businessId: groupData['business_id'] as String,
          name: groupData['name'] as String,
          description: groupData['description'] as String?,
          isDefault: (groupData['is_default'] as int?) == 1,
          isActive: (groupData['is_active'] as int?) == 1,
          displayOrder: groupData['display_order'] as int? ?? 0,
          taxRates: taxRates,
          createdAt: DateTime.parse(groupData['created_at'] as String),
          updatedAt: DateTime.parse(groupData['updated_at'] as String),
        ));
      }

      return Right(taxGroups);
    } catch (e) {
      _logger.error('Error getting tax groups', e);
      return Left('Failed to load tax groups: $e');
    }
  }

  // Add tax group
  Future<Either<String, TaxGroup>> addTaxGroup({
    required String businessId,
    required String name,
    String? description,
    bool isDefault = false,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      // If setting as default, unset other defaults
      if (isDefault) {
        await _localDatabase.update(
          'tax_groups',
          {'is_default': 0},
          where: 'business_id = ?',
          whereArgs: [businessId],
        );
      }

      await _localDatabase.insert('tax_groups', {
        'id': id,
        'business_id': businessId,
        'name': name,
        'description': description,
        'is_default': isDefault ? 1 : 0,
        'is_active': 1,
        'display_order': 0,
        'created_at': now,
        'updated_at': now,
      });

      // Queue for sync
      await _syncQueueService.addToQueue(
        'tax_groups',
        'create',
        id,
        {
          'id': id,
          'business_id': businessId,
          'name': name,
          'description': description,
          'is_default': isDefault,
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        },
      );

      final group = TaxGroup(
        id: id,
        businessId: businessId,
        name: name,
        description: description,
        isDefault: isDefault,
        isActive: true,
        displayOrder: 0,
        taxRates: [],
        createdAt: DateTime.parse(now),
        updatedAt: DateTime.parse(now),
      );

      _logger.info('Added tax group: $name');
      return Right(group);
    } catch (e) {
      _logger.error('Error adding tax group', e);
      return Left('Failed to add tax group: $e');
    }
  }

  // Add tax rate to group
  Future<Either<String, TaxRate>> addTaxRate({
    required String taxGroupId,
    required String businessId,
    required String name,
    required double rate,
    TaxType type = TaxType.percentage,
    TaxCalculationMethod calculationMethod = TaxCalculationMethod.exclusive,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      await _localDatabase.insert('tax_rates', {
        'id': id,
        'tax_group_id': taxGroupId,
        'business_id': businessId,
        'name': name,
        'rate': rate,
        'type': type.name,
        'calculation_method': calculationMethod.name,
        'apply_on': 'base_price',
        'is_active': 1,
        'display_order': 0,
        'created_at': now,
        'updated_at': now,
      });

      // Queue for sync
      await _syncQueueService.addToQueue(
        'tax_rates',
        'create',
        id,
        {
          'id': id,
          'tax_group_id': taxGroupId,
          'business_id': businessId,
          'name': name,
          'rate': rate,
          'type': type.name,
          'calculation_method': calculationMethod.name,
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        },
      );

      final taxRate = TaxRate(
        id: id,
        taxGroupId: taxGroupId,
        businessId: businessId,
        name: name,
        rate: rate,
        type: type,
        calculationMethod: calculationMethod,
        isActive: true,
        displayOrder: 0,
        applyOn: 'base_price',
        createdAt: DateTime.parse(now),
        updatedAt: DateTime.parse(now),
      );

      _logger.info('Added tax rate: $name');
      return Right(taxRate);
    } catch (e) {
      _logger.error('Error adding tax rate', e);
      return Left('Failed to add tax rate: $e');
    }
  }

  // Assign tax to product
  Future<Either<String, void>> assignTaxToProduct({
    required String productId,
    required String taxGroupId,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      // Check if already assigned
      final existing = await _localDatabase.query(
        'product_taxes',
        where: 'product_id = ? AND tax_group_id = ?',
        whereArgs: [productId, taxGroupId],
      );

      if (existing.isNotEmpty) {
        return const Right(null);
      }

      await _localDatabase.insert('product_taxes', {
        'id': id,
        'product_id': productId,
        'tax_group_id': taxGroupId,
        'is_active': 1,
        'created_at': now,
      });

      // Queue for sync
      await _syncQueueService.addToQueue(
        'product_taxes',
        'create',
        id,
        {
          'id': id,
          'product_id': productId,
          'tax_group_id': taxGroupId,
          'is_active': true,
          'created_at': now,
        },
      );

      _logger.info('Assigned tax to product: $productId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error assigning tax to product', e);
      return Left('Failed to assign tax: $e');
    }
  }

  // Assign tax to category
  Future<Either<String, void>> assignTaxToCategory({
    required String categoryId,
    required String taxGroupId,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      // Check if already assigned
      final existing = await _localDatabase.query(
        'category_taxes',
        where: 'category_id = ? AND tax_group_id = ?',
        whereArgs: [categoryId, taxGroupId],
      );

      if (existing.isNotEmpty) {
        return const Right(null);
      }

      await _localDatabase.insert('category_taxes', {
        'id': id,
        'category_id': categoryId,
        'tax_group_id': taxGroupId,
        'is_active': 1,
        'created_at': now,
      });

      // Queue for sync
      await _syncQueueService.addToQueue(
        'category_taxes',
        'create',
        id,
        {
          'id': id,
          'category_id': categoryId,
          'tax_group_id': taxGroupId,
          'is_active': true,
          'created_at': now,
        },
      );

      _logger.info('Assigned tax to category: $categoryId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error assigning tax to category', e);
      return Left('Failed to assign tax: $e');
    }
  }

  // Get tax for product (direct or from category)
  Future<Either<String, TaxGroup?>> getTaxForProduct(String productId) async {
    try {
      // First check direct product tax
      final productTax = await _localDatabase.query(
        'product_taxes',
        where: 'product_id = ? AND is_active = ?',
        whereArgs: [productId, 1],
        limit: 1,
      );

      String? taxGroupId;
      if (productTax.isNotEmpty) {
        taxGroupId = productTax.first['tax_group_id'] as String?;
      } else {
        // Check category tax
        // First get product's category
        final product = await _localDatabase.query(
          'products',
          where: 'id = ?',
          whereArgs: [productId],
          limit: 1,
        );

        if (product.isNotEmpty && product.first['category_id'] != null) {
          final categoryTax = await _localDatabase.query(
            'category_taxes',
            where: 'category_id = ? AND is_active = ?',
            whereArgs: [product.first['category_id'], 1],
            limit: 1,
          );

          if (categoryTax.isNotEmpty) {
            taxGroupId = categoryTax.first['tax_group_id'] as String?;
          }
        }
      }

      if (taxGroupId == null) {
        return const Right(null);
      }

      // Get the tax group
      final groupsResult = await getTaxGroups(productId); // This needs businessId
      return groupsResult.fold(
        (error) => Left(error),
        (groups) => Right(groups.firstWhere(
          (g) => g.id == taxGroupId,
          orElse: () => groups.first,
        )),
      );
    } catch (e) {
      _logger.error('Error getting tax for product', e);
      return Left('Failed to get product tax: $e');
    }
  }

  // Download tax data from Supabase
  Future<Either<String, void>> downloadTaxData(String businessId) async {
    try {
      // Download tax groups
      final groupsResponse = await _supabase
          .from('tax_groups')
          .select()
          .eq('business_id', businessId);

      // Download tax rates
      final ratesResponse = await _supabase
          .from('tax_rates')
          .select()
          .eq('business_id', businessId);

      // Clear existing local data
      await _localDatabase.delete(
        'tax_groups',
        where: 'business_id = ?',
        whereArgs: [businessId],
      );
      await _localDatabase.delete(
        'tax_rates',
        where: 'business_id = ?',
        whereArgs: [businessId],
      );

      // Insert groups
      for (final group in groupsResponse as List) {
        await _localDatabase.insert('tax_groups', {
          'id': group['id'],
          'business_id': group['business_id'],
          'name': group['name'],
          'description': group['description'],
          'is_default': group['is_default'] == true ? 1 : 0,
          'is_active': group['is_active'] == true ? 1 : 0,
          'display_order': group['display_order'] ?? 0,
          'created_at': group['created_at'],
          'updated_at': group['updated_at'],
        });
      }

      // Insert rates
      for (final rate in ratesResponse as List) {
        await _localDatabase.insert('tax_rates', {
          'id': rate['id'],
          'tax_group_id': rate['tax_group_id'],
          'business_id': rate['business_id'],
          'name': rate['name'],
          'rate': rate['rate'],
          'type': rate['type'] ?? 'percentage',
          'calculation_method': rate['calculation_method'] ?? 'exclusive',
          'apply_on': rate['apply_on'] ?? 'base_price',
          'parent_tax_id': rate['parent_tax_id'],
          'is_active': rate['is_active'] == true ? 1 : 0,
          'display_order': rate['display_order'] ?? 0,
          'created_at': rate['created_at'],
          'updated_at': rate['updated_at'],
        });
      }

      _logger.info('Downloaded ${groupsResponse.length} tax groups and ${ratesResponse.length} tax rates');
      return const Right(null);
    } catch (e) {
      _logger.error('Error downloading tax data', e);
      return Left('Failed to download tax data: $e');
    }
  }

  // Create default tax groups for new business
  Future<Either<String, void>> createDefaultTaxGroups(String businessId) async {
    try {
      // Create GST group
      final gstResult = await addTaxGroup(
        businessId: businessId,
        name: 'GST',
        description: 'Goods and Services Tax',
        isDefault: true,
      );

      if (gstResult.isLeft()) {
        return Left(gstResult.fold((l) => l, (r) => ''));
      }

      final gstGroup = gstResult.getOrElse(() => throw Exception());

      // Add standard GST rates
      final gstRates = [
        {'name': 'GST 0%', 'rate': 0.0},
        {'name': 'GST 5%', 'rate': 5.0},
        {'name': 'GST 12%', 'rate': 12.0},
        {'name': 'GST 18%', 'rate': 18.0},
        {'name': 'GST 28%', 'rate': 28.0},
      ];

      for (final rateData in gstRates) {
        await addTaxRate(
          taxGroupId: gstGroup.id,
          businessId: businessId,
          name: rateData['name'] as String,
          rate: rateData['rate'] as double,
        );
      }

      _logger.info('Created default tax groups for business: $businessId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error creating default tax groups', e);
      return Left('Failed to create default tax groups: $e');
    }
  }
}
