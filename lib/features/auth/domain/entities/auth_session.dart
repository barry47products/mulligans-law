import 'package:equatable/equatable.dart';
import 'auth_user.dart';

/// Represents an authentication session.
///
/// Contains the user information and session metadata.
class AuthSession extends Equatable {
  /// The authenticated user
  final AuthUser user;

  /// Access token for API calls
  final String accessToken;

  /// Refresh token for renewing the session
  final String refreshToken;

  /// When the session expires
  final DateTime expiresAt;

  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Whether the session is still valid
  bool get isValid => DateTime.now().isBefore(expiresAt);

  /// Whether the session is expired
  bool get isExpired => !isValid;

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresAt];

  /// Creates a copy with optional field overrides
  AuthSession copyWith({
    AuthUser? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
