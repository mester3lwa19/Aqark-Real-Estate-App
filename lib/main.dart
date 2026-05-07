import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'core/di/service_locator.dart';
import 'core/network/sync_service.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/router_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup Dependency Injection
  await setupServiceLocator();

  // Start background sync listener
  GetIt.instance<SyncService>().start();

  // Check Onboarding status
  final prefs = GetIt.instance<SharedPreferences>();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // Check Auth state
  final auth = GetIt.instance<FirebaseAuth>();
  final bool isLoggedIn = auth.currentUser != null;

  runApp(AqarkApp(
    isFirstTime: isFirstTime,
    isLoggedIn: isLoggedIn,
  ));
}

class AqarkApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;

  const AqarkApp({
    super.key,
    required this.isFirstTime,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // --- SMART NAVIGATION ---
      // 1. First-time open: Onboarding
      // 2. Logged in: Home
      // 3. Not logged in: Signup/Login
      initialRoute: isFirstTime
          ? AppRoutes.onboarding
          : (isLoggedIn ? AppRoutes.mainHub : AppRoutes.signup),

      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}
