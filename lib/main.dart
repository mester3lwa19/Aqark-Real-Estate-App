import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/router_generator.dart';

void main() async {
  // Ensure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- PERSISTENCE CHECK ---
  // On emulators, Firebase might need a millisecond to pull the token from disk.
  // We check the auth state before deciding where to send the user.
  final auth = FirebaseAuth.instance;

  // Optional: Small wait to ensure emulator disk read is complete
  // await Future.delayed(const Duration(milliseconds: 500));

  runApp(AqarkApp(isLoggedIn: auth.currentUser != null));
}

class AqarkApp extends StatelessWidget {
  final bool isLoggedIn;

  const AqarkApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // --- SMART NAVIGATION ---
      // If user session exists, go straight to Home.
      // Otherwise, start from onboarding/login.
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.onboarding,

      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}
