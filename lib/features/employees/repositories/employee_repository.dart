import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/logger.dart';
import '../../../services/sync_queue_service.dart';
import '../data/employee_local_database.dart';
import '../models/employee.dart';
import '../models/employee_session.dart';
import '../models/role_template.dart';

class EmployeeRepository {
  static final _logger = Logger('EmployeeRepository');
  static const _uuid = Uuid();

  final Database localDatabase;
  final SupabaseClient supabase;
  final SyncQueueService syncQueueService;
  final EmployeeLocalDatabase _localDb;

  EmployeeRepository({
    required this.localDatabase,
    required this.supabase,
    required this.syncQueueService,
  }) : _localDb = EmployeeLocalDatabase(database: localDatabase);

  // Initialize local tables
  Future<void> initializeLocalTables() async {
    await EmployeeLocalDatabase.initializeTables(localDatabase);
  }

  // ==================== EMPLOYEE OPERATIONS ====================

  /// Create a new employee
  Future<Either<String, Employee>> createEmployee({
    required String phone,
    required String fullName,
    required String businessId,
    required EmployeeRole role,
    List<String>? locationIds,
    String? email,
    String? temporaryPassword,
    String? currentUserId,
  }) async {
    try {
      // Step 1: Check if user exists with this phone
      final existingUserResult = await _checkUserExists(phone);

      String? userId;
      bool isNewUser = false;

      // Handle the Either result properly
      final userExistsResult = existingUserResult.getOrElse(() => null);
      
      if (userExistsResult != null) {
        // User exists - just create employee record
        userId = userExistsResult;

        // Check if already an employee of this business
        final existingEmployee = await _localDb.getEmployeeByUserId(
          userExistsResult,
          businessId,
        );
        if (existingEmployee != null) {
          return const Left('This person is already an employee of your business');
        }
      } else {
        // New user - need to create account
        isNewUser = true;

        // Generate temporary password if not provided
        final password = temporaryPassword ?? _generateTemporaryPassword();

        // IMPORTANT: Save current session before creating new user
        final currentSession = supabase.auth.currentSession;
        final currentUser = supabase.auth.currentUser;

        try {
          // For employee creation, we need to use email-based signup because:
          // 1. Phone signup requires SMS provider configuration  
          // 2. We don't want to send SMS verification for employee accounts
          // 3. We'll store the phone number in user metadata
          
          // Generate a unique email if not provided
          final signupEmail = email ?? '${phone.replaceAll('+', '')}@employee.tym-erp.local';
          
          final authResponse = await supabase.auth.signUp(
            email: signupEmail,
            password: password,
            data: {
              'full_name': fullName,
              'phone': phone,  // Store phone in metadata
              'email': email,  // Store actual email if provided
              'created_by_business': businessId,
              'is_employee': true,  // Mark as employee account
            },
          );

          if (authResponse.user == null) {
            // Restore original session if creation failed
            if (currentSession != null) {
              await supabase.auth.setSession(currentSession.refreshToken!);
            }
            return const Left('Failed to create user account');
          }

          userId = authResponse.user!.id;
          
          // Update the phone field in auth.users using our database function
          try {
            await supabase.rpc('update_user_phone', params: {
              'user_id': userId,
              'phone_number': phone,
            });
            _logger.info('Updated phone number for user: $userId');
          } catch (e) {
            _logger.warning('Could not update phone in auth.users (function may not exist yet)', e);
            // Continue anyway - phone is stored in metadata
          }

          // CRITICAL: Restore the original session immediately after creating the user
          // This prevents the new employee from becoming the current user
          if (currentSession != null && currentSession.refreshToken != null) {
            try {
              await supabase.auth.setSession(currentSession.refreshToken!);
              _logger.info('Original session restored after employee creation');
            } catch (e) {
              _logger.error('Failed to restore original session', e);
              // Try to recover with stored access token
              try {
                await supabase.auth.recoverSession(currentSession.accessToken);
                _logger.info('Session recovered using access token');
              } catch (e2) {
                _logger.error('Failed to recover session with access token', e2);
              }
            }
          }

          // TODO: Implement SMS service to send credentials
          _logger.info('New user created. Temporary password: $password');
        } catch (e) {
          // Always try to restore original session on any error
          if (currentSession != null && currentSession.refreshToken != null) {
            try {
              await supabase.auth.setSession(currentSession.refreshToken!);
            } catch (_) {
              // Silent fail - already in error state
            }
          }
          _logger.error('Failed to create user account', e);
          return Left('Failed to create user account: ${e.toString()}');
        }
      }

      // Step 2: Generate employee code
      final employeeCode = await _localDb.generateEmployeeCode(businessId);

      // Step 3: Create employee record
      final now = DateTime.now();
      if (userId == null) {
        throw Exception('User ID not initialized');
      }
      
      final employee = Employee(
        id: _uuid.v4(),
        userId: userId!,
        businessId: businessId,
        employeeCode: employeeCode,
        displayName: fullName,
        primaryRole: role,
        assignedLocations: locationIds ?? [],
        canAccessAllLocations: locationIds == null || locationIds.isEmpty,
        employmentStatus: EmploymentStatus.active,
        joinedAt: now,
        permissions: _getDefaultPermissions(role),
        createdAt: now,
        updatedAt: now,
        createdBy: currentUserId,
        hasUnsyncedChanges: true,
      );

      // Step 4: Save to local database
      await _localDb.saveEmployee(employee);

      // Step 5: Add to sync queue (employee MUST be synced before audit log)
      await _addEmployeeToSyncQueue(employee, 'INSERT');

      // Step 6: Log the action (AFTER employee is queued for sync)
      // NOTE: We delay audit log creation to avoid foreign key violations
      // The audit log will be created after the employee is successfully synced
      // For now, we'll skip the audit log and rely on the employee record itself
      // await _logAuditAction(
      //   employeeId: employee.id,
      //   businessId: businessId,
      //   action: 'created',
      //   performedBy: currentUserId,
      //   details: {'role': role.name, 'is_new_user': isNewUser},
      // );
      _logger.info('Skipping audit log to prevent foreign key violation during sync');

      _logger.info('Employee created successfully: ${employee.employeeCode}');
      return Right(employee);
    } catch (e, stackTrace) {
      _logger.error('Failed to create employee', e, stackTrace);
      return Left('Failed to create employee: ${e.toString()}');
    }
  }

  /// Get employee by ID
  Future<Either<String, Employee?>> getEmployeeById(String id) async {
    try {
      final employee = await _localDb.getEmployeeById(id);
      return Right(employee);
    } catch (e) {
      _logger.error('Failed to get employee by ID', e);
      return Left('Failed to get employee: $e');
    }
  }

  /// Get all employees for a business
  Future<Either<String, List<Employee>>> getEmployeesForBusiness(
    String businessId, {
    String? status,
    String? role,
  }) async {
    try {
      final employees = await _localDb.getEmployeesForBusiness(
        businessId,
        status: status,
        role: role,
      );

      return Right(employees);
    } catch (e) {
      _logger.error('Failed to get employees', e);
      return Left('Failed to get employees: $e');
    }
  }

  /// Update employee information
  Future<Either<String, Employee>> updateEmployee(Employee employee) async {
    try {
      final updatedEmployee = employee.copyWith(
        updatedAt: DateTime.now(),
        hasUnsyncedChanges: true,
      );

      await _localDb.updateEmployee(updatedEmployee);
      await _addEmployeeToSyncQueue(updatedEmployee, 'UPDATE');

      _logger.info('Employee updated: ${employee.employeeCode}');
      return Right(updatedEmployee);
    } catch (e) {
      _logger.error('Failed to update employee', e);
      return Left('Failed to update employee: $e');
    }
  }

  /// Update employee status
  Future<Either<String, Employee>> updateEmployeeStatus({
    required String employeeId,
    required EmploymentStatus newStatus,
    String? reason,
    String? performedBy,
  }) async {
    try {
      final employeeResult = await getEmployeeById(employeeId);

      return employeeResult.fold((error) => Left(error), (employee) async {
        if (employee == null) {
          return Left('Employee not found');
        }

        final updatedEmployee = employee.copyWith(
          employmentStatus: newStatus,
          terminatedAt:
              newStatus == EmploymentStatus.terminated
                  ? DateTime.now()
                  : employee.terminatedAt,
          terminationReason:
              newStatus == EmploymentStatus.terminated
                  ? reason
                  : employee.terminationReason,
          updatedAt: DateTime.now(),
          hasUnsyncedChanges: true,
        );

        await _localDb.updateEmployee(updatedEmployee);
        await _addEmployeeToSyncQueue(updatedEmployee, 'UPDATE');

        // Log the status change
        await _logAuditAction(
          employeeId: employeeId,
          businessId: employee.businessId,
          action: _getStatusChangeAction(newStatus),
          performedBy: performedBy,
          details: {
            'old_status': employee.employmentStatus.name,
            'new_status': newStatus.name,
            'reason': reason,
          },
        );

        _logger.info(
          'Employee status updated: $employeeId to ${newStatus.name}',
        );
        return Right(updatedEmployee);
      });
    } catch (e) {
      _logger.error('Failed to update employee status', e);
      return Left('Failed to update employee status: $e');
    }
  }

  /// Delete employee (soft delete by changing status)
  Future<Either<String, void>> deleteEmployee(
    String employeeId,
    String? performedBy,
  ) async {
    try {
      final result = await updateEmployeeStatus(
        employeeId: employeeId,
        newStatus: EmploymentStatus.terminated,
        reason: 'Deleted by admin',
        performedBy: performedBy,
      );

      return result.fold((error) => Left(error), (_) => const Right(null));
    } catch (e) {
      _logger.error('Failed to delete employee', e);
      return Left('Failed to delete employee: $e');
    }
  }

  // ==================== SESSION OPERATIONS ====================

  /// Create a new session for an employee
  Future<Either<String, EmployeeSession>> createSession({
    required String employeeId,
    required String deviceId,
    required AppType appType,
    String? deviceName,
    DeviceType? deviceType,
    String? ipAddress,
    String? userAgent,
  }) async {
    try {
      final now = DateTime.now();
      final session = EmployeeSession(
        id: _uuid.v4(),
        employeeId: employeeId,
        sessionToken: _generateSessionToken(),
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
        appType: appType,
        ipAddress: ipAddress,
        userAgent: userAgent,
        startedAt: now,
        lastActivityAt: now,
        expiresAt: now.add(const Duration(hours: 8)),
        // 8 hour sessions
        createdAt: now,
      );

      await _localDb.saveSession(session);

      // Add to sync queue
      await syncQueueService.addToQueue(
        'employee_sessions',
        'INSERT',
        session.id,
        _sessionToSupabaseFormat(session),
      );

      _logger.info('Session created for employee: $employeeId');
      return Right(session);
    } catch (e) {
      _logger.error('Failed to create session', e);
      return Left('Failed to create session: $e');
    }
  }

  /// Get active sessions for an employee
  Future<Either<String, List<EmployeeSession>>> getActiveSessions(
    String employeeId,
  ) async {
    try {
      final sessions = await _localDb.getActiveSessions(employeeId);
      return Right(sessions);
    } catch (e) {
      _logger.error('Failed to get active sessions', e);
      return Left('Failed to get active sessions: $e');
    }
  }

  /// End a session
  Future<Either<String, void>> endSession(
    String sessionId,
    SessionEndReason reason,
  ) async {
    try {
      await _localDb.endSession(sessionId, reason);

      // Add to sync queue
      await syncQueueService
          .addToQueue('employee_sessions', 'UPDATE', sessionId, {
            'is_active': false,
            'ended_at': DateTime.now().toIso8601String(),
            'end_reason': reason.name,
          });

      _logger.info('Session ended: $sessionId');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to end session', e);
      return Left('Failed to end session: $e');
    }
  }

  // ==================== ROLE OPERATIONS ====================

  /// Get all role templates
  Future<Either<String, List<RoleTemplate>>> getRoleTemplates() async {
    try {
      final templates = await _localDb.getRoleTemplates();

      // If empty, load default templates
      if (templates.isEmpty) {
        await _loadDefaultRoleTemplates();
        final updatedTemplates = await _localDb.getRoleTemplates();
        return Right(updatedTemplates);
      }

      return Right(templates);
    } catch (e) {
      _logger.error('Failed to get role templates', e);
      return Left('Failed to get role templates: $e');
    }
  }

  // ==================== HELPER METHODS ====================

  /// Check if user exists with given phone number
  Future<Either<String?, String?>> _checkUserExists(String phone) async {
    try {
      // Use the database function to check if user exists
      final response = await supabase
          .rpc('check_user_exists_by_phone', params: {'check_phone': phone});
      
      if (response != null && response is List && response.isNotEmpty) {
        final userData = response.first;
        if (userData['user_exists'] == true) {  // Changed from 'exists' to 'user_exists'
          // User exists, return their ID
          return Right(userData['user_id'] as String);
        }
      }
      
      // User doesn't exist
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to check user existence', e);
      // In case of error (offline or function doesn't exist), 
      // proceed with the assumption that user doesn't exist
      return const Right(null);
    }
  }

  /// Generate temporary password
  String _generateTemporaryPassword() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(8, (index) {
      final charIndex = (random + index) % chars.length;
      return chars[charIndex];
    }).join();
  }

  /// Generate session token
  String _generateSessionToken() {
    return _uuid.v4().replaceAll('-', '');
  }

  /// Get default permissions for a role
  Map<String, dynamic> _getDefaultPermissions(EmployeeRole role) {
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

  /// Get status change action name
  String _getStatusChangeAction(EmploymentStatus status) {
    switch (status) {
      case EmploymentStatus.active:
        return 'reactivated';
      case EmploymentStatus.inactive:
        return 'deactivated';
      case EmploymentStatus.suspended:
        return 'suspended';
      case EmploymentStatus.terminated:
        return 'terminated';
    }
  }

  /// Load default role templates
  Future<void> _loadDefaultRoleTemplates() async {
    final templates = [
      RoleTemplate(
        id: _uuid.v4(),
        roleCode: 'owner',
        roleName: 'Owner',
        permissions: {'all': true},
        description: 'Business owner with full system access',
        createdAt: DateTime.now(),
      ),
      RoleTemplate(
        id: _uuid.v4(),
        roleCode: 'manager',
        roleName: 'Manager',
        permissions: {
          'orders': ['view', 'create', 'edit', 'cancel', 'void'],
          'inventory': ['view', 'edit', 'adjust'],
          'employees': ['view', 'create', 'edit'],
          'reports': ['view', 'export'],
          'payments': ['process', 'refund'],
        },
        description: 'Location manager with broad access',
        createdAt: DateTime.now(),
      ),
      RoleTemplate(
        id: _uuid.v4(),
        roleCode: 'cashier',
        roleName: 'Cashier',
        permissions: {
          'orders': ['view', 'create', 'edit'],
          'payments': ['process', 'refund'],
          'reports': ['view_daily'],
          'cash_drawer': ['open', 'close', 'count'],
        },
        description: 'Payment processing and order management',
        createdAt: DateTime.now(),
      ),
      RoleTemplate(
        id: _uuid.v4(),
        roleCode: 'waiter',
        roleName: 'Waiter',
        permissions: {
          'orders': ['view', 'create', 'edit'],
          'tables': ['view', 'manage'],
          'menu': ['view'],
          'kot': ['create', 'print'],
        },
        description: 'Table service and order taking',
        createdAt: DateTime.now(),
      ),
      RoleTemplate(
        id: _uuid.v4(),
        roleCode: 'kitchen_staff',
        roleName: 'Kitchen Staff',
        permissions: {
          'orders': ['view', 'update_status'],
          'kot': ['view', 'mark_ready'],
          'inventory': ['view'],
          'menu': ['view'],
        },
        description: 'Kitchen order management',
        createdAt: DateTime.now(),
      ),
    ];

    await _localDb.saveRoleTemplates(templates);
  }

  /// Add employee to sync queue
  Future<void> _addEmployeeToSyncQueue(
    Employee employee,
    String operation,
  ) async {
    try {
      final data = _employeeToSupabaseFormat(employee);
      
      // Remove local-only fields that don't exist in Supabase
      data.remove('has_unsynced_changes');
      data.remove('last_synced_at');

      await syncQueueService.addToQueue(
        'employees',
        operation,
        employee.id,
        data,
      );
    } catch (e) {
      _logger.error('Failed to add employee to sync queue', e);
    }
  }

  /// Log audit action
  Future<void> _logAuditAction({
    required String employeeId,
    required String businessId,
    required String action,
    String? performedBy,
    Map<String, dynamic>? details,
  }) async {
    try {
      final auditData = {
        'id': _uuid.v4(),
        'employee_id': employeeId,
        'business_id': businessId,
        'action': action,
        'old_values': jsonEncode(details?['old_values'] ?? {}),
        'new_values': jsonEncode(details?['new_values'] ?? {}),
        'performed_by': performedBy,
        'performed_at': DateTime.now().toIso8601String(),
        'has_unsynced_changes': 1,
      };

      await localDatabase.insert('employee_audit_log', auditData);

      // Add to sync queue
      await syncQueueService.addToQueue(
        'employee_audit_log',
        'INSERT',
        auditData['id'] as String,
        auditData,
      );
    } catch (e) {
      _logger.error('Failed to log audit action', e);
    }
  }

  // ==================== FORMAT CONVERSION ====================

  Map<String, dynamic> _employeeToSupabaseFormat(Employee employee) {
    return {
      'id': employee.id,
      'user_id': employee.userId,
      'business_id': employee.businessId,
      'employee_code': employee.employeeCode,
      'display_name': employee.displayName,
      'primary_role': employee.primaryRole.name,
      'assigned_locations': employee.assignedLocations,
      'can_access_all_locations': employee.canAccessAllLocations,
      'employment_status': employee.employmentStatus.name,
      'joined_at': employee.joinedAt.toIso8601String(),
      'terminated_at': employee.terminatedAt?.toIso8601String(),
      'termination_reason': employee.terminationReason,
      'work_phone': employee.workPhone,
      'work_email': employee.workEmail,
      'emergency_contact': employee.emergencyContact,
      'permissions': employee.permissions,
      'settings': employee.settings,
      'default_shift_start': employee.defaultShiftStart,
      'default_shift_end': employee.defaultShiftEnd,
      'working_days': employee.workingDays,
      'hourly_rate': employee.hourlyRate,
      'monthly_salary': employee.monthlySalary,
      'created_at': employee.createdAt.toIso8601String(),
      'updated_at': employee.updatedAt.toIso8601String(),
      'created_by': employee.createdBy,
      'last_modified_by': employee.lastModifiedBy,
    };
  }

  Map<String, dynamic> _sessionToSupabaseFormat(EmployeeSession session) {
    return {
      'id': session.id,
      'employee_id': session.employeeId,
      'session_token': session.sessionToken,
      'device_id': session.deviceId,
      'device_name': session.deviceName,
      'device_type': session.deviceType?.name,
      'app_type': session.appType?.name,
      'app_version': session.appVersion,
      'ip_address': session.ipAddress,
      'user_agent': session.userAgent,
      'started_at': session.startedAt.toIso8601String(),
      'last_activity_at': session.lastActivityAt.toIso8601String(),
      'expires_at': session.expiresAt?.toIso8601String(),
      'last_known_latitude': session.lastKnownLatitude,
      'last_known_longitude': session.lastKnownLongitude,
      'last_location_update': session.lastLocationUpdate?.toIso8601String(),
      'is_active': session.isActive,
      'ended_at': session.endedAt?.toIso8601String(),
      'end_reason': session.endReason?.name,
      'created_at': session.createdAt.toIso8601String(),
    };
  }
}
