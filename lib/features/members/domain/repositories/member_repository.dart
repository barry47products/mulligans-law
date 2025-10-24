import '../entities/member.dart';
import '../../../societies/domain/entities/society_stats.dart';

/// Repository interface for member-related operations
abstract class MemberRepository {
  /// Fetches all members for a given society, sorted by name
  Future<List<Member>> getSocietyMembers(String societyId);

  /// Gets the count of members in a society
  Future<int> getMemberCount(String societyId);

  /// Gets aggregated statistics for a society
  /// Returns stats including member count, owner/captain names, and average handicap
  /// Only includes ACTIVE members in calculations
  Future<SocietyStats> getSocietyStats(String societyId);

  /// Adds a new member to a society
  ///
  /// Optional [status] defaults to 'ACTIVE' in database if not provided
  /// Optional [expiresAt] for PENDING status (7-day expiry for join requests)
  Future<Member> addMember({
    required String societyId,
    required String userId,
    required String name,
    required String email,
    String? avatarUrl,
    required double handicap,
    required String role,
    String? status,
    DateTime? expiresAt,
  });

  /// Updates a member's information
  Future<Member> updateMember({
    required String memberId,
    String? name,
    String? email,
    String? avatarUrl,
    double? handicap,
    String? role,
  });

  /// Removes a member from a society
  Future<void> removeMember(String memberId);

  /// Gets a specific member by ID
  Future<Member> getMemberById(String memberId);

  /// Gets the primary member profile for a user (where society_id IS NULL)
  /// Throws [MemberNotFoundException] if primary member not found
  Future<Member> getPrimaryMember(String userId);

  /// Creates a primary member profile (society_id = NULL, role = NULL)
  /// This is called during user registration to create the user's base profile
  /// Throws [MemberAlreadyExistsException] if primary member already exists
  Future<Member> createPrimaryMember({
    required String userId,
    required String name,
    required String email,
    required double handicap,
    String? avatarUrl,
  });

  /// Updates a user's primary member profile
  /// Only provided fields will be updated
  /// Throws [MemberNotFoundException] if primary member not found
  Future<Member> updatePrimaryMember({
    required String userId,
    String? name,
    String? email,
    double? handicap,
    String? avatarUrl,
  });

  /// Updates a member's role in a society
  /// Can only be called by a CAPTAIN
  /// Throws [MemberNotFoundException] if member not found
  /// Throws [InvalidMemberOperationException] if operation not allowed
  Future<Member> updateMemberRole({
    required String memberId,
    required String role,
  });

  /// Removes a member from a society
  /// Cannot remove a CAPTAIN if other members exist
  /// Throws [MemberNotFoundException] if member not found
  /// Throws [InvalidMemberOperationException] if operation not allowed
  Future<void> removeSocietyMember(String memberId);
}
