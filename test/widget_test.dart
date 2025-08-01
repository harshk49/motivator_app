// This is a basic Flutter widget test for the Motivator App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:motivator_app/main.dart';

void main() {
  testWidgets('Motivator app loads without crashing',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MotivatorApp());

    // Verify that the app loads (look for loading indicator or content)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the quote to load
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Should have some quote content loaded
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
