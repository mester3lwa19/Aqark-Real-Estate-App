import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../data/data.dart';
// import '../repositories/auth_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Repository handles cloud save and local SharedPreferences save
        await _authRepo.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          // Send to login so they can verify their new credentials
          Navigator.pushReplacementNamed(context, AppRoutes.login);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created! Please login.")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/images/Aqark.png', height: 100),
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

                _buildLabel("Email"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter an email" : null,
                  decoration: _inputDecoration(
                    "example@email.com",
                    Icons.email_outlined,
                    colors,
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel("Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) => value!.length < 6
                      ? "Password must be at least 6 characters"
                      : null,
                  decoration: _inputDecoration(
                    "********",
                    Icons.lock_outline,
                    colors,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.actionPrimaryDefault,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusFull,
                        ),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleSignUp,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: colors.actionPrimaryDefault,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
    AppSemanticColors colors, {
    Widget? suffix,
  }) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    suffixIcon: suffix,
    filled: true,
    fillColor: colors.inputBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radius8),
      borderSide: BorderSide.none,
    ),
  );
}
