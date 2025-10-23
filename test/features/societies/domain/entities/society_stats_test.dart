import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/societies/domain/entities/society_stats.dart';

void main() {
  group('SocietyStats', () {
    const testStats = SocietyStats(
      memberCount: 24,
      ownerNames: ['John Doe', 'Jane Smith'],
      captainNames: ['Bob Johnson'],
      averageHandicap: 18.5,
    );

    test('should be a valid entity with all properties', () {
      // Assert
      expect(testStats.memberCount, 24);
      expect(testStats.ownerNames, ['John Doe', 'Jane Smith']);
      expect(testStats.captainNames, ['Bob Johnson']);
      expect(testStats.averageHandicap, 18.5);
    });

    test('should support equality comparison', () {
      // Arrange
      const stats1 = SocietyStats(
        memberCount: 24,
        ownerNames: ['John Doe'],
        captainNames: ['Bob Johnson'],
        averageHandicap: 18.5,
      );

      const stats2 = SocietyStats(
        memberCount: 24,
        ownerNames: ['John Doe'],
        captainNames: ['Bob Johnson'],
        averageHandicap: 18.5,
      );

      const stats3 = SocietyStats(
        memberCount: 25,
        ownerNames: ['John Doe'],
        captainNames: ['Bob Johnson'],
        averageHandicap: 18.5,
      );

      // Assert
      expect(stats1, equals(stats2));
      expect(stats1, isNot(equals(stats3)));
    });

    test('should support empty lists for owners and captains', () {
      // Arrange
      const emptyStats = SocietyStats(
        memberCount: 0,
        ownerNames: [],
        captainNames: [],
        averageHandicap: 0.0,
      );

      // Assert
      expect(emptyStats.memberCount, 0);
      expect(emptyStats.ownerNames, isEmpty);
      expect(emptyStats.captainNames, isEmpty);
      expect(emptyStats.averageHandicap, 0.0);
    });

    test('should handle multiple owners and captains', () {
      // Arrange
      const multipleRoles = SocietyStats(
        memberCount: 50,
        ownerNames: ['Owner 1', 'Owner 2', 'Owner 3'],
        captainNames: ['Captain 1', 'Captain 2'],
        averageHandicap: 22.3,
      );

      // Assert
      expect(multipleRoles.ownerNames.length, 3);
      expect(multipleRoles.captainNames.length, 2);
    });

    test('should support copyWith for immutability', () {
      // Arrange
      const original = SocietyStats(
        memberCount: 10,
        ownerNames: ['Owner'],
        captainNames: ['Captain'],
        averageHandicap: 15.0,
      );

      // Act
      final updated = original.copyWith(memberCount: 12);

      // Assert
      expect(updated.memberCount, 12);
      expect(updated.ownerNames, ['Owner']);
      expect(updated.captainNames, ['Captain']);
      expect(updated.averageHandicap, 15.0);
      expect(original.memberCount, 10); // Original unchanged
    });

    test('should allow copyWith to update all fields', () {
      // Arrange
      const original = SocietyStats(
        memberCount: 10,
        ownerNames: ['Owner 1'],
        captainNames: ['Captain 1'],
        averageHandicap: 15.0,
      );

      // Act
      final updated = original.copyWith(
        memberCount: 20,
        ownerNames: ['Owner 2', 'Owner 3'],
        captainNames: ['Captain 2'],
        averageHandicap: 18.0,
      );

      // Assert
      expect(updated.memberCount, 20);
      expect(updated.ownerNames, ['Owner 2', 'Owner 3']);
      expect(updated.captainNames, ['Captain 2']);
      expect(updated.averageHandicap, 18.0);
    });
  });
}
