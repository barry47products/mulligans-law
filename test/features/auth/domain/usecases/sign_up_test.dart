import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_session.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/domain/repositories/auth_repository.dart';
import 'package:mulligans_law/features/auth/domain/usecases/sign_up.dart';
import 'package:mulligans_law/core/errors/auth_exceptions.dart';

import 'sign_up_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignUp signUp;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    signUp = SignUp(mockRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'Test123!@#';
  const testName = 'Test User';

  final testUser = AuthUser(
    id: 'user-123',
    email: testEmail,
    name: testName,
    createdAt: DateTime.now(),
  );

  final testSession = AuthSession(
    user: testUser,
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );

  group('SignUp', () {
    test('should return AuthSession on successful sign up', () async {
      // Arrange
      when(
        mockRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      ).thenAnswer((_) async => testSession);

      // Act
      final result = await signUp(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      // Assert
      expect(result, testSession);
      verify(
        mockRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should sign up without name', () async {
      // Arrange
      when(
        mockRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => testSession);

      // Act
      final result = await signUp(email: testEmail, password: testPassword);

      // Assert
      expect(result, testSession);
      verify(
        mockRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test(
      'should throw EmailAlreadyExistsException when email exists',
      () async {
        // Arrange
        when(
          mockRepository.signUpWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).thenThrow(const EmailAlreadyExistsException());

        // Act & Assert
        expect(
          () => signUp(email: testEmail, password: testPassword),
          throwsA(isA<EmailAlreadyExistsException>()),
        );
      },
    );

    test('should throw WeakPasswordException for weak password', () async {
      // Arrange
      const weakPassword = '123456'; // Passes length but weak
      when(
        mockRepository.signUpWithEmail(
          email: testEmail,
          password: weakPassword,
        ),
      ).thenThrow(const WeakPasswordException());

      // Act & Assert
      expect(
        () => signUp(email: testEmail, password: weakPassword),
        throwsA(isA<WeakPasswordException>()),
      );
    });

    test('should throw NetworkException when no internet connection', () async {
      // Arrange
      when(
        mockRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenThrow(const NetworkException());

      // Act & Assert
      expect(
        () => signUp(email: testEmail, password: testPassword),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should validate email is not empty', () async {
      // Act & Assert
      expect(
        () => signUp(email: '', password: testPassword),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should validate password is not empty', () async {
      // Act & Assert
      expect(
        () => signUp(email: testEmail, password: ''),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should validate email format', () async {
      // Act & Assert
      expect(
        () => signUp(email: 'invalid-email', password: testPassword),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should validate password minimum length', () async {
      // Act & Assert
      expect(
        () => signUp(email: testEmail, password: '12345'),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockRepository);
    });
  });
}
