import '../entities/auth_session.dart';
import '../entities/auth_user.dart';

/// Repository interface for authentication operations.
///
/// This defines the contract for authentication without exposing implementation details.
/// Implementations can use Supabase, Firebase, or any other auth provider.
abstract class AuthRepository {
  /// Sign in with email and password
  ///
  /// Throws:
  /// - [InvalidCredentialsException] if email/password is incorrect
  /// - [NetworkException] if there's no internet connection
  /// - [AuthException] for other auth errors
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  ///
  /// Throws:
  /// - [EmailAlreadyExistsException] if email is already registered
  /// - [WeakPasswordException] if password doesn't meet requirements
  /// - [NetworkException] if there's no internet connection
  /// - [AuthException] for other auth errors
  Future<AuthSession> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out the current user
  ///
  /// Throws:
  /// - [AuthException] if sign out fails
  Future<void> signOut();

  /// Get the current authenticated user
  ///
  /// Returns null if no user is signed in
  Future<AuthUser?> getCurrentUser();

  /// Get the current session
  ///
  /// Returns null if no active session
  Future<AuthSession?> getCurrentSession();

  /// Stream of authentication state changes
  ///
  /// Emits:
  /// - AuthUser when user signs in
  /// - null when user signs out
  Stream<AuthUser?> get authStateChanges;

  /// Reset password for email
  ///
  /// Sends password reset email to the user
  ///
  /// Throws:
  /// - [UserNotFoundException] if email doesn't exist
  /// - [NetworkException] if there's no internet connection
  /// - [AuthException] for other auth errors
  Future<void> resetPassword({required String email});

  /// Update user profile
  ///
  /// Throws:
  /// - [UnauthorizedException] if no user is signed in
  /// - [AuthException] for other auth errors
  Future<AuthUser> updateProfile({String? name, String? avatarUrl});
}
