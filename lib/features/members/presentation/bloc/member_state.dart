import 'package:equatable/equatable.dart';
import '../../domain/entities/member.dart';

/// Base class for all member states
abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object?> get props => [];
}

/// Initial state when BLoC is created
class MemberInitial extends MemberState {
  const MemberInitial();
}

/// State when loading members
class MemberLoading extends MemberState {
  const MemberLoading();
}

/// State when members are loaded successfully
class MemberLoaded extends MemberState {
  final List<Member> members;
  final String societyId;

  const MemberLoaded({required this.members, required this.societyId});

  @override
  List<Object?> get props => [members, societyId];

  /// Creates a copy with optional field overrides
  MemberLoaded copyWith({List<Member>? members, String? societyId}) {
    return MemberLoaded(
      members: members ?? this.members,
      societyId: societyId ?? this.societyId,
    );
  }
}

/// State when a member operation is in progress
class MemberOperationInProgress extends MemberState {
  final String message;

  const MemberOperationInProgress(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a member operation succeeds
class MemberOperationSuccess extends MemberState {
  final String message;
  final List<Member> members;
  final String societyId;

  const MemberOperationSuccess({
    required this.message,
    required this.members,
    required this.societyId,
  });

  @override
  List<Object?> get props => [message, members, societyId];
}

/// State when an error occurs
class MemberError extends MemberState {
  final String message;
  final List<Member>? members;
  final String? societyId;

  const MemberError({required this.message, this.members, this.societyId});

  @override
  List<Object?> get props => [message, members, societyId];
}
