import '../../../../core/constants/validation_constants.dart';
import '../../../../core/errors/society_exceptions.dart';
import '../entities/society.dart';
import '../repositories/society_repository.dart';
import '../../../members/domain/repositories/member_repository.dart';

/// Creates a new golf society.
///
/// Validates input and delegates to the repository.
/// After creating the society, automatically adds the creator as a captain member.
class CreateSociety {
  final SocietyRepository _societyRepository;
  final MemberRepository _memberRepository;

  CreateSociety(this._societyRepository, this._memberRepository);

  /// Executes the create society operation.
  ///
  /// Validates:
  /// - Name is not empty
  /// - Name does not exceed max length
  /// - Description (if provided) does not exceed max length
  ///
  /// After creating the society:
  /// 1. Fetches the creator's primary member profile
  /// 2. Creates a captain member record (second member record for the user)
  ///
  /// Returns the created [Society] with generated ID and timestamps.
  ///
  /// Throws:
  /// - [InvalidSocietyDataException] for validation errors
  /// - [NetworkException] for network errors
  /// - [SocietyDatabaseException] for database errors
  /// - [MemberNotFoundException] if primary member not found
  /// - [MemberDatabaseException] for member creation errors
  Future<Society> call({
    required String userId,
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

    // Create the society
    final society = await _societyRepository.createSociety(
      name: trimmedName,
      description: finalDescription,
      logoUrl: finalLogoUrl,
    );

    // Get the creator's primary member profile
    final primaryMember = await _memberRepository.getPrimaryMember(userId);

    // Create captain member record (second member record for this user)
    await _memberRepository.addMember(
      societyId: society.id,
      userId: userId,
      name: primaryMember.name,
      email: primaryMember.email,
      handicap: primaryMember.handicap,
      role: 'CAPTAIN',
    );

    return society;
  }
}
