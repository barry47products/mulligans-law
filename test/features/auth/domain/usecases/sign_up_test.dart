import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_session.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/domain/repositories/auth_repository.dart';
import 'package:mulligans_law/features/auth/domain/usecases/sign_up.dart';
import 'package:mulligans_law/core/errors/auth_exceptions.dart';
import 'package:mulligans_law/features/members/domain/entities/member.dart';
import 'package:mulligans_law/features/members/domain/repositories/member_repository.dart';
import 'package:mulligans_law/core/errors/member_exceptions.dart';

import 'sign_up_test.mocks.dart';

@GenerateMocks([AuthRepository, MemberRepository])
void main() {
  late SignUp signUp;
  late MockAuthRepository mockAuthRepository;
  late MockMemberRepository mockMemberRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockMemberRepository = MockMemberRepository();
    signUp = SignUp(mockAuthRepository, mockMemberRepository);
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
        mockAuthRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      ).thenAnswer((_) async => testSession);

      when(
        mockMemberRepository.createPrimaryMember(
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          handicap: anyNamed('handicap'),
        ),
      ).thenAnswer(
        (_) async => Member(
          id: 'member-123',
          societyId: null,
          userId: testUser.id,
          name: testName,
          email: testEmail,
          handicap: 0.0,
          role: null,
          joinedAt: DateTime.now(),
        ),
      );

      // Act
      final result = await signUp(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      // Assert
      expect(result, testSession);
      verify(
        mockAuthRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      ).called(1);
    });

    test('should sign up without name', () async {
      // Arrange
      when(
        mockAuthRepository.signUpWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => testSession);

      when(
        mockMemberRepository.createPrimaryMember(
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          handicap: anyNamed('handicap'),
        ),
      ).thenAnswer(
        (_) async => Member(
          id: 'member-123',
          societyId: null,
          userId: testUser.id,
          name: testEmail,
          email: testEmail,
          handicap: 0.0,
          role: null,
          joinedAt: DateTime.now(),
        ),
      );

      // Act
      final result = await signUp(email: testEmail, password: testPassword);

      // Assert
      expect(result, testSession);
      verify(
        mockAuthRepository.signUpWithEmail(
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
          mockAuthRepository.signUpWithEmail(
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
        mockAuthRepository.signUpWithEmail(
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
        mockAuthRepository.signUpWithEmail(
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
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should validate password is not empty', () async {
      // Act & Assert
      expect(
        () => signUp(email: testEmail, password: ''),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should validate email format', () async {
      // Act & Assert
      expect(
        () => signUp(email: 'invalid-email', password: testPassword),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should validate password minimum length', () async {
      // Act & Assert
      expect(
        () => signUp(email: testEmail, password: '12345'),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(mockAuthRepository);
    });

    group('Primary Member Creation', () {
      const testHandicap = 18.0;

      final testMember = Member(
        id: 'member-123',
        societyId: null, // Primary member
        userId: 'user-123',
        name: testName,
        email: testEmail,
        handicap: testHandicap,
        role: null, // Primary member
        joinedAt: DateTime.now(),
      );

      test('should create primary member after successful sign up', () async {
        // Arrange
        when(
          mockAuthRepository.signUpWithEmail(
            email: testEmail,
            password: testPassword,
            name: testName,
          ),
        ).thenAnswer((_) async => testSession);

        when(
          mockMemberRepository.createPrimaryMember(
            userId: testUser.id,
            name: testName,
            email: testEmail,
            handicap: testHandicap,
          ),
        ).thenAnswer((_) async => testMember);

        // Act
        await signUp(
          email: testEmail,
          password: testPassword,
          name: testName,
          handicap: testHandicap,
        );

        // Assert
        verify(
          mockMemberRepository.createPrimaryMember(
            userId: testUser.id,
            name: testName,
            email: testEmail,
            handicap: testHandicap,
          ),
        ).called(1);
      });

      test(
        'should create primary member with null societyId and role',
        () async {
          // Arrange
          when(
            mockAuthRepository.signUpWithEmail(
              email: testEmail,
              password: testPassword,
              name: testName,
            ),
          ).thenAnswer((_) async => testSession);

          when(
            mockMemberRepository.createPrimaryMember(
              userId: anyNamed('userId'),
              name: anyNamed('name'),
              email: anyNamed('email'),
              handicap: anyNamed('handicap'),
            ),
          ).thenAnswer((_) async => testMember);

          // Act
          await signUp(
            email: testEmail,
            password: testPassword,
            name: testName,
            handicap: testHandicap,
          );

          // Assert - Verify member was created
          final captured = verify(
            mockMemberRepository.createPrimaryMember(
              userId: captureAnyNamed('userId'),
              name: captureAnyNamed('name'),
              email: captureAnyNamed('email'),
              handicap: captureAnyNamed('handicap'),
            ),
          ).captured;

          expect(captured[0], testUser.id); // userId from auth
          expect(captured[1], testName); // name from sign up
          expect(captured[2], testEmail); // email from sign up
          expect(captured[3], testHandicap); // handicap from sign up
        },
      );

      test('should use default handicap if not provided', () async {
        // Arrange
        const defaultHandicap = 0.0;
        when(
          mockAuthRepository.signUpWithEmail(
            email: testEmail,
            password: testPassword,
            name: testName,
          ),
        ).thenAnswer((_) async => testSession);

        when(
          mockMemberRepository.createPrimaryMember(
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: defaultHandicap,
          ),
        ).thenAnswer((_) async => testMember);

        // Act
        await signUp(email: testEmail, password: testPassword, name: testName);

        // Assert
        verify(
          mockMemberRepository.createPrimaryMember(
            userId: testUser.id,
            name: testName,
            email: testEmail,
            handicap: defaultHandicap,
          ),
        ).called(1);
      });

      test('should throw exception if member creation fails', () async {
        // Arrange
        when(
          mockAuthRepository.signUpWithEmail(
            email: testEmail,
            password: testPassword,
            name: testName,
          ),
        ).thenAnswer((_) async => testSession);

        when(
          mockMemberRepository.createPrimaryMember(
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
          ),
        ).thenThrow(
          MemberAlreadyExistsException('Primary member already exists'),
        );

        // Act & Assert
        expect(
          () => signUp(
            email: testEmail,
            password: testPassword,
            name: testName,
            handicap: testHandicap,
          ),
          throwsA(isA<MemberAlreadyExistsException>()),
        );
      });

      test('should handle member database exception', () async {
        // Arrange
        when(
          mockAuthRepository.signUpWithEmail(
            email: testEmail,
            password: testPassword,
            name: testName,
          ),
        ).thenAnswer((_) async => testSession);

        when(
          mockMemberRepository.createPrimaryMember(
            userId: anyNamed('userId'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            handicap: anyNamed('handicap'),
          ),
        ).thenThrow(MemberDatabaseException('Failed to create member'));

        // Act & Assert
        expect(
          () => signUp(
            email: testEmail,
            password: testPassword,
            name: testName,
            handicap: testHandicap,
          ),
          throwsA(isA<MemberDatabaseException>()),
        );
      });
    });
  });
}
