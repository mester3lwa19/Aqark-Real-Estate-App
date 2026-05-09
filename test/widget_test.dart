import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aqark_futter_project/main.dart';
import 'package:aqark_futter_project/core/settings/settings_controller.dart';

// Minimal mock to satisfy the dependency in tests
class MockSettingsController extends ChangeNotifier implements SettingsController {
  @override
  ThemeMode get themeMode => ThemeMode.system;
  
  @override
  Locale get locale => const Locale('en');

  @override
  Future<void> loadSettings() async {}

  @override
  Future<void> updateThemeMode(bool isDark) async {}

  @override
  Future<void> updateLocale(String langCode) async {}
}

void main() {
  testWidgets('Aqark app builds smoke test', (WidgetTester tester) async {
    // Create a mock settings controller for the test
    final mockSettingsController = MockSettingsController();

    // Build our app and trigger a frame.
    // We provide initial state for the app parameters.
    await tester.pumpWidget(AqarkApp(
      isLoggedIn: false,
      isFirstTime: false,
      settingsController: mockSettingsController,
    ));

    // A simple test to verify the app booted up successfully
    // by checking that a MaterialApp exists in the widget tree.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
