import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../members/domain/usecases/get_member_count.dart';
import '../../domain/entities/society.dart';

/// Dashboard screen for a specific society showing overview and members
class SocietyDashboardScreen extends StatefulWidget {
  final Society society;
  final GetMemberCount getMemberCount;

  const SocietyDashboardScreen({
    super.key,
    required this.society,
    required this.getMemberCount,
  });

  @override
  State<SocietyDashboardScreen> createState() => _SocietyDashboardScreenState();
}

class _SocietyDashboardScreenState extends State<SocietyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _memberCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _loadMemberCount();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMemberCount() async {
    try {
      final count = await widget.getMemberCount(widget.society.id);
      if (mounted) {
        setState(() {
          _memberCount = count;
        });
      }
    } catch (e) {
      // Default to 0 on error
      if (mounted) {
        setState(() {
          _memberCount = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Statistics cards
          Row(
            children: [
              Expanded(
                child: _buildStatisticCard(
                  title: _membersLabel,
                  value: _memberCount.toString(),
                  icon: Icons.people,
                ),
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: _buildStatisticCard(
                  title: _eventsLabel,
                  value: '0',
                  subtitle: _comingSoonLabel,
                  icon: Icons.event,
                ),
              ),
            ],
          ),
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
            onPressed: () {
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
            onPressed: () {
              Navigator.pushNamed(context, '/edit', arguments: widget.society);
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

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
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

  static const String _overviewTabLabel = 'Overview';
  static const String _membersTabLabel = 'Members';
  static const String _statisticsLabel = 'Statistics';
  static const String _membersLabel = 'Members';
  static const String _eventsLabel = 'Events';
  static const String _comingSoonLabel = 'Coming soon';
  static const String _quickActionsLabel = 'Quick Actions';
  static const String _viewMembersLabel = 'View Members';
  static const String _settingsLabel = 'Settings';
}
