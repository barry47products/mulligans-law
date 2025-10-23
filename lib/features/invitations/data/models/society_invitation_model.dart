import '../../domain/entities/society_invitation.dart';

/// Data model for [SocietyInvitation]
class SocietyInvitationModel extends SocietyInvitation {
  const SocietyInvitationModel({
    required super.id,
    required super.societyId,
    required super.societyName,
    required super.invitedUserId,
    required super.invitedUserEmail,
    required super.invitedUserName,
    required super.invitedByUserId,
    required super.invitedByName,
    super.message,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.respondedAt,
  });

  /// Create from JSON
  factory SocietyInvitationModel.fromJson(Map<String, dynamic> json) {
    return SocietyInvitationModel(
      id: json['id'] as String,
      societyId: json['society_id'] as String,
      societyName: json['society_name'] as String,
      invitedUserId: json['invited_user_id'] as String,
      invitedUserEmail: json['invited_user_email'] as String,
      invitedUserName: json['invited_user_name'] as String,
      invitedByUserId: json['invited_by_user_id'] as String,
      invitedByName: json['invited_by_name'] as String,
      message: json['message'] as String?,
      status: _statusFromString(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'society_id': societyId,
      'society_name': societyName,
      'invited_user_id': invitedUserId,
      'invited_user_email': invitedUserEmail,
      'invited_user_name': invitedUserName,
      'invited_by_user_id': invitedByUserId,
      'invited_by_name': invitedByName,
      'message': message,
      'status': _statusToString(status),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
    };
  }

  /// Convert to domain entity
  SocietyInvitation toDomain() {
    return SocietyInvitation(
      id: id,
      societyId: societyId,
      societyName: societyName,
      invitedUserId: invitedUserId,
      invitedUserEmail: invitedUserEmail,
      invitedUserName: invitedUserName,
      invitedByUserId: invitedByUserId,
      invitedByName: invitedByName,
      message: message,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      respondedAt: respondedAt,
    );
  }

  /// Convert status enum to database string
  static String _statusToString(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return 'PENDING';
      case InvitationStatus.accepted:
        return 'ACCEPTED';
      case InvitationStatus.declined:
        return 'DECLINED';
      case InvitationStatus.cancelled:
        return 'CANCELLED';
      case InvitationStatus.expired:
        return 'EXPIRED';
    }
  }

  /// Convert database string to status enum
  static InvitationStatus _statusFromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return InvitationStatus.pending;
      case 'ACCEPTED':
        return InvitationStatus.accepted;
      case 'DECLINED':
        return InvitationStatus.declined;
      case 'CANCELLED':
        return InvitationStatus.cancelled;
      case 'EXPIRED':
        return InvitationStatus.expired;
      default:
        throw ArgumentError('Unknown invitation status: $status');
    }
  }
}
