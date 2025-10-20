import '../repositories/member_repository.dart';

/// Use case for counting members in a society
class GetMemberCount {
  final MemberRepository _repository;

  GetMemberCount(this._repository);

  /// Counts the number of members in a given society
  ///
  /// Returns 0 if no members found
  /// Throws [MemberDatabaseException] if database operation fails
  Future<int> call(String societyId) async {
    return await _repository.getMemberCount(societyId);
  }
}
