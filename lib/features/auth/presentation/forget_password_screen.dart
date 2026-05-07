import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';
import 'widgets/auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late final AuthRepository _authRepo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepo = GetIt.instance<AuthRepository>();
  }

  void _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final email = _emailController.text.trim();
        await _authRepo.sendPasswordReset(email);
        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.resetPassword);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/aqark.png', height: 80),
                const SizedBox(height: 40),
                Text(
                  "Enter your email so we can send\nyou reset password message",
                  textAlign: TextAlign.center,
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize5,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight6,
                  ).copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 40),
                CustomAuthTextField(
                  controller: _emailController,
                  label: "Email",
                  hintText: "example@email.com",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? "Enter a valid email" : null,
                ),
                const SizedBox(height: 40),
                PrimaryAuthButton(
                  text: "Confirm",
                  onPressed: _handleReset,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/forget_password.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
