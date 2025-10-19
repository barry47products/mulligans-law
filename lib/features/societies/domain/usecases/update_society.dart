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

    // Ensure at least one field is being updated
    // (check the original parameters, not the processed ones)
    if (name == null && description == null && logoUrl == null) {
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
    );
  }
}
