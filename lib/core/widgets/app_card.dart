import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Reusable card component following the Mulligans Law design system.
///
/// Provides a consistent elevated surface with rounded corners and
/// optional tap interaction.
class AppCard extends StatelessWidget {
  /// The widget to display inside the card
  final Widget child;

  /// Optional custom padding (defaults to cardPadding if not provided)
  final EdgeInsets? padding;

  /// Optional tap callback to make the card interactive
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          child: child,
        ),
      ),
    );
  }
}
