import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/auth/domain/repositories/auth_repository.dart';
import 'package:mulligans_law/features/auth/domain/usecases/sign_out.dart';
import 'package:mulligans_law/core/errors/auth_exceptions.dart';

import 'sign_out_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignOut signOut;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    signOut = SignOut(mockRepository);
  });

  group('SignOut', () {
    test('should sign out successfully', () async {
      // Arrange
      when(mockRepository.signOut()).thenAnswer((_) async {});

      // Act
      await signOut();

      // Assert
      verify(mockRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate AuthException on sign out failure', () async {
      // Arrange
      when(
        mockRepository.signOut(),
      ).thenThrow(const AuthException('Sign out failed'));

      // Act & Assert
      expect(() => signOut(), throwsA(isA<AuthException>()));
      verify(mockRepository.signOut()).called(1);
    });

    test('should propagate NetworkException on network error', () async {
      // Arrange
      when(mockRepository.signOut()).thenThrow(const NetworkException());

      // Act & Assert
      expect(() => signOut(), throwsA(isA<NetworkException>()));
    });
  });
}
