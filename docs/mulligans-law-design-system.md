# Mulligans Law Base Design System

## Overview

Initial design system implementation for the Mulligans Law Flutter application. This document defines the foundational theme configuration and reusable components for the golf score tracking app.

## Project Context

- **Framework:** Flutter 3.0+
- **Architecture:** Clean Architecture with BLoC pattern
- **Backend:** Supabase
- **Database:** Drift (local) + Supabase (remote)
- **Development Approach:** TDD with AI-assisted development

## Core Design Principles

### Visual Principles

- **Clarity First:** High contrast and legibility for outdoor/bright conditions
- **Minimal Interaction:** Reduce taps needed during active play
- **Friendly Competition:** Approachable design that encourages social interaction
- **Consistent Spacing:** 8-point grid system throughout

### Technical Principles

- **Offline-First:** All UI components work without connectivity
- **Accessibility:** WCAG 2.1 Level AA compliance
- **Performance:** Smooth 60fps animations, < 100ms touch response
- **Responsive:** Mobile-first, tablet-ready

## Implementation Structure

```dart
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart         // Main theme configuration
│   │   ├── app_colors.dart        // Colour constants
│   │   ├── app_typography.dart    // Text styles
│   │   ├── app_spacing.dart       // Spacing constants
│   │   └── app_shadows.dart       // Elevation and shadows
│   └── widgets/
│       ├── app_card.dart          // Reusable card component
│       ├── app_button.dart        // Button variations
│       ├── app_text_field.dart    // Form inputs
│       └── app_loading.dart       // Loading indicators
```

## Colour System

### Primary Palette

```dart
class AppColors {
  // Brand colours - Golf-inspired greens
  static const Color primary = Color(0xFF4CD4B0);        // Mint green
  static const Color primaryDark = Color(0xFF3AB895);    // Darker mint
  static const Color primaryLight = Color(0xFF6FE4C8);   // Light mint

  // Surface colours
  static const Color background = Color(0xFFF8F9FB);     // Light grey-blue
  static const Color surface = Color(0xFFFFFFFF);        // Pure white
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Off-white

  // Text colours
  static const Color textPrimary = Color(0xFF2D3436);    // Dark charcoal
  static const Color textSecondary = Color(0xFF636E72);  // Medium grey
  static const Color textOnPrimary = Color(0xFFFFFFFF);  // White
  static const Color textDisabled = Color(0xFFB0B0B0);   // Light grey

  // Semantic colours
  static const Color success = Color(0xFF27AE60);        // Green
  static const Color error = Color(0xFFE74C3C);          // Red
  static const Color warning = Color(0xFFF39C12);        // Orange
  static const Color info = Color(0xFF3498DB);           // Blue

  // Golf-specific colours
  static const Color birdie = Color(0xFF4CAF50);         // Green
  static const Color eagle = Color(0xFF2E7D32);          // Dark green
  static const Color par = Color(0xFF9E9E9E);            // Grey
  static const Color bogey = Color(0xFFFF9800);          // Orange
  static const Color doubleBogey = Color(0xFFE74C3C);    // Red

  // Neutral greys
  static const Color grey100 = Color(0xFFF5F5F5);        // Grey 100
  static const Color grey200 = Color(0xFFEEEEEE);        // Grey 200
  static const Color grey300 = Color(0xFFE0E0E0);        // Grey 300
  static const Color grey400 = Color(0xFFBDBDBD);        // Grey 400
  static const Color grey500 = Color(0xFF9E9E9E);        // Grey 500
}
```

## Typography System

### Type Scale

```dart
class AppTypography {
  static const String fontFamily = 'Inter';
  static const String fontFamilyFallback = 'Roboto';

  // Display - Leaderboards, major headings
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.25,
  );

  // Headlines - Screen titles, section headers
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Body - Content, descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  // Labels - Buttons, inputs, chips
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );
}
```

## Spacing System

### 8-Point Grid

```dart
class AppSpacing {
  static const double space0 = 0;     // 0px
  static const double space1 = 4;     // 4px - Tight elements
  static const double space2 = 8;     // 8px - Compact spacing
  static const double space3 = 12;    // 12px - Related items
  static const double space4 = 16;    // 16px - Standard spacing
  static const double space5 = 20;    // 20px - Screen padding
  static const double space6 = 24;    // 24px - Section spacing
  static const double space7 = 32;    // 32px - Large sections
  static const double space8 = 48;    // 48px - Major divisions
  static const double space9 = 64;    // 64px - Extra large

  // Specific use cases
  static const double screenPaddingHorizontal = 20;
  static const double screenPaddingVertical = 24;
  static const double cardPadding = 20;
  static const double listItemSpacing = 12;
  static const double buttonHeight = 48;
  static const double inputHeight = 48;
}
```

## Component Specifications

### Base Card Component

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const AppCard({
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding ?? EdgeInsets.all(AppSpacing.cardPadding),
          child: child,
        ),
      ),
    );
  }
}
```

### Primary Button

```dart
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        minimumSize: Size(
          isFullWidth ? double.infinity : 0,
          AppSpacing.buttonHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.textOnPrimary,
                ),
              ),
            )
          : Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
    );
  }
}
```

### Text Input Field

```dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary.withOpacity(0.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space3,
        ),
      ),
    );
  }
}
```

## Theme Configuration

### Light Theme

```dart
ThemeData createLightTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,

    // Colour scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      secondary: AppColors.primaryLight,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
    ),

    // Scaffold background
    scaffoldBackgroundColor: AppColors.background,

    // AppBar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: AppTypography.headlineMedium.copyWith(
        color: AppColors.textPrimary,
      ),
    ),

    // Card theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.surface,
      shadowColor: Colors.black.withOpacity(0.06),
      margin: EdgeInsets.symmetric(
        vertical: AppSpacing.space2,
        horizontal: AppSpacing.space5,
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey300),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space3,
      ),
    ),
  );
}
```

## Accessibility Guidelines

### Minimum Requirements

- **Text Contrast:** 4.5:1 for normal text, 3:1 for large text
- **Touch Targets:** Minimum 48x48px
- **Focus Indicators:** 2px minimum border width
- **Screen Reader Support:** All interactive elements must have semantic labels

### Implementation Checklist

- [ ] All colours meet WCAG AA contrast requirements
- [ ] Interactive elements are minimum 48x48px
- [ ] Focus states are clearly visible
- [ ] Semantic labels provided for icons
- [ ] Text can scale to 200% without breaking layout
- [ ] Animations respect `MediaQuery.disableAnimations`

## Usage in Features

### Score Capture Example

```dart
class ScoreCaptureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hole 1 - Par 4'),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          children: [
            AppCard(
              child: Column(
                children: [
                  Text(
                    'Enter your score',
                    style: AppTypography.headlineMedium,
                  ),
                  SizedBox(height: AppSpacing.space4),
                  // Score input buttons here
                ],
              ),
            ),
            SizedBox(height: AppSpacing.space6),
            AppButton(
              label: 'Next Hole',
              onPressed: () {
                // Navigate to next hole
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

## Next Steps

### Phase 1 Implementation

1. Create base theme files in `lib/core/theme/`
2. Implement reusable components in `lib/core/widgets/`
3. Apply theme to main.dart
4. Test with sample screens

### Future Enhancements

- Dark mode support
- Landscape tablet layouts
- Custom animations
- Golf-specific components (scorecard, leaderboard tiles)
- Weather-aware themes

## Resources

- [Flutter Material 3 Guidelines](https://m3.material.io/)
- [WCAG 2.1 Standards](https://www.w3.org/WAI/WCAG21/quickref/)
- [Project Repository](https://github.com/barry47products/mulligans-law)

---

_Version 1.0.0 - Base Design System_  
_Last Updated: October 2025_  
_Compatible with Flutter 3.0+_
