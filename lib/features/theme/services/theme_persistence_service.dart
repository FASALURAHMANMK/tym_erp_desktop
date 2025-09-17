import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_state.dart';

class ThemePersistenceService {
  static const String _themeModeKey = 'theme_mode';
  static const String _colorSchemeKey = 'color_scheme';
  static const String _useMaterial3Key = 'use_material3';
  static const String _borderRadiusKey = 'border_radius';

  /// Load theme preferences from SharedPreferences
  /// Returns default AppThemeState if no saved preferences exist
  static Future<AppThemeState> loadThemeState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final themeModeString = prefs.getString(_themeModeKey);
      final themeMode = themeModeString != null
          ? AppThemeMode.values.firstWhere(
              (e) => e.name == themeModeString,
              orElse: () => AppThemeMode.system,
            )
          : AppThemeMode.system;

      // Load color scheme
      final colorSchemeString = prefs.getString(_colorSchemeKey);
      final colorScheme = colorSchemeString != null
          ? AppColorScheme.values.firstWhere(
              (e) => e.name == colorSchemeString,
              orElse: () => AppColorScheme.tymBrand,
            )
          : AppColorScheme.tymBrand;

      // Load other preferences
      final useMaterial3 = prefs.getBool(_useMaterial3Key) ?? true;
      final borderRadius = prefs.getDouble(_borderRadiusKey) ?? 12.0;

      return AppThemeState(
        themeMode: themeMode,
        colorScheme: colorScheme,
        useMaterial3: useMaterial3,
        borderRadius: borderRadius,
        isCustomizing: false, // Never persist this as it's a UI state
      );
    } catch (e) {
      // If any error occurs, return default state
      return const AppThemeState();
    }
  }

  /// Save theme preferences to SharedPreferences
  static Future<void> saveThemeState(AppThemeState themeState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await Future.wait([
        prefs.setString(_themeModeKey, themeState.themeMode.name),
        prefs.setString(_colorSchemeKey, themeState.colorScheme.name),
        prefs.setBool(_useMaterial3Key, themeState.useMaterial3),
        prefs.setDouble(_borderRadiusKey, themeState.borderRadius),
      ]);
    } catch (e) {
      // Silently fail - we don't want theme persistence errors to crash the app
      // In a production app, you might want to log this error
    }
  }

  /// Save theme mode only (for quick toggle operations)
  static Future<void> saveThemeMode(AppThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, themeMode.name);
    } catch (e) {
      // Silently fail
    }
  }

  /// Save color scheme only (for quick color changes)
  static Future<void> saveColorScheme(AppColorScheme colorScheme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_colorSchemeKey, colorScheme.name);
    } catch (e) {
      // Silently fail
    }
  }

  /// Save border radius only
  static Future<void> saveBorderRadius(double borderRadius) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_borderRadiusKey, borderRadius);
    } catch (e) {
      // Silently fail
    }
  }

  /// Save Material 3 preference only
  static Future<void> saveMaterial3(bool useMaterial3) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useMaterial3Key, useMaterial3);
    } catch (e) {
      // Silently fail
    }
  }

  /// Clear all theme preferences (reset to defaults)
  static Future<void> clearThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(_themeModeKey),
        prefs.remove(_colorSchemeKey),
        prefs.remove(_useMaterial3Key),
        prefs.remove(_borderRadiusKey),
      ]);
    } catch (e) {
      // Silently fail
    }
  }

  /// Check if theme preferences exist
  static Future<bool> hasThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_themeModeKey) ||
             prefs.containsKey(_colorSchemeKey) ||
             prefs.containsKey(_useMaterial3Key) ||
             prefs.containsKey(_borderRadiusKey);
    } catch (e) {
      return false;
    }
  }
}