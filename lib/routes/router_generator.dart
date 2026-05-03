import 'package:flutter/material.dart';
import '../features/auth/presentation/login_screen.dart';
import 'app_routes.dart';
// Feature Imports
import '../features/auth/presentation/sign_up_screen.dart';
// import '../features/auth/presentation/sign_otp_screen.dart';
import '../features/auth/presentation/forget_password_screen.dart';
import '../features/auth/presentation/new_password_screen.dart';
import '../features/auth/presentation/success_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/properties/presentation/home_screen.dart';
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
      // case AppRoutes.otpVerification:
      //   return MaterialPageRoute(builder: (_) => const SignOtpScreen(userData: {},));
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
      // This screen will contain the BottomNavigationBar and swap between:
      // Home, Saved, Comparisons, Messages, Profile
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Main Hub (Bottom Nav)'));

    // ----------------------------------------
    // 3. PROPERTY FLOW
    // ----------------------------------------
      case AppRoutes.filter:
      // Often a bottom sheet, but can be a full screen
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Filter Options'));
      case AppRoutes.searchResults:
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Search Results / Empty State'));
      case AppRoutes.propertyDetails:
      // You would pass the Property object via arguments here
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Property Details'));

    // ----------------------------------------
    // 4. COMPARISON FLOW
    // ----------------------------------------
      case AppRoutes.selectToCompare:
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Select Properties to Compare'));
      case AppRoutes.comparisonResult:
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Comparison Results Table'));

    // ----------------------------------------
    // 5. PROFILE & MESSAGES EXPANSIONS
    // ----------------------------------------
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Edit Profile'));
      case AppRoutes.propertyAlerts:
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Property Alerts'));
      case AppRoutes.chatThread:
        return MaterialPageRoute(builder: (_) => _buildDummyScreen('Direct Chat Thread'));
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

    // ----------------------------------------
    // FALLBACK ROUTE
    // ----------------------------------------
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // A temporary helper to generate screens so your app compiles instantly.
  // Delete this and replace it with your actual screen imports as you build them.
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