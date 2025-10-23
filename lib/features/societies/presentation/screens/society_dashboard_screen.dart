import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/society.dart';
import '../../domain/entities/society_stats.dart';
import '../../domain/usecases/get_society_stats.dart';

/// Dashboard screen for a specific society showing overview and members
class SocietyDashboardScreen extends StatefulWidget {
  final Society society;
  final GetSocietyStats getSocietyStats;

  const SocietyDashboardScreen({
    super.key,
    required this.society,
    required this.getSocietyStats,
  });

  @override
  State<SocietyDashboardScreen> createState() => _SocietyDashboardScreenState();
}

class _SocietyDashboardScreenState extends State<SocietyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SocietyStats? _stats;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _loadStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await widget.getSocietyStats(widget.society.id);
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      // Default to empty stats on error
      if (mounted) {
        setState(() {
          _stats = const SocietyStats(
            memberCount: 0,
            ownerNames: [],
            captainNames: [],
            averageHandicap: 0.0,
          );
          _isLoadingStats = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDeleted = widget.society.deletedAt != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.society.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: _overviewTabLabel),
            Tab(text: _membersTabLabel),
          ],
        ),
      ),
      body: Column(
        children: [
          if (isDeleted) _buildDeletedBanner(),
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildOverviewTab(), _buildMembersTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeletedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.space3),
      color: AppColors.error.withValues(alpha: _deletedBannerOpacity),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.error,
            size: _deletedBannerIconSize,
          ),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            child: Text(
              _deletedBannerMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      color: AppColors.grey100,
      child: Row(
        children: [
          // Logo placeholder
          Container(
            width: _logoSize,
            height: _logoSize,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.space2),
            ),
            child: widget.society.logoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.space2),
                    child: Image.network(
                      widget.society.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildLogoPlaceholder(),
                    ),
                  )
                : _buildLogoPlaceholder(),
          ),
          const SizedBox(width: AppSpacing.space4),
          // Society details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.society.name,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.society.description != null) ...[
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    widget.society.description!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: _descriptionMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildOverviewTab() {
    final isDeleted = widget.society.deletedAt != null;

    if (_isLoadingStats) {
      return const Center(child: CircularProgressIndicator());
    }

    final stats = _stats!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.space4),
          Text(
            _statisticsLabel,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          // Statistics cards - Row 1
          Row(
            children: [
              Expanded(
                child: _buildStatisticCard(
                  title: _membersLabel,
                  value: stats.memberCount.toString(),
                  icon: Icons.people,
                ),
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: _buildStatisticCard(
                  title: _averageHandicapLabel,
                  value: stats.averageHandicap.toStringAsFixed(
                    _handicapDecimalPlaces,
                  ),
                  icon: Icons.golf_course,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          // Statistics cards - Row 2
          _buildRoleCard(
            title: _ownersLabel,
            names: stats.ownerNames,
            icon: Icons.star,
          ),
          const SizedBox(height: AppSpacing.space4),
          _buildRoleCard(
            title: _captainsLabel,
            names: stats.captainNames,
            icon: Icons.military_tech,
          ),
          const SizedBox(height: AppSpacing.space6),
          // Activity Feed Section
          Text(
            _activityFeedLabel,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          _buildActivityFeed(),
          const SizedBox(height: AppSpacing.space6),
          Text(
            _quickActionsLabel,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          // Quick action buttons
          _buildQuickActionButton(
            label: _viewMembersLabel,
            icon: Icons.people,
            onPressed: isDeleted
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      '/${widget.society.id}/members',
                      arguments: widget.society,
                    );
                  },
          ),
          const SizedBox(height: AppSpacing.space3),
          _buildQuickActionButton(
            label: _settingsLabel,
            icon: Icons.settings,
            onPressed: isDeleted
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      '/edit',
                      arguments: widget.society,
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.space2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: _statisticIconSize),
            const SizedBox(height: AppSpacing.space2),
            Text(
              value,
              style: AppTypography.displayLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space1),
            Text(
              title,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.space1),
              Text(
                subtitle,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required List<String> names,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.space2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: _roleIconSize),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    names.isEmpty ? _noRoleMembersLabel : names.join(', '),
                    style: AppTypography.bodyMedium.copyWith(
                      color: names.isEmpty
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontStyle: names.isEmpty ? FontStyle.italic : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityFeed() {
    // TODO: Wire up to real ActivityEventRepository when implemented
    final placeholderEvents = [
      _buildActivityItem(
        icon: Icons.person_add,
        title: _activityMemberJoined,
        timestamp: _activityPlaceholderTime,
      ),
      _buildActivityItem(
        icon: Icons.golf_course,
        title: _activityRoundCompleted,
        timestamp: _activityPlaceholderTime,
      ),
      _buildActivityItem(
        icon: Icons.military_tech,
        title: _activityRoleChanged,
        timestamp: _activityPlaceholderTime,
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.space2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _activityFeedPlaceholder,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            ...placeholderEvents,
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String timestamp,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: _activityIconSize),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  timestamp,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space4,
          ),
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: _emptyStateIconSize,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              _comingSoonLabel,
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              'Member management will be available soon',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Constants
  static const int _tabCount = 2;
  static const double _logoSize = 60.0;
  static const double _logoIconSize = 32.0;
  static const int _descriptionMaxLines = 2;
  static const double _statisticIconSize = 32.0;
  static const double _emptyStateIconSize = 80.0;
  static const double _roleIconSize = 24.0;
  static const double _activityIconSize = 20.0;
  static const double _deletedBannerIconSize = 20.0;
  static const double _deletedBannerOpacity = 0.1;
  static const int _handicapDecimalPlaces = 1;

  static const String _overviewTabLabel = 'Overview';
  static const String _membersTabLabel = 'Members';
  static const String _statisticsLabel = 'Statistics';
  static const String _membersLabel = 'Members';
  static const String _averageHandicapLabel = 'Avg Handicap';
  static const String _ownersLabel = 'Owners';
  static const String _captainsLabel = 'Captains';
  static const String _noRoleMembersLabel = 'None assigned';
  static const String _activityFeedLabel = 'Recent Activity';
  static const String _activityFeedPlaceholder =
      'Activity feed will show recent events when implemented';
  static const String _activityMemberJoined = 'New member joined the society';
  static const String _activityRoundCompleted =
      'Round completed at Example Golf Club';
  static const String _activityRoleChanged = 'Member role updated to Captain';
  static const String _activityPlaceholderTime = '2 hours ago';
  static const String _comingSoonLabel = 'Coming soon';
  static const String _quickActionsLabel = 'Quick Actions';
  static const String _viewMembersLabel = 'View Members';
  static const String _settingsLabel = 'Settings';
  static const String _deletedBannerMessage =
      'This society has been deleted and is read-only';
}
