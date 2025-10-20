import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/core/errors/society_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/join_society.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';

import 'join_society_test.mocks.dart';

@GenerateMocks([MemberRepository, SocietyRepository])
void main() {
  late JoinSociety useCase;
  late MockMemberRepository mockMemberRepository;
  late MockSocietyRepository mockSocietyRepository;

  setUp(() {
    mockMemberRepository = MockMemberRepository();
    mockSocietyRepository = MockSocietyRepository();
    useCase = JoinSociety(mockMemberRepository, mockSocietyRepository);
  });

  const testUserId = 'user-123';
  const testSocietyId = 'society-456';
  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSociety = Society(
    id: testSocietyId,
    name: 'Test Golf Society',
    description: 'A test golf society',
    logoUrl: null,
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  final testPrimaryMember = Member(
    id: 'primary-1',
    userId: testUserId,
    societyId: null,
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 18.0,
    role: null,
    avatarUrl: null,
    joinedAt: testDateTime,
    lastPlayedAt: null,
  );

  final testSocietyMember = Member(
    id: 'society-member-1',
    userId: testUserId,
    societyId: testSocietyId,
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 18.0,
    role: 'MEMBER',
    avatarUrl: null,
    joinedAt: testDateTime,
    lastPlayedAt: null,
  );

  group('JoinSociety', () {
    test('should create society membership from primary member', () async {
      // Arrange
      when(
        mockSocietyRepository.getSocietyById(testSocietyId),
      ).thenAnswer((_) async => testSociety);
      when(
        mockMemberRepository.getPrimaryMember(testUserId),
      ).thenAnswer((_) async => testPrimaryMember);
      when(
        mockMemberRepository.addMember(
          societyId: testSocietyId,
          userId: testUserId,
          name: testPrimaryMember.name,
          email: testPrimaryMember.email,
          handicap: testPrimaryMember.handicap,
          avatarUrl: testPrimaryMember.avatarUrl,
          role: 'MEMBER',
        ),
      ).thenAnswer((_) async => testSocietyMember);

      // Act
      final result = await useCase(
        userId: testUserId,
        societyId: testSocietyId,
      );

      // Assert
      expect(result.userId, testUserId);
      expect(result.societyId, testSocietyId);
      expect(result.role, 'MEMBER');
      expect(result.name, testPrimaryMember.name);
      expect(result.handicap, testPrimaryMember.handicap);
      verify(mockMemberRepository.getPrimaryMember(testUserId)).called(1);
      verify(
        mockMemberRepository.addMember(
          societyId: testSocietyId,
          userId: testUserId,
          name: testPrimaryMember.name,
          email: testPrimaryMember.email,
          handicap: testPrimaryMember.handicap,
          avatarUrl: testPrimaryMember.avatarUrl,
          role: 'MEMBER',
        ),
      ).called(1);
    });

    test(
      'should throw MemberNotFoundException if primary member not found',
      () async {
        // Arrange
        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenAnswer((_) async => testSociety);
        when(
          mockMemberRepository.getPrimaryMember(testUserId),
        ).thenThrow(MemberNotFoundException('Primary member not found'));

        // Act & Assert
        expect(
          () => useCase(userId: testUserId, societyId: testSocietyId),
          throwsA(isA<MemberNotFoundException>()),
        );
      },
    );

    test(
      'should throw SocietyNotFoundException if society does not exist',
      () async {
        // Arrange
        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenThrow(SocietyNotFoundException('Society not found'));

        // Act & Assert
        expect(
          () => useCase(userId: testUserId, societyId: testSocietyId),
          throwsA(isA<SocietyNotFoundException>()),
        );
      },
    );

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        mockSocietyRepository.getSocietyById(testSocietyId),
      ).thenAnswer((_) async => testSociety);
      when(
        mockMemberRepository.getPrimaryMember(testUserId),
      ).thenThrow(MemberDatabaseException('Database error'));

      // Act & Assert
      expect(
        () => useCase(userId: testUserId, societyId: testSocietyId),
        throwsA(isA<MemberDatabaseException>()),
      );
    });
  });
}
