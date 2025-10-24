import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/members/data/models/member_model.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';

void main() {
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');
  final testLastPlayed = DateTime.parse('2025-01-10T14:00:00.000Z');

  final testJson = {
    'id': 'member-1',
    'society_id': 'society-1',
    'user_id': 'user-1',
    'name': 'James Wilson',
    'email': 'james@example.com',
    'avatar_url': 'https://example.com/avatar.jpg',
    'handicap': 8.4,
    'role': 'member',
    'joined_at': '2025-01-15T10:30:00.000Z',
    'last_played_at': '2025-01-10T14:00:00.000Z',
  };

  final testMember = Member(
    id: 'member-1',
    societyId: 'society-1',
    userId: 'user-1',
    name: 'James Wilson',
    email: 'james@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
    handicap: 8.4,
    role: 'member',
    joinedAt: testDateTime,
    lastPlayedAt: testLastPlayed,
  );

  group('MemberModel', () {
    test('should be a subclass of Member entity', () {
      // Arrange
      final model = MemberModel(
        id: 'member-1',
        societyId: 'society-1',
        userId: 'user-1',
        name: 'James Wilson',
        email: 'james@example.com',
        handicap: 8.4,
        role: 'member',
        joinedAt: testDateTime,
      );

      // Assert
      expect(model, isA<Member>());
    });

    group('fromJson', () {
      test('should return a valid MemberModel from JSON', () {
        // Act
        final result = MemberModel.fromJson(testJson);

        // Assert
        expect(result.id, 'member-1');
        expect(result.societyId, 'society-1');
        expect(result.userId, 'user-1');
        expect(result.name, 'James Wilson');
        expect(result.email, 'james@example.com');
        expect(result.avatarUrl, 'https://example.com/avatar.jpg');
        expect(result.handicap, 8.4);
        expect(result.role, 'member');
        expect(result.joinedAt, testDateTime);
        expect(result.lastPlayedAt, testLastPlayed);
      });

      test('should handle null avatarUrl', () {
        // Arrange
        final jsonWithoutAvatar = Map<String, dynamic>.from(testJson)
          ..remove('avatar_url');

        // Act
        final result = MemberModel.fromJson(jsonWithoutAvatar);

        // Assert
        expect(result.avatarUrl, isNull);
      });

      test('should handle null lastPlayedAt', () {
        // Arrange
        final jsonWithoutLastPlayed = Map<String, dynamic>.from(testJson)
          ..remove('last_played_at');

        // Act
        final result = MemberModel.fromJson(jsonWithoutLastPlayed);

        // Assert
        expect(result.lastPlayedAt, isNull);
      });

      test('should handle missing optional fields', () {
        // Arrange
        final minimalJson = {
          'id': 'member-1',
          'society_id': 'society-1',
          'user_id': 'user-1',
          'name': 'James Wilson',
          'email': 'james@example.com',
          'handicap': 8.4,
          'role': 'member',
          'joined_at': '2025-01-15T10:30:00.000Z',
        };

        // Act
        final result = MemberModel.fromJson(minimalJson);

        // Assert
        expect(result.avatarUrl, isNull);
        expect(result.lastPlayedAt, isNull);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Arrange
        final model = MemberModel(
          id: 'member-1',
          societyId: 'society-1',
          userId: 'user-1',
          name: 'James Wilson',
          email: 'james@example.com',
          avatarUrl: 'https://example.com/avatar.jpg',
          handicap: 8.4,
          role: 'member',
          status: 'ACTIVE',
          joinedAt: testDateTime,
          lastPlayedAt: testLastPlayed,
        );

        // Act
        final result = model.toJson();

        // Assert
        expect(result, {
          'id': 'member-1',
          'society_id': 'society-1',
          'user_id': 'user-1',
          'name': 'James Wilson',
          'email': 'james@example.com',
          'avatar_url': 'https://example.com/avatar.jpg',
          'handicap': 8.4,
          'role': 'member',
          'status': 'ACTIVE',
          'expires_at': null,
          'joined_at': '2025-01-15T10:30:00.000Z',
          'last_played_at': '2025-01-10T14:00:00.000Z',
        });
      });

      test('should handle null avatarUrl in JSON output', () {
        // Arrange
        final model = MemberModel(
          id: 'member-1',
          societyId: 'society-1',
          userId: 'user-1',
          name: 'James Wilson',
          email: 'james@example.com',
          handicap: 8.4,
          role: 'member',
          joinedAt: testDateTime,
        );

        // Act
        final result = model.toJson();

        // Assert
        expect(result['avatar_url'], isNull);
      });

      test('should handle null lastPlayedAt in JSON output', () {
        // Arrange
        final model = MemberModel(
          id: 'member-1',
          societyId: 'society-1',
          userId: 'user-1',
          name: 'James Wilson',
          email: 'james@example.com',
          handicap: 8.4,
          role: 'member',
          joinedAt: testDateTime,
        );

        // Act
        final result = model.toJson();

        // Assert
        expect(result['last_played_at'], isNull);
      });
    });

    group('fromEntity', () {
      test('should convert Member entity to MemberModel', () {
        // Act
        final result = MemberModel.fromEntity(testMember);

        // Assert
        expect(result, isA<MemberModel>());
        expect(result.id, testMember.id);
        expect(result.societyId, testMember.societyId);
        expect(result.userId, testMember.userId);
        expect(result.name, testMember.name);
        expect(result.email, testMember.email);
        expect(result.avatarUrl, testMember.avatarUrl);
        expect(result.handicap, testMember.handicap);
        expect(result.role, testMember.role);
        expect(result.joinedAt, testMember.joinedAt);
        expect(result.lastPlayedAt, testMember.lastPlayedAt);
      });
    });

    group('toEntity', () {
      test('should convert MemberModel to Member entity', () {
        // Arrange
        final model = MemberModel.fromJson(testJson);

        // Act
        final result = model.toEntity();

        // Assert
        expect(result, isA<Member>());
        expect(result.id, model.id);
        expect(result.societyId, model.societyId);
        expect(result.userId, model.userId);
        expect(result.name, model.name);
        expect(result.email, model.email);
        expect(result.avatarUrl, model.avatarUrl);
        expect(result.handicap, model.handicap);
        expect(result.role, model.role);
        expect(result.joinedAt, model.joinedAt);
        expect(result.lastPlayedAt, model.lastPlayedAt);
      });
    });

    group('JSON serialization round-trip', () {
      test('should maintain data integrity through encode/decode cycle', () {
        // Arrange
        final originalModel = MemberModel.fromEntity(testMember);

        // Act - Encode to JSON and decode back
        final json = originalModel.toJson();
        final decodedModel = MemberModel.fromJson(json);

        // Assert - Should be equal after round-trip
        expect(decodedModel.id, originalModel.id);
        expect(decodedModel.societyId, originalModel.societyId);
        expect(decodedModel.userId, originalModel.userId);
        expect(decodedModel.name, originalModel.name);
        expect(decodedModel.email, originalModel.email);
        expect(decodedModel.avatarUrl, originalModel.avatarUrl);
        expect(decodedModel.handicap, originalModel.handicap);
        expect(decodedModel.role, originalModel.role);
        expect(decodedModel.joinedAt, originalModel.joinedAt);
        expect(decodedModel.lastPlayedAt, originalModel.lastPlayedAt);
      });
    });

    group('Primary member profile support', () {
      test('should handle null society_id for primary member', () {
        // Arrange - Primary member JSON (no society association)
        final primaryMemberJson = {
          'id': 'member-primary-1',
          'society_id': null,
          'user_id': 'user-1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'avatar_url': null,
          'handicap': 10.5,
          'role': null,
          'joined_at': '2025-01-15T10:30:00.000Z',
          'last_played_at': null,
        };

        // Act
        final result = MemberModel.fromJson(primaryMemberJson);

        // Assert
        expect(result.societyId, isNull);
        expect(result.role, isNull);
        expect(result.name, 'John Doe');
        expect(result.userId, 'user-1');
      });

      test('should serialize null society_id correctly', () {
        // Arrange - Primary member model
        final primaryMember = MemberModel(
          id: 'member-primary-1',
          societyId: null,
          userId: 'user-1',
          name: 'John Doe',
          email: 'john@example.com',
          handicap: 10.5,
          role: null,
          joinedAt: testDateTime,
        );

        // Act
        final json = primaryMember.toJson();

        // Assert
        expect(json['society_id'], isNull);
        expect(json['role'], isNull);
        expect(json['name'], 'John Doe');
      });

      test('should handle primary member with avatar', () {
        // Arrange
        final primaryMemberJson = {
          'id': 'member-primary-2',
          'society_id': null,
          'user_id': 'user-2',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'avatar_url': 'https://example.com/jane.jpg',
          'handicap': 15.0,
          'role': null,
          'joined_at': '2025-01-20T12:00:00.000Z',
          'last_played_at': '2025-01-19T09:00:00.000Z',
        };

        // Act
        final result = MemberModel.fromJson(primaryMemberJson);

        // Assert
        expect(result.societyId, isNull);
        expect(result.role, isNull);
        expect(result.avatarUrl, 'https://example.com/jane.jpg');
        expect(result.lastPlayedAt, isNotNull);
      });
    });
  });
}
