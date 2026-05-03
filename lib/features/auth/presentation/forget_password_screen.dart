import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final email = _emailController.text.trim();
        final dbRef = FirebaseDatabase.instance.ref("users");

        // Check if user exists in Firebase
        final snapshot = await dbRef
            .orderByChild("email")
            .equalTo(email)
            .limitToFirst(1)
            .get();

        if (snapshot.exists) {
          // SAVE EMAIL LOCALLY: Fixes the "Email argument missing" error on reload
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('reset_email_temp', email);

          if (mounted) {
            Navigator.pushNamed(
              context,
              AppRoutes.resetPassword,
              arguments: email,
            );
          }
        } else {
          throw "No account found with this email in our system.";
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/Aqark.png', height: 100),
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
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email", style: TextStyle(fontWeight: AppTypography.weightBold, color: colors.textPrimary, fontSize: 14)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => (val == null || !val.contains('@')) ? "Enter a valid email" : null,
                  decoration: InputDecoration(
                    hintText: "example@email.com",
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    filled: true,
                    fillColor: colors.inputBackground,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radius8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.radius8)),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.actionPrimaryDefault,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.radiusFull)),
                    ),
                    onPressed: _isLoading ? null : _handleReset,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Confirm", style: AppTypography.createStyle(fontSize: AppTypography.fontSize4, fontWeight: AppTypography.weightBold, lineHeight: AppTypography.lineHeight5).copyWith(color: colors.textButton)),
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset('assets/images/cuate.png', height: 250, fit: BoxFit.contain),
              ],
            ),
          ),
        ),
      ),
    );
  }
}