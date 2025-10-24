import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../invitations/presentation/screens/invite_to_society_screen.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/presentation/bloc/member_bloc.dart';
import '../../../members/presentation/bloc/member_event.dart';
import '../../../members/presentation/bloc/member_state.dart';
import '../../../members/presentation/widgets/member_card.dart';
import '../../domain/entities/society.dart';

/// Screen displaying the list of members in a society
class SocietyMembersScreen extends StatefulWidget {
  final Society society;

  const SocietyMembersScreen({super.key, required this.society});

  @override
  State<SocietyMembersScreen> createState() => _SocietyMembersScreenState();
}

class _SocietyMembersScreenState extends State<SocietyMembersScreen> {
  String _sortBy = _sortNameAsc;

  @override
  void initState() {
    super.initState();
    // Load members when screen initializes
    context.read<MemberBloc>().add(MemberLoadRequested(widget.society.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          if (state is MemberLoading) {
            return _buildLoadingState();
          } else if (state is MemberError) {
            return _buildErrorState(state.message);
          } else if (state is MemberLoaded) {
            if (state.members.isEmpty) {
              return _buildEmptyState();
            }
            return _buildMembersList(state.members);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          final count = state is MemberLoaded ? state.members.length : 0;
          return Text('Members ($count)');
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            // Get current user ID from AuthBloc
            final authState = context.read<AuthBloc>().state;
            if (authState is AuthAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InviteToSocietyScreen(
                    societyId: widget.society.id,
                    societyName: widget.society.name,
                    currentUserId: authState.user.id,
                  ),
                ),
              );
            }
          },
          tooltip: _addMemberTooltip,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: _errorIconSize,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              message,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space4),
            ElevatedButton(
              onPressed: () {
                context.read<MemberBloc>().add(
                  MemberLoadRequested(widget.society.id),
                );
              },
              child: const Text(_retryButtonLabel),
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
              Icons.people_outline,
              size: _emptyStateIconSize,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              _emptyStateTitle,
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              _emptyStateMessage,
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

  Widget _buildMembersList(List<Member> members) {
    final sortedMembers = _sortMembers(members);

    return Column(
      children: [
        _buildSortDropdown(),
        Expanded(
          child: ListView.builder(
            itemCount: sortedMembers.length,
            itemBuilder: (context, index) {
              return MemberCard(member: sortedMembers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
      child: Row(
        children: [
          Text(
            _sortByLabel,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.space2),
          DropdownButton<String>(
            value: _sortBy,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _sortBy = newValue;
                });
              }
            },
            items: const [
              DropdownMenuItem(
                value: _sortNameAsc,
                child: Text(_sortNameAscLabel),
              ),
              DropdownMenuItem(
                value: _sortNameDesc,
                child: Text(_sortNameDescLabel),
              ),
              DropdownMenuItem(
                value: _sortHandicapAsc,
                child: Text(_sortHandicapAscLabel),
              ),
              DropdownMenuItem(
                value: _sortHandicapDesc,
                child: Text(_sortHandicapDescLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Member> _sortMembers(List<Member> members) {
    final sorted = List<Member>.from(members);

    switch (_sortBy) {
      case _sortNameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _sortNameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case _sortHandicapAsc:
        sorted.sort((a, b) => a.handicap.compareTo(b.handicap));
        break;
      case _sortHandicapDesc:
        sorted.sort((a, b) => b.handicap.compareTo(a.handicap));
        break;
    }

    return sorted;
  }

  // Constants
  static const double _emptyStateIconSize = 80.0;
  static const double _errorIconSize = 64.0;

  static const String _sortByLabel = 'Sort by';
  static const String _addMemberTooltip = 'Add Member';
  static const String _retryButtonLabel = 'Retry';
  static const String _emptyStateTitle = 'No members yet';
  static const String _emptyStateMessage =
      'Add your first member to get started!';

  static const String _sortNameAsc = 'name_asc';
  static const String _sortNameDesc = 'name_desc';
  static const String _sortHandicapAsc = 'handicap_asc';
  static const String _sortHandicapDesc = 'handicap_desc';

  static const String _sortNameAscLabel = 'Name (A-Z)';
  static const String _sortNameDescLabel = 'Name (Z-A)';
  static const String _sortHandicapAscLabel = 'Handicap (Low-High)';
  static const String _sortHandicapDescLabel = 'Handicap (High-Low)';
}
