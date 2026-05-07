import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import 'widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthRepository _authRepo;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepo = GetIt.instance<AuthRepository>();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        final success = await _authRepo.signIn(
          email: email,
          password: password,
        );

        if (success && mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.mainHub,
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
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
    final colors = AppSemanticColors.light;

    return Scaffold(
      backgroundColor: colors.surfaceBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/images/aqark.png', height: 80),
                const SizedBox(height: 40),
                Text(
                  "Welcome Back",
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize6,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight7,
                  ).copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 40),
                CustomAuthTextField(
                  controller: _emailController,
                  label: "Email",
                  hintText: "example@gmail.com",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? "Enter a valid email"
                      : null,
                ),
                const SizedBox(height: AppSpacing.spacing4),
                CustomAuthTextField(
                  controller: _passwordController,
                  label: "Password",
                  hintText: "••••••",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Enter password" : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: colors.actionPrimaryDefault,
                        fontWeight: AppTypography.weightBold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing6),
                PrimaryAuthButton(
                  text: "Login",
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.spacing8),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Or Login with",
                        style: TextStyle(color: colors.textDisabled),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.spacing6),
                const SocialLoginRow(),
                const SizedBox(height: AppSpacing.spacing8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.signup,
                      ),
                      child: Text(
                        "Sign Up",
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
