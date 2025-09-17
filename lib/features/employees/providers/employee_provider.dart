import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../services/local_database_service.dart';
import '../../../services/sync_queue_service.dart';
import '../../business/providers/business_provider.dart';
import '../models/employee.dart';
import '../models/employee_session.dart';
import '../models/role_template.dart';
import '../repositories/employee_repository.dart';
import '../services/employee_service.dart';

part 'employee_provider.g.dart';

// ==================== REPOSITORY & SERVICE PROVIDERS ====================

@riverpod
EmployeeRepository employeeRepository(Ref ref) {
  throw UnimplementedError('Employee repository must be initialized first');
}

// Initialize employee repository
Future<EmployeeRepository> initializeEmployeeRepository() async {
  final localDb = LocalDatabaseService();
  final database = await localDb.database;
  final supabase = Supabase.instance.client;
  final syncQueueService = SyncQueueService();

  final repository = EmployeeRepository(
    localDatabase: database,
    supabase: supabase,
    syncQueueService: syncQueueService,
  );
  
  // Initialize tables
  await repository.initializeLocalTables();
  
  return repository;
}

// Provider to hold the initialized repository
@riverpod
Future<EmployeeRepository> employeeRepositoryAsync(Ref ref) async {
  return await initializeEmployeeRepository();
}

@riverpod
Future<EmployeeService> employeeService(Ref ref) async {
  final repository = await ref.watch(employeeRepositoryAsyncProvider.future);
  final supabase = Supabase.instance.client;

  return EmployeeService(repository: repository, supabase: supabase);
}

// ==================== EMPLOYEE LIST PROVIDER ====================

@riverpod
class EmployeesNotifier extends _$EmployeesNotifier {
  static final _logger = Logger('EmployeesNotifier');

  @override
  Future<List<Employee>> build() async {
    // Get selected business
    final business = ref.watch(selectedBusinessProvider);
    if (business == null) {
      return [];
    }

    // Initialize default data
    final service = await ref.watch(employeeServiceProvider.future);
    await service.initializeDefaultData();

    // Load employees for the business
    return _loadEmployees(business.id);
  }

  Future<List<Employee>> _loadEmployees(String businessId) async {
    try {
      final repository = await ref.read(employeeRepositoryAsyncProvider.future);
      final result = await repository.getEmployeesForBusiness(businessId);

      return result.fold((error) {
        _logger.error('Failed to load employees', error);
        return [];
      }, (employees) => employees);
    } catch (e) {
      _logger.error('Failed to load employees', e);
      return [];
    }
  }

  Future<void> refresh() async {
    final business = ref.read(selectedBusinessProvider);
    if (business == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadEmployees(business.id));
  }

  Future<bool> createEmployee({
    required String phone,
    required String fullName,
    required EmployeeRole role,
    List<String>? locationIds,
    String? email,
    String? temporaryPassword,
  }) async {
    try {
      final business = ref.read(selectedBusinessProvider);
      if (business == null) {
        _logger.error('No business selected');
        return false;
      }

      final service = await ref.read(employeeServiceProvider.future);
      final result = await service.createEmployee(
        phone: phone,
        fullName: fullName,
        businessId: business.id,
        role: role,
        locationIds: locationIds,
        email: email,
        temporaryPassword: temporaryPassword,
      );

      return result.fold(
        (error) {
          _logger.error('Failed to create employee', error);
          return false;
        },
        (employee) {
          // Refresh the list
          refresh();
          return true;
        },
      );
    } catch (e) {
      _logger.error('Failed to create employee', e);
      return false;
    }
  }

  Future<bool> updateEmployee(Employee employee) async {
    try {
      final service = await ref.read(employeeServiceProvider.future);
      final result = await service.updateEmployee(employee);

      return result.fold(
        (error) {
          _logger.error('Failed to update employee', error);
          return false;
        },
        (_) {
          refresh();
          return true;
        },
      );
    } catch (e) {
      _logger.error('Failed to update employee', e);
      return false;
    }
  }

  Future<bool> updateEmployeeStatus({
    required String employeeId,
    required EmploymentStatus newStatus,
    String? reason,
  }) async {
    try {
      final service = await ref.read(employeeServiceProvider.future);
      final result = await service.updateEmployeeStatus(
        employeeId: employeeId,
        newStatus: newStatus,
        reason: reason,
      );

      return result.fold(
        (error) {
          _logger.error('Failed to update employee status', error);
          return false;
        },
        (_) {
          refresh();
          return true;
        },
      );
    } catch (e) {
      _logger.error('Failed to update employee status', e);
      return false;
    }
  }

  Future<bool> deleteEmployee(String employeeId) async {
    try {
      final service = await ref.read(employeeServiceProvider.future);
      final result = await service.deleteEmployee(employeeId);

      return result.fold(
        (error) {
          _logger.error('Failed to delete employee', error);
          return false;
        },
        (_) {
          refresh();
          return true;
        },
      );
    } catch (e) {
      _logger.error('Failed to delete employee', e);
      return false;
    }
  }
}

// ==================== FILTERED EMPLOYEES PROVIDER ====================

@riverpod
List<Employee> filteredEmployees(
  Ref ref, {
  String? searchQuery,
  EmployeeRole? role,
  EmploymentStatus? status,
}) {
  final employeesAsync = ref.watch(employeesNotifierProvider);

  return employeesAsync.when(
    data: (employees) {
      var filtered = employees;

      // Apply search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        filtered =
            filtered.where((emp) {
              return emp.displayName?.toLowerCase().contains(query) == true ||
                  emp.employeeCode.toLowerCase().contains(query) ||
                  emp.workPhone?.contains(query) == true ||
                  emp.workEmail?.toLowerCase().contains(query) == true;
            }).toList();
      }

      // Apply role filter
      if (role != null) {
        filtered = filtered.where((emp) => emp.primaryRole == role).toList();
      }

      // Apply status filter
      if (status != null) {
        filtered =
            filtered.where((emp) => emp.employmentStatus == status).toList();
      }

      // Sort by employee code
      filtered.sort((a, b) => a.employeeCode.compareTo(b.employeeCode));

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// ==================== ROLE TEMPLATES PROVIDER ====================

@riverpod
Future<List<RoleTemplate>> roleTemplates(Ref ref) async {
  try {
    final repository = await ref.watch(employeeRepositoryAsyncProvider.future);
    final result = await repository.getRoleTemplates();

    return result.fold((error) {
      Logger(
        'RoleTemplatesProvider',
      ).error('Failed to load role templates', error);
      return [];
    }, (templates) => templates);
  } catch (e) {
    Logger('RoleTemplatesProvider').error('Failed to load role templates', e);
    return [];
  }
}

// ==================== EMPLOYEE SESSION PROVIDERS ====================

@riverpod
class EmployeeSessionNotifier extends _$EmployeeSessionNotifier {
  static final _logger = Logger('EmployeeSessionNotifier');

  @override
  EmployeeSession? build() {
    // Return current session if exists
    return null;
  }

  Future<bool> createSession({
    required String employeeId,
    required String deviceId,
    required AppType appType,
    String? deviceName,
    DeviceType? deviceType,
  }) async {
    try {
      final service = await ref.read(employeeServiceProvider.future);
      final result = await service.createEmployeeSession(
        employeeId: employeeId,
        deviceId: deviceId,
        appType: appType,
        deviceName: deviceName,
        deviceType: deviceType,
      );

      return result.fold(
        (error) {
          _logger.error('Failed to create session', error);
          return false;
        },
        (session) {
          state = session;
          return true;
        },
      );
    } catch (e) {
      _logger.error('Failed to create session', e);
      return false;
    }
  }

  Future<void> endSession() async {
    if (state == null) return;

    try {
      final service = await ref.read(employeeServiceProvider.future);
      await service.endSession(state!.id, reason: SessionEndReason.logout);

      state = null;
    } catch (e) {
      _logger.error('Failed to end session', e);
    }
  }

  Future<bool> validateSession() async {
    if (state == null) return false;

    try {
      final service = await ref.read(employeeServiceProvider.future);
      final isValid = await service.validateSession(state!.id);

      if (!isValid) {
        state = null;
      }

      return isValid;
    } catch (e) {
      _logger.error('Failed to validate session', e);
      return false;
    }
  }
}

// ==================== EMPLOYEE STATS PROVIDER ====================

@riverpod
Map<String, dynamic> employeeStats(Ref ref) {
  final employeesAsync = ref.watch(employeesNotifierProvider);

  return employeesAsync.when(
    data: (employees) {
      final activeCount = employees.where((e) => e.isActive).length;
      final inactiveCount = employees.where((e) => !e.isActive).length;

      final roleDistribution = <EmployeeRole, int>{};
      for (final employee in employees) {
        roleDistribution[employee.primaryRole] =
            (roleDistribution[employee.primaryRole] ?? 0) + 1;
      }

      return {
        'total': employees.length,
        'active': activeCount,
        'inactive': inactiveCount,
        'roleDistribution': roleDistribution,
      };
    },
    loading:
        () => {'total': 0, 'active': 0, 'inactive': 0, 'roleDistribution': {}},
    error:
        (_, __) => {
          'total': 0,
          'active': 0,
          'inactive': 0,
          'roleDistribution': {},
        },
  );
}

// ==================== CURRENT EMPLOYEE PROVIDER ====================

@riverpod
Employee? currentEmployee(Ref ref) {
  // Get current user
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;

  // Get selected business
  final business = ref.watch(selectedBusinessProvider);
  if (business == null) return null;

  // Find employee record for current user in selected business
  final employeesAsync = ref.watch(employeesNotifierProvider);

  return employeesAsync.when(
    data: (employees) {
      try {
        return employees.firstWhere(
          (emp) => emp.userId == user.id && emp.businessId == business.id,
        );
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
}

// ==================== PERMISSION CHECK PROVIDER ====================

@riverpod
Future<bool> hasPermission(Ref ref, String permission) async {
  final employee = ref.watch(currentEmployeeProvider);
  if (employee == null) return false;

  return employee.hasPermission(permission);
}
