import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static AppSemanticColors getColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppSemanticColors.dark : AppSemanticColors.light;
  }

  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppSemanticColors.light.surfaceBackground,
      fontFamily: AppTypography.fontFamilyBase,
      colorScheme: ColorScheme.light(
        primary: AppSemanticColors.light.actionPrimaryDefault,
        onPrimary: AppSemanticColors.light.textButton,
        secondary: AppSemanticColors.light.actionSecondaryDefault,
        onSecondary: AppSemanticColors.light.textButton,
        error: AppSemanticColors.light.statusError,
        surface: AppSemanticColors.light.surfaceCard,
        onSurface: AppSemanticColors.light.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppSemanticColors.light.surfaceBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppSemanticColors.light.textPrimary),
        titleTextStyle: AppTypography.createStyle(
          fontSize: AppTypography.fontSize6, // 24px
          fontWeight: AppTypography.weightSemiBold,
          lineHeight: AppTypography.lineHeight7, // 28px
        ).copyWith(color: AppSemanticColors.light.textPrimary),
      ),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppSemanticColors.dark.surfaceBackground,
      fontFamily: AppTypography.fontFamilyBase,
      colorScheme: ColorScheme.dark(
        primary: AppSemanticColors.dark.actionPrimaryDefault,
        onPrimary: AppSemanticColors.dark.textButton,
        secondary: AppSemanticColors.dark.actionSecondaryDefault,
        onSecondary: AppSemanticColors.dark.textButton,
        error: AppSemanticColors.dark.statusError,
        surface: AppSemanticColors.dark.surfaceCard,
        onSurface: AppSemanticColors.dark.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppSemanticColors.dark.surfaceBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppSemanticColors.dark.textPrimary),
        titleTextStyle: AppTypography.createStyle(
          fontSize: AppTypography.fontSize6,
          fontWeight: AppTypography.weightSemiBold,
          lineHeight: AppTypography.lineHeight7,
        ).copyWith(color: AppSemanticColors.dark.textPrimary),
      ),
    );
  }
}
