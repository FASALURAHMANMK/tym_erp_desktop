import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../core/utils/logger.dart';
import '../models/employee.dart';
import '../models/employee_session.dart';
import '../models/role_template.dart';
import '../../../services/database_schema.dart';

class EmployeeLocalDatabase {
  static final _logger = Logger('EmployeeLocalDatabase');
  final Database database;

  EmployeeLocalDatabase({required this.database});

  // Initialize local tables
  static Future<void> initializeTables(Database database) async {
    try {
      await DatabaseSchema.applySqliteSchema(database);
      _logger.info('Employee tables ensured via bundled schema');
    } catch (e) {
      _logger.error('Failed to ensure employee tables', e);
      rethrow;
    }
  }

  // ==================== EMPLOYEE OPERATIONS ====================

  Future<void> saveEmployee(Employee employee) async {
    try {
      final data = _employeeToLocalFormat(employee);
      
      await database.insert(
        'employees',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.info('Employee saved locally: ${employee.employeeCode}');
    } catch (e) {
      _logger.error('Failed to save employee', e);
      rethrow;
    }
  }

  Future<Employee?> getEmployeeById(String id) async {
    try {
      final results = await database.query(
        'employees',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isEmpty) return null;
      
      return _employeeFromLocalFormat(results.first);
    } catch (e) {
      _logger.error('Failed to get employee by ID', e);
      rethrow;
    }
  }

  Future<Employee?> getEmployeeByUserId(String userId, String businessId) async {
    try {
      final results = await database.query(
        'employees',
        where: 'user_id = ? AND business_id = ?',
        whereArgs: [userId, businessId],
      );

      if (results.isEmpty) return null;
      
      return _employeeFromLocalFormat(results.first);
    } catch (e) {
      _logger.error('Failed to get employee by user ID', e);
      rethrow;
    }
  }

  Future<List<Employee>> getEmployeesForBusiness(
    String businessId, {
    String? status,
    String? role,
  }) async {
    try {
      String query = 'business_id = ?';
      List<dynamic> args = [businessId];

      if (status != null) {
        query += ' AND employment_status = ?';
        args.add(status);
      }

      if (role != null) {
        query += ' AND primary_role = ?';
        args.add(role);
      }

      final results = await database.query(
        'employees',
        where: query,
        whereArgs: args,
        orderBy: 'employee_code ASC',
      );

      return results.map((data) => _employeeFromLocalFormat(data)).toList();
    } catch (e) {
      _logger.error('Failed to get employees for business', e);
      rethrow;
    }
  }

  Future<int> getEmployeeCount(String businessId) async {
    try {
      final result = await database.rawQuery(
        'SELECT COUNT(*) as count FROM employees WHERE business_id = ?',
        [businessId],
      );
      
      return result.first['count'] as int? ?? 0;
    } catch (e) {
      _logger.error('Failed to get employee count', e);
      return 0;
    }
  }

  Future<String> generateEmployeeCode(String businessId) async {
    try {
      final count = await getEmployeeCount(businessId);
      return 'EMP${(count + 1).toString().padLeft(3, '0')}';
    } catch (e) {
      _logger.error('Failed to generate employee code', e);
      return 'EMP001';
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final data = _employeeToLocalFormat(employee);
      data['has_unsynced_changes'] = 1;
      data['updated_at'] = DateTime.now().toIso8601String();
      
      await database.update(
        'employees',
        data,
        where: 'id = ?',
        whereArgs: [employee.id],
      );
      
      _logger.info('Employee updated locally: ${employee.employeeCode}');
    } catch (e) {
      _logger.error('Failed to update employee', e);
      rethrow;
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await database.delete(
        'employees',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      _logger.info('Employee deleted locally: $id');
    } catch (e) {
      _logger.error('Failed to delete employee', e);
      rethrow;
    }
  }

  // ==================== SESSION OPERATIONS ====================

  Future<void> saveSession(EmployeeSession session) async {
    try {
      final data = _sessionToLocalFormat(session);
      
      await database.insert(
        'employee_sessions',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      _logger.info('Session saved locally: ${session.id}');
    } catch (e) {
      _logger.error('Failed to save session', e);
      rethrow;
    }
  }

  Future<List<EmployeeSession>> getActiveSessions(String employeeId) async {
    try {
      final results = await database.query(
        'employee_sessions',
        where: 'employee_id = ? AND is_active = 1',
        whereArgs: [employeeId],
        orderBy: 'started_at DESC',
      );

      return results.map((data) => _sessionFromLocalFormat(data)).toList();
    } catch (e) {
      _logger.error('Failed to get active sessions', e);
      return [];
    }
  }

  Future<void> endSession(String sessionId, SessionEndReason reason) async {
    try {
      await database.update(
        'employee_sessions',
        {
          'is_active': 0,
          'ended_at': DateTime.now().toIso8601String(),
          'end_reason': reason.name,
        },
        where: 'id = ?',
        whereArgs: [sessionId],
      );
      
      _logger.info('Session ended: $sessionId');
    } catch (e) {
      _logger.error('Failed to end session', e);
      rethrow;
    }
  }

  // ==================== ROLE TEMPLATE OPERATIONS ====================

  Future<void> saveRoleTemplates(List<RoleTemplate> templates) async {
    try {
      final batch = database.batch();
      
      for (final template in templates) {
        batch.insert(
          'role_templates',
          _roleTemplateToLocalFormat(template),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      
      await batch.commit(noResult: true);
      _logger.info('Role templates saved: ${templates.length}');
    } catch (e) {
      _logger.error('Failed to save role templates', e);
      rethrow;
    }
  }

  Future<List<RoleTemplate>> getRoleTemplates() async {
    try {
      final results = await database.query(
        'role_templates',
        orderBy: 'role_name ASC',
      );

      return results.map((data) => _roleTemplateFromLocalFormat(data)).toList();
    } catch (e) {
      _logger.error('Failed to get role templates', e);
      return [];
    }
  }

  // ==================== FORMAT CONVERSION ====================

  Map<String, dynamic> _employeeToLocalFormat(Employee employee) {
    return {
      'id': employee.id,
      'user_id': employee.userId,
      'business_id': employee.businessId,
      'employee_code': employee.employeeCode,
      'display_name': employee.displayName,
      'primary_role': employee.primaryRole.name,
      'assigned_locations': employee.assignedLocations.join(','),
      'can_access_all_locations': employee.canAccessAllLocations ? 1 : 0,
      'employment_status': employee.employmentStatus.name,
      'joined_at': employee.joinedAt.toIso8601String(),
      'terminated_at': employee.terminatedAt?.toIso8601String(),
      'termination_reason': employee.terminationReason,
      'work_phone': employee.workPhone,
      'work_email': employee.workEmail,
      'emergency_contact': employee.emergencyContact.isNotEmpty 
          ? jsonEncode(employee.emergencyContact) : null,
      'permissions': employee.permissions.isNotEmpty 
          ? jsonEncode(employee.permissions) : null,
      'settings': employee.settings.isNotEmpty 
          ? jsonEncode(employee.settings) : null,
      'default_shift_start': employee.defaultShiftStart,
      'default_shift_end': employee.defaultShiftEnd,
      'working_days': employee.workingDays.join(','),
      'hourly_rate': employee.hourlyRate,
      'monthly_salary': employee.monthlySalary,
      'created_at': employee.createdAt.toIso8601String(),
      'updated_at': employee.updatedAt.toIso8601String(),
      'created_by': employee.createdBy,
      'last_modified_by': employee.lastModifiedBy,
      'has_unsynced_changes': employee.hasUnsyncedChanges ? 1 : 0,
      'last_synced_at': employee.lastSyncedAt?.toIso8601String(),
    };
  }

  Employee _employeeFromLocalFormat(Map<String, dynamic> data) {
    return Employee(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      businessId: data['business_id'] as String,
      employeeCode: data['employee_code'] as String,
      displayName: data['display_name'] as String?,
      primaryRole: EmployeeRole.values.firstWhere(
        (r) => r.name == data['primary_role'],
      ),
      assignedLocations: data['assigned_locations'] != null && 
          (data['assigned_locations'] as String).isNotEmpty
          ? (data['assigned_locations'] as String).split(',')
          : [],
      canAccessAllLocations: data['can_access_all_locations'] == 1,
      employmentStatus: EmploymentStatus.values.firstWhere(
        (s) => s.name == data['employment_status'],
      ),
      joinedAt: DateTime.parse(data['joined_at'] as String),
      terminatedAt: data['terminated_at'] != null
          ? DateTime.parse(data['terminated_at'] as String)
          : null,
      terminationReason: data['termination_reason'] as String?,
      workPhone: data['work_phone'] as String?,
      workEmail: data['work_email'] as String?,
      emergencyContact: data['emergency_contact'] != null
          ? Map<String, dynamic>.from(jsonDecode(data['emergency_contact'] as String))
          : {},
      permissions: data['permissions'] != null
          ? Map<String, dynamic>.from(jsonDecode(data['permissions'] as String))
          : {},
      settings: data['settings'] != null
          ? Map<String, dynamic>.from(jsonDecode(data['settings'] as String))
          : {},
      defaultShiftStart: data['default_shift_start'] as String?,
      defaultShiftEnd: data['default_shift_end'] as String?,
      workingDays: data['working_days'] != null && 
          (data['working_days'] as String).isNotEmpty
          ? (data['working_days'] as String).split(',').map(int.parse).toList()
          : [1, 2, 3, 4, 5],
      hourlyRate: data['hourly_rate'] as double?,
      monthlySalary: data['monthly_salary'] as double?,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
      createdBy: data['created_by'] as String?,
      lastModifiedBy: data['last_modified_by'] as String?,
      hasUnsyncedChanges: data['has_unsynced_changes'] == 1,
      lastSyncedAt: data['last_synced_at'] != null
          ? DateTime.parse(data['last_synced_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> _sessionToLocalFormat(EmployeeSession session) {
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
      'is_active': session.isActive ? 1 : 0,
      'ended_at': session.endedAt?.toIso8601String(),
      'end_reason': session.endReason?.name,
      'created_at': session.createdAt.toIso8601String(),
    };
  }

  EmployeeSession _sessionFromLocalFormat(Map<String, dynamic> data) {
    return EmployeeSession(
      id: data['id'] as String,
      employeeId: data['employee_id'] as String,
      sessionToken: data['session_token'] as String,
      deviceId: data['device_id'] as String,
      deviceName: data['device_name'] as String?,
      deviceType: data['device_type'] != null
          ? DeviceType.values.firstWhere((t) => t.name == data['device_type'])
          : null,
      appType: data['app_type'] != null
          ? AppType.values.firstWhere((t) => t.name == data['app_type'])
          : null,
      appVersion: data['app_version'] as String?,
      ipAddress: data['ip_address'] as String?,
      userAgent: data['user_agent'] as String?,
      startedAt: DateTime.parse(data['started_at'] as String),
      lastActivityAt: DateTime.parse(data['last_activity_at'] as String),
      expiresAt: data['expires_at'] != null
          ? DateTime.parse(data['expires_at'] as String)
          : null,
      lastKnownLatitude: data['last_known_latitude'] as double?,
      lastKnownLongitude: data['last_known_longitude'] as double?,
      lastLocationUpdate: data['last_location_update'] != null
          ? DateTime.parse(data['last_location_update'] as String)
          : null,
      isActive: data['is_active'] == 1,
      endedAt: data['ended_at'] != null
          ? DateTime.parse(data['ended_at'] as String)
          : null,
      endReason: data['end_reason'] != null
          ? SessionEndReason.values.firstWhere((r) => r.name == data['end_reason'])
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> _roleTemplateToLocalFormat(RoleTemplate template) {
    return {
      'id': template.id,
      'role_code': template.roleCode,
      'role_name': template.roleName,
      'permissions': jsonEncode(template.permissions),
      'description': template.description,
      'is_system_role': template.isSystemRole ? 1 : 0,
      'created_at': template.createdAt.toIso8601String(),
    };
  }

  RoleTemplate _roleTemplateFromLocalFormat(Map<String, dynamic> data) {
    return RoleTemplate(
      id: data['id'] as String,
      roleCode: data['role_code'] as String,
      roleName: data['role_name'] as String,
      permissions: Map<String, dynamic>.from(jsonDecode(data['permissions'] as String)),
      description: data['description'] as String?,
      isSystemRole: data['is_system_role'] == 1,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
