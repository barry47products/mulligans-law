import '../repositories/member_repository.dart';

/// Use case for leaving a society
///
/// Removes a member's society membership record
/// A CAPTAIN cannot leave if other members exist
class LeaveSociety {
  final MemberRepository _repository;

  LeaveSociety(this._repository);

  /// Removes a member from a society
  ///
  /// Throws [MemberNotFoundException] if member not found
  /// Throws [InvalidMemberOperationException] if captain tries to leave with other members
  Future<void> call(String memberId) async {
    await _repository.removeSocietyMember(memberId);
  }
}
