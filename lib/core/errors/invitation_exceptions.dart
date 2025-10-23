/// Base exception for invitation-related errors
class InvitationException implements Exception {
  final String message;

  const InvitationException(this.message);

  @override
  String toString() => 'InvitationException: $message';
}

/// Thrown when user already has a pending invitation
class PendingInvitationExistsException extends InvitationException {
  const PendingInvitationExistsException(super.message);

  @override
  String toString() => 'PendingInvitationExistsException: $message';
}

/// Thrown when user is already a member of the society
class UserAlreadyMemberException extends InvitationException {
  const UserAlreadyMemberException(super.message);

  @override
  String toString() => 'UserAlreadyMemberException: $message';
}

/// Thrown when invitation is not found
class InvitationNotFoundException extends InvitationException {
  const InvitationNotFoundException(super.message);

  @override
  String toString() => 'InvitationNotFoundException: $message';
}

/// Thrown when invitation has expired
class InvitationExpiredException extends InvitationException {
  const InvitationExpiredException(super.message);

  @override
  String toString() => 'InvitationExpiredException: $message';
}

/// Thrown when invitation has already been responded to
class InvitationAlreadyRespondedException extends InvitationException {
  const InvitationAlreadyRespondedException(super.message);

  @override
  String toString() => 'InvitationAlreadyRespondedException: $message';
}

/// Thrown when user's handicap doesn't meet society requirements
class HandicapValidationException extends InvitationException {
  const HandicapValidationException(super.message);

  @override
  String toString() => 'HandicapValidationException: $message';
}

/// Thrown when database operation fails
class DatabaseException extends InvitationException {
  const DatabaseException(super.message);

  @override
  String toString() => 'DatabaseException: $message';
}
