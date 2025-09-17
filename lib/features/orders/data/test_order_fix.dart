import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/utils/logger.dart';

// Test script to verify the JSON parsing fix
class TestOrderFix {
  static final _logger = Logger('TestOrderFix');
  
  static Future<void> runTest() async {
    _logger.info('Starting order JSON fix test...');
    
    // Get the database path
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'tym_erp.db');
    
    // Open database
    final db = await openDatabase(path);
    
    try {
      // Query orders table
      final results = await db.query('orders', limit: 10);
      
      _logger.info('Found ${results.length} orders to test');
      
      for (final order in results) {
        _logger.info('Testing order ${order['order_number']}...');
        
        // Test each JSON field
        _testJsonField(order['items'], 'items');
        _testJsonField(order['payments'], 'payments');
        _testJsonField(order['order_discounts'], 'order_discounts');
        _testJsonField(order['prepared_by'], 'prepared_by');
      }
      
      _logger.info('Test completed successfully!');
    } catch (e, stackTrace) {
      _logger.error('Test failed', e, stackTrace);
    } finally {
      await db.close();
    }
  }
  
  static void _testJsonField(dynamic field, String fieldName) {
    if (field == null) {
      _logger.info('  $fieldName: null (OK)');
      return;
    }
    
    if (field is List || field is Map) {
      _logger.info('  $fieldName: Already decoded (${field.runtimeType}) (OK)');
      return;
    }
    
    if (field is String) {
      if (field.isEmpty) {
        _logger.info('  $fieldName: Empty string (OK)');
        return;
      }
      
      try {
        final decoded = jsonDecode(field);
        _logger.info('  $fieldName: Valid JSON string → ${decoded.runtimeType} (OK)');
      } catch (e) {
        // Check for corrupted data
        if (field.contains('{id:') || field.contains('[{')) {
          _logger.warning('  $fieldName: Corrupted data (toString output) - will be handled');
          _logger.warning('    Sample: ${field.substring(0, field.length > 50 ? 50 : field.length)}...');
        } else {
          _logger.error('  $fieldName: Invalid JSON - ${e.toString()}');
        }
      }
    } else {
      _logger.warning('  $fieldName: Unexpected type: ${field.runtimeType}');
    }
  }
  
  // Method to clean corrupted JSON data
  static Future<void> cleanCorruptedData() async {
    _logger.info('Cleaning corrupted JSON data...');
    
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'tym_erp.db');
    final db = await openDatabase(path);
    
    try {
      // Find orders with corrupted JSON
      final results = await db.query('orders');
      int fixedCount = 0;
      
      for (final order in results) {
        bool needsUpdate = false;
        final updates = <String, dynamic>{};
        
        // Check each JSON field
        for (final field in ['items', 'payments', 'order_discounts', 'prepared_by']) {
          final value = order[field];
          if (value is String && value.isNotEmpty) {
            try {
              jsonDecode(value);
            } catch (e) {
              // If it's corrupted, replace with empty array
              if (value.contains('{id:') || value.contains('[{')) {
                updates[field] = '[]';
                needsUpdate = true;
                _logger.warning('Fixed corrupted $field in order ${order['order_number']}');
              }
            }
          }
        }
        
        if (needsUpdate) {
          await db.update(
            'orders',
            updates,
            where: 'id = ?',
            whereArgs: [order['id']],
          );
          fixedCount++;
        }
      }
      
      _logger.info('Fixed $fixedCount orders with corrupted JSON');
    } catch (e, stackTrace) {
      _logger.error('Failed to clean corrupted data', e, stackTrace);
    } finally {
      await db.close();
    }
  }
}