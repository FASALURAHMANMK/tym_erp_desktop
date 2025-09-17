import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../models/payment_method.dart';

class PaymentMethodRepository {
  final Database localDatabase;
  final SupabaseClient supabase;
  final SyncQueueService syncQueueService;
  
  static final _logger = Logger('PaymentMethodRepository');
  static const _uuid = Uuid();

  PaymentMethodRepository({
    required this.localDatabase,
    required this.supabase,
    required this.syncQueueService,
  });

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    await localDatabase.execute('''
      CREATE TABLE IF NOT EXISTS payment_methods (
        id TEXT PRIMARY KEY,
        business_id TEXT NOT NULL,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        icon TEXT,
        is_active INTEGER DEFAULT 1,
        is_default INTEGER DEFAULT 0,
        requires_reference INTEGER DEFAULT 0,
        requires_approval INTEGER DEFAULT 0,
        display_order INTEGER DEFAULT 0,
        settings TEXT DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        created_by TEXT,
        has_unsynced_changes INTEGER DEFAULT 0
      )
    ''');

    await localDatabase.execute('''
      CREATE INDEX IF NOT EXISTS idx_payment_methods_business 
      ON payment_methods(business_id)
    ''');

    await localDatabase.execute('''
      CREATE INDEX IF NOT EXISTS idx_payment_methods_code 
      ON payment_methods(business_id, code)
    ''');
  }

  // Get all payment methods for a business
  Future<Either<String, List<PaymentMethod>>> getPaymentMethods({
    required String businessId,
    bool activeOnly = false,
  }) async {
    try {
      // Try to get from local database first
      String query = 'SELECT * FROM payment_methods WHERE business_id = ?';
      List<dynamic> args = [businessId];
      
      if (activeOnly) {
        query += ' AND is_active = ?';
        args.add(1);
      }
      
      query += ' ORDER BY display_order ASC, name ASC';
      
      final results = await localDatabase.rawQuery(query, args);
      
      if (results.isNotEmpty) {
        final methods = results.map((row) => _paymentMethodFromLocalJson(row)).toList();
        _logger.info('Retrieved ${methods.length} payment methods from local database');
        return Right(methods);
      }
      
      // If no local data, try to fetch from Supabase
      try {
        final response = await supabase
            .from('payment_methods')
            .select()
            .eq('business_id', businessId)
            .order('display_order', ascending: true)
            .order('name', ascending: true);
        
        final methods = (response as List)
            .map((data) => _paymentMethodFromSupabaseJson(data))
            .toList();
        
        // Save to local database
        for (final method in methods) {
          await _saveToLocal(method);
        }
        
        _logger.info('Retrieved ${methods.length} payment methods from Supabase');
        
        if (activeOnly) {
          return Right(methods.where((m) => m.isActive).toList());
        }
        return Right(methods);
      } catch (e) {
        _logger.warning('Failed to fetch from Supabase, using empty list: $e');
        return const Right([]);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to get payment methods', e, stackTrace);
      return Left('Failed to get payment methods: $e');
    }
  }

  // Create or get default payment methods
  Future<Either<String, List<PaymentMethod>>> ensureDefaultPaymentMethods({
    required String businessId,
  }) async {
    try {
      // Check if defaults already exist
      final existingResult = await getPaymentMethods(businessId: businessId);
      
      return existingResult.fold(
        (error) => Left(error),
        (existing) async {
          final defaultCodes = ['cash', 'card', 'customer_credit', 'cheque'];
          final existingCodes = existing.map((m) => m.code).toSet();
          final missingDefaults = defaultCodes.where((code) => !existingCodes.contains(code)).toList();
          
          if (missingDefaults.isEmpty) {
            _logger.info('All default payment methods already exist');
            return Right(existing);
          }
          
          // Create missing defaults
          final defaults = PaymentMethod.createDefaults(businessId);
          final methodsToCreate = defaults.where((d) => missingDefaults.contains(d.code)).toList();
          
          for (final method in methodsToCreate) {
            final result = await addPaymentMethod(method: method);
            if (result.isLeft()) {
              _logger.error('Failed to create default payment method: ${method.code}');
            }
          }
          
          // Return updated list
          return getPaymentMethods(businessId: businessId);
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to ensure default payment methods', e, stackTrace);
      return Left('Failed to ensure default payment methods: $e');
    }
  }

  // Add a new payment method
  Future<Either<String, PaymentMethod>> addPaymentMethod({
    required PaymentMethod method,
  }) async {
    try {
      final id = method.id.startsWith('default_') ? _uuid.v4() : method.id;
      final methodWithId = method.copyWith(id: id);
      
      // Save to local database
      await _saveToLocal(methodWithId);
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'payment_methods',
        'INSERT',
        id,
        _paymentMethodToSupabaseFormat(methodWithId),
      );
      
      _logger.info('Added payment method: ${method.name}');
      return Right(methodWithId);
    } catch (e, stackTrace) {
      _logger.error('Failed to add payment method', e, stackTrace);
      return Left('Failed to add payment method: $e');
    }
  }

  // Update a payment method
  Future<Either<String, PaymentMethod>> updatePaymentMethod({
    required PaymentMethod method,
  }) async {
    try {
      final updatedMethod = method.copyWith(
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );
      
      // Update in local database
      await localDatabase.update(
        'payment_methods',
        _paymentMethodToLocalJson(updatedMethod),
        where: 'id = ?',
        whereArgs: [method.id],
      );
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'payment_methods',
        'UPDATE',
        method.id,
        _paymentMethodToSupabaseFormat(updatedMethod),
      );
      
      _logger.info('Updated payment method: ${method.name}');
      return Right(updatedMethod);
    } catch (e, stackTrace) {
      _logger.error('Failed to update payment method', e, stackTrace);
      return Left('Failed to update payment method: $e');
    }
  }

  // Delete a payment method (only non-default)
  Future<Either<String, void>> deletePaymentMethod({
    required String methodId,
    required String businessId,
  }) async {
    try {
      // Check if it's a default method
      final results = await localDatabase.query(
        'payment_methods',
        where: 'id = ?',
        whereArgs: [methodId],
      );
      
      if (results.isNotEmpty) {
        final method = _paymentMethodFromLocalJson(results.first);
        if (method.isDefault) {
          return Left('Cannot delete default payment methods');
        }
      }
      
      // Delete from local database
      await localDatabase.delete(
        'payment_methods',
        where: 'id = ?',
        whereArgs: [methodId],
      );
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'payment_methods',
        'DELETE',
        methodId,
        {},
      );
      
      _logger.info('Deleted payment method: $methodId');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete payment method', e, stackTrace);
      return Left('Failed to delete payment method: $e');
    }
  }

  // Toggle payment method status
  Future<Either<String, void>> togglePaymentMethodStatus({
    required String methodId,
    required bool isActive,
    required String businessId,
  }) async {
    try {
      await localDatabase.update(
        'payment_methods',
        {
          'is_active': isActive ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
          'has_unsynced_changes': 1,
        },
        where: 'id = ?',
        whereArgs: [methodId],
      );
      
      // Add to sync queue
      await syncQueueService.addToQueue(
        'payment_methods',
        'UPDATE',
        methodId,
        {
          'is_active': isActive,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      
      _logger.info('Toggled payment method status: $methodId to $isActive');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to toggle payment method status', e, stackTrace);
      return Left('Failed to toggle payment method status: $e');
    }
  }

  // Save to local database
  Future<void> _saveToLocal(PaymentMethod method) async {
    await localDatabase.insert(
      'payment_methods',
      _paymentMethodToLocalJson(method),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Convert PaymentMethod to local JSON
  Map<String, dynamic> _paymentMethodToLocalJson(PaymentMethod method) {
    return {
      'id': method.id,
      'business_id': method.businessId,
      'name': method.name,
      'code': method.code,
      'icon': method.icon,
      'is_active': method.isActive ? 1 : 0,
      'is_default': method.isDefault ? 1 : 0,
      'requires_reference': method.requiresReference ? 1 : 0,
      'requires_approval': method.requiresApproval ? 1 : 0,
      'display_order': method.displayOrder,
      'settings': jsonEncode(method.settings),  // Properly encode as JSON string
      'created_at': method.createdAt.toIso8601String(),
      'updated_at': method.updatedAt.toIso8601String(),
      'created_by': method.createdBy,
      'has_unsynced_changes': method.hasUnsyncedChanges ? 1 : 0,
    };
  }

  // Convert local JSON to PaymentMethod
  PaymentMethod _paymentMethodFromLocalJson(Map<String, dynamic> json) {
    // Parse settings - it's stored as JSON string in SQLite
    Map<String, dynamic> settings = {};
    if (json['settings'] != null) {
      final settingsValue = json['settings'];
      if (settingsValue is String && settingsValue.isNotEmpty) {
        try {
          settings = Map<String, dynamic>.from(jsonDecode(settingsValue));
        } catch (e) {
          _logger.warning('Failed to parse settings JSON: $e');
        }
      } else if (settingsValue is Map) {
        settings = Map<String, dynamic>.from(settingsValue);
      }
    }
    
    return PaymentMethod(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      icon: json['icon'] as String?,
      isActive: (json['is_active'] as int) == 1,
      isDefault: (json['is_default'] as int) == 1,
      requiresReference: (json['requires_reference'] as int) == 1,
      requiresApproval: (json['requires_approval'] as int) == 1,
      displayOrder: json['display_order'] as int,
      settings: settings,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int) == 1,
    );
  }

  // Convert Supabase JSON to PaymentMethod
  PaymentMethod _paymentMethodFromSupabaseJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      icon: json['icon'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
      requiresReference: json['requires_reference'] as bool? ?? false,
      requiresApproval: json['requires_approval'] as bool? ?? false,
      displayOrder: json['display_order'] as int? ?? 0,
      settings: json['settings'] != null
          ? Map<String, dynamic>.from(json['settings'] as Map)
          : {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      hasUnsyncedChanges: false,
    );
  }

  // Convert PaymentMethod to Supabase format
  Map<String, dynamic> _paymentMethodToSupabaseFormat(PaymentMethod method) {
    return {
      'id': method.id,
      'business_id': method.businessId,
      'name': method.name,
      'code': method.code,
      'icon': method.icon,
      'is_active': method.isActive,
      'is_default': method.isDefault,
      'requires_reference': method.requiresReference,
      'requires_approval': method.requiresApproval,
      'display_order': method.displayOrder,
      'settings': method.settings,
      'created_at': method.createdAt.toIso8601String(),
      'updated_at': method.updatedAt.toIso8601String(),
      'created_by': method.createdBy,
    };
  }
}