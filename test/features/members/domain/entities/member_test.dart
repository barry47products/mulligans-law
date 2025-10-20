import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';

void main() {
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');
  final testLastPlayed = DateTime.parse('2025-01-10T14:00:00.000Z');

  final testMember = Member(
    id: 'member-1',
    societyId: 'society-1',
    userId: 'user-1',
    name: 'James Wilson',
    email: 'james@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
    handicap: 8.4,
    role: 'MEMBER',
    joinedAt: testDateTime,
    lastPlayedAt: testLastPlayed,
  );

  final primaryMember = Member(
    id: 'member-primary-1',
    societyId: null,
    userId: 'user-2',
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 10.5,
    role: null,
    joinedAt: testDateTime,
  );

  group('Member Entity', () {
    group('copyWith', () {
      test('should create copy with updated name', () {
        // Arrange
        const newName = 'Updated Name';

        // Act
        final result = testMember.copyWith(name: newName);

        // Assert
        expect(result.name, newName);
        expect(result.id, testMember.id);
        expect(result.societyId, testMember.societyId);
        expect(result.userId, testMember.userId);
        expect(result.email, testMember.email);
        expect(result.handicap, testMember.handicap);
        expect(result.role, testMember.role);
      });

      test('should preserve all unchanged fields when updating one field', () {
        // Arrange
        const newHandicap = 12.5;

        // Act
        final result = testMember.copyWith(handicap: newHandicap);

        // Assert
        expect(result.handicap, newHandicap);
        // Verify all other fields unchanged
        expect(result.id, testMember.id);
        expect(result.societyId, testMember.societyId);
        expect(result.userId, testMember.userId);
        expect(result.name, testMember.name);
        expect(result.email, testMember.email);
        expect(result.avatarUrl, testMember.avatarUrl);
        expect(result.role, testMember.role);
        expect(result.joinedAt, testMember.joinedAt);
        expect(result.lastPlayedAt, testMember.lastPlayedAt);
      });

      test('should handle updating nullable societyId', () {
        // Arrange
        const newSocietyId = 'new-society-id';

        // Act
        final result = primaryMember.copyWith(societyId: newSocietyId);

        // Assert
        expect(result.societyId, newSocietyId);
        expect(result.id, primaryMember.id);
        expect(result.userId, primaryMember.userId);
      });

      test('should handle updating nullable role', () {
        // Arrange
        const newRole = 'CAPTAIN';

        // Act
        final result = primaryMember.copyWith(role: newRole);

        // Assert
        expect(result.role, newRole);
        expect(result.societyId, isNull);
        expect(result.name, primaryMember.name);
      });

      test('should handle updating nullable avatarUrl', () {
        // Arrange
        const newAvatarUrl = 'https://example.com/new-avatar.jpg';

        // Act
        final result = testMember.copyWith(avatarUrl: newAvatarUrl);

        // Assert
        expect(result.avatarUrl, newAvatarUrl);
      });

      test('should handle updating nullable lastPlayedAt', () {
        // Arrange
        final newLastPlayed = DateTime.parse('2025-01-20T15:00:00.000Z');

        // Act
        final result = primaryMember.copyWith(lastPlayedAt: newLastPlayed);

        // Assert
        expect(result.lastPlayedAt, newLastPlayed);
        expect(primaryMember.lastPlayedAt, isNull); // Original unchanged
      });

      test('should handle updating all fields at once', () {
        // Arrange
        const newId = 'new-id';
        const newSocietyId = 'new-society';
        const newUserId = 'new-user';
        const newName = 'New Name';
        const newEmail = 'new@example.com';
        const newAvatarUrl = 'https://example.com/new.jpg';
        const newHandicap = 15.0;
        const newRole = 'CAPTAIN';
        final newJoinedAt = DateTime.parse('2025-02-01T10:00:00.000Z');
        final newLastPlayed = DateTime.parse('2025-02-05T14:00:00.000Z');

        // Act
        final result = testMember.copyWith(
          id: newId,
          societyId: newSocietyId,
          userId: newUserId,
          name: newName,
          email: newEmail,
          avatarUrl: newAvatarUrl,
          handicap: newHandicap,
          role: newRole,
          joinedAt: newJoinedAt,
          lastPlayedAt: newLastPlayed,
        );

        // Assert
        expect(result.id, newId);
        expect(result.societyId, newSocietyId);
        expect(result.userId, newUserId);
        expect(result.name, newName);
        expect(result.email, newEmail);
        expect(result.avatarUrl, newAvatarUrl);
        expect(result.handicap, newHandicap);
        expect(result.role, newRole);
        expect(result.joinedAt, newJoinedAt);
        expect(result.lastPlayedAt, newLastPlayed);
      });

      test('should create new instance (not modify original)', () {
        // Arrange
        const newName = 'Updated Name';

        // Act
        final result = testMember.copyWith(name: newName);

        // Assert
        expect(result, isNot(same(testMember)));
        expect(testMember.name, 'James Wilson'); // Original unchanged
        expect(result.name, newName);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        // Arrange
        final member1 = Member(
          id: 'member-1',
          societyId: 'society-1',
          userId: 'user-1',
          name: 'James Wilson',
          email: 'james@example.com',
          avatarUrl: 'https://example.com/avatar.jpg',
          handicap: 8.4,
          role: 'MEMBER',
          joinedAt: testDateTime,
          lastPlayedAt: testLastPlayed,
        );

        final member2 = Member(
          id: 'member-1',
          societyId: 'society-1',
          userId: 'user-1',
          name: 'James Wilson',
          email: 'james@example.com',
          avatarUrl: 'https://example.com/avatar.jpg',
          handicap: 8.4,
          role: 'MEMBER',
          joinedAt: testDateTime,
          lastPlayedAt: testLastPlayed,
        );

        // Assert
        expect(member1, equals(member2));
        expect(member1.hashCode, equals(member2.hashCode));
      });

      test('should not be equal when societyId differs', () {
        // Arrange
        final member1 = testMember;
        final member2 = testMember.copyWith(societyId: 'different-society');

        // Assert
        expect(member1, isNot(equals(member2)));
      });

      test('should not be equal when role differs', () {
        // Arrange
        final member1 = testMember;
        final member2 = testMember.copyWith(role: 'CAPTAIN');

        // Assert
        expect(member1, isNot(equals(member2)));
      });

      test('should be equal when both have null societyId', () {
        // Arrange
        final member1 = primaryMember;
        final member2 = Member(
          id: 'member-primary-1',
          societyId: null,
          userId: 'user-2',
          name: 'John Doe',
          email: 'john@example.com',
          handicap: 10.5,
          role: null,
          joinedAt: testDateTime,
        );

        // Assert
        expect(member1, equals(member2));
      });

      test(
        'should not be equal when one has null societyId and other does not',
        () {
          // Arrange
          final member1 = primaryMember;
          final member2 = primaryMember.copyWith(societyId: 'society-1');

          // Assert
          expect(member1, isNot(equals(member2)));
        },
      );

      test('should handle hashCode consistency', () {
        // Arrange
        final member1 = testMember;
        final member2 = testMember.copyWith();

        // Assert - Same object should have same hashCode
        expect(member1.hashCode, equals(member2.hashCode));

        // Different objects with different data should have different hashCodes
        final member3 = testMember.copyWith(name: 'Different Name');
        expect(member1.hashCode, isNot(equals(member3.hashCode)));
      });
    });

    group('edge cases', () {
      test('should handle minimum handicap (0.0)', () {
        // Arrange & Act
        final member = testMember.copyWith(handicap: 0.0);

        // Assert
        expect(member.handicap, 0.0);
      });

      test('should handle maximum handicap (54.0)', () {
        // Arrange & Act
        final member = testMember.copyWith(handicap: 54.0);

        // Assert
        expect(member.handicap, 54.0);
      });

      test('should handle very long names', () {
        // Arrange
        final longName = 'A' * 255;

        // Act
        final member = testMember.copyWith(name: longName);

        // Assert
        expect(member.name, longName);
        expect(member.name.length, 255);
      });

      test('should handle email with special characters', () {
        // Arrange
        const specialEmail = 'user+test@example.co.uk';

        // Act
        final member = testMember.copyWith(email: specialEmail);

        // Assert
        expect(member.email, specialEmail);
      });

      test('should handle null lastPlayedAt for new members', () {
        // Arrange & Act
        final newMember = Member(
          id: 'new-member',
          societyId: 'society-1',
          userId: 'user-new',
          name: 'New Member',
          email: 'new@example.com',
          handicap: 20.0,
          role: 'MEMBER',
          joinedAt: DateTime.now(),
          lastPlayedAt: null,
        );

        // Assert
        expect(newMember.lastPlayedAt, isNull);
      });
    });
  });
}
