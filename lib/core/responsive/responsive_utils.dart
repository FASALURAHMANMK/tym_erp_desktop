import 'package:flutter/material.dart';

/// Responsive breakpoints for desktop ERP application
class ResponsiveBreakpoints {
  // Desktop breakpoints optimized for ERP usage
  static const double smallDesktop = 1024;   // Small desktop/POS terminals
  static const double mediumDesktop = 1366;  // Standard desktop
  static const double largeDesktop = 1920;   // Large desktop/monitors
  static const double extraLargeDesktop = 2560; // Ultra-wide/4K monitors

  // Height breakpoints for different aspect ratios
  static const double compactHeight = 768;   // Compact screens
  static const double standardHeight = 1080; // Standard screens
}

/// Screen size categories for responsive design
enum ScreenSize { 
  small,      // 1024-1365px
  medium,     // 1366-1919px  
  large,      // 1920-2559px
  extraLarge  // 2560px+
}

/// Comprehensive responsive utilities for ERP desktop application
class ResponsiveUtils {
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < ResponsiveBreakpoints.mediumDesktop) {
      return ScreenSize.small;
    } else if (width < ResponsiveBreakpoints.largeDesktop) {
      return ScreenSize.medium;
    } else if (width < ResponsiveBreakpoints.extraLargeDesktop) {
      return ScreenSize.large;
    } else {
      return ScreenSize.extraLarge;
    }
  }

  static bool isSmallScreen(BuildContext context) => 
      getScreenSize(context) == ScreenSize.small;
  
  static bool isMediumScreen(BuildContext context) => 
      getScreenSize(context) == ScreenSize.medium;
  
  static bool isLargeScreen(BuildContext context) => 
      getScreenSize(context) == ScreenSize.large;
  
  static bool isExtraLargeScreen(BuildContext context) => 
      getScreenSize(context) == ScreenSize.extraLarge;

  static bool isCompactHeight(BuildContext context) =>
      MediaQuery.of(context).size.height < ResponsiveBreakpoints.compactHeight;

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T small,
    required T medium,
    required T large,
    T? extraLarge,
  }) {
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return small;
      case ScreenSize.medium:
        return medium;
      case ScreenSize.large:
        return large;
      case ScreenSize.extraLarge:
        return extraLarge ?? large;
    }
  }

  /// Get scaling factor based on screen width
  /// Base resolution: 1366px (100% scale)
  static double getScaleFactor(BuildContext context, {
    double minScale = 0.8,
    double maxScale = 1.5,
  }) {
    final width = MediaQuery.of(context).size.width;
    final baseWidth = ResponsiveBreakpoints.mediumDesktop;
    final scale = width / baseWidth;
    return scale.clamp(minScale, maxScale);
  }
}

/// Responsive dimensions for ERP components
class ResponsiveDimensions {
  
  /// Header heights based on screen size
  static double getHeaderHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 64.0,      // Compact for small screens
      medium: 72.0,     // Standard
      large: 80.0,      // Larger for big monitors
      extraLarge: 88.0, // Extra large for 4K displays
    );
  }

  /// Sidebar widths based on screen size
  static double getSidebarExpandedWidth(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 200.0,     // Narrower for small screens
      medium: 240.0,    // Standard
      large: 280.0,     // Wider for large screens
      extraLarge: 320.0, // Extra wide for 4K
    );
  }

  static double getSidebarCollapsedWidth(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 60.0,      // Compact for small screens
      medium: 80.0,     // Standard
      large: 88.0,      // Slightly larger
      extraLarge: 96.0, // Larger for 4K
    );
  }

  /// Content padding based on screen size
  static double getContentPadding(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 12.0,      // Compact padding for small screens
      medium: 16.0,     // Standard padding
      large: 20.0,      // More spacious for large screens
      extraLarge: 24.0, // Maximum spacing for 4K
    );
  }

  /// Screen padding (outer margins)
  static double getScreenPadding(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 16.0,      // Minimal for small screens
      medium: 24.0,     // Standard
      large: 32.0,      // More generous for large screens
      extraLarge: 40.0, // Maximum for 4K displays
    );
  }

  /// Card padding based on screen size
  static double getCardPadding(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 16.0,      // Compact
      medium: 20.0,     // Standard
      large: 24.0,      // Spacious
      extraLarge: 28.0, // Extra spacious
    );
  }

  /// Icon sizes based on screen size
  static double getIconSize(BuildContext context, {double baseSize = 24.0}) {
    final scale = ResponsiveUtils.getScaleFactor(context, minScale: 0.9, maxScale: 1.3);
    return baseSize * scale;
  }

  /// Logo area height based on screen size
  static double getLogoAreaHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 64.0,      // Compact for small screens
      medium: 80.0,     // Standard
      large: 88.0,      // Larger for big screens
      extraLarge: 96.0, // Maximum for 4K
    );
  }

  /// Navigation item height based on screen size
  static double getNavItemHeight(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 48.0,      // Compact touch targets
      medium: 56.0,     // Standard
      large: 64.0,      // Larger for easier interaction
      extraLarge: 72.0, // Maximum for 4K displays
    );
  }
}

/// Responsive spacing utilities
class ResponsiveSpacing {
  /// Get responsive EdgeInsets for padding
  static EdgeInsets getPadding(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    final scale = ResponsiveUtils.getScaleFactor(context, minScale: 0.8, maxScale: 1.2);
    
    return EdgeInsets.only(
      left: (left ?? horizontal ?? all ?? 0.0) * scale,
      top: (top ?? vertical ?? all ?? 0.0) * scale,
      right: (right ?? horizontal ?? all ?? 0.0) * scale,
      bottom: (bottom ?? vertical ?? all ?? 0.0) * scale,
    );
  }

  /// Get responsive SizedBox for spacing
  static Widget getVerticalSpacing(BuildContext context, double height) {
    final scale = ResponsiveUtils.getScaleFactor(context, minScale: 0.8, maxScale: 1.2);
    return SizedBox(height: height * scale);
  }

  static Widget getHorizontalSpacing(BuildContext context, double width) {
    final scale = ResponsiveUtils.getScaleFactor(context, minScale: 0.8, maxScale: 1.2);
    return SizedBox(width: width * scale);
  }
}

/// Responsive typography utilities
class ResponsiveTypography {
  /// Get scaled text style based on screen size
  static TextStyle? getScaledTextStyle(
    BuildContext context, 
    TextStyle? baseStyle,
    {double? scaleFactor}
  ) {
    if (baseStyle == null) return null;
    
    final scale = scaleFactor ?? ResponsiveUtils.getScaleFactor(
      context, 
      minScale: 0.9, 
      maxScale: 1.2
    );
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14.0) * scale,
    );
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: baseSize * 0.9,      // Slightly smaller for small screens
      medium: baseSize,           // Base size
      large: baseSize * 1.1,      // Slightly larger for big screens
      extraLarge: baseSize * 1.2, // Larger for 4K displays
    );
  }
}

/// Responsive layout utilities
class ResponsiveLayout {
  /// Get number of columns for grid based on screen size
  static int getGridColumns(BuildContext context, {
    int? small,
    int? medium,
    int? large,
    int? extraLarge,
  }) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: small ?? 2,
      medium: medium ?? 3,
      large: large ?? 4,
      extraLarge: extraLarge ?? 5,
    );
  }

  /// Get responsive aspect ratio for cards
  static double getCardAspectRatio(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: 1.1,       // Slightly taller for small screens
      medium: 1.2,      // Standard ratio
      large: 1.3,       // Wider for large screens
      extraLarge: 1.4,  // Widest for 4K
    );
  }

  /// Check if sidebar should be collapsed by default
  static bool shouldCollapseSidebar(BuildContext context) {
    return ResponsiveUtils.isSmallScreen(context) || 
           ResponsiveUtils.isCompactHeight(context);
  }

  /// Get maximum content width for readability
  static double getMaxContentWidth(BuildContext context) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      small: double.infinity,  // Use all available space
      medium: 1200.0,          // Reasonable limit for medium screens
      large: 1400.0,           // Larger limit for big screens
      extraLarge: 1600.0,      // Maximum for 4K displays
    );
  }
}