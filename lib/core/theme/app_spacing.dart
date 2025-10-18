/// Spacing constants following an 8-point grid system.
///
/// Provides consistent spacing values throughout the application
/// for padding, margins, and component sizing.
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // Base spacing scale (8-point grid)
  static const double space0 = 0; // 0px
  static const double space1 = 4; // 4px - Tight elements
  static const double space2 = 8; // 8px - Compact spacing
  static const double space3 = 12; // 12px - Related items
  static const double space4 = 16; // 16px - Standard spacing
  static const double space5 = 20; // 20px - Screen padding
  static const double space6 = 24; // 24px - Section spacing
  static const double space7 = 32; // 32px - Large sections
  static const double space8 = 48; // 48px - Major divisions
  static const double space9 = 64; // 64px - Extra large

  // Specific use cases
  static const double screenPaddingHorizontal = 20;
  static const double screenPaddingVertical = 24;
  static const double cardPadding = 20;
  static const double listItemSpacing = 12;
  static const double buttonHeight = 48;
  static const double inputHeight = 48;
}
