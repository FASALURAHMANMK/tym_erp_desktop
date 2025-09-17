import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/waiter_constants.dart';
import '../../../core/utils/waiter_helpers.dart';
import '../providers/waiter_auth_provider.dart';

/// Mobile-optimized waiter login screen
class WaiterLoginScreen extends ConsumerStatefulWidget {
  const WaiterLoginScreen({super.key});

  @override
  ConsumerState<WaiterLoginScreen> createState() => _WaiterLoginScreenState();
}

class _WaiterLoginScreenState extends ConsumerState<WaiterLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Use waiter-specific authentication
    await ref.read(waiterAuthStateProvider.notifier).signInWithPhone(
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      
      // Check authentication result
      final authState = ref.read(waiterAuthStateProvider);
      authState.when(
        data: (employee) {
          if (employee != null) {
            WaiterHelpers.showSuccessSnackbar(
              context, 
              'Welcome! Starting your shift...',
            );
            // Router will automatically redirect to dashboard via redirect logic
          }
        },
        loading: () {
          // Still loading
        },
        error: (error, stackTrace) {
          setState(() => _errorMessage = error.toString());
          WaiterHelpers.showErrorSnackbar(context, error.toString());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = WaiterHelpers.isTablet(context);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: WaiterHelpers.getResponsivePadding(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : screenSize.width * 0.9,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and app name
                    _buildHeader(theme),
                    
                    SizedBox(height: screenSize.height * 0.05),
                    
                    // Error message
                    if (_errorMessage != null) ...[
                      _buildErrorContainer(theme),
                      const SizedBox(height: 20),
                    ],
                    
                    // Phone number field
                    _buildPhoneField(),
                    
                    const SizedBox(height: 20),
                    
                    // Password field
                    _buildPasswordField(),
                    
                    const SizedBox(height: 30),
                    
                    // Sign in button
                    _buildSignInButton(),
                    
                    const SizedBox(height: 20),
                    
                    // Forgot password
                    _buildForgotPassword(),
                    
                    const SizedBox(height: 40),
                    
                    // Info container
                    _buildInfoContainer(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        // App icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant_menu,
            size: 50,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // App name
        Text(
          WaiterConstants.appName,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtitle
        Text(
          'Start your shift with a quick sign-in',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorContainer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: const TextStyle(fontSize: 16),
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        hintText: '+1234567890',
        prefixIcon: Icon(Icons.phone, size: 24),
      ),
      validator: (value) {
        if (WaiterHelpers.isNullOrEmpty(value)) {
          return 'Please enter your phone number';
        }
        if (!value!.startsWith('+')) {
          return 'Include country code (e.g., +1234567890)';
        }
        if (!WaiterHelpers.isValidPhoneNumber(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock, size: 24),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (WaiterHelpers.isNullOrEmpty(value)) {
          return 'Please enter your password';
        }
        if (value!.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSignInButton() {
    return FilledButton(
      onPressed: _isLoading ? null : _signIn,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(
              'Start Shift',
              style: TextStyle(
                fontSize: WaiterHelpers.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () {
        WaiterHelpers.showInfoSnackbar(
          context,
          'Contact your manager for password reset',
        );
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildInfoContainer(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Use the phone number and password provided by your manager. Contact support if you need assistance.',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onPrimaryContainer,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

