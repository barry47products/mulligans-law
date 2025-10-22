import '../../domain/entities/society.dart';

/// Data model for Society that handles JSON serialization.
///
/// Extends the domain entity and adds conversion methods for
/// communication with Supabase.
class SocietyModel extends Society {
  const SocietyModel({
    required super.id,
    required super.name,
    super.description,
    super.logoUrl,
    super.isPublic = false,
    super.handicapLimitEnabled = false,
    super.handicapMin,
    super.handicapMax,
    super.location,
    super.rules,
    super.deletedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a SocietyModel from JSON data (from Supabase).
  ///
  /// Handles snake_case to camelCase conversion for field names.
  factory SocietyModel.fromJson(Map<String, dynamic> json) {
    return SocietyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      handicapLimitEnabled: json['handicap_limit_enabled'] as bool? ?? false,
      handicapMin: json['handicap_min'] as int?,
      handicapMax: json['handicap_max'] as int?,
      location: json['location'] as String?,
      rules: json['rules'] as String?,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON (for Supabase).
  ///
  /// Handles camelCase to snake_case conversion for field names.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo_url': logoUrl,
      'is_public': isPublic,
      'handicap_limit_enabled': handicapLimitEnabled,
      'handicap_min': handicapMin,
      'handicap_max': handicapMax,
      'location': location,
      'rules': rules,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a SocietyModel from a Society entity.
  factory SocietyModel.fromEntity(Society society) {
    return SocietyModel(
      id: society.id,
      name: society.name,
      description: society.description,
      logoUrl: society.logoUrl,
      isPublic: society.isPublic,
      handicapLimitEnabled: society.handicapLimitEnabled,
      handicapMin: society.handicapMin,
      handicapMax: society.handicapMax,
      location: society.location,
      rules: society.rules,
      deletedAt: society.deletedAt,
      createdAt: society.createdAt,
      updatedAt: society.updatedAt,
    );
  }

  /// Converts the model back to a Society entity.
  Society toEntity() {
    return Society(
      id: id,
      name: name,
      description: description,
      logoUrl: logoUrl,
      isPublic: isPublic,
      handicapLimitEnabled: handicapLimitEnabled,
      handicapMin: handicapMin,
      handicapMax: handicapMax,
      location: location,
      rules: rules,
      deletedAt: deletedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
