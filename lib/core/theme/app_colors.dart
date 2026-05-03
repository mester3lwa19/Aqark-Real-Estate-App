// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppPrimitiveColors {
  // Primary
  static const Color primary25 = Color(0xFFFAF9F9);
  static const Color primary50 = Color(0xFFF5F0EE);
  static const Color primary100 = Color(0xFFEDD9D3);
  static const Color primary200 = Color(0xFFE9B4A4);
  static const Color primary300 = Color(0xFFE78363);
  static const Color primary400 = Color(0xFFEA5A2D);
  static const Color primary500 = Color(0xFFD53E0F);
  static const Color primary600 = Color(0xFFB5340C);
  static const Color primary700 = Color(0xFF952B0A);
  static const Color primary800 = Color(0xFF752208);
  static const Color primary900 = Color(0xFF551806);
  static const Color primary950 = Color(0xFF3F1204);
  static const Color primary1000 = Color(0xFF2A0C03);

  // Secondary
  static const Color secondary25 = Color(0xFFF9F9FA);
  static const Color secondary50 = Color(0xFFEFF1F5);
  static const Color secondary100 = Color(0xFFD3DBED);
  static const Color secondary200 = Color(0xFFA6BAE7);
  static const Color secondary300 = Color(0xFF668DE4);
  static const Color secondary400 = Color(0xFF316AE7);
  static const Color secondary500 = Color(0xFF1146BB);
  static const Color secondary600 = Color(0xFF0E3B9E);
  static const Color secondary700 = Color(0xFF0B3182);
  static const Color secondary800 = Color(0xFF092666);
  static const Color secondary900 = Color(0xFF061C4A);
  static const Color secondary950 = Color(0xFF051538);
  static const Color secondary1000 = Color(0xFF030E25);

  // Gray
  static const Color gray25 = Color(0xFFF9F9F9);
  static const Color gray50 = Color(0xFFF1F2F2);
  static const Color gray100 = Color(0xFFDFDFE1);
  static const Color gray200 = Color(0xFFC3C5CA);
  static const Color gray300 = Color(0xFF9EA3AC);
  static const Color gray400 = Color(0xFF828995);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF5A606C);
  static const Color gray700 = Color(0xFF4A4F59);
  static const Color gray800 = Color(0xFF3A3E46);
  static const Color gray900 = Color(0xFF2A2D33);
  static const Color gray950 = Color(0xFF202226);
  static const Color gray1000 = Color(0xFF151619);

  // Success
  static const Color success25 = Color(0xFFF9FAF9);
  static const Color success50 = Color(0xFFF1F5EF);
  static const Color success100 = Color(0xFFDDECD4);
  static const Color success200 = Color(0xFFBFE6A7);
  static const Color success300 = Color(0xFF97E368);
  static const Color success400 = Color(0xFF77E434);
  static const Color success500 = Color(0xFF48A111);
  static const Color success600 = Color(0xFF3D880E);
  static const Color success700 = Color(0xFF32700B);
  static const Color success800 = Color(0xFF275809);
  static const Color success900 = Color(0xFF1C4006);
  static const Color success950 = Color(0xFF153005);
  static const Color success1000 = Color(0xFF0E2003);

  // Warning
  static const Color warning25 = Color(0xFFFAFAF8);
  static const Color warning50 = Color(0xFFF6F4EE);
  static const Color warning100 = Color(0xFFEFEAD1);
  static const Color warning200 = Color(0xFFEEE09F);
  static const Color warning300 = Color(0xFFF1D759);
  static const Color warning400 = Color(0xFFF9D31F);
  static const Color warning500 = Color(0xFFFFDE42);
  static const Color warning600 = Color(0xFFFFD511);
  static const Color warning700 = Color(0xFFE0B900);
  static const Color warning800 = Color(0xFFB09100);
  static const Color warning900 = Color(0xFF806900);
  static const Color warning950 = Color(0xFF604F00);
  static const Color warning1000 = Color(0xFF403400);

  // Error
  static const Color error25 = Color(0xFFFAF8F8);
  static const Color error50 = Color(0xFFF6EEEE);
  static const Color error100 = Color(0xFFEFD1D1);
  static const Color error200 = Color(0xFFEE9F9F);
  static const Color error300 = Color(0xFFF15959);
  static const Color error400 = Color(0xFFF91F1F);
  static const Color error500 = Color(0xFFFF0000);
  static const Color error600 = Color(0xFFD80000);
  static const Color error700 = Color(0xFFB20000);
  static const Color error800 = Color(0xFF8C0000);
  static const Color error900 = Color(0xFF660000);
  static const Color error950 = Color(0xFF4C0000);
  static const Color error1000 = Color(0xFF330000);
}

class AppSemanticColors {
  final Color textPrimary;
  final Color textSecondary;
  final Color textGray;
  final Color textDisabled;
  final Color textInverse;
  final Color textLink;
  final Color textLinkHover;
  final Color textButton;

  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceGray;
  final Color surfaceCard;
  final Color surfaceCardHover;
  final Color surfaceOverlay;
  final Color surfaceInverse;
  final Color surfaceBrandSubtle;
  final Color surfaceBackground;

  final Color actionPrimaryDefault;
  final Color actionPrimaryHover;
  final Color actionPrimaryPressed;
  final Color actionPrimaryDisabled;
  final Color actionSecondaryDefault;
  final Color actionSecondaryHover;
  final Color actionSecondaryPressed;
  final Color actionSecondaryDisabled;

  final Color borderDefault;
  final Color borderStrong;
  final Color borderSubtle;
  final Color borderFocused;
  final Color borderError;

  final Color statusSuccess;
  final Color statusSuccessSubtle;
  final Color statusSuccessHovered;
  final Color statusSuccessPressed;

  final Color statusError;
  final Color statusErrorSubtle;
  final Color statusErrorHovered;
  final Color statusErrorPressed;

  final Color statusWarning;
  final Color statusWarningSubtle;
  final Color statusWarningHovered;
  final Color statusWarningPressed;

  final Color statusInfo;
  final Color statusInfoSubtle;

  final Color propertyVerifiedBadge;
  final Color propertyFeaturedBadge;
  final Color propertyNewBadge;
  final Color propertyPriceHighlight;

  final Color inputBackground;
  final Color inputBorder;
  final Color inputPlaceholder;

  const AppSemanticColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textGray,
    required this.textDisabled,
    required this.textInverse,
    required this.textLink,
    required this.textLinkHover,
    required this.textButton,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceGray,
    required this.surfaceCard,
    required this.surfaceCardHover,
    required this.surfaceOverlay,
    required this.surfaceInverse,
    required this.surfaceBrandSubtle,
    required this.surfaceBackground,
    required this.actionPrimaryDefault,
    required this.actionPrimaryHover,
    required this.actionPrimaryPressed,
    required this.actionPrimaryDisabled,
    required this.actionSecondaryDefault,
    required this.actionSecondaryHover,
    required this.actionSecondaryPressed,
    required this.actionSecondaryDisabled,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderSubtle,
    required this.borderFocused,
    required this.borderError,
    required this.statusSuccess,
    required this.statusSuccessSubtle,
    required this.statusSuccessHovered,
    required this.statusSuccessPressed,
    required this.statusError,
    required this.statusErrorSubtle,
    required this.statusErrorHovered,
    required this.statusErrorPressed,
    required this.statusWarning,
    required this.statusWarningSubtle,
    required this.statusWarningHovered,
    required this.statusWarningPressed,
    required this.statusInfo,
    required this.statusInfoSubtle,
    required this.propertyVerifiedBadge,
    required this.propertyFeaturedBadge,
    required this.propertyNewBadge,
    required this.propertyPriceHighlight,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputPlaceholder,
  });

  static const light = AppSemanticColors(
    textPrimary: Color(0xFF2A0C03),
    textSecondary: Color(0xFF030E25),
    textGray: Color(0xFF151619),
    textDisabled: Color(0xFF828995),
    textInverse: Color(0xFFF1F2F2),
    textLink: Color(0xFF0E3B9E),
    textLinkHover: Color(0xFF0B3182),
    textButton: Color(0xFFFAF9F9),
    surfacePrimary: Color(0xFFE9B4A4),
    surfaceSecondary: Color(0xFFA6BAE7),
    surfaceGray: Color(0xFFC3C5CA),
    surfaceCard: Color(0xFFF1F2F2),
    surfaceCardHover: Color(0xFFDFDFE1),
    surfaceOverlay: Color(0xFF2A2D33),
    surfaceInverse: Color(0xFF2A2D33),
    surfaceBrandSubtle: Color(0xFFF5F0EE),
    surfaceBackground: Color(0xFFF5F0EE),
    actionPrimaryDefault: Color(0xFFEA5A2D),
    actionPrimaryHover: Color(0xFF952B0A),
    actionPrimaryPressed: Color(0xFF752208),
    actionPrimaryDisabled: Color(0xFF9EA3AC),
    actionSecondaryDefault: Color(0xFF0E3B9E),
    actionSecondaryHover: Color(0xFF0B3182),
    actionSecondaryPressed: Color(0xFF092666),
    actionSecondaryDisabled: Color(0xFF9EA3AC),
    borderDefault: Color(0xFF9EA3AC),
    borderStrong: Color(0xFF828995),
    borderSubtle: Color(0xFFC3C5CA),
    borderFocused: Color(0xFFD53E0F),
    borderError: Color(0xFFFF0000),
    statusSuccess: Color(0xFF3D880E),
    statusSuccessSubtle: Color(0xFFDDECD4),
    statusSuccessHovered: Color(0xFF32700B),
    statusSuccessPressed: Color(0xFF275809),
    statusError: Color(0xFFD80000),
    statusErrorSubtle: Color(0xFFEFD1D1),
    statusErrorHovered: Color(0xFFB20000),
    statusErrorPressed: Color(0xFF8C0000),
    statusWarning: Color(0xFFFFD511),
    statusWarningSubtle: Color(0xFFEFEAD1),
    statusWarningHovered: Color(0xFFE0B900),
    statusWarningPressed: Color(0xFFB09100),
    statusInfo: Color(0xFF0E3B9E),
    statusInfoSubtle: Color(0xFFD3DBED),
    propertyVerifiedBadge: Color(0xFF3D880E),
    propertyFeaturedBadge: Color(0xFFFFD511),
    propertyNewBadge: Color(0xFFB5340C),
    propertyPriceHighlight: Color(0xFF952B0A),
    inputBackground: Color(0xFFDFDFE1),
    inputBorder: Color(0xFF9EA3AC),
    inputPlaceholder: Color(0xFF6B7280),
  );

  static const dark = AppSemanticColors(
    textPrimary: Color(0xFFF5F0EE),
    textSecondary: Color(0xFFEFF1F5),
    textGray: Color(0xFFF1F2F2),
    textDisabled: Color(0xFF5A606C),
    textInverse: Color(0xFF2A2D33),
    textLink: Color(0xFF316AE7),
    textLinkHover: Color(0xFF668DE4),
    textButton: Color(0xFFFAF9F9),
    surfacePrimary: Color(0xFF952B0A),
    surfaceSecondary: Color(0xFF0B3182),
    surfaceGray: Color(0xFF4A4F59),
    surfaceCard: Color(0xFF3A3E46),
    surfaceCardHover: Color(0xFF4A4F59),
    surfaceOverlay: Color(0xFF202226),
    surfaceInverse: Color(0xFFF1F2F2),
    surfaceBrandSubtle: Color(0xFF551806),
    surfaceBackground: Color(0xFF151619),
    actionPrimaryDefault: Color(0xFFEA5A2D),
    actionPrimaryHover: Color(0xFFEA5A2D),
    actionPrimaryPressed: Color(0xFFB5340C),
    actionPrimaryDisabled: Color(0xFF4A4F59),
    actionSecondaryDefault: Color(0xFF1146BB),
    actionSecondaryHover: Color(0xFF316AE7),
    actionSecondaryPressed: Color(0xFF0E3B9E),
    actionSecondaryDisabled: Color(0xFF4A4F59),
    borderDefault: Color(0xFF4A4F59),
    borderStrong: Color(0xFF5A606C),
    borderSubtle: Color(0xFF3A3E46),
    borderFocused: Color(0xFFEA5A2D),
    borderError: Color(0xFFF91F1F),
    statusSuccess: Color(0xFF48A111),
    statusSuccessSubtle: Color(0xFF1C4006),
    statusSuccessHovered: Color(0xFF77E434),
    statusSuccessPressed: Color(0xFF97E368),
    statusError: Color(0xFFFF0000),
    statusErrorSubtle: Color(0xFF660000),
    statusErrorHovered: Color(0xFFF91F1F),
    statusErrorPressed: Color(0xFFF15959),
    statusWarning: Color(0xFFFFDE42),
    statusWarningSubtle: Color(0xFF806900),
    statusWarningHovered: Color(0xFFF9D31F),
    statusWarningPressed: Color(0xFFF1D759),
    statusInfo: Color(0xFF1146BB),
    statusInfoSubtle: Color(0xFF061C4A),
    propertyVerifiedBadge: Color(0xFF77E434),
    propertyFeaturedBadge: Color(0xFFF9D31F),
    propertyNewBadge: Color(0xFFEA5A2D),
    propertyPriceHighlight: Color(0xFFE78363),
    inputBackground: Color(0xFF3A3E46),
    inputBorder: Color(0xFF4A4F59),
    inputPlaceholder: Color(0xFF6B7280),
  );
}
