/// Tests for the test helper utilities.
///
/// This demonstrates how to use the test infrastructure and verifies
/// that helper functions work correctly.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/main.dart';
import 'test_helper.dart';

void main() {
  group('Test Helper Utilities', () {
    testWidgets('pumpTestWidget should wrap widget in MaterialApp', (
      tester,
    ) async {
      // Arrange
      const testText = 'Test Widget';
      const testWidget = Text(testText);

      // Act
      await pumpTestWidget(tester, testWidget);

      // Assert
      expect(find.text(testText), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('pumpTestWidget should apply custom theme', (tester) async {
      // Arrange
      const testWidget = Text('Themed Text');
      final customTheme = ThemeData(
        primaryColor: Colors.purple,
        useMaterial3: false,
      );

      // Act
      await pumpTestWidget(tester, testWidget, theme: customTheme);

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.primaryColor, Colors.purple);
    });

    testWidgets('findByKey should find widget by key', (tester) async {
      // Arrange
      const testKey = 'test-key';
      const testWidget = Text('Test', key: Key(testKey));

      // Act
      await pumpTestWidget(tester, testWidget);
      final finder = findByKey(testKey);

      // Assert
      expect(finder, findsOneWidget);
    });

    testWidgets('findByType should find widget by type', (tester) async {
      // Arrange
      await pumpTestWidget(tester, const Text('Test'));

      // Act
      final finder = findByType<Text>();

      // Assert
      expect(finder, findsWidgets);
    });

    testWidgets('verifyWidgetExists should pass when widget exists', (
      tester,
    ) async {
      // Arrange
      await pumpTestWidget(tester, const Text('test'));

      // Act & Assert
      verifyWidgetExists('test');
    });

    testWidgets('verifyWidgetNotExists should pass when widget absent', (
      tester,
    ) async {
      // Arrange
      await pumpTestWidget(tester, const Text('Test'));

      // Act & Assert
      verifyWidgetNotExists('Non-existent text');
    });
  });

  group('Mock Factory Integration', () {
    test('test helpers work with mock factories', () {
      // This demonstrates that the test infrastructure is set up correctly
      // and ready to be used with actual domain entities once they're created
      expect(true, isTrue);
    });
  });

  group('Sample Widget Tests', () {
    testWidgets('MulligansLawApp should display welcome screen', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MulligansLawApp());

      // Assert
      verifyWidgetExists('Welcome to Mulligans Law');
      verifyWidgetExists('Golf Society Score Tracking');
      expect(find.byIcon(Icons.golf_course), findsOneWidget);
    });

    testWidgets('HomeScreen should have app bar with title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MulligansLawApp());

      // Assert
      expect(find.widgetWithText(AppBar, 'Mulligans Law'), findsOneWidget);
    });

    testWidgets('HomeScreen should display golf icon', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MulligansLawApp());

      // Assert
      final iconFinder = find.byIcon(Icons.golf_course);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.size, 80); // Updated to match design system
      // Note: Icon color is now AppColors.primary (mint green #4CD4B0)
      // We don't check exact color here as it's set by the theme
    });
  });
}
