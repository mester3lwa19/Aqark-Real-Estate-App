import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import 'widgets/auth_widgets.dart';

class SignOtpScreen extends StatefulWidget {
  const SignOtpScreen({super.key});

  @override
  State<SignOtpScreen> createState() => _SignOtpScreenState();
}

class _SignOtpScreenState extends State<SignOtpScreen> {
  bool _isLoading = false;

  void _openEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
    );
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        // If mailto doesn't work (e.g. emulator), just show a message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open email app. Please open it manually.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please check your Gmail inbox.")),
        );
      }
    }
  }

  void _goToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.light;

    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/aqark.png', height: 80),
              const SizedBox(height: 40),
              Icon(Icons.mark_email_unread_outlined, size: 100, color: colors.actionPrimaryDefault),
              const SizedBox(height: 30),
              Text(
                "Verify your email",
                style: AppTypography.createStyle(
                  fontSize: AppTypography.fontSize6,
                  fontWeight: AppTypography.weightBold,
                  lineHeight: AppTypography.lineHeight7,
                ).copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.spacing2),
              Text(
                "We've sent a verification link to your email. Please click the link to activate your account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textDisabled, fontSize: 16),
              ),
              const SizedBox(height: 40),
              PrimaryAuthButton(
                text: "Open Email App",
                onPressed: _openEmailApp,
                isLoading: false,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _goToLogin,
                child: Text(
                  "Already verified? Go to Login",
                  style: TextStyle(
                    color: colors.actionPrimaryDefault,
                    fontWeight: AppTypography.weightBold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Image.asset('assets/images/otp.png', height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
