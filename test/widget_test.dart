import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aqark_futter_project/main.dart';

void main() {
  testWidgets('Aqark app builds smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We provide initial state for the app parameters.
    await tester.pumpWidget(const AqarkApp(
      isLoggedIn: false,
      isFirstTime: false,
    ));

    // A simple test to verify the app booted up successfully
    // by checking that a MaterialApp exists in the widget tree.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
