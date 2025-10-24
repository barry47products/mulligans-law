import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/entities/society_invitation.dart';

/// Base class for all InviteMembersBloc states
abstract class InviteMembersState extends Equatable {
  const InviteMembersState();

  @override
  List<Object?> get props => [];
}

/// Initial state when bloc is first created
class InviteMembersInitial extends InviteMembersState {
  const InviteMembersInitial();
}

/// State when searching for users
class SearchingUsers extends InviteMembersState {
  const SearchingUsers();
}

/// State when users have been loaded from search
class UsersLoaded extends InviteMembersState {
  final List<UserProfile> users;
  final String query;

  const UsersLoaded(this.users, this.query);

  @override
  List<Object?> get props => [users, query];
}

/// State when sending an invitation
class SendingInvitation extends InviteMembersState {
  final String invitedUserId;

  const SendingInvitation(this.invitedUserId);

  @override
  List<Object?> get props => [invitedUserId];
}

/// State when invitation has been sent successfully
class InvitationSent extends InviteMembersState {
  final SocietyInvitation invitation;
  final List<UserProfile> remainingUsers;
  final String query;

  const InvitationSent(this.invitation, this.remainingUsers, this.query);

  @override
  List<Object?> get props => [invitation, remainingUsers, query];
}

/// State when an error occurs
class InviteMembersError extends InviteMembersState {
  final String message;
  final List<UserProfile>? users;
  final String? query;

  const InviteMembersError(this.message, {this.users, this.query});

  @override
  List<Object?> get props => [message, users, query];
}
