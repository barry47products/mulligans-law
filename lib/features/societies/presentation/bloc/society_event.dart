import 'package:equatable/equatable.dart';

/// Base class for all society events
abstract class SocietyEvent extends Equatable {
  const SocietyEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all societies for the current user
class SocietyLoadRequested extends SocietyEvent {
  const SocietyLoadRequested();
}

/// Event to create a new society
class SocietyCreateRequested extends SocietyEvent {
  final String userId;
  final String name;
  final String? description;
  final String? logoUrl;
  final bool isPublic;
  final bool handicapLimitEnabled;
  final int? handicapMin;
  final int? handicapMax;
  final String? location;
  final String? rules;

  const SocietyCreateRequested({
    required this.userId,
    required this.name,
    this.description,
    this.logoUrl,
    this.isPublic = false,
    this.handicapLimitEnabled = false,
    this.handicapMin,
    this.handicapMax,
    this.location,
    this.rules,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    description,
    logoUrl,
    isPublic,
    handicapLimitEnabled,
    handicapMin,
    handicapMax,
    location,
    rules,
  ];
}

/// Event to update an existing society
class SocietyUpdateRequested extends SocietyEvent {
  final String id;
  final String? name;
  final String? description;
  final String? logoUrl;
  final bool? isPublic;
  final bool? handicapLimitEnabled;
  final int? handicapMin;
  final int? handicapMax;
  final String? location;
  final String? rules;

  const SocietyUpdateRequested({
    required this.id,
    this.name,
    this.description,
    this.logoUrl,
    this.isPublic,
    this.handicapLimitEnabled,
    this.handicapMin,
    this.handicapMax,
    this.location,
    this.rules,
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
  ];
}

/// Event to delete a society
class SocietyDeleteRequested extends SocietyEvent {
  final String id;

  const SocietyDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to select a specific society
class SocietySelected extends SocietyEvent {
  final String societyId;

  const SocietySelected(this.societyId);

  @override
  List<Object?> get props => [societyId];
}

/// Event to clear the selected society
class SocietyClearSelection extends SocietyEvent {
  const SocietyClearSelection();
}

/// Event to load public societies that the user can discover and join
class SocietyLoadPublicRequested extends SocietyEvent {
  const SocietyLoadPublicRequested();
}
