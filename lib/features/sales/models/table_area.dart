import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_area.freezed.dart';
part 'table_area.g.dart';

@freezed
class TableArea with _$TableArea {
  const factory TableArea({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    String? description,
    @Default(0) int displayOrder,
    @Default(true) bool isActive,
    @Default({}) Map<String, dynamic> layoutConfig,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _TableArea;

  factory TableArea.fromJson(Map<String, dynamic> json) =>
      _$TableAreaFromJson(json);

  const TableArea._();

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unnamed Area';
  
  // Get grid dimensions from layout config
  int get gridColumns => layoutConfig['gridColumns'] as int? ?? 4;
  int get gridRows => layoutConfig['gridRows'] as int? ?? 4;
  
  // Check if area has custom layout
  bool get hasCustomLayout => layoutConfig.isNotEmpty;
}