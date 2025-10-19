import 'package:equatable/equatable.dart';

/// Represents a golf society in the domain layer.
///
/// This is a pure domain entity with no external dependencies.
/// A society is the top-level organization that contains members,
/// organizes rounds, and manages tournaments.
class Society extends Equatable {
  /// Unique identifier for the society
  final String id;

  /// Name of the society (e.g., "Mulligans Golf Society")
  final String name;

  /// Optional description of the society
  final String? description;

  /// URL to society logo image in Supabase Storage
  final String? logoUrl;

  /// When the society was created
  final DateTime createdAt;

  /// When the society was last updated
  final DateTime updatedAt;

  const Society({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    logoUrl,
    createdAt,
    updatedAt,
  ];

  /// Creates a copy with optional field overrides
  Society copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Society(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
