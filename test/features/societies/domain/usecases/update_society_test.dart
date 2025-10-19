import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/core/constants/validation_constants.dart';
import 'package:mulligans_law/core/errors/society_exceptions.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';
import 'package:mulligans_law/features/societies/domain/usecases/update_society.dart';

import 'update_society_test.mocks.dart';

@GenerateMocks([SocietyRepository])
void main() {
  late UpdateSociety useCase;
  late MockSocietyRepository mockRepository;

  setUp(() {
    mockRepository = MockSocietyRepository();
    useCase = UpdateSociety(mockRepository);
  });

  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');
  final testSociety = Society(
    id: 'society-123',
    name: 'Updated Society Name',
    description: 'Updated description',
    logoUrl: 'https://example.com/new-logo.png',
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  group('UpdateSociety', () {
    test('should update all fields successfully', () async {
      // Arrange
      when(
        mockRepository.updateSociety(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      // Act
      final result = await useCase(
        id: 'society-123',
        name: 'Updated Society Name',
        description: 'Updated description',
        logoUrl: 'https://example.com/new-logo.png',
      );

      // Assert
      expect(result, testSociety);
      verify(
        mockRepository.updateSociety(
          id: 'society-123',
          name: 'Updated Society Name',
          description: 'Updated description',
          logoUrl: 'https://example.com/new-logo.png',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update only name field', () async {
      // Arrange
      when(
        mockRepository.updateSociety(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      // Act
      await useCase(id: 'society-123', name: 'New Name');

      // Assert
      verify(
        mockRepository.updateSociety(
          id: 'society-123',
          name: 'New Name',
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test('should update only description field', () async {
      // Arrange
      when(
        mockRepository.updateSociety(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      // Act
      await useCase(id: 'society-123', description: 'New description');

      // Assert
      verify(
        mockRepository.updateSociety(
          id: 'society-123',
          name: null,
          description: 'New description',
          logoUrl: null,
        ),
      ).called(1);
    });

    test('should trim whitespace from name', () async {
      // Arrange
      when(
        mockRepository.updateSociety(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      // Act
      await useCase(id: 'society-123', name: '  Trimmed Name  ');

      // Assert
      verify(
        mockRepository.updateSociety(
          id: 'society-123',
          name: 'Trimmed Name',
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test(
      'should throw InvalidSocietyDataException when name is empty after trim',
      () async {
        // Act & Assert
        expect(
          () => useCase(id: 'society-123', name: '   '),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              ValidationMessages.societyNameEmpty,
            ),
          ),
        );
        verifyZeroInteractions(mockRepository);
      },
    );

    test(
      'should throw InvalidSocietyDataException when name exceeds max length',
      () async {
        // Arrange
        final longName = 'A' * (ValidationConstants.societyNameMaxLength + 1);

        // Act & Assert
        expect(
          () => useCase(id: 'society-123', name: longName),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              ValidationMessages.societyNameTooLong,
            ),
          ),
        );
        verifyZeroInteractions(mockRepository);
      },
    );

    test('should accept name at exactly max length', () async {
      // Arrange
      final maxLengthName = 'A' * ValidationConstants.societyNameMaxLength;
      when(
        mockRepository.updateSociety(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      // Act
      await useCase(id: 'society-123', name: maxLengthName);

      // Assert
      verify(
        mockRepository.updateSociety(
          id: 'society-123',
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
          () => useCase(id: 'society-123', description: longDescription),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              ValidationMessages.societyDescriptionTooLong,
            ),
          ),
        );
        verifyZeroInteractions(mockRepository);
      },
    );

    test('should handle empty string description as null', () async {
      // Arrange
      when(
        mockRepository.updateSociety(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      // Act
      await useCase(id: 'society-123', description: '');

      // Assert
      verify(
        mockRepository.updateSociety(
          id: 'society-123',
          name: null,
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test('should handle empty string logoUrl as null', () async {
      // Arrange
      when(
        mockRepository.updateSociety(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          logoUrl: anyNamed('logoUrl'),
        ),
      ).thenAnswer((_) async => testSociety);

      // Act
      await useCase(id: 'society-123', logoUrl: '');

      // Assert
      verify(
        mockRepository.updateSociety(
          id: 'society-123',
          name: null,
          description: null,
          logoUrl: null,
        ),
      ).called(1);
    });

    test(
      'should throw InvalidSocietyDataException when no fields to update',
      () async {
        // Act & Assert
        expect(
          () => useCase(id: 'society-123'),
          throwsA(
            isA<InvalidSocietyDataException>().having(
              (e) => e.message,
              'message',
              contains('At least one field'),
            ),
          ),
        );
        verifyZeroInteractions(mockRepository);
      },
    );
  });
}
