# Testing Guide

This document explains how to run tests in the Mulligans Law project.

## Quick Start

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Organization

```bash
test/
├── features/
│   └── auth/                           # Authentication Feature (49 tests)
│       ├── auth_test_suite.dart        # Run all auth tests together
│       ├── data/
│       │   └── repositories/           # Repository layer (16 tests)
│       ├── domain/
│       │   └── usecases/               # Use case layer (20 tests)
│       └── presentation/
│           └── bloc/                   # BLoC layer (13 tests)
├── helpers/                            # Test utilities (10 tests)
└── widget_test.dart                    # Widget tests (1 test)

Total: 62 tests
```

## Running Tests by Feature

### All Auth Tests (49 tests)

```bash
flutter test test/features/auth/auth_test_suite.dart
```

Or run the entire auth directory:

```bash
flutter test test/features/auth/
```bash
flutter test test/features/auth/
```

## Running Tests by Layer

### Data Layer Tests

```bash
# All data layer tests
flutter test test/features/auth/data/

# Specific repository tests
flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart
```

### Domain Layer Tests (Use Cases)

```bash
# All domain tests
flutter test test/features/auth/domain/

# All use case tests
flutter test test/features/auth/domain/usecases/

# Specific use case tests
flutter test test/features/auth/domain/usecases/sign_in_test.dart
flutter test test/features/auth/domain/usecases/sign_up_test.dart
flutter test test/features/auth/domain/usecases/sign_out_test.dart
flutter test test/features/auth/domain/usecases/get_current_user_test.dart
```

### Presentation Layer Tests (BLoC)

```bash
# All presentation tests
flutter test test/features/auth/presentation/

# BLoC tests
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart
```

## Running Tests by Name Pattern

```bash
# Run all tests with "SignIn" in the name
flutter test --name "SignIn"

# Run all tests with "BLoC" in the name
flutter test --name "BLoC"

# Run all tests with "Auth" in the name
flutter test --name "Auth"
```

## Using VS Code

### Test Configurations Available

Press `F5` or use the Run menu to select:

1. **Run All Tests** - All 62 tests with coverage
2. **Run Auth Tests (All)** - All 49 auth tests
3. **Run Auth Data Layer Tests** - 16 repository tests
4. **Run Auth Use Case Tests** - 20 use case tests
5. **Run Auth BLoC Tests** - 13 BLoC tests
6. **Run Current Test File** - Tests in the open file

### Using VS Code Test Explorer

1. Install the **Dart** extension (should already be installed)
2. Click the test icon in the sidebar (beaker icon)
3. Browse tests by file/group
4. Click play icon next to any test to run it
5. Click debug icon to debug with breakpoints

## Test Output Interpretation

```bash
✓ test/features/auth/data/repositories/auth_repository_impl_test.dart  16/16 passed
```

- ✓ = All tests passed
- 16/16 = 16 tests passed out of 16 total
- Time shown after each file

## Coverage Reports

### Generate Coverage

```bash
flutter test --coverage
```

### View HTML Report

```bash
# Install lcov (one-time setup)
brew install lcov  # macOS
# or
sudo apt-get install lcov  # Linux

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html  # macOS
# or
xdg-open coverage/html/index.html  # Linux
```

### Coverage Goals

- **Unit Tests**: 70% coverage (repositories, use cases)
- **Widget Tests**: 20% coverage (screens, widgets)
- **Integration Tests**: 10% coverage (end-to-end flows)

Current coverage: Check `coverage/html/index.html` after generation

## Debugging Tests

### In VS Code

1. Set breakpoints in your test or implementation
2. Select "Run Current Test File" from debug menu (F5)
3. Test will pause at breakpoints
4. Use debug toolbar to step through code

### Command Line

```bash
# Run with verbose output
flutter test --verbose

# Run specific test with output
flutter test test/path/to/test.dart --name "test name"

# Run with Dart VM options
flutter test --dart-define=DEBUG=true
```

## Writing New Tests

### Test File Naming

- Test files should end with `_test.dart`
- Place test files in the same structure as source files
- Example: `lib/features/auth/domain/usecases/sign_in.dart`
  → `test/features/auth/domain/usecases/sign_in_test.dart`

### Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    test('should do something', () {
      // Arrange

      // Act

      // Assert
    });
  });
}
```

### Using Test Helpers

```dart
import '../../../../helpers/test_helper.dart';
import '../../../../helpers/mock_factories.dart';

// Use helper functions
await pumpTestWidget(tester, MyWidget());

// Use mock factories
final user = createTestUser();
```

## Continuous Integration

Tests run automatically on:

- Every push to any branch
- Every pull request
- Before merging to main

See `.github/workflows/` for CI configuration.

## Troubleshooting

### Tests Not Running?

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Regenerate mocks
flutter pub run build_runner build --delete-conflicting-outputs

# Try again
flutter test
```

### Slow Tests?

```bash
# Run tests in parallel (faster)
flutter test --concurrency=4

# Run only specific tests during development
flutter test test/features/auth/domain/usecases/sign_in_test.dart
```

### Mock Issues?

If you see "Missing stub" errors:

1. Regenerate mocks: `flutter pub run build_runner build --delete-conflicting-outputs`
2. Check `@GenerateMocks` annotations in test files
3. Ensure mock files are imported

## Best Practices

1. **Run tests before committing**: `flutter test`
2. **Write tests first** (TDD): Red → Green → Refactor
3. **One assertion per test** when possible
4. **Use descriptive test names**: "should return user when email is valid"
5. **Group related tests**: Use `group()` to organize
6. **Mock external dependencies only**: Don't mock domain entities
7. **Keep tests fast**: Unit tests should run in milliseconds

## Resources

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [BLoC Testing](https://pub.dev/packages/bloc_test)
- Project CLAUDE.md for TDD guidelines
