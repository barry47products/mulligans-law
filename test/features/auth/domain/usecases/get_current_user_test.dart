import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/domain/repositories/auth_repository.dart';
import 'package:mulligans_law/features/auth/domain/usecases/get_current_user.dart';

import 'get_current_user_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late GetCurrentUser getCurrentUser;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    getCurrentUser = GetCurrentUser(mockRepository);
  });

  final testUser = AuthUser(
    id: 'user-123',
    email: 'test@example.com',
    name: 'Test User',
    createdAt: DateTime.now(),
  );

  group('GetCurrentUser', () {
    test('should return AuthUser when user is authenticated', () async {
      // Arrange
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => testUser);

      // Act
      final result = await getCurrentUser();

      // Assert
      expect(result, testUser);
      verify(mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return null when no user is authenticated', () async {
      // Arrange
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => null);

      // Act
      final result = await getCurrentUser();

      // Assert
      expect(result, isNull);
      verify(mockRepository.getCurrentUser()).called(1);
    });
  });
}
