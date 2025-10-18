import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_session.dart';
import 'package:mulligans_law/features/auth/domain/entities/auth_user.dart';
import 'package:mulligans_law/features/auth/domain/usecases/get_current_user.dart';
import 'package:mulligans_law/features/auth/domain/usecases/sign_in.dart';
import 'package:mulligans_law/features/auth/domain/usecases/sign_out.dart';
import 'package:mulligans_law/features/auth/domain/usecases/sign_up.dart';
import 'package:mulligans_law/features/auth/domain/repositories/auth_repository.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_event.dart';
import 'package:mulligans_law/features/auth/presentation/bloc/auth_state.dart';
import 'package:mulligans_law/core/errors/auth_exceptions.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([SignIn, SignUp, SignOut, GetCurrentUser, AuthRepository])
void main() {
  late AuthBloc authBloc;
  late MockSignIn mockSignIn;
  late MockSignUp mockSignUp;
  late MockSignOut mockSignOut;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockAuthRepository mockAuthRepository;

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

  setUp(() {
    mockSignIn = MockSignIn();
    mockSignUp = MockSignUp();
    mockSignOut = MockSignOut();
    mockGetCurrentUser = MockGetCurrentUser();
    mockAuthRepository = MockAuthRepository();

    // Mock the auth state stream to return empty by default
    when(
      mockAuthRepository.authStateChanges,
    ).thenAnswer((_) => const Stream.empty());

    authBloc = AuthBloc(
      signIn: mockSignIn,
      signUp: mockSignUp,
      signOut: mockSignOut,
      getCurrentUser: mockGetCurrentUser,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when user is signed in',
        build: () {
          when(mockGetCurrentUser()).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
        verify: (_) {
          verify(mockGetCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when no user is signed in',
        build: () {
          when(mockGetCurrentUser()).thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
        verify: (_) {
          verify(mockGetCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when check fails',
        build: () {
          when(
            mockGetCurrentUser(),
          ).thenThrow(const AuthException('Failed to get user'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [
          const AuthLoading(),
          const AuthError('Failed to get user'),
        ],
      );
    });

    group('AuthSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] on successful sign in',
        build: () {
          when(
            mockSignIn(email: testEmail, password: testPassword),
          ).thenAnswer((_) async => testSession);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthSignInRequested(email: testEmail, password: testPassword),
        ),
        expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
        verify: (_) {
          verify(
            mockSignIn(email: testEmail, password: testPassword),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] on invalid credentials',
        build: () {
          when(
            mockSignIn(email: testEmail, password: testPassword),
          ).thenThrow(const InvalidCredentialsException());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthSignInRequested(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError('Invalid email or password'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] on network error',
        build: () {
          when(
            mockSignIn(email: testEmail, password: testPassword),
          ).thenThrow(const NetworkException());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthSignInRequested(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError('No internet connection'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] with validation error',
        build: () {
          when(
            mockSignIn(email: '', password: testPassword),
          ).thenThrow(const AuthException('Email cannot be empty'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthSignInRequested(email: '', password: testPassword),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError('Email cannot be empty'),
        ],
      );
    });

    group('AuthSignUpRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] on successful sign up',
        build: () {
          when(
            mockSignUp(
              email: testEmail,
              password: testPassword,
              name: testName,
            ),
          ).thenAnswer((_) async => testSession);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthSignUpRequested(
            email: testEmail,
            password: testPassword,
            name: testName,
          ),
        ),
        expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
        verify: (_) {
          verify(
            mockSignUp(
              email: testEmail,
              password: testPassword,
              name: testName,
            ),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when email already exists',
        build: () {
          when(
            mockSignUp(email: testEmail, password: testPassword),
          ).thenThrow(const EmailAlreadyExistsException());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthSignUpRequested(email: testEmail, password: testPassword),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError('Email address is already registered'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] on weak password',
        build: () {
          when(
            mockSignUp(email: testEmail, password: 'weak'),
          ).thenThrow(const WeakPasswordException());
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthSignUpRequested(email: testEmail, password: 'weak'),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError('Password is too weak'),
        ],
      );
    });

    group('AuthSignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] on successful sign out',
        build: () {
          when(mockSignOut()).thenAnswer((_) async {});
          return authBloc;
        },
        seed: () => AuthAuthenticated(testUser),
        act: (bloc) => bloc.add(const AuthSignOutRequested()),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
        verify: (_) {
          verify(mockSignOut()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign out fails',
        build: () {
          when(mockSignOut()).thenThrow(const AuthException('Sign out failed'));
          return authBloc;
        },
        seed: () => AuthAuthenticated(testUser),
        act: (bloc) => bloc.add(const AuthSignOutRequested()),
        expect: () => [const AuthLoading(), const AuthError('Sign out failed')],
      );
    });

    group('AuthUserChanged', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when user ID is provided',
        build: () {
          when(mockGetCurrentUser()).thenAnswer((_) async => testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthUserChanged('user-123')),
        expect: () => [const AuthLoading(), AuthAuthenticated(testUser)],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthUnauthenticated] when user ID is null',
        build: () => authBloc,
        seed: () => AuthAuthenticated(testUser),
        act: (bloc) => bloc.add(const AuthUserChanged(null)),
        expect: () => [const AuthUnauthenticated()],
      );
    });
  });
}
