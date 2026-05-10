import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import 'widgets/auth_widgets.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getColors(context);
    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/Aqark.png',
                height: 100,
                color: colors.textPrimary,
              ),
              const SizedBox(height: 60),
              Container(
                padding: EdgeInsets.all(AppSpacing.spacing4),
                decoration: BoxDecoration(
                  color: colors.actionPrimaryDefault.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: colors.actionPrimaryDefault,
                  size: 100,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Password Reset Successfully",
                textAlign: TextAlign.center,
                style: AppTypography.createStyle(
                  fontSize: AppTypography.fontSize6,
                  fontWeight: AppTypography.weightBold,
                  lineHeight: AppTypography.lineHeight7,
                ).copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 20),
              Text(
                "You can now login with your new password",
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textDisabled),
              ),
              const Spacer(),
              PrimaryAuthButton(
                text: "Back to Login",
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                },
              ),
              SizedBox(height: AppSpacing.spacing8),
            ],
          ),
        ),
      ),
    );
  }
}
