// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamilyBase = "Montserrat";

  // Font Sizes
  static const double fontSize0_0 = 0.0;
  static const double fontSize0_5 = 2.0;
  static const double fontSize1 = 4.0;
  static const double fontSize1_5 = 6.0;
  static const double fontSize2 = 8.0;
  static const double fontSize3 = 12.0;
  static const double fontSize4 = 16.0;
  static const double fontSize5 = 20.0;
  static const double fontSize6 = 24.0;
  static const double fontSize8 = 32.0;
  static const double fontSize10 = 40.0;
  static const double fontSize12 = 48.0;
  static const double fontSize16 = 64.0;
  static const double fontSize20 = 80.0;
  static const double fontSize24 = 96.0;
  static const double fontSize32 = 128.0;

  // Line Heights
  static const double lineHeight3 = 12.0;
  static const double lineHeight4 = 16.0;
  static const double lineHeight5 = 20.0;
  static const double lineHeight6 = 24.0;
  static const double lineHeight7 = 28.0;
  static const double lineHeight8 = 32.0;
  static const double lineHeight9 = 36.0;
  static const double lineHeight10 = 40.0;

  // Font Weights
  static const FontWeight weightThin = FontWeight.w100;
  static const FontWeight weightExtraLight = FontWeight.w200;
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightNormal = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;

  // Paragraph Spacing
  static const double paragraphSpacingNone = 0.0;
  static const double paragraphSpacingSmall = 4.0;
  static const double paragraphSpacingMedium = 8.0;
  static const double paragraphSpacingLarge = 16.0;

  // Helper method to create TextStyles easily
  static TextStyle createStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamilyBase,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
    );
  }
}