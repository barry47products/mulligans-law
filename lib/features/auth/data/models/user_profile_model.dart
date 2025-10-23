import '../../domain/entities/user_profile.dart';

/// Data model for [UserProfile]
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.handicap,
    super.avatarUrl,
  });

  /// Create from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      handicap: json['handicap'] != null
          ? (json['handicap'] is int
                ? json['handicap'] as int
                : (json['handicap'] as num).round())
          : null,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'handicap': handicap,
      'avatar_url': avatarUrl,
    };
  }

  /// Convert to domain entity
  UserProfile toDomain() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      handicap: handicap,
      avatarUrl: avatarUrl,
    );
  }
}
