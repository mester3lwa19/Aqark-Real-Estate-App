import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import 'widgets/auth_widgets.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  void _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.passwordSuccess, (route) => false);
      }
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/Aqark.png',
                  height: 80,
                  color: colors.textPrimary,
                ),
                const SizedBox(height: 40),
                Text(
                  "Reset Password",
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize6,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight7,
                  ).copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 10),
                Text(
                  "Set your new password to login",
                  style: TextStyle(color: colors.textDisabled),
                ),
                const SizedBox(height: 40),
                CustomAuthTextField(
                  controller: _passwordController,
                  label: "New Password",
                  hintText: "••••••••",
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) => (v == null || v.length < 6) ? "Too short" : null,
                ),
                SizedBox(height: AppSpacing.spacing4),
                CustomAuthTextField(
                  controller: _confirmController,
                  label: "Confirm Password",
                  hintText: "••••••••",
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) => v != _passwordController.text ? "Passwords do not match" : null,
                ),
                const SizedBox(height: 40),
                PrimaryAuthButton(
                  text: "Reset Password",
                  onPressed: _handleReset,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 40),
                Image.asset('assets/images/new_password.png', height: 250),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
