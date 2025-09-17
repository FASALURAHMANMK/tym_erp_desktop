import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/routing/route_names.dart';
import '../tym_waiter_app/main_waiter.dart' as waiter;
import '../tym_waiter_app/core/services/waiter_session_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkWaiterSession();
  }

  Future<void> _checkWaiterSession() async {
    // Check if there's an active waiter session
    final isWaiterAuthenticated = await WaiterSessionService.isWaiterAuthenticated();
    if (isWaiterAuthenticated && mounted) {
      // Set the flag before launching to prevent business check
      waiter.isInWaiterMode = true;
      // Auto-launch waiter app if waiter is authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        waiter.launchWaiterApp(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/tym_logo_transparent_background.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome to TYM ERP',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F766E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your comprehensive business management solution',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
                ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.signIn);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    context.go(AppRoutes.register);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF0F766E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'New to TYM ERP? Create an account to get started with managing your business operations.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // TEST BUTTON - Remove in production
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'TEST MODE - Employee Login',
                  style: TextStyle(
                    fontSize: 12, 
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    waiter.launchWaiterApp(context);
                  },
                  icon: const Icon(Icons.restaurant_menu, color: Colors.orange),
                  label: const Text(
                    'Test Waiter App',
                    style: TextStyle(color: Colors.orange),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    backgroundColor: Colors.orange.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}