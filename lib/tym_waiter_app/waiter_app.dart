import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/waiter_theme.dart';
import 'navigation/waiter_router.dart';

/// Main waiter application widget
/// This is the entry point for the mobile waiter interface
class WaiterApp extends ConsumerWidget {
  const WaiterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(waiterRouterProvider);

    return MaterialApp.router(
      title: 'TYM Waiter',
      debugShowCheckedModeBanner: false,
      
      // Use mobile-optimized theme
      theme: WaiterTheme.lightTheme,
      darkTheme: WaiterTheme.darkTheme,
      themeMode: ThemeMode.system, // Follow system theme
      
      // Waiter-specific routing
      routerConfig: router,
    );
  }
}

/// Platform and context detection service
class PlatformService {
  
  /// Detect if the app should show waiter interface
  static bool shouldShowWaiterInterface() {
    // For now, we'll use a simple detection
    // Later this can be enhanced with user role detection
    return true; // Will be determined by routing or user preference
  }
  
  /// Check if current platform is mobile
  static bool get isMobile {
    // This will be implemented in waiter_helpers.dart
    return true; // Placeholder
  }
  
  /// Get appropriate app widget based on context
  static Widget getAppWidget() {
    // This logic will determine which app to show
    // For testing purposes, we'll add a way to choose
    return const WaiterApp();
  }
}