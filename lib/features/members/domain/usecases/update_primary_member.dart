import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case for updating a user's primary member profile
///
/// Can update: name, email, handicap, avatarUrl
/// Cannot update: societyId (always null), role (always null), userId
class UpdatePrimaryMember {
  final MemberRepository _repository;

  UpdatePrimaryMember(this._repository);

  /// Updates the primary member profile for a given user ID
  ///
  /// Only provided fields will be updated
  /// Throws [MemberNotFoundException] if primary member not found
  /// Throws [MemberDatabaseException] if database operation fails
  Future<Member> call({
    required String userId,
    String? name,
    String? email,
    double? handicap,
    String? avatarUrl,
  }) async {
    return await _repository.updatePrimaryMember(
      userId: userId,
      name: name,
      email: email,
      handicap: handicap,
      avatarUrl: avatarUrl,
    );
  }
}
