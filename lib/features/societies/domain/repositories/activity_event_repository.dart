import '../entities/activity_event.dart';

/// Repository interface for activity event operations
///
/// TODO: This is scaffolding for future implementation.
/// Activity events will be created automatically by triggers
/// or application logic when certain actions occur.
abstract class ActivityEventRepository {
  /// Fetches recent activity events for a society
  /// Returns events ordered by timestamp (newest first)
  /// [limit] controls how many events to return (default 50)
  Future<List<ActivityEvent>> getSocietyActivityEvents(
    String societyId, {
    int limit = 50,
  });

  /// Creates a new activity event
  /// This will be used internally by the app when actions occur
  Future<ActivityEvent> createActivityEvent({
    required String type,
    required String societyId,
    String? userId,
    String? userName,
    Map<String, dynamic>? metadata,
  });

  /// Streams activity events for real-time updates
  /// Returns a stream that emits new events as they occur
  Stream<List<ActivityEvent>> watchSocietyActivityEvents(String societyId);
}
