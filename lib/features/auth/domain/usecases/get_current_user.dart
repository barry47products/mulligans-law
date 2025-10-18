import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Gets the current authenticated user.
///
/// Returns the user if authenticated, null otherwise.
class GetCurrentUser {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  /// Executes the operation to get the current user.
  ///
  /// Returns [AuthUser] if authenticated, null otherwise.
  Future<AuthUser?> call() async {
    return await _repository.getCurrentUser();
  }
}
