import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Events landing screen - placeholder for future event management features
///
/// This screen will eventually display:
/// - Upcoming society events
/// - Event calendar
/// - Tee time bookings
/// - Tournament management
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  static const String _title = 'Events';
  static const String _comingSoonTitle = 'Events coming soon';
  static const String _comingSoonDescription =
      'Track society events, book tee times, and manage tournaments';

  static const double _iconSize = 64.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(_title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event,
                size: _iconSize,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                _comingSoonTitle,
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space2),
              Text(
                _comingSoonDescription,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
