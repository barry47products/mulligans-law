import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Dashboard home screen showing activity overview and quick actions
///
/// Displays:
/// - Welcome header with user info
/// - Quick stats (societies, events, rounds, rank)
/// - Recent activity feed
/// - Quick action buttons
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const String _welcomePrefix = 'Welcome back';
  static const String _defaultName = 'Golfer';
  static const String _handicapLabel = 'Handicap';
  static const String _handicapPlaceholder = 'Not set';
  static const String _quickStatsTitle = 'Quick Stats';
  static const String _societiesLabel = 'Societies';
  static const String _eventsLabel = 'Events';
  static const String _roundsLabel = 'Rounds';
  static const String _rankLabel = 'Rank';
  static const String _recentActivityTitle = 'Recent Activity';
  static const String _noActivityMessage = 'No recent activity';
  static const String _quickActionsTitle = 'Quick Actions';
  static const String _mySocietiesButton = 'My Societies';
  static const String _startRoundButton = 'Start a Round';
  static const String _societiesRoute = '/societies';

  static const int _placeholderSocieties = 0;
  static const int _placeholderEvents = 0;
  static const int _placeholderRounds = 0;
  static const String _placeholderRank = 'N/A';

  static const double _avatarRadius = 32.0;
  static const double _gridCrossAxisSpacing = 12.0;
  static const double _gridMainAxisSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mulligans Law'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.space6),

            // Welcome Header
            _buildWelcomeHeader(context),

            const SizedBox(height: AppSpacing.space6),

            // Quick Stats
            _buildQuickStats(),

            const SizedBox(height: AppSpacing.space6),

            // Recent Activity
            _buildRecentActivity(),

            const SizedBox(height: AppSpacing.space6),

            // Quick Actions
            _buildQuickActions(context),

            const SizedBox(height: AppSpacing.space6),
          ],
        ),
      ),
    );
  }

  /// Build welcome header with user info
  Widget _buildWelcomeHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = _defaultName;
        String? userEmail;

        if (state is AuthAuthenticated) {
          userName = state.user.name ?? state.user.email.split('@')[0];
          userEmail = state.user.email;
        }

        return AppCard(
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: _avatarRadius,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  _getInitials(userName),
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space4),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_welcomePrefix, $userName!',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (userEmail != null) ...[
                      const SizedBox(height: AppSpacing.space1),
                      Text(
                        userEmail,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.space1),
                    Text(
                      '$_handicapLabel: $_handicapPlaceholder',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build quick stats section with 2x2 grid
  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _quickStatsTitle,
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: _gridCrossAxisSpacing,
          mainAxisSpacing: _gridMainAxisSpacing,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(_societiesLabel, _placeholderSocieties.toString()),
            _buildStatCard(_eventsLabel, _placeholderEvents.toString()),
            _buildStatCard(_roundsLabel, _placeholderRounds.toString()),
            _buildStatCard(_rankLabel, _placeholderRank),
          ],
        ),
      ],
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(String label, String value) {
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build recent activity section
  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _recentActivityTitle,
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        AppCard(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space6),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    _noActivityMessage,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build quick actions section
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _quickActionsTitle,
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: _mySocietiesButton,
                onPressed: () {
                  Navigator.of(context).pushNamed(_societiesRoute);
                },
              ),
              const SizedBox(height: AppSpacing.space3),
              AppButton(
                label: _startRoundButton,
                onPressed: () {
                  // TODO: Navigate to round creation
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get user initials from name
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
