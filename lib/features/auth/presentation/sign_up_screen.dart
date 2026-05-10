import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/data.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import 'widgets/auth_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AuthRepository _authRepo;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _authRepo = GetIt.instance<AuthRepository>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authRepo.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          // Navigate to OTP or Login depending on flow. User requested OTP screen implementation.
          // Usually after signup we might verify OTP.
          Navigator.pushNamed(context, AppRoutes.otpVerification);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: AppTheme.getColors(context).statusError,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getColors(context);

    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/Aqark.png',
                  height: 80,
                  color: colors.textPrimary,
                ),
                const SizedBox(height: 30),
                Text(
                  "Create an Account",
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize6,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight7,
                  ).copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 30),
                CustomAuthTextField(
                  controller: _emailController,
                  label: "Email",
                  hintText: "example@email.com",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? "Enter a valid email"
                      : null,
                ),
                const SizedBox(height: 20),
                CustomAuthTextField(
                  controller: _passwordController,
                  label: "Password",
                  hintText: "••••••",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) => (v == null || v.length < 6)
                      ? "Password must be at least 6 characters"
                      : null,
                ),
                const SizedBox(height: 20),
                CustomAuthTextField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  hintText: "••••••",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword),
                  validator: (v) => (v != _passwordController.text)
                      ? "Passwords do not match"
                      : null,
                ),
                const SizedBox(height: 40),
                PrimaryAuthButton(
                  text: "Sign Up",
                  onPressed: _handleSignUp,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Or Sign Up with",
                        style: TextStyle(color: colors.textDisabled),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                const SocialLoginRow(),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: colors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: colors.actionPrimaryDefault,
                          fontWeight: AppTypography.weightBold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
