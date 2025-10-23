import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/societies/domain/entities/society_stats.dart';
import 'package:mulligans_law/features/societies/domain/usecases/get_society_stats.dart';

class MockMemberRepository extends Mock implements MemberRepository {}

void main() {
  late GetSocietyStats useCase;
  late MockMemberRepository mockRepository;

  setUp(() {
    mockRepository = MockMemberRepository();
    useCase = GetSocietyStats(mockRepository);
  });

  const testSocietyId = 'society-123';

  final testStats = const SocietyStats(
    memberCount: 24,
    ownerNames: ['John Doe', 'Jane Smith'],
    captainNames: ['Bob Johnson'],
    averageHandicap: 18.5,
  );

  group('GetSocietyStats', () {
    test('should get society stats from repository', () async {
      // Arrange
      when(
        () => mockRepository.getSocietyStats(testSocietyId),
      ).thenAnswer((_) async => testStats);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result, testStats);
      verify(() => mockRepository.getSocietyStats(testSocietyId)).called(1);
    });

    test(
      'should return stats with zero members when no active members',
      () async {
        // Arrange
        const emptyStats = SocietyStats(
          memberCount: 0,
          ownerNames: [],
          captainNames: [],
          averageHandicap: 0.0,
        );

        when(
          () => mockRepository.getSocietyStats(testSocietyId),
        ).thenAnswer((_) async => emptyStats);

        // Act
        final result = await useCase(testSocietyId);

        // Assert
        expect(result.memberCount, 0);
        expect(result.ownerNames, isEmpty);
        expect(result.captainNames, isEmpty);
        expect(result.averageHandicap, 0.0);
      },
    );

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        () => mockRepository.getSocietyStats(testSocietyId),
      ).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => useCase(testSocietyId), throwsA(isA<Exception>()));
    });

    test('should handle multiple owners and captains', () async {
      // Arrange
      const statsWithMultipleRoles = SocietyStats(
        memberCount: 50,
        ownerNames: ['Owner 1', 'Owner 2', 'Owner 3'],
        captainNames: ['Captain 1', 'Captain 2'],
        averageHandicap: 22.3,
      );

      when(
        () => mockRepository.getSocietyStats(testSocietyId),
      ).thenAnswer((_) async => statsWithMultipleRoles);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result.ownerNames.length, 3);
      expect(result.captainNames.length, 2);
      expect(result.memberCount, 50);
    });

    test('should handle stats with owners but no captains', () async {
      // Arrange
      const statsWithoutCaptains = SocietyStats(
        memberCount: 5,
        ownerNames: ['Owner'],
        captainNames: [],
        averageHandicap: 15.0,
      );

      when(
        () => mockRepository.getSocietyStats(testSocietyId),
      ).thenAnswer((_) async => statsWithoutCaptains);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result.ownerNames, isNotEmpty);
      expect(result.captainNames, isEmpty);
    });
  });
}
