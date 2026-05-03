// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_dimensions.dart';
// import '../../../core/theme/app_typography.dart';
// import '../../../routes/app_routes.dart';
// import '../data/data.dart';
// // import '../repositories/auth_repository.dart';
//
// class SignOtpScreen extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   const SignOtpScreen({super.key, required this.userData});
//
//   @override
//   State<SignOtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<SignOtpScreen> {
//   final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
//   final _authRepo = AuthRepository();
//
//   @override
//   Widget build(BuildContext context) {
//     // Matching the background color from image_951569.png
//     final colors = AppSemanticColors.light;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F3F1), // Specific background shade from your image
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing6),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     // 1. Logo
//                     Image.asset('assets/images/Aqark.png', height: 100),
//                     const SizedBox(height: 40),
//
//                     // 2. Exact Header Text from image_951569.png
//                     Text(
//                       "We sent you a verification code\nto secure your account to your\nemail.",
//                       textAlign: TextAlign.center,
//                       style: AppTypography.createStyle(
//                         fontSize: AppTypography.fontSize5,
//                         fontWeight: AppTypography.weightBold,
//                         lineHeight: AppTypography.lineHeight6,
//                       ).copyWith(color: colors.textPrimary),
//                     ),
//                     const SizedBox(height: 30),
//
//                     // 3. OTP Input Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: List.generate(6, (index) => _buildOtpBox(index)),
//                     ),
//                     const SizedBox(height: 40),
//
//                     // 4. Confirm Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: colors.actionPrimaryDefault,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(AppRadius.radiusFull),
//                           ),
//                         ),
//                         onPressed: () async {
//                           String code = _controllers.map((e) => e.text).join();
//                           if (code.length == 6) {
//                             try {
//                               await _authRepo.signUp(
//                                 email: widget.userData['email'],
//                                 password: widget.userData['password'],
//                               );
//                               Navigator.pushReplacementNamed(context, AppRoutes.home);
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text(e.toString())),
//                               );
//                             }
//                           }
//                         },
//                         child: Text(
//                           "Confirm",
//                           style: AppTypography.createStyle(
//                             fontSize: AppTypography.fontSize4,
//                             fontWeight: AppTypography.weightBold, lineHeight: AppTypography.lineHeight5,
//                           ).copyWith(color: colors.textButton),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // 5. Bottom Illustration (pana.png)
//             // This is placed outside the ScrollView (or at the bottom of the column)
//             // to match the layout in image_951569.png
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Image.asset(
//                 'assets/images/pana.png',
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOtpBox(int index) {
//     return SizedBox(
//       height: 54,
//       width: 48,
//       child: TextField(
//         controller: _controllers[index],
//         onChanged: (value) {
//           if (value.length == 1 && index < 5) FocusScope.of(context).nextFocus();
//           if (value.isEmpty && index > 0) FocusScope.of(context).previousFocus();
//         },
//         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         inputFormatters: [
//           LengthLimitingTextInputFormatter(1),
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: EdgeInsets.zero,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppRadius.radius8),
//             borderSide: const BorderSide(color: Color(0xFFD1D1D1)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(AppRadius.radius8),
//             borderSide: BorderSide(color: AppSemanticColors.light.actionPrimaryDefault, width: 2),
//           ),
//         ),
//       ),
//     );
//   }
// }