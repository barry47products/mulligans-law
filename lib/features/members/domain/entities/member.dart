import 'package:equatable/equatable.dart';

/// Domain entity representing a member of a golf society
class Member extends Equatable {
  /// Unique identifier for the member
  final String id;

  /// ID of the society this member belongs to
  final String societyId;

  /// ID of the user account (from auth.users)
  final String userId;

  /// Member's full name
  final String name;

  /// Member's email address
  final String email;

  /// URL to member's avatar image (optional)
  final String? avatarUrl;

  /// Member's handicap index (0-54)
  final double handicap;

  /// Member's role in the society (member, captain)
  final String role;

  /// Timestamp when the member joined the society
  final DateTime joinedAt;

  /// Timestamp of last round played (optional)
  final DateTime? lastPlayedAt;

  const Member({
    required this.id,
    required this.societyId,
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.handicap,
    required this.role,
    required this.joinedAt,
    this.lastPlayedAt,
  });

  @override
  List<Object?> get props => [
    id,
    societyId,
    userId,
    name,
    email,
    avatarUrl,
    handicap,
    role,
    joinedAt,
    lastPlayedAt,
  ];

  /// Creates a copy of this member with updated fields
  Member copyWith({
    String? id,
    String? societyId,
    String? userId,
    String? name,
    String? email,
    String? avatarUrl,
    double? handicap,
    String? role,
    DateTime? joinedAt,
    DateTime? lastPlayedAt,
  }) {
    return Member(
      id: id ?? this.id,
      societyId: societyId ?? this.societyId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      handicap: handicap ?? this.handicap,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }
}
