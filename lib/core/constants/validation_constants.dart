/// Validation constants for the application
class ValidationConstants {
  // Prevent instantiation
  const ValidationConstants._();

  // Society validation
  static const int societyNameMinLength = 1;
  static const int societyNameMaxLength = 100;
  static const int societyDescriptionMaxLength = 500;

  // Member validation
  static const int memberNameMinLength = 1;
  static const int memberNameMaxLength = 100;
  static const int minHandicap = 0;
  static const int maxHandicap = 54;

  // General
  static const int phoneMaxLength = 20;
}

/// Validation error messages
class ValidationMessages {
  // Prevent instantiation
  const ValidationMessages._();

  // Society messages
  static const String societyNameEmpty = 'Society name cannot be empty';
  static const String societyNameTooLong =
      'Society name cannot exceed ${ValidationConstants.societyNameMaxLength} characters';
  static const String societyDescriptionTooLong =
      'Description cannot exceed ${ValidationConstants.societyDescriptionMaxLength} characters';

  // Member messages
  static const String memberNameEmpty = 'Member name cannot be empty';
  static const String memberNameTooLong =
      'Member name cannot exceed ${ValidationConstants.memberNameMaxLength} characters';
  static const String invalidEmail = 'Invalid email format';
  static const String invalidHandicap =
      'Handicap must be between ${ValidationConstants.minHandicap} and ${ValidationConstants.maxHandicap}';
  static const String phoneTooLong =
      'Phone number cannot exceed ${ValidationConstants.phoneMaxLength} characters';
}
