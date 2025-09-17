import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../models/charge.dart';
import '../../../services/database_schema.dart';

class ChargeRepository {
  final Database localDatabase;
  final SupabaseClient supabase;
  final SyncQueueService syncQueueService;
  
  static final _logger = Logger('ChargeRepository');
  static const _uuid = Uuid();

  ChargeRepository({
    required this.localDatabase,
    required this.supabase,
    required this.syncQueueService,
  });

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    // Ensure schema tables via centralized schema
    await DatabaseSchema.applySqliteSchema(localDatabase);

    // Optional table not present in schema: keep if used by app
    await localDatabase.execute('''
      CREATE TABLE IF NOT EXISTS charge_formulas (
        id TEXT PRIMARY KEY,
        charge_id TEXT NOT NULL,
        base_amount REAL DEFAULT 0,
        variable_rate REAL DEFAULT 0,
        variable_type TEXT,
        min_charge REAL,
        max_charge REAL,
        formula_expression TEXT,
        custom_variables TEXT,
        created_at TEXT NOT NULL,
        has_unsynced_changes INTEGER DEFAULT 0,
        FOREIGN KEY (charge_id) REFERENCES charges(id)
      )
    ''');
  }

  // Get all charges for a business
  Future<Either<String, List<Charge>>> getCharges({
    required String businessId,
    String? locationId,
    bool activeOnly = true,
  }) async {
    try {
      String query = 'SELECT * FROM charges WHERE business_id = ?';
      List<dynamic> args = [businessId];
      
      if (locationId != null) {
        query += ' AND (location_id IS NULL OR location_id = ?)';
        args.add(locationId);
      }
      
      if (activeOnly) {
        query += ' AND is_active = 1';
      }
      
      query += ' ORDER BY display_order ASC, name ASC';
      
      final results = await localDatabase.rawQuery(query, args);
      
      final charges = <Charge>[];
      for (final row in results) {
        final charge = await _chargeFromLocalJson(row);
        charges.add(charge);
      }
      
      return Right(charges);
    } catch (e, stackTrace) {
      _logger.error('Failed to get charges', e, stackTrace);
      return Left('Failed to get charges: $e');
    }
  }

  // Get applicable charges for an order
  Future<Either<String, List<Charge>>> getApplicableCharges({
    required String businessId,
    String? locationId,
    required double orderValue,
    String? customerId,
    List<String>? categoryIds,
    List<String>? productIds,
    String? customerGroupId,
  }) async {
    try {
      // Get all active charges
      final chargesResult = await getCharges(
        businessId: businessId,
        locationId: locationId,
        activeOnly: true,
      );
      
      if (chargesResult.isLeft()) {
        return chargesResult;
      }
      
      final allCharges = chargesResult.getOrElse(() => []);
      final applicableCharges = <Charge>[];
      
      for (final charge in allCharges) {
        // Check if charge is applicable
        bool isApplicable = charge.isApplicable(
          orderValue: orderValue,
          categoryId: categoryIds?.isNotEmpty == true ? categoryIds!.first : null,
          productId: productIds?.isNotEmpty == true ? productIds!.first : null,
          customerGroupId: customerGroupId,
        );
        
        if (isApplicable) {
          // Check for customer exemptions
          if (customerId != null) {
            final hasExemption = await _hasCustomerExemption(
              customerId: customerId,
              chargeId: charge.id,
            );
            
            if (!hasExemption) {
              applicableCharges.add(charge);
            }
          } else {
            applicableCharges.add(charge);
          }
        }
      }
      
      return Right(applicableCharges);
    } catch (e, stackTrace) {
      _logger.error('Failed to get applicable charges', e, stackTrace);
      return Left('Failed to get applicable charges: $e');
    }
  }

  // Add a new charge
  Future<Either<String, Charge>> addCharge({
    required String businessId,
    required String code,
    required String name,
    required ChargeType chargeType,
    required CalculationType calculationType,
    String? locationId,
    String? description,
    double? value,
    ChargeScope scope = ChargeScope.order,
    bool autoApply = false,
    bool isMandatory = false,
    bool isTaxable = true,
    bool applyBeforeDiscount = false,
    double? minimumOrderValue,
    double? maximumOrderValue,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String>? applicableDays,
    Map<String, dynamic>? applicableTimeSlots,
    List<String>? applicableCategories,
    List<String>? applicableProducts,
    List<String>? excludedCategories,
    List<String>? excludedProducts,
    List<String>? applicableCustomerGroups,
    List<String>? excludedCustomerGroups,
    int displayOrder = 0,
    bool showInPos = true,
    bool showInInvoice = true,
    bool showInOnline = true,
    String? iconName,
    String? colorHex,
    List<ChargeTier>? tiers,
    ChargeFormula? formula,
  }) async {
    try {
      final chargeId = _uuid.v4();
      final now = DateTime.now();
      
      final charge = Charge(
        id: chargeId,
        businessId: businessId,
        locationId: locationId,
        code: code,
        name: name,
        description: description,
        chargeType: chargeType,
        calculationType: calculationType,
        value: value,
        scope: scope,
        autoApply: autoApply,
        isMandatory: isMandatory,
        isTaxable: isTaxable,
        applyBeforeDiscount: applyBeforeDiscount,
        minimumOrderValue: minimumOrderValue,
        maximumOrderValue: maximumOrderValue,
        validFrom: validFrom,
        validUntil: validUntil,
        applicableDays: applicableDays ?? [],
        applicableTimeSlots: applicableTimeSlots,
        applicableCategories: applicableCategories ?? [],
        applicableProducts: applicableProducts ?? [],
        excludedCategories: excludedCategories ?? [],
        excludedProducts: excludedProducts ?? [],
        applicableCustomerGroups: applicableCustomerGroups ?? [],
        excludedCustomerGroups: excludedCustomerGroups ?? [],
        displayOrder: displayOrder,
        showInPos: showInPos,
        showInInvoice: showInInvoice,
        showInOnline: showInOnline,
        iconName: iconName,
        colorHex: colorHex,
        tiers: tiers ?? [],
        formula: formula,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
      
      // Save to local database
      await _saveChargeToLocal(charge);
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'charges',
        'INSERT',
        chargeId,
        _chargeToSupabaseFormat(charge),
      );
      
      // Save tiers if any
      if (tiers != null && tiers.isNotEmpty) {
        for (final tier in tiers) {
          await _saveTierToLocal(tier.copyWith(chargeId: chargeId));
          await syncQueueService.addToQueue(
            'charge_tiers',
            'INSERT',
            tier.id,
            _tierToSupabaseFormat(tier.copyWith(chargeId: chargeId)),
          );
        }
      }
      
      // Save formula if any
      if (formula != null) {
        await _saveFormulaToLocal(formula.copyWith(chargeId: chargeId));
        await syncQueueService.addToQueue(
          'charge_formulas',
          'INSERT',
          formula.id,
          _formulaToSupabaseFormat(formula.copyWith(chargeId: chargeId)),
        );
      }
      
      _logger.info('Added charge: $name');
      return Right(charge);
    } catch (e, stackTrace) {
      _logger.error('Failed to add charge', e, stackTrace);
      return Left('Failed to add charge: $e');
    }
  }

  // Update a charge
  Future<Either<String, Charge>> updateCharge({
    required String chargeId,
    required String name,
    required ChargeType chargeType,
    required CalculationType calculationType,
    String? description,
    double? value,
    ChargeScope? scope,
    bool? autoApply,
    bool? isMandatory,
    bool? isTaxable,
    bool? applyBeforeDiscount,
    double? minimumOrderValue,
    double? maximumOrderValue,
    DateTime? validFrom,
    DateTime? validUntil,
    List<String>? applicableDays,
    Map<String, dynamic>? applicableTimeSlots,
    List<String>? applicableCategories,
    List<String>? applicableProducts,
    List<String>? excludedCategories,
    List<String>? excludedProducts,
    List<String>? applicableCustomerGroups,
    List<String>? excludedCustomerGroups,
    int? displayOrder,
    bool? showInPos,
    bool? showInInvoice,
    bool? showInOnline,
    String? iconName,
    String? colorHex,
    bool? isActive,
    List<ChargeTier>? tiers,
    ChargeFormula? formula,
  }) async {
    try {
      // Get existing charge
      final existingResult = await _getChargeById(chargeId);
      if (existingResult.isLeft()) {
        return Left('Charge not found');
      }
      
      final existingCharge = existingResult.getOrElse(() => throw Exception());
      
      // Update charge
      final updatedCharge = existingCharge.copyWith(
        name: name,
        description: description ?? existingCharge.description,
        chargeType: chargeType,
        calculationType: calculationType,
        value: value ?? existingCharge.value,
        scope: scope ?? existingCharge.scope,
        autoApply: autoApply ?? existingCharge.autoApply,
        isMandatory: isMandatory ?? existingCharge.isMandatory,
        isTaxable: isTaxable ?? existingCharge.isTaxable,
        applyBeforeDiscount: applyBeforeDiscount ?? existingCharge.applyBeforeDiscount,
        minimumOrderValue: minimumOrderValue,
        maximumOrderValue: maximumOrderValue,
        validFrom: validFrom,
        validUntil: validUntil,
        applicableDays: applicableDays ?? existingCharge.applicableDays,
        applicableTimeSlots: applicableTimeSlots ?? existingCharge.applicableTimeSlots,
        applicableCategories: applicableCategories ?? existingCharge.applicableCategories,
        applicableProducts: applicableProducts ?? existingCharge.applicableProducts,
        excludedCategories: excludedCategories ?? existingCharge.excludedCategories,
        excludedProducts: excludedProducts ?? existingCharge.excludedProducts,
        applicableCustomerGroups: applicableCustomerGroups ?? existingCharge.applicableCustomerGroups,
        excludedCustomerGroups: excludedCustomerGroups ?? existingCharge.excludedCustomerGroups,
        displayOrder: displayOrder ?? existingCharge.displayOrder,
        showInPos: showInPos ?? existingCharge.showInPos,
        showInInvoice: showInInvoice ?? existingCharge.showInInvoice,
        showInOnline: showInOnline ?? existingCharge.showInOnline,
        iconName: iconName ?? existingCharge.iconName,
        colorHex: colorHex ?? existingCharge.colorHex,
        tiers: tiers ?? existingCharge.tiers,
        formula: formula ?? existingCharge.formula,
        isActive: isActive ?? existingCharge.isActive,
        updatedAt: DateTime.now(),
      );
      
      // Update in local database
      await _updateChargeInLocal(updatedCharge);
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'charges',
        'UPDATE',
        chargeId,
        _chargeToSupabaseFormat(updatedCharge),
      );
      
      _logger.info('Updated charge: $name');
      return Right(updatedCharge);
    } catch (e, stackTrace) {
      _logger.error('Failed to update charge', e, stackTrace);
      return Left('Failed to update charge: $e');
    }
  }

  // Delete a charge
  Future<Either<String, void>> deleteCharge(String chargeId) async {
    try {
      // Soft delete by marking as inactive
      await localDatabase.update(
        'charges',
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [chargeId],
      );
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'charges',
        'UPDATE',
        chargeId,
        {'is_active': false},
      );
      
      _logger.info('Deleted charge: $chargeId');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete charge', e, stackTrace);
      return Left('Failed to delete charge: $e');
    }
  }

  // Apply charges to an order
  Future<Either<String, List<AppliedCharge>>> applyChargesToOrder({
    required String orderId,
    required List<Charge> charges,
    required double orderSubtotal,
    String? addedBy,
  }) async {
    try {
      final appliedCharges = <AppliedCharge>[];
      final now = DateTime.now();
      
      for (final charge in charges) {
        final chargeAmount = charge.calculateCharge(orderSubtotal);
        
        if (chargeAmount > 0) {
          final appliedChargeId = _uuid.v4();
          
          final appliedCharge = AppliedCharge(
            id: appliedChargeId,
            orderId: orderId,
            chargeId: charge.id,
            chargeCode: charge.code,
            chargeName: charge.name,
            chargeType: charge.chargeType.name,
            calculationType: charge.calculationType.name,
            baseAmount: orderSubtotal,
            chargeRate: charge.value,
            chargeAmount: chargeAmount,
            isTaxable: charge.isTaxable,
            addedBy: addedBy,
            createdAt: now,
          );
          
          // Save to local database
          await _saveAppliedChargeToLocal(appliedCharge);
          
          // Add to sync queue
          await syncQueueService.addToQueue(
            'order_charges',
            'INSERT',
            appliedChargeId,
            _appliedChargeToSupabaseFormat(appliedCharge),
          );
          
          appliedCharges.add(appliedCharge);
        }
      }
      
      _logger.info('Applied ${appliedCharges.length} charges to order: $orderId');
      return Right(appliedCharges);
    } catch (e, stackTrace) {
      _logger.error('Failed to apply charges to order', e, stackTrace);
      return Left('Failed to apply charges: $e');
    }
  }

  // Helper methods for local database operations
  Future<void> _saveChargeToLocal(Charge charge) async {
    await localDatabase.insert(
      'charges',
      _chargeToLocalJson(charge),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _updateChargeInLocal(Charge charge) async {
    await localDatabase.update(
      'charges',
      {
        ..._chargeToLocalJson(charge),
        'has_unsynced_changes': 1,
      },
      where: 'id = ?',
      whereArgs: [charge.id],
    );
  }

  Future<void> _saveTierToLocal(ChargeTier tier) async {
    await localDatabase.insert(
      'charge_tiers',
      _tierToLocalJson(tier),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveFormulaToLocal(ChargeFormula formula) async {
    await localDatabase.insert(
      'charge_formulas',
      _formulaToLocalJson(formula),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveAppliedChargeToLocal(AppliedCharge charge) async {
    await localDatabase.insert(
      'order_charges',
      _appliedChargeToLocalJson(charge),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Either<String, Charge>> _getChargeById(String chargeId) async {
    try {
      final results = await localDatabase.query(
        'charges',
        where: 'id = ?',
        whereArgs: [chargeId],
      );
      
      if (results.isEmpty) {
        return Left('Charge not found');
      }
      
      final charge = await _chargeFromLocalJson(results.first);
      return Right(charge);
    } catch (e) {
      return Left('Failed to get charge: $e');
    }
  }

  Future<bool> _hasCustomerExemption({
    required String customerId,
    required String chargeId,
  }) async {
    final results = await localDatabase.query(
      'customer_charge_exemptions',
      where: 'customer_id = ? AND charge_id = ? AND is_active = 1 AND exemption_type = ?',
      whereArgs: [customerId, chargeId, 'full'],
    );
    
    return results.isNotEmpty;
  }

  // Convert Charge to/from local JSON
  Map<String, dynamic> _chargeToLocalJson(Charge charge) {
    return {
      'id': charge.id,
      'business_id': charge.businessId,
      'location_id': charge.locationId,
      'code': charge.code,
      'name': charge.name,
      'description': charge.description,
      'charge_type': charge.chargeType.name,
      'calculation_type': charge.calculationType.name,
      'value': charge.value,
      'scope': charge.scope.name,
      'auto_apply': charge.autoApply ? 1 : 0,
      'is_mandatory': charge.isMandatory ? 1 : 0,
      'is_taxable': charge.isTaxable ? 1 : 0,
      'apply_before_discount': charge.applyBeforeDiscount ? 1 : 0,
      'minimum_order_value': charge.minimumOrderValue,
      'maximum_order_value': charge.maximumOrderValue,
      'valid_from': charge.validFrom?.toIso8601String(),
      'valid_until': charge.validUntil?.toIso8601String(),
      'applicable_days': jsonEncode(charge.applicableDays),
      'applicable_time_slots': charge.applicableTimeSlots != null 
          ? jsonEncode(charge.applicableTimeSlots) : null,
      'applicable_categories': jsonEncode(charge.applicableCategories),
      'applicable_products': jsonEncode(charge.applicableProducts),
      'excluded_categories': jsonEncode(charge.excludedCategories),
      'excluded_products': jsonEncode(charge.excludedProducts),
      'applicable_customer_groups': jsonEncode(charge.applicableCustomerGroups),
      'excluded_customer_groups': jsonEncode(charge.excludedCustomerGroups),
      'display_order': charge.displayOrder,
      'show_in_pos': charge.showInPos ? 1 : 0,
      'show_in_invoice': charge.showInInvoice ? 1 : 0,
      'show_in_online': charge.showInOnline ? 1 : 0,
      'icon_name': charge.iconName,
      'color_hex': charge.colorHex,
      'is_active': charge.isActive ? 1 : 0,
      'created_at': charge.createdAt.toIso8601String(),
      'updated_at': charge.updatedAt.toIso8601String(),
      'created_by': charge.createdBy,
    };
  }

  Future<Charge> _chargeFromLocalJson(Map<String, dynamic> json) async {
    // Get tiers for this charge
    final tiersResult = await localDatabase.query(
      'charge_tiers',
      where: 'charge_id = ?',
      whereArgs: [json['id']],
      orderBy: 'display_order ASC, min_value ASC',
    );
    
    final tiers = tiersResult.map((t) => _tierFromLocalJson(t)).toList();
    
    // Get formula for this charge
    final formulaResult = await localDatabase.query(
      'charge_formulas',
      where: 'charge_id = ?',
      whereArgs: [json['id']],
    );
    
    ChargeFormula? formula;
    if (formulaResult.isNotEmpty) {
      formula = _formulaFromLocalJson(formulaResult.first);
    }
    
    return Charge(
      id: json['id'],
      businessId: json['business_id'],
      locationId: json['location_id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      chargeType: ChargeType.values.firstWhere(
        (e) => e.name == json['charge_type'],
      ),
      calculationType: CalculationType.values.firstWhere(
        (e) => e.name == json['calculation_type'],
      ),
      value: json['value']?.toDouble(),
      scope: ChargeScope.values.firstWhere(
        (e) => e.name == json['scope'],
        orElse: () => ChargeScope.order,
      ),
      autoApply: json['auto_apply'] == 1,
      isMandatory: json['is_mandatory'] == 1,
      isTaxable: json['is_taxable'] == 1,
      applyBeforeDiscount: json['apply_before_discount'] == 1,
      minimumOrderValue: json['minimum_order_value']?.toDouble(),
      maximumOrderValue: json['maximum_order_value']?.toDouble(),
      validFrom: json['valid_from'] != null 
          ? DateTime.parse(json['valid_from']) : null,
      validUntil: json['valid_until'] != null 
          ? DateTime.parse(json['valid_until']) : null,
      applicableDays: json['applicable_days'] != null
          ? List<String>.from(jsonDecode(json['applicable_days']))
          : [],
      applicableTimeSlots: json['applicable_time_slots'] != null
          ? jsonDecode(json['applicable_time_slots'])
          : null,
      applicableCategories: json['applicable_categories'] != null
          ? List<String>.from(jsonDecode(json['applicable_categories']))
          : [],
      applicableProducts: json['applicable_products'] != null
          ? List<String>.from(jsonDecode(json['applicable_products']))
          : [],
      excludedCategories: json['excluded_categories'] != null
          ? List<String>.from(jsonDecode(json['excluded_categories']))
          : [],
      excludedProducts: json['excluded_products'] != null
          ? List<String>.from(jsonDecode(json['excluded_products']))
          : [],
      applicableCustomerGroups: json['applicable_customer_groups'] != null
          ? List<String>.from(jsonDecode(json['applicable_customer_groups']))
          : [],
      excludedCustomerGroups: json['excluded_customer_groups'] != null
          ? List<String>.from(jsonDecode(json['excluded_customer_groups']))
          : [],
      displayOrder: json['display_order'] ?? 0,
      showInPos: json['show_in_pos'] == 1,
      showInInvoice: json['show_in_invoice'] == 1,
      showInOnline: json['show_in_online'] == 1,
      iconName: json['icon_name'],
      colorHex: json['color_hex'],
      tiers: tiers,
      formula: formula,
      isActive: json['is_active'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'],
    );
  }

  // Convert to Supabase format (snake_case)
  Map<String, dynamic> _chargeToSupabaseFormat(Charge charge) {
    return {
      'id': charge.id,
      'business_id': charge.businessId,
      'location_id': charge.locationId,
      'code': charge.code,
      'name': charge.name,
      'description': charge.description,
      'charge_type': charge.chargeType.name,
      'calculation_type': charge.calculationType.name,
      'value': charge.value,
      'scope': charge.scope.name,
      'auto_apply': charge.autoApply,
      'is_mandatory': charge.isMandatory,
      'is_taxable': charge.isTaxable,
      'apply_before_discount': charge.applyBeforeDiscount,
      'minimum_order_value': charge.minimumOrderValue,
      'maximum_order_value': charge.maximumOrderValue,
      'valid_from': charge.validFrom?.toIso8601String(),
      'valid_until': charge.validUntil?.toIso8601String(),
      'applicable_days': charge.applicableDays,
      'applicable_time_slots': charge.applicableTimeSlots,
      'applicable_categories': charge.applicableCategories,
      'applicable_products': charge.applicableProducts,
      'excluded_categories': charge.excludedCategories,
      'excluded_products': charge.excludedProducts,
      'applicable_customer_groups': charge.applicableCustomerGroups,
      'excluded_customer_groups': charge.excludedCustomerGroups,
      'display_order': charge.displayOrder,
      'show_in_pos': charge.showInPos,
      'show_in_invoice': charge.showInInvoice,
      'show_in_online': charge.showInOnline,
      'icon_name': charge.iconName,
      'color_hex': charge.colorHex,
      'is_active': charge.isActive,
      'created_at': charge.createdAt.toIso8601String(),
      'updated_at': charge.updatedAt.toIso8601String(),
      'created_by': charge.createdBy,
    };
  }

  // Helper methods for tiers
  Map<String, dynamic> _tierToLocalJson(ChargeTier tier) {
    return {
      'id': tier.id,
      'charge_id': tier.chargeId,
      'tier_name': tier.tierName,
      'min_value': tier.minValue,
      'max_value': tier.maxValue,
      'charge_value': tier.chargeValue,
      'display_order': tier.displayOrder,
      'created_at': tier.createdAt.toIso8601String(),
    };
  }

  ChargeTier _tierFromLocalJson(Map<String, dynamic> json) {
    return ChargeTier(
      id: json['id'],
      chargeId: json['charge_id'],
      tierName: json['tier_name'],
      minValue: json['min_value'].toDouble(),
      maxValue: json['max_value']?.toDouble(),
      chargeValue: json['charge_value'].toDouble(),
      displayOrder: json['display_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> _tierToSupabaseFormat(ChargeTier tier) {
    return {
      'id': tier.id,
      'charge_id': tier.chargeId,
      'tier_name': tier.tierName,
      'min_value': tier.minValue,
      'max_value': tier.maxValue,
      'charge_value': tier.chargeValue,
      'display_order': tier.displayOrder,
      'created_at': tier.createdAt.toIso8601String(),
    };
  }

  // Helper methods for formulas
  Map<String, dynamic> _formulaToLocalJson(ChargeFormula formula) {
    return {
      'id': formula.id,
      'charge_id': formula.chargeId,
      'base_amount': formula.baseAmount,
      'variable_rate': formula.variableRate,
      'variable_type': formula.variableType,
      'min_charge': formula.minCharge,
      'max_charge': formula.maxCharge,
      'formula_expression': formula.formulaExpression,
      'custom_variables': formula.customVariables != null
          ? jsonEncode(formula.customVariables) : null,
      'created_at': formula.createdAt.toIso8601String(),
    };
  }

  ChargeFormula _formulaFromLocalJson(Map<String, dynamic> json) {
    return ChargeFormula(
      id: json['id'],
      chargeId: json['charge_id'],
      baseAmount: json['base_amount']?.toDouble() ?? 0,
      variableRate: json['variable_rate']?.toDouble() ?? 0,
      variableType: json['variable_type'],
      minCharge: json['min_charge']?.toDouble(),
      maxCharge: json['max_charge']?.toDouble(),
      formulaExpression: json['formula_expression'],
      customVariables: json['custom_variables'] != null
          ? jsonDecode(json['custom_variables'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> _formulaToSupabaseFormat(ChargeFormula formula) {
    return {
      'id': formula.id,
      'charge_id': formula.chargeId,
      'base_amount': formula.baseAmount,
      'variable_rate': formula.variableRate,
      'variable_type': formula.variableType,
      'min_charge': formula.minCharge,
      'max_charge': formula.maxCharge,
      'formula_expression': formula.formulaExpression,
      'custom_variables': formula.customVariables,
      'created_at': formula.createdAt.toIso8601String(),
    };
  }

  // Helper methods for applied charges
  Map<String, dynamic> _appliedChargeToLocalJson(AppliedCharge charge) {
    return {
      'id': charge.id,
      'order_id': charge.orderId,
      'charge_id': charge.chargeId,
      'charge_code': charge.chargeCode,
      'charge_name': charge.chargeName,
      'charge_type': charge.chargeType,
      'calculation_type': charge.calculationType,
      'base_amount': charge.baseAmount,
      'charge_rate': charge.chargeRate,
      'charge_amount': charge.chargeAmount,
      'is_taxable': charge.isTaxable ? 1 : 0,
      'tax_amount': charge.taxAmount,
      'is_manual': charge.isManual ? 1 : 0,
      'original_amount': charge.originalAmount,
      'adjustment_reason': charge.adjustmentReason,
      'added_by': charge.addedBy,
      'removed_by': charge.removedBy,
      'is_removed': charge.isRemoved ? 1 : 0,
      'removed_at': charge.removedAt?.toIso8601String(),
      'notes': charge.notes,
      'created_at': charge.createdAt.toIso8601String(),
      'updated_at': charge.updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> _appliedChargeToSupabaseFormat(AppliedCharge charge) {
    return {
      'id': charge.id,
      'order_id': charge.orderId,
      'charge_id': charge.chargeId,
      'charge_code': charge.chargeCode,
      'charge_name': charge.chargeName,
      'charge_type': charge.chargeType,
      'calculation_type': charge.calculationType,
      'base_amount': charge.baseAmount,
      'charge_rate': charge.chargeRate,
      'charge_amount': charge.chargeAmount,
      'is_taxable': charge.isTaxable,
      'tax_amount': charge.taxAmount,
      'is_manual': charge.isManual,
      'original_amount': charge.originalAmount,
      'adjustment_reason': charge.adjustmentReason,
      'added_by': charge.addedBy,
      'removed_by': charge.removedBy,
      'is_removed': charge.isRemoved,
      'removed_at': charge.removedAt?.toIso8601String(),
      'notes': charge.notes,
      'created_at': charge.createdAt.toIso8601String(),
      'updated_at': charge.updatedAt?.toIso8601String(),
    };
  }
}
