# Architecture Overview

Mulligans Law is built using **Clean Architecture** principles with an **offline-first** approach, ensuring the app works seamlessly with or without an internet connection.

## Core Principles

### 1. Clean Architecture

The codebase follows Uncle Bob's Clean Architecture pattern, organizing code into distinct layers with clear dependencies:

```bash
Presentation Layer (UI)
       ↓
Domain Layer (Business Logic)
       ↓
Data Layer (External Services)
```

**Key Rules:**

- **Dependencies point inward** - Outer layers depend on inner layers, never the reverse
- **Domain layer is independent** - Contains only business logic, no framework dependencies
- **Testable in isolation** - Each layer can be tested independently

### 2. Offline-First

The app prioritizes local data and synchronizes with the backend when online:

- **Local database first** - All writes go to SQLite (Drift) immediately
- **Optimistic UI updates** - UI reflects changes instantly
- **Background sync** - Data syncs to Supabase when online
- **Conflict resolution** - Last-write-wins strategy

### 3. Test-Driven Development (TDD)

All features are built using the Red-Green-Refactor cycle:

1. **Red** - Write failing test first
2. **Green** - Write minimal code to pass
3. **Refactor** - Improve code quality

**Target Coverage:** 70% overall (70% unit, 20% widget, 10% integration)

## Layer Structure

### Presentation Layer

**Location:** `lib/features/*/presentation/`

**Responsibilities:**

- Display UI to users
- Handle user interactions
- Manage UI state with BLoC

**Components:**

- **Screens** - Full page views
- **Widgets** - Reusable UI components
- **BLoCs** - State management (Business Logic Component)

**Example:**

```dart
lib/features/scores/presentation/
├── bloc/
│   ├── score_capture_bloc.dart
│   ├── score_capture_event.dart
│   └── score_capture_state.dart
├── screens/
│   └── score_capture_screen.dart
└── widgets/
    └── score_card.dart
```

**Dependencies:**

- ✅ Can depend on Domain layer (use cases, entities)
- ❌ Cannot depend on Data layer directly

### Domain Layer

**Location:** `lib/features/*/domain/`

**Responsibilities:**

- Define business logic and rules
- Define data contracts (entities, repositories)
- No framework or external dependencies

**Components:**

- **Entities** - Core business objects (Score, Round, Member)
- **Use Cases** - Single business operations (SubmitScore, CreateRound)
- **Repository Interfaces** - Data access contracts

**Example:**

```dart
lib/features/scores/domain/
├── entities/
│   └── score.dart
├── repositories/
│   └── score_repository.dart  // Interface only
└── usecases/
    ├── submit_score.dart
    └── calculate_stableford.dart
```

**Dependencies:**

- ✅ Pure Dart - no Flutter or external packages
- ❌ Independent of all other layers

### Data Layer

**Location:** `lib/features/*/data/`

**Responsibilities:**

- Implement repository interfaces
- Manage data sources (API, database)
- Handle data transformations

**Components:**

- **Models** - Data Transfer Objects (DTOs)
- **Data Sources** - Remote (Supabase) and Local (Drift)
- **Repository Implementations** - Implement domain interfaces

**Example:**

```dart
lib/features/scores/data/
├── models/
│   └── score_model.dart  // Extends Score entity
├── datasources/
│   ├── score_remote_datasource.dart
│   └── score_local_datasource.dart
└── repositories/
    └── score_repository_impl.dart  // Implements ScoreRepository
```

**Dependencies:**

- ✅ Can depend on Domain layer
- ✅ Can use external packages (Supabase, Drift)

## Data Flow

### Write Operation (Create Score)

```bash
User Action
    ↓
[Presentation] ScoreBloc receives CreateScoreEvent
    ↓
[Domain] CreateScoreUseCase executes
    ↓
[Data] ScoreRepositoryImpl.createScore()
    ↓
[Data] Write to Local DB (Drift) ← Returns immediately
    ↓
[Data] Queue for sync
    ↓
[Presentation] BLoC emits ScoreCreated state
    ↓
UI updates (optimistic)
    ↓
[Background] SyncEngine syncs to Supabase
```

### Read Operation (Get Leaderboard)

```bash
User opens leaderboard
    ↓
[Presentation] LeaderboardBloc receives LoadLeaderboard event
    ↓
[Domain] GetLeaderboardUseCase executes
    ↓
[Data] LeaderboardRepositoryImpl.getLeaderboard()
    ↓
[Data] Read from Local DB (fast) → Return to UI
    ↓
[Presentation] Display cached data immediately
    ↓
[Background] Fetch fresh data from Supabase
    ↓
[Data] Update local DB with fresh data
    ↓
[Presentation] Stream emits updated data
    ↓
UI updates with fresh data
```

## Technology Stack

### Frontend (Flutter)

| Component            | Technology         | Purpose                |
| -------------------- | ------------------ | ---------------------- |
| **Framework**        | Flutter 3.35.6     | Cross-platform UI      |
| **Language**         | Dart 3.9.2         | Programming language   |
| **State Management** | flutter_bloc 8.1.6 | BLoC pattern for state |
| **Navigation**       | go_router (future) | Declarative routing    |
| **DI**               | get_it (future)    | Dependency injection   |

### Backend & Database

| Component     | Technology     | Purpose                             |
| ------------- | -------------- | ----------------------------------- |
| **Backend**   | Supabase       | Auth, PostgreSQL, Storage, Realtime |
| **Remote DB** | PostgreSQL     | Cloud database                      |
| **Local DB**  | Drift (SQLite) | Offline storage                     |
| **ORM**       | Drift 2.22.0   | Type-safe SQL queries               |
| **Auth**      | Supabase Auth  | User authentication                 |

### Testing

| Component        | Technology      | Purpose             |
| ---------------- | --------------- | ------------------- |
| **Unit Tests**   | flutter_test    | Test business logic |
| **Widget Tests** | flutter_test    | Test UI components  |
| **Mocking**      | mockito 5.4.4   | Mock dependencies   |
| **BLoC Tests**   | bloc_test 9.1.7 | Test BLoC state     |
| **Coverage**     | Codecov         | Track coverage      |

### CI/CD

| Component      | Technology                        | Purpose                      |
| -------------- | --------------------------------- | ---------------------------- |
| **CI**         | GitHub Actions                    | Automated testing            |
| **CD**         | GitHub Actions + semantic-release | Auto versioning & deployment |
| **Linting**    | flutter_lints 5.0.0               | Code quality                 |
| **Formatting** | dart format                       | Code style                   |
| **Git Hooks**  | Lefthook 1.13.6                   | Pre-commit checks            |

## Database Schema

### Core Tables

#### Societies

```sql
CREATE TABLE societies (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    logo_url TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);
```

**Purpose:** Top-level organization for golf societies

**Security:** Row Level Security (RLS) ensures members only see their societies

#### Members

```sql
CREATE TABLE members (
    id UUID PRIMARY KEY,
    society_id UUID REFERENCES societies(id),
    user_id UUID REFERENCES auth.users(id),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    handicap INTEGER CHECK (handicap >= 0 AND handicap <= 54),
    role TEXT CHECK (role IN ('CAPTAIN', 'MEMBER')),
    status TEXT CHECK (status IN ('ACTIVE', 'INACTIVE', 'PENDING')),
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
);
```

**Purpose:** Links users to societies with roles and golf handicaps

**Security:**

- Captains can manage members
- Members can update their own profile
- All queries scoped to user's societies

### Future Tables

- **courses** - Golf courses with hole details
- **rounds** - Competition rounds
- **scores** - Player scores for rounds
- **groups** - Player pairings
- **tournaments** - Multi-round tournaments
- **seasons** - Annual competitions
- **spot_prizes** - Special prizes (longest drive, nearest pin)

## Offline Sync Strategy

### Sync Engine Architecture

```bash
User Action → Local DB (immediate)
                  ↓
            Queue for Sync
                  ↓
         [Sync Engine]
                  ↓
    Online? → Yes → Sync to Supabase
        ↓              ↓
       No          Success → Mark synced
        ↓              ↓
    Retry Later    Failure → Retry with backoff
```

### Conflict Resolution

**Strategy:** Last-write-wins

When conflicts occur:

1. Compare `updated_at` timestamps
2. Keep the most recent change
3. Log conflict for manual review if needed

### Sync Queue

**Table:** `sync_queue` (local only)

```dart
class SyncQueueItem {
  String id;
  String table;
  String action; // CREATE, UPDATE, DELETE
  String recordId;
  Map<String, dynamic> data;
  DateTime createdAt;
  int retryCount;
}
```

**Process:**

1. Actions queued locally
2. Sync engine processes queue in order
3. Failed actions retry with exponential backoff
4. Successful syncs remove from queue

## Security Model

### Row Level Security (RLS)

All tables use PostgreSQL RLS to enforce data access:

#### **Example: Societies Table**

```sql
-- Members can view societies they belong to
CREATE POLICY "View societies you are a member of"
    ON societies FOR SELECT
    USING (
        id IN (
            SELECT society_id FROM members
            WHERE user_id = auth.uid() AND status = 'ACTIVE'
        )
    );

-- Only captains can update societies
CREATE POLICY "Captains can update their society"
    ON societies FOR UPDATE
    USING (
        id IN (
            SELECT society_id FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
        )
    );
```

### Authentication

**Provider:** Supabase Auth

**Status:** ✅ Fully Implemented (62 tests passing)

**Flow:**

1. User signs in (email/password)
2. Supabase returns JWT token
3. Token stored by Supabase client (SharedPreferences)
4. Token sent with all API requests
5. RLS policies enforce permissions

**Session Management:**

- Tokens auto-refresh before expiration
- AuthBloc listens to auth state changes
- AuthGate routes based on authentication status
- Session validation on app start

**Implementation Details:**

See [Authentication Feature Documentation](../features/authentication.md) for complete details on:

- Domain entities (AuthUser, AuthSession)
- Use cases (SignIn, SignUp, SignOut, GetCurrentUser)
- BLoC state management (5 events, 5 states)
- UI screens (Welcome, SignIn, SignUp, ForgotPassword, VerifyEmail)
- Error handling (7 custom exceptions)
- Testing (51 auth tests + 11 widget tests)

## State Management

### BLoC Pattern

**Why BLoC?**

- ✅ Predictable state changes
- ✅ Easy to test
- ✅ Separates business logic from UI
- ✅ Works well with streams

**Structure:**

```dart
// Events - User actions
abstract class ScoreEvent {}
class LoadScore extends ScoreEvent {
  final String scoreId;
}

// States - UI states
abstract class ScoreState {}
class ScoreInitial extends ScoreState {}
class ScoreLoading extends ScoreState {}
class ScoreLoaded extends ScoreState {
  final Score score;
}
class ScoreError extends ScoreState {
  final String message;
}

// BLoC - Business logic
class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  final GetScoreUseCase getScore;

  ScoreBloc(this.getScore) : super(ScoreInitial()) {
    on<LoadScore>(_onLoadScore);
  }

  Future<void> _onLoadScore(LoadScore event, Emitter emit) async {
    emit(ScoreLoading());
    try {
      final score = await getScore(event.scoreId);
      emit(ScoreLoaded(score));
    } catch (e) {
      emit(ScoreError(e.toString()));
    }
  }
}
```

## Performance Considerations

### Database Optimization

**Indexes:**

- All foreign keys indexed
- Frequently queried fields indexed
- Composite indexes for common joins

**Query Optimization:**

- Select only needed fields
- Use pagination for large datasets
- Implement cursor-based pagination

### UI Performance

**Best Practices:**

- Const constructors where possible
- ListView.builder for long lists
- cached_network_image for photos
- Lazy loading for images

### Network Efficiency

**Strategies:**

- Batch API calls when possible
- Compress images before upload
- Use Supabase Realtime for live updates
- Cache responses locally

## Error Handling

### Error Types

```dart
// Domain layer errors
class DomainException implements Exception {
  final String message;
  DomainException(this.message);
}

class ValidationException extends DomainException {}
class NotFoundException extends DomainException {}
class UnauthorizedException extends DomainException {}

// Data layer errors
class DataException implements Exception {
  final String message;
  DataException(this.message);
}

class NetworkException extends DataException {}
class DatabaseException extends DataException {}
class SyncException extends DataException {}
```

### Error Handling Flow

```dart
// Repository catches low-level errors
try {
  final result = await supabase.from('scores').select();
} on PostgrestException catch (e) {
  throw DatabaseException(e.message);
} on SocketException {
  throw NetworkException('No internet');
}

// Use case handles business errors
try {
  await repository.submitScore(score);
} on ValidationException {
  // Re-throw for UI
  rethrow;
} on NetworkException {
  // Handle offline gracefully
  // Score already saved locally
}

// BLoC presents errors to UI
try {
  await submitScore(scoreId);
  emit(ScoreSubmitted());
} on ValidationException catch (e) {
  emit(ScoreError(e.message));
} on NetworkException {
  emit(ScoreError('Saved locally, will sync later'));
}
```

## Directory Structure

```bash
mulligans-law/
├── lib/
│   ├── core/                    # Shared code
│   │   ├── config/             # App configuration
│   │   ├── constants/          # App constants
│   │   ├── errors/             # Error classes
│   │   ├── usecases/           # Base use case
│   │   └── utils/              # Helper functions
│   │
│   ├── features/               # Feature modules
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── scores/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   └── [other features]/
│   │
│   └── main.dart               # App entry point
│
├── test/                        # Tests mirror lib/
│   ├── core/
│   ├── features/
│   ├── helpers/                # Test utilities
│   └── fixtures/               # Test data
│
├── supabase/                    # Database migrations
│   ├── migrations/
│   └── seed.sql
│
└── docs-technical/              # Docusaurus docs
    └── docs/
```

## Next Steps

Now that you understand the architecture, explore:

- [Development Workflow](../workflow/development.md) - How to build features
- [Testing Strategy](../testing/strategy.md) - TDD approach and testing patterns

## Related Documentation

- [Technical Specification](https://github.com/barry47products/mulligans-law/blob/main/docs/technical-spec.md)
- [Functional Specification](https://github.com/barry47products/mulligans-law/blob/main/docs/functional-spec.md)
- [CLAUDE.md](https://github.com/barry47products/mulligans-law/blob/main/CLAUDE.md) - Development guidelines
