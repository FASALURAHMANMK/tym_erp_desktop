import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant_table.freezed.dart';
part 'restaurant_table.g.dart';

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
  @JsonValue('cleaning')
  cleaning,
}

enum TableShape {
  @JsonValue('rectangle')
  rectangle,
  @JsonValue('circle')
  circle,
  @JsonValue('square')
  square,
}

@freezed
class RestaurantTable with _$RestaurantTable {
  const factory RestaurantTable({
    required String id,
    required String areaId,
    required String businessId,
    required String locationId,
    required String tableNumber,
    String? displayName,
    @Default(4) int capacity,
    @Default(TableStatus.free) TableStatus status,
    String? currentOrderId,
    @Default(0) int positionX,
    @Default(0) int positionY,
    @Default(100) int width,
    @Default(100) int height,
    @Default(TableShape.rectangle) TableShape shape,
    @Default(true) bool isActive,
    @Default(true) bool isBookable,
    @Default({}) Map<String, dynamic> settings,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastOccupiedAt,
    DateTime? lastClearedAt,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _RestaurantTable;

  factory RestaurantTable.fromJson(Map<String, dynamic> json) =>
      _$RestaurantTableFromJson(json);

  const RestaurantTable._();

  // Helper methods
  String get effectiveDisplayName => displayName ?? 'Table $tableNumber';
  
  bool get isFree => status == TableStatus.free;
  bool get isOccupied => status == TableStatus.occupied;
  bool get isBilled => status == TableStatus.billed;
  bool get isBlocked => status == TableStatus.blocked;
  bool get isReserved => status == TableStatus.reserved;
  bool get isCleaning => status == TableStatus.cleaning;
  
  bool get isAvailable => isFree && isActive && isBookable;
  bool get canBeOccupied => (isFree || isReserved) && isActive;
  
  // Get status color
  String getStatusColorHex() {
    switch (status) {
      case TableStatus.free:
        return '#4CAF50'; // Green
      case TableStatus.occupied:
        return '#F44336'; // Red
      case TableStatus.billed:
        return '#FF9800'; // Orange
      case TableStatus.blocked:
        return '#9E9E9E'; // Grey
      case TableStatus.reserved:
        return '#2196F3'; // Blue
      case TableStatus.cleaning:
        return '#FFC107'; // Amber
    }
  }
  
  // Get status display text
  String getStatusDisplayText() {
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
      case TableStatus.cleaning:
        return 'Cleaning';
    }
  }
  
  // Calculate occupancy duration
  Duration? getOccupancyDuration() {
    if (lastOccupiedAt == null || !isOccupied) return null;
    return DateTime.now().difference(lastOccupiedAt!);
  }
  
  // Format occupancy duration for display
  String? getOccupancyDurationText() {
    final duration = getOccupancyDuration();
    if (duration == null) return null;
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}