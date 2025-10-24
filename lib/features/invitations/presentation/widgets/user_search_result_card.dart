import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user_profile.dart';

/// Card displaying a user in the search results with an invite button
class UserSearchResultCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onInvite;
  final bool isInviting;

  const UserSearchResultCard({
    super.key,
    required this.user,
    required this.onInvite,
    this.isInviting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildAvatar(),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            if (user.handicap != null) ...[
              const SizedBox(height: 4),
              Text(
                'Handicap: ${user.handicap}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        trailing: _buildInviteButton(context),
        isThreeLine: user.handicap != null,
      ),
    );
  }

  Widget _buildAvatar() {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl!));
    }

    // Default avatar with initials
    final initials = _getInitials(user.name);
    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: Text(initials, style: const TextStyle(color: Colors.white)),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Widget _buildInviteButton(BuildContext context) {
    if (isInviting) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return ElevatedButton(onPressed: onInvite, child: const Text('Invite'));
  }
}
