import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isSignedIn => currentUser != null;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        phone: phone,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Network error: Please check your connection and try again.');
    }
  }

  Future<AuthResponse> register({
    required String phone,
    required String password,
    required String fullName,
    String? email,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        phone: phone,
        password: password,
        data: {
          'full_name': fullName,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Network error: Please check your connection and try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  String _handleAuthError(AuthException e) {
    // Debug: Print the actual error details (remove in production)
    // print('AuthException - Status: ${e.statusCode}, Message: ${e.message}');
    
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
        e.message.contains('password') && e.message.contains('6')) {
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