import '../entities/member.dart';
import '../repositories/member_repository.dart';
import '../../../societies/domain/repositories/society_repository.dart';

/// Use case for joining a society
///
/// Creates a society membership record from the user's primary member profile
/// The user will have TWO member records:
/// - Primary member (societyId=null, role=null)
/// - Society membership (societyId=X, role='MEMBER')
class JoinSociety {
  final MemberRepository _memberRepository;
  final SocietyRepository _societyRepository;

  JoinSociety(this._memberRepository, this._societyRepository);

  /// Creates a society membership for a user
  ///
  /// Steps:
  /// 1. Validates society exists
  /// 2. Gets user's primary member profile
  /// 3. Creates society membership record with role='MEMBER'
  ///
  /// Throws [SocietyNotFoundException] if society does not exist
  /// Throws [MemberNotFoundException] if primary member not found
  /// Throws [MemberAlreadyExistsException] if already a member
  Future<Member> call({
    required String userId,
    required String societyId,
  }) async {
    // Validate society exists
    await _societyRepository.getSocietyById(societyId);

    // Get primary member
    final primaryMember = await _memberRepository.getPrimaryMember(userId);

    // Create society membership
    return await _memberRepository.addMember(
      societyId: societyId,
      userId: userId,
      name: primaryMember.name,
      email: primaryMember.email,
      handicap: primaryMember.handicap,
      avatarUrl: primaryMember.avatarUrl,
      role: 'MEMBER',
    );
  }
}
