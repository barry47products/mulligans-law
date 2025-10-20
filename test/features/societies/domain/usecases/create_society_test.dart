import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/constants/validation_constants.dart';
import 'package:mulligans_law/core/errors/society_exceptions.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';
import 'package:mulligans_law/features/societies/domain/usecases/create_society.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';

import 'create_society_test.mocks.dart';

@GenerateMocks([SocietyRepository, MemberRepository])
void main() {
  late CreateSociety useCase;
  late MockSocietyRepository mockSocietyRepository;
  late MockMemberRepository mockMemberRepository;

  setUp(() {
    mockSocietyRepository = MockSocietyRepository();
    mockMemberRepository = MockMemberRepository();
    useCase = CreateSociety(mockSocietyRepository, mockMemberRepository);
  });

  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');
  final testSociety = Society(
    id: 'society-123',
    name: 'Mulligans Golf Society',
    description: 'A friendly golf society',
    logoUrl: 'https://example.com/logo.png',
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  const testUserId = 'user-123';
  final testPrimaryMember = Member(
    id: 'member-primary-1',
    societyId: null,
    userId: testUserId,
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 10.5,
    role: null,
    joinedAt: testDateTime,
  );

  final testCaptainMember = Member(
    id: 'member-captain-1',
    societyId: 'society-123',
    userId: testUserId,
    name: 'John Doe',
    email: 'john@example.com',
    handicap: 10.5,
    role: 'CAPTAIN',
    joinedAt: testDateTime,
  );

  group('CreateSociety', () {
    // Helper to set up standard member repository mocks
    void setupMemberMocks() {
      when(
        mockMemberRepository.getPrimaryMember(testUserId),
      ).thenAnswer((_) async => testPrimaryMember);

      when(
        mockMemberRepository.addMember(
          societyId: anyNamed('societyId'),
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          handicap: anyNamed('handicap'),
          role: anyNamed('role'),
        ),
      ).thenAnswer((_) async => testCaptainMember);
    }

    test('should create society successfully with all fields', () async {
      // Arrange
      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      when(
        mockMemberRepository.getPrimaryMember(testUserId),
      ).thenAnswer((_) async => testPrimaryMember);

      when(
        mockMemberRepository.addMember(
          societyId: anyNamed('societyId'),
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          handicap: anyNamed('handicap'),
          role: anyNamed('role'),
        ),
      ).thenAnswer((_) async => testCaptainMember);

      // Act
      final result = await useCase(
        userId: testUserId,
        name: 'Mulligans Golf Society',
        description: 'A friendly golf society',
        logoUrl: 'https://example.com/logo.png',
      );

      // Assert
      expect(result, testSociety);
      verify(
        mockSocietyRepository.createSociety(
          name: 'Mulligans Golf Society',
          description: 'A friendly golf society',
          logoUrl: 'https://example.com/logo.png',
        ),
      ).called(1);
      verify(mockMemberRepository.getPrimaryMember(testUserId)).called(1);
      verify(
        mockMemberRepository.addMember(
          societyId: testSociety.id,
          userId: testUserId,
          name: testPrimaryMember.name,
          email: testPrimaryMember.email,
          handicap: testPrimaryMember.handicap,
          role: 'CAPTAIN',
        ),
      ).called(1);
    });

    test('should create society with only required fields', () async {
      // Arrange
      final minimalSociety = Society(
        id: 'society-123',
        name: 'Test Society',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => minimalSociety);

      setupMemberMocks();

      // Act
      final result = await useCase(userId: testUserId, name: 'Test Society');

      // Assert
      expect(result.name, 'Test Society');
      expect(result.description, isNull);
      expect(result.logoUrl, isNull);
      verify(
        mockSocietyRepository.createSociety(
          name: 'Test Society',
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test('should trim whitespace from society name', () async {
      // Arrange
      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      setupMemberMocks();

      // Act
      await useCase(userId: testUserId, name: '  Mulligans Golf Society  ');

      // Assert
      verify(
        mockSocietyRepository.createSociety(
          name: 'Mulligans Golf Society',
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test(
      'should throw InvalidSocietyDataException when name is empty',
      () async {
        // Act & Assert
        expect(
          () => useCase(userId: testUserId, name: ''),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              ValidationMessages.societyNameEmpty,
            ),
          ),
        );
        verifyZeroInteractions(mockSocietyRepository);
      },
    );

    test(
      'should throw InvalidSocietyDataException when name is only whitespace',
      () async {
        // Act & Assert
        expect(
          () => useCase(userId: testUserId, name: '   '),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              ValidationMessages.societyNameEmpty,
            ),
          ),
        );
        verifyZeroInteractions(mockSocietyRepository);
      },
    );

    test(
      'should throw InvalidSocietyDataException when name exceeds max length',
      () async {
        // Arrange
        final longName = 'A' * (ValidationConstants.societyNameMaxLength + 1);

        // Act & Assert
        expect(
          () => useCase(userId: testUserId, name: longName),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              ValidationMessages.societyNameTooLong,
            ),
          ),
        );
        verifyZeroInteractions(mockSocietyRepository);
      },
    );

    test('should accept name at exactly max length', () async {
      // Arrange
      final maxLengthName = 'A' * ValidationConstants.societyNameMaxLength;
      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      setupMemberMocks();

      // Act
      await useCase(userId: testUserId, name: maxLengthName);

      // Assert
      verify(
        mockSocietyRepository.createSociety(
          name: maxLengthName,
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test(
      'should throw InvalidSocietyDataException when description exceeds max length',
      () async {
        // Arrange
        final longDescription =
            'A' * (ValidationConstants.societyDescriptionMaxLength + 1);

        // Act & Assert
        expect(
          () => useCase(
            userId: testUserId,
            name: 'Test Society',
            description: longDescription,
          ),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              ValidationMessages.societyDescriptionTooLong,
            ),
          ),
        );
        verifyZeroInteractions(mockSocietyRepository);
      },
    );

    test('should accept description at exactly max length', () async {
      // Arrange
      final maxLengthDesc =
          'A' * ValidationConstants.societyDescriptionMaxLength;
      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      setupMemberMocks();

      // Act
      await useCase(
        userId: testUserId,
        name: 'Test Society',
        description: maxLengthDesc,
      );

      // Assert
      verify(
        mockSocietyRepository.createSociety(
          name: 'Test Society',
          description: maxLengthDesc,
          logoUrl: null,
        ),
      ).called(1);
    });

    test('should handle empty string description as null', () async {
      // Arrange
      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      setupMemberMocks();

      // Act
      await useCase(userId: testUserId, name: 'Test Society', description: '');

      // Assert
      verify(
        mockSocietyRepository.createSociety(
          name: 'Test Society',
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test('should handle empty string logoUrl as null', () async {
      // Arrange
      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      setupMemberMocks();

      // Act
      await useCase(userId: testUserId, name: 'Test Society', logoUrl: '');

      // Assert
      verify(
        mockSocietyRepository.createSociety(
          name: 'Test Society',
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    group('Captain Member Creation', () {
      test('should create captain member after creating society', () async {
        // Arrange
        when(
          mockSocietyRepository.createSociety(
            name: anyNamed('name'),
            description: anyNamed('description'),
            logoUrl: anyNamed('logoUrl'),
          ),
        ).thenAnswer((_) async => testSociety);

        when(
          mockMemberRepository.getPrimaryMember(testUserId),
        ).thenAnswer((_) async => testPrimaryMember);

        when(
          mockMemberRepository.addMember(
            societyId: anyNamed('societyId'),
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
            role: anyNamed('role'),
          ),
        ).thenAnswer((_) async => testCaptainMember);

        // Act
        final result = await useCase(
          userId: testUserId,
          name: 'Mulligans Golf Society',
        );

        // Assert
        expect(result, testSociety);
        verify(mockMemberRepository.getPrimaryMember(testUserId)).called(1);
        verify(
          mockMemberRepository.addMember(
            societyId: testSociety.id,
            userId: testUserId,
            name: testPrimaryMember.name,
            email: testPrimaryMember.email,
            handicap: testPrimaryMember.handicap,
            role: 'CAPTAIN',
          ),
        ).called(1);
      });

      test('should create captain member using primary member data', () async {
        // Arrange
        when(
          mockSocietyRepository.createSociety(
            name: anyNamed('name'),
            description: anyNamed('description'),
            logoUrl: anyNamed('logoUrl'),
          ),
        ).thenAnswer((_) async => testSociety);

        when(
          mockMemberRepository.getPrimaryMember(testUserId),
        ).thenAnswer((_) async => testPrimaryMember);

        when(
          mockMemberRepository.addMember(
            societyId: anyNamed('societyId'),
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
            role: anyNamed('role'),
          ),
        ).thenAnswer((_) async => testCaptainMember);

        // Act
        await useCase(userId: testUserId, name: 'Test Society');

        // Assert - Verify captain member gets data from primary member
        final captured = verify(
          mockMemberRepository.addMember(
            societyId: captureAnyNamed('societyId'),
            userId: captureAnyNamed('userId'),
            name: captureAnyNamed('name'),
            email: captureAnyNamed('email'),
            handicap: captureAnyNamed('handicap'),
            role: captureAnyNamed('role'),
          ),
        ).captured;

        expect(captured[0], testSociety.id); // societyId from new society
        expect(captured[1], testUserId); // userId from parameter
        expect(captured[2], testPrimaryMember.name); // from primary member
        expect(captured[3], testPrimaryMember.email); // from primary member
        expect(captured[4], testPrimaryMember.handicap); // from primary member
        expect(captured[5], 'CAPTAIN'); // role is CAPTAIN
      });

      test(
        'should throw MemberNotFoundException if primary member not found',
        () async {
          // Arrange
          when(
            mockSocietyRepository.createSociety(
              name: anyNamed('name'),
              description: anyNamed('description'),
              logoUrl: anyNamed('logoUrl'),
            ),
          ).thenAnswer((_) async => testSociety);

          when(
            mockMemberRepository.getPrimaryMember(testUserId),
          ).thenThrow(MemberNotFoundException('Primary member not found'));

          // Act & Assert
          try {
            await useCase(userId: testUserId, name: 'Test Society');
            fail('Should have thrown MemberNotFoundException');
          } catch (e) {
            expect(e, isA<MemberNotFoundException>());
          }

          verify(
            mockSocietyRepository.createSociety(
              name: 'Test Society',
              description: null,
              logoUrl: null,
            ),
          ).called(1);
          verify(mockMemberRepository.getPrimaryMember(testUserId)).called(1);
          verifyNever(
            mockMemberRepository.addMember(
              societyId: anyNamed('societyId'),
              userId: anyNamed('userId'),
              name: anyNamed('name'),
              email: anyNamed('email'),
              handicap: anyNamed('handicap'),
              role: anyNamed('role'),
            ),
          );
        },
      );

      test('should throw exception if captain member creation fails', () async {
        // Arrange
        when(
          mockSocietyRepository.createSociety(
            name: anyNamed('name'),
            description: anyNamed('description'),
            logoUrl: anyNamed('logoUrl'),
          ),
        ).thenAnswer((_) async => testSociety);

        when(
          mockMemberRepository.getPrimaryMember(testUserId),
        ).thenAnswer((_) async => testPrimaryMember);

        when(
          mockMemberRepository.addMember(
            societyId: anyNamed('societyId'),
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
            role: anyNamed('role'),
          ),
        ).thenThrow(MemberDatabaseException('Failed to add captain member'));

        // Act & Assert
        expect(
          () => useCase(userId: testUserId, name: 'Test Society'),
          throwsA(isA<MemberDatabaseException>()),
        );
      });
    });
  });
}
