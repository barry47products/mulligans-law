import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Profile landing screen showing user information and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _title = 'Profile';
  static const String _handicapNotSet = 'Not set';
  static const String _editProfileLabel = 'Edit Profile';
  static const String _settingsLabel = 'Settings';
  static const String _signOutLabel = 'Sign Out';
  static const String _comingSoonMessage = 'Coming soon';
  static const double _avatarRadius = 50.0;
  static const int _snackbarDurationSeconds = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: Text('Not authenticated'));
          }

          final user = state.user;
          final initials = _getInitials(user.email);

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.space8),
                // Avatar
                CircleAvatar(
                  radius: _avatarRadius,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    initials,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                // Name (from email for now)
                Text(user.email, style: AppTypography.headlineMedium),
                const SizedBox(height: AppSpacing.space2),
                // Email
                Text(
                  user.email,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2),
                // Handicap placeholder
                Text(
                  'Handicap: $_handicapNotSet',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.space8),
                // Menu options
                _buildMenuSection(context),
                const SizedBox(height: AppSpacing.space8),
                // Sign out button
                _buildSignOutButton(context),
                const SizedBox(height: AppSpacing.space8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text(_editProfileLabel),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showComingSoon(context),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text(_settingsLabel),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showComingSoon(context),
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingHorizontal,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthSignOutRequested());
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: BorderSide(color: AppColors.error),
            padding: const EdgeInsets.all(AppSpacing.space4),
          ),
          child: const Text(_signOutLabel),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(_comingSoonMessage),
        duration: Duration(seconds: _snackbarDurationSeconds),
      ),
    );
  }

  String _getInitials(String email) {
    if (email.isEmpty) return '?';

    // Get first letter of email (before @)
    final username = email.split('@').first;
    if (username.isEmpty) return '?';

    // Get first two letters if available
    if (username.length >= 2) {
      return username.substring(0, 2).toUpperCase();
    }

    return username[0].toUpperCase();
  }
}
