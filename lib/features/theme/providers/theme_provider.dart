import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import '../models/theme_state.dart';
import '../services/theme_persistence_service.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  AppThemeState build() {
    // Initialize with default theme state
    // Saved preferences will be loaded asynchronously
    return const AppThemeState();
  }

  /// Initialize theme with saved preferences
  /// Call this after the provider is created
  Future<void> initialize() async {
    final savedThemeState = await ThemePersistenceService.loadThemeState();
    state = savedThemeState;
  }

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    // Save to persistence
    ThemePersistenceService.saveThemeMode(mode);
  }

  void setColorScheme(AppColorScheme colorScheme) {
    state = state.copyWith(colorScheme: colorScheme);
    // Save to persistence
    ThemePersistenceService.saveColorScheme(colorScheme);
  }

  void setBorderRadius(double radius) {
    state = state.copyWith(borderRadius: radius);
    // Save to persistence
    ThemePersistenceService.saveBorderRadius(radius);
  }

  void setMaterial3(bool useMaterial3) {
    state = state.copyWith(useMaterial3: useMaterial3);
    // Save to persistence
    ThemePersistenceService.saveMaterial3(useMaterial3);
  }

  void toggleCustomizing() {
    // Don't persist isCustomizing as it's just UI state
    state = state.copyWith(isCustomizing: !state.isCustomizing);
  }

  void toggleTheme() {
    final currentMode = state.themeMode;
    AppThemeMode newMode;
    
    switch (currentMode) {
      case AppThemeMode.light:
        newMode = AppThemeMode.dark;
        break;
      case AppThemeMode.dark:
        newMode = AppThemeMode.system;
        break;
      case AppThemeMode.system:
        newMode = AppThemeMode.light;
        break;
    }
    
    setThemeMode(newMode);
  }

  void resetToDefaults() {
    state = const AppThemeState();
    // Clear saved preferences
    ThemePersistenceService.clearThemePreferences();
  }
}

@riverpod
ThemeData lightTheme(Ref ref) {
  final themeState = ref.watch(themeNotifierProvider);
  
  return FlexThemeData.light(
    scheme: _getFlexScheme(themeState.colorScheme),
    colors: _getTymColors(themeState.colorScheme, false),
    useMaterial3: themeState.useMaterial3,
    appBarStyle: FlexAppBarStyle.primary,
    appBarOpacity: 0.95,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    tooltipsMatchBackground: true,
    swapLegacyOnMaterial3: true,
    lightIsWhite: false,
    subThemesData: FlexSubThemesData(
      useMaterial3Typography: true,
      fabUseShape: true,
      interactionEffects: true,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 0.95,
      navigationBarOpacity: 0.95,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
      defaultRadius: themeState.borderRadius,
      buttonMinSize: const Size(40, 40),
      toggleButtonsRadius: themeState.borderRadius,
      segmentedButtonRadius: themeState.borderRadius,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      inputDecoratorRadius: themeState.borderRadius,
      fabRadius: themeState.borderRadius,
      chipRadius: themeState.borderRadius,
      cardRadius: themeState.borderRadius,
      popupMenuRadius: themeState.borderRadius,
      dialogRadius: themeState.borderRadius,
      timePickerDialogRadius: themeState.borderRadius,
      snackBarRadius: themeState.borderRadius,
      appBarScrolledUnderElevation: 4.0,
      bottomSheetElevation: 4.0,
      bottomSheetModalElevation: 8.0,
      popupMenuElevation: 6.0,
      dialogElevation: 6.0,
      drawerElevation: 4.0,
      navigationBarElevation: 0.0,
      navigationRailElevation: 0.0,
    ),
    keyColors: FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepPrimary: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

@riverpod
ThemeData darkTheme(Ref ref) {
  final themeState = ref.watch(themeNotifierProvider);
  
  return FlexThemeData.dark(
    scheme: _getFlexScheme(themeState.colorScheme),
    colors: _getTymColors(themeState.colorScheme, true),
    useMaterial3: themeState.useMaterial3,
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 0.95,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forBackground,
    tooltipsMatchBackground: true,
    swapLegacyOnMaterial3: true,
    darkIsTrueBlack: false,
    subThemesData: FlexSubThemesData(
      useMaterial3Typography: true,
      fabUseShape: true,
      interactionEffects: true,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 0.95,
      navigationBarOpacity: 0.95,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
      defaultRadius: themeState.borderRadius,
      buttonMinSize: const Size(40, 40),
      toggleButtonsRadius: themeState.borderRadius,
      segmentedButtonRadius: themeState.borderRadius,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      inputDecoratorRadius: themeState.borderRadius,
      fabRadius: themeState.borderRadius,
      chipRadius: themeState.borderRadius,
      cardRadius: themeState.borderRadius,
      popupMenuRadius: themeState.borderRadius,
      dialogRadius: themeState.borderRadius,
      timePickerDialogRadius: themeState.borderRadius,
      snackBarRadius: themeState.borderRadius,
      appBarScrolledUnderElevation: 4.0,
      bottomSheetElevation: 4.0,
      bottomSheetModalElevation: 8.0,
      popupMenuElevation: 6.0,
      dialogElevation: 6.0,
      drawerElevation: 4.0,
      navigationBarElevation: 0.0,
      navigationRailElevation: 0.0,
    ),
    keyColors: FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepPrimary: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

@riverpod
ThemeMode currentThemeMode(Ref ref) {
  final themeState = ref.watch(themeNotifierProvider);
  
  switch (themeState.themeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
}

FlexScheme _getFlexScheme(AppColorScheme colorScheme) {
  switch (colorScheme) {
    case AppColorScheme.tymBrand:
    case AppColorScheme.tymSoft:
    case AppColorScheme.tymContrast:
      return FlexScheme.material;  // Base material scheme for TYM variants
    case AppColorScheme.blue:
      return FlexScheme.blue;
    case AppColorScheme.green:
      return FlexScheme.green;
    case AppColorScheme.purple:
      return FlexScheme.deepPurple;
    case AppColorScheme.orange:
      return FlexScheme.amber;  // Use amber instead of orange
    case AppColorScheme.red:
      return FlexScheme.red;
    case AppColorScheme.pink:
      return FlexScheme.sakura;
    case AppColorScheme.indigo:
      return FlexScheme.indigo;
  }
}

/// Custom TYM color configurations for optimal eye comfort and brand alignment
FlexSchemeColor? _getTymColors(AppColorScheme colorScheme, bool isDark) {
  if (!_isTymScheme(colorScheme)) return null;

  switch (colorScheme) {
    case AppColorScheme.tymBrand:
      return _createTymBrandColors(isDark);
    case AppColorScheme.tymSoft:
      return _createTymSoftColors(isDark);
    case AppColorScheme.tymContrast:
      return _createTymContrastColors(isDark);
    default:
      return null;
  }
}

bool _isTymScheme(AppColorScheme scheme) {
  return scheme == AppColorScheme.tymBrand ||
         scheme == AppColorScheme.tymSoft ||
         scheme == AppColorScheme.tymContrast;
}

/// TYM Professional - Brand-aligned with professional appeal
FlexSchemeColor _createTymBrandColors(bool isDark) {
  if (isDark) {
    // Dark mode optimized for reduced eye strain
    return const FlexSchemeColor(
      primary: Color(0xFF4DD4C7),      // Lighter teal for dark backgrounds
      primaryContainer: Color(0xFF0F766E), // Original brand color as container
      secondary: Color(0xFF64D2C7),    // Complementary teal
      secondaryContainer: Color(0xFF134E4A), // Dark teal container
      tertiary: Color(0xFF7DD3FC),     // Light blue accent
      tertiaryContainer: Color(0xFF0C4A6E), // Dark blue container
      error: Color(0xFFFF6B6B),        // Soft red for errors
    );
  } else {
    // Light mode optimized for eye comfort and professionalism
    return const FlexSchemeColor(
      primary: Color(0xFF0F766E),      // TYM brand teal
      primaryContainer: Color(0xFFCCFBF1), // Very light teal container
      secondary: Color(0xFF0D9488),    // Darker teal secondary
      secondaryContainer: Color(0xFFA7F3D0), // Light green container
      tertiary: Color(0xFF0284C7),     // Professional blue
      tertiaryContainer: Color(0xFFDBEAFE), // Light blue container
      error: Color(0xFFDC2626),        // Professional red
    );
  }
}

/// TYM Soft - Optimized for maximum eye comfort
FlexSchemeColor _createTymSoftColors(bool isDark) {
  if (isDark) {
    // Warmer, softer dark theme to reduce eye strain
    return const FlexSchemeColor(
      primary: Color(0xFF5EEAD4),      // Softer, warmer teal
      primaryContainer: Color(0xFF14B8A6), // Soft brand variant
      secondary: Color(0xFF6EE7B7),    // Soft green
      secondaryContainer: Color(0xFF047857), // Warm dark green
      tertiary: Color(0xFF93C5FD),     // Soft blue
      tertiaryContainer: Color(0xFF1E40AF), // Warm dark blue
      error: Color(0xFFF87171),        // Soft red
    );
  } else {
    // Very soft light theme with warmer tones
    return const FlexSchemeColor(
      primary: Color(0xFF14B8A6),      // Softer teal
      primaryContainer: Color(0xFFD6F7F0), // Warmer light container
      secondary: Color(0xFF059669),    // Soft green
      secondaryContainer: Color(0xFFBBF7D0), // Very light green
      tertiary: Color(0xFF3B82F6),     // Soft blue
      tertiaryContainer: Color(0xFFEBF4FF), // Very light blue
      error: Color(0xFFEF4444),        // Soft red
    );
  }
}

/// TYM High Contrast - Enhanced accessibility and readability
FlexSchemeColor _createTymContrastColors(bool isDark) {
  if (isDark) {
    // High contrast dark theme for accessibility
    return const FlexSchemeColor(
      primary: Color(0xFF00F5E4),      // Bright teal for high contrast
      primaryContainer: Color(0xFF0D9488), // Strong contrast container
      secondary: Color(0xFF00E676),    // Bright green
      secondaryContainer: Color(0xFF047857), // Dark green container
      tertiary: Color(0xFF40C4FF),     // Bright blue
      tertiaryContainer: Color(0xFF0D47A1), // Dark blue container
      error: Color(0xFFFF5252),        // Bright red
    );
  } else {
    // High contrast light theme
    return const FlexSchemeColor(
      primary: Color(0xFF0D9488),      // Strong teal
      primaryContainer: Color(0xFFB2DFDB), // High contrast container
      secondary: Color(0xFF00695C),    // Very dark teal
      secondaryContainer: Color(0xFF80CBC4), // Medium contrast container
      tertiary: Color(0xFF01579B),     // Dark blue
      tertiaryContainer: Color(0xFF81D4FA), // Light blue container
      error: Color(0xFFB71C1C),        // Dark red
    );
  }
}