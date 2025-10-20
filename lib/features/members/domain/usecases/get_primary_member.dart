import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case for retrieving a user's primary member profile
///
/// Primary member profiles have:
/// - societyId = null
/// - role = null
/// - Single record per user
class GetPrimaryMember {
  final MemberRepository _repository;

  GetPrimaryMember(this._repository);

  /// Retrieves the primary member profile for a given user ID
  ///
  /// Throws [MemberNotFoundException] if no primary member exists
  /// Throws [MemberDatabaseException] if database operation fails
  Future<Member> call(String userId) async {
    return await _repository.getPrimaryMember(userId);
  }
}
