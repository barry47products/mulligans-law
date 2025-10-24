import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';

/// Use case for requesting to join a public society.
///
/// Creates a PENDING member record with a 7-day expiration.
/// Validates:
/// - User has a primary member profile
/// - Society exists and is public (not deleted)
/// - User's handicap is within society limits (if enabled)
class RequestToJoinSociety {
  final MemberRepository _memberRepository;
  final SocietyRepository _societyRepository;

  /// Duration for pending invitation expiry (7 days)
  static const Duration pendingExpiryDuration = Duration(days: 7);

  /// Default role for join requests
  static const String defaultRole = 'MEMBER';

  /// Status for pending requests
  static const String pendingStatus = 'PENDING';

  RequestToJoinSociety({
    required MemberRepository memberRepository,
    required SocietyRepository societyRepository,
  }) : _memberRepository = memberRepository,
       _societyRepository = societyRepository;

  /// Request to join a public society.
  ///
  /// Throws:
  /// - [MemberNotFoundException] if primary member profile not found
  /// - [InvalidMemberOperationException] if society is not public, deleted, or handicap outside limits
  /// - [Exception] if society not found or other errors
  Future<void> call({required String userId, required String societyId}) async {
    // 1. Get user's primary member profile
    final primaryMember = await _memberRepository.getPrimaryMember(userId);

    // 2. Get society details
    final society = await _societyRepository.getSocietyById(societyId);

    // 3. Validate society is public
    if (!society.isPublic) {
      throw InvalidMemberOperationException(
        'Cannot join a private society. You must be invited by a captain or owner.',
      );
    }

    // 4. Validate society is not deleted
    if (society.deletedAt != null) {
      throw InvalidMemberOperationException(
        'This society has been deleted and cannot accept new members.',
      );
    }

    // 5. Validate handicap limits (if enabled)
    if (society.handicapLimitEnabled) {
      final userHandicap = primaryMember.handicap;
      final minHandicap = society.handicapMin ?? 0;
      final maxHandicap = society.handicapMax ?? 54;

      if (userHandicap < minHandicap || userHandicap > maxHandicap) {
        throw InvalidMemberOperationException(
          'Your handicap ($userHandicap) is outside this society\'s limits ($minHandicap - $maxHandicap).',
        );
      }
    }

    // 6. Add member to repository (creates PENDING record with 7-day expiry)
    await _memberRepository.addMember(
      societyId: societyId,
      userId: userId,
      name: primaryMember.name,
      email: primaryMember.email,
      avatarUrl: primaryMember.avatarUrl,
      handicap: primaryMember.handicap,
      role: defaultRole,
      status: pendingStatus,
      expiresAt: DateTime.now().add(pendingExpiryDuration),
    );
  }
}
