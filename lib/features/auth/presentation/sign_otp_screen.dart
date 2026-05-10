import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
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
            SnackBar(
              content: const Text("Could not open email app. Please open it manually."),
              backgroundColor: AppTheme.getColors(context).statusError,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please check your Gmail inbox."),
            backgroundColor: AppTheme.getColors(context).statusInfo,
          ),
        );
      }
    }
  }

  void _goToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getColors(context);

    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/Aqark.png',
                height: 80,
                color: colors.textPrimary,
              ),
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
              SizedBox(height: AppSpacing.spacing2),
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
