import 'package:flutter/material.dart';
// Make sure these paths match your folder structure!
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routes/app_routes.dart';

// --- Data Model for the Screens ---
class OnboardingContent {
  final String imagePath;
  final String titleStart;
  final String titleHighlight;
  final String titleEnd;
  final String description;

  OnboardingContent({
    required this.imagePath,
    required this.titleStart,
    required this.titleHighlight,
    required this.titleEnd,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // The content matching your Figma design perfectly with plain text
  final List<OnboardingContent> _contents = [
    OnboardingContent(
      imagePath: 'assets/images/onboarding1.png',
      titleStart: 'Find Your Dream\nHome, ',
      titleHighlight: 'Effortlessly.',
      titleEnd: '',
      description:
          'Discover thousands of properties tailored to your budget. Filter by location, price, and flexible installment plans.',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding2.png',
      titleStart: '',
      titleHighlight: '100% ',
      titleEnd: 'Verified & Real\nListings.',
      description:
          'Say goodbye to fake ads and hidden prices. We verify properties and agents to guarantee a safe, transparent experience.',
    ),
    OnboardingContent(
      imagePath: 'assets/images/onboarding3.png',
      titleStart: 'Connect ',
      titleHighlight: 'Directly,\nInstantly.',
      titleEnd: '',
      description:
          'Found what you love? Call or WhatsApp the owner or verified broker directly with a single tap. No middleman delays.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  void _skipToLogin() async {
    await _completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _goToSignUp() async {
    await _completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.signup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // The scrollable PageView taking up the available space
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _contents.length,
              itemBuilder: (context, index) {
                return _buildPageContent(_contents[index], colorScheme);
              },
            ),
          ),

          // The Bottom Buttons Area
          Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing6),
            child: _currentPage == _contents.length - 1
                ? _buildFinalPageButtons(colorScheme)
                : _buildStandardButtons(colorScheme),
          ),
        ],
      ),
    );
  }

  // Helper to build the visual content of each page
  Widget _buildPageContent(OnboardingContent content, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Image
        Expanded(
          flex: 8,
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              content.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: colorScheme.secondary.withValues(alpha: 0.2),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ),

        // Text Content Area
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing6,
              vertical: AppSpacing.spacing6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTypography.createStyle(
                      fontSize: AppTypography.fontSize8,
                      fontWeight: AppTypography.weightBold,
                      lineHeight: AppTypography.lineHeight9,
                    ).copyWith(color: colorScheme.onSurface),
                    children: [
                      TextSpan(text: content.titleStart),
                      TextSpan(
                        text: content.titleHighlight,
                        style: TextStyle(color: colorScheme.primary),
                      ),
                      TextSpan(text: content.titleEnd),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing4),
                Text(
                  content.description,
                  style:
                      AppTypography.createStyle(
                        fontSize: AppTypography.fontSize4,
                        fontWeight: AppTypography.weightNormal,
                        lineHeight: AppTypography.lineHeight6,
                      ).copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Buttons for Pages 1 and 2
  Widget _buildStandardButtons(ColorScheme colorScheme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next',
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize4,
                    fontWeight: AppTypography.weightSemiBold,
                    lineHeight: AppTypography.lineHeight6,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing2),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        TextButton(
          onPressed: _skipToLogin,
          style: TextButton.styleFrom(foregroundColor: colorScheme.onSurface),
          child: Text(
            'Skip',
            style: AppTypography.createStyle(
              fontSize: AppTypography.fontSize4,
              fontWeight: AppTypography.weightSemiBold,
              lineHeight: AppTypography.lineHeight6,
            ),
          ),
        ),
      ],
    );
  }

  // Buttons for the Final Page (Sign Up / Login / Guest)
  Widget _buildFinalPageButtons(ColorScheme colorScheme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _goToSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              ),
            ),
            child: Text(
              'Sign Up',
              style: AppTypography.createStyle(
                fontSize: AppTypography.fontSize4,
                fontWeight: AppTypography.weightSemiBold,
                lineHeight: AppTypography.lineHeight6,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: _skipToLogin,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              ),
            ),
            child: Text(
              'Login',
              style: AppTypography.createStyle(
                fontSize: AppTypography.fontSize4,
                fontWeight: AppTypography.weightSemiBold,
                lineHeight: AppTypography.lineHeight6,
              ).copyWith(color: colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing3),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.mainHub);
          },
          style: TextButton.styleFrom(foregroundColor: colorScheme.onSurface),
          child: Text(
            'Continue as a Guest',
            style: AppTypography.createStyle(
              fontSize: AppTypography.fontSize3,
              fontWeight: AppTypography.weightSemiBold,
              lineHeight: AppTypography.lineHeight4,
            ),
          ),
        ),
      ],
    );
  }
}
