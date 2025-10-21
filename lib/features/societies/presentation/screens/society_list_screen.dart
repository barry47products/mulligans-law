import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../members/domain/usecases/get_member_count.dart';
import '../../domain/entities/society.dart';
import '../bloc/society_bloc.dart';
import '../bloc/society_event.dart';
import '../bloc/society_state.dart';
import '../widgets/society_card.dart';

/// Screen displaying list of user's societies
class SocietyListScreen extends StatefulWidget {
  const SocietyListScreen({super.key});

  static const String routeName = '/societies';

  @override
  State<SocietyListScreen> createState() => _SocietyListScreenState();
}

class _SocietyListScreenState extends State<SocietyListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, int> _memberCounts = {};
  late final GetMemberCount _getMemberCount;

  @override
  void initState() {
    super.initState();
    _getMemberCount = context.read<GetMemberCount>();
    // Load societies on init
    context.read<SocietyBloc>().add(const SocietyLoadRequested());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Societies'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SocietyBloc, SocietyState>(
        listener: (context, state) {
          if (state is SocietyOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SocietyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SocietyError) {
            return _buildErrorState(state.message);
          }

          if (state is SocietyLoaded) {
            if (state.societies.isEmpty) {
              return _buildEmptyState();
            }
            return _buildSocietyList(state.societies);
          }

          if (state is SocietyOperationSuccess) {
            if (state.societies.isEmpty) {
              return _buildEmptyState();
            }
            return _buildSocietyList(state.societies);
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateSociety,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSocietyList(List<Society> societies) {
    // Schedule member counts to load after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMemberCounts(societies);
    });

    final filteredSocieties = _filterSocieties(societies);

    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: filteredSocieties.isEmpty
              ? _buildNoResultsState()
              : ListView.separated(
                  padding: const EdgeInsets.all(
                    AppSpacing.screenPaddingHorizontal,
                  ),
                  itemCount: filteredSocieties.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.listItemSpacing),
                  itemBuilder: (context, index) {
                    final society = filteredSocieties[index];
                    return _buildSocietyCard(society);
                  },
                ),
        ),
      ],
    );
  }

  List<Society> _filterSocieties(List<Society> societies) {
    if (_searchQuery.isEmpty) {
      return societies;
    }
    return societies
        .where(
          (society) =>
              society.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _searchHintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.space2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space3,
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: _emptyStateIconSize,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.space6),
            Text(
              _noResultsMessage,
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              'Try adjusting your search',
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

  Widget _buildSocietyCard(Society society) {
    final memberCount = _memberCounts[society.id] ?? 0;

    return SocietyCard(
      society: society,
      memberCount: memberCount,
      onViewPressed: () => _onSocietyTapped(society),
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
              Icons.golf_course_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.space6),
            Text(
              "You're not a member of any societies yet",
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              'Create your first society to get started',
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
                context.read<SocietyBloc>().add(const SocietyLoadRequested());
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

  void _onSocietyTapped(Society society) {
    context.read<SocietyBloc>().add(SocietySelected(society.id));
    // Navigate to society dashboard (relative path within Societies tab)
    Navigator.pushNamed(
      context,
      '/${society.id}/dashboard',
      arguments: society,
    );
  }

  void _navigateToCreateSociety() {
    // Navigate to create form (relative path within Societies tab)
    Navigator.pushNamed(context, '/create');
  }

  // Constants
  static const String _searchHintText = 'Search societies...';
  static const String _noResultsMessage = 'No societies found';
  static const double _emptyStateIconSize = 80.0;
}
