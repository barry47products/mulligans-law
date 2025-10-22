import '../../../../core/constants/validation_constants.dart';
import '../../../../core/errors/society_exceptions.dart';
import '../entities/society.dart';
import '../repositories/society_repository.dart';

/// Creates a new golf society.
///
/// Validates input and delegates to the repository.
/// The repository uses a database function that automatically adds the creator as a captain member.
class CreateSociety {
  final SocietyRepository _societyRepository;

  CreateSociety(this._societyRepository);

  /// Executes the create society operation.
  ///
  /// Validates:
  /// - Name is not empty
  /// - Name does not exceed max length
  /// - Description (if provided) does not exceed max length
  /// - Handicap range is valid (min <= max, within -8 to 36)
  ///
  /// The repository uses a database function that atomically:
  /// 1. Creates the society record
  /// 2. Automatically adds the creator as a captain member
  ///
  /// Returns the created [Society] with generated ID and timestamps.
  ///
  /// Throws:
  /// - [InvalidSocietyDataException] for validation errors
  /// - [NetworkException] for network errors
  /// - [SocietyDatabaseException] for database errors
  Future<Society> call({
    required String userId,
    required String name,
    String? description,
    String? logoUrl,
    bool isPublic = false,
    bool handicapLimitEnabled = false,
    int? handicapMin,
    int? handicapMax,
    String? location,
    String? rules,
  }) async {
    // Trim and validate name
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const InvalidSocietyDataException(
        ValidationMessages.societyNameEmpty,
      );
    }

    if (trimmedName.length > ValidationConstants.societyNameMaxLength) {
      throw const InvalidSocietyDataException(
        ValidationMessages.societyNameTooLong,
      );
    }

    // Validate description length if provided
    String? finalDescription = description?.trim();
    if (finalDescription != null && finalDescription.isEmpty) {
      finalDescription = null;
    }

    if (finalDescription != null &&
        finalDescription.length >
            ValidationConstants.societyDescriptionMaxLength) {
      throw const InvalidSocietyDataException(
        ValidationMessages.societyDescriptionTooLong,
      );
    }

    // Handle empty logo URL
    String? finalLogoUrl = logoUrl?.trim();
    if (finalLogoUrl != null && finalLogoUrl.isEmpty) {
      finalLogoUrl = null;
    }

    // Validate and process location
    String? finalLocation = location?.trim();
    if (finalLocation != null && finalLocation.isEmpty) {
      finalLocation = null;
    }

    // Validate and process rules
    String? finalRules = rules?.trim();
    if (finalRules != null && finalRules.isEmpty) {
      finalRules = null;
    }

    // Validate handicap limits if enabled
    if (handicapLimitEnabled) {
      if (handicapMin == null || handicapMax == null) {
        throw const InvalidSocietyDataException(
          'Handicap min and max must be provided when handicap limits are enabled',
        );
      }

      // Validate handicap range (-8 to 36)
      if (handicapMin < -8 || handicapMin > 36) {
        throw const InvalidSocietyDataException(
          'Handicap minimum must be between -8 and 36',
        );
      }

      if (handicapMax < -8 || handicapMax > 36) {
        throw const InvalidSocietyDataException(
          'Handicap maximum must be between -8 and 36',
        );
      }

      // Validate min <= max
      if (handicapMin > handicapMax) {
        throw const InvalidSocietyDataException(
          'Handicap minimum must be less than or equal to maximum',
        );
      }
    }

    // Create the society
    // Note: The repository's createSociety now uses a database function
    // that automatically adds the creator as a captain member,
    // so we don't need to do it here anymore.
    final society = await _societyRepository.createSociety(
      name: trimmedName,
      description: finalDescription,
      logoUrl: finalLogoUrl,
      isPublic: isPublic,
      handicapLimitEnabled: handicapLimitEnabled,
      handicapMin: handicapLimitEnabled ? handicapMin : null,
      handicapMax: handicapLimitEnabled ? handicapMax : null,
      location: finalLocation,
      rules: finalRules,
    );

    return society;
  }
}
