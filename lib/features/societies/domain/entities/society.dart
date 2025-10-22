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

  /// Whether the society is publicly visible and searchable
  final bool isPublic;

  /// Whether handicap limits are enforced for membership
  final bool handicapLimitEnabled;

  /// Minimum handicap allowed when limits are enabled (+8 to 36)
  final int? handicapMin;

  /// Maximum handicap allowed when limits are enabled (+8 to 36)
  final int? handicapMax;

  /// Optional location text (city or course name)
  final String? location;

  /// Optional society rules and guidelines
  final String? rules;

  /// When the society was soft-deleted (null if active)
  final DateTime? deletedAt;

  /// When the society was created
  final DateTime createdAt;

  /// When the society was last updated
  final DateTime updatedAt;

  const Society({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.isPublic = false,
    this.handicapLimitEnabled = false,
    this.handicapMin,
    this.handicapMax,
    this.location,
    this.rules,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    logoUrl,
    isPublic,
    handicapLimitEnabled,
    handicapMin,
    handicapMax,
    location,
    rules,
    deletedAt,
    createdAt,
    updatedAt,
  ];

  /// Creates a copy with optional field overrides
  Society copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    bool? isPublic,
    bool? handicapLimitEnabled,
    int? handicapMin,
    int? handicapMax,
    String? location,
    String? rules,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Society(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      isPublic: isPublic ?? this.isPublic,
      handicapLimitEnabled: handicapLimitEnabled ?? this.handicapLimitEnabled,
      handicapMin: handicapMin ?? this.handicapMin,
      handicapMax: handicapMax ?? this.handicapMax,
      location: location ?? this.location,
      rules: rules ?? this.rules,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
