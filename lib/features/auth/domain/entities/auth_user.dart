import 'package:equatable/equatable.dart';

/// Represents an authenticated user in the domain layer.
///
/// This is a pure domain entity with no external dependencies.
/// It contains the essential user information after authentication.
class AuthUser extends Equatable {
  /// Unique identifier for the user (from Supabase Auth)
  final String id;

  /// User's email address
  final String email;

  /// Optional display name
  final String? name;

  /// Avatar/profile image URL
  final String? avatarUrl;

  /// When the user was created
  final DateTime createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt];

  /// Creates a copy with optional field overrides
  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
