import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/society.dart';

/// Card widget displaying society information with member count and action button
class SocietyCard extends StatelessWidget {
  final Society society;
  final int memberCount;
  final VoidCallback onViewPressed;

  const SocietyCard({
    super.key,
    required this.society,
    required this.memberCount,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.space2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            _buildLogo(),
            const SizedBox(width: AppSpacing.space4),
            Expanded(child: _buildDetails()),
            const SizedBox(width: AppSpacing.space3),
            _buildViewButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: _logoSize,
      height: _logoSize,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSpacing.space2),
      ),
      child: society.logoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.space2),
              child: Image.network(
                society.logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildLogoPlaceholder(),
              ),
            )
          : _buildLogoPlaceholder(),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Center(
      child: Icon(
        Icons.golf_course,
        size: _logoIconSize,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          society.name,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.space1),
        Text(
          _memberCountText,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (society.description != null) ...[
          const SizedBox(height: AppSpacing.space1),
          Text(
            society.description!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: _descriptionMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildViewButton() {
    return SizedBox(
      width: 80,
      child: ElevatedButton(
        onPressed: onViewPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space2,
          ),
        ),
        child: const Text(_viewButtonText),
      ),
    );
  }

  String get _memberCountText {
    if (memberCount == 1) {
      return '$memberCount member';
    }
    return '$memberCount members';
  }

  // Constants
  static const double _logoSize = 60.0;
  static const double _logoIconSize = 32.0;
  static const int _descriptionMaxLines = 2;
  static const String _viewButtonText = 'View';
}
