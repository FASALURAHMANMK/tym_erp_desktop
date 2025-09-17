import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

enum EmployeeRole {
  @JsonValue('owner')
  owner,
  @JsonValue('manager')
  manager,
  @JsonValue('cashier')
  cashier,
  @JsonValue('waiter')
  waiter,
  @JsonValue('kitchen_staff')
  kitchenStaff,
  @JsonValue('delivery')
  delivery,
  @JsonValue('accountant')
  accountant,
}

enum EmploymentStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('suspended')
  suspended,
  @JsonValue('terminated')
  terminated,
}

@freezed
class Employee with _$Employee {
  const factory Employee({
    required String id,
    required String userId,
    required String businessId,
    
    // Basic Info
    required String employeeCode,
    String? displayName,
    
    // Role & Access
    required EmployeeRole primaryRole,
    @Default([]) List<String> assignedLocations,
    @Default(false) bool canAccessAllLocations,
    
    // Employment
    @Default(EmploymentStatus.active) EmploymentStatus employmentStatus,
    required DateTime joinedAt,
    DateTime? terminatedAt,
    String? terminationReason,
    
    // Contact
    String? workPhone,
    String? workEmail,
    @Default({}) Map<String, dynamic> emergencyContact,
    
    // Settings & Permissions
    @Default({}) Map<String, dynamic> permissions,
    @Default({}) Map<String, dynamic> settings,
    
    // Shift & Schedule
    String? defaultShiftStart, // Store as string "09:00"
    String? defaultShiftEnd,   // Store as string "17:00"
    @Default([1, 2, 3, 4, 5]) List<int> workingDays, // 1=Monday, 7=Sunday
    
    // Compensation
    double? hourlyRate,
    double? monthlySalary,
    
    // Meta
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    String? lastModifiedBy,
    
    // Sync fields
    @Default(false) bool hasUnsyncedChanges,
    DateTime? lastSyncedAt,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  const Employee._();

  // Helper methods
  String get roleDisplayName {
    switch (primaryRole) {
      case EmployeeRole.owner:
        return 'Owner';
      case EmployeeRole.manager:
        return 'Manager';
      case EmployeeRole.cashier:
        return 'Cashier';
      case EmployeeRole.waiter:
        return 'Waiter';
      case EmployeeRole.kitchenStaff:
        return 'Kitchen Staff';
      case EmployeeRole.delivery:
        return 'Delivery';
      case EmployeeRole.accountant:
        return 'Accountant';
    }
  }

  String get statusDisplayName {
    switch (employmentStatus) {
      case EmploymentStatus.active:
        return 'Active';
      case EmploymentStatus.inactive:
        return 'Inactive';
      case EmploymentStatus.suspended:
        return 'Suspended';
      case EmploymentStatus.terminated:
        return 'Terminated';
    }
  }

  bool get isActive => employmentStatus == EmploymentStatus.active;
  
  bool get canLogin => 
      employmentStatus == EmploymentStatus.active || 
      employmentStatus == EmploymentStatus.inactive;

  bool hasPermission(String permission) {
    // Check if user has specific permission
    if (primaryRole == EmployeeRole.owner) {
      return true; // Owners have all permissions
    }
    
    final rolePermissions = permissions['role'] as Map<String, dynamic>?;
    if (rolePermissions != null) {
      final perms = rolePermissions['permissions'] as List<dynamic>?;
      if (perms != null && perms.contains(permission)) {
        return true;
      }
    }
    
    // Check override permissions
    final overrides = permissions['overrides'] as Map<String, dynamic>?;
    if (overrides != null) {
      return overrides[permission] == true;
    }
    
    return false;
  }

  bool canAccessLocation(String locationId) {
    if (canAccessAllLocations) return true;
    return assignedLocations.contains(locationId);
  }

  // Get working days as readable string
  String get workingDaysDisplay {
    const dayNames = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    
    if (workingDays.length == 7) return 'Every day';
    if (workingDays.length == 5 && 
        workingDays.every((d) => d >= 1 && d <= 5)) {
      return 'Mon - Fri';
    }
    
    return workingDays.map((d) => dayNames[d] ?? '').join(', ');
  }

  // Get shift timing display
  String? get shiftDisplay {
    if (defaultShiftStart != null && defaultShiftEnd != null) {
      return '$defaultShiftStart - $defaultShiftEnd';
    }
    return null;
  }
}