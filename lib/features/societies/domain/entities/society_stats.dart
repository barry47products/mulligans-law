import 'package:equatable/equatable.dart';

/// Statistics for a golf society
///
/// Contains aggregated data about society membership and performance.
/// This is a pure domain entity with no external dependencies.
class SocietyStats extends Equatable {
  /// Total number of active members in the society
  final int memberCount;

  /// Names of society owners (OWNER and CO_OWNER roles)
  final List<String> ownerNames;

  /// Names of society captains (CAPTAIN role)
  final List<String> captainNames;

  /// Average handicap of all active members
  final double averageHandicap;

  const SocietyStats({
    required this.memberCount,
    required this.ownerNames,
    required this.captainNames,
    required this.averageHandicap,
  });

  @override
  List<Object?> get props => [
    memberCount,
    ownerNames,
    captainNames,
    averageHandicap,
  ];

  /// Creates a copy with optional field overrides
  SocietyStats copyWith({
    int? memberCount,
    List<String>? ownerNames,
    List<String>? captainNames,
    double? averageHandicap,
  }) {
    return SocietyStats(
      memberCount: memberCount ?? this.memberCount,
      ownerNames: ownerNames ?? this.ownerNames,
      captainNames: captainNames ?? this.captainNames,
      averageHandicap: averageHandicap ?? this.averageHandicap,
    );
  }
}
