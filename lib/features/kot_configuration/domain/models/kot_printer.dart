import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_printer.freezed.dart';
part 'kot_printer.g.dart';

@freezed
class KotPrinter with _$KotPrinter {
  const factory KotPrinter({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    required String printerType, // network, bluetooth, usb
    String? ipAddress,
    String? port,
    String? macAddress,
    String? deviceName,
    required bool isActive,
    required bool isDefault,
    required int printCopies,
    required String paperSize, // 58mm, 80mm
    required bool autoCut,
    required bool cashDrawer,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _KotPrinter;

  factory KotPrinter.fromJson(Map<String, dynamic> json) =>
      _$KotPrinterFromJson(json);
}