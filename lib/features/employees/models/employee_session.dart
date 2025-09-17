import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_session.freezed.dart';
part 'employee_session.g.dart';

enum DeviceType {
  @JsonValue('desktop')
  desktop,
  @JsonValue('mobile')
  mobile,
  @JsonValue('tablet')
  tablet,
  @JsonValue('pos_terminal')
  posTerminal,
}

enum AppType {
  @JsonValue('erp_desktop')
  erpDesktop,
  @JsonValue('waiter_app')
  waiterApp,
  @JsonValue('kitchen_app')
  kitchenApp,
  @JsonValue('delivery_app')
  deliveryApp,
}

enum SessionEndReason {
  @JsonValue('logout')
  logout,
  @JsonValue('timeout')
  timeout,
  @JsonValue('forced')
  forced,
  @JsonValue('app_closed')
  appClosed,
  @JsonValue('network_error')
  networkError,
}

@freezed
class EmployeeSession with _$EmployeeSession {
  const factory EmployeeSession({
    required String id,
    required String employeeId,
    
    // Session Info
    required String sessionToken,
    required String deviceId,
    String? deviceName,
    DeviceType? deviceType,
    AppType? appType,
    String? appVersion,
    
    // Network Info
    String? ipAddress,
    String? userAgent,
    
    // Activity
    required DateTime startedAt,
    required DateTime lastActivityAt,
    DateTime? expiresAt,
    
    // Location tracking (for mobile apps)
    double? lastKnownLatitude,
    double? lastKnownLongitude,
    DateTime? lastLocationUpdate,
    
    // Status
    @Default(true) bool isActive,
    DateTime? endedAt,
    SessionEndReason? endReason,
    
    required DateTime createdAt,
  }) = _EmployeeSession;

  factory EmployeeSession.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSessionFromJson(json);

  const EmployeeSession._();

  // Helper methods
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Duration get sessionDuration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  String get sessionDurationDisplay {
    final duration = sessionDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  bool get isStale {
    // Consider session stale if no activity for 30 minutes
    return DateTime.now().difference(lastActivityAt).inMinutes > 30;
  }

  String get deviceTypeDisplay {
    switch (deviceType) {
      case DeviceType.desktop:
        return 'Desktop';
      case DeviceType.mobile:
        return 'Mobile';
      case DeviceType.tablet:
        return 'Tablet';
      case DeviceType.posTerminal:
        return 'POS Terminal';
      default:
        return 'Unknown';
    }
  }

  String get appTypeDisplay {
    switch (appType) {
      case AppType.erpDesktop:
        return 'ERP Desktop';
      case AppType.waiterApp:
        return 'Waiter App';
      case AppType.kitchenApp:
        return 'Kitchen Display';
      case AppType.deliveryApp:
        return 'Delivery App';
      default:
        return 'Unknown App';
    }
  }
}