import 'package:equatable/equatable.dart';

/// Represents an activity event in a society
///
/// Activity events are used to display a feed of recent actions
/// and changes within a society (member joined, round completed, etc.)
class ActivityEvent extends Equatable {
  /// Unique identifier for the event
  final String id;

  /// Type of activity event (e.g., 'member_joined', 'round_completed', 'role_changed')
  final String type;

  /// ID of the society this event belongs to
  final String societyId;

  /// ID of the user who triggered this event (optional)
  final String? userId;

  /// Name of the user who triggered this event (for display)
  final String? userName;

  /// When the event occurred
  final DateTime timestamp;

  /// Additional metadata specific to the event type (JSON-like map)
  /// Example: {'role': 'CAPTAIN', 'oldRole': 'MEMBER'}
  final Map<String, dynamic> metadata;

  const ActivityEvent({
    required this.id,
    required this.type,
    required this.societyId,
    this.userId,
    this.userName,
    required this.timestamp,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    id,
    type,
    societyId,
    userId,
    userName,
    timestamp,
    metadata,
  ];

  /// Creates a copy with optional field overrides
  ActivityEvent copyWith({
    String? id,
    String? type,
    String? societyId,
    String? userId,
    String? userName,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return ActivityEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      societyId: societyId ?? this.societyId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Common activity event types
class ActivityEventType {
  const ActivityEventType._();

  static const String memberJoined = 'member_joined';
  static const String memberResigned = 'member_resigned';
  static const String roleChanged = 'role_changed';
  static const String roundCompleted = 'round_completed';
  static const String societyUpdated = 'society_updated';
}
