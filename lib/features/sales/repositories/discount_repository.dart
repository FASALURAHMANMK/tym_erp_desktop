import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../models/discount.dart';
import '../../../services/database_schema.dart';

class DiscountRepository {
  final Database _localDatabase;
  final SupabaseClient _supabase; // ignore: unused_field
  final SyncQueueService _syncQueueService;
  final _logger = Logger('DiscountRepository');
  final _uuid = const Uuid();

  DiscountRepository({
    required Database localDatabase,
    required SupabaseClient supabase,
    required SyncQueueService syncQueueService,
  })  : _localDatabase = localDatabase,
        _supabase = supabase,
        _syncQueueService = syncQueueService;

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    await DatabaseSchema.applySqliteSchema(_localDatabase);
  }

  // Get all discounts for a business
  Future<Either<String, List<Discount>>> getDiscounts({
    required String businessId,
    String? status, // active, scheduled, expired
  }) async {
    try {
      String whereClause = 'business_id = ?';
      List<dynamic> whereArgs = [businessId];

      final now = DateTime.now().toIso8601String();

      if (status == 'active') {
        whereClause += ' AND is_active = ? AND (valid_from IS NULL OR valid_from <= ?) AND (valid_until IS NULL OR valid_until >= ?)';
        whereArgs.addAll([1, now, now]);
      } else if (status == 'scheduled') {
        whereClause += ' AND is_active = ? AND valid_from > ?';
        whereArgs.addAll([1, now]);
      } else if (status == 'expired') {
        whereClause += ' AND (is_active = ? OR valid_until < ?)';
        whereArgs.addAll([0, now]);
      }

      final discounts = await _localDatabase.query(
        'discount_rules',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'priority DESC, created_at DESC',
      );

      final discountList = <Discount>[];
      for (final data in discounts) {
        // Get applicable products
        final products = await _localDatabase.query(
          'discount_products',
          where: 'discount_rule_id = ?',
          whereArgs: [data['id']],
        );
        final productIds = products.map((p) => p['product_id'] as String).toList();

        // Get applicable categories
        final categories = await _localDatabase.query(
          'discount_categories',
          where: 'discount_rule_id = ?',
          whereArgs: [data['id']],
        );
        final categoryIds = categories.map((c) => c['category_id'] as String).toList();

        discountList.add(Discount(
          id: data['id'] as String,
          name: data['name'] as String,
          value: (data['discount_value'] as num).toDouble(),
          type: DiscountType.values.firstWhere(
            (t) => t.name == data['discount_type'],
            orElse: () => DiscountType.percentage,
          ),
          scope: DiscountScope.values.firstWhere(
            (s) => s.name == data['scope'],
            orElse: () => DiscountScope.cart,
          ),
          minimumAmount: data['min_purchase_amount'] != null
              ? (data['min_purchase_amount'] as num).toDouble()
              : null,
          maximumDiscount: data['max_discount_amount'] != null
              ? (data['max_discount_amount'] as num).toDouble()
              : null,
          categoryId: categoryIds.isNotEmpty ? categoryIds.first : null,
          productId: productIds.isNotEmpty ? productIds.first : null,
          couponCode: data['code'] as String?,
          validFrom: data['valid_from'] != null
              ? DateTime.parse(data['valid_from'] as String)
              : null,
          validUntil: data['valid_until'] != null
              ? DateTime.parse(data['valid_until'] as String)
              : null,
          isActive: (data['is_active'] as int?) == 1,
          isAutoApply: (data['auto_apply'] as int?) == 1,
          description: data['description'] as String?,
          conditions: data['valid_days'] != null
              ? {'valid_days': jsonDecode(data['valid_days'] as String)}
              : {},
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: DateTime.parse(data['updated_at'] as String),
        ));
      }

      return Right(discountList);
    } catch (e) {
      _logger.error('Error getting discounts', e);
      return Left('Failed to load discounts: $e');
    }
  }

  // Add discount rule
  Future<Either<String, Discount>> addDiscount({
    required String businessId,
    required String name,
    required double value,
    required DiscountType type,
    required DiscountScope scope,
    String? code,
    String? description,
    double? minimumAmount,
    double? maximumDiscount,
    DateTime? validFrom,
    DateTime? validUntil,
    bool autoApply = false,
    bool requiresCoupon = false,
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      await _localDatabase.insert('discount_rules', {
        'id': id,
        'business_id': businessId,
        'name': name,
        'code': code,
        'description': description,
        'discount_type': type.name,
        'discount_value': value,
        'max_discount_amount': maximumDiscount,
        'scope': scope.name,
        'auto_apply': autoApply ? 1 : 0,
        'requires_coupon': requiresCoupon ? 1 : 0,
        'combinable': 0,
        'min_purchase_amount': minimumAmount,
        'valid_from': validFrom?.toIso8601String(),
        'valid_until': validUntil?.toIso8601String(),
        'is_active': 1,
        'created_at': now,
        'updated_at': now,
      });

      // Add product associations
      if (productIds != null) {
        for (final productId in productIds) {
          await _localDatabase.insert('discount_products', {
            'id': _uuid.v4(),
            'discount_rule_id': id,
            'product_id': productId,
            'is_active': 1,
            'created_at': now,
          });
        }
      }

      // Add category associations
      if (categoryIds != null) {
        for (final categoryId in categoryIds) {
          await _localDatabase.insert('discount_categories', {
            'id': _uuid.v4(),
            'discount_rule_id': id,
            'category_id': categoryId,
            'is_active': 1,
            'created_at': now,
          });
        }
      }

      // Queue for sync
      await _syncQueueService.addToQueue(
        'discount_rules',
        'create',
        id,
        {
          'id': id,
          'business_id': businessId,
          'name': name,
          'code': code,
          'description': description,
          'discount_type': type.name,
          'discount_value': value,
          'max_discount_amount': maximumDiscount,
          'scope': scope.name,
          'auto_apply': autoApply,
          'requires_coupon': requiresCoupon,
          'min_purchase_amount': minimumAmount,
          'valid_from': validFrom?.toIso8601String(),
          'valid_until': validUntil?.toIso8601String(),
          'is_active': true,
          'created_at': now,
          'updated_at': now,
        },
      );

      final discount = Discount(
        id: id,
        name: name,
        value: value,
        type: type,
        scope: scope,
        minimumAmount: minimumAmount,
        maximumDiscount: maximumDiscount,
        couponCode: code,
        validFrom: validFrom,
        validUntil: validUntil,
        isActive: true,
        isAutoApply: autoApply,
        description: description,
        createdAt: DateTime.parse(now),
        updatedAt: DateTime.parse(now),
      );

      _logger.info('Added discount: $name');
      return Right(discount);
    } catch (e) {
      _logger.error('Error adding discount', e);
      return Left('Failed to add discount: $e');
    }
  }

  // Apply discount (validate and calculate)
  Future<Either<String, double>> applyDiscount({
    required String discountId,
    required double baseAmount,
    String? customerId,
    List<String>? productIds,
    String? categoryId,
  }) async {
    try {
      // Get discount
      final discountData = await _localDatabase.query(
        'discount_rules',
        where: 'id = ? AND is_active = ?',
        whereArgs: [discountId, 1],
        limit: 1,
      );

      if (discountData.isEmpty) {
        return const Left('Discount not found or inactive');
      }

      final discount = discountData.first;
      final now = DateTime.now();

      // Check validity period
      if (discount['valid_from'] != null) {
        final validFrom = DateTime.parse(discount['valid_from'] as String);
        if (now.isBefore(validFrom)) {
          return const Left('Discount not yet valid');
        }
      }

      if (discount['valid_until'] != null) {
        final validUntil = DateTime.parse(discount['valid_until'] as String);
        if (now.isAfter(validUntil)) {
          return const Left('Discount has expired');
        }
      }

      // Check minimum amount
      if (discount['min_purchase_amount'] != null) {
        final minAmount = (discount['min_purchase_amount'] as num).toDouble();
        if (baseAmount < minAmount) {
          return Left('Minimum purchase amount of ₹$minAmount required');
        }
      }

      // Check usage limits
      if (discount['total_usage_limit'] != null) {
        final limit = discount['total_usage_limit'] as int;
        final usage = discount['current_usage_count'] as int? ?? 0;
        if (usage >= limit) {
          return const Left('Discount usage limit reached');
        }
      }

      // Calculate discount amount
      double discountAmount = 0;
      final value = (discount['discount_value'] as num).toDouble();
      final type = discount['discount_type'] as String;

      if (type == 'percentage') {
        discountAmount = baseAmount * (value / 100);
      } else {
        discountAmount = value;
      }

      // Apply maximum discount cap
      if (discount['max_discount_amount'] != null) {
        final maxDiscount = (discount['max_discount_amount'] as num).toDouble();
        if (discountAmount > maxDiscount) {
          discountAmount = maxDiscount;
        }
      }

      // Ensure discount doesn't exceed base amount
      if (discountAmount > baseAmount) {
        discountAmount = baseAmount;
      }

      return Right(discountAmount);
    } catch (e) {
      _logger.error('Error applying discount', e);
      return Left('Failed to apply discount: $e');
    }
  }

  // Validate coupon code
  Future<Either<String, Discount?>> validateCoupon({
    required String code,
    required String businessId,
    String? customerId,
  }) async {
    try {
      final discountData = await _localDatabase.query(
        'discount_rules',
        where: 'business_id = ? AND code = ? AND is_active = ?',
        whereArgs: [businessId, code, 1],
        limit: 1,
      );

      if (discountData.isEmpty) {
        return const Left('Invalid coupon code');
      }

      final data = discountData.first;
      final now = DateTime.now();

      // Check validity
      if (data['valid_from'] != null &&
          now.isBefore(DateTime.parse(data['valid_from'] as String))) {
        return const Left('Coupon not yet valid');
      }

      if (data['valid_until'] != null &&
          now.isAfter(DateTime.parse(data['valid_until'] as String))) {
        return const Left('Coupon has expired');
      }

      // Check usage limits
      if (data['total_usage_limit'] != null) {
        final limit = data['total_usage_limit'] as int;
        final usage = data['current_usage_count'] as int? ?? 0;
        if (usage >= limit) {
          return const Left('Coupon usage limit reached');
        }
      }

      // Check per-customer limit if customerId provided
      if (customerId != null && data['per_customer_limit'] != null) {
        final customerUsage = await _localDatabase.query(
          'discount_usage_history',
          where: 'discount_rule_id = ? AND customer_id = ?',
          whereArgs: [data['id'], customerId],
        );

        final limit = data['per_customer_limit'] as int;
        if (customerUsage.length >= limit) {
          return const Left('You have already used this coupon');
        }
      }

      final discount = Discount(
        id: data['id'] as String,
        name: data['name'] as String,
        value: (data['discount_value'] as num).toDouble(),
        type: DiscountType.values.firstWhere(
          (t) => t.name == data['discount_type'],
          orElse: () => DiscountType.percentage,
        ),
        scope: DiscountScope.values.firstWhere(
          (s) => s.name == data['scope'],
          orElse: () => DiscountScope.cart,
        ),
        minimumAmount: data['min_purchase_amount'] != null
            ? (data['min_purchase_amount'] as num).toDouble()
            : null,
        maximumDiscount: data['max_discount_amount'] != null
            ? (data['max_discount_amount'] as num).toDouble()
            : null,
        couponCode: code,
        isActive: true,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: DateTime.parse(data['updated_at'] as String),
      );

      return Right(discount);
    } catch (e) {
      _logger.error('Error validating coupon', e);
      return Left('Failed to validate coupon: $e');
    }
  }

  // Record discount usage
  Future<Either<String, void>> recordDiscountUsage({
    required String discountId,
    required String orderId,
    required double discountAmount,
    String? customerId,
    String? locationId,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now().toIso8601String();

      // Record usage
      await _localDatabase.insert('discount_usage_history', {
        'id': id,
        'discount_rule_id': discountId,
        'order_id': orderId,
        'customer_id': customerId,
        'discount_amount': discountAmount,
        'used_at': now,
        'location_id': locationId,
      });

      // Update usage count
      await _localDatabase.rawUpdate(
        'UPDATE discount_rules SET current_usage_count = current_usage_count + 1 WHERE id = ?',
        [discountId],
      );

      // Queue for sync
      await _syncQueueService.addToQueue(
        'discount_usage_history',
        'create',
        id,
        {
          'id': id,
          'discount_rule_id': discountId,
          'order_id': orderId,
          'customer_id': customerId,
          'discount_amount': discountAmount,
          'used_at': now,
          'location_id': locationId,
        },
      );

      _logger.info('Recorded discount usage for order: $orderId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error recording discount usage', e);
      return Left('Failed to record discount usage: $e');
    }
  }

  // Update discount rule
  Future<Either<String, Discount>> updateDiscount({
    required String discountId,
    required String name,
    required double value,
    required DiscountType type,
    required DiscountScope scope,
    String? code,
    String? description,
    double? minimumAmount,
    double? maximumDiscount,
    DateTime? validFrom,
    DateTime? validUntil,
    bool autoApply = false,
    bool requiresCoupon = false,
    bool isActive = true,
    List<String>? productIds,
    List<String>? categoryIds,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      // Update the discount rule
      await _localDatabase.update(
        'discount_rules',
        {
          'name': name,
          'code': code,
          'description': description,
          'discount_type': type.name,
          'discount_value': value,
          'max_discount_amount': maximumDiscount,
          'scope': scope.name,
          'auto_apply': autoApply ? 1 : 0,
          'requires_coupon': requiresCoupon ? 1 : 0,
          'min_purchase_amount': minimumAmount,
          'valid_from': validFrom?.toIso8601String(),
          'valid_until': validUntil?.toIso8601String(),
          'is_active': isActive ? 1 : 0,
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [discountId],
      );
      
      // Delete existing product associations
      await _localDatabase.delete(
        'discount_products',
        where: 'discount_rule_id = ?',
        whereArgs: [discountId],
      );
      
      // Delete existing category associations
      await _localDatabase.delete(
        'discount_categories',
        where: 'discount_rule_id = ?',
        whereArgs: [discountId],
      );
      
      // Add new product associations
      if (productIds != null) {
        for (final productId in productIds) {
          await _localDatabase.insert('discount_products', {
            'id': _uuid.v4(),
            'discount_rule_id': discountId,
            'product_id': productId,
            'is_active': 1,
            'created_at': now,
          });
        }
      }
      
      // Add new category associations
      if (categoryIds != null) {
        for (final categoryId in categoryIds) {
          await _localDatabase.insert('discount_categories', {
            'id': _uuid.v4(),
            'discount_rule_id': discountId,
            'category_id': categoryId,
            'is_active': 1,
            'created_at': now,
          });
        }
      }
      
      // Get business_id from the existing record for sync
      final existingRecord = await _localDatabase.query(
        'discount_rules',
        where: 'id = ?',
        whereArgs: [discountId],
        limit: 1,
      );
      
      final businessId = existingRecord.isNotEmpty 
          ? existingRecord.first['business_id'] as String
          : throw Exception('Discount not found');
      
      // Queue for sync
      await _syncQueueService.addToQueue(
        'discount_rules',
        'UPDATE',
        discountId,
        {
          'id': discountId,
          'business_id': businessId,  // Include business_id for Supabase
          'name': name,
          'code': code,
          'description': description,
          'discount_type': type.name,
          'discount_value': value,
          'max_discount_amount': maximumDiscount,
          'scope': scope.name,
          'auto_apply': autoApply,
          'requires_coupon': requiresCoupon,
          'min_purchase_amount': minimumAmount,
          'valid_from': validFrom?.toIso8601String(),
          'valid_until': validUntil?.toIso8601String(),
          'is_active': isActive,
          'updated_at': now,
        },
      );
      
      final discount = Discount(
        id: discountId,
        name: name,
        value: value,
        type: type,
        scope: scope,
        minimumAmount: minimumAmount,
        maximumDiscount: maximumDiscount,
        couponCode: code,
        validFrom: validFrom,
        validUntil: validUntil,
        isActive: isActive,
        isAutoApply: autoApply,
        description: description,
        createdAt: DateTime.now(), // We don't have the original created date
        updatedAt: DateTime.parse(now),
      );
      
      _logger.info('Updated discount: $name');
      return Right(discount);
    } catch (e) {
      _logger.error('Error updating discount', e);
      return Left('Failed to update discount: $e');
    }
  }

  // Delete discount rule
  Future<Either<String, void>> deleteDiscount(String discountId) async {
    try {
      // Delete associated products
      await _localDatabase.delete(
        'discount_products',
        where: 'discount_rule_id = ?',
        whereArgs: [discountId],
      );
      
      // Delete associated categories
      await _localDatabase.delete(
        'discount_categories',
        where: 'discount_rule_id = ?',
        whereArgs: [discountId],
      );
      
      // Delete the discount rule
      await _localDatabase.delete(
        'discount_rules',
        where: 'id = ?',
        whereArgs: [discountId],
      );
      
      // Queue for sync
      await _syncQueueService.addToQueue(
        'discount_rules',
        'DELETE',
        discountId,
        {'id': discountId},
      );
      
      _logger.info('Deleted discount: $discountId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error deleting discount', e);
      return Left('Failed to delete discount: $e');
    }
  }

  // Toggle discount status
  Future<Either<String, void>> toggleDiscountStatus(String discountId, bool isActive) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      await _localDatabase.update(
        'discount_rules',
        {
          'is_active': isActive ? 1 : 0,
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [discountId],
      );
      
      // Queue for sync
      await _syncQueueService.addToQueue(
        'discount_rules',
        'UPDATE',
        discountId,
        {
          'id': discountId,
          'is_active': isActive,
          'updated_at': now,
        },
      );
      
      _logger.info('Toggled discount status: $discountId to $isActive');
      return const Right(null);
    } catch (e) {
      _logger.error('Error toggling discount status', e);
      return Left('Failed to toggle discount status: $e');
    }
  }

  // Get applicable discounts for cart
  Future<Either<String, List<Discount>>> getApplicableDiscounts({
    required String businessId,
    required double cartTotal,
    List<String>? productIds,
    List<String>? categoryIds,
    String? customerId,
  }) async {
    try {
      _logger.info('Getting applicable discounts for business: $businessId, cart total: $cartTotal');
      
      // Get all active discounts
      final discountsResult = await getDiscounts(
        businessId: businessId,
        status: 'active',
      );

      if (discountsResult.isLeft()) {
        _logger.error('Failed to get active discounts');
        return discountsResult;
      }

      final allDiscounts = discountsResult.getOrElse(() => []);
      _logger.info('Found ${allDiscounts.length} active discounts');
      
      final applicableDiscounts = <Discount>[];

      for (final discount in allDiscounts) {
        _logger.info('Checking discount: ${discount.name}, coupon: ${discount.couponCode}, autoApply: ${discount.isAutoApply}');
        
        // Skip coupon-required discounts (they should be applied via coupon code)
        if (discount.couponCode != null && discount.couponCode!.isNotEmpty) {
          _logger.info('Skipping ${discount.name} - requires coupon code');
          continue;
        }

        // Check minimum amount
        if (discount.minimumAmount != null &&
            cartTotal < discount.minimumAmount!) {
          _logger.info('Skipping ${discount.name} - minimum amount not met');
          continue;
        }

        // Check scope
        if (discount.scope == DiscountScope.item) {
          if (productIds == null || productIds.isEmpty) {
            _logger.info('Skipping ${discount.name} - no products in cart for item-specific discount');
            continue;
          }
          // Check if any cart product is eligible
          final eligibleProducts = await _localDatabase.query(
            'discount_products',
            where: 'discount_rule_id = ? AND product_id IN (${productIds.map((_) => '?').join(',')})',
            whereArgs: [discount.id, ...productIds],
          );

          if (eligibleProducts.isEmpty) {
            _logger.info('Skipping ${discount.name} - no eligible products in cart');
            continue;
          }
        } else if (discount.scope == DiscountScope.category) {
          if (categoryIds == null || categoryIds.isEmpty) {
            _logger.info('Skipping ${discount.name} - no category info available for category-specific discount');
            continue;
          }
          // Check if any cart category is eligible
          final eligibleCategories = await _localDatabase.query(
            'discount_categories',
            where: 'discount_rule_id = ? AND category_id IN (${categoryIds.map((_) => '?').join(',')})',
            whereArgs: [discount.id, ...categoryIds],
          );

          if (eligibleCategories.isEmpty) {
            _logger.info('Skipping ${discount.name} - no eligible categories in cart');
            continue;
          }
        }

        _logger.info('Adding ${discount.name} to applicable discounts');
        applicableDiscounts.add(discount);
      }

      // Sort by priority (highest discount first)
      applicableDiscounts.sort((a, b) {
        final aDiscount = a.calculateDiscount(cartTotal);
        final bDiscount = b.calculateDiscount(cartTotal);
        return bDiscount.compareTo(aDiscount);
      });

      _logger.info('Returning ${applicableDiscounts.length} applicable discounts');
      return Right(applicableDiscounts);
    } catch (e) {
      _logger.error('Error getting applicable discounts', e);
      return Left('Failed to get applicable discounts: $e');
    }
  }
}
