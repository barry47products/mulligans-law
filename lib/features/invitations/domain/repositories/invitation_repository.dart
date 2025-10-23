import '../entities/society_invitation.dart';

/// Repository interface for managing society invitations
///
/// This defines the contract for invitation operations without exposing
/// implementation details.
abstract class InvitationRepository {
  /// Send an invitation to a user to join a society
  ///
  /// [societyId] - ID of the society to invite the user to
  /// [invitedUserId] - ID of the user being invited
  /// [invitedByUserId] - ID of the user sending the invitation
  /// [message] - Optional custom message to include
  ///
  /// Returns the created invitation
  ///
  /// Throws:
  /// - [UserAlreadyMemberException] if user is already a member
  /// - [PendingInvitationExistsException] if user already has pending invitation
  /// - [UnauthorizedException] if sender doesn't have permission
  /// - [HandicapValidationException] if user's handicap is outside society limits
  /// - [NetworkException] if there's no internet connection
  /// - [DatabaseException] for other database errors
  Future<SocietyInvitation> sendInvitation({
    required String societyId,
    required String invitedUserId,
    required String invitedByUserId,
    String? message,
  });

  /// Get a specific invitation by ID
  ///
  /// Returns null if invitation doesn't exist
  Future<SocietyInvitation?> getInvitation(String invitationId);

  /// Get all pending invitations for a user
  ///
  /// Returns list of invitations that are still pending
  Future<List<SocietyInvitation>> getPendingInvitationsForUser(String userId);

  /// Get all invitations sent by a user
  ///
  /// [userId] - ID of the user who sent the invitations
  /// [societyId] - Optional filter by society
  Future<List<SocietyInvitation>> getInvitationsSentBy({
    required String userId,
    String? societyId,
  });

  /// Get all invitations for a society
  ///
  /// [societyId] - ID of the society
  /// [status] - Optional filter by invitation status
  Future<List<SocietyInvitation>> getSocietyInvitations({
    required String societyId,
    InvitationStatus? status,
  });

  /// Accept an invitation
  ///
  /// Creates a member record and updates invitation status
  ///
  /// Throws:
  /// - [InvitationNotFoundException] if invitation doesn't exist
  /// - [InvitationExpiredException] if invitation has expired
  /// - [InvitationAlreadyRespondedException] if already accepted/declined
  /// - [DatabaseException] for other database errors
  Future<SocietyInvitation> acceptInvitation(String invitationId);

  /// Decline an invitation
  ///
  /// Updates invitation status to declined
  ///
  /// Throws:
  /// - [InvitationNotFoundException] if invitation doesn't exist
  /// - [InvitationAlreadyRespondedException] if already accepted/declined
  /// - [DatabaseException] for other database errors
  Future<SocietyInvitation> declineInvitation(String invitationId);

  /// Cancel an invitation
  ///
  /// Only the sender or society captain can cancel
  ///
  /// Throws:
  /// - [InvitationNotFoundException] if invitation doesn't exist
  /// - [UnauthorizedException] if user doesn't have permission
  /// - [InvitationAlreadyRespondedException] if already accepted/declined
  /// - [DatabaseException] for other database errors
  Future<SocietyInvitation> cancelInvitation(String invitationId);

  /// Watch pending invitations for a user
  ///
  /// Returns a stream that emits whenever pending invitations change
  Stream<List<SocietyInvitation>> watchPendingInvitationsForUser(String userId);
}
