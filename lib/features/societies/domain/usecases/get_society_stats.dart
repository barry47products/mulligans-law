import '../../../members/domain/repositories/member_repository.dart';
import '../entities/society_stats.dart';

/// Use case to retrieve aggregated statistics for a society
///
/// Fetches member count, owner/captain names, and average handicap
/// for all ACTIVE members of a society.
class GetSocietyStats {
  final MemberRepository _repository;

  GetSocietyStats(this._repository);

  /// Retrieves society statistics for the given [societyId]
  ///
  /// Returns [SocietyStats] containing aggregated member data.
  /// Throws exceptions from the repository layer if any occur.
  Future<SocietyStats> call(String societyId) async {
    return await _repository.getSocietyStats(societyId);
  }
}
