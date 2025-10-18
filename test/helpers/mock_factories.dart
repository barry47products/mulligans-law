/// Mock Factories
///
/// This file contains factory functions for creating test data and mock objects.
/// Use these factories to create consistent test data across your test suite.
library;

/// Creates a test score entity with default values.
///
/// Override any fields as needed for specific test cases.
///
/// Example:
/// ```dart
/// final score = createTestScore(
///   id: 'score-1',
///   totalStableford: 36,
/// );
/// ```
Map<String, dynamic> createTestScore({
  String id = 'test-score-1',
  String roundId = 'test-round-1',
  String playerId = 'test-player-1',
  List<int>? holeScores,
  int? totalGross,
  int? totalNet,
  int? totalStableford,
  String status = 'IN_PROGRESS',
}) {
  return {
    'id': id,
    'round_id': roundId,
    'player_id': playerId,
    'hole_scores': holeScores ?? List.filled(18, 4),
    'total_gross': totalGross ?? 72,
    'total_net': totalNet ?? 72,
    'total_stableford': totalStableford ?? 36,
    'status': status,
    'created_at': DateTime.now().toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
  };
}

/// Creates a test round entity with default values.
///
/// Example:
/// ```dart
/// final round = createTestRound(
///   id: 'round-1',
///   courseId: 'course-1',
/// );
/// ```
Map<String, dynamic> createTestRound({
  String id = 'test-round-1',
  String societyId = 'test-society-1',
  String courseId = 'test-course-1',
  DateTime? date,
  String formatType = 'INDIVIDUAL_STABLEFORD',
  String status = 'UPCOMING',
}) {
  return {
    'id': id,
    'society_id': societyId,
    'course_id': courseId,
    'date': (date ?? DateTime.now()).toIso8601String(),
    'format_type': formatType,
    'status': status,
    'created_at': DateTime.now().toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
  };
}

/// Creates a test member entity with default values.
///
/// Example:
/// ```dart
/// final member = createTestMember(
///   id: 'member-1',
///   handicap: 18,
/// );
/// ```
Map<String, dynamic> createTestMember({
  String id = 'test-member-1',
  String societyId = 'test-society-1',
  String userId = 'test-user-1',
  String name = 'Test Player',
  String email = 'test@example.com',
  int handicap = 18,
  String role = 'MEMBER',
  String status = 'ACTIVE',
}) {
  return {
    'id': id,
    'society_id': societyId,
    'user_id': userId,
    'name': name,
    'email': email,
    'handicap': handicap,
    'role': role,
    'status': status,
    'created_at': DateTime.now().toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
  };
}

/// Creates a test society entity with default values.
///
/// Example:
/// ```dart
/// final society = createTestSociety(
///   id: 'society-1',
///   name: 'Test Golf Society',
/// );
/// ```
Map<String, dynamic> createTestSociety({
  String id = 'test-society-1',
  String name = 'Test Golf Society',
  String? description,
}) {
  return {
    'id': id,
    'name': name,
    'description': description,
    'created_at': DateTime.now().toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
  };
}

/// Creates a test course entity with default values.
///
/// Example:
/// ```dart
/// final course = createTestCourse(
///   id: 'course-1',
///   name: 'Test Golf Course',
/// );
/// ```
Map<String, dynamic> createTestCourse({
  String id = 'test-course-1',
  String name = 'Test Golf Course',
  String location = 'Test Location',
  List<Map<String, int>>? holes,
}) {
  // Default 18 holes: Par 4, Stroke Index 1-18
  final defaultHoles = List.generate(
    18,
    (index) => {'par': 4, 'stroke_index': index + 1},
  );

  return {
    'id': id,
    'name': name,
    'location': location,
    'holes': holes ?? defaultHoles,
    'total_par': 72,
    'created_at': DateTime.now().toIso8601String(),
    'updated_at': DateTime.now().toIso8601String(),
  };
}

/// Creates a test user entity with default values.
///
/// Example:
/// ```dart
/// final user = createTestUser(
///   id: 'user-1',
///   email: 'user@test.com',
/// );
/// ```
Map<String, dynamic> createTestUser({
  String id = 'test-user-1',
  String email = 'test@example.com',
  String? name,
}) {
  return {
    'id': id,
    'email': email,
    'name': name ?? 'Test User',
    'created_at': DateTime.now().toIso8601String(),
  };
}
