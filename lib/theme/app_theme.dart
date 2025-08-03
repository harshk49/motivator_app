import 'package:flutter/material.dart';

/// Central theme configuration for the Motivator App
/// Provides consistent dark theme styling across the entire application
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Primary color scheme based on deep purple
  static const Color _primaryColor = Color(0xFF673AB7);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _surfaceColor = Color(0xFF1E1E1E);
  static const Color _cardColor = Color(0xFF2D2D2D);

  /// Main dark theme for the application
  static ThemeData get darkTheme {
    return ThemeData(
      // Material 3 design system
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme configuration
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
        surface: _surfaceColor,
      ),

      // Scaffold and background colors
      scaffoldBackgroundColor: _darkBackground,
      canvasColor: _darkBackground,
      cardColor: _cardColor,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text themes optimized for quote display
      textTheme: _buildTextTheme(),

      // Card theme for quote cards
      cardTheme: CardTheme(
        color: _cardColor,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: Colors.white70,
        size: 24,
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryColor,
      ),
    );
  }

  /// Builds the custom text theme for optimal quote readability
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      // Large quote text
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        height: 1.3,
        color: Colors.white,
      ),

      // Medium quote text (main quote display)
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        height: 1.4,
        color: Colors.white,
      ),

      // Small headlines
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        height: 1.3,
        color: Colors.white,
      ),

      // Author attribution text
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        height: 1.5,
        color: Colors.white70,
      ),

      // Secondary body text
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
        color: Colors.white60,
      ),

      // Small body text
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        letterSpacing: 0.2,
        height: 1.4,
        color: Colors.white54,
      ),

      // Labels and buttons
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Colors.white,
      ),
    );
  }

  /// Custom colors for specific use cases
  static const Color primary = _primaryColor;
  static const Color background = _darkBackground;
  static const Color surface = _surfaceColor;
  static const Color card = _cardColor;

  // Accent colors
  static const Color accent = Color(0xFF9C27B0);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textHint = Color(0xFF666666);

  // Border and divider colors
  static const Color border = Color(0xFF333333);
  static const Color divider = Color(0xFF2A2A2A);

  // Gradient colors for backgrounds
  static const List<Color> backgroundGradient = [
    _darkBackground,
    Color(0xFF1A1A1A),
  ];

  /// Animation durations used throughout the app
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration quoteAnimation = Duration(milliseconds: 600);

  /// Spacing constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  /// Border radius constants
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusCard = 16.0;
  static const double radiusButton = 12.0;
}
