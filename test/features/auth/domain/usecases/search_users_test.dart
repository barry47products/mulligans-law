import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mulligans_law/features/auth/domain/entities/user_profile.dart';
import 'package:mulligans_law/features/auth/domain/repositories/auth_repository.dart';
import 'package:mulligans_law/features/auth/domain/usecases/search_users.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SearchUsers useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SearchUsers(mockRepository);
  });

  const testQuery = 'john';
  const testLimit = 10;

  final testUsers = [
    UserProfile(
      id: 'user-1',
      name: 'John Smith',
      email: 'john.smith@example.com',
      handicap: 12,
    ),
    UserProfile(
      id: 'user-2',
      name: 'John Doe',
      email: 'john.doe@example.com',
      handicap: 8,
    ),
  ];

  group('SearchUsers', () {
    test('should return list of matching users', () async {
      // Arrange
      when(
        () => mockRepository.searchUsers(query: testQuery, limit: testLimit),
      ).thenAnswer((_) async => testUsers);

      // Act
      final result = await useCase(query: testQuery, limit: testLimit);

      // Assert
      expect(result, equals(testUsers));
      expect(result.length, equals(2));
      verify(
        () => mockRepository.searchUsers(query: testQuery, limit: testLimit),
      ).called(1);
    });

    test('should return empty list when no users match', () async {
      // Arrange
      when(
        () => mockRepository.searchUsers(query: testQuery, limit: testLimit),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase(query: testQuery, limit: testLimit);

      // Assert
      expect(result, isEmpty);
      verify(
        () => mockRepository.searchUsers(query: testQuery, limit: testLimit),
      ).called(1);
    });

    test('should use default limit when not specified', () async {
      // Arrange
      const defaultLimit = 20;
      when(
        () => mockRepository.searchUsers(query: testQuery, limit: defaultLimit),
      ).thenAnswer((_) async => testUsers);

      // Act
      final result = await useCase(query: testQuery);

      // Assert
      expect(result, equals(testUsers));
      verify(
        () => mockRepository.searchUsers(query: testQuery, limit: defaultLimit),
      ).called(1);
    });

    test('should handle repository exceptions', () async {
      // Arrange
      when(
        () => mockRepository.searchUsers(
          query: testQuery,
          limit: any(named: 'limit'),
        ),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase(query: testQuery), throwsException);
    });

    test('should return users without handicap', () async {
      // Arrange
      final usersWithoutHandicap = [
        const UserProfile(
          id: 'user-3',
          name: 'Jane Smith',
          email: 'jane@example.com',
        ),
      ];
      when(
        () => mockRepository.searchUsers(
          query: 'jane',
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => usersWithoutHandicap);

      // Act
      final result = await useCase(query: 'jane');

      // Assert
      expect(result, equals(usersWithoutHandicap));
      expect(result.first.handicap, isNull);
    });
  });
}
