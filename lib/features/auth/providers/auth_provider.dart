import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../models/user_model.dart';
import '../models/auth_state.dart';
import '../../business/providers/business_provider.dart';
import '../../../services/sync_service.dart';
import '../../../core/utils/logger.dart';
import '../../../tym_waiter_app/core/services/waiter_session_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final _logger = Logger('AuthNotifier');
  
  @override
  AppAuthState build() {
    // Initialize with current session if exists
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // Check businesses for existing session (but not for waiter sessions)
      _checkUserBusinessesIfNotWaiter();
      
      return AppAuthState(
        isAuthenticated: true,
        user: _userFromSupabaseUser(session.user),
      );
    }
    return const AppAuthState();
  }

  Future<void> signIn({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        phone: phone,
        password: password,
      );
      
      if (response.session != null && response.user != null) {
        state = AppAuthState(
          isAuthenticated: true,
          user: _userFromSupabaseUser(response.user!),
          isLoading: false,
        );
        
        // Check user's businesses after successful sign in (but not for waiter sessions)
        _checkUserBusinessesIfNotWaiter();
        
        // Trigger initial data download
        _downloadInitialData();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Sign in failed',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _handleAuthError(e),
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: Please check your connection and try again.',
      );
      rethrow;
    }
  }

  Future<void> register({
    required String phone,
    required String password,
    required String fullName,
    String? email,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await Supabase.instance.client.auth.signUp(
        phone: phone,
        password: password,
        data: {
          'full_name': fullName,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
      
      if (response.session != null && response.user != null) {
        state = AppAuthState(
          isAuthenticated: true,
          user: _userFromSupabaseUser(response.user!),
          isLoading: false,
        );
        
        // Check user's businesses after successful registration (but not for waiter sessions)
        _checkUserBusinessesIfNotWaiter();
        
        // Trigger initial data download
        _downloadInitialData();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Registration failed',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _handleAuthError(e),
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: Please check your connection and try again.',
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      // Clear business data BEFORE clearing auth state (while user is still available)
      await ref.read(businessNotifierProvider.notifier).clearBusinessData();
      
      await Supabase.instance.client.auth.signOut();
      state = const AppAuthState();
    } catch (e) {
      state = state.copyWith(error: 'Failed to sign out: ${e.toString()}');
      rethrow;
    }
  }

  /// Check user's businesses after successful authentication
  void _checkUserBusinesses() {
    // Use a small delay to ensure the auth state is fully updated
    Future.microtask(() {
      ref.read(businessNotifierProvider.notifier).checkUserBusinesses();
    });
  }
  
  /// Check user's businesses only if not a waiter session
  void _checkUserBusinessesIfNotWaiter() {
    // Check for waiter session asynchronously
    Future.microtask(() async {
      final hasWaiterSession = await WaiterSessionService.isWaiterAuthenticated();
      if (!hasWaiterSession) {
        ref.read(businessNotifierProvider.notifier).checkUserBusinesses();
      } else {
        _logger.info('Skipping business check in auth provider - waiter session active');
      }
    });
  }
  
  /// Download initial data after successful authentication
  void _downloadInitialData() {
    // Delay to ensure business is selected and UI is ready
    Future.delayed(const Duration(seconds: 1), () {
      try {
        final syncService = ref.read(syncServiceProvider);
        
        // Start the download
        syncService.downloadInitialData();
        
        // Note: The UI will handle showing progress via DataSeedingProgressDialog
        // when navigating to the main app screen
      } catch (e) {
        // Don't block login if download fails
        _logger.error('Initial data download failed', e);
      }
    });
  }

  UserModel _userFromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      phone: user.phone ?? '',
      fullName: user.userMetadata?['full_name'] ?? '',
      email: user.userMetadata?['email'],
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  String _handleAuthError(AuthException e) {
    // Handle specific error messages first, regardless of status code
    if (e.message.contains('Invalid login credentials')) {
      return 'Invalid phone number or password. Please check and try again.';
    }
    
    if (e.message.contains('Invalid phone number') || 
        e.message.contains('phone number format') ||
        e.message.contains('Invalid phone')) {
      return 'Please enter a valid phone number with country code (e.g., +1234567890)';
    }
    
    if (e.message.contains('Password should be at least 6 characters') ||
        (e.message.contains('password') && e.message.contains('6'))) {
      return 'Password must be at least 6 characters long.';
    }
    
    if (e.message.contains('User already registered')) {
      return 'An account with this phone number already exists.';
    }
    
    // Handle by status code as fallback
    switch (e.statusCode) {
      case '400':
        return 'Invalid request. Please check your phone number and password.';
      case '422':
        return 'Invalid input format. Please check your phone number includes country code.';
      case '429':
        return 'Too many attempts. Please wait a moment before trying again.';
      default:
        return e.message.isNotEmpty ? e.message : 'Authentication failed. Please try again.';
    }
  }
}

// Convenient providers for accessing auth state
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
}

@riverpod
UserModel? currentUser(Ref ref) {
  return ref.watch(authNotifierProvider).user;
}

@riverpod
bool isLoading(Ref ref) {
  return ref.watch(authNotifierProvider).isLoading;
}