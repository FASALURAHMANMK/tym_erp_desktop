import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/offline_first_exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/models/kot_item_routing.dart';
import '../../domain/models/kot_printer.dart';
import '../../domain/models/kot_printer_station.dart';
import '../../domain/models/kot_station.dart';
import '../../domain/models/kot_template.dart';
import '../local/kot_local_database.dart';

class OfflineFirstKotRepository {
  static final _logger = Logger('OfflineFirstKotRepository');
  final SupabaseClient _supabaseClient;
  final KotLocalDatabase _localDatabase;

  OfflineFirstKotRepository(this._supabaseClient, this._localDatabase);

  // KOT Stations
  Future<Either<OfflineFirstException, List<KotStation>>> getStations(
    String businessId,
    String locationId,
  ) async {
    try {
      // Always return from local database (offline-first)
      final stations = await _localDatabase.getStations(businessId, locationId);
      return Right(stations);
    } catch (e, stackTrace) {
      _logger.error('Failed to get stations', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get stations',
          'getStations',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, KotStation?>> getStation(
    String id,
  ) async {
    try {
      final station = await _localDatabase.getStation(id);
      return Right(station);
    } catch (e, stackTrace) {
      _logger.error('Failed to get station', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get station',
          'getStation',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, String>> saveStation(
    KotStation station,
  ) async {
    try {
      final id = await _localDatabase.saveStation(station);
      return Right(id);
    } catch (e, stackTrace) {
      _logger.error('Failed to save station', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to save station',
          'saveStation',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, void>> deleteStation(String id) async {
    try {
      await _localDatabase.deleteStation(id);
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete station', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to delete station',
          'deleteStation',
          originalError: e,
        ),
      );
    }
  }

  // KOT Printers
  Future<Either<OfflineFirstException, List<KotPrinter>>> getPrinters(
    String businessId,
    String locationId,
  ) async {
    try {
      final printers = await _localDatabase.getPrinters(businessId, locationId);
      return Right(printers);
    } catch (e, stackTrace) {
      _logger.error('Failed to get printers', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get printers',
          'getPrinters',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, KotPrinter?>> getPrinter(
    String id,
  ) async {
    try {
      final printer = await _localDatabase.getPrinter(id);
      return Right(printer);
    } catch (e, stackTrace) {
      _logger.error('Failed to get printer', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get printer',
          'getPrinter',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, String>> savePrinter(
    KotPrinter printer,
  ) async {
    try {
      final id = await _localDatabase.savePrinter(printer);
      return Right(id);
    } catch (e, stackTrace) {
      _logger.error('Failed to save printer', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to save printer',
          'savePrinter',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, void>> deletePrinter(String id) async {
    try {
      await _localDatabase.deletePrinter(id);
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete printer', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to delete printer',
          'deletePrinter',
          originalError: e,
        ),
      );
    }
  }

  // KOT Printer Stations
  Future<Either<OfflineFirstException, List<KotPrinterStation>>>
  getPrinterStations(String businessId, String locationId) async {
    try {
      final printerStations = await _localDatabase.getPrinterStations(
        businessId,
        locationId,
      );
      return Right(printerStations);
    } catch (e, stackTrace) {
      _logger.error('Failed to get printer stations', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get printer stations',
          'getPrinterStations',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, String>> savePrinterStation(
    KotPrinterStation printerStation,
  ) async {
    try {
      final id = await _localDatabase.savePrinterStation(printerStation);
      return Right(id);
    } catch (e, stackTrace) {
      _logger.error('Failed to save printer station', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to save printer station',
          'savePrinterStation',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, void>> deletePrinterStation(
    String id,
  ) async {
    try {
      await _localDatabase.deletePrinterStation(id);
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete printer station', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to delete printer station',
          'deletePrinterStation',
          originalError: e,
        ),
      );
    }
  }

  // KOT Item Routing
  Future<Either<OfflineFirstException, List<KotItemRouting>>> getItemRoutings(
    String businessId,
    String locationId,
  ) async {
    try {
      final routings = await _localDatabase.getItemRoutings(
        businessId,
        locationId,
      );
      return Right(routings);
    } catch (e, stackTrace) {
      _logger.error('Failed to get item routings', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get item routings',
          'getItemRoutings',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, String>> saveItemRouting(
    KotItemRouting routing,
  ) async {
    try {
      final id = await _localDatabase.saveItemRouting(routing);
      return Right(id);
    } catch (e, stackTrace) {
      _logger.error('Failed to save item routing', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to save item routing',
          'saveItemRouting',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, void>> deleteItemRouting(
    String id,
  ) async {
    try {
      await _localDatabase.deleteItemRouting(id);
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete item routing', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to delete item routing',
          'deleteItemRouting',
          originalError: e,
        ),
      );
    }
  }

  // KOT Templates
  Future<Either<OfflineFirstException, List<KotTemplate>>> getTemplates(
    String businessId,
    String locationId,
  ) async {
    try {
      final templates = await _localDatabase.getTemplates(
        businessId,
        locationId,
      );
      return Right(templates);
    } catch (e, stackTrace) {
      _logger.error('Failed to get templates', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get templates',
          'getTemplates',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, KotTemplate?>> getTemplate(
    String id,
  ) async {
    try {
      final template = await _localDatabase.getTemplate(id);
      return Right(template);
    } catch (e, stackTrace) {
      _logger.error('Failed to get template', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to get template',
          'getTemplate',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, String>> saveTemplate(
    KotTemplate template,
  ) async {
    try {
      final id = await _localDatabase.saveTemplate(template);
      return Right(id);
    } catch (e, stackTrace) {
      _logger.error('Failed to save template', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to save template',
          'saveTemplate',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<OfflineFirstException, void>> deleteTemplate(String id) async {
    try {
      await _localDatabase.deleteTemplate(id);
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete template', e, stackTrace);
      return Left(
        LocalDatabaseException(
          'Failed to delete template',
          'deleteTemplate',
          originalError: e,
        ),
      );
    }
  }

  // Sync methods for pulling data from Supabase
  Future<void> syncStationsFromSupabase(
    String businessId,
    String locationId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('kot_stations')
          .select()
          .eq('business_id', businessId)
          .eq('location_id', locationId);

      for (final json in response as List) {
        final station = KotStation.fromJson(_stationFromSupabaseFormat(json));
        await _localDatabase.saveStationFromCloud(station);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to sync stations from Supabase', e, stackTrace);
    }
  }

  Future<void> syncPrintersFromSupabase(
    String businessId,
    String locationId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('kot_printers')
          .select()
          .eq('business_id', businessId)
          .eq('location_id', locationId);

      for (final json in response as List) {
        final printer = KotPrinter.fromJson(_printerFromSupabaseFormat(json));
        await _localDatabase.savePrinterFromCloud(printer);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to sync printers from Supabase', e, stackTrace);
    }
  }

  Future<void> syncPrinterStationsFromSupabase(
    String businessId,
    String locationId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('kot_printer_stations')
          .select()
          .eq('business_id', businessId)
          .eq('location_id', locationId);

      for (final json in response as List) {
        final printerStation = KotPrinterStation.fromJson(
          _printerStationFromSupabaseFormat(json),
        );
        await _localDatabase.savePrinterStationFromCloud(printerStation);
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to sync printer stations from Supabase',
        e,
        stackTrace,
      );
    }
  }

  Future<void> syncItemRoutingsFromSupabase(
    String businessId,
    String locationId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('kot_item_routing')
          .select()
          .eq('business_id', businessId)
          .eq('location_id', locationId);

      for (final json in response as List) {
        final routing = KotItemRouting.fromJson(
          _itemRoutingFromSupabaseFormat(json),
        );
        await _localDatabase.saveItemRoutingFromCloud(routing);
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to sync item routings from Supabase',
        e,
        stackTrace,
      );
    }
  }

  Future<void> syncTemplatesFromSupabase(
    String businessId,
    String locationId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('kot_templates')
          .select()
          .eq('business_id', businessId)
          .eq('location_id', locationId);

      for (final json in response as List) {
        final template = KotTemplate.fromJson(
          _templateFromSupabaseFormat(json),
        );
        await _localDatabase.saveTemplateFromCloud(template);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to sync templates from Supabase', e, stackTrace);
    }
  }

  // Format conversion helpers
  Map<String, dynamic> _stationFromSupabaseFormat(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'businessId': json['business_id'],
      'locationId': json['location_id'],
      'name': json['name'],
      'type': json['type'],
      'description': json['description'],
      'isActive': json['is_active'] ?? true,
      'displayOrder': json['display_order'] ?? 0,
      'color': json['color'],
      'createdAt': json['created_at'],
      'updatedAt': json['updated_at'],
    };
  }

  Map<String, dynamic> _printerFromSupabaseFormat(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'businessId': json['business_id'],
      'locationId': json['location_id'],
      'name': json['name'],
      'printerType': json['printer_type'],
      'ipAddress': json['ip_address'],
      'port': json['port']?.toString(),
      'macAddress': json['mac_address'],
      'deviceName': json['device_name'],
      'isActive': json['is_active'] ?? true,
      'isDefault': json['is_default'] ?? false,
      'printCopies': json['print_copies'] ?? 1,
      'paperSize': json['paper_size'] ?? '80mm',
      'autoCut': json['auto_cut'] ?? true,
      'cashDrawer': json['cash_drawer'] ?? false,
      'notes': json['notes'],
      'createdAt': json['created_at'],
      'updatedAt': json['updated_at'],
    };
  }

  Map<String, dynamic> _printerStationFromSupabaseFormat(
    Map<String, dynamic> json,
  ) {
    return {
      'id': json['id'],
      'businessId': json['business_id'],
      'locationId': json['location_id'],
      'printerId': json['printer_id'],
      'stationId': json['station_id'],
      'isActive': json['is_active'] ?? true,
      'priority': json['priority'] ?? 1,
      'createdAt': json['created_at'],
      'updatedAt': json['updated_at'],
    };
  }

  Map<String, dynamic> _itemRoutingFromSupabaseFormat(
    Map<String, dynamic> json,
  ) {
    return {
      'id': json['id'],
      'businessId': json['business_id'],
      'locationId': json['location_id'],
      'stationId': json['station_id'],
      'categoryId': json['category_id'],
      'productId': json['product_id'],
      'variationId': json['variation_id'],
      'priority': json['priority'] ?? 1,
      'isActive': json['is_active'] ?? true,
      'createdAt': json['created_at'],
      'updatedAt': json['updated_at'],
    };
  }

  Map<String, dynamic> _templateFromSupabaseFormat(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'businessId': json['business_id'],
      'locationId': json['location_id'],
      'name': json['name'],
      'type': json['type'],
      'content': json['content'],
      'isActive': json['is_active'] ?? true,
      'isDefault': json['is_default'] ?? false,
      'description': json['description'],
      'settings': json['settings'],
      'createdAt': json['created_at'],
      'updatedAt': json['updated_at'],
    };
  }
}
