import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../features/employees/services/employee_auth_service.dart';
import '../../../../features/employees/models/employee.dart';
import '../../../core/services/waiter_session_service.dart';

/// Provider for waiter authentication state
final waiterAuthStateProvider = StateNotifierProvider<WaiterAuthNotifier, AsyncValue<Employee?>>((ref) {
  return WaiterAuthNotifier(ref);
});

/// Provider to check if waiter is authenticated
final isWaiterAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(waiterAuthStateProvider);
  final isAuth = authState.maybeWhen(
    data: (employee) => employee != null,
    orElse: () => false,
  );
  debugPrint('WaiterAuth: isAuthenticated=$isAuth');
  return isAuth;
});

/// Provider for current waiter employee
final currentWaiterProvider = Provider<Employee?>((ref) {
  final authState = ref.watch(waiterAuthStateProvider);
  return authState.maybeWhen(
    data: (employee) => employee,
    orElse: () => null,
  );
});

/// Waiter authentication state notifier
class WaiterAuthNotifier extends StateNotifier<AsyncValue<Employee?>> {
  late final EmployeeAuthService _authService;
  late final SupabaseClient _supabase;

  WaiterAuthNotifier(Ref ref) : super(const AsyncValue.loading()) {
    _supabase = Supabase.instance.client;
    _authService = EmployeeAuthService(supabase: _supabase);
    _initializeAuth();
  }

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      debugPrint('WaiterAuth: Initializing authentication state...');
      
      // Check if waiter is authenticated
      final isAuthenticated = await WaiterSessionService.isWaiterAuthenticated();
      debugPrint('WaiterAuth: Is authenticated from saved session: $isAuthenticated');
      
      if (isAuthenticated) {
        // Load saved employee data
        final employeeData = await WaiterSessionService.getEmployeeData();
        debugPrint('WaiterAuth: Loaded employee data: $employeeData');
        
        if (employeeData != null && employeeData['id'] != null) {
          // Create employee from saved data with proper parsing
          final employee = Employee(
            id: employeeData['id'] ?? '',
            userId: employeeData['userId'] ?? '',
            businessId: employeeData['businessId'] ?? '',
            employeeCode: employeeData['employeeCode'] ?? '',
            displayName: employeeData['displayName'] ?? 'Waiter',
            primaryRole: _parseEmployeeRole(employeeData['primaryRole']),
            joinedAt: employeeData['joinedAt'] != null 
              ? DateTime.tryParse(employeeData['joinedAt']) ?? DateTime.now()
              : DateTime.now(),
            createdAt: employeeData['createdAt'] != null
              ? DateTime.tryParse(employeeData['createdAt']) ?? DateTime.now()
              : DateTime.now(),
            updatedAt: employeeData['updatedAt'] != null
              ? DateTime.tryParse(employeeData['updatedAt']) ?? DateTime.now()
              : DateTime.now(),
          );
          state = AsyncValue.data(employee);
          debugPrint('WaiterAuth: Restored session for employee: ${employee.displayName} (${employee.employeeCode})');
        } else {
          // Invalid saved data, clear session
          debugPrint('WaiterAuth: Invalid saved employee data, clearing session');
          await WaiterSessionService.clearWaiterSession();
          state = const AsyncValue.data(null);
        }
      } else {
        debugPrint('WaiterAuth: No saved session found');
        state = const AsyncValue.data(null);
      }
    } catch (e, stackTrace) {
      debugPrint('WaiterAuth: Error initializing auth: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Sign in with phone and password
  Future<void> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final result = await _authService.signInWithPhone(
        phone: phone,
        password: password,
      );
      
      await result.fold(
        (error) async {
          state = AsyncValue.error(error, StackTrace.current);
        },
        (authResponse) async {
          // Get employee details after successful authentication
          final employeeResult = await _authService.getEmployeeByPhone(phone);
          employeeResult.fold(
            (error) => state = AsyncValue.error(error, StackTrace.current),
            (data) async {
              // Parse the actual employee data
              final employeeData = data['employee'] as Map<String, dynamic>?;
              final userData = data['user'] as Map<String, dynamic>?;
              
              if (employeeData != null) {
                // Use real employee data
                final employee = Employee(
                  id: employeeData['id'] ?? '',
                  userId: employeeData['user_id'] ?? userData?['user_id'] ?? '',
                  businessId: employeeData['business_id'] ?? '',
                  employeeCode: employeeData['employee_code'] ?? '',
                  displayName: employeeData['display_name'] ?? userData?['raw_user_meta_data']?['full_name'] ?? 'Waiter',
                  primaryRole: _parseEmployeeRole(employeeData['primary_role']),
                  joinedAt: employeeData['joined_at'] != null 
                    ? DateTime.parse(employeeData['joined_at']) 
                    : DateTime.now(),
                  createdAt: employeeData['created_at'] != null
                    ? DateTime.parse(employeeData['created_at'])
                    : DateTime.now(),
                  updatedAt: employeeData['updated_at'] != null
                    ? DateTime.parse(employeeData['updated_at'])
                    : DateTime.now(),
                );
                
                // Save session data with real employee info
                // For now, use the first available location or default location
                // In a real app, this might be configured per employee
                await WaiterSessionService.saveWaiterSession(
                  employeeId: employee.id,
                  businessId: employee.businessId,
                  locationId: 'default-location', // Will be determined by location provider
                  shiftStartTime: DateTime.now(),
                );
                
                // Save employee data with all fields for proper restoration
                await WaiterSessionService.saveEmployeeData({
                  'id': employee.id,
                  'userId': employee.userId,
                  'businessId': employee.businessId,
                  'employeeCode': employee.employeeCode,
                  'displayName': employee.displayName,
                  'primaryRole': employee.primaryRole.name,
                  'joinedAt': employee.joinedAt.toIso8601String(),
                  'createdAt': employee.createdAt.toIso8601String(),
                  'updatedAt': employee.updatedAt.toIso8601String(),
                });
                
                state = AsyncValue.data(employee);
                debugPrint('WaiterAuth: Login successful, employee: ${employee.displayName} (${employee.employeeCode})');
              } else {
                // No employee record found - this shouldn't happen
                state = const AsyncValue.error(
                  'Employee record not found. Please contact your administrator.',
                  StackTrace.empty,
                );
              }
            },
          );
        },
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await WaiterSessionService.clearWaiterSession();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Refresh current employee data
  Future<void> refresh() async {
    if (state.value != null) {
      try {
        // For now, just return the current mock data
        // In real app, would refresh from database
        state = AsyncValue.data(state.value);
      } catch (e, stackTrace) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }
  
  /// Helper method to parse employee role from string
  EmployeeRole _parseEmployeeRole(dynamic roleStr) {
    if (roleStr == null) return EmployeeRole.waiter;
    
    final role = roleStr.toString().toLowerCase();
    switch (role) {
      case 'owner':
        return EmployeeRole.owner;
      case 'manager':
        return EmployeeRole.manager;
      case 'cashier':
        return EmployeeRole.cashier;
      case 'waiter':
        return EmployeeRole.waiter;
      case 'kitchen_staff':
      case 'kitchenstaff':
        return EmployeeRole.kitchenStaff;
      case 'delivery':
        return EmployeeRole.delivery;
      case 'accountant':
        return EmployeeRole.accountant;
      default:
        return EmployeeRole.waiter;
    }
  }
}

/// Provider for waiter session management
final waiterSessionProvider = StateNotifierProvider<WaiterSessionNotifier, WaiterSession?>((ref) {
  return WaiterSessionNotifier(ref);
});

/// Waiter session data
class WaiterSession {
  final String employeeId;
  final String businessId;
  final String locationId;
  final DateTime shiftStartTime;
  final DateTime? shiftEndTime;
  final Map<String, dynamic> sessionData;

  const WaiterSession({
    required this.employeeId,
    required this.businessId,
    required this.locationId,
    required this.shiftStartTime,
    this.shiftEndTime,
    this.sessionData = const {},
  });

  WaiterSession copyWith({
    String? employeeId,
    String? businessId,
    String? locationId,
    DateTime? shiftStartTime,
    DateTime? shiftEndTime,
    Map<String, dynamic>? sessionData,
  }) {
    return WaiterSession(
      employeeId: employeeId ?? this.employeeId,
      businessId: businessId ?? this.businessId,
      locationId: locationId ?? this.locationId,
      shiftStartTime: shiftStartTime ?? this.shiftStartTime,
      shiftEndTime: shiftEndTime ?? this.shiftEndTime,
      sessionData: sessionData ?? this.sessionData,
    );
  }

  Duration get shiftDuration {
    final endTime = shiftEndTime ?? DateTime.now();
    return endTime.difference(shiftStartTime);
  }

  bool get isActive => shiftEndTime == null;
}

/// Waiter session notifier for shift management
class WaiterSessionNotifier extends StateNotifier<WaiterSession?> {

  WaiterSessionNotifier(Ref ref) : super(null);

  /// Start a new shift
  void startShift({
    required String employeeId,
    required String businessId,
    required String locationId,
  }) {
    state = WaiterSession(
      employeeId: employeeId,
      businessId: businessId,
      locationId: locationId,
      shiftStartTime: DateTime.now(),
    );
  }

  /// End current shift
  void endShift() {
    if (state != null) {
      state = state!.copyWith(shiftEndTime: DateTime.now());
    }
  }

  /// Update session data
  void updateSessionData(Map<String, dynamic> data) {
    if (state != null) {
      final currentData = Map<String, dynamic>.from(state!.sessionData);
      currentData.addAll(data);
      state = state!.copyWith(sessionData: currentData);
    }
  }

  /// Clear session
  void clearSession() {
    state = null;
  }
}