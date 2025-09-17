import 'package:flutter/material.dart';

import 'waiter_app.dart';
import 'core/services/waiter_session_service.dart';

/// Global flag to indicate if we're in waiter mode
/// This helps prevent main app logic from interfering
bool isInWaiterMode = false;

/// Dedicated entry point for waiter app
/// This launches the waiter app as a separate app experience
/// Note: Does NOT create a new ProviderScope - uses the existing one from main.dart
class WaiterAppLauncher extends StatefulWidget {
  const WaiterAppLauncher({super.key});

  @override
  State<WaiterAppLauncher> createState() => _WaiterAppLauncherState();
}

class _WaiterAppLauncherState extends State<WaiterAppLauncher> {
  @override
  void initState() {
    super.initState();
    // Set global flag to indicate we're in waiter mode
    isInWaiterMode = true;
  }

  @override
  void dispose() {
    // Clear flag when exiting waiter mode
    isInWaiterMode = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't create a new ProviderScope here - use the existing one
    // This allows the waiter app to maintain its own authentication state
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Handle back button - clear waiter session if needed
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit Waiter App?'),
              content: const Text('Do you want to exit the waiter app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
          
          if (shouldPop == true && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: const WaiterApp(),
    );
  }
}

/// Function to launch waiter app in a new context
/// This helps isolate waiter app from main app routing and state
Future<void> launchWaiterApp(BuildContext context) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const WaiterAppLauncher(),
      settings: const RouteSettings(name: '/waiter-app'),
      fullscreenDialog: true, // Makes it feel like a separate app
    ),
  );
  
  // Reset flag when returning from waiter app
  isInWaiterMode = false;
}

/// Check if there's an active waiter session
Future<bool> hasActiveWaiterSession() async {
  return await WaiterSessionService.isWaiterAuthenticated();
}