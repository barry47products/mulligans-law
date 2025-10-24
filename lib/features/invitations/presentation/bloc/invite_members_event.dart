import 'package:equatable/equatable.dart';

/// Base class for all InviteMembersBloc events
abstract class InviteMembersEvent extends Equatable {
  const InviteMembersEvent();

  @override
  List<Object?> get props => [];
}

/// Event to search for users by name or email
class SearchUsersEvent extends InviteMembersEvent {
  final String query;
  final String societyId;

  const SearchUsersEvent(this.query, this.societyId);

  @override
  List<Object?> get props => [query, societyId];
}

/// Event to send an invitation to a user
class SendInvitationEvent extends InviteMembersEvent {
  final String societyId;
  final String invitedUserId;
  final String invitedByUserId;
  final String? message;

  const SendInvitationEvent({
    required this.societyId,
    required this.invitedUserId,
    required this.invitedByUserId,
    this.message,
  });

  @override
  List<Object?> get props => [
    societyId,
    invitedUserId,
    invitedByUserId,
    message,
  ];
}

/// Event to clear search results
class ClearSearchEvent extends InviteMembersEvent {
  const ClearSearchEvent();
}
