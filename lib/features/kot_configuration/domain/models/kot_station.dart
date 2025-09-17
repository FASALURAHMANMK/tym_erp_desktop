import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_station.freezed.dart';
part 'kot_station.g.dart';

@freezed
class KotStation with _$KotStation {
  const factory KotStation({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    required String type, // kitchen, bar, bakery, grill, etc.
    String? description,
    required bool isActive,
    required int displayOrder,
    String? color, // hex color for visual identification
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _KotStation;

  factory KotStation.fromJson(Map<String, dynamic> json) =>
      _$KotStationFromJson(json);
}