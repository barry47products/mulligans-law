import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/constants/validation_constants.dart';
import 'package:mulligans_law/core/errors/society_exceptions.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';
import 'package:mulligans_law/features/societies/domain/usecases/create_society.dart';

import 'create_society_test.mocks.dart';

@GenerateMocks([SocietyRepository])
void main() {
  late CreateSociety useCase;
  late MockSocietyRepository mockSocietyRepository;

  setUp(() {
    mockSocietyRepository = MockSocietyRepository();
    useCase = CreateSociety(mockSocietyRepository);
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

  group('CreateSociety', () {
    test('should create society successfully with all fields', () async {
      // Arrange
      when(
        mockSocietyRepository.createSociety(
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

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

    // NOTE: Captain member creation tests removed because the repository now
    // uses a database function that automatically creates the captain member.
    // The member creation is tested at the repository/integration level instead.
  });
}
