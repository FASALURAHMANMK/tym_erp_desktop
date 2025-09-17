import 'package:flutter/material.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

enum AppColorScheme {
  tymBrand,    // Primary TYM brand scheme (default)
  tymSoft,     // Softer variant for eye comfort
  tymContrast, // High contrast variant for accessibility
  blue,
  green,
  purple,
  orange,
  red,
  pink,
  indigo,
}

class AppThemeState {
  final AppThemeMode themeMode;
  final AppColorScheme colorScheme;
  final bool useMaterial3;
  final double borderRadius;
  final bool isCustomizing;

  const AppThemeState({
    this.themeMode = AppThemeMode.system,
    this.colorScheme = AppColorScheme.tymBrand, // Default to TYM brand
    this.useMaterial3 = true,
    this.borderRadius = 12.0,
    this.isCustomizing = false,
  });

  AppThemeState copyWith({
    AppThemeMode? themeMode,
    AppColorScheme? colorScheme,
    bool? useMaterial3,
    double? borderRadius,
    bool? isCustomizing,
  }) {
    return AppThemeState(
      themeMode: themeMode ?? this.themeMode,
      colorScheme: colorScheme ?? this.colorScheme,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      borderRadius: borderRadius ?? this.borderRadius,
      isCustomizing: isCustomizing ?? this.isCustomizing,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'colorScheme': colorScheme.name,
      'useMaterial3': useMaterial3,
      'borderRadius': borderRadius,
      'isCustomizing': isCustomizing,
    };
  }

  factory AppThemeState.fromJson(Map<String, dynamic> json) {
    return AppThemeState(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => AppThemeMode.system,
      ),
      colorScheme: AppColorScheme.values.firstWhere(
        (e) => e.name == json['colorScheme'],
        orElse: () => AppColorScheme.tymBrand,
      ),
      useMaterial3: json['useMaterial3'] as bool? ?? true,
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 12.0,
      isCustomizing: json['isCustomizing'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppThemeState &&
        other.themeMode == themeMode &&
        other.colorScheme == colorScheme &&
        other.useMaterial3 == useMaterial3 &&
        other.borderRadius == borderRadius &&
        other.isCustomizing == isCustomizing;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      colorScheme,
      useMaterial3,
      borderRadius,
      isCustomizing,
    );
  }

  @override
  String toString() {
    return 'AppThemeState(themeMode: $themeMode, colorScheme: $colorScheme, useMaterial3: $useMaterial3, borderRadius: $borderRadius, isCustomizing: $isCustomizing)';
  }
}

extension AppColorSchemeExtension on AppColorScheme {
  String get displayName {
    switch (this) {
      case AppColorScheme.tymBrand:
        return 'TYM Professional';
      case AppColorScheme.tymSoft:
        return 'TYM Soft';
      case AppColorScheme.tymContrast:
        return 'TYM High Contrast';
      case AppColorScheme.blue:
        return 'Ocean Blue';
      case AppColorScheme.green:
        return 'Forest Green';
      case AppColorScheme.purple:
        return 'Royal Purple';
      case AppColorScheme.orange:
        return 'Sunset Orange';
      case AppColorScheme.red:
        return 'Crimson Red';
      case AppColorScheme.pink:
        return 'Rose Pink';
      case AppColorScheme.indigo:
        return 'Deep Indigo';
    }
  }

  Color get primaryColor {
    switch (this) {
      case AppColorScheme.tymBrand:
        return const Color(0xFF0F766E); // TYM brand teal - professional and modern
      case AppColorScheme.tymSoft:
        return const Color(0xFF14B8A6); // Softer teal variant for eye comfort
      case AppColorScheme.tymContrast:
        return const Color(0xFF0D9488); // High contrast teal for accessibility
      case AppColorScheme.blue:
        return const Color(0xFF1976D2);
      case AppColorScheme.green:
        return const Color(0xFF388E3C);
      case AppColorScheme.purple:
        return const Color(0xFF7B1FA2);
      case AppColorScheme.orange:
        return const Color(0xFFF57C00);
      case AppColorScheme.red:
        return const Color(0xFFD32F2F);
      case AppColorScheme.pink:
        return const Color(0xFFC2185B);
      case AppColorScheme.indigo:
        return const Color(0xFF303F9F);
    }
  }
}

extension AppThemeModeExtension on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.auto_mode;
    }
  }
}