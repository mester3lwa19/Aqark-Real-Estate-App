import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/router_generator.dart';

void main() {
  runApp(const AqarkApp());
}

class AqarkApp extends StatelessWidget {
  const AqarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqark',
      // Removes the "DEBUG" banner in the top right corner
      debugShowCheckedModeBanner: false,

      // Injecting the custom design system we created
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // 👉 CHANGED: Launch the app directly into the new Onboarding screen!
      initialRoute: AppRoutes.onboarding,
      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}