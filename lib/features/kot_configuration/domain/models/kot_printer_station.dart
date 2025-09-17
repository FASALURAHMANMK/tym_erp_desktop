import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_printer_station.freezed.dart';
part 'kot_printer_station.g.dart';

@freezed
class KotPrinterStation with _$KotPrinterStation {
  const factory KotPrinterStation({
    required String id,
    required String businessId,
    required String locationId,
    required String printerId,
    required String stationId,
    required bool isActive,
    required int priority, // print order priority
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _KotPrinterStation;

  factory KotPrinterStation.fromJson(Map<String, dynamic> json) =>
      _$KotPrinterStationFromJson(json);
}