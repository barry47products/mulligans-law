# Authentication API Reference

Complete API reference for the authentication feature.

## Domain Layer

### Entities

#### AuthUser

Domain entity representing an authenticated user.

**Location:** `lib/features/auth/domain/entities/auth_user.dart`

```dart
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl, createdAt];
}
```

**Properties:**

| Property    | Type       | Description                           |
| ----------- | ---------- | ------------------------------------- |
| `id`        | `String`   | Unique user identifier (UUID)         |
| `email`     | `String`   | User's email address                  |
| `name`      | `String?`  | User's display name (optional)        |
| `avatarUrl` | `String?`  | URL to user's avatar image (optional) |
| `createdAt` | `DateTime` | Account creation timestamp            |

#### AuthSession

Domain entity representing an authentication session with validation.

**Location:** `lib/features/auth/domain/entities/auth_session.dart`

```dart
class AuthSession extends Equatable {
  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isValid => DateTime.now().isBefore(expiresAt);

  @override
  List<Object> get props => [user, accessToken, refreshToken, expiresAt];
}
```

**Properties:**

| Property       | Type       | Description                           |
| -------------- | ---------- | ------------------------------------- |
| `user`         | `AuthUser` | The authenticated user                |
| `accessToken`  | `String`   | JWT access token for API requests     |
| `refreshToken` | `String`   | JWT refresh token for renewing access |
| `expiresAt`    | `DateTime` | Token expiration timestamp            |

**Getters:**

| Getter    | Type   | Description                            |
| --------- | ------ | -------------------------------------- |
| `isValid` | `bool` | Returns true if session hasn't expired |

### Repository Interface

#### AuthRepository

Abstract interface defining authentication operations.

**Location:** `lib/features/auth/domain/repositories/auth_repository.dart`

```dart
abstract class AuthRepository {
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthSession> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  Future<void> signOut();

  Future<AuthUser?> getCurrentUser();

  Future<AuthSession?> getCurrentSession();

  Future<void> resetPassword({required String email});

  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
  });

  Stream<AuthUser?> get authStateChanges;
}
```

**Methods:**

##### **signInWithEmail**

```dart
Future<AuthSession> signInWithEmail({
  required String email,
  required String password,
})
```

Authenticates user with email and password.

- **Parameters:**
  - `email`: User's email address
  - `password`: User's password
- **Returns:** `AuthSession` on success
- **Throws:**
  - `InvalidCredentialsException` - Wrong email/password
  - `NetworkException` - No internet connection
  - `AuthException` - Other authentication errors

##### **signUpWithEmail**

```dart
Future<AuthSession> signUpWithEmail({
  required String email,
  required String password,
  String? name,
})
```

Creates new user account with email and password.

- **Parameters:**
  - `email`: User's email address
  - `password`: User's password (minimum 6 characters)
  - `name`: User's display name (optional)
- **Returns:** `AuthSession` on success
- **Throws:**
  - `EmailAlreadyExistsException` - Email already registered
  - `WeakPasswordException` - Password doesn't meet requirements
  - `NetworkException` - No internet connection
  - `AuthException` - Other authentication errors

##### **signOut**

```dart
Future<void> signOut()
```

Signs out the current user and clears session.

- **Throws:**
  - `AuthException` - Sign out failed
  - `NetworkException` - No internet connection

##### **getCurrentUser**

```dart
Future<AuthUser?> getCurrentUser()
```

Gets the currently authenticated user.

- **Returns:** `AuthUser` if signed in, `null` otherwise
- **Throws:**
  - `AuthException` - Failed to get current user

##### **getCurrentSession**

```dart
Future<AuthSession?> getCurrentSession()
```

Gets the current authentication session.

- **Returns:** `AuthSession` if session exists, `null` otherwise
- **Throws:**
  - `SessionExpiredException` - Session has expired
  - `AuthException` - Failed to get session

##### **resetPassword**

```dart
Future<void> resetPassword({required String email})
```

Sends password reset email to user.

- **Parameters:**
  - `email`: User's email address
- **Throws:**
  - `UserNotFoundException` - Email not found
  - `NetworkException` - No internet connection
  - `AuthException` - Failed to send reset email

##### **updateProfile**

```dart
Future<void> updateProfile({
  String? name,
  String? avatarUrl,
})
```

Updates user profile information.

- **Parameters:**
  - `name`: New display name (optional)
  - `avatarUrl`: New avatar URL (optional)
- **Throws:**
  - `UnauthorizedException` - No user signed in
  - `NetworkException` - No internet connection
  - `AuthException` - Update failed

##### **authStateChanges**

```dart
Stream<AuthUser?> get authStateChanges
```

Stream that emits when authentication state changes.

- **Returns:** Stream of `AuthUser?`
- **Emits:**
  - `AuthUser` when user signs in
  - `null` when user signs out

### Use Cases

#### SignIn

Email/password sign-in use case with validation.

**Location:** `lib/features/auth/domain/usecases/sign_in.dart`

```dart
class SignIn {
  final AuthRepository _repository;

  SignIn(this._repository);

  Future<AuthSession> call({
    required String email,
    required String password,
  }) async {
    // Validation
    if (email.trim().isEmpty) {
      throw const AuthException('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw const AuthException('Password cannot be empty');
    }
    if (!_isValidEmail(email)) {
      throw const AuthException('Invalid email format');
    }

    // Delegate to repository
    return await _repository.signInWithEmail(
      email: email.trim(),
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

**Usage:**

```dart
final signIn = SignIn(authRepository);
try {
  final session = await signIn(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Signed in: ${session.user.email}');
} on AuthException catch (e) {
  print('Sign in failed: ${e.message}');
}
```

#### SignUp

Email/password sign-up use case with validation.

**Location:** `lib/features/auth/domain/usecases/sign_up.dart`

```dart
class SignUp {
  final AuthRepository _repository;
  static const int _minimumPasswordLength = 6;

  SignUp(this._repository);

  Future<AuthSession> call({
    required String email,
    required String password,
    String? name,
  }) async {
    // Validation
    if (email.trim().isEmpty) {
      throw const AuthException('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw const AuthException('Password cannot be empty');
    }
    if (!_isValidEmail(email)) {
      throw const AuthException('Invalid email format');
    }
    if (password.length < _minimumPasswordLength) {
      throw AuthException(
        'Password must be at least $_minimumPasswordLength characters',
      );
    }

    // Delegate to repository
    return await _repository.signUpWithEmail(
      email: email.trim(),
      password: password,
      name: name?.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

#### SignOut

Sign-out use case.

**Location:** `lib/features/auth/domain/usecases/sign_out.dart`

```dart
class SignOut {
  final AuthRepository _repository;

  SignOut(this._repository);

  Future<void> call() async {
    return await _repository.signOut();
  }
}
```

#### GetCurrentUser

Get current user use case.

**Location:** `lib/features/auth/domain/usecases/get_current_user.dart`

```dart
class GetCurrentUser {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  Future<AuthUser?> call() async {
    return await _repository.getCurrentUser();
  }
}
```

### Exceptions

Custom authentication exceptions.

**Location:** `lib/core/errors/auth_exceptions.dart`

#### AuthException

Base exception for all authentication errors.

```dart
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
```

#### InvalidCredentialsException

Thrown when email/password combination is incorrect.

```dart
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([String? message])
      : super(message ?? 'Invalid email or password');
}
```

#### EmailAlreadyExistsException

Thrown when attempting to sign up with existing email.

```dart
class EmailAlreadyExistsException extends AuthException {
  const EmailAlreadyExistsException([String? message])
      : super(message ?? 'Email already exists');
}
```

#### WeakPasswordException

Thrown when password doesn't meet requirements.

```dart
class WeakPasswordException extends AuthException {
  const WeakPasswordException([String? message])
      : super(message ?? 'Password is too weak');
}
```

#### UserNotFoundException

Thrown when user email not found.

```dart
class UserNotFoundException extends AuthException {
  const UserNotFoundException([String? message])
      : super(message ?? 'User not found');
}
```

#### UnauthorizedException

Thrown when operation requires authentication.

```dart
class UnauthorizedException extends AuthException {
  const UnauthorizedException([String? message])
      : super(message ?? 'User not authorized');
}
```

#### NetworkException

Thrown when network connection fails.

```dart
class NetworkException extends AuthException {
  const NetworkException([String? message])
      : super(message ?? 'Network error occurred');
}
```

#### SessionExpiredException

Thrown when session has expired.

```dart
class SessionExpiredException extends AuthException {
  const SessionExpiredException([String? message])
      : super(message ?? 'Session has expired');
}
```

## Presentation Layer

### BLoC

#### AuthBloc

BLoC for managing authentication state.

**Location:** `lib/features/auth/presentation/bloc/auth_bloc.dart`

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final AuthRepository _authRepository;

  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required AuthRepository authRepository,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       _getCurrentUser = getCurrentUser,
       _authRepository = authRepository,
       super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthUserChanged>(_onAuthUserChanged);

    // Listen to auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthUserChanged(user?.id));
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
```

#### AuthEvent

Events that can be sent to AuthBloc.

**Location:** `lib/features/auth/presentation/bloc/auth_event.dart`

##### **AuthCheckRequested**

```dart
class AuthCheckRequested extends AuthEvent {}
```

Check current authentication status on app start.

##### **AuthSignInRequested**

```dart
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });
}
```

Request sign in with email and password.

##### **AuthSignUpRequested**

```dart
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? name;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    this.name,
  });
}
```

Request sign up with email, password, and optional name.

##### **AuthSignOutRequested**

```dart
class AuthSignOutRequested extends AuthEvent {}
```

Request sign out of current session.

##### **AuthUserChanged**

```dart
class AuthUserChanged extends AuthEvent {
  final String? userId;

  const AuthUserChanged(this.userId);
}
```

Internal event triggered when auth state changes.

#### AuthState

States emitted by AuthBloc.

**Location:** `lib/features/auth/presentation/bloc/auth_state.dart`

##### **AuthInitial**

```dart
class AuthInitial extends AuthState {
  const AuthInitial();
}
```

Initial state before any auth operations.

##### **AuthLoading**

```dart
class AuthLoading extends AuthState {
  const AuthLoading();
}
```

Authentication operation in progress.

##### **AuthAuthenticated**

```dart
class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);
}
```

User is successfully authenticated.

##### **AuthUnauthenticated**

```dart
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
```

User is not authenticated.

##### **AuthError**

```dart
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
```

Authentication operation failed with error message.

## Configuration

### SupabaseConfig

Configuration class for Supabase connection.

**Location:** `lib/core/config/supabase_config.dart`

```dart
class SupabaseConfig {
  SupabaseConfig._(); // Private constructor

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://localhost:54321',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGc...', // Local dev key
  );

  static const bool enableDebugLogging = bool.fromEnvironment(
    'SUPABASE_DEBUG',
    defaultValue: true,
  );
}
```

**Constants:**

| Constant             | Type     | Default                  | Description                |
| -------------------- | -------- | ------------------------ | -------------------------- |
| `supabaseUrl`        | `String` | `http://localhost:54321` | Supabase project URL       |
| `supabaseAnonKey`    | `String` | Local dev key            | Supabase anonymous key     |
| `enableDebugLogging` | `bool`   | `true`                   | Enable Supabase debug logs |

**Environment Variables:**

Set via `--dart-define` flags:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-key \
  --dart-define=SUPABASE_DEBUG=false
```
