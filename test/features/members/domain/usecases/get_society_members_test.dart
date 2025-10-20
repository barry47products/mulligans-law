import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/get_society_members.dart';

import 'get_society_members_test.mocks.dart';

@GenerateMocks([MemberRepository])
void main() {
  late GetSocietyMembers useCase;
  late MockMemberRepository mockRepository;

  setUp(() {
    mockRepository = MockMemberRepository();
    useCase = GetSocietyMembers(mockRepository);
  });

  const testSocietyId = 'society-123';
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testMembers = [
    Member(
      id: 'member-1',
      userId: 'user-1',
      societyId: testSocietyId,
      name: 'Alice Smith',
      email: 'alice@example.com',
      handicap: 12.0,
      role: 'CAPTAIN',
      avatarUrl: null,
      joinedAt: testDateTime,
      lastPlayedAt: null,
    ),
    Member(
      id: 'member-2',
      userId: 'user-2',
      societyId: testSocietyId,
      name: 'Bob Jones',
      email: 'bob@example.com',
      handicap: 18.0,
      role: 'MEMBER',
      avatarUrl: null,
      joinedAt: testDateTime.add(const Duration(days: 1)),
      lastPlayedAt: null,
    ),
    Member(
      id: 'member-3',
      userId: 'user-3',
      societyId: testSocietyId,
      name: 'Charlie Brown',
      email: 'charlie@example.com',
      handicap: 24.0,
      role: 'MEMBER',
      avatarUrl: null,
      joinedAt: testDateTime.add(const Duration(days: 2)),
      lastPlayedAt: testDateTime,
    ),
  ];

  group('GetSocietyMembers', () {
    test('should get society members from repository', () async {
      // Arrange
      when(
        mockRepository.getSocietyMembers(testSocietyId),
      ).thenAnswer((_) async => testMembers);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result, testMembers);
      expect(result.length, 3);
      verify(mockRepository.getSocietyMembers(testSocietyId)).called(1);
    });

    test('should return members sorted by name', () async {
      // Arrange
      when(
        mockRepository.getSocietyMembers(testSocietyId),
      ).thenAnswer((_) async => testMembers);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result[0].name, 'Alice Smith');
      expect(result[1].name, 'Bob Jones');
      expect(result[2].name, 'Charlie Brown');
    });

    test('should return all members with societyId set', () async {
      // Arrange
      when(
        mockRepository.getSocietyMembers(testSocietyId),
      ).thenAnswer((_) async => testMembers);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      for (final member in result) {
        expect(member.societyId, testSocietyId);
        expect(member.role, isNotNull);
      }
    });

    test('should return empty list when no members found', () async {
      // Arrange
      when(
        mockRepository.getSocietyMembers(testSocietyId),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase(testSocietyId);

      // Assert
      expect(result, isEmpty);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        mockRepository.getSocietyMembers(testSocietyId),
      ).thenThrow(MemberDatabaseException('Database error'));

      // Act & Assert
      expect(
        () => useCase(testSocietyId),
        throwsA(isA<MemberDatabaseException>()),
      );
    });
  });
}
