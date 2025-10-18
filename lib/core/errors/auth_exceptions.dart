/// Base exception for all authentication-related errors
class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() =>
      'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when email/password credentials are invalid
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([String? message])
    : super(
        message ?? 'Invalid email or password',
        code: 'invalid_credentials',
      );
}

/// Thrown when email is already registered
class EmailAlreadyExistsException extends AuthException {
  const EmailAlreadyExistsException([String? message])
    : super(
        message ?? 'Email address is already registered',
        code: 'email_exists',
      );
}

/// Thrown when password doesn't meet requirements
class WeakPasswordException extends AuthException {
  const WeakPasswordException([String? message])
    : super(message ?? 'Password is too weak', code: 'weak_password');
}

/// Thrown when user is not found
class UserNotFoundException extends AuthException {
  const UserNotFoundException([String? message])
    : super(message ?? 'User not found', code: 'user_not_found');
}

/// Thrown when operation requires authentication but user is not signed in
class UnauthorizedException extends AuthException {
  const UnauthorizedException([String? message])
    : super(message ?? 'User is not authenticated', code: 'unauthorized');
}

/// Thrown when there's no internet connection
class NetworkException extends AuthException {
  const NetworkException([String? message])
    : super(message ?? 'No internet connection', code: 'network_error');
}

/// Thrown when session has expired
class SessionExpiredException extends AuthException {
  const SessionExpiredException([String? message])
    : super(message ?? 'Session has expired', code: 'session_expired');
}
