import 'package:freezed_annotation/freezed_annotation.dart';
import 'business_location.dart'; // Import SyncStatus

part 'pos_device.freezed.dart';

@freezed
class POSDevice with _$POSDevice {
  const factory POSDevice({
    required String id,
    required String locationId,
    required String deviceName,
    required String deviceCode, // Unique code like POS001, POS002
    String? description,
    required bool isDefault,
    required bool isActive,
    DateTime? lastSyncAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
  }) = _POSDevice;

  const POSDevice._();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location_id': locationId,
      'device_name': deviceName,
      'device_code': deviceCode,
      'description': description,
      'is_default': isDefault ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'last_sync_at': lastSyncAt?.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'sync_status': syncStatus.name,
    };
  }

  factory POSDevice.fromJson(Map<String, dynamic> json) {
    return POSDevice(
      id: json['id'] as String,
      locationId: json['location_id'] as String,
      deviceName: json['device_name'] as String,
      deviceCode: json['device_code'] as String,
      description: json['description'] as String?,
      isDefault: (json['is_default'] as int) == 1,
      isActive: (json['is_active'] as int) == 1,
      lastSyncAt: json['last_sync_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['last_sync_at'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at'] as int),
      syncStatus: SyncStatus.values.firstWhere(
        (s) => s.name == json['sync_status'],
        orElse: () => SyncStatus.pending,
      ),
    );
  }

  // Create from Supabase data (different format)
  factory POSDevice.fromSupabase(Map<String, dynamic> json) {
    return POSDevice(
      id: json['id'] as String,
      locationId: json['location_id'] as String,
      deviceName: json['device_name'] as String,
      deviceCode: json['device_code'] as String,
      description: json['description'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      lastSyncAt: json['last_sync_at'] != null 
          ? DateTime.parse(json['last_sync_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      syncStatus: SyncStatus.synced, // Data from Supabase is considered synced
    );
  }

  // Convert to Supabase format
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'location_id': locationId,
      'device_name': deviceName,
      'device_code': deviceCode,
      'description': description,
      'is_default': isDefault,
      'is_active': isActive,
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

extension POSDeviceExtension on POSDevice {
  String get displayName => '$deviceName ($deviceCode)';
  
  bool get isOnline => lastSyncAt != null && 
      DateTime.now().difference(lastSyncAt!).inMinutes < 5;
  
  String get statusText {
    if (!isActive) return 'Inactive';
    if (isOnline) return 'Online';
    return 'Offline';
  }
}