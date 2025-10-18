import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/auth_exceptions.dart';

/// Signs up a new user with email and password.
///
/// Validates input and delegates to the repository.
class SignUp {
  final AuthRepository _repository;

  // Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Minimum password length
  static const int _minPasswordLength = 6;

  SignUp(this._repository);

  /// Executes the sign up operation.
  ///
  /// Validates:
  /// - Email is not empty
  /// - Email format is valid
  /// - Password is not empty
  /// - Password meets minimum length
  ///
  /// Optional [name] can be provided for the user profile.
  ///
  /// Returns [AuthSession] on success.
  ///
  /// Throws:
  /// - [AuthException] for validation errors
  /// - [EmailAlreadyExistsException] if email is taken
  /// - [WeakPasswordException] for weak passwords
  /// - [NetworkException] for network errors
  Future<AuthSession> call({
    required String email,
    required String password,
    String? name,
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

    if (password.length < _minPasswordLength) {
      throw AuthException(
        'Password must be at least $_minPasswordLength characters',
      );
    }

    // Delegate to repository
    return await _repository.signUpWithEmail(
      email: email.trim(),
      password: password,
      name: name?.trim(),
    );
  }
}
