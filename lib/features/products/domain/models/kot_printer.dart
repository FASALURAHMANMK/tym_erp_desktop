import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_printer.freezed.dart';
part 'kot_printer.g.dart';

enum PrinterType { 
  @JsonValue('network') network, 
  @JsonValue('usb') usb, 
  @JsonValue('bluetooth') bluetooth 
}

@freezed
class KotPrinter with _$KotPrinter {
  const factory KotPrinter({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    required String ipAddress,
    @Default(9100) int port,
    @Default(PrinterType.network) PrinterType type,
    String? description,
    @Default(true) bool isActive,
    @Default(false) bool isDefault,
    
    // Sync fields
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _KotPrinter;

  factory KotPrinter.fromJson(Map<String, dynamic> json) => 
      _$KotPrinterFromJson(json);
      
  const KotPrinter._();
}