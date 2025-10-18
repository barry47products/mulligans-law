# Codecov Setup Guide

This guide explains how to set up Codecov for code coverage reporting in the Mulligans Law project.

## What is Codecov?

Codecov is a code coverage reporting tool that integrates with your CI/CD pipeline to track test coverage over time. It provides:

- Visual coverage reports
- Coverage badges for README
- Pull request comments with coverage changes
- Coverage trends over time

## Setup Steps

### 1. Sign Up for Codecov

1. Go to [codecov.io](https://codecov.io)
2. Click "Sign up with GitHub"
3. Authorize Codecov to access your GitHub account

### 2. Add Repository

1. Once logged in, click "Add new repository"
2. Find and select `barry47products/mulligans-law`
3. Codecov will provide you with a repository upload token

### 3. Configure GitHub Secret

1. Go to your GitHub repository: `https://github.com/barry47products/mulligans-law`
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `CODECOV_TOKEN`
5. Value: Paste the token from Codecov
6. Click **Add secret**

### 4. Verify Setup

1. Push a commit or create a pull request
2. GitHub Actions CI will run
3. Coverage report will be uploaded to Codecov
4. Check Codecov dashboard for coverage data

## CI Integration

The CI pipeline (`.github/workflows/ci.yml`) already includes Codecov integration:

```yaml
- name: Run tests
  run: flutter test --coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v5
  continue-on-error: true
  with:
    files: ./coverage/lcov.info
    fail_ci_if_error: false
    token: ${{ secrets.CODECOV_TOKEN }}
```

**Note:** The `continue-on-error: true` flag ensures CI passes even if Codecov upload fails (e.g., token not configured yet).

## Optional: Add Coverage Badge

Once Codecov is set up, you can add a coverage badge to the README:

1. Go to Codecov dashboard for your repository
2. Click **Settings** → **Badge**
3. Copy the Markdown badge code
4. Add to `README.md`:

```markdown
[![codecov](https://codecov.io/gh/barry47products/mulligans-law/branch/main/graph/badge.svg)](https://codecov.io/gh/barry47products/mulligans-law)
```

## Coverage Standards

Current project standards (from `CLAUDE.md`):

- **Target coverage:** 70% overall
- **Test distribution:**
  - 70% unit tests (business logic, use cases, calculators)
  - 20% widget tests (UI components)
  - 10% integration tests (full flows)

## What Gets Tested

✅ **Do test:**
- Business logic (use cases, calculators, validators)
- State management (BLoCs, Cubits)
- Widgets with user interaction
- Repository implementations
- Data transformations

❌ **Don't test:**
- Third-party libraries
- Simple getters/setters
- Data classes with no logic
- UI layouts (unless interactive)

## Troubleshooting

### CI passes but no coverage appears

1. Check that `CODECOV_TOKEN` secret is configured in GitHub
2. Verify token is correct in Codecov dashboard
3. Check GitHub Actions logs for upload errors

### Coverage seems low

1. Run `flutter test --coverage` locally
2. Check `coverage/lcov.info` file is generated
3. Ensure tests are actually running assertions
4. Use coverage exclusions for generated files (see below)

### Exclude generated files from coverage

Create `coverage_excludes.txt`:

```
**/*.g.dart
**/*.freezed.dart
**/*.gr.dart
**/generated/**
```

Update test command in CI:

```yaml
- name: Run tests
  run: flutter test --coverage --coverage-path=coverage/lcov.info
```

## Local Coverage Reports

To view coverage locally:

```bash
# Install lcov (macOS)
brew install lcov

# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## Next Steps

1. Set up Codecov account
2. Add `CODECOV_TOKEN` to GitHub secrets
3. Push a commit to trigger CI
4. Verify coverage appears in Codecov dashboard
5. (Optional) Add coverage badge to README
6. (Optional) Configure coverage thresholds in Codecov settings

## Resources

- [Codecov Documentation](https://docs.codecov.com/)
- [GitHub Actions Integration](https://github.com/codecov/codecov-action)
- [Flutter Coverage Guide](https://flutter.dev/docs/cookbook/testing/integration/introduction#5b-generate-coverage-reports)
