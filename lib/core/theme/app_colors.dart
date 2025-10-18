import 'package:flutter/material.dart';

/// Application color palette following the Mulligans Law design system.
///
/// All colors are defined using the 0xFF prefix for Flutter's Color class.
/// Hex values match the design system specification.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Brand colors - Golf-inspired greens
  static const Color primary = Color(0xFF4CD4B0); // Mint green
  static const Color primaryDark = Color(0xFF3AB895); // Darker mint
  static const Color primaryLight = Color(0xFF6FE4C8); // Light mint

  // Surface colors
  static const Color background = Color(0xFFF8F9FB); // Light grey-blue
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Off-white

  // Text colors
  static const Color textPrimary = Color(0xFF2D3436); // Dark charcoal
  static const Color textSecondary = Color(0xFF636E72); // Medium grey
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  static const Color textDisabled = Color(0xFFB0B0B0); // Light grey

  // Semantic colors
  static const Color success = Color(0xFF27AE60); // Green
  static const Color error = Color(0xFFE74C3C); // Red
  static const Color warning = Color(0xFFF39C12); // Orange
  static const Color info = Color(0xFF3498DB); // Blue

  // Golf-specific colors
  static const Color birdie = Color(0xFF4CAF50); // Green
  static const Color eagle = Color(0xFF2E7D32); // Dark green
  static const Color par = Color(0xFF9E9E9E); // Grey
  static const Color bogey = Color(0xFFFF9800); // Orange
  static const Color doubleBogey = Color(0xFFE74C3C); // Red

  // Neutral greys
  static const Color grey100 = Color(0xFFF5F5F5); // Grey 100
  static const Color grey200 = Color(0xFFEEEEEE); // Grey 200
  static const Color grey300 = Color(0xFFE0E0E0); // Grey 300
  static const Color grey400 = Color(0xFFBDBDBD); // Grey 400
  static const Color grey500 = Color(0xFF9E9E9E); // Grey 500
}
