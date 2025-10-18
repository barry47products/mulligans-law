import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mulligans_law/features/auth/presentation/screens/screens.dart';

void main() {
  testWidgets('Welcome screen displays correctly', (WidgetTester tester) async {
    // Build just the welcome screen to avoid Supabase initialization
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Verify that our welcome screen is displayed.
    expect(find.text('Welcome to Mulligans Law'), findsOneWidget);
    expect(find.text('Track scores, compete with friends'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
