import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Leaderboard landing screen - placeholder for future rankings and statistics
///
/// This screen will eventually display:
/// - Society leaderboards
/// - Player rankings
/// - Performance statistics
/// - Competition standings
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const String _title = 'Leaderboard';
  static const String _comingSoonTitle = 'Leaderboards coming soon';
  static const String _comingSoonDescription =
      'View rankings, statistics, and compete with society members';

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
                Icons.leaderboard,
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
