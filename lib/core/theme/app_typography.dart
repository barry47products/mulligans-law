import 'package:flutter/material.dart';

/// Typography system for the Mulligans Law application.
///
/// Defines text styles following Material 3 type scale with custom
/// specifications for readability in outdoor/bright conditions.
class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  /// Primary font family (Inter)
  static const String fontFamily = 'Inter';

  /// Fallback font family (Roboto - built into Flutter)
  static const String fontFamilyFallback = 'Roboto';

  // Display - Leaderboards, major headings
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.25,
    fontFamily: fontFamily,
    fontFamilyFallback: [fontFamilyFallback],
  );

  // Headlines - Screen titles, section headers
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    fontFamily: fontFamily,
    fontFamilyFallback: [fontFamilyFallback],
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
    fontFamily: fontFamily,
    fontFamilyFallback: [fontFamilyFallback],
  );

  // Body - Content, descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    fontFamily: fontFamily,
    fontFamilyFallback: [fontFamilyFallback],
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    fontFamily: fontFamily,
    fontFamilyFallback: [fontFamilyFallback],
  );

  // Labels - Buttons, inputs, chips
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    fontFamily: fontFamily,
    fontFamilyFallback: [fontFamilyFallback],
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    fontFamily: fontFamily,
    fontFamilyFallback: [fontFamilyFallback],
  );
}
