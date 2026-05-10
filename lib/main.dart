import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'core/di/service_locator.dart';
import 'core/network/sync_service.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/router_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/settings/settings_controller.dart';

void main() async {
  // Ensure Flutter engine is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup Dependency Injection
  await setupServiceLocator();

  // Load Settings
  final settingsController = GetIt.instance<SettingsController>();
  await settingsController.loadSettings();

  // Start background sync listener
  GetIt.instance<SyncService>().start();

  // Check Onboarding status
  final prefs = GetIt.instance<SharedPreferences>();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(AqarkApp(
    isFirstTime: isFirstTime,
    settingsController: settingsController,
  ));
}

class AqarkApp extends StatelessWidget {
  final bool isFirstTime;
  final SettingsController settingsController;

  const AqarkApp({
    super.key,
    required this.isFirstTime,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Aqark',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsController.themeMode,
          locale: settingsController.locale,

          // --- SMART NAVIGATION ---
          initialRoute: isFirstTime
              ? AppRoutes.onboarding
              : AppRoutes.authWrapper,

          onGenerateRoute: RouterGenerator.generateRoute,
        );
      },
    );
  }
}
