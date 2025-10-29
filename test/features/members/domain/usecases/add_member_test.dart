import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/features/members/domain/usecases/add_member.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';

import 'add_member_test.mocks.dart';

@GenerateMocks([MemberRepository, SocietyRepository])
void main() {
  late AddMember useCase;
  late MockMemberRepository mockMemberRepository;
  late MockSocietyRepository mockSocietyRepository;

  setUp(() {
    mockMemberRepository = MockMemberRepository();
    mockSocietyRepository = MockSocietyRepository();
    useCase = AddMember(
      memberRepository: mockMemberRepository,
      societyRepository: mockSocietyRepository,
    );
  });

  final testDateTime = DateTime(2024, 1, 1);

  const testSocietyId = 'society-123';
  const testUserId = 'user-123';
  const testName = 'John Doe';
  const testEmail = 'john@example.com';
  const testHandicap = 12.0;
  const testRole = 'MEMBER';

  final testSociety = Society(
    id: testSocietyId,
    name: 'Test Society',
    isPublic: false,
    handicapLimitEnabled: false,
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  final testMember = Member(
    id: 'member-123',
    societyId: testSocietyId,
    userId: testUserId,
    name: testName,
    email: testEmail,
    handicap: testHandicap,
    role: testRole,
    joinedAt: testDateTime,
  );

  group('AddMember', () {
    test('should successfully add member when all validations pass', () async {
      // Arrange
      when(
        mockSocietyRepository.getSocietyById(testSocietyId),
      ).thenAnswer((_) async => testSociety);
      when(
        mockMemberRepository.addMember(
          societyId: anyNamed('societyId'),
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          handicap: anyNamed('handicap'),
          role: anyNamed('role'),
          status: anyNamed('status'),
        ),
      ).thenAnswer((_) async => testMember);

      // Act
      final result = await useCase(
        societyId: testSocietyId,
        userId: testUserId,
        name: testName,
        email: testEmail,
        handicap: testHandicap,
        role: testRole,
      );

      // Assert
      expect(result, equals(testMember));
      verify(mockSocietyRepository.getSocietyById(testSocietyId)).called(1);
      verify(
        mockMemberRepository.addMember(
          societyId: testSocietyId,
          userId: testUserId,
          name: testName,
          email: testEmail,
          handicap: testHandicap,
          role: testRole,
          status: 'ACTIVE',
        ),
      ).called(1);
    });

    test('should add member with ACTIVE status by default', () async {
      // Arrange
      when(
        mockSocietyRepository.getSocietyById(testSocietyId),
      ).thenAnswer((_) async => testSociety);
      when(
        mockMemberRepository.addMember(
          societyId: anyNamed('societyId'),
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          handicap: anyNamed('handicap'),
          role: anyNamed('role'),
          status: anyNamed('status'),
        ),
      ).thenAnswer((_) async => testMember);

      // Act
      await useCase(
        societyId: testSocietyId,
        userId: testUserId,
        name: testName,
        email: testEmail,
        handicap: testHandicap,
        role: testRole,
      );

      // Assert
      verify(
        mockMemberRepository.addMember(
          societyId: testSocietyId,
          userId: testUserId,
          name: testName,
          email: testEmail,
          handicap: testHandicap,
          role: testRole,
          status: 'ACTIVE',
        ),
      ).called(1);
    });

    group('Handicap Validation', () {
      test('should throw when handicap below society minimum', () async {
        // Arrange
        final societyWithLimits = Society(
          id: testSocietyId,
          name: 'Test Society',
          isPublic: false,
          handicapLimitEnabled: true,
          handicapMin: 10,
          handicapMax: 28,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenAnswer((_) async => societyWithLimits);

        // Act & Assert
        expect(
          () => useCase(
            societyId: testSocietyId,
            userId: testUserId,
            name: testName,
            email: testEmail,
            handicap: 8.0, // Below minimum
            role: testRole,
          ),
          throwsA(isA<InvalidMemberOperationException>()),
        );
      });

      test('should throw when handicap above society maximum', () async {
        // Arrange
        final societyWithLimits = Society(
          id: testSocietyId,
          name: 'Test Society',
          isPublic: false,
          handicapLimitEnabled: true,
          handicapMin: 10,
          handicapMax: 28,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenAnswer((_) async => societyWithLimits);

        // Act & Assert
        expect(
          () => useCase(
            societyId: testSocietyId,
            userId: testUserId,
            name: testName,
            email: testEmail,
            handicap: 30.0, // Above maximum
            role: testRole,
          ),
          throwsA(isA<InvalidMemberOperationException>()),
        );
      });

      test('should allow handicap within society limits', () async {
        // Arrange
        final societyWithLimits = Society(
          id: testSocietyId,
          name: 'Test Society',
          isPublic: false,
          handicapLimitEnabled: true,
          handicapMin: 10,
          handicapMax: 28,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenAnswer((_) async => societyWithLimits);
        when(
          mockMemberRepository.addMember(
            societyId: anyNamed('societyId'),
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
            role: anyNamed('role'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testMember);

        // Act
        await useCase(
          societyId: testSocietyId,
          userId: testUserId,
          name: testName,
          email: testEmail,
          handicap: 15.0, // Within limits
          role: testRole,
        );

        // Assert
        verify(
          mockMemberRepository.addMember(
            societyId: testSocietyId,
            userId: testUserId,
            name: testName,
            email: testEmail,
            handicap: 15.0,
            role: testRole,
            status: 'ACTIVE',
          ),
        ).called(1);
      });

      test('should allow any handicap when limits not enabled', () async {
        // Arrange
        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenAnswer((_) async => testSociety); // handicapLimitEnabled: false
        when(
          mockMemberRepository.addMember(
            societyId: anyNamed('societyId'),
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
            role: anyNamed('role'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testMember);

        // Act
        await useCase(
          societyId: testSocietyId,
          userId: testUserId,
          name: testName,
          email: testEmail,
          handicap: 50.0, // Way outside normal range, but no limits set
          role: testRole,
        );

        // Assert - should succeed
        verify(
          mockMemberRepository.addMember(
            societyId: testSocietyId,
            userId: testUserId,
            name: testName,
            email: testEmail,
            handicap: 50.0,
            role: testRole,
            status: 'ACTIVE',
          ),
        ).called(1);
      });

      test('should allow handicap at exact minimum boundary', () async {
        // Arrange
        final societyWithLimits = Society(
          id: testSocietyId,
          name: 'Test Society',
          isPublic: false,
          handicapLimitEnabled: true,
          handicapMin: 10,
          handicapMax: 28,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenAnswer((_) async => societyWithLimits);
        when(
          mockMemberRepository.addMember(
            societyId: anyNamed('societyId'),
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
            role: anyNamed('role'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testMember);

        // Act
        await useCase(
          societyId: testSocietyId,
          userId: testUserId,
          name: testName,
          email: testEmail,
          handicap: 10.0, // Exact minimum
          role: testRole,
        );

        // Assert - should succeed
        verify(
          mockMemberRepository.addMember(
            societyId: testSocietyId,
            userId: testUserId,
            name: testName,
            email: testEmail,
            handicap: 10.0,
            role: testRole,
            status: 'ACTIVE',
          ),
        ).called(1);
      });

      test('should allow handicap at exact maximum boundary', () async {
        // Arrange
        final societyWithLimits = Society(
          id: testSocietyId,
          name: 'Test Society',
          isPublic: false,
          handicapLimitEnabled: true,
          handicapMin: 10,
          handicapMax: 28,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        when(
          mockSocietyRepository.getSocietyById(testSocietyId),
        ).thenAnswer((_) async => societyWithLimits);
        when(
          mockMemberRepository.addMember(
            societyId: anyNamed('societyId'),
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
            role: anyNamed('role'),
            status: anyNamed('status'),
          ),
        ).thenAnswer((_) async => testMember);

        // Act
        await useCase(
          societyId: testSocietyId,
          userId: testUserId,
          name: testName,
          email: testEmail,
          handicap: 28.0, // Exact maximum
          role: testRole,
        );

        // Assert - should succeed
        verify(
          mockMemberRepository.addMember(
            societyId: testSocietyId,
            userId: testUserId,
            name: testName,
            email: testEmail,
            handicap: 28.0,
            role: testRole,
            status: 'ACTIVE',
          ),
        ).called(1);
      });
    });
  });
}
