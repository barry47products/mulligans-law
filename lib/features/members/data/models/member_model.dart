import '../../domain/entities/member.dart';

/// Data model for Member entity with JSON serialization support
class MemberModel extends Member {
  const MemberModel({
    required super.id,
    super.societyId,
    required super.userId,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.handicap,
    super.role,
    required super.joinedAt,
    super.lastPlayedAt,
  });

  /// Creates a MemberModel from JSON data (from Supabase)
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String,
      societyId: json['society_id'] as String?,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      handicap: (json['handicap'] as num).toDouble(),
      role: json['role'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      lastPlayedAt: json['last_played_at'] != null
          ? DateTime.parse(json['last_played_at'] as String)
          : null,
    );
  }

  /// Converts this model to JSON format (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'society_id': societyId,
      'user_id': userId,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'handicap': handicap,
      'role': role,
      'joined_at': joinedAt.toIso8601String(),
      'last_played_at': lastPlayedAt?.toIso8601String(),
    };
  }

  /// Creates a MemberModel from a Member entity
  factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      id: member.id,
      societyId: member.societyId,
      userId: member.userId,
      name: member.name,
      email: member.email,
      avatarUrl: member.avatarUrl,
      handicap: member.handicap,
      role: member.role,
      joinedAt: member.joinedAt,
      lastPlayedAt: member.lastPlayedAt,
    );
  }

  /// Converts this model to a Member entity
  Member toEntity() {
    return Member(
      id: id,
      societyId: societyId,
      userId: userId,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      handicap: handicap,
      role: role,
      joinedAt: joinedAt,
      lastPlayedAt: lastPlayedAt,
    );
  }
}
