import 'package:equatable/equatable.dart';

/// Represents a basic user profile for search and display
///
/// This is a lightweight version of AuthUser used for searching
/// and displaying users in lists (e.g., invite screens)
class UserProfile extends Equatable {
  /// Unique identifier for the user
  final String id;

  /// User's display name
  final String name;

  /// User's email address
  final String email;

  /// User's handicap (optional)
  final int? handicap;

  /// URL to user's avatar image (optional)
  final String? avatarUrl;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.handicap,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, email, handicap, avatarUrl];

  /// Creates a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? handicap,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      handicap: handicap ?? this.handicap,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
