/// Base exception for member-related errors
class MemberException implements Exception {
  final String message;

  MemberException(this.message);

  @override
  String toString() => 'MemberException: $message';
}

/// Thrown when a member is not found
class MemberNotFoundException extends MemberException {
  MemberNotFoundException(super.message);

  @override
  String toString() => 'MemberNotFoundException: $message';
}

/// Thrown when member data is invalid
class InvalidMemberDataException extends MemberException {
  InvalidMemberDataException(super.message);

  @override
  String toString() => 'InvalidMemberDataException: $message';
}

/// Thrown when a member already exists
class MemberAlreadyExistsException extends MemberException {
  MemberAlreadyExistsException(super.message);

  @override
  String toString() => 'MemberAlreadyExistsException: $message';
}

/// Thrown when a member operation is denied due to permissions
class MemberPermissionDeniedException extends MemberException {
  MemberPermissionDeniedException(super.message);

  @override
  String toString() => 'MemberPermissionDeniedException: $message';
}

/// Thrown when a member operation cannot be completed due to business rules
class InvalidMemberOperationException extends MemberException {
  InvalidMemberOperationException(super.message);

  @override
  String toString() => 'InvalidMemberOperationException: $message';
}

/// Thrown when a database operation fails
class MemberDatabaseException extends MemberException {
  MemberDatabaseException(super.message);

  @override
  String toString() => 'MemberDatabaseException: $message';
}
