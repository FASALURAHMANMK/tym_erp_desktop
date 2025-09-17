import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../services/sync_queue_service.dart';
import '../../../../services/database_schema.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/kot_item_routing.dart';
import '../../domain/models/kot_printer.dart';
import '../../domain/models/kot_printer_station.dart';
import '../../domain/models/kot_station.dart';
import '../../domain/models/kot_template.dart';

class KotLocalDatabase {
  static final _logger = Logger('KotLocalDatabase');
  final Database _database;
  final SyncQueueService _syncQueueService;
  final _uuid = const Uuid();

  KotLocalDatabase(this._database, this._syncQueueService);

  // Initialize KOT tables via global schema to ensure exact match
  static Future<void> createTables(Database db) async {
    await DatabaseSchema.applySqliteSchema(db);
  }

  // KOT Stations
  Future<List<KotStation>> getStations(
    String businessId,
    String locationId,
  ) async {
    try {
      final results = await _database.query(
        'kot_stations',
        where: 'business_id = ? AND location_id = ?',
        whereArgs: [businessId, locationId],
        orderBy: 'display_order ASC, name ASC',
      );
      return results.map((json) => _stationFromLocalJson(json)).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get stations', e, stackTrace);
      return [];
    }
  }

  Future<KotStation?> getStation(String id) async {
    try {
      final results = await _database.query(
        'kot_stations',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (results.isEmpty) return null;
      return _stationFromLocalJson(results.first);
    } catch (e, stackTrace) {
      _logger.error('Failed to get station', e, stackTrace);
      return null;
    }
  }

  Future<String> saveStation(KotStation station) async {
    try {
      final id = station.id.isEmpty ? _uuid.v4() : station.id;
      final now = DateTime.now().toIso8601String();

      final data = {
        'id': id,
        'business_id': station.businessId,
        'location_id': station.locationId,
        'name': station.name,
        'type': station.type,
        'description': station.description,
        'is_active': station.isActive ? 1 : 0,
        'display_order': station.displayOrder,
        'color': station.color,
        'created_at': station.createdAt?.toIso8601String() ?? now,
        'updated_at': now,
        'has_unsynced_changes': 1,
      };

      await _database.insert(
        'kot_stations',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _syncQueueService.addToQueue(
        'kot_stations',
        station.id.isEmpty ? 'INSERT' : 'UPDATE',
        id,
        _stationToSupabaseFormat(station.copyWith(id: id)),
      );

      return id;
    } catch (e, stackTrace) {
      _logger.error('Failed to save station', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteStation(String id) async {
    try {
      await _database.delete('kot_stations', where: 'id = ?', whereArgs: [id]);

      await _syncQueueService.addToQueue('kot_stations', 'DELETE', id, {
        'id': id,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to delete station', e, stackTrace);
      rethrow;
    }
  }

  // KOT Printers
  Future<List<KotPrinter>> getPrinters(
    String businessId,
    String locationId,
  ) async {
    try {
      final results = await _database.query(
        'kot_printers',
        where: 'business_id = ? AND location_id = ?',
        whereArgs: [businessId, locationId],
        orderBy: 'is_default DESC, name ASC',
      );
      return results.map((json) => _printerFromLocalJson(json)).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get printers', e, stackTrace);
      return [];
    }
  }

  Future<KotPrinter?> getPrinter(String id) async {
    try {
      final results = await _database.query(
        'kot_printers',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (results.isEmpty) return null;
      return _printerFromLocalJson(results.first);
    } catch (e, stackTrace) {
      _logger.error('Failed to get printer', e, stackTrace);
      return null;
    }
  }

  Future<String> savePrinter(KotPrinter printer) async {
    try {
      final id = printer.id.isEmpty ? _uuid.v4() : printer.id;
      final now = DateTime.now().toIso8601String();

      // If setting as default, unset other defaults
      if (printer.isDefault) {
        await _database.update(
          'kot_printers',
          {'is_default': 0},
          where: 'business_id = ? AND location_id = ? AND id != ?',
          whereArgs: [printer.businessId, printer.locationId, id],
        );
      }

      final data = {
        'id': id,
        'business_id': printer.businessId,
        'location_id': printer.locationId,
        'name': printer.name,
        'printer_type': printer.printerType,
        'ip_address': printer.ipAddress,
        'port': printer.port,
        'mac_address': printer.macAddress,
        'device_name': printer.deviceName,
        'is_active': printer.isActive ? 1 : 0,
        'is_default': printer.isDefault ? 1 : 0,
        'print_copies': printer.printCopies,
        'paper_size': printer.paperSize,
        'auto_cut': printer.autoCut ? 1 : 0,
        'cash_drawer': printer.cashDrawer ? 1 : 0,
        'notes': printer.notes,
        'created_at': printer.createdAt?.toIso8601String() ?? now,
        'updated_at': now,
        'has_unsynced_changes': 1,
      };

      await _database.insert(
        'kot_printers',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _syncQueueService.addToQueue(
        'kot_printers',
        printer.id.isEmpty ? 'INSERT' : 'UPDATE',
        id,
        _printerToSupabaseFormat(printer.copyWith(id: id)),
      );

      return id;
    } catch (e, stackTrace) {
      _logger.error('Failed to save printer', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deletePrinter(String id) async {
    try {
      await _database.delete('kot_printers', where: 'id = ?', whereArgs: [id]);

      await _syncQueueService.addToQueue('kot_printers', 'DELETE', id, {
        'id': id,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to delete printer', e, stackTrace);
      rethrow;
    }
  }

  // KOT Printer Stations
  Future<List<KotPrinterStation>> getPrinterStations(
    String businessId,
    String locationId,
  ) async {
    try {
      final results = await _database.query(
        'kot_printer_stations',
        where: 'business_id = ? AND location_id = ?',
        whereArgs: [businessId, locationId],
        orderBy: 'priority ASC',
      );
      return results.map((json) => _printerStationFromLocalJson(json)).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get printer stations', e, stackTrace);
      return [];
    }
  }

  Future<String> savePrinterStation(KotPrinterStation printerStation) async {
    try {
      final id = printerStation.id.isEmpty ? _uuid.v4() : printerStation.id;
      final now = DateTime.now().toIso8601String();

      final data = {
        'id': id,
        'business_id': printerStation.businessId,
        'location_id': printerStation.locationId,
        'printer_id': printerStation.printerId,
        'station_id': printerStation.stationId,
        'is_active': printerStation.isActive ? 1 : 0,
        'priority': printerStation.priority,
        'created_at': printerStation.createdAt?.toIso8601String() ?? now,
        'updated_at': now,
        'has_unsynced_changes': 1,
      };

      await _database.insert(
        'kot_printer_stations',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _syncQueueService.addToQueue(
        'kot_printer_stations',
        printerStation.id.isEmpty ? 'INSERT' : 'UPDATE',
        id,
        _printerStationToSupabaseFormat(printerStation.copyWith(id: id)),
      );

      return id;
    } catch (e, stackTrace) {
      _logger.error('Failed to save printer station', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deletePrinterStation(String id) async {
    try {
      await _database.delete(
        'kot_printer_stations',
        where: 'id = ?',
        whereArgs: [id],
      );

      await _syncQueueService.addToQueue('kot_printer_stations', 'DELETE', id, {
        'id': id,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to delete printer station', e, stackTrace);
      rethrow;
    }
  }

  // KOT Item Routing
  Future<List<KotItemRouting>> getItemRoutings(
    String businessId,
    String locationId,
  ) async {
    try {
      final results = await _database.query(
        'kot_item_routing',
        where: 'business_id = ? AND location_id = ?',
        whereArgs: [businessId, locationId],
        orderBy: 'priority DESC',
      );
      return results.map((json) => _itemRoutingFromLocalJson(json)).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get item routings', e, stackTrace);
      return [];
    }
  }

  Future<String> saveItemRouting(KotItemRouting routing) async {
    try {
      final id = routing.id.isEmpty ? _uuid.v4() : routing.id;
      final now = DateTime.now().toIso8601String();

      final data = {
        'id': id,
        'business_id': routing.businessId,
        'location_id': routing.locationId,
        'station_id': routing.stationId,
        'category_id': routing.categoryId,
        'product_id': routing.productId,
        'variation_id': routing.variationId,
        'priority': routing.priority,
        'is_active': routing.isActive ? 1 : 0,
        'created_at': routing.createdAt?.toIso8601String() ?? now,
        'updated_at': now,
        'has_unsynced_changes': 1,
      };

      await _database.insert(
        'kot_item_routing',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _syncQueueService.addToQueue(
        'kot_item_routing',
        routing.id.isEmpty ? 'INSERT' : 'UPDATE',
        id,
        _itemRoutingToSupabaseFormat(routing.copyWith(id: id)),
      );

      return id;
    } catch (e, stackTrace) {
      _logger.error('Failed to save item routing', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteItemRouting(String id) async {
    try {
      await _database.delete(
        'kot_item_routing',
        where: 'id = ?',
        whereArgs: [id],
      );

      await _syncQueueService.addToQueue('kot_item_routing', 'DELETE', id, {
        'id': id,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to delete item routing', e, stackTrace);
      rethrow;
    }
  }

  // KOT Templates
  Future<List<KotTemplate>> getTemplates(
    String businessId,
    String locationId,
  ) async {
    try {
      final results = await _database.query(
        'kot_templates',
        where: 'business_id = ? AND location_id = ?',
        whereArgs: [businessId, locationId],
        orderBy: 'type ASC, is_default DESC, name ASC',
      );
      return results.map((json) => _templateFromLocalJson(json)).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get templates', e, stackTrace);
      return [];
    }
  }

  Future<KotTemplate?> getTemplate(String id) async {
    try {
      final results = await _database.query(
        'kot_templates',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (results.isEmpty) return null;
      return _templateFromLocalJson(results.first);
    } catch (e, stackTrace) {
      _logger.error('Failed to get template', e, stackTrace);
      return null;
    }
  }

  Future<String> saveTemplate(KotTemplate template) async {
    try {
      final id = template.id.isEmpty ? _uuid.v4() : template.id;
      final now = DateTime.now().toIso8601String();

      // If setting as default, unset other defaults of same type
      if (template.isDefault) {
        await _database.update(
          'kot_templates',
          {'is_default': 0},
          where: 'business_id = ? AND location_id = ? AND type = ? AND id != ?',
          whereArgs: [
            template.businessId,
            template.locationId,
            template.type,
            id,
          ],
        );
      }

      final data = {
        'id': id,
        'business_id': template.businessId,
        'location_id': template.locationId,
        'name': template.name,
        'type': template.type,
        'content': template.content,
        'is_active': template.isActive ? 1 : 0,
        'is_default': template.isDefault ? 1 : 0,
        'description': template.description,
        'settings': template.settings?.toString(),
        'created_at': template.createdAt?.toIso8601String() ?? now,
        'updated_at': now,
        'has_unsynced_changes': 1,
      };

      await _database.insert(
        'kot_templates',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await _syncQueueService.addToQueue(
        'kot_templates',
        template.id.isEmpty ? 'INSERT' : 'UPDATE',
        id,
        _templateToSupabaseFormat(template.copyWith(id: id)),
      );

      return id;
    } catch (e, stackTrace) {
      _logger.error('Failed to save template', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await _database.delete('kot_templates', where: 'id = ?', whereArgs: [id]);

      await _syncQueueService.addToQueue('kot_templates', 'DELETE', id, {
        'id': id,
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to delete template', e, stackTrace);
      rethrow;
    }
  }

  // Cloud save methods - save data from cloud without marking for sync
  Future<void> saveStationFromCloud(KotStation station) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      final data = {
        'id': station.id,
        'business_id': station.businessId,
        'location_id': station.locationId,
        'name': station.name,
        'type': station.type,
        'description': station.description,
        'is_active': station.isActive ? 1 : 0,
        'display_order': station.displayOrder,
        'color': station.color,
        'created_at': station.createdAt?.toIso8601String() ?? now,
        'updated_at': station.updatedAt?.toIso8601String() ?? now,
        'has_unsynced_changes': 0, // Not marking for sync
      };

      await _database.insert(
        'kot_stations',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.debug('Saved station from cloud: ${station.id}');
    } catch (e, stackTrace) {
      _logger.error('Failed to save station from cloud', e, stackTrace);
      rethrow;
    }
  }

  Future<void> savePrinterFromCloud(KotPrinter printer) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      // If setting as default, unset other defaults
      if (printer.isDefault) {
        await _database.update(
          'kot_printers',
          {'is_default': 0},
          where: 'business_id = ? AND location_id = ? AND id != ?',
          whereArgs: [printer.businessId, printer.locationId, printer.id],
        );
      }
      
      final data = {
        'id': printer.id,
        'business_id': printer.businessId,
        'location_id': printer.locationId,
        'name': printer.name,
        'printer_type': printer.printerType,
        'ip_address': printer.ipAddress,
        'port': printer.port,
        'mac_address': printer.macAddress,
        'device_name': printer.deviceName,
        'is_active': printer.isActive ? 1 : 0,
        'is_default': printer.isDefault ? 1 : 0,
        'print_copies': printer.printCopies,
        'paper_size': printer.paperSize,
        'auto_cut': printer.autoCut ? 1 : 0,
        'cash_drawer': printer.cashDrawer ? 1 : 0,
        'notes': printer.notes,
        'created_at': printer.createdAt?.toIso8601String() ?? now,
        'updated_at': printer.updatedAt?.toIso8601String() ?? now,
        'has_unsynced_changes': 0, // Not marking for sync
      };

      await _database.insert(
        'kot_printers',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.debug('Saved printer from cloud: ${printer.id}');
    } catch (e, stackTrace) {
      _logger.error('Failed to save printer from cloud', e, stackTrace);
      rethrow;
    }
  }

  Future<void> savePrinterStationFromCloud(KotPrinterStation printerStation) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      final data = {
        'id': printerStation.id,
        'business_id': printerStation.businessId,
        'location_id': printerStation.locationId,
        'printer_id': printerStation.printerId,
        'station_id': printerStation.stationId,
        'is_active': printerStation.isActive ? 1 : 0,
        'priority': printerStation.priority,
        'created_at': printerStation.createdAt?.toIso8601String() ?? now,
        'updated_at': printerStation.updatedAt?.toIso8601String() ?? now,
        'has_unsynced_changes': 0, // Not marking for sync
      };

      await _database.insert(
        'kot_printer_stations',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.debug('Saved printer station from cloud: ${printerStation.id}');
    } catch (e, stackTrace) {
      _logger.error('Failed to save printer station from cloud', e, stackTrace);
      rethrow;
    }
  }

  Future<void> saveItemRoutingFromCloud(KotItemRouting routing) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      final data = {
        'id': routing.id,
        'business_id': routing.businessId,
        'location_id': routing.locationId,
        'station_id': routing.stationId,
        'category_id': routing.categoryId,
        'product_id': routing.productId,
        'variation_id': routing.variationId,
        'priority': routing.priority,
        'is_active': routing.isActive ? 1 : 0,
        'created_at': routing.createdAt?.toIso8601String() ?? now,
        'updated_at': routing.updatedAt?.toIso8601String() ?? now,
        'has_unsynced_changes': 0, // Not marking for sync
      };

      await _database.insert(
        'kot_item_routing',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.debug('Saved item routing from cloud: ${routing.id}');
    } catch (e, stackTrace) {
      _logger.error('Failed to save item routing from cloud', e, stackTrace);
      rethrow;
    }
  }

  Future<void> saveTemplateFromCloud(KotTemplate template) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      final data = {
        'id': template.id,
        'business_id': template.businessId,
        'location_id': template.locationId,
        'name': template.name,
        'type': template.type,
        'content': template.content,
        'is_active': template.isActive ? 1 : 0,
        'is_default': template.isDefault ? 1 : 0,
        'description': template.description,
        'settings': template.settings,
        'created_at': template.createdAt?.toIso8601String() ?? now,
        'updated_at': template.updatedAt?.toIso8601String() ?? now,
        'has_unsynced_changes': 0, // Not marking for sync
      };

      await _database.insert(
        'kot_templates',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.debug('Saved template from cloud: ${template.id}');
    } catch (e, stackTrace) {
      _logger.error('Failed to save template from cloud', e, stackTrace);
      rethrow;
    }
  }

  // Helper methods for conversion
  KotStation _stationFromLocalJson(Map<String, dynamic> json) {
    return KotStation(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      locationId: json['location_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      isActive: (json['is_active'] as int) == 1,
      displayOrder: json['display_order'] as int,
      color: json['color'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> _stationToSupabaseFormat(KotStation station) {
    return {
      'id': station.id,
      'business_id': station.businessId,
      'location_id': station.locationId,
      'name': station.name,
      'type': station.type,
      'description': station.description,
      'is_active': station.isActive,
      'display_order': station.displayOrder,
      'color': station.color,
      'created_at': station.createdAt?.toIso8601String(),
      'updated_at': station.updatedAt?.toIso8601String(),
    };
  }

  KotPrinter _printerFromLocalJson(Map<String, dynamic> json) {
    return KotPrinter(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      locationId: json['location_id'] as String,
      name: json['name'] as String,
      printerType: json['printer_type'] as String,
      ipAddress: json['ip_address'] as String?,
      port: json['port'] as String?,
      macAddress: json['mac_address'] as String?,
      deviceName: json['device_name'] as String?,
      isActive: (json['is_active'] as int) == 1,
      isDefault: (json['is_default'] as int) == 1,
      printCopies: json['print_copies'] as int,
      paperSize: json['paper_size'] as String,
      autoCut: (json['auto_cut'] as int) == 1,
      cashDrawer: (json['cash_drawer'] as int) == 1,
      notes: json['notes'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> _printerToSupabaseFormat(KotPrinter printer) {
    return {
      'id': printer.id,
      'business_id': printer.businessId,
      'location_id': printer.locationId,
      'name': printer.name,
      'printer_type': printer.printerType,
      'ip_address': printer.ipAddress,
      'port': printer.port != null ? int.tryParse(printer.port!) : null,
      'mac_address': printer.macAddress,
      'device_name': printer.deviceName,
      'is_active': printer.isActive,
      'is_default': printer.isDefault,
      'print_copies': printer.printCopies,
      'paper_size': printer.paperSize,
      'auto_cut': printer.autoCut,
      'cash_drawer': printer.cashDrawer,
      'notes': printer.notes,
      'created_at': printer.createdAt?.toIso8601String(),
      'updated_at': printer.updatedAt?.toIso8601String(),
    };
  }

  KotPrinterStation _printerStationFromLocalJson(Map<String, dynamic> json) {
    return KotPrinterStation(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      locationId: json['location_id'] as String,
      printerId: json['printer_id'] as String,
      stationId: json['station_id'] as String,
      isActive: (json['is_active'] as int) == 1,
      priority: json['priority'] as int,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> _printerStationToSupabaseFormat(
    KotPrinterStation printerStation,
  ) {
    return {
      'id': printerStation.id,
      'business_id': printerStation.businessId,
      'location_id': printerStation.locationId,
      'printer_id': printerStation.printerId,
      'station_id': printerStation.stationId,
      'is_active': printerStation.isActive,
      'priority': printerStation.priority,
      'created_at': printerStation.createdAt?.toIso8601String(),
      'updated_at': printerStation.updatedAt?.toIso8601String(),
    };
  }

  KotItemRouting _itemRoutingFromLocalJson(Map<String, dynamic> json) {
    return KotItemRouting(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      locationId: json['location_id'] as String,
      stationId: json['station_id'] as String,
      categoryId: json['category_id'] as String?,
      productId: json['product_id'] as String?,
      variationId: json['variation_id'] as String?,
      priority: json['priority'] as int,
      isActive: (json['is_active'] as int) == 1,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> _itemRoutingToSupabaseFormat(KotItemRouting routing) {
    return {
      'id': routing.id,
      'business_id': routing.businessId,
      'location_id': routing.locationId,
      'station_id': routing.stationId,
      'category_id': routing.categoryId,
      'product_id': routing.productId,
      'variation_id': routing.variationId,
      'priority': routing.priority,
      'is_active': routing.isActive,
      'created_at': routing.createdAt?.toIso8601String(),
      'updated_at': routing.updatedAt?.toIso8601String(),
    };
  }

  KotTemplate _templateFromLocalJson(Map<String, dynamic> json) {
    Map<String, dynamic>? settings;
    if (json['settings'] != null) {
      try {
        settings = Map<String, dynamic>.from(json['settings'] as Map);
      } catch (_) {
        settings = null;
      }
    }

    return KotTemplate(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      locationId: json['location_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      isActive: (json['is_active'] as int) == 1,
      isDefault: (json['is_default'] as int) == 1,
      description: json['description'] as String?,
      settings: settings,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      hasUnsyncedChanges: (json['has_unsynced_changes'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> _templateToSupabaseFormat(KotTemplate template) {
    return {
      'id': template.id,
      'business_id': template.businessId,
      'location_id': template.locationId,
      'name': template.name,
      'type': template.type,
      'content': template.content,
      'is_active': template.isActive,
      'is_default': template.isDefault,
      'description': template.description,
      'settings': template.settings,
      'created_at': template.createdAt?.toIso8601String(),
      'updated_at': template.updatedAt?.toIso8601String(),
    };
  }
}
