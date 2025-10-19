import '../../../../core/constants/validation_constants.dart';
import '../../../../core/errors/society_exceptions.dart';
import '../entities/society.dart';
import '../repositories/society_repository.dart';

/// Creates a new golf society.
///
/// Validates input and delegates to the repository.
/// The authenticated user automatically becomes a captain (via database trigger).
class CreateSociety {
  final SocietyRepository _repository;

  CreateSociety(this._repository);

  /// Executes the create society operation.
  ///
  /// Validates:
  /// - Name is not empty
  /// - Name does not exceed max length
  /// - Description (if provided) does not exceed max length
  ///
  /// Returns the created [Society] with generated ID and timestamps.
  ///
  /// Throws:
  /// - [InvalidSocietyDataException] for validation errors
  /// - [NetworkException] for network errors
  /// - [SocietyDatabaseException] for database errors
  Future<Society> call({
    required String name,
    String? description,
    String? logoUrl,
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

    // Delegate to repository
    return await _repository.createSociety(
      name: trimmedName,
      description: finalDescription,
      logoUrl: finalLogoUrl,
    );
  }
}
