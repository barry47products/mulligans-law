import '../../../../core/errors/member_exceptions.dart';
import '../../../societies/domain/repositories/society_repository.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case for adding a member directly to a society (by captain/owner).
///
/// Creates an ACTIVE member record (not PENDING like join requests).
/// Validates handicap limits if enabled for the society.
class AddMember {
  final MemberRepository _memberRepository;
  final SocietyRepository _societyRepository;

  /// Default status for members added by captains (not pending)
  static const String defaultStatus = 'ACTIVE';

  AddMember({
    required MemberRepository memberRepository,
    required SocietyRepository societyRepository,
  }) : _memberRepository = memberRepository,
       _societyRepository = societyRepository;

  /// Adds a new member to a society with validation.
  ///
  /// Steps:
  /// 1. Validates society exists
  /// 2. If handicap limits enabled, validates handicap is within range
  /// 3. Creates member record with status='ACTIVE'
  ///
  /// Throws:
  /// - [SocietyNotFoundException] if society does not exist
  /// - [InvalidMemberOperationException] if handicap outside society limits
  /// - [MemberAlreadyExistsException] if user already a member
  Future<Member> call({
    required String societyId,
    required String userId,
    required String name,
    required String email,
    required double handicap,
    required String role,
  }) async {
    // 1. Get society to check handicap limits
    final society = await _societyRepository.getSocietyById(societyId);

    // 2. Validate handicap limits if enabled
    if (society.handicapLimitEnabled) {
      final min = society.handicapMin;
      final max = society.handicapMax;

      if (min != null && handicap < min) {
        throw InvalidMemberOperationException(
          'Handicap ${handicap.toStringAsFixed(1)} is below society minimum ($min)',
        );
      }

      if (max != null && handicap > max) {
        throw InvalidMemberOperationException(
          'Handicap ${handicap.toStringAsFixed(1)} is above society maximum ($max)',
        );
      }
    }

    // 3. Create member with ACTIVE status
    return await _memberRepository.addMember(
      societyId: societyId,
      userId: userId,
      name: name,
      email: email,
      handicap: handicap,
      role: role,
      status: defaultStatus,
    );
  }
}
