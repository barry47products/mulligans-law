import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../members/domain/usecases/get_member_count.dart';
import '../../../members/domain/usecases/request_to_join_society.dart';
import '../../domain/entities/society.dart';
import '../bloc/society_bloc.dart';
import '../bloc/society_event.dart';
import '../bloc/society_state.dart';

/// Widget displaying public societies that users can discover and join
class DiscoverSocietiesTab extends StatefulWidget {
  const DiscoverSocietiesTab({super.key});

  @override
  State<DiscoverSocietiesTab> createState() => _DiscoverSocietiesTabState();
}

class _DiscoverSocietiesTabState extends State<DiscoverSocietiesTab> {
  final Map<String, int> _memberCounts = {};
  late final GetMemberCount _getMemberCount;
  late final RequestToJoinSociety _requestToJoinSociety;

  @override
  void initState() {
    super.initState();
    _getMemberCount = context.read<GetMemberCount>();
    _requestToJoinSociety = context.read<RequestToJoinSociety>();
  }

  Future<void> _loadMemberCounts(List<Society> societies) async {
    for (final society in societies) {
      if (!_memberCounts.containsKey(society.id)) {
        try {
          final count = await _getMemberCount(society.id);
          if (mounted) {
            setState(() {
              _memberCounts[society.id] = count;
            });
          }
        } catch (e) {
          // If we can't load member count, default to 0
          if (mounted) {
            setState(() {
              _memberCounts[society.id] = 0;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocietyBloc, SocietyState>(
      builder: (context, state) {
        if (state is SocietyLoadingPublic) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SocietyError) {
          return _buildErrorState(state.message);
        }

        if (state is SocietyPublicLoaded) {
          if (state.publicSocieties.isEmpty) {
            return _buildEmptyState();
          }
          return _buildSocietyList(state.publicSocieties);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSocietyList(List<Society> societies) {
    // Schedule member counts to load after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMemberCounts(societies);
    });

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      itemCount: societies.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.listItemSpacing),
      itemBuilder: (context, index) {
        final society = societies[index];
        return _buildSocietyCard(society);
      },
    );
  }

  Widget _buildSocietyCard(Society society) {
    final memberCount = _memberCounts[society.id] ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.space3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and member count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    society.name,
                    style: AppTypography.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space2,
                    vertical: AppSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.space3),
                  ),
                  child: Text(
                    '$memberCount members',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            // Description
            if (society.description != null) ...[
              const SizedBox(height: AppSpacing.space2),
              Text(
                society.description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Handicap info
            if (society.handicapLimitEnabled &&
                society.handicapMin != null &&
                society.handicapMax != null) ...[
              const SizedBox(height: AppSpacing.space2),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.info),
                  const SizedBox(width: AppSpacing.space1),
                  Text(
                    'Handicap range: ${society.handicapMin} - ${society.handicapMax}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],

            // Request to Join button
            const SizedBox(height: AppSpacing.space4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _requestToJoin(society),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.space2),
                  ),
                ),
                child: const Text('Request to Join'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.space6),
            Text(
              'No public societies available',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              'Check back later for societies you can join',
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

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: AppColors.error),
            const SizedBox(height: AppSpacing.space6),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space6),
            ElevatedButton(
              onPressed: () {
                // TODO: Retry loading public societies
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestToJoin(Society society) async {
    try {
      // Get current user ID from AuthBloc
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        throw Exception('User not authenticated');
      }
      final userId = authState.user.id;

      // Call RequestToJoinSociety use case
      // Note: Handicap validation is handled inside the use case
      await _requestToJoinSociety(userId: userId, societyId: society.id);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Join request sent to ${society.name}! '
              'You\'ll be notified when a captain approves.',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        // Refresh public societies list to remove the joined society
        context.read<SocietyBloc>().add(const SocietyLoadPublicRequested());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send join request: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
