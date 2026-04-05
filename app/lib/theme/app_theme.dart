import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand colour palette for Mapa Money.
class AppColors {
  const AppColors._(); // coverage:ignore-line

  // ── Core brand ─────────────────────────────────────────────────
  static const Color primary = Color(0xFF0F3D3E); // deep teal
  static const Color primaryDark = Color(0xFF0A2B2C);
  static const Color accent = Color(0xFFC47A2C); // copper
  static const Color background = Color(0xFFF8FAFA); // light background
  static const Color surface = Color(0xFFFFFFFF); // white cards

  // ── Financial indicators ────────────────────────────────────────
  static const Color expense = Color(0xFFE76F51); // red-orange
  static const Color savings = Color(0xFF2A9D8F); // teal-green
  static const Color neutral = Color(0xFF6B7280); // cool grey

  // ── Category palette ────────────────────────────────────────────
  static const Color categoryFood = Color(0xFFF4A261);
  static const Color categoryTransport = Color(0xFF2A9D8F);
  static const Color categoryEntertainment = Color(0xFFC47A2C);
  static const Color categoryBills = Color(0xFFE76F51);
  static const Color categoryOther = Color(0xFF6B7280);

  // ── Semantic / structural ───────────────────────────────────────
  static const Color onSurface = Color(0xFF1C1C1E);
  static const Color divider = Color(0xFFE5E7EB);

  /// Returns the brand colour assigned to [category].
  static Color categoryColor(String category) {
    switch (category) {
      case 'Food':
        return categoryFood;
      case 'Transport':
        return categoryTransport;
      case 'Entertainment':
        return categoryEntertainment;
      case 'Bills':
        return categoryBills;
      default:
        return categoryOther;
    }
  }
}

/// Central theme definition for Mapa Money.
class AppTheme {
  const AppTheme._(); // coverage:ignore-line

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.expense,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamilyFallback: ['Noto Sans Tamil'],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 8),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.expense, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.neutral),
        prefixIconColor: AppColors.neutral,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.surface,
      ),

      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surface,
        elevation: 4,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(brightness: Brightness.dark),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            fontFamilyFallback: const ['Noto Sans Tamil'],
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.only(bottom: 8),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        prefixIconColor: colorScheme.onSurfaceVariant,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: GoogleFonts.inter(
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: colorScheme.surface,
      ),

      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: colorScheme.surfaceContainerHighest,
        elevation: 4,
      ),
    );
  }

  static TextTheme _buildTextTheme({
    Brightness brightness = Brightness.light,
  }) {
    final textColor = brightness == Brightness.light
        ? AppColors.onSurface
        : const Color(0xFFE1E5EA);
    final subtleColor = brightness == Brightness.light
        ? AppColors.neutral
        : const Color(0xFF9EA7B3);

    TextStyle s(
      double size,
      FontWeight weight, {
      Color? color,
    }) {
      return GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: color ?? textColor,
          fontFamilyFallback: const ['Noto Sans Tamil'],
        ),
      );
    }

    return TextTheme(
      displayLarge: s(57, FontWeight.w400),
      displayMedium: s(45, FontWeight.w400),
      displaySmall: s(36, FontWeight.w400),
      headlineLarge: s(32, FontWeight.w600),
      headlineMedium: s(28, FontWeight.w600),
      headlineSmall: s(24, FontWeight.w600),
      titleLarge: s(22, FontWeight.w600),
      titleMedium: s(16, FontWeight.w600),
      titleSmall: s(14, FontWeight.w500),
      bodyLarge: s(16, FontWeight.w400),
      bodyMedium: s(14, FontWeight.w400),
      bodySmall: s(12, FontWeight.w400, color: subtleColor),
      labelLarge: s(14, FontWeight.w600),
      labelMedium: s(12, FontWeight.w500),
      labelSmall: s(11, FontWeight.w500),
    );
  }
}
