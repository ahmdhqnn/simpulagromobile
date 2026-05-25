import 'package:flutter/material.dart';

/// Centralized color tokens for the SimpulAgro design system.
class AppColors {
  // Primary - Rich greens for agriculture theme
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF0D3B0F);

  // Secondary - Warm earth tones
  static const Color secondary = Color(0xFF795548);
  static const Color secondaryLight = Color(0xFFA1887F);

  // Accent
  static const Color accent = Color(0xFF66BB6A);
  static const Color accentDark = Color(0xFF388E3C);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Neutral
  static const Color background = Color(0xFFF5F7F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F4F0);
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF6B6E6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color pill = Color(0xFFF7F7F7);

  // Shimmer
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Sensor-specific colors
  static const Color temperature = Color(0xFFFF7043);
  static const Color humidity = Color(0xFF42A5F5);
  static const Color nitrogen = Color(0xFF66BB6A);
  static const Color phosphorus = Color(0xFFAB47BC);
  static const Color potassium = Color(0xFFFFA726);
  static const Color ph = Color(0xFF26C6DA);

  // Soft accent backgrounds (commonly used for icon badges)
  static const Color softGreen = Color(0xFFEDF7EE);
  static const Color softBlue = Color(0xFFECF6FE);
  static const Color softOrange = Color(0xFFFFF6E9);
  static const Color softGreenAlt = Color(0xFFE8EFE9);
}

/// Standard corner radius tokens used across cards, badges, and buttons.
class AppRadius {
  AppRadius._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 18;
  static const double xl = 20;
  static const double pill = 100;
}

/// Centralized typography. The font family is set globally on [ThemeData],
/// so these styles only need to set size/weight/color.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Plus Jakarta Sans';

  /// Section/screen title (around 22sp).
  static TextStyle sectionTitle(BuildContext context, [double size = 22]) =>
      _scaled(
        context,
        size: size,
        weight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.0,
      );

  /// Card title.
  static TextStyle cardTitle(BuildContext context, [double size = 16]) =>
      _scaled(
        context,
        size: size,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  /// Big metric / number display.
  static TextStyle metric(
    BuildContext context, {
    double size = 22,
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.w500,
  }) => _scaled(context, size: size, weight: weight, color: color, height: 1.0);

  /// Body label/caption (around 12sp).
  static TextStyle label(
    BuildContext context, {
    double size = 12,
    Color color = AppColors.textPrimary,
    FontWeight weight = FontWeight.w500,
    double height = 1.83,
  }) => _scaled(
    context,
    size: size,
    weight: weight,
    color: color,
    height: height,
  );

  /// Body secondary (smaller).
  static TextStyle caption(
    BuildContext context, {
    double size = 11,
    Color color = AppColors.textSecondary,
    FontWeight weight = FontWeight.w400,
  }) => _scaled(context, size: size, weight: weight, color: color);

  /// Body secondary (smaller).
  static TextStyle caption2(
    BuildContext context, {
    double size = 11,
    Color color = AppColors.textSecondary,
    FontWeight weight = FontWeight.w300,
  }) => _scaled(context, size: size, weight: weight, color: color);

  /// Hint / muted small text.
  static TextStyle hint(
    BuildContext context, {
    double size = 12,
    FontWeight weight = FontWeight.w300,
    double height = 1.83,
  }) => _scaled(
    context,
    size: size,
    weight: weight,
    color: AppColors.textPrimary.withValues(alpha: 0.6),
    height: height,
  );

  static TextStyle _scaled(
    BuildContext context, {
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
  }) {
    final scaledSize =
        size * (MediaQuery.sizeOf(context).width / 390).clamp(0.8, 1.3);
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: scaledSize,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        color: AppColors.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
