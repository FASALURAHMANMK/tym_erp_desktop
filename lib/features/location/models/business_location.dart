import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_location.freezed.dart';

@freezed
class BusinessLocation with _$BusinessLocation {
  const factory BusinessLocation({
    required String id,
    required String businessId,
    required String name,
    String? address,
    String? phone,
    required bool isDefault,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
  }) = _BusinessLocation;

  const BusinessLocation._();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'name': name,
      'address': address,
      'phone': phone,
      'is_default': isDefault ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'sync_status': syncStatus.name,
    };
  }

  factory BusinessLocation.fromJson(Map<String, dynamic> json) {
    return BusinessLocation(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      isDefault: (json['is_default'] as int) == 1,
      isActive: (json['is_active'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at'] as int),
      syncStatus: SyncStatus.values.firstWhere(
        (s) => s.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
    );
  }

  // Create from Supabase data (different format)
  factory BusinessLocation.fromSupabase(Map<String, dynamic> json) {
    return BusinessLocation(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      syncStatus: SyncStatus.synced, // Data from Supabase is considered synced
    );
  }

  // Convert to Supabase format
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'business_id': businessId,
      'name': name,
      'address': address,
      'phone': phone,
      'is_default': isDefault,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum SyncStatus {
  synced,    // Data matches remote
  pending,   // Local changes need upload
  conflict,  // Merge conflict needs resolution
  error,     // Sync failed
}

extension SyncStatusExtension on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pending:
        return 'Pending Sync';
      case SyncStatus.conflict:
        return 'Sync Conflict';
      case SyncStatus.error:
        return 'Sync Error';
    }
  }

  bool get needsSync => this == SyncStatus.pending || this == SyncStatus.error;
}