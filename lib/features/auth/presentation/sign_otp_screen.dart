import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleConfirm() async {
    setState(() => _isLoading = true);
    // Simulation of verification logic
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.mainHub, (route) => false);
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/aqark.png', height: 80),
              const SizedBox(height: 40),
              Text(
                "OTP Verification",
                style: AppTypography.createStyle(
                  fontSize: AppTypography.fontSize6,
                  fontWeight: AppTypography.weightBold,
                  lineHeight: AppTypography.lineHeight7,
                ).copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.spacing2),
              Text(
                "Enter the 6-digit code sent to your email",
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textDisabled),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOTPBox(index, colors)),
              ),
              const SizedBox(height: 40),
              PrimaryAuthButton(
                text: "Confirm",
                onPressed: _handleConfirm,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 60),
              Image.asset('assets/images/otp.png', height: 250),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPBox(int index, AppSemanticColors colors) {
    return SizedBox(
      width: 45,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        style: AppTypography.createStyle(
          fontSize: AppTypography.fontSize5,
          fontWeight: AppTypography.weightBold,
          lineHeight: AppTypography.lineHeight6,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: colors.inputBackground,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius8),
            borderSide: BorderSide(color: colors.borderSubtle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.radius8),
            borderSide: BorderSide(color: colors.borderFocused),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
