import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Add printer packages when version conflicts are resolved
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/kot_printer.dart';
import '../domain/models/kot_printer_station.dart';
import '../domain/models/kot_station.dart';
import '../providers/kot_providers.dart';

// Provider for KOT print service
final kotPrintServiceProvider = Provider<KotPrintService>((ref) {
  return KotPrintService(ref);
});

class KotPrintService {
  final Ref _ref;
  static final _logger = Logger('KotPrintService');

  KotPrintService(this._ref);

  /// Print KOT content to the appropriate printer for a station
  Future<void> printKOT({
    required KotStation station,
    required String content,
  }) async {
    try {
      _logger.info('Printing KOT for station: ${station.name} (ID: ${station.id})');

      // Get printer mapping for the station
      final printerMapping = await _getPrinterForStation(station.id);
      if (printerMapping == null) {
        _logger.warning('No printer mapped for station: ${station.name}. Please configure printer-station mapping in KOT Configuration.');
        throw Exception('No printer mapped for station: ${station.name}.\nPlease configure printer-station mapping in KOT Configuration.');
      }

      // Get printer details
      final printer = await _getPrinterDetails(printerMapping.printerId);
      if (printer == null) {
        _logger.error('Printer not found for ID: ${printerMapping.printerId}');
        throw Exception('Printer not found: ${printerMapping.printerId}.\nPlease check printer configuration.');
      }

      // Print based on printer type
      switch (printer.printerType) {
        case 'network':
          await _printToNetworkPrinter(printer, content);
          break;
        case 'bluetooth':
          await _printToBluetoothPrinter(printer, content);
          break;
        case 'usb':
        case 'serial':
          await _printToUSBPrinter(printer, content);
          break;
        default:
          throw Exception('Unsupported printer type: ${printer.printerType}');
      }

      _logger.info('KOT printed successfully to ${printer.name}');
    } catch (e, stackTrace) {
      _logger.error('Failed to print KOT', e, stackTrace);
      rethrow;
    }
  }

  /// Print to network printer using raw socket connection
  Future<void> _printToNetworkPrinter(
    KotPrinter printer,
    String content,
  ) async {
    if (printer.ipAddress == null || printer.ipAddress!.isEmpty) {
      throw Exception('No IP address configured for printer: ${printer.name}');
    }

    try {
      // For now, log the print request (will implement actual printing later)
      _logger.info(
        'Would print to network printer: ${printer.name} at ${printer.ipAddress}:${printer.port}',
      );
      _logger.info('Content to print:\n$content');

      // TODO: Implement actual network printing when packages are available
      // For testing, write to a file
      final file = File(
        'kot_print_${DateTime.now().millisecondsSinceEpoch}.txt',
      );
      await file.writeAsString(content);
      _logger.info('Test KOT saved to: ${file.path}');
    } catch (e) {
      _logger.error('Network printing failed', e);
      // Try fallback printer if available
      await _tryFallbackPrinter(printer, content);
    }
  }

  /// Print to Bluetooth printer
  Future<void> _printToBluetoothPrinter(
    KotPrinter printer,
    String content,
  ) async {
    if (printer.macAddress == null || printer.macAddress!.isEmpty) {
      throw Exception('No MAC address configured for printer: ${printer.name}');
    }

    try {
      // For now, log the print request
      _logger.info(
        'Would print to Bluetooth printer: ${printer.name} at ${printer.macAddress}',
      );
      _logger.info('Content to print:\n$content');

      // TODO: Implement actual Bluetooth printing when packages are available
      // For testing, write to a file
      final file = File(
        'kot_print_bt_${DateTime.now().millisecondsSinceEpoch}.txt',
      );
      await file.writeAsString(content);
      _logger.info('Test KOT saved to: ${file.path}');
    } catch (e) {
      _logger.error('Bluetooth printing failed', e);
      await _tryFallbackPrinter(printer, content);
    }
  }

  /// Print to USB printer
  Future<void> _printToUSBPrinter(KotPrinter printer, String content) async {
    if (printer.deviceName == null || printer.deviceName!.isEmpty) {
      throw Exception('No device name configured for printer: ${printer.name}');
    }

    try {
      // This is platform-specific and would require platform channels
      // For now, we'll use a file-based approach for testing

      if (Platform.isWindows) {
        // Windows: Write to printer device
        final file = File(printer.deviceName!);
        final bytes = await _formatContentForThermal(content, printer);
        await file.writeAsBytes(bytes);
      } else if (Platform.isLinux || Platform.isMacOS) {
        // Linux/Mac: Use CUPS or lp command
        final process = await Process.run('lp', [
          '-d',
          printer.deviceName!,
          '-',
        ], runInShell: true);

        if (process.exitCode != 0) {
          throw Exception('USB printing failed: ${process.stderr}');
        }
      }

      _logger.info('USB printing completed for ${printer.name}');
    } catch (e) {
      _logger.error('USB printing failed', e);
      await _tryFallbackPrinter(printer, content);
    }
  }

  /// Format content for thermal printer
  Future<Uint8List> _formatContentForThermal(
    String content,
    KotPrinter printer,
  ) async {
    try {
      // TODO: Implement ESC/POS formatting when packages are available
      // For now, return plain text
      return Uint8List.fromList(content.codeUnits);
    } catch (e) {
      _logger.error('Failed to format content for thermal printer', e);
      return Uint8List.fromList(content.codeUnits);
    }
  }

  // TODO: Implement proper print content method when packages are available

  /// Try fallback printer if primary fails
  Future<void> _tryFallbackPrinter(
    KotPrinter failedPrinter,
    String content,
  ) async {
    try {
      _logger.info('Trying fallback printer for ${failedPrinter.name}');

      // Get all printers for the same location
      final printersAsync = _ref.read(kotPrintersProvider);

      await printersAsync.when(
        data: (printers) async {
          // Find default printer as fallback
          final defaultPrinter = printers.firstWhere(
            (p) => p.isDefault && p.id != failedPrinter.id,
            orElse: () => throw Exception('No fallback printer available'),
          );

          _logger.info('Using fallback printer: ${defaultPrinter.name}');

          // Try printing to default printer
          switch (defaultPrinter.printerType) {
            case 'network':
              await _printToNetworkPrinter(defaultPrinter, content);
              break;
            case 'bluetooth':
              await _printToBluetoothPrinter(defaultPrinter, content);
              break;
            case 'usb':
            case 'serial':
              await _printToUSBPrinter(defaultPrinter, content);
              break;
          }
        },
        loading: () => throw Exception('Printers still loading'),
        error: (error, _) => throw Exception('Failed to load printers: $error'),
      );
    } catch (e) {
      _logger.error('Fallback printing also failed', e);
      throw Exception('All printers failed. Original error: ${e.toString()}');
    }
  }

  /// Get printer mapping for a station
  Future<KotPrinterStation?> _getPrinterForStation(String stationId) async {
    try {
      // First try to get from provider
      final mappingsAsync = await _ref.read(kotPrinterStationsProvider.future);
      
      final stationMappings = mappingsAsync
          .where((m) => m.stationId == stationId && m.isActive)
          .toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));

      if (stationMappings.isNotEmpty) {
        _logger.debug('Found ${stationMappings.length} printer mappings for station $stationId');
        return stationMappings.first;
      }

      _logger.warning('No printer mappings found for station $stationId');
      
      // If no mappings found, try to get default printer for fallback
      final printersAsync = await _ref.read(kotPrintersProvider.future);
      final defaultPrinter = printersAsync.firstWhereOrNull((p) => p.isDefault && p.isActive);
      
      if (defaultPrinter != null) {
        _logger.info('Using default printer ${defaultPrinter.name} as fallback');
        // Create a temporary mapping for the default printer
        return KotPrinterStation(
          id: 'temp-mapping',
          businessId: defaultPrinter.businessId,
          locationId: defaultPrinter.locationId,
          printerId: defaultPrinter.id,
          stationId: stationId,
          isActive: true,
          priority: 1,
        );
      }
      
      return null;
    } catch (e) {
      _logger.error('Error getting printer for station', e);
      return null;
    }
  }

  /// Get printer details by ID
  Future<KotPrinter?> _getPrinterDetails(String printerId) async {
    try {
      final printers = await _ref.read(kotPrintersProvider.future);
      final printer = printers.firstWhereOrNull((p) => p.id == printerId);
      
      if (printer != null) {
        _logger.debug('Found printer: ${printer.name} (Type: ${printer.printerType})');
      } else {
        _logger.warning('Printer not found for ID: $printerId');
      }
      
      return printer;
    } catch (e) {
      _logger.error('Error getting printer details', e);
      return null;
    }
  }

  /// Test printer connection
  Future<bool> testPrinter(KotPrinter printer) async {
    try {
      final testContent = '''
================================
       PRINTER TEST
================================
Printer: ${printer.name}
Type: ${printer.printerType}
Time: ${DateTime.now()}
================================

This is a test print
to verify printer connection
and configuration.

================================
       END OF TEST
================================
''';

      // Create a dummy station for testing
      final testStation = KotStation(
        id: 'test',
        businessId: 'test',
        locationId: 'test',
        name: 'Test Station',
        type: 'kitchen',
        isActive: true,
        displayOrder: 0,
      );

      await printKOT(station: testStation, content: testContent);
      return true;
    } catch (e) {
      _logger.error('Printer test failed', e);
      return false;
    }
  }
}
