# Claude Code Instructions - Mulligans Law

## Project Context

You are assisting in building a Flutter mobile application called Mulligans Law for managing golf scores and leaderboards for social golf societies. This document provides guidelines for how to approach development tasks.

## Core Principles

### 1. Test-Driven Development (TDD)

#### CRITICAL: TDD is mandatory for all features

**Red-Green-Refactor Cycle:**

1. **Red**: Write a failing test first
2. **Green**: Write minimal code to make it pass
3. **Refactor**: Improve code quality while keeping tests green

**Before writing any production code:**

```dart
// 1. Write the test FIRST
test('should calculate net score correctly', () {
  // Arrange
  final calculator = ScoreCalculator();

  // Act
  final result = calculator.calculateNet(grossScore: 5, handicapStrokes: 1);

  // Assert
  expect(result, equals(4));
});

// 2. THEN write the implementation
class ScoreCalculator {
  int calculateNet({required int grossScore, required int handicapStrokes}) {
    return grossScore - handicapStrokes;
  }
}
```

**Test Coverage:**

- Unit tests: 70% of test effort
- Widget tests: 20% of test effort
- Integration tests: 10% of test effort

**What to test:**

- Business logic (use cases, calculators, validators)
- State management (BLoCs, Cubits)
- Widgets with user interaction
- Repository implementations
- Data transformations

**What NOT to test:**

- Third-party libraries (trust they work)
- Simple getters/setters
- Data classes with no logic
- UI layouts (unless interactive)

### 2. Minimal Mocking

**Do Mock:**

- External dependencies (Supabase client, local database)
- Repositories in use case tests
- Complex services

```dart
// Good: Mock repository
class MockScoreRepository extends Mock implements ScoreRepository {}

void main() {
  late SubmitScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = SubmitScoreUseCase(mockRepository);
  });

  test('should submit score', () async {
    // Use mock
    when(mockRepository.getScore(any)).thenAnswer((_) async => testScore);
    await useCase('score-id');
    verify(mockRepository.getScore('score-id')).called(1);
  });
}
```

**Don't Mock:**

- Domain entities
- Value objects
- Simple data classes
- DTOs

```dart
// Bad: Don't do this
class MockScore extends Mock implements Score {}

// Good: Use real objects
final score = Score(
  id: '1',
  roundId: 'round1',
  playerId: 'player1',
  holeScores: [4, 3, 5, 4, 4, 3, 5, 4, 4, 5, 4, 3, 4, 5, 4, 4, 3, 5],
);
```

### 3. Clean Architecture

**Layer Structure:**

```bash
Presentation → Domain → Data
     ↓           ↓        ↓
  Widgets    Entities  Models
   BLoCs     UseCases  Repos
```

**Dependency Rule:** Dependencies point inward

- Presentation depends on Domain
- Data depends on Domain
- Domain depends on nothing

**File Organization:**

```bash
lib/features/scores/
  ├── data/
  │   ├── models/score_model.dart
  │   └── repositories/score_repository_impl.dart
  ├── domain/
  │   ├── entities/score.dart
  │   ├── repositories/score_repository.dart
  │   └── usecases/submit_score.dart
  └── presentation/
      ├── bloc/score_capture_bloc.dart
      ├── screens/score_capture_screen.dart
      └── widgets/score_card.dart
```

### 4. Offline-First Architecture

**Write Path:**

```bash
1. Write to local database (Drift)
2. Update UI immediately (optimistic)
3. Queue for sync
4. Sync to Supabase when online
```

**Read Path:**

```bash
1. Read from local database (fast)
2. Display to user
3. Fetch from Supabase in background
4. Update local database
5. UI updates via stream
```

**Implementation Pattern:**

```dart
Future<Score> createScore(Score score) async {
  // 1. Write local first
  final localScore = await localDb.scores.insert(score.toLocal());

  // 2. Queue for sync
  await syncEngine.queue(SyncAction.create('scores', score));

  // 3. Trigger sync (non-blocking)
  unawaited(syncEngine.sync());

  // 4. Return immediately
  return score;
}
```

### 5. Code Quality Standards

**Naming Conventions:**

- Classes: `PascalCase`
- Methods/variables: `camelCase`
- Constants: `lowerCamelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- Files: `snake_case.dart`

**No Magic Strings or Numbers:**
**CRITICAL: All literal values must be defined as named constants.**

```dart
// ❌ BAD: Magic numbers and strings
class ScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Hole 1',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}

// ✅ GOOD: Named constants
class ScoreCard extends StatelessWidget {
  static const double _cardPadding = 16.0;
  static const double _titleFontSize = 24.0;
  static const String _holePrefix = 'Hole';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_cardPadding),
      child: Text(
        '$_holePrefix 1',
        style: TextStyle(fontSize: _titleFontSize),
      ),
    );
  }
}

// ✅ BETTER: App-wide constants
// lib/core/constants/ui_constants.dart
class UiConstants {
  static const double cardPadding = 16.0;
  static const double titleFontSize = 24.0;
}

// lib/core/constants/app_strings.dart
class AppStrings {
  static const String holePrefix = 'Hole';
  static const String parLabel = 'Par';
  static const String submitButton = 'Submit Score';
}

// Usage
Container(
  padding: EdgeInsets.all(UiConstants.cardPadding),
  child: Text(
    '${AppStrings.holePrefix} 1',
    style: TextStyle(fontSize: UiConstants.titleFontSize),
  ),
)
```

**Business Logic Constants:**

```dart
// ❌ BAD: Magic numbers in calculations
int calculateStableford(int netScore, int par) {
  if (netScore >= par + 2) return 0;
  if (netScore == par + 1) return 1;
  if (netScore == par) return 2;
  // ...
}

// ✅ GOOD: Named constants
// lib/core/constants/scoring_constants.dart
class ScoringConstants {
  static const int doubleBogeyOrWorse = 0;
  static const int bogeyPoints = 1;
  static const int parPoints = 2;
  static const int birdiePoints = 3;
  static const int eaglePoints = 4;
  static const int albatrossPoints = 5;

  static const int holesPerRound = 18;
  static const int minHandicap = 0;
  static const int maxHandicap = 54;
}

int calculateStableford(int netScore, int par) {
  final scoreToPar = netScore - par;

  if (scoreToPar >= 2) return ScoringConstants.doubleBogeyOrWorse;
  if (scoreToPar == 1) return ScoringConstants.bogeyPoints;
  if (scoreToPar == 0) return ScoringConstants.parPoints;
  if (scoreToPar == -1) return ScoringConstants.birdiePoints;
  if (scoreToPar == -2) return ScoringConstants.eaglePoints;
  return ScoringConstants.albatrossPoints;
}
```

**Configuration Values:**

```dart
// ❌ BAD: Hardcoded URLs and keys
final supabase = Supabase.initialize(
  url: 'http://localhost:54321',
  anonKey: 'eyJhbGc...',
);

// ✅ GOOD: Configuration class
// lib/core/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://localhost:54321',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-local-dev-key',
  );
}

// Usage
final supabase = Supabase.initialize(
  url: SupabaseConfig.supabaseUrl,
  anonKey: SupabaseConfig.supabaseAnonKey,
);
```

**Time/Duration Constants:**

```dart
// ❌ BAD
await Future.delayed(Duration(milliseconds: 500));
if (elapsed > 3600) { /* ... */ }

// ✅ GOOD
// lib/core/constants/time_constants.dart
class TimeConstants {
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration syncInterval = Duration(seconds: 30);
  static const int secondsPerHour = 3600;
  static const int millisecondsPerSecond = 1000;
}

await Future.delayed(TimeConstants.debounceDelay);
if (elapsed > TimeConstants.secondsPerHour) { /* ... */ }
```

**API/Database Constants:**

```dart
// ❌ BAD
await supabase.from('scores').select();
if (status == 'APPROVED') { /* ... */ }

// ✅ GOOD
// lib/core/constants/database_constants.dart
class DatabaseTables {
  static const String scores = 'scores';
  static const String rounds = 'rounds';
  static const String members = 'members';
}

class ScoreStatus {
  static const String inProgress = 'IN_PROGRESS';
  static const String submitted = 'SUBMITTED';
  static const String approved = 'APPROVED';
  static const String disputed = 'DISPUTED';
}

// Usage
await supabase.from(DatabaseTables.scores).select();
if (status == ScoreStatus.approved) { /* ... */ }
```

**Acceptable Exceptions:**

- Loop indices: `for (int i = 0; i < list.length; i++)`
- Mathematical constants: `const pi = 3.14159265359;` (but use `dart:math` instead)
- Boolean literals: `true`, `false`
- Null: `null`
- Empty collections: `[]`, `{}`
- Small offsets in calculations: `index + 1`, `count - 1` (when contextually obvious)

**File Length:**

- Maximum 300 lines per file
- Split large files into smaller, focused files
- Use `part` only when necessary

**Function Length:**

- Maximum 50 lines per function
- Extract complex logic to helper functions
- One level of abstraction per function

**Null Safety:**

- Use null safety properly
- Avoid `!` (bang operator) when possible
- Use `?.` and `??` appropriately

```dart
// Good
final name = user?.name ?? 'Unknown';

// Bad
final name = user!.name; // Can crash
```

## Development Workflow

### Git and Commit Workflow

**Branch Strategy:**

```bash
# Always work on feature branches
git checkout main
git pull origin main
git checkout -b feat/task-name

# Work in small commits (TDD cycles)
# Push frequently
# Create PR when task complete
# Squash merge to main
```

**Commit Guidelines:**

Use **Conventional Commits** format:

```bash
<type>(<scope>): <subject>

[optional body]
```

**Commit Types:**

- `feat`: New feature
- `fix`: Bug fix
- `test`: Add/update tests
- `refactor`: Code restructuring (no behavior change)
- `docs`: Documentation only
- `style`: Formatting, whitespace
- `perf`: Performance improvement
- `chore`: Dependencies, build, tooling
- `ci`: CI/CD changes

**Examples:**

```bash
# TDD cycle commits
git commit -m "test: add failing test for net score calculation"
git commit -m "feat(scores): implement net score calculation"
git commit -m "refactor(scores): extract calculation to helper method"

# Bug fixes
git commit -m "fix(sync): prevent duplicate score submissions"

# Other changes
git commit -m "docs: update API documentation for ScoreRepository"
git commit -m "chore: upgrade supabase_flutter to 2.1.0"
```

**Commit Frequency:**

- Commit after each passing test (TDD green phase)
- Multiple commits per hour during active development
- Each commit should leave tests passing
- Push to remote frequently (at least daily, ideally more)

**Branch Lifecycle:**

```bash
# 1. Start task from TASKS.md
git checkout -b feat/score-capture-ui

# 2. Work in TDD cycle with frequent commits
git commit -m "test: ..."
git commit -m "feat: ..."

# 3. Push regularly
git push origin feat/score-capture-ui

# 4. Create PR when task complete
# - CI runs automatically
# - Self-review code
# - Squash and merge to main

# 5. Delete branch after merge
git branch -d feat/score-capture-ui
```

**What Gets Committed:**

- Source code changes
- Test files
- Documentation updates
- Configuration changes

**What Doesn't Get Committed:**

- Generated files (\*.g.dart, \*.freezed.dart)
- Build outputs (build/, .dart_tool/)
- IDE files (.vscode/, .idea/)
- Environment files (.env, secrets)
- Coverage reports (coverage/)

**Pull Request Process:**

1. Complete entire task from TASKS.md (no partial PRs)
2. Ensure all tests pass locally
3. Create PR with descriptive title
4. Fill out PR template
5. Wait for CI to pass (green checks)
6. Self-review code changes
7. Squash and merge to main
8. Delete feature branch

### Starting a New Feature

1. **Read Requirements**

   - Review functional spec
   - Review technical spec
   - Understand acceptance criteria

2. **Design Tests First (TDD)**

   - Write test file before implementation
   - Define test cases covering happy path and edge cases
   - Run tests (should fail - Red phase)

3. **Implement Minimal Code**

   - Write just enough code to pass tests (Green phase)
   - No over-engineering

4. **Refactor**

   - Improve code quality
   - Extract duplicated code
   - Ensure tests still pass

5. **Integration**

   - Wire up to UI
   - Test manually on device
   - Verify offline functionality

6. **Create Pull Request**
   - Push feature branch
   - Create PR
   - Wait for CI
   - Review and merge

### Documentation Requirements

**When to Update Docusaurus:**

1. **New Feature Added**

   - Create/update feature page in `docs-technical/docs/features/`
   - Add code examples
   - Include screenshots if UI feature
   - Update navigation in `docusaurus.config.js` if new page

2. **API Changes**

   - Update API reference in `docs-technical/docs/api/`
   - Document new repository methods
   - Document new use cases
   - Document new BLoC events/states

3. **Architecture Changes**

   - Update architecture documentation
   - Update diagrams if structure changed
   - Explain rationale for changes

4. **Setup/Configuration Changes**
   - Update getting started guide
   - Update installation instructions
   - Update troubleshooting section

**Documentation Workflow:**

```bash
# After implementing feature
cd docs-technical
npm start  # Preview docs locally

# Create/update relevant .md files
# Build to verify no errors
npm run build

# Commit documentation with feature
git add docs-technical/
git commit -m "docs(features): add score capture documentation"
```

**What NOT to document:**

- Implementation details that change frequently
- Temporary workarounds
- Internal helper functions
- Obvious code (let code be self-documenting)

### Code Review Checklist

Before marking any task as complete:

- [ ] All tests pass (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] TDD approach followed (tests written first)
- [ ] Minimal mocking (only external dependencies)
- [ ] Clean architecture respected (proper layering)
- [ ] Offline-first pattern implemented where needed
- [ ] Error handling implemented
- [ ] **Documentation updated in Docusaurus (if applicable)**
- [ ] README.md updated (if setup changes)
- [ ] Code comments for complex logic
- [ ] Tested on actual device (not just simulator)

## Common Patterns

### 1. Creating a Repository

```dart
// 1. Define interface in domain layer
abstract class ScoreRepository {
  Future<Score> getScore(String id);
  Future<List<Score>> getScoresByRound(String roundId);
  Future<Score> createScore(Score score);
  Stream<List<Score>> watchRoundScores(String roundId);
}

// 2. Write tests for implementation
void main() {
  late ScoreRepositoryImpl repository;
  late MockSupabaseClient mockSupabase;
  late MockLocalDatabase mockLocalDb;
  late MockSyncEngine mockSyncEngine;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockLocalDb = MockLocalDatabase();
    mockSyncEngine = MockSyncEngine();
    repository = ScoreRepositoryImpl(
      supabase: mockSupabase,
      localDb: mockLocalDb,
      syncEngine: mockSyncEngine,
    );
  });

  test('should create score locally and queue for sync', () async {
    // Arrange
    final score = Score(id: '1', roundId: 'round1', playerId: 'player1');
    when(mockLocalDb.scores.insert(any)).thenAnswer((_) async => 1);

    // Act
    await repository.createScore(score);

    // Assert
    verify(mockLocalDb.scores.insert(any)).called(1);
    verify(mockSyncEngine.queue(any)).called(1);
  });
}

// 3. Implement (make tests pass)
class ScoreRepositoryImpl implements ScoreRepository {
  final SupabaseClient supabase;
  final LocalDatabase localDb;
  final SyncEngine syncEngine;

  // ...implementation
}
```

### 2. Creating a Use Case

```dart
// 1. Write test first
void main() {
  late SubmitScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = SubmitScoreUseCase(mockRepository);
  });

  test('should submit complete score', () async {
    // Arrange
    final score = Score(
      id: '1',
      holeScores: List.filled(18, 4),
      status: ScoreStatus.inProgress,
    );
    when(mockRepository.getScore('1')).thenAnswer((_) async => score);
    when(mockRepository.updateScore(any)).thenAnswer((_) async => score);

    // Act
    await useCase('1');

    // Assert
    verify(mockRepository.updateScore(
      argThat(predicate<Score>((s) => s.status == ScoreStatus.submitted))
    )).called(1);
  });

  test('should throw for incomplete score', () {
    // Arrange
    final score = Score(id: '1', holeScores: [4, 3], status: ScoreStatus.inProgress);
    when(mockRepository.getScore('1')).thenAnswer((_) async => score);

    // Act & Assert
    expect(() => useCase('1'), throwsA(isA<IncompleteScoreException>()));
  });
}

// 2. Implement
class SubmitScoreUseCase {
  final ScoreRepository repository;

  SubmitScoreUseCase(this.repository);

  Future<void> call(String scoreId) async {
    final score = await repository.getScore(scoreId);

    if (score.holeScores.length != 18) {
      throw IncompleteScoreException('All 18 holes required');
    }

    final updated = score.copyWith(
      status: ScoreStatus.submitted,
      submittedAt: DateTime.now(),
    );

    await repository.updateScore(updated);
  }
}
```

### 3. Creating a BLoC

```dart
// 1. Define events and states
abstract class ScoreCaptureEvent {}
class LoadRound extends ScoreCaptureEvent {
  final String roundId;
  LoadRound(this.roundId);
}
class UpdateHoleScore extends ScoreCaptureEvent {
  final int hole;
  final int score;
  UpdateHoleScore(this.hole, this.score);
}

abstract class ScoreCaptureState {}
class ScoreCaptureLoading extends ScoreCaptureState {}
class ScoreCaptureLoaded extends ScoreCaptureState {
  final Round round;
  final Score score;
  final int currentHole;
  ScoreCaptureLoaded(this.round, this.score, this.currentHole);
}

// 2. Write BLoC tests
void main() {
  late ScoreCaptureBloc bloc;
  late MockGetRoundUseCase mockGetRound;

  setUp(() {
    mockGetRound = MockGetRoundUseCase();
    bloc = ScoreCaptureBloc(getRound: mockGetRound);
  });

  blocTest<ScoreCaptureBloc, ScoreCaptureState>(
    'emits loaded state when LoadRound succeeds',
    build: () {
      when(mockGetRound(any)).thenAnswer((_) async => testRound);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadRound('round1')),
    expect: () => [
      ScoreCaptureLoading(),
      isA<ScoreCaptureLoaded>(),
    ],
  );
}

// 3. Implement BLoC
class ScoreCaptureBloc extends Bloc<ScoreCaptureEvent, ScoreCaptureState> {
  final GetRoundUseCase getRound;

  ScoreCaptureBloc({required this.getRound}) : super(ScoreCaptureInitial()) {
    on<LoadRound>(_onLoadRound);
    on<UpdateHoleScore>(_onUpdateHoleScore);
  }

  Future<void> _onLoadRound(
    LoadRound event,
    Emitter<ScoreCaptureState> emit,
  ) async {
    emit(ScoreCaptureLoading());
    try {
      final round = await getRound(event.roundId);
      emit(ScoreCaptureLoaded(round, Score.empty(), 0));
    } catch (e) {
      emit(ScoreCaptureError(e.toString()));
    }
  }
}
```

### 4. Creating a Widget

```dart
// 1. Write widget test
void main() {
  testWidgets('ScoreCard displays hole information', (tester) async {
    // Arrange & Act
    await tester.pumpWidget(
      MaterialApp(
        home: ScoreCard(
          hole: 1,
          par: 4,
          score: 5,
          onScoreChanged: (_) {},
        ),
      ),
    );

    // Assert
    expect(find.text('Hole 1'), findsOneWidget);
    expect(find.text('Par 4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('ScoreCard calls onScoreChanged when tapped', (tester) async {
    // Arrange
    int? capturedScore;
    await tester.pumpWidget(
      MaterialApp(
        home: ScoreCard(
          hole: 1,
          par: 4,
          score: 0,
          onScoreChanged: (s) => capturedScore = s,
        ),
      ),
    );

    // Act
    await tester.tap(find.text('4'));
    await tester.pump();

    // Assert
    expect(capturedScore, 4);
  });
}

// 2. Implement widget
class ScoreCard extends StatelessWidget {
  final int hole;
  final int par;
  final int score;
  final ValueChanged<int> onScoreChanged;

  const ScoreCard({
    required this.hole,
    required this.par,
    required this.score,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text('Hole $hole'),
          Text('Par $par'),
          Text('$score'),
          _buildScoreButtons(),
        ],
      ),
    );
  }

  Widget _buildScoreButtons() {
    return Row(
      children: List.generate(8, (i) {
        final score = i + 1;
        return TextButton(
          onPressed: () => onScoreChanged(score),
          child: Text('$score'),
        );
      }),
    );
  }
}
```

## Database Migrations

When creating new tables or modifying schema:

```bash
# 1. Create migration file
supabase migration new add_spot_prizes

# 2. Write SQL in generated file
# supabase/migrations/YYYYMMDDHHMMSS_add_spot_prizes.sql
CREATE TABLE spot_prizes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  prize_type TEXT NOT NULL,
  -- ...
);

# 3. Enable RLS
ALTER TABLE spot_prizes ENABLE ROW LEVEL SECURITY;

# 4. Create policies
CREATE POLICY "Members view society prizes"
  ON spot_prizes FOR SELECT
  USING (
    round_id IN (
      SELECT r.id FROM rounds r
      JOIN members m ON m.society_id = r.society_id
      WHERE m.user_id = auth.uid()
    )
  );

# 5. Apply migration
supabase db reset
```

## Error Handling

Always handle errors gracefully:

```dart
// In repositories
try {
  final result = await supabase.from('scores').insert(data);
  return Score.fromJson(result);
} on PostgrestException catch (e) {
  if (e.code == '23505') {
    throw DuplicateScoreException('Score already exists');
  }
  throw DatabaseException(e.message);
} on SocketException {
  throw NetworkException('No internet connection');
} catch (e) {
  throw UnknownException('An unexpected error occurred');
}

// In BLoCs
try {
  final score = await submitScore(scoreId);
  emit(ScoreSubmitted(score));
} on IncompleteScoreException catch (e) {
  emit(ScoreError(e.message));
} on NetworkException {
  emit(ScoreError('No internet connection. Score saved locally.'));
} catch (e) {
  emit(ScoreError('Failed to submit score. Please try again.'));
}
```

## Performance Considerations

**Efficient Queries:**

```dart
// Good: Select only needed fields
final scores = await supabase
  .from('scores')
  .select('id, total_stableford, player_id')
  .eq('round_id', roundId);

// Bad: Select everything
final scores = await supabase
  .from('scores')
  .select('*')
  .eq('round_id', roundId);
```

**Pagination:**

```dart
final scores = await supabase
  .from('scores')
  .select()
  .range(0, 19) // First 20 results
  .order('created_at', ascending: false);
```

**Debouncing:**

```dart
Timer? _debounce;

void onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 500), () {
    performSearch(query);
  });
}
```

## What to Avoid

### Anti-Patterns

**❌ Don't skip tests:**

```dart
// Bad: Writing production code first
class ScoreCalculator {
  int calculate() => 42; // No tests!
}
```

**❌ Don't over-mock:**

```dart
// Bad: Mocking simple data classes
class MockScore extends Mock implements Score {}
final mockScore = MockScore();
when(mockScore.id).thenReturn('1'); // Unnecessary!

// Good: Use real objects
final score = Score(id: '1', ...);
```

**❌ Don't bypass layers:**

```dart
// Bad: Widget calling Supabase directly
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client; // ❌
    // ...
  }
}

// Good: Widget uses BLoC, BLoC uses Use Case, Use Case uses Repository
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBloc, MyState>(...); // ✓
  }
}
```

**❌ Don't use print() for debugging:**

```dart
// Bad
print('Score: $score'); // Not in production code

// Good
debugPrint('Score: $score'); // OK in debug builds
log('Score: $score', name: 'ScoreCapture'); // Better
```

**❌ Don't ignore errors:**

```dart
// Bad
try {
  await submitScore();
} catch (e) {
  // Silent failure
}

// Good
try {
  await submitScore();
} catch (e) {
  log('Failed to submit score', error: e);
  rethrow; // Or handle appropriately
}
```

## Task Completion Checklist

Before closing any task:

- [ ] Tests written BEFORE implementation (TDD)
- [ ] All tests pass (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Minimal mocking (only external dependencies)
- [ ] Clean architecture respected
- [ ] Error handling implemented
- [ ] Offline functionality works (if applicable)
- [ ] Tested on physical device
- [ ] No console warnings
- [ ] Code documented (public APIs)
- [ ] Performance acceptable

## Getting Help

When stuck:

1. Check functional spec for requirements
2. Check technical spec for architecture patterns
3. Review similar existing code in the project
4. Ask for clarification on ambiguous requirements

## Remember

- **TDD is mandatory** - Write tests first, always
- **Mock minimally** - Only mock external dependencies
- **Offline first** - Local database first, sync later
- **Clean architecture** - Respect layer boundaries
- **Quality over speed** - Better to do it right than fast

The goal is to build a maintainable, testable, high-quality codebase that can evolve over time.
