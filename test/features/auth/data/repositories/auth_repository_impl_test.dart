import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:mulligans_law/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart'
    as domain;
import 'package:mulligans_law/features/auth/domain/entities/auth_session.dart';
import 'package:mulligans_law/core/errors/auth_exceptions.dart';

import 'auth_repository_impl_test.mocks.dart';

// Generate mocks for Supabase classes
@GenerateMocks([
  supabase.SupabaseClient,
  supabase.GoTrueClient,
  supabase.Session,
  supabase.User,
  supabase.UserResponse,
])
void main() {
  late AuthRepositoryImpl repository;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuthClient;

  // Test constants
  const testEmail = 'test@example.com';
  const testPassword = 'Test123!@#';
  const testName = 'Test User';
  const testUserId = 'user-123';
  const testAccessToken = 'access-token-123';
  const testRefreshToken = 'refresh-token-123';

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockAuthClient = MockGoTrueClient();
    when(mockSupabaseClient.auth).thenReturn(mockAuthClient);

    // Mock the auth state change stream
    when(
      mockAuthClient.onAuthStateChange,
    ).thenAnswer((_) => const Stream.empty());

    repository = AuthRepositoryImpl(supabase: mockSupabaseClient);
  });

  group('signInWithEmail', () {
    test('should return AuthSession on successful sign in', () async {
      // Arrange
      final mockUser = MockUser();
      final mockSession = MockSession();
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      when(mockUser.id).thenReturn(testUserId);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUser.userMetadata).thenReturn({'name': testName});
      when(mockUser.createdAt).thenReturn(DateTime.now().toIso8601String());

      when(mockSession.user).thenReturn(mockUser);
      when(mockSession.accessToken).thenReturn(testAccessToken);
      when(mockSession.refreshToken).thenReturn(testRefreshToken);
      when(
        mockSession.expiresAt,
      ).thenReturn(expiresAt.millisecondsSinceEpoch ~/ 1000);

      final authResponse = supabase.AuthResponse(
        session: mockSession,
        user: mockUser,
      );
      when(
        mockAuthClient.signInWithPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => authResponse);

      // Act
      final result = await repository.signInWithEmail(
        email: testEmail,
        password: testPassword,
      );

      // Assert
      expect(result, isA<AuthSession>());
      expect(result.user, isA<domain.AuthUser>());
      expect(result.user.id, testUserId);
      expect(result.user.email, testEmail);
      expect(result.user.name, testName);
      expect(result.accessToken, testAccessToken);
      expect(result.refreshToken, testRefreshToken);
      verify(
        mockAuthClient.signInWithPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test(
      'should throw InvalidCredentialsException on wrong password',
      () async {
        // Arrange
        when(
          mockAuthClient.signInWithPassword(
            email: testEmail,
            password: testPassword,
          ),
        ).thenThrow(Exception('Invalid login credentials'));

        // Act & Assert
        expect(
          () => repository.signInWithEmail(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(isA<InvalidCredentialsException>()),
        );
      },
    );

    test('should throw NetworkException on network error', () async {
      // Arrange
      when(
        mockAuthClient.signInWithPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => repository.signInWithEmail(
          email: testEmail,
          password: testPassword,
        ),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('signUpWithEmail', () {
    test('should return AuthSession on successful sign up', () async {
      // Arrange
      final mockUser = MockUser();
      final mockSession = MockSession();
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      when(mockUser.id).thenReturn(testUserId);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUser.userMetadata).thenReturn({'name': testName});
      when(mockUser.createdAt).thenReturn(DateTime.now().toIso8601String());

      when(mockSession.user).thenReturn(mockUser);
      when(mockSession.accessToken).thenReturn(testAccessToken);
      when(mockSession.refreshToken).thenReturn(testRefreshToken);
      when(
        mockSession.expiresAt,
      ).thenReturn(expiresAt.millisecondsSinceEpoch ~/ 1000);

      final authResponse = supabase.AuthResponse(
        session: mockSession,
        user: mockUser,
      );
      when(
        mockAuthClient.signUp(
          email: testEmail,
          password: testPassword,
          data: {'name': testName},
        ),
      ).thenAnswer((_) async => authResponse);

      // Act
      final result = await repository.signUpWithEmail(
        email: testEmail,
        password: testPassword,
        name: testName,
      );

      // Assert
      expect(result, isA<AuthSession>());
      expect(result.user.id, testUserId);
      expect(result.user.email, testEmail);
      expect(result.user.name, testName);
      verify(
        mockAuthClient.signUp(
          email: testEmail,
          password: testPassword,
          data: {'name': testName},
        ),
      ).called(1);
    });

    test(
      'should throw EmailAlreadyExistsException when email exists',
      () async {
        // Arrange
        when(
          mockAuthClient.signUp(
            email: testEmail,
            password: testPassword,
            data: anyNamed('data'),
          ),
        ).thenThrow(Exception('User already registered'));

        // Act & Assert
        expect(
          () => repository.signUpWithEmail(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(isA<EmailAlreadyExistsException>()),
        );
      },
    );

    test('should throw WeakPasswordException for weak password', () async {
      // Arrange
      when(
        mockAuthClient.signUp(
          email: testEmail,
          password: 'weak',
          data: anyNamed('data'),
        ),
      ).thenThrow(Exception('Password should be at least 6 characters'));

      // Act & Assert
      expect(
        () => repository.signUpWithEmail(email: testEmail, password: 'weak'),
        throwsA(isA<WeakPasswordException>()),
      );
    });
  });

  group('signOut', () {
    test('should sign out successfully', () async {
      // Arrange
      when(mockAuthClient.signOut()).thenAnswer((_) async {});

      // Act
      await repository.signOut();

      // Assert
      verify(mockAuthClient.signOut()).called(1);
    });

    test('should throw AuthException on sign out failure', () async {
      // Arrange
      when(mockAuthClient.signOut()).thenThrow(Exception('Sign out failed'));

      // Act & Assert
      expect(() => repository.signOut(), throwsA(isA<AuthException>()));
    });
  });

  group('getCurrentUser', () {
    test('should return AuthUser when user is signed in', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.id).thenReturn(testUserId);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUser.userMetadata).thenReturn({'name': testName});
      when(mockUser.createdAt).thenReturn(DateTime.now().toIso8601String());

      when(mockAuthClient.currentUser).thenReturn(mockUser);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isA<domain.AuthUser>());
      expect(result?.id, testUserId);
      expect(result?.email, testEmail);
      expect(result?.name, testName);
    });

    test('should return null when no user is signed in', () async {
      // Arrange
      when(mockAuthClient.currentUser).thenReturn(null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, isNull);
    });
  });

  group('getCurrentSession', () {
    test('should return AuthSession when session exists', () async {
      // Arrange
      final mockUser = MockUser();
      final mockSession = MockSession();
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      when(mockUser.id).thenReturn(testUserId);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUser.userMetadata).thenReturn({});
      when(mockUser.createdAt).thenReturn(DateTime.now().toIso8601String());

      when(mockSession.user).thenReturn(mockUser);
      when(mockSession.accessToken).thenReturn(testAccessToken);
      when(mockSession.refreshToken).thenReturn(testRefreshToken);
      when(
        mockSession.expiresAt,
      ).thenReturn(expiresAt.millisecondsSinceEpoch ~/ 1000);

      when(mockAuthClient.currentSession).thenReturn(mockSession);

      // Act
      final result = await repository.getCurrentSession();

      // Assert
      expect(result, isA<AuthSession>());
      expect(result?.user.id, testUserId);
      expect(result?.accessToken, testAccessToken);
    });

    test('should return null when no session exists', () async {
      // Arrange
      when(mockAuthClient.currentSession).thenReturn(null);

      // Act
      final result = await repository.getCurrentSession();

      // Assert
      expect(result, isNull);
    });
  });

  group('resetPassword', () {
    test('should send password reset email successfully', () async {
      // Arrange
      when(
        mockAuthClient.resetPasswordForEmail(testEmail),
      ).thenAnswer((_) async {});

      // Act
      await repository.resetPassword(email: testEmail);

      // Assert
      verify(mockAuthClient.resetPasswordForEmail(testEmail)).called(1);
    });

    test('should throw UserNotFoundException when email not found', () async {
      // Arrange
      when(
        mockAuthClient.resetPasswordForEmail(testEmail),
      ).thenThrow(Exception('User not found'));

      // Act & Assert
      expect(
        () => repository.resetPassword(email: testEmail),
        throwsA(isA<UserNotFoundException>()),
      );
    });
  });

  group('updateProfile', () {
    test('should update user profile successfully', () async {
      // Arrange
      final mockUser = MockUser();
      when(mockUser.id).thenReturn(testUserId);
      when(mockUser.email).thenReturn(testEmail);
      when(mockUser.userMetadata).thenReturn({'name': 'Updated Name'});
      when(mockUser.createdAt).thenReturn(DateTime.now().toIso8601String());

      final mockUserResponse = MockUserResponse();
      when(mockUserResponse.user).thenReturn(mockUser);

      when(
        mockAuthClient.updateUser(any),
      ).thenAnswer((_) async => mockUserResponse);

      // Act
      final result = await repository.updateProfile(name: 'Updated Name');

      // Assert
      expect(result, isA<domain.AuthUser>());
      expect(result.name, 'Updated Name');
      verify(mockAuthClient.updateUser(any)).called(1);
    });

    test('should throw UnauthorizedException when no user signed in', () async {
      // Arrange
      when(
        mockAuthClient.updateUser(any),
      ).thenThrow(Exception('Not authenticated'));

      // Act & Assert
      expect(
        () => repository.updateProfile(name: 'New Name'),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });
}
