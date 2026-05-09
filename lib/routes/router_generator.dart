import 'package:flutter/material.dart';
import '../features/auth/presentation/login_screen.dart';
import 'app_routes.dart';
// Feature Imports
import '../features/auth/presentation/sign_up_screen.dart';
import '../features/auth/presentation/sign_otp_screen.dart';
import '../features/auth/presentation/forget_password_screen.dart';
import '../features/auth/presentation/new_password_screen.dart';
import '../features/auth/presentation/success_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/properties/presentation/home_screen.dart';
import '../features/properties/presentation/property_details_screen.dart';
import '../features/properties/models/models.dart';
import '../features/main_hub_screen.dart';

import '../features/properties/presentation/search_screen.dart';

class RouterGenerator {
  static Route generateRoute(RouteSettings settings) {
    // You can extract arguments here for screens that need them
    // final args = settings.arguments;

    switch (settings.name) {
      // ----------------------------------------
      // 1. AUTH & ONBOARDING
      // ----------------------------------------
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.otpVerification:
        return MaterialPageRoute(builder: (_) => const SignOtpScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const NewPasswordScreen());
      case AppRoutes.passwordSuccess:
        return MaterialPageRoute(builder: (_) => const SuccessScreen());

      // ----------------------------------------
      // 2. MAIN HUB (Bottom Navigation)
      // ----------------------------------------
      case AppRoutes.mainHub:
        return MaterialPageRoute(builder: (_) => const MainHubScreen());

      // ----------------------------------------
      // 3. PROPERTY FLOW
      // ----------------------------------------
      case AppRoutes.filter:
        // Often a bottom sheet, but can be a full screen
        return MaterialPageRoute(
          builder: (_) => _buildDummyScreen('Filter Options'),
        );
      case AppRoutes.searchResults:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case AppRoutes.propertyDetails:
        final property = settings.arguments as Property;
        return MaterialPageRoute(
          builder: (_) => PropertyDetailsScreen(property: property),
        );

      // ----------------------------------------
      // 4. PROFILE & MESSAGES EXPANSIONS
      // ----------------------------------------
      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (_) => _buildDummyScreen('Edit Profile'),
        );
      case AppRoutes.propertyAlerts:
        return MaterialPageRoute(
          builder: (_) => _buildDummyScreen('Property Alerts'),
        );
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // ----------------------------------------
      // FALLBACK ROUTE
      // ----------------------------------------
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // A temporary helper to generate screens so your app compiles instantly.
  static Widget _buildDummyScreen(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Screen\nReplace me with the real UI!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
