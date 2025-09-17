import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_price_override.freezed.dart';
part 'table_price_override.g.dart';

@freezed
class TablePriceOverride with _$TablePriceOverride {
  const factory TablePriceOverride({
    required String id,
    required String tableId,
    required String variationId,
    required double price,
    @Default(true) bool isActive,
    DateTime? validFrom,
    DateTime? validUntil,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? lastSyncedAt,
    @Default(false) bool hasUnsyncedChanges,
  }) = _TablePriceOverride;

  factory TablePriceOverride.fromJson(Map<String, dynamic> json) =>
      _$TablePriceOverrideFromJson(json);

  const TablePriceOverride._();

  // Helper methods
  bool get isCurrentlyValid {
    if (!isActive) return false;
    
    final now = DateTime.now();
    
    if (validFrom != null && now.isBefore(validFrom!)) {
      return false;
    }
    
    if (validUntil != null && now.isAfter(validUntil!)) {
      return false;
    }
    
    return true;
  }
  
  bool get hasValidityPeriod => validFrom != null || validUntil != null;
  
  bool get isExpired {
    if (validUntil == null) return false;
    return DateTime.now().isAfter(validUntil!);
  }
  
  bool get isUpcoming {
    if (validFrom == null) return false;
    return DateTime.now().isBefore(validFrom!);
  }
  
  // Get days until expiry
  int? getDaysUntilExpiry() {
    if (validUntil == null) return null;
    final difference = validUntil!.difference(DateTime.now());
    return difference.inDays;
  }
}