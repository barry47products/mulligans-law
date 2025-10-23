import '../entities/society_invitation.dart';
import '../repositories/invitation_repository.dart';

/// Use case for sending a society invitation to a user
///
/// This use case validates the request and delegates to the repository
/// to create and send the invitation.
class SendSocietyInvitation {
  final InvitationRepository _repository;

  SendSocietyInvitation(this._repository);

  /// Send an invitation to a user to join a society
  ///
  /// [societyId] - ID of the society to invite the user to
  /// [invitedUserId] - ID of the user being invited
  /// [invitedByUserId] - ID of the user sending the invitation
  /// [message] - Optional custom message to include
  ///
  /// Returns the created invitation
  ///
  /// Throws exceptions from the repository if invitation cannot be sent
  Future<SocietyInvitation> call({
    required String societyId,
    required String invitedUserId,
    required String invitedByUserId,
    String? message,
  }) async {
    return await _repository.sendInvitation(
      societyId: societyId,
      invitedUserId: invitedUserId,
      invitedByUserId: invitedByUserId,
      message: message,
    );
  }
}
