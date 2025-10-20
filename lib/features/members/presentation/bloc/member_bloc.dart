import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/member_exceptions.dart';
import '../../domain/usecases/get_society_members.dart';
import '../../domain/usecases/join_society.dart';
import '../../domain/usecases/leave_society.dart';
import '../../domain/usecases/update_member_role.dart';
import 'member_event.dart';
import 'member_state.dart';

/// BLoC for managing member operations
class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final GetSocietyMembers _getSocietyMembers;
  final JoinSociety _joinSociety;
  final UpdateMemberRole _updateMemberRole;
  final LeaveSociety _leaveSociety;

  MemberBloc({
    required GetSocietyMembers getSocietyMembers,
    required JoinSociety joinSociety,
    required UpdateMemberRole updateMemberRole,
    required LeaveSociety leaveSociety,
  }) : _getSocietyMembers = getSocietyMembers,
       _joinSociety = joinSociety,
       _updateMemberRole = updateMemberRole,
       _leaveSociety = leaveSociety,
       super(const MemberInitial()) {
    on<MemberLoadRequested>(_onLoadRequested);
    on<MemberAddRequested>(_onAddRequested);
    on<MemberUpdateRoleRequested>(_onUpdateRoleRequested);
    on<MemberRemoveRequested>(_onRemoveRequested);
  }

  /// Handles loading members for a society
  Future<void> _onLoadRequested(
    MemberLoadRequested event,
    Emitter<MemberState> emit,
  ) async {
    emit(const MemberLoading());
    try {
      final members = await _getSocietyMembers(event.societyId);
      emit(MemberLoaded(members: members, societyId: event.societyId));
    } on MemberException catch (e) {
      emit(MemberError(message: 'Failed to load members: ${e.message}'));
    } catch (e) {
      emit(MemberError(message: 'Failed to load members: ${e.toString()}'));
    }
  }

  /// Handles adding a new member to a society
  Future<void> _onAddRequested(
    MemberAddRequested event,
    Emitter<MemberState> emit,
  ) async {
    emit(const MemberOperationInProgress('Adding member...'));
    try {
      await _joinSociety(userId: event.userId, societyId: event.societyId);

      // Reload members after successful add
      final members = await _getSocietyMembers(event.societyId);
      emit(
        MemberOperationSuccess(
          message: 'Member added successfully',
          members: members,
          societyId: event.societyId,
        ),
      );
    } on MemberException catch (e) {
      emit(MemberError(message: 'Failed to add member: ${e.message}'));
    } catch (e) {
      emit(MemberError(message: 'Failed to add member: ${e.toString()}'));
    }
  }

  /// Handles updating a member's role
  Future<void> _onUpdateRoleRequested(
    MemberUpdateRoleRequested event,
    Emitter<MemberState> emit,
  ) async {
    final currentState = state;
    emit(const MemberOperationInProgress('Updating member role...'));
    try {
      await _updateMemberRole(memberId: event.memberId, role: event.role);

      // Reload members after successful update
      if (currentState is MemberLoaded) {
        final members = await _getSocietyMembers(currentState.societyId);
        emit(
          MemberOperationSuccess(
            message: 'Member role updated successfully',
            members: members,
            societyId: currentState.societyId,
          ),
        );
      }
    } on MemberException catch (e) {
      if (currentState is MemberLoaded) {
        emit(
          MemberError(
            message: 'Failed to update member role: ${e.message}',
            members: currentState.members,
            societyId: currentState.societyId,
          ),
        );
      } else {
        emit(
          MemberError(message: 'Failed to update member role: ${e.message}'),
        );
      }
    } catch (e) {
      if (currentState is MemberLoaded) {
        emit(
          MemberError(
            message: 'Failed to update member role: ${e.toString()}',
            members: currentState.members,
            societyId: currentState.societyId,
          ),
        );
      } else {
        emit(
          MemberError(message: 'Failed to update member role: ${e.toString()}'),
        );
      }
    }
  }

  /// Handles removing a member from a society
  Future<void> _onRemoveRequested(
    MemberRemoveRequested event,
    Emitter<MemberState> emit,
  ) async {
    final currentState = state;
    emit(const MemberOperationInProgress('Removing member...'));
    try {
      await _leaveSociety(event.memberId);

      // Reload members after successful removal
      if (currentState is MemberLoaded) {
        final members = await _getSocietyMembers(currentState.societyId);
        emit(
          MemberOperationSuccess(
            message: 'Member removed successfully',
            members: members,
            societyId: currentState.societyId,
          ),
        );
      }
    } on MemberException catch (e) {
      if (currentState is MemberLoaded) {
        emit(
          MemberError(
            message: 'Failed to remove member: ${e.message}',
            members: currentState.members,
            societyId: currentState.societyId,
          ),
        );
      } else {
        emit(MemberError(message: 'Failed to remove member: ${e.message}'));
      }
    } catch (e) {
      if (currentState is MemberLoaded) {
        emit(
          MemberError(
            message: 'Failed to remove member: ${e.toString()}',
            members: currentState.members,
            societyId: currentState.societyId,
          ),
        );
      } else {
        emit(MemberError(message: 'Failed to remove member: ${e.toString()}'));
      }
    }
  }
}
