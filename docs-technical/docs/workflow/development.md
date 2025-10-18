# Development Workflow

This guide explains the step-by-step process for developing new features in Mulligans Law, following Test-Driven Development (TDD) and Clean Architecture principles.

## Overview

Every feature follows the same pattern:
1. **Plan** - Review requirements and design tests
2. **Red** - Write failing tests
3. **Green** - Implement minimal code to pass tests
4. **Refactor** - Improve code quality
5. **Integrate** - Wire up to UI and test end-to-end
6. **Deploy** - Merge to main (triggers CI/CD)

## Git Workflow

### Trunk-Based Development

We use **trunk-based development** with short-lived feature branches:

```bash
main (always deployable)
  ├── feat/score-capture (1-2 days)
  ├── fix/handicap-validation (few hours)
  └── refactor/leaderboard-calc (1 day)
```

**Rules:**
- `main` branch is always stable and deployable
- Feature branches live 1-3 days maximum
- Merge to `main` frequently (daily if possible)
- No long-lived branches

### Starting a New Task

#### 1. Pull Latest Changes

```bash
git checkout main
git pull origin main
```

#### 2. Create Feature Branch

Branch naming convention:
- `feat/` - New feature
- `fix/` - Bug fix
- `refactor/` - Code improvement
- `test/` - Test additions
- `docs/` - Documentation

```bash
# Example: Building score capture UI
git checkout -b feat/score-capture-ui

# Example: Fixing handicap calculation
git checkout -b fix/handicap-calculation
```

### Working in TDD Cycles

#### Red-Green-Refactor

Each feature is built in small TDD cycles:

```bash
# 1. RED: Write failing test
# Edit: test/features/scores/domain/usecases/submit_score_test.dart
flutter test test/features/scores/domain/usecases/submit_score_test.dart
# ❌ Test fails (expected)

git add test/
git commit -m "test(scores): add failing test for submit score use case"

# 2. GREEN: Make it pass
# Edit: lib/features/scores/domain/usecases/submit_score.dart
flutter test test/features/scores/domain/usecases/submit_score_test.dart
# ✅ Test passes

git add lib/ test/
git commit -m "feat(scores): implement submit score use case"

# 3. REFACTOR: Improve code
# Edit: lib/features/scores/domain/usecases/submit_score.dart
flutter test
# ✅ All tests still pass

git add lib/
git commit -m "refactor(scores): extract validation logic to separate method"
```

**Commit Frequency:**
- Commit after each RED-GREEN-REFACTOR cycle
- Multiple commits per hour during active development
- Push to remote at least daily

### Conventional Commits

All commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <subject>

[optional body]
```

**Types:**
- `feat` - New feature (bumps minor version)
- `fix` - Bug fix (bumps patch version)
- `test` - Adding or updating tests
- `refactor` - Code refactoring
- `docs` - Documentation changes
- `style` - Code formatting
- `perf` - Performance improvements
- `ci` - CI/CD changes
- `chore` - Maintenance tasks

**Examples:**

```bash
✅ Good:
feat(scores): add stableford calculation
fix(sync): prevent duplicate score uploads
test(leaderboards): add order of merit calculation tests
refactor(auth): simplify login flow
docs(api): update repository documentation

❌ Bad:
Update code
Fix bug
WIP
changes
minor updates
```

**Breaking Changes:**

```bash
feat(api)!: redesign authentication flow

BREAKING CHANGE: Auth now requires OAuth tokens instead of API keys.
Users must re-authenticate after this update.
```

This bumps the major version (1.2.3 → 2.0.0).

### Creating Pull Requests

#### 1. Ensure Tests Pass

```bash
# Run all tests
flutter test

# Run code analysis
flutter analyze

# Check formatting
dart format --set-exit-if-changed .
```

#### 2. Push Feature Branch

```bash
git push origin feat/score-capture-ui
```

#### 3. Create Pull Request

```bash
# Using GitHub CLI
gh pr create --title "feat(scores): add score capture UI" --body "Implements score capture screen with hole-by-hole input"

# Or via GitHub web interface
```

The PR template will guide you through:
- Task reference from TASKS.md
- Description of changes
- Testing checklist
- Screenshots (for UI changes)

#### 4. Wait for CI

GitHub Actions will automatically:
- ✅ Run `dart format`
- ✅ Run `flutter analyze`
- ✅ Run all tests
- ✅ Build iOS and Android
- ✅ Upload coverage to Codecov

All checks must pass before merging.

#### 5. Merge to Main

- **Self-review** your changes
- **Squash and merge** (GitHub default)
- **Delete branch** after merge

**Result:** CD pipeline triggers, creating a new release if the commit warrants it.

## Feature Development Process

### Step 1: Plan the Feature

Before writing code, understand requirements:

1. Read the **functional spec** for the feature
2. Read the **technical spec** for architecture guidance
3. Check **TASKS.md** for the specific task
4. Identify **acceptance criteria**

**Example: Score Capture Feature**

**Functional requirement:**
- Players enter scores hole-by-hole
- App calculates gross, net, and stableford
- Scores save offline and sync later

**Technical approach:**
- Domain: Score entity, calculation use cases
- Data: Local database (Drift), Supabase repository
- Presentation: BLoC for state, swipeable scorecard UI

### Step 2: Write Domain Layer (TDD)

Start with the domain layer - pure business logic, no dependencies.

#### 2.1 Define Entity

```bash
# Create test file FIRST
touch test/features/scores/domain/entities/score_test.dart
```

```dart
// test/features/scores/domain/entities/score_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mulligans_law/features/scores/domain/entities/score.dart';

void main() {
  group('Score Entity', () {
    test('should calculate gross total correctly', () {
      // Arrange
      final holeScores = [4, 3, 5, 4, 4, 3, 5, 4, 4, 5, 4, 3, 4, 5, 4, 4, 3, 5];
      final score = Score(holeScores: holeScores);

      // Act
      final grossTotal = score.calculateGross();

      // Assert
      expect(grossTotal, 75);
    });
  });
}
```

```bash
# RED: Run test (fails - Score class doesn't exist)
flutter test test/features/scores/domain/entities/score_test.dart
```

```dart
// lib/features/scores/domain/entities/score.dart
class Score {
  final List<int> holeScores;

  Score({required this.holeScores});

  int calculateGross() {
    return holeScores.fold(0, (sum, score) => sum + score);
  }
}
```

```bash
# GREEN: Test passes
flutter test test/features/scores/domain/entities/score_test.dart
```

#### 2.2 Define Use Case

```dart
// test/features/scores/domain/usecases/submit_score_test.dart
void main() {
  late SubmitScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = SubmitScoreUseCase(mockRepository);
  });

  test('should submit complete score', () async {
    // Arrange
    final score = Score(holeScores: List.filled(18, 4));
    when(mockRepository.submitScore(score))
        .thenAnswer((_) async => score);

    // Act
    final result = await useCase(score);

    // Assert
    verify(mockRepository.submitScore(score)).called(1);
    expect(result, score);
  });
}
```

### Step 3: Write Data Layer (TDD)

Implement repositories that interact with external services.

#### 3.1 Create Model

```dart
// lib/features/scores/data/models/score_model.dart
class ScoreModel extends Score {
  ScoreModel({
    required String id,
    required List<int> holeScores,
  }) : super(holeScores: holeScores);

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      id: json['id'],
      holeScores: List<int>.from(json['hole_scores']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hole_scores': holeScores,
    };
  }
}
```

#### 3.2 Implement Repository

```dart
// lib/features/scores/data/repositories/score_repository_impl.dart
class ScoreRepositoryImpl implements ScoreRepository {
  final SupabaseClient supabase;
  final LocalDatabase localDb;
  final SyncEngine syncEngine;

  @override
  Future<Score> submitScore(Score score) async {
    // 1. Write to local database first (offline-first)
    await localDb.scores.insertScore(score);

    // 2. Queue for sync
    await syncEngine.queueSync('scores', score.id, SyncAction.update);

    // 3. Try to sync immediately (non-blocking)
    unawaited(syncEngine.sync());

    return score;
  }
}
```

### Step 4: Write Presentation Layer (TDD)

Build the UI with BLoC for state management.

#### 4.1 Define BLoC

```dart
// test/features/scores/presentation/bloc/score_capture_bloc_test.dart
void main() {
  late ScoreCaptureBloc bloc;
  late MockSubmitScoreUseCase mockSubmitScore;

  setUp(() {
    mockSubmitScore = MockSubmitScoreUseCase();
    bloc = ScoreCaptureBloc(submitScore: mockSubmitScore);
  });

  blocTest<ScoreCaptureBloc, ScoreCaptureState>(
    'emits [ScoreSubmitting, ScoreSubmitted] when SubmitScore succeeds',
    build: () {
      when(mockSubmitScore(any)).thenAnswer((_) async => testScore);
      return bloc;
    },
    act: (bloc) => bloc.add(SubmitScore(testScore)),
    expect: () => [
      ScoreSubmitting(),
      ScoreSubmitted(testScore),
    ],
  );
}
```

#### 4.2 Create Widget

```dart
// test/features/scores/presentation/screens/score_capture_screen_test.dart
void main() {
  testWidgets('displays scorecard', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ScoreCaptureScreen()),
    );

    expect(find.text('Hole 1'), findsOneWidget);
    expect(find.byType(ScoreCard), findsOneWidget);
  });
}
```

### Step 5: Integration

Wire everything together:

1. **Set up dependency injection** (when using get_it)
2. **Connect BLoC to UI**
3. **Test manually** on device/simulator
4. **Verify offline** functionality

```bash
# Test on iOS
flutter run -d ios

# Test on Android
flutter run -d android

# Test offline
# 1. Enable Airplane Mode
# 2. Perform actions
# 3. Verify data saved locally
# 4. Disable Airplane Mode
# 5. Verify data syncs to Supabase
```

### Step 6: Documentation

Update documentation if needed:

**When to update Docusaurus:**
- ✅ New API endpoint or repository method
- ✅ Architecture changes
- ✅ New testing patterns
- ❌ Minor bug fixes
- ❌ Internal refactoring

```bash
cd docs-technical
npm start  # Preview locally
# Edit relevant .md files
npm run build  # Verify builds
```

### Step 7: Code Review & Merge

1. **Self-review** your code
2. Create **pull request**
3. Wait for **CI to pass**
4. **Merge** to main
5. **Monitor CD** for deployment

## Common Workflows

### Adding a New Feature

```bash
# 1. Start from main
git checkout main && git pull

# 2. Create branch
git checkout -b feat/leaderboard-display

# 3. TDD cycle (repeat)
# Write test → Run (RED) → Implement → Run (GREEN) → Refactor
git commit -m "test(leaderboards): add test for order of merit calculation"
git commit -m "feat(leaderboards): implement order of merit calculation"

# 4. Push and create PR
git push origin feat/leaderboard-display
gh pr create

# 5. Wait for CI, then merge
gh pr merge --squash
```

### Fixing a Bug

```bash
# 1. Create fix branch
git checkout -b fix/handicap-calculation

# 2. Write failing test that reproduces bug
git commit -m "test(scores): add failing test for handicap edge case"

# 3. Fix the bug
git commit -m "fix(scores): handle edge case in handicap calculation"

# 4. PR and merge
git push origin fix/handicap-calculation
gh pr create --title "fix(scores): handle edge case in handicap calculation"
```

### Refactoring Code

```bash
# 1. Ensure tests exist
flutter test

# 2. Create branch
git checkout -b refactor/simplify-score-calc

# 3. Refactor while keeping tests green
# Make changes
flutter test  # ✅ Still passing

git commit -m "refactor(scores): extract calculation to helper method"

# 4. PR and merge
```

## Best Practices

### Code Quality

**Before Every Commit:**
```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

**Git hooks automatically enforce these!**

### Testing

**Test Coverage:**
- ✅ Write tests BEFORE implementation (TDD)
- ✅ Aim for 70% overall coverage
- ✅ Test business logic thoroughly
- ❌ Don't test third-party libraries

**What to Test:**
- ✅ Domain entities and use cases
- ✅ BLoC state transitions
- ✅ Repository implementations
- ✅ Widget interactions
- ❌ Simple getters/setters
- ❌ Data classes with no logic

### Commits

**Frequency:**
- Commit after each TDD cycle
- Multiple commits per feature
- Push at least daily

**Size:**
- Small, focused commits
- One logical change per commit
- Easy to review and revert if needed

**Messages:**
- Follow Conventional Commits
- Be descriptive
- Explain WHY, not just WHAT

### Pull Requests

**Size:**
- Complete one task from TASKS.md
- 200-400 lines changed ideal
- Max 800 lines (split larger features)

**Review:**
- Self-review before requesting review
- Check all CI checks pass
- Add screenshots for UI changes

## Troubleshooting

### Tests Failing Locally

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter test
```

### CI Failing but Passing Locally

```bash
# Ensure you're on latest main
git fetch origin
git rebase origin/main

# Check Flutter version matches CI
flutter --version  # Should be 3.35.6
```

### Merge Conflicts

```bash
# Rebase on main
git fetch origin
git rebase origin/main

# Resolve conflicts
# Edit files, then:
git add .
git rebase --continue
```

### Accidentally Committed to Main

```bash
# Create branch from current commit
git branch feat/my-feature

# Reset main to remote
git checkout main
git reset --hard origin/main

# Switch to feature branch
git checkout feat/my-feature
```

## Next Steps

- [Testing Strategy](../testing/strategy.md) - Learn the TDD approach
- [Architecture Overview](../architecture/overview.md) - Understand the structure
