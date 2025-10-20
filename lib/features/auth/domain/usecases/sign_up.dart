import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/auth_exceptions.dart';
import '../../../members/domain/repositories/member_repository.dart';

/// Signs up a new user with email and password.
///
/// Validates input and delegates to the repository.
/// After successful auth creation, automatically creates a primary member profile.
class SignUp {
  final AuthRepository _authRepository;
  final MemberRepository _memberRepository;

  // Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Minimum password length
  static const int _minPasswordLength = 6;

  // Default handicap for new users
  static const double _defaultHandicap = 0.0;

  SignUp(this._authRepository, this._memberRepository);

  /// Executes the sign up operation.
  ///
  /// Validates:
  /// - Email is not empty
  /// - Email format is valid
  /// - Password is not empty
  /// - Password meets minimum length
  ///
  /// Optional [name] can be provided for the user profile.
  /// Optional [handicap] can be provided (defaults to 0.0).
  ///
  /// Creates:
  /// 1. Auth user account
  /// 2. Primary member profile (societyId=null, role=null)
  ///
  /// Returns [AuthSession] on success.
  ///
  /// Throws:
  /// - [AuthException] for validation errors
  /// - [EmailAlreadyExistsException] if email is taken
  /// - [WeakPasswordException] for weak passwords
  /// - [NetworkException] for network errors
  /// - [MemberAlreadyExistsException] if member creation fails
  /// - [MemberDatabaseException] for member database errors
  Future<AuthSession> call({
    required String email,
    required String password,
    String? name,
    double? handicap,
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

    // Create auth user
    final session = await _authRepository.signUpWithEmail(
      email: email.trim(),
      password: password,
      name: name?.trim(),
    );

    // Create primary member profile
    await _memberRepository.createPrimaryMember(
      userId: session.user.id,
      name: name?.trim() ?? email.trim(),
      email: email.trim(),
      handicap: handicap ?? _defaultHandicap,
    );

    return session;
  }
}
