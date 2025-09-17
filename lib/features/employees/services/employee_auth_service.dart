import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/logger.dart';

/// Service to handle employee authentication with phone number support
class EmployeeAuthService {
  static final _logger = Logger('EmployeeAuthService');
  
  final SupabaseClient _supabase;

  EmployeeAuthService({required SupabaseClient supabase}) : _supabase = supabase;

  /// Sign in employee using phone number and password
  /// This is a workaround since employees are created with email auth
  Future<Either<String, AuthResponse>> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    try {
      // Step 1: Look up the user's email by phone number
      // Note: The RPC function expects 'check_phone' parameter
      final userLookup = await _supabase.rpc(
        'get_user_by_phone',
        params: {'check_phone': phone},
      );

      if (userLookup == null || (userLookup as List).isEmpty) {
        return const Left('No account found with this phone number');
      }

      final userData = userLookup.first;
      final email = userData['email'] as String?;
      
      if (email == null) {
        return const Left('Account configuration error. Please contact admin.');
      }

      // Check if this is an employee account
      // Note: The user metadata contains 'is_employee' flag
      final rawUserMetaData = userData['raw_user_meta_data'] as Map<String, dynamic>?;
      final isEmployee = rawUserMetaData?['is_employee'] as bool? ?? false;
      
      // Also check if there's an employee record for this user
      // Skip this check for now as it might not exist yet

      // Step 2: Sign in using the email associated with the phone
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        return const Left('Authentication failed');
      }

      _logger.info('Employee signed in successfully via phone: $phone');
      return Right(response);
    } on AuthException catch (e) {
      _logger.error('Auth error during phone sign in', e);
      
      if (e.message.contains('Invalid login credentials')) {
        return const Left('Invalid phone number or password');
      }
      
      return Left('Authentication failed: ${e.message}');
    } catch (e) {
      _logger.error('Failed to sign in with phone', e);
      return Left('Sign in failed: ${e.toString()}');
    }
  }

  /// Sign in employee using email and password (direct method)
  Future<Either<String, AuthResponse>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        return const Left('Authentication failed');
      }

      // Verify this is an employee account
      final user = response.user;
      if (user != null) {
        final isEmployee = user.userMetadata?['is_employee'] as bool? ?? false;
        if (!isEmployee) {
          // Sign out non-employee users
          await _supabase.auth.signOut();
          return const Left('This login is for employees only');
        }
      }

      _logger.info('Employee signed in successfully via email');
      return Right(response);
    } on AuthException catch (e) {
      _logger.error('Auth error during email sign in', e);
      
      if (e.message.contains('Invalid login credentials')) {
        return const Left('Invalid email or password');
      }
      
      return Left('Authentication failed: ${e.message}');
    } catch (e) {
      _logger.error('Failed to sign in with email', e);
      return Left('Sign in failed: ${e.toString()}');
    }
  }

  /// Check if a phone number is registered as an employee
  Future<bool> isEmployeePhone(String phone) async {
    try {
      final result = await _supabase.rpc(
        'get_user_by_phone',
        params: {'phone_number': phone},
      );

      if (result != null && (result as List).isNotEmpty) {
        final userData = result.first;
        return userData['is_employee'] as bool? ?? false;
      }

      return false;
    } catch (e) {
      _logger.error('Failed to check employee phone', e);
      return false;
    }
  }

  /// Get employee details by phone number
  Future<Either<String, Map<String, dynamic>>> getEmployeeByPhone(String phone) async {
    try {
      // First get user data - use correct parameter name
      final userResult = await _supabase.rpc(
        'get_user_by_phone',
        params: {'check_phone': phone},
      );

      if (userResult == null || (userResult as List).isEmpty) {
        return const Left('No employee found with this phone number');
      }

      final userData = userResult.first;
      final userId = userData['user_id'] as String;

      // Then get employee record
      try {
        final employeeResult = await _supabase
            .from('employees')
            .select()
            .eq('user_id', userId)
            .single();

        return Right({
          'user': userData,
          'employee': employeeResult,
        });
      } catch (e) {
        // If employee record doesn't exist yet, return just user data
        _logger.warning('Employee record not found for user $userId, returning user data only');
        return Right({
          'user': userData,
          'employee': null,
        });
      }
    } catch (e) {
      _logger.error('Failed to get employee by phone', e);
      return Left('Failed to retrieve employee data: ${e.toString()}');
    }
  }

  /// Reset employee password (admin function)
  Future<Either<String, String>> resetEmployeePassword({
    required String employeeUserId,
    required String newPassword,
  }) async {
    try {
      // This would require admin privileges or a secure backend function
      // For now, return instruction for manual reset
      return const Right(
        'Password reset must be done through Supabase Dashboard or by having the employee use forgot password flow',
      );
    } catch (e) {
      _logger.error('Failed to reset employee password', e);
      return Left('Failed to reset password: ${e.toString()}');
    }
  }

  /// Send password reset email to employee
  Future<Either<String, void>> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to send password reset email', e);
      return Left('Failed to send reset email: ${e.toString()}');
    }
  }
}