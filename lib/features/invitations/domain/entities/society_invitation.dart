import 'package:equatable/equatable.dart';

/// Represents an invitation to join a society
///
/// Invitations are sent by society captains/owners to existing app users.
/// The invited user can accept or decline the invitation.
class SocietyInvitation extends Equatable {
  /// Unique identifier for the invitation
  final String id;

  /// ID of the society the user is invited to
  final String societyId;

  /// Name of the society (for display purposes)
  final String societyName;

  /// ID of the user being invited
  final String invitedUserId;

  /// Email of the user being invited
  final String invitedUserEmail;

  /// Name of the user being invited
  final String invitedUserName;

  /// ID of the user who sent the invitation (captain/owner)
  final String invitedByUserId;

  /// Name of the user who sent the invitation
  final String invitedByName;

  /// Optional custom message from the inviter
  final String? message;

  /// Current status of the invitation
  final InvitationStatus status;

  /// When the invitation was created
  final DateTime createdAt;

  /// When the invitation was last updated
  final DateTime updatedAt;

  /// When the invitation was responded to (accepted/declined)
  final DateTime? respondedAt;

  const SocietyInvitation({
    required this.id,
    required this.societyId,
    required this.societyName,
    required this.invitedUserId,
    required this.invitedUserEmail,
    required this.invitedUserName,
    required this.invitedByUserId,
    required this.invitedByName,
    this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.respondedAt,
  });

  @override
  List<Object?> get props => [
    id,
    societyId,
    societyName,
    invitedUserId,
    invitedUserEmail,
    invitedUserName,
    invitedByUserId,
    invitedByName,
    message,
    status,
    createdAt,
    updatedAt,
    respondedAt,
  ];

  /// Creates a copy with updated fields
  SocietyInvitation copyWith({
    String? id,
    String? societyId,
    String? societyName,
    String? invitedUserId,
    String? invitedUserEmail,
    String? invitedUserName,
    String? invitedByUserId,
    String? invitedByName,
    String? message,
    InvitationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? respondedAt,
  }) {
    return SocietyInvitation(
      id: id ?? this.id,
      societyId: societyId ?? this.societyId,
      societyName: societyName ?? this.societyName,
      invitedUserId: invitedUserId ?? this.invitedUserId,
      invitedUserEmail: invitedUserEmail ?? this.invitedUserEmail,
      invitedUserName: invitedUserName ?? this.invitedUserName,
      invitedByUserId: invitedByUserId ?? this.invitedByUserId,
      invitedByName: invitedByName ?? this.invitedByName,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}

/// Status of a society invitation
enum InvitationStatus {
  /// Invitation has been sent but not yet responded to
  pending,

  /// Invitation was accepted by the user
  accepted,

  /// Invitation was declined by the user
  declined,

  /// Invitation was cancelled by the sender
  cancelled,

  /// Invitation has expired
  expired,
}
