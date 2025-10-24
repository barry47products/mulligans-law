import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/auth_exceptions.dart';
import '../../../../core/errors/invitation_exceptions.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../../auth/domain/usecases/search_users.dart';
import '../../domain/usecases/send_society_invitation.dart';
import 'invite_members_event.dart';
import 'invite_members_state.dart';

/// BLoC for managing the invite members screen
class InviteMembersBloc extends Bloc<InviteMembersEvent, InviteMembersState> {
  final SearchUsers _searchUsers;
  final SendSocietyInvitation _sendInvitation;

  static const int _searchResultsLimit = 20;
  static const int _minSearchQueryLength = 1;

  InviteMembersBloc({
    required SearchUsers searchUsers,
    required SendSocietyInvitation sendInvitation,
  }) : _searchUsers = searchUsers,
       _sendInvitation = sendInvitation,
       super(const InviteMembersInitial()) {
    on<SearchUsersEvent>(_onSearchUsers);
    on<SendInvitationEvent>(_onSendInvitation);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<InviteMembersState> emit,
  ) async {
    final query = event.query.trim();

    // Don't search for empty or whitespace-only queries
    if (query.length < _minSearchQueryLength) {
      return;
    }

    emit(const SearchingUsers());

    try {
      final users = await _searchUsers(
        query: query,
        limit: _searchResultsLimit,
      );

      emit(UsersLoaded(users, query));
    } on NetworkException catch (e) {
      emit(InviteMembersError(e.message));
    } on AuthException catch (e) {
      emit(InviteMembersError('Failed to search users: ${e.message}'));
    } catch (e) {
      emit(InviteMembersError('Failed to search users: ${e.toString()}'));
    }
  }

  Future<void> _onSendInvitation(
    SendInvitationEvent event,
    Emitter<InviteMembersState> emit,
  ) async {
    // Preserve current state for error handling
    final currentState = state;
    final List<UserProfile> currentUsers = currentState is UsersLoaded
        ? currentState.users
        : <UserProfile>[];
    final String currentQuery = currentState is UsersLoaded
        ? currentState.query
        : '';

    emit(SendingInvitation(event.invitedUserId));

    try {
      final invitation = await _sendInvitation(
        societyId: event.societyId,
        invitedUserId: event.invitedUserId,
        invitedByUserId: event.invitedByUserId,
        message: event.message,
      );

      // Remove the invited user from the list
      final List<UserProfile> remainingUsers = currentUsers
          .where((user) => user.id != event.invitedUserId)
          .toList();

      emit(InvitationSent(invitation, remainingUsers, currentQuery));
    } on PendingInvitationExistsException catch (e) {
      emit(
        InviteMembersError(e.message, users: currentUsers, query: currentQuery),
      );
    } on UserAlreadyMemberException catch (e) {
      emit(
        InviteMembersError(e.message, users: currentUsers, query: currentQuery),
      );
    } on HandicapValidationException catch (e) {
      emit(
        InviteMembersError(e.message, users: currentUsers, query: currentQuery),
      );
    } on NetworkException catch (e) {
      emit(
        InviteMembersError(e.message, users: currentUsers, query: currentQuery),
      );
    } on InvitationException catch (e) {
      emit(
        InviteMembersError(
          'Failed to send invitation: ${e.message}',
          users: currentUsers,
          query: currentQuery,
        ),
      );
    } catch (e) {
      emit(
        InviteMembersError(
          'Failed to send invitation: ${e.toString()}',
          users: currentUsers,
          query: currentQuery,
        ),
      );
    }
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<InviteMembersState> emit,
  ) async {
    emit(const InviteMembersInitial());
  }
}
