import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/society.dart';
import '../bloc/society_bloc.dart';
import '../bloc/society_event.dart';
import '../bloc/society_state.dart';

/// Screen displaying list of user's societies
class SocietyListScreen extends StatefulWidget {
  const SocietyListScreen({super.key});

  static const String routeName = '/societies';

  @override
  State<SocietyListScreen> createState() => _SocietyListScreenState();
}

class _SocietyListScreenState extends State<SocietyListScreen> {
  @override
  void initState() {
    super.initState();
    // Load societies on init
    context.read<SocietyBloc>().add(const SocietyLoadRequested());
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.space2),
      ),
      child: InkWell(
        onTap: () => _onSocietyTapped(society),
        borderRadius: BorderRadius.circular(AppSpacing.space2),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              // Society logo or placeholder
              Container(
                width: 60,
                height: 60,
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
              ),
              const SizedBox(width: AppSpacing.space4),
              // Society details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      society.name,
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (society.description != null) ...[
                      const SizedBox(height: AppSpacing.space1),
                      Text(
                        society.description!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Chevron icon
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Center(
      child: Icon(Icons.golf_course, size: 32, color: AppColors.primary),
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
    // TODO: Navigate to society dashboard screen when implemented
    // For now, navigate to edit screen
    Navigator.pushNamed(context, '/societies/edit', arguments: society);
  }

  void _navigateToCreateSociety() {
    Navigator.pushNamed(context, '/societies/create');
  }
}
