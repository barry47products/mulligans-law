import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_session.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/domain/repositories/auth_repository.dart';
import 'package:mulligans_law/features/auth/domain/usecases/sign_in.dart';
import 'package:mulligans_law/core/errors/auth_exceptions.dart';

import 'sign_in_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignIn signIn;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    signIn = SignIn(mockRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'Test123!@#';

  final testUser = AuthUser(
    id: 'user-123',
    email: testEmail,
    name: 'Test User',
    createdAt: DateTime.now(),
  );

  final testSession = AuthSession(
    user: testUser,
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );

  group('SignIn', () {
    test('should return AuthSession on successful sign in', () async {
      // Arrange
      when(
        mockRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => testSession);

      // Act
      final result = await signIn(email: testEmail, password: testPassword);

      // Assert
      expect(result, testSession);
      verify(
        mockRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should throw InvalidCredentialsException for invalid credentials',
      () async {
        // Arrange
        when(
          mockRepository.signInWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).thenThrow(const InvalidCredentialsException());

        // Act & Assert
        expect(
          () => signIn(email: testEmail, password: testPassword),
          throwsA(isA<InvalidCredentialsException>()),
        );
        verify(
          mockRepository.signInWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
      },
    );

    test('should throw NetworkException when no internet connection', () async {
      // Arrange
      when(
        mockRepository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenThrow(const NetworkException());

      // Act & Assert
      expect(
        () => signIn(email: testEmail, password: testPassword),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should validate email is not empty', () async {
      // Act & Assert
      expect(
        () => signIn(email: '', password: testPassword),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should validate password is not empty', () async {
      // Act & Assert
      expect(
        () => signIn(email: testEmail, password: ''),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should validate email format', () async {
      // Act & Assert
      expect(
        () => signIn(email: 'invalid-email', password: testPassword),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockRepository);
    });
  });
}
