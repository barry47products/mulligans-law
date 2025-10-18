# Testing Strategy

Mulligans Law uses Test-Driven Development (TDD) to ensure high code quality, maintainability, and confidence in changes. This guide covers our testing approach, patterns, and best practices.

## Overview

### Test-Driven Development (TDD)

**Philosophy:** Write tests BEFORE writing production code.

**Benefits:**

- ✅ Forces good design (testable code is well-designed code)
- ✅ Prevents regression bugs
- ✅ Serves as living documentation
- ✅ Increases confidence in changes
- ✅ Reduces debugging time

**Warning:** ❌ Writing code first and tests later is NOT TDD!

### The Red-Green-Refactor Cycle

Every feature is built in small TDD cycles:

```bash
🔴 RED → Write a failing test
         ↓
🟢 GREEN → Write minimal code to pass
          ↓
🔵 REFACTOR → Improve code quality while keeping tests green
             ↓
        (Repeat)
```

**Example Cycle (5-15 minutes each):**

```dart
// 🔴 RED: Write failing test
test('should calculate net score correctly', () {
  final calculator = ScoreCalculator();
  expect(calculator.calculateNet(gross: 5, handicap: 1), 4);
});
// Run: flutter test → ❌ Fails (ScoreCalculator doesn't exist)

// 🟢 GREEN: Make it pass (minimal code)
class ScoreCalculator {
  int calculateNet({required int gross, required int handicap}) {
    return gross - handicap;
  }
}
// Run: flutter test → ✅ Passes

// 🔵 REFACTOR: Improve (if needed)
class ScoreCalculator {
  int calculateNet({required int gross, required int handicap}) {
    if (gross < 0 || handicap < 0) {
      throw ArgumentError('Scores must be non-negative');
    }
    return gross - handicap;
  }
}
// Run: flutter test → ✅ Still passes
```

## Test Types

### Test Pyramid

Our testing strategy follows the test pyramid:

```bash
      /\
     /  \  10% Integration Tests (E2E)
    /____\
   /      \  20% Widget Tests (UI)
  /________\
 /          \
/____________\ 70% Unit Tests (Logic)
```

**Distribution:**

- **70% Unit Tests** - Fast, isolated, test business logic
- **20% Widget Tests** - Test UI components and interactions
- **10% Integration Tests** - Test complete user flows

### 1. Unit Tests

**Purpose:** Test individual functions, classes, and use cases in isolation.

**What to Test:**

- ✅ Domain entities and value objects
- ✅ Use cases (business logic)
- ✅ Calculators and validators
- ✅ Repository implementations
- ✅ Data transformations

**What NOT to Test:**

- ❌ Third-party libraries (trust they work)
- ❌ Simple getters/setters with no logic
- ❌ Data classes with no behavior
- ❌ Flutter framework code

#### **Example: Testing a Use Case**

```dart
// test/features/scores/domain/usecases/submit_score_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'submit_score_test.mocks.dart';

@GenerateMocks([ScoreRepository])
void main() {
  late SubmitScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = SubmitScoreUseCase(mockRepository);
  });

  group('SubmitScoreUseCase', () {
    final testScore = Score(
      id: 'score-1',
      roundId: 'round-1',
      holeScores: List.filled(18, 4),
    );

    test('should submit complete score successfully', () async {
      // Arrange
      when(mockRepository.submitScore(testScore))
          .thenAnswer((_) async => testScore);

      // Act
      final result = await useCase(testScore);

      // Assert
      expect(result, testScore);
      verify(mockRepository.submitScore(testScore)).called(1);
    });

    test('should throw IncompleteScoreException when score incomplete', () {
      // Arrange
      final incompleteScore = Score(
        id: 'score-1',
        roundId: 'round-1',
        holeScores: [4, 3, 5], // Only 3 holes!
      );

      // Act & Assert
      expect(
        () => useCase(incompleteScore),
        throwsA(isA<IncompleteScoreException>()),
      );
    });
  });
}
```

**Running Unit Tests:**

```bash
# All unit tests
flutter test

# Specific test file
flutter test test/features/scores/domain/usecases/submit_score_test.dart

# Tests matching pattern
flutter test --name "SubmitScore"

# With coverage
flutter test --coverage
```

### 2. Widget Tests

**Purpose:** Test UI components and user interactions.

**What to Test:**

- ✅ Widgets render correctly
- ✅ User interactions (taps, swipes, input)
- ✅ Widget responds to state changes
- ✅ Navigation flows
- ✅ Form validation

**What NOT to Test:**

- ❌ Static layouts without logic
- ❌ Third-party widgets
- ❌ Pixel-perfect rendering

#### **Example: Testing a Widget**

```dart
// test/features/scores/presentation/widgets/score_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScoreCard Widget', () {
    testWidgets('displays hole information correctly', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreCard(
              hole: 1,
              par: 4,
              strokeIndex: 10,
              score: 5,
              onScoreChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Hole 1'), findsOneWidget);
      expect(find.text('Par 4'), findsOneWidget);
      expect(find.text('SI 10'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('calls onScoreChanged when score button tapped', (tester) async {
      // Arrange
      int? capturedScore;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreCard(
              hole: 1,
              par: 4,
              strokeIndex: 10,
              score: 0,
              onScoreChanged: (score) => capturedScore = score,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('4'));
      await tester.pump();

      // Assert
      expect(capturedScore, 4);
    });

    testWidgets('highlights current score', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreCard(
              hole: 1,
              par: 4,
              strokeIndex: 10,
              score: 5,
              onScoreChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final scoreButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, '5'),
      );
      expect(scoreButton.style?.backgroundColor?.resolve({}), isNotNull);
    });
  });
}
```

**Running Widget Tests:**

```bash
# All widget tests
flutter test test/**/widgets/

# Specific widget
flutter test test/features/scores/presentation/widgets/score_card_test.dart
```

### 3. BLoC Tests

**Purpose:** Test state management logic using bloc_test package.

#### **Example: Testing a BLoC**

```dart
// test/features/scores/presentation/bloc/score_capture_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late ScoreCaptureBloc bloc;
  late MockGetRoundUseCase mockGetRound;
  late MockSubmitScoreUseCase mockSubmitScore;

  setUp(() {
    mockGetRound = MockGetRoundUseCase();
    mockSubmitScore = MockSubmitScoreUseCase();
    bloc = ScoreCaptureBloc(
      getRound: mockGetRound,
      submitScore: mockSubmitScore,
    );
  });

  group('LoadRound', () {
    final testRound = Round(
      id: 'round-1',
      course: testCourse,
      date: DateTime.now(),
    );

    blocTest<ScoreCaptureBloc, ScoreCaptureState>(
      'emits [Loading, Loaded] when LoadRound succeeds',
      build: () {
        when(mockGetRound('round-1'))
            .thenAnswer((_) async => testRound);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadRound('round-1')),
      expect: () => [
        ScoreCaptureLoading(),
        ScoreCaptureLoaded(round: testRound, currentHole: 0),
      ],
    );

    blocTest<ScoreCaptureBloc, ScoreCaptureState>(
      'emits [Loading, Error] when LoadRound fails',
      build: () {
        when(mockGetRound('round-1'))
            .thenThrow(RoundNotFoundException());
        return bloc;
      },
      act: (bloc) => bloc.add(LoadRound('round-1')),
      expect: () => [
        ScoreCaptureLoading(),
        ScoreCaptureError('Round not found'),
      ],
    );
  });
}
```

### 4. Integration Tests

**Purpose:** Test complete user flows end-to-end.

**When to Use:**

- Critical user journeys (login → create round → submit score)
- Cross-feature flows
- Smoke tests for major functionality

#### **Example: Integration Test**

```dart
// integration_test/score_capture_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Score Capture Flow', () {
    testWidgets('complete score capture journey', (tester) async {
      // Start app
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // 1. Login
      await tester.enterText(find.byKey(Key('email')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password')), 'password123');
      await tester.tap(find.byKey(Key('login-button')));
      await tester.pumpAndSettle();

      // 2. Navigate to rounds
      await tester.tap(find.text('Rounds'));
      await tester.pumpAndSettle();

      // 3. Select a round
      await tester.tap(find.text('Sunday Medal'));
      await tester.pumpAndSettle();

      // 4. Enter scores for 18 holes
      for (int hole = 1; hole <= 18; hole++) {
        await tester.tap(find.text('4')); // Par for each hole
        if (hole < 18) {
          await tester.drag(
            find.byType(PageView),
            Offset(-400, 0), // Swipe left
          );
          await tester.pumpAndSettle();
        }
      }

      // 5. Submit score
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // 6. Verify success
      expect(find.text('Score submitted!'), findsOneWidget);
    });
  });
}
```

**Running Integration Tests:**

```bash
# On device/emulator
flutter test integration_test/

# With specific device
flutter test integration_test/ -d <device-id>
```

## Mocking Strategy

### Minimal Mocking

**Rule:** Only mock external dependencies, use real objects for everything else.

**Do Mock:**

- ✅ External APIs (Supabase client)
- ✅ Local database (Drift)
- ✅ Repositories (in use case tests)
- ✅ Use cases (in BLoC tests)
- ✅ Complex services

**Don't Mock:**

- ❌ Domain entities
- ❌ Value objects
- ❌ Data classes
- ❌ Simple DTOs

#### **Example: Proper Mocking**

```dart
// ✅ GOOD: Mock repository (external dependency)
@GenerateMocks([ScoreRepository])
void main() {
  late MockScoreRepository mockRepository;
  late SubmitScoreUseCase useCase;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = SubmitScoreUseCase(mockRepository);
  });

  test('should submit score', () async {
    // Use real Score object
    final score = Score(
      id: 'score-1',
      roundId: 'round-1',
      holeScores: List.filled(18, 4),
    );

    when(mockRepository.submitScore(score))
        .thenAnswer((_) async => score);

    await useCase(score);

    verify(mockRepository.submitScore(score)).called(1);
  });
}
```

```dart
// ❌ BAD: Mock domain entity (unnecessary)
@GenerateMocks([Score])
void main() {
  test('should calculate total', () {
    final mockScore = MockScore();
    when(mockScore.calculateTotal()).thenReturn(72);

    // This is pointless - just use a real Score!
    final total = mockScore.calculateTotal();
    expect(total, 72);
  });
}
```

### Generating Mocks

Use `mockito` to generate mocks:

```dart
// Add annotation above test
@GenerateMocks([ScoreRepository, RoundRepository])
import 'my_test.mocks.dart';

void main() {
  // Mocks available: MockScoreRepository, MockRoundRepository
}
```

Generate mocks:

```bash
flutter pub run build_runner build
```

## Test Helpers

### Using Test Helpers

The project includes helper utilities in `test/helpers/`:

**test_helper.dart** - Widget testing utilities:

```dart
import 'package:test/helpers/test_helper.dart';

testWidgets('my widget test', (tester) async {
  // Helper to pump widget with MaterialApp
  await pumpTestWidget(tester, MyWidget());

  // Helper assertions
  verifyWidgetExists('Welcome');
  verifyWidgetNotExists('Error');
});
```

**mock_factories.dart** - Test data generators:

```dart
import 'package:test/helpers/mock_factories.dart';

test('my test', () {
  // Create test data easily
  final score = createTestScore(
    id: 'score-1',
    totalStableford: 36,
  );

  final member = createTestMember(
    handicap: 18,
    role: 'CAPTAIN',
  );
});
```

## Coverage

### Target Coverage

**Overall:** 70% minimum

**By Layer:**

- **Domain:** 90%+ (critical business logic)
- **Data:** 70%+ (repository implementations)
- **Presentation:** 60%+ (BLoCs and important widgets)

### Measuring Coverage

```bash
# Generate coverage
flutter test --coverage

# View coverage HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**CI Integration:**

- Coverage automatically uploaded to Codecov
- Coverage trends tracked over time
- PRs show coverage changes

### Coverage Exclusions

Files excluded from coverage:

```dart
// coverage:ignore-file - Entire file
// coverage:ignore-start / coverage:ignore-end - Block
// coverage:ignore-line - Single line
```

**Auto-excluded:**

- `**/*.g.dart` (generated files)
- `**/*.freezed.dart` (generated files)
- `main.dart` (app entry point)

## Best Practices

### Writing Good Tests

#### 1. Follow AAA Pattern

**Arrange-Act-Assert:**

```dart
test('should calculate stableford points correctly', () {
  // Arrange - Set up test data and dependencies
  final calculator = StablefordCalculator();
  final netScore = 4;
  final par = 4;

  // Act - Execute the code being tested
  final points = calculator.calculate(netScore: netScore, par: par);

  // Assert - Verify the result
  expect(points, 2);
});
```

#### 2. Test One Thing

**Each test should verify one behavior:**

```dart
// ✅ GOOD: Tests one thing
test('should calculate stableford points for par', () {
  final points = calculator.calculate(netScore: 4, par: 4);
  expect(points, 2);
});

test('should calculate stableford points for birdie', () {
  final points = calculator.calculate(netScore: 3, par: 4);
  expect(points, 3);
});

// ❌ BAD: Tests multiple things
test('should calculate stableford points', () {
  expect(calculator.calculate(netScore: 4, par: 4), 2); // Par
  expect(calculator.calculate(netScore: 3, par: 4), 3); // Birdie
  expect(calculator.calculate(netScore: 5, par: 4), 1); // Bogey
  // Too much in one test!
});
```

#### 3. Use Descriptive Names

**Test names should describe the behavior:**

```dart
// ✅ GOOD: Clear what's being tested
test('should throw ValidationException when handicap is negative', () {
  // ...
});

test('should calculate net score by subtracting handicap strokes', () {
  // ...
});

// ❌ BAD: Vague names
test('handicap test', () {
  // ...
});

test('test calculation', () {
  // ...
});
```

#### 4. Keep Tests Independent

**Tests should not depend on each other:**

```dart
// ✅ GOOD: Each test sets up its own data
test('test A', () {
  final score = Score(holeScores: [4, 3, 5]);
  // ...
});

test('test B', () {
  final score = Score(holeScores: [4, 4, 4]);
  // ...
});

// ❌ BAD: Tests share mutable state
Score? sharedScore;

test('test A', () {
  sharedScore = Score(holeScores: [4, 3, 5]);
  // ...
});

test('test B', () {
  sharedScore!.holeScores[0] = 3; // Modifies shared state!
  // ...
});
```

#### 5. Test Edge Cases

**Don't just test the happy path:**

```dart
group('StablefordCalculator', () {
  test('should calculate points for par', () {
    expect(calculator.calculate(netScore: 4, par: 4), 2);
  });

  test('should calculate points for albatross', () {
    expect(calculator.calculate(netScore: 2, par: 5), 5);
  });

  test('should return 0 points for double bogey or worse', () {
    expect(calculator.calculate(netScore: 6, par: 4), 0);
    expect(calculator.calculate(netScore: 7, par: 4), 0);
  });

  test('should handle negative scores gracefully', () {
    expect(
      () => calculator.calculate(netScore: -1, par: 4),
      throwsA(isA<ArgumentError>()),
    );
  });
});
```

## Continuous Integration

### GitHub Actions CI

Every push triggers automated testing:

```yaml
- name: Run tests
  run: flutter test --coverage

- name: Upload coverage
  uses: codecov/codecov-action@v5
```

**CI Requirements:**

- ✅ All tests must pass
- ✅ Code must be formatted (`dart format`)
- ✅ No analysis errors (`flutter analyze`)
- ✅ Builds must succeed (iOS & Android)

**Pull requests cannot merge until CI passes.**

## Next Steps

- [Development Workflow](../workflow/development.md) - Learn the TDD process
- [Architecture Overview](../architecture/overview.md) - Understand the structure
- [Getting Started](../getting-started/installation.md) - Set up your environment
