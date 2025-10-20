import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case for updating a member's role in a society
///
/// Can only be called by a CAPTAIN
/// Valid roles: 'CAPTAIN', 'MEMBER'
class UpdateMemberRole {
  final MemberRepository _repository;

  UpdateMemberRole(this._repository);

  /// Updates a member's role in a society
  ///
  /// Throws [MemberNotFoundException] if member not found
  /// Throws [InvalidMemberOperationException] if caller is not a captain
  Future<Member> call({required String memberId, required String role}) async {
    return await _repository.updateMemberRole(memberId: memberId, role: role);
  }
}
