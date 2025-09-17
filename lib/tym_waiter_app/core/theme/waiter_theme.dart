import 'package:flutter/material.dart';
import '../constants/waiter_constants.dart';

/// Mobile-optimized theme for the waiter application
class WaiterTheme {
  static ThemeData get lightTheme {
    const primaryColor = Color(0xFF1976D2); // Blue
    const secondaryColor = Color(0xFF4CAF50); // Green
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme optimized for mobile restaurant environment
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        secondary: secondaryColor,
      ),
      
      // Typography optimized for mobile screens
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.25,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.43,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card theme for mobile touch interaction
      cardTheme: CardThemeData(
        elevation: WaiterConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Button themes optimized for touch
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(WaiterConstants.minTouchTarget, WaiterConstants.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(WaiterConstants.minTouchTarget, WaiterConstants.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(WaiterConstants.minTouchTarget, WaiterConstants.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
          ),
        ),
      ),
      
      // Input decoration for forms
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
      
      // App bar theme
      appBarTheme: AppBarThemeData(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 4,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    const primaryColor = Color(0xFF90CAF9); // Light Blue
    const secondaryColor = Color(0xFF81C784); // Light Green
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme optimized for low-light restaurant environments
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ).copyWith(
        secondary: secondaryColor,
      ),
      
      // Same typography as light theme
      textTheme: lightTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      
      // Card theme for dark mode
      cardTheme: CardThemeData(
        elevation: WaiterConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey[850],
      ),
      
      // Button themes for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(WaiterConstants.minTouchTarget, WaiterConstants.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WaiterConstants.borderRadius),
          ),
        ),
      ),
      
      // Bottom navigation for dark mode
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Status colors for tables and orders
class WaiterStatusColors {
  // Table status colors
  static const Color tableFree = Color(0xFF4CAF50);      // Green
  static const Color tableOccupied = Color(0xFFF44336);  // Red  
  static const Color tableBilled = Color(0xFFFF9800);    // Orange
  static const Color tableReserved = Color(0xFF2196F3);  // Blue
  static const Color tableBlocked = Color(0xFF9E9E9E);   // Grey
  static const Color tableCleaning = Color(0xFFFFC107);  // Amber
  
  // Order status colors
  static const Color orderDraft = Color(0xFF9E9E9E);     // Grey
  static const Color orderConfirmed = Color(0xFF2196F3); // Blue
  static const Color orderPreparing = Color(0xFFFF9800); // Orange
  static const Color orderReady = Color(0xFF4CAF50);     // Green
  static const Color orderServed = Color(0xFF8BC34A);    // Light Green
  static const Color orderCompleted = Color(0xFF4CAF50); // Green
  static const Color orderCancelled = Color(0xFFF44336); // Red
  
  // Payment status colors
  static const Color paymentPending = Color(0xFFFF9800); // Orange
  static const Color paymentPartial = Color(0xFFFFC107); // Amber
  static const Color paymentPaid = Color(0xFF4CAF50);    // Green
  static const Color paymentRefunded = Color(0xFFF44336);// Red
}
