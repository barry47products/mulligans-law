import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/user_profile.dart';
import '../bloc/invite_members_bloc.dart';
import '../bloc/invite_members_event.dart';
import '../bloc/invite_members_state.dart';
import '../widgets/user_search_result_card.dart';

/// Screen for inviting users to a society
class InviteToSocietyScreen extends StatefulWidget {
  final String societyId;
  final String societyName;
  final String currentUserId;

  const InviteToSocietyScreen({
    super.key,
    required this.societyId,
    required this.societyName,
    required this.currentUserId,
  });

  @override
  State<InviteToSocietyScreen> createState() => _InviteToSocietyScreenState();
}

class _InviteToSocietyScreenState extends State<InviteToSocietyScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<InviteMembersBloc>().add(SearchUsersEvent(query));
  }

  void _onInviteUser(UserProfile user) {
    context.read<InviteMembersBloc>().add(
      SendInvitationEvent(
        societyId: widget.societyId,
        invitedUserId: user.id,
        invitedByUserId: widget.currentUserId,
      ),
    );
  }

  void _onClearSearch() {
    _searchController.clear();
    context.read<InviteMembersBloc>().add(const ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invite to ${widget.societyName}')),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name or email',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _onClearSearch,
                )
              : null,
          border: const OutlineInputBorder(),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<InviteMembersBloc, InviteMembersState>(
      listener: (context, state) {
        if (state is InvitationSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invitation sent to ${state.invitation.invitedUserName}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is InviteMembersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is InviteMembersInitial) {
          return _buildEmptyState();
        } else if (state is SearchingUsers) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          return _buildUsersList(state.users, null);
        } else if (state is InvitationSent) {
          return _buildUsersList(state.remainingUsers, null);
        } else if (state is SendingInvitation) {
          return _buildUsersList(_getPreviousUsers(state), state.invitedUserId);
        } else if (state is InviteMembersError) {
          if (state.users != null && state.users!.isNotEmpty) {
            return _buildUsersList(state.users!, null);
          }
          return _buildEmptyState();
        }
        return _buildEmptyState();
      },
    );
  }

  List<UserProfile> _getPreviousUsers(SendingInvitation state) {
    // This is a workaround - in production, you might want to store users in SendingInvitation state
    return [];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Search for users to invite',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(
    List<UserProfile> users,
    String? sendingInvitationToUserId,
  ) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isSending = sendingInvitationToUserId == user.id;

        return UserSearchResultCard(
          user: user,
          onInvite: () => _onInviteUser(user),
          isInviting: isSending,
        );
      },
    );
  }
}
