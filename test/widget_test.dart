import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mulligans_law/main.dart';

void main() {
  testWidgets('App loads with welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MulligansLawApp());

    // Verify that our welcome screen is displayed.
    expect(find.text('Welcome to Mulligans Law'), findsOneWidget);
    expect(find.text('Track scores, compete with friends'), findsOneWidget);
    expect(find.byIcon(Icons.golf_course), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
