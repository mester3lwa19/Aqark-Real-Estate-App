import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';

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
              Image.asset(
                'assets/images/pana1.png',
                height: 350,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Icon(Icons.check_circle, size: 100, color: Colors.green)),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                "Your password has been reset\ncorreclty",
                textAlign: TextAlign.center,
                style: AppTypography.createStyle(
                  fontSize: AppTypography.fontSize5,
                  fontWeight: AppTypography.weightBold,
                  lineHeight: AppTypography.lineHeight6,
                ).copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.actionPrimaryDefault,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                          (route) => false,
                    );
                  },
                  child: Text(
                    "Confirm",
                    style: AppTypography.createStyle(
                      fontSize: AppTypography.fontSize4,
                      fontWeight: AppTypography.weightBold,
                      lineHeight: AppTypography.lineHeight5,
                    ).copyWith(color: colors.textButton),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}