import '../../../../core/constants/validation_constants.dart';
import '../../../../core/errors/society_exceptions.dart';
import '../entities/society.dart';
import '../repositories/society_repository.dart';

/// Updates an existing golf society.
///
/// Validates input and delegates to the repository.
/// Only captains can update society details (enforced at repository/RLS level).
class UpdateSociety {
  final SocietyRepository _repository;

  UpdateSociety(this._repository);

  /// Executes the update society operation.
  ///
  /// At least one field must be provided for update.
  ///
  /// Validates:
  /// - At least one field is provided
  /// - Name (if provided) is not empty and does not exceed max length
  /// - Description (if provided) does not exceed max length
  /// - Handicap range is valid (min <= max, within -8 to 36)
  ///
  /// Returns the updated [Society].
  ///
  /// Throws:
  /// - [InvalidSocietyDataException] for validation errors
  /// - [SocietyNotFoundException] if society doesn't exist
  /// - [UnauthorizedException] if user is not a captain
  /// - [NetworkException] for network errors
  Future<Society> call({
    required String id,
    String? name,
    String? description,
    String? logoUrl,
    bool? isPublic,
    bool? handicapLimitEnabled,
    int? handicapMin,
    int? handicapMax,
    String? location,
    String? rules,
  }) async {
    // Validate and process name
    String? finalName;
    if (name != null) {
      finalName = name.trim();
      if (finalName.isEmpty) {
        throw const InvalidSocietyDataException(
          ValidationMessages.societyNameEmpty,
        );
      }
      if (finalName.length > ValidationConstants.societyNameMaxLength) {
        throw const InvalidSocietyDataException(
          ValidationMessages.societyNameTooLong,
        );
      }
    }

    // Validate and process description
    String? finalDescription;
    if (description != null) {
      finalDescription = description.trim();
      if (finalDescription.isEmpty) {
        finalDescription = null;
      } else if (finalDescription.length >
          ValidationConstants.societyDescriptionMaxLength) {
        throw const InvalidSocietyDataException(
          ValidationMessages.societyDescriptionTooLong,
        );
      }
    }

    // Process logo URL
    String? finalLogoUrl;
    if (logoUrl != null) {
      finalLogoUrl = logoUrl.trim();
      if (finalLogoUrl.isEmpty) {
        finalLogoUrl = null;
      }
    }

    // Process location
    String? finalLocation;
    if (location != null) {
      finalLocation = location.trim();
      if (finalLocation.isEmpty) {
        finalLocation = null;
      }
    }

    // Process rules
    String? finalRules;
    if (rules != null) {
      finalRules = rules.trim();
      if (finalRules.isEmpty) {
        finalRules = null;
      }
    }

    // Validate handicap limits if being updated
    if (handicapMin != null || handicapMax != null) {
      // If either is provided, validate both values
      if (handicapMin != null) {
        if (handicapMin < -8 || handicapMin > 36) {
          throw const InvalidSocietyDataException(
            'Handicap minimum must be between -8 and 36',
          );
        }
      }

      if (handicapMax != null) {
        if (handicapMax < -8 || handicapMax > 36) {
          throw const InvalidSocietyDataException(
            'Handicap maximum must be between -8 and 36',
          );
        }
      }

      // If both are provided, validate min <= max
      if (handicapMin != null && handicapMax != null) {
        if (handicapMin > handicapMax) {
          throw const InvalidSocietyDataException(
            'Handicap minimum must be less than or equal to maximum',
          );
        }
      }
    }

    // Ensure at least one field is being updated
    if (name == null &&
        description == null &&
        logoUrl == null &&
        isPublic == null &&
        handicapLimitEnabled == null &&
        handicapMin == null &&
        handicapMax == null &&
        location == null &&
        rules == null) {
      throw const InvalidSocietyDataException(
        'At least one field must be provided for update',
      );
    }

    // Delegate to repository
    return await _repository.updateSociety(
      id: id,
      name: finalName,
      description: finalDescription,
      logoUrl: finalLogoUrl,
      isPublic: isPublic,
      handicapLimitEnabled: handicapLimitEnabled,
      handicapMin: handicapMin,
      handicapMax: handicapMax,
      location: finalLocation,
      rules: finalRules,
    );
  }
}
