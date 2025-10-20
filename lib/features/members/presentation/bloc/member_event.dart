import 'package:equatable/equatable.dart';

/// Base class for all member events
abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load members for a society
class MemberLoadRequested extends MemberEvent {
  final String societyId;

  const MemberLoadRequested(this.societyId);

  @override
  List<Object?> get props => [societyId];
}

/// Event to add a member to a society (join society)
class MemberAddRequested extends MemberEvent {
  final String userId;
  final String societyId;

  const MemberAddRequested({required this.userId, required this.societyId});

  @override
  List<Object?> get props => [userId, societyId];
}

/// Event to update a member's role
class MemberUpdateRoleRequested extends MemberEvent {
  final String memberId;
  final String role;

  const MemberUpdateRoleRequested({required this.memberId, required this.role});

  @override
  List<Object?> get props => [memberId, role];
}

/// Event to remove a member from a society
class MemberRemoveRequested extends MemberEvent {
  final String memberId;

  const MemberRemoveRequested(this.memberId);

  @override
  List<Object?> get props => [memberId];
}
