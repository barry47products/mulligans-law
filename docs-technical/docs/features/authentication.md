# Authentication

The authentication system provides complete user management with email/password authentication, powered by Supabase.

## Overview

The authentication feature follows Clean Architecture principles with three distinct layers:

```bash
Presentation Layer (UI + BLoC)
       ↓
Domain Layer (Business Logic)
       ↓
Data Layer (Supabase Integration)
```

## Features

- ✅ Email/password sign up
- ✅ Email/password sign in
- ✅ Sign out
- ✅ Password reset
- ✅ Email verification
- ✅ Persistent sessions
- ✅ Automatic token refresh
- ✅ Offline-first architecture

## Architecture

### Domain Layer

#### Entities

**AuthUser** - Domain representation of an authenticated user:

```dart
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;
}
```

**AuthSession** - Domain representation of an authentication session:

```dart
class AuthSession extends Equatable {
  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  bool get isValid => DateTime.now().isBefore(expiresAt);
}
```

#### Repository Interface

```dart
abstract class AuthRepository {
  Future<AuthSession> signInWithEmail({required String email, required String password});
  Future<AuthSession> signUpWithEmail({required String email, required String password, String? name});
  Future<void> signOut();
  Future<AuthUser?> getCurrentUser();
  Future<AuthSession?> getCurrentSession();
  Future<void> resetPassword({required String email});
  Future<void> updateProfile({String? name, String? avatarUrl});
  Stream<AuthUser?> get authStateChanges;
}
```

#### Use Cases

All use cases follow the callable pattern with validation:

- **SignIn** - Validates email/password format, delegates to repository
- **SignUp** - Validates email/password/name, enforces 6-char minimum password
- **SignOut** - Clears session and local storage
- **GetCurrentUser** - Returns current authenticated user or null

### Data Layer

#### Repository Implementation

**AuthRepositoryImpl** integrates with Supabase:

```dart
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabase;

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session!.toDomain();
    } catch (e) {
      // Error mapping to domain exceptions
    }
  }
}
```

**Error Handling:**

Supabase exceptions are mapped to domain exceptions:

- `AuthException` (400) → `InvalidCredentialsException`
- `AuthException` (409) → `EmailAlreadyExistsException`
- `AuthException` (422) → `WeakPasswordException`
- `SocketException` → `NetworkException`

### Presentation Layer

#### BLoC State Management

**AuthBloc** manages authentication state with 5 events and 5 states:

**Events:**

- `AuthCheckRequested` - Check auth status on app start
- `AuthSignInRequested` - User requests sign in
- `AuthSignUpRequested` - User requests sign up
- `AuthSignOutRequested` - User requests sign out
- `AuthUserChanged` - Auth state changed (from stream)

**States:**

- `AuthInitial` - Initial state
- `AuthLoading` - Operation in progress
- `AuthAuthenticated` - User is signed in
- `AuthUnauthenticated` - User is not signed in
- `AuthError` - Operation failed with error message

**Stream Listener:**

The BLoC subscribes to `authStateChanges` and emits `AuthUserChanged` events:

```dart
_authStateSubscription = _authRepository.authStateChanges.listen((user) {
  add(AuthUserChanged(user?.id));
});
```

#### UI Screens

**WelcomeScreen** - Entry point with branding:

- Golf course icon
- "Welcome to Mulligans Law" message
- Sign In and Create Account buttons

**SignInScreen** - Email/password authentication:

- Email input with validation
- Password input with visibility toggle
- "Forgot password?" link
- Google sign-in placeholder
- Navigate to sign up

**SignUpScreen** - New user registration:

- Full name input
- Email input with validation
- Password input (min 6 characters)
- Optional handicap index (0-54)
- Google sign-up placeholder
- Navigate to sign in

**ForgotPasswordScreen** - Password reset:

- Email input
- Success state with confirmation
- Resend option
- Back to sign in

**VerifyEmailScreen** - Email verification:

- 6-digit code input (auto-advance)
- Auto-submit when complete
- Resend code option
- Email parameter via route arguments

## Configuration

### Supabase Setup

**SupabaseConfig** provides environment-based configuration:

```dart
class SupabaseConfig {
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

**Production Configuration:**

```bash
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co \
            --dart-define=SUPABASE_ANON_KEY=your-anon-key \
            --dart-define=SUPABASE_DEBUG=false
```

### App Integration

**main.dart** initializes Supabase and provides AuthBloc:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
    debug: SupabaseConfig.enableDebugLogging,
  );

  runApp(const MulligansLawApp());
}
```

**Dependency Injection:**

```dart
class MulligansLawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create repository and use cases
    final supabaseClient = Supabase.instance.client;
    final authRepository = AuthRepositoryImpl(supabase: supabaseClient);
    final signInUseCase = SignIn(authRepository);
    final signUpUseCase = SignUp(authRepository);
    final signOutUseCase = SignOut(authRepository);
    final getCurrentUserUseCase = GetCurrentUser(authRepository);

    return BlocProvider(
      create: (context) => AuthBloc(
        signIn: signInUseCase,
        signUp: signUpUseCase,
        signOut: signOutUseCase,
        getCurrentUser: getCurrentUserUseCase,
        authRepository: authRepository,
      )..add(AuthCheckRequested()),
      child: MaterialApp(...),
    );
  }
}
```

### Auth Gate

**AuthGate** routes based on authentication state:

```dart
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
```

## Usage Examples

### Sign In

```dart
// In your widget
context.read<AuthBloc>().add(
  AuthSignInRequested(
    email: 'user@example.com',
    password: 'password123',
  ),
);

// Listen to state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } else if (state is AuthError) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: YourWidget(),
)
```

### Sign Up

```dart
context.read<AuthBloc>().add(
  AuthSignUpRequested(
    email: 'newuser@example.com',
    password: 'securepass123',
    name: 'John Doe',
  ),
);
```

### Sign Out

```dart
context.read<AuthBloc>().add(AuthSignOutRequested());
```

### Check Current User

```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) {
      return Text('Welcome, ${state.user.name ?? state.user.email}!');
    }
    return const SizedBox.shrink();
  },
)
```

## Testing

### Test Coverage

- **Unit Tests (51):**
  - 16 AuthRepository tests
  - 20 Use case tests
  - 13 AuthBloc tests
  - 2 Entity tests

- **Widget Tests (11):**
  - Screen rendering tests
  - Navigation tests
  - Helper utility tests

#### **Total: 62 tests, all passing ✅**

**Coverage:**

- Domain Layer: 95%+
- Data Layer: 90%+
- BLoC Layer: 85%+
- Overall: 31% (UI screens not yet tested)

### Running Tests

```bash
# Run all auth tests
flutter test test/features/auth/

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart
```

### Test Structure

```bash
test/features/auth/
├── data/
│   └── repositories/
│       └── auth_repository_impl_test.dart
├── domain/
│   └── usecases/
│       ├── sign_in_test.dart
│       ├── sign_up_test.dart
│       ├── sign_out_test.dart
│       └── get_current_user_test.dart
└── presentation/
    └── bloc/
        └── auth_bloc_test.dart
```

## Security Considerations

### Row Level Security (RLS)

Supabase enforces RLS policies on all tables. Users can only access their own data.

### Token Management

- Access tokens stored securely by Supabase client
- Automatic token refresh before expiration
- Tokens cleared on sign out
- No tokens stored in plain text

### Password Requirements

- Minimum 6 characters
- Validated client-side and server-side
- Never logged or displayed
- Bcrypt hashing on server

### HTTPS Required

- Production must use HTTPS
- Local development uses HTTP (localhost only)
- Supabase enforces HTTPS in production

## Troubleshooting

### "Supabase instance not initialized"

Make sure Supabase is initialized before `runApp()`:

```dart
await Supabase.initialize(
  url: SupabaseConfig.supabaseUrl,
  anonKey: SupabaseConfig.supabaseAnonKey,
);
```

### "Invalid credentials" on valid login

Check that local Supabase is running:

```bash
supabase status
```

### Tests failing with MissingPluginException

Widget tests that use `MulligansLawApp` need Supabase initialized. Test individual screens instead:

```dart
await tester.pumpWidget(
  const MaterialApp(home: WelcomeScreen()),
);
```

## Future Enhancements

- [ ] OAuth providers (Google, Apple)
- [ ] Biometric authentication
- [ ] Multi-factor authentication (MFA)
- [ ] Session management dashboard
- [ ] Password strength meter
- [ ] Remember me functionality
- [ ] Account deletion

## API Reference

See [Auth API Reference](../api/auth.md) for detailed class and method documentation.
