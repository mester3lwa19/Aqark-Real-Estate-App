class AppRoutes {
  // --- Auth & Onboarding Flow ---
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  // static const String otpVerification = '/otp_verification';
  static const String forgotPassword = '/forgot_password';
  static const String resetPassword = '/reset_password';
  static const String passwordSuccess = '/password_success';

  // --- Main Hub & Testing ---
  static const String mainHub = '/main_hub';
  static const String home = '/home'; // ADD THIS LINE FOR TESTING

  // --- Property Flow ---
  static const String filter = '/filter';
  static const String searchResults = '/search_results';
  static const String propertyDetails = '/property_details';

  // --- Comparison Flow ---
  static const String selectToCompare = '/select_to_compare';
  static const String comparisonResult = '/comparison_result';

  // --- Profile & Settings Flow ---
  static const String editProfile = '/edit_profile';
  static const String propertyAlerts = '/property_alerts';

  // --- Chat Flow ---
  static const String chatThread = '/chat_thread';
}
