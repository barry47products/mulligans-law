import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/auth_exceptions.dart';

/// Signs in a user with email and password.
///
/// Validates input and delegates to the repository.
class SignIn {
  final AuthRepository _repository;

  // Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  SignIn(this._repository);

  /// Executes the sign in operation.
  ///
  /// Validates:
  /// - Email is not empty
  /// - Email format is valid
  /// - Password is not empty
  ///
  /// Returns [AuthSession] on success.
  ///
  /// Throws:
  /// - [AuthException] for validation errors
  /// - [InvalidCredentialsException] for wrong credentials
  /// - [NetworkException] for network errors
  Future<AuthSession> call({
    required String email,
    required String password,
  }) async {
    // Validate email
    if (email.trim().isEmpty) {
      throw const AuthException('Email cannot be empty');
    }

    if (!_emailRegex.hasMatch(email)) {
      throw const AuthException('Invalid email format');
    }

    // Validate password
    if (password.isEmpty) {
      throw const AuthException('Password cannot be empty');
    }

    // Delegate to repository
    return await _repository.signInWithEmail(
      email: email.trim(),
      password: password,
    );
  }
}
