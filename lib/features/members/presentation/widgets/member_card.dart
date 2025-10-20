import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/member.dart';

/// A card widget displaying member information
class MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback? onTap;

  const MemberCard({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingHorizontal,
        vertical: AppSpacing.space2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.space2),
      ),
      child: ListTile(
        onTap: onTap,
        leading: _buildAvatar(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildAvatar() {
    if (member.avatarUrl != null && member.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: _avatarRadius,
        backgroundImage: NetworkImage(member.avatarUrl!),
      );
    }

    return CircleAvatar(
      radius: _avatarRadius,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        _getInitials(member.name),
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            member.name,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (member.role == _captainRole) ...[
          const SizedBox(width: AppSpacing.space2),
          _buildCaptainBadge(),
        ],
      ],
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'HCP: ${_formatHandicap(member.handicap)}',
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
    );
  }

  Widget _buildCaptainBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space2,
        vertical: AppSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.space1),
      ),
      child: Text(
        _captainRole,
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Extracts initials from a name (first letter of first and last name)
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0].substring(0, 1)}${parts[parts.length - 1].substring(0, 1)}'
        .toUpperCase();
  }

  /// Formats handicap to remove decimal if it's a whole number
  String _formatHandicap(double handicap) {
    if (handicap == handicap.toInt()) {
      return handicap.toInt().toString();
    }
    return handicap.toStringAsFixed(1);
  }

  // Constants
  static const double _cardElevation = 1.0;
  static const double _avatarRadius = 24.0;
  static const String _captainRole = 'CAPTAIN';
}
