import '../entities/society.dart';

/// Repository interface for Society operations.
///
/// Defines the contract for society data access.
/// Implementations should handle communication with the data source (Supabase).
abstract class SocietyRepository {
  /// Creates a new society.
  ///
  /// The authenticated user will automatically become a captain (member with CAPTAIN role).
  ///
  /// Returns the created [Society] with generated ID and timestamps.
  ///
  /// Throws:
  /// - [SocietyException] for validation errors
  /// - [NetworkException] for network errors
  Future<Society> createSociety({
    required String name,
    String? description,
    String? logoUrl,
    bool isPublic = false,
    bool handicapLimitEnabled = false,
    int? handicapMin,
    int? handicapMax,
    String? location,
    String? rules,
  });

  /// Gets all societies where the current user is an active member.
  ///
  /// Returns empty list if user is not a member of any societies.
  ///
  /// Throws:
  /// - [UnauthorizedException] if user is not authenticated
  /// - [NetworkException] for network errors
  Future<List<Society>> getUserSocieties();

  /// Gets a specific society by ID.
  ///
  /// User must be an active member to view the society.
  ///
  /// Throws:
  /// - [SocietyNotFoundException] if society doesn't exist or user has no access
  /// - [UnauthorizedException] if user is not authenticated
  /// - [NetworkException] for network errors
  Future<Society> getSocietyById(String id);

  /// Updates an existing society.
  ///
  /// Only captains can update society details.
  ///
  /// Throws:
  /// - [SocietyNotFoundException] if society doesn't exist
  /// - [UnauthorizedException] if user is not a captain
  /// - [SocietyException] for validation errors
  /// - [NetworkException] for network errors
  Future<Society> updateSociety({
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
  });

  /// Deletes a society.
  ///
  /// Only captains can delete a society.
  /// This will cascade delete all related data (members, rounds, scores, etc.).
  ///
  /// Throws:
  /// - [SocietyNotFoundException] if society doesn't exist
  /// - [UnauthorizedException] if user is not a captain
  /// - [NetworkException] for network errors
  Future<void> deleteSociety(String id);

  /// Watches changes to societies where the user is a member.
  ///
  /// Returns a stream that emits updated society lists when changes occur.
  /// Useful for real-time updates in the UI.
  Stream<List<Society>> watchUserSocieties();
}
