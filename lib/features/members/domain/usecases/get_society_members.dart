import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case for retrieving all members of a society
///
/// Society members have:
/// - societyId = `society_id`
/// - role = 'CAPTAIN' or 'MEMBER'
/// - Multiple records per society
class GetSocietyMembers {
  final MemberRepository _repository;

  GetSocietyMembers(this._repository);

  /// Retrieves all members for a given society ID, sorted by name
  ///
  /// Returns an empty list if no members found
  /// Throws [MemberDatabaseException] if database operation fails
  Future<List<Member>> call(String societyId) async {
    return await _repository.getSocietyMembers(societyId);
  }
}
