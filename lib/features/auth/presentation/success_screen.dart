import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import 'widgets/auth_widgets.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.light;
    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset('assets/images/aqark.png', height: 100),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(AppSpacing.spacing4),
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
              const SizedBox(height: AppSpacing.spacing8),
            ],
          ),
        ),
      ),
    );
  }
}
