import 'package:freezed_annotation/freezed_annotation.dart';

part 'table.freezed.dart';
part 'table.g.dart';

enum TableStatus {
  @JsonValue('free')
  free,
  @JsonValue('occupied')
  occupied,
  @JsonValue('billed')
  billed,
  @JsonValue('blocked')
  blocked,
  @JsonValue('reserved')
  reserved,
}

enum TableShape {
  @JsonValue('square')
  square,
  @JsonValue('rectangle')
  rectangle,
  @JsonValue('circle')
  circle,
  @JsonValue('oval')
  oval,
}

@freezed
class RestaurantTable with _$RestaurantTable {
  const factory RestaurantTable({
    required String id,
    required String businessId,
    required String locationId,
    required String floorId,
    required String tableName,
    String? displayName,
    @Default(4) int seatingCapacity,
    @Default(TableStatus.free) TableStatus status,
    @Default(TableShape.square) TableShape shape,
    String? currentOrderId,
    DateTime? occupiedAt,
    String? occupiedBy, // Waiter/Staff ID
    double? currentAmount,
    String? customerName,
    String? customerPhone,
    @Default(0) double positionX, // For visual layout
    @Default(0) double positionY, // For visual layout
    @Default(100) double width,
    @Default(100) double height,
    @Default('#4CAF50') String colorHex, // Visual color
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    String? notes,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _RestaurantTable;

  factory RestaurantTable.fromJson(Map<String, dynamic> json) =>
      _$RestaurantTableFromJson(json);

  const RestaurantTable._();

  // Helper getters
  bool get isFree => status == TableStatus.free;

  bool get isOccupied => status == TableStatus.occupied;

  bool get isBilled => status == TableStatus.billed;

  bool get isBlocked => status == TableStatus.blocked;

  bool get isReserved => status == TableStatus.reserved;

  bool get isAvailable => status == TableStatus.free && isActive;

  // Calculate occupied duration
  Duration? get occupiedDuration {
    if (occupiedAt == null) return null;
    return DateTime.now().difference(occupiedAt!);
  }

  // Format occupied time display
  String get occupiedTimeDisplay {
    final duration = occupiedDuration;
    if (duration == null) return '';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Get status color
  String get statusColorHex {
    switch (status) {
      case TableStatus.free:
        return '#4CAF50'; // Green
      case TableStatus.occupied:
        return '#FF5252'; // Red
      case TableStatus.billed:
        return '#FFC107'; // Amber
      case TableStatus.blocked:
        return '#9E9E9E'; // Grey
      case TableStatus.reserved:
        return '#2196F3'; // Blue
    }
  }

  // Get display text
  String get displayText => displayName ?? tableName;

  // Get status text
  String get statusText {
    switch (status) {
      case TableStatus.free:
        return 'Free';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.billed:
        return 'Billed';
      case TableStatus.blocked:
        return 'Blocked';
      case TableStatus.reserved:
        return 'Reserved';
    }
  }
}

@freezed
class Floor with _$Floor {
  const factory Floor({
    required String id,
    required String businessId,
    required String locationId,
    required String name,
    String? description,
    @Default(0) int displayOrder,
    @Default(true) bool isActive,
    @Default([]) List<RestaurantTable> tables,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Floor;

  factory Floor.fromJson(Map<String, dynamic> json) => _$FloorFromJson(json);

  const Floor._();

  // Helper getters
  int get totalTables => tables.length;

  int get freeTables => tables.where((t) => t.isFree).length;

  int get occupiedTables => tables.where((t) => t.isOccupied).length;

  int get billedTables => tables.where((t) => t.isBilled).length;

  // Check if floor has available tables
  bool get hasAvailableTables => tables.any((t) => t.isAvailable);
}
