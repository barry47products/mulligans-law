import '../repositories/auth_repository.dart';

/// Signs out the current user.
///
/// Delegates to the repository to end the session.
class SignOut {
  final AuthRepository _repository;

  SignOut(this._repository);

  /// Executes the sign out operation.
  ///
  /// Throws:
  /// - [AuthException] if sign out fails
  /// - [NetworkException] for network errors
  Future<void> call() async {
    return await _repository.signOut();
  }
}
