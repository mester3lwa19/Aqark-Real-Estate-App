import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_theme.dart';

class CustomAuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomAuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getColors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.createStyle(
            fontSize: AppTypography.fontSize3,
            fontWeight: AppTypography.weightBold,
            lineHeight: AppTypography.lineHeight4,
          ).copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.spacing2),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          style: TextStyle(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: colors.inputPlaceholder),
            prefixIcon: Icon(prefixIcon, color: colors.textDisabled),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: colors.textDisabled,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: colors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              borderSide: BorderSide(color: colors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              borderSide: BorderSide(color: colors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              borderSide: BorderSide(color: colors.borderFocused),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radius8),
              borderSide: BorderSide(color: colors.borderError),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing4,
              vertical: AppSpacing.spacing4,
            ),
          ),
        ),
      ],
    );
  }
}

class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getColors(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.actionPrimaryDefault,
          foregroundColor: colors.textButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CircularProgressIndicator(color: colors.textButton)
            : Text(
                text,
                style: AppTypography.createStyle(
                  fontSize: AppTypography.fontSize4,
                  fontWeight: AppTypography.weightBold,
                  lineHeight: AppTypography.lineHeight5,
                ),
              ),
      ),
    );
  }
}

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getColors(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          iconPath: 'assets/images/google.png',
          onTap: () {},
          colors: colors,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.spacing6),
        _SocialButton(
          iconData: FontAwesomeIcons.apple,
          onTap: () {},
          colors: colors,
          isDark: isDark,
        ),
        const SizedBox(width: AppSpacing.spacing6),
        _SocialButton(
          iconData: FontAwesomeIcons.facebook,
          onTap: () {},
          colors: colors,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData? iconData;
  final String? iconPath;
  final VoidCallback onTap;
  final AppSemanticColors colors;
  final bool isDark;

  const _SocialButton({
    this.iconData,
    this.iconPath,
    required this.onTap,
    required this.colors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color? iconColor;
    Color bgColor;
    BoxBorder? border;

    bool isGoogle = iconPath?.contains('google') ?? false;
    bool isFacebook = iconData == FontAwesomeIcons.facebook || (iconPath?.contains('facebook') ?? false);
    bool isApple = iconData == FontAwesomeIcons.apple || (iconPath?.contains('apple') ?? false);

    if (isGoogle) {
      // Google: Multi-colored logo on white background
      iconColor = null;
      bgColor = Colors.white;
      border = Border.all(color: const Color(0xFFEEEEEE));
    } else if (isFacebook) {
      // Facebook: Official blue icon on white background
      iconColor = const Color(0xFF1877F2);
      bgColor = Colors.white;
      border = Border.all(color: const Color(0xFFEEEEEE));
    } else if (isApple) {
      // Apple: Black on white in dark mode, White on black in light mode
      iconColor = isDark ? Colors.black : Colors.white;
      bgColor = isDark ? Colors.white : Colors.black;
      border = null;
    } else {
      iconColor = isDark ? colors.textPrimary : null;
      bgColor = colors.surfaceCard;
      border = Border.all(color: colors.borderSubtle);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
          color: bgColor,
        ),
        padding: const EdgeInsets.all(AppSpacing.spacing2),
        child: iconData != null
            ? Center(
                child: FaIcon(
                  iconData,
                  color: iconColor,
                  size: 24,
                ),
              )
            : Image.asset(
                iconPath!,
                fit: BoxFit.contain,
                color: iconColor,
              ),
      ),
    );
  }
}
