import '../entities/society.dart';
import '../repositories/society_repository.dart';

/// Gets all societies where the current user is an active member.
///
/// No validation needed - simply delegates to the repository.
class GetUserSocieties {
  final SocietyRepository _repository;

  GetUserSocieties(this._repository);

  /// Executes the get user societies operation.
  ///
  /// Returns a list of [Society] objects where the user is an active member.
  /// Returns empty list if user is not a member of any societies.
  ///
  /// Throws:
  /// - [UnauthorizedException] if user is not authenticated
  /// - [NetworkException] for network errors
  /// - [SocietyDatabaseException] for database errors
  Future<List<Society>> call() async {
    return await _repository.getUserSocieties();
  }
}
