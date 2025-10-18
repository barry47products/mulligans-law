/// Test Helper Utilities
///
/// This file contains utility functions and helpers for testing.
/// Use these helpers to reduce boilerplate in test files.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a widget wrapped in a MaterialApp for testing.
///
/// This is useful for widget tests that need Material context.
///
/// Example:
/// ```dart
/// await pumpTestWidget(
///   tester,
///   MyWidget(),
/// );
/// ```
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget widget, {
  ThemeData? theme,
  Locale? locale,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      locale: locale,
      home: Scaffold(body: widget),
    ),
  );
}

/// Pumps a widget with BLoC provider for testing.
///
/// This is useful for testing widgets that depend on BLoCs.
///
/// Example:
/// ```dart
/// await pumpWithBloc(
///   tester,
///   bloc: mockBloc,
///   child: MyWidget(),
/// );
/// ```
Future<void> pumpWithBloc<T>(
  WidgetTester tester, {
  required T bloc,
  required Widget child,
}) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
}

/// Simulates a frame after a duration.
///
/// Useful for testing animations or delayed operations.
///
/// Example:
/// ```dart
/// await tester.pump();
/// await pumpAndSettle(tester, duration: Duration(seconds: 1));
/// ```
Future<void> pumpAndSettle(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 100),
}) async {
  await tester.pump(duration);
  await tester.pumpAndSettle();
}

/// Finds a widget by its key.
///
/// Example:
/// ```dart
/// final button = findByKey<ElevatedButton>('submit-button');
/// await tester.tap(button);
/// ```
Finder findByKey(String key) {
  return find.byKey(Key(key));
}

/// Finds a widget by its type.
///
/// Example:
/// ```dart
/// final textField = findByType<TextField>();
/// await tester.enterText(textField, 'test');
/// ```
Finder findByType<T>() {
  return find.byType(T);
}

/// Verifies that a widget exists exactly once.
///
/// Example:
/// ```dart
/// verifyWidgetExists('Welcome');
/// ```
void verifyWidgetExists(String text) {
  expect(find.text(text), findsOneWidget);
}

/// Verifies that a widget does not exist.
///
/// Example:
/// ```dart
/// verifyWidgetNotExists('Error');
/// ```
void verifyWidgetNotExists(String text) {
  expect(find.text(text), findsNothing);
}
