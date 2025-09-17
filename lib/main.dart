import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routing/app_router.dart';
import 'features/theme/providers/theme_provider.dart';
import 'features/sales/services/sales_background_sync.dart';
import 'features/products/providers/product_image_sync_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory for desktop platforms
    databaseFactory = databaseFactoryFfi;
  }

  await Supabase.initialize(
    url: 'https://ulhdzzdsoctxqkirwtxd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVsaGR6emRzb2N0eHFraXJ3dHhkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM0NDQ4MzksImV4cCI6MjA2OTAyMDgzOX0.tYjvfeigmYx-QqLrRvPVndIfmpg_sw5bu4q8jcxHTiQ',
  );

  runApp(
    // Wrap the entire app with ProviderScope for Riverpod
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize theme with saved preferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeNotifierProvider.notifier).initialize();
      // Start background sync for sales data (price categories, product prices, etc.)
      ref.read(salesBackgroundSyncProvider);
      // Start background sync for product images
      ref.read(autoImageSyncInitProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final themeMode = ref.watch(currentThemeModeProvider);

    return MaterialApp.router(
      title: 'TYM ERP Desktop',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
