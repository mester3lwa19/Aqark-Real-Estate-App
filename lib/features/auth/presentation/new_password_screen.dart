import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../routes/app_routes.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _handleConfirm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final prefs = await SharedPreferences.getInstance();

        // 1. Recover Email
        final Object? args = ModalRoute.of(context)!.settings.arguments;
        String? email = args is String
            ? args
            : prefs.getString('reset_email_temp');

        if (email == null || email.isEmpty) {
          throw "Session expired. Please restart the reset process.";
        }

        final String newPass = _passwordController.text.trim();

        /* 
          IMPORTANT NOTE: 
          Firebase Auth does NOT allow changing a password for a random email 
          without a secure "Reset Code" (oobCode) from an email link.
          
          If you want the LOGIN screen to work, you have two choices:
          1. Use: await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          2. Or, if you want to force-change it (Manual Admin Style), you must
             update the Realtime Database (as you are doing) and then ensure 
             your LOGIN logic checks the DATABASE instead of Firebase Auth.
        */

        // 2. Update Realtime Database
        final dbRef = FirebaseDatabase.instance.ref("users");
        final snapshot = await dbRef
            .orderByChild("email")
            .equalTo(email)
            .limitToFirst(1)
            .get();

        if (snapshot.exists && snapshot.children.isNotEmpty) {
          final userId = snapshot.children.first.key;
          if (userId != null) {
            // Update the password used for your custom login logic
            await dbRef.child(userId).update({
              "password": newPass,
              "last_updated": ServerValue.timestamp,
            });

            // Sync local storage
            await prefs.setString('local_password', newPass);
            await prefs.remove('reset_email_temp');
          }
        } else {
          throw "Account record not found.";
        }

        if (mounted) {
          Navigator.pushNamed(context, AppRoutes.passwordSuccess);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Auth Error: ${e.toString()}"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // UI remains the same as your design in image_786686.png
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
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/images/Aqark.png', height: 100),
                const SizedBox(height: 40),
                Text(
                  "Enter your new password",
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize5,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight6,
                  ).copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 30),
                _buildField(
                  _passwordController,
                  "Password",
                  _obscurePassword,
                  (v) => setState(() => _obscurePassword = !v),
                ),
                const SizedBox(height: 20),
                _buildField(
                  _confirmPasswordController,
                  "Confirm Password",
                  _obscureConfirmPassword,
                  (v) => setState(() => _obscureConfirmPassword = !v),
                ),
                const SizedBox(height: 40),
                _buildConfirmButton(colors),
                const SizedBox(height: 30),
                Image.asset('assets/images/cuate1.png', height: 280),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    bool obscure,
    Function(bool) toggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () => toggle(obscure),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(AppSemanticColors colors) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.actionPrimaryDefault,
          shape: StadiumBorder(),
        ),
        onPressed: _isLoading ? null : _handleConfirm,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Confirm", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
