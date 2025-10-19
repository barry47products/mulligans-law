import '../entities/member.dart';

/// Repository interface for member-related operations
abstract class MemberRepository {
  /// Fetches all members for a given society, sorted by name
  Future<List<Member>> getSocietyMembers(String societyId);

  /// Gets the count of members in a society
  Future<int> getMemberCount(String societyId);

  /// Adds a new member to a society
  Future<Member> addMember({
    required String societyId,
    required String userId,
    required String name,
    required String email,
    String? avatarUrl,
    required double handicap,
    required String role,
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
}
