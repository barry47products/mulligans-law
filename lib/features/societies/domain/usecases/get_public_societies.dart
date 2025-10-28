import '../entities/society.dart';
import '../repositories/society_repository.dart';

/// Gets all public societies that the user can discover and join.
///
/// No validation needed - simply delegates to the repository.
class GetPublicSocieties {
  final SocietyRepository _repository;

  GetPublicSocieties(this._repository);

  /// Executes the get public societies operation.
  ///
  /// Returns a list of [Society] objects that are:
  /// - Public (is_public = true)
  /// - Not soft-deleted (deleted_at IS NULL)
  /// - Not societies the user is already a member of (ACTIVE or PENDING status)
  ///
  /// Returns empty list if no public societies available.
  ///
  /// Throws:
  /// - [UnauthorizedException] if user is not authenticated
  /// - [NetworkException] for network errors
  /// - [SocietyDatabaseException] for database errors
  Future<List<Society>> call() async {
    return await _repository.getPublicSocieties();
  }
}
