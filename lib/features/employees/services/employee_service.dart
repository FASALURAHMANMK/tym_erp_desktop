import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../models/employee.dart';
import '../models/employee_session.dart';
import '../models/role_template.dart';
import '../repositories/employee_repository.dart';

class EmployeeService {
  static final _logger = Logger('EmployeeService');
  
  final EmployeeRepository _repository;
  final SupabaseClient _supabase;

  EmployeeService({
    required EmployeeRepository repository,
    required SupabaseClient supabase,
  })  : _repository = repository,
        _supabase = supabase;

  // ==================== EMPLOYEE MANAGEMENT ====================

  /// Create a new employee with smart user detection
  Future<Either<String, Employee>> createEmployee({
    required String phone,
    required String fullName,
    required String businessId,
    required EmployeeRole role,
    List<String>? locationIds,
    String? email,
    String? temporaryPassword,
  }) async {
    try {
      // Validate phone number format
      if (!_isValidPhoneNumber(phone)) {
        return const Left('Invalid phone number format. Include country code (e.g., +1234567890)');
      }

      // Get current user ID for audit
      final currentUserId = _supabase.auth.currentUser?.id;

      // Create employee through repository
      return await _repository.createEmployee(
        phone: phone,
        fullName: fullName,
        businessId: businessId,
        role: role,
        locationIds: locationIds,
        email: email,
        temporaryPassword: temporaryPassword,
        currentUserId: currentUserId,
      );
    } catch (e) {
      _logger.error('Failed to create employee in service', e);
      return Left('Failed to create employee: ${e.toString()}');
    }
  }

  /// Check if a user exists with the given phone number
  Future<bool> checkUserExists(String phone) async {
    try {
      if (!_isValidPhoneNumber(phone)) {
        return false;
      }

      // Use the database function to check if user exists
      final response = await _supabase
          .rpc('check_user_exists_by_phone', params: {'check_phone': phone});
      
      if (response != null && response is List && response.isNotEmpty) {
        final userData = response.first;
        return userData['user_exists'] == true;  // Changed from 'exists' to 'user_exists'
      }
      
      // If function doesn't exist or returns empty, try alternative check
      // Check if phone is registered (simpler function)
      try {
        final isRegistered = await _supabase
            .rpc('is_phone_registered', params: {'check_phone': phone});
        return isRegistered == true;
      } catch (e) {
        // Function might not exist yet
        _logger.debug('Phone check functions not available', e);
      }
      
      return false; // Default to false if we can't check
    } catch (e) {
      _logger.error('Failed to check user existence', e);
      return false;
    }
  }

  /// Get all employees for a business
  Future<Either<String, List<Employee>>> getEmployeesForBusiness(
    String businessId, {
    String? status,
    String? role,
  }) async {
    return _repository.getEmployeesForBusiness(
      businessId,
      status: status,
      role: role,
    );
  }

  /// Get employee by ID
  Future<Either<String, Employee?>> getEmployeeById(String id) async {
    return _repository.getEmployeeById(id);
  }

  /// Update employee information
  Future<Either<String, Employee>> updateEmployee(Employee employee) async {
    return _repository.updateEmployee(employee);
  }

  /// Update employee role
  Future<Either<String, Employee>> updateEmployeeRole({
    required String employeeId,
    required EmployeeRole newRole,
  }) async {
    try {
      final employeeResult = await getEmployeeById(employeeId);
      
      return employeeResult.fold(
        (error) => Left(error),
        (employee) async {
          if (employee == null) {
            return const Left('Employee not found');
          }
          
          final updatedEmployee = employee.copyWith(
            primaryRole: newRole,
            permissions: _getDefaultPermissionsForRole(newRole),
          );
          
          return _repository.updateEmployee(updatedEmployee);
        },
      );
    } catch (e) {
      _logger.error('Failed to update employee role', e);
      return Left('Failed to update role: ${e.toString()}');
    }
  }

  /// Update employee status (active, inactive, suspended, terminated)
  Future<Either<String, Employee>> updateEmployeeStatus({
    required String employeeId,
    required EmploymentStatus newStatus,
    String? reason,
  }) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    
    return _repository.updateEmployeeStatus(
      employeeId: employeeId,
      newStatus: newStatus,
      reason: reason,
      performedBy: currentUserId,
    );
  }

  /// Suspend an employee temporarily
  Future<Either<String, Employee>> suspendEmployee({
    required String employeeId,
    required String reason,
  }) async {
    return updateEmployeeStatus(
      employeeId: employeeId,
      newStatus: EmploymentStatus.suspended,
      reason: reason,
    );
  }

  /// Reactivate a suspended or inactive employee
  Future<Either<String, Employee>> reactivateEmployee(String employeeId) async {
    return updateEmployeeStatus(
      employeeId: employeeId,
      newStatus: EmploymentStatus.active,
    );
  }

  /// Terminate an employee
  Future<Either<String, Employee>> terminateEmployee({
    required String employeeId,
    required String reason,
  }) async {
    return updateEmployeeStatus(
      employeeId: employeeId,
      newStatus: EmploymentStatus.terminated,
      reason: reason,
    );
  }

  /// Delete employee (soft delete)
  Future<Either<String, void>> deleteEmployee(String employeeId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    return _repository.deleteEmployee(employeeId, currentUserId);
  }

  // ==================== SESSION MANAGEMENT ====================

  /// Create a new session for employee login
  Future<Either<String, EmployeeSession>> createEmployeeSession({
    required String employeeId,
    required String deviceId,
    required AppType appType,
    String? deviceName,
    DeviceType? deviceType,
  }) async {
    try {
      // End any existing active sessions for this device
      final existingSessionsResult = await _repository.getActiveSessions(employeeId);
      
      await existingSessionsResult.fold(
        (error) => null,
        (sessions) async {
          for (final session in sessions) {
            if (session.deviceId == deviceId) {
              await _repository.endSession(session.id, SessionEndReason.forced);
            }
          }
        },
      );

      // Create new session
      return _repository.createSession(
        employeeId: employeeId,
        deviceId: deviceId,
        appType: appType,
        deviceName: deviceName,
        deviceType: deviceType,
        ipAddress: null, // TODO: Get actual IP
        userAgent: null, // TODO: Get actual user agent
      );
    } catch (e) {
      _logger.error('Failed to create employee session', e);
      return Left('Failed to create session: ${e.toString()}');
    }
  }

  /// Get active sessions for an employee
  Future<Either<String, List<EmployeeSession>>> getActiveSessions(
    String employeeId,
  ) async {
    return _repository.getActiveSessions(employeeId);
  }

  /// End a session (logout)
  Future<Either<String, void>> endSession(
    String sessionId, {
    SessionEndReason reason = SessionEndReason.logout,
  }) async {
    return _repository.endSession(sessionId, reason);
  }

  /// Validate session is still active
  Future<bool> validateSession(String sessionId) async {
    try {
      // TODO: Implement session validation logic
      // Check if session exists, is active, and not expired
      return true;
    } catch (e) {
      _logger.error('Failed to validate session', e);
      return false;
    }
  }

  // ==================== ROLE & PERMISSION MANAGEMENT ====================

  /// Get all available role templates
  Future<Either<String, List<RoleTemplate>>> getRoleTemplates() async {
    return _repository.getRoleTemplates();
  }

  /// Check if employee has specific permission
  Future<bool> hasPermission({
    required String employeeId,
    required String permission,
  }) async {
    try {
      final employeeResult = await getEmployeeById(employeeId);
      
      return employeeResult.fold(
        (error) => false,
        (employee) {
          if (employee == null) return false;
          return employee.hasPermission(permission);
        },
      );
    } catch (e) {
      _logger.error('Failed to check permission', e);
      return false;
    }
  }

  /// Grant additional permission to employee
  Future<Either<String, Employee>> grantPermission({
    required String employeeId,
    required String permission,
  }) async {
    try {
      final employeeResult = await getEmployeeById(employeeId);
      
      return employeeResult.fold(
        (error) => Left(error),
        (employee) async {
          if (employee == null) {
            return const Left('Employee not found');
          }
          
          final overrides = Map<String, dynamic>.from(
            employee.permissions['overrides'] ?? {},
          );
          overrides[permission] = true;
          
          final updatedPermissions = Map<String, dynamic>.from(employee.permissions);
          updatedPermissions['overrides'] = overrides;
          
          final updatedEmployee = employee.copyWith(
            permissions: updatedPermissions,
          );
          
          return _repository.updateEmployee(updatedEmployee);
        },
      );
    } catch (e) {
      _logger.error('Failed to grant permission', e);
      return Left('Failed to grant permission: ${e.toString()}');
    }
  }

  /// Revoke permission from employee
  Future<Either<String, Employee>> revokePermission({
    required String employeeId,
    required String permission,
  }) async {
    try {
      final employeeResult = await getEmployeeById(employeeId);
      
      return employeeResult.fold(
        (error) => Left(error),
        (employee) async {
          if (employee == null) {
            return const Left('Employee not found');
          }
          
          final overrides = Map<String, dynamic>.from(
            employee.permissions['overrides'] ?? {},
          );
          overrides[permission] = false;
          
          final updatedPermissions = Map<String, dynamic>.from(employee.permissions);
          updatedPermissions['overrides'] = overrides;
          
          final updatedEmployee = employee.copyWith(
            permissions: updatedPermissions,
          );
          
          return _repository.updateEmployee(updatedEmployee);
        },
      );
    } catch (e) {
      _logger.error('Failed to revoke permission', e);
      return Left('Failed to revoke permission: ${e.toString()}');
    }
  }

  // ==================== HELPER METHODS ====================

  /// Validate phone number format
  bool _isValidPhoneNumber(String phone) {
    // Basic validation for phone number with country code
    final phoneRegex = RegExp(r'^\+\d{10,15}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Get default permissions for a role
  Map<String, dynamic> _getDefaultPermissionsForRole(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.owner:
        return {'all': true};
      case EmployeeRole.manager:
        return {
          'orders': ['view', 'create', 'edit', 'cancel'],
          'inventory': ['view', 'edit'],
          'reports': ['view', 'export'],
          'payments': ['process', 'refund'],
        };
      case EmployeeRole.cashier:
        return {
          'orders': ['view', 'create', 'edit'],
          'payments': ['process', 'refund'],
          'reports': ['view_daily'],
        };
      case EmployeeRole.waiter:
        return {
          'orders': ['view', 'create', 'edit'],
          'tables': ['view', 'manage'],
          'menu': ['view'],
        };
      case EmployeeRole.kitchenStaff:
        return {
          'orders': ['view', 'update_status'],
          'kot': ['view', 'mark_ready'],
          'menu': ['view'],
        };
      case EmployeeRole.delivery:
        return {
          'orders': ['view', 'update_delivery_status'],
          'customers': ['view'],
        };
      case EmployeeRole.accountant:
        return {
          'reports': ['view', 'export', 'create'],
          'payments': ['view', 'reconcile'],
          'expenses': ['view', 'create', 'approve'],
        };
    }
  }

  /// Initialize default data (role templates, etc.)
  Future<void> initializeDefaultData() async {
    try {
      // Load role templates if not already loaded
      final templatesResult = await getRoleTemplates();
      
      templatesResult.fold(
        (error) => _logger.error('Failed to load role templates', error),
        (templates) {
          if (templates.isEmpty) {
            _logger.info('Role templates already initialized');
          }
        },
      );
    } catch (e) {
      _logger.error('Failed to initialize default data', e);
    }
  }
}