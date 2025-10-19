/// Base exception for all society-related errors
class SocietyException implements Exception {
  final String message;
  final String? code;

  const SocietyException(this.message, {this.code});

  @override
  String toString() =>
      'SocietyException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when a society is not found or user has no access to it
class SocietyNotFoundException extends SocietyException {
  const SocietyNotFoundException([String? message])
    : super(
        message ?? 'Society not found or access denied',
        code: 'society_not_found',
      );
}

/// Thrown when society data is invalid
class InvalidSocietyDataException extends SocietyException {
  const InvalidSocietyDataException([String? message])
    : super(message ?? 'Invalid society data', code: 'invalid_society_data');
}

/// Thrown when a society name already exists
class SocietyNameExistsException extends SocietyException {
  const SocietyNameExistsException([String? message])
    : super(
        message ?? 'A society with this name already exists',
        code: 'society_name_exists',
      );
}

/// Thrown when user doesn't have permission for society operation
class SocietyPermissionDeniedException extends SocietyException {
  const SocietyPermissionDeniedException([String? message])
    : super(
        message ?? 'You do not have permission to perform this action',
        code: 'society_permission_denied',
      );
}

/// Thrown when society operation fails on the database level
class SocietyDatabaseException extends SocietyException {
  const SocietyDatabaseException([String? message])
    : super(
        message ?? 'Database operation failed',
        code: 'society_database_error',
      );
}
