import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/societies/domain/entities/society.dart';
import 'package:mulligans_law/features/societies/domain/repositories/society_repository.dart';
import 'package:mulligans_law/features/societies/domain/usecases/get_user_societies.dart';

import 'get_user_societies_test.mocks.dart';

@GenerateMocks([SocietyRepository])
void main() {
  late GetUserSocieties useCase;
  late MockSocietyRepository mockRepository;

  setUp(() {
    mockRepository = MockSocietyRepository();
    useCase = GetUserSocieties(mockRepository);
  });

  final testDateTime = DateTime.parse('2025-01-15T10:30:00.000Z');

  final testSocieties = [
    Society(
      id: 'society-1',
      name: 'Mulligans Golf Society',
      description: 'A friendly golf society',
      logoUrl: 'https://example.com/logo1.png',
      createdAt: testDateTime,
      updatedAt: testDateTime,
    ),
    Society(
      id: 'society-2',
      name: 'Another Golf Club',
      createdAt: testDateTime,
      updatedAt: testDateTime,
    ),
  ];

  group('GetUserSocieties', () {
    test('should return list of societies for authenticated user', () async {
      // Arrange
      when(
        mockRepository.getUserSocieties(),
      ).thenAnswer((_) async => testSocieties);

      // Act
      final result = await useCase();

      // Assert
      expect(result, testSocieties);
      expect(result.length, 2);
      expect(result[0].name, 'Mulligans Golf Society');
      expect(result[1].name, 'Another Golf Club');
      verify(mockRepository.getUserSocieties()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when user has no societies', () async {
      // Arrange
      when(mockRepository.getUserSocieties()).thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getUserSocieties()).called(1);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(
        mockRepository.getUserSocieties(),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase(), throwsA(isA<Exception>()));
      verify(mockRepository.getUserSocieties()).called(1);
    });
  });
}
