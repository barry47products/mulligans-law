# GitHub Actions CI/CD Setup Guide

This guide walks through setting up the complete CI/CD pipeline for the Golf Society App.

## Prerequisites

- GitHub repository created
- Local development environment working
- Supabase local environment running

## 1. Repository Setup

### Create Repository

```bash
# On GitHub: Create new repository (mulligans-law)
# Initialize locally
git init
git add .
git commit -m "chore: initial project setup"
git branch -M main
git remote add origin https://github.com/barry47products/mulligans-law.git
git push -u origin main
```

### Configure Branch Protection

1. Go to repository **Settings** → **Branches**
2. Add branch protection rule for `main`:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
     - Add: `Test and Build`
   - ✅ Require branches to be up to date before merging
   - ✅ Include administrators
   - ✅ Restrict pushes to matching branches

## 2. Configure Secrets

Go to repository **Settings** → **Secrets and variables** → **Actions**

### Required Secrets

#### Codecov (Coverage Reporting)

1. Sign up at [codecov.io](https://codecov.io)
2. Add repository
3. Get upload token
4. Add secret: `CODECOV_TOKEN`

#### TestFlight (iOS Distribution) - Optional Initially

When ready to deploy to TestFlight:

1. **App Store Connect API Key**

   - Go to App Store Connect → Users and Access → Keys
   - Create new API key with App Manager role
   - Download `.p8` file

2. **Add Secrets:**
   - `APPSTORE_ISSUER_ID`: From API Keys page
   - `APPSTORE_API_KEY_ID`: From API Keys page
   - `APPSTORE_API_PRIVATE_KEY`: Contents of `.p8` file

#### Supabase (Future Staging/Production)

When deploying to Supabase staging:

- `SUPABASE_PROJECT_REF`: Project reference ID
- `SUPABASE_ACCESS_TOKEN`: Personal access token

## 3. Set Up Workflow Files

Copy these files to your repository:

```bash
mkdir -p .github/workflows
# Copy ci.yml to .github/workflows/ci.yml
# Copy deploy.yml to .github/workflows/deploy.yml
```

### Initial Configuration

The CI pipeline is ready to use immediately. The CD pipeline needs configuration:

**In `.github/workflows/deploy.yml`:**

1. **TestFlight Upload** - Commented out initially
   - Uncomment when certificates are configured
2. **Supabase Migrations** - Commented out initially
   - Uncomment when deploying to staging

## 4. Configure Semantic Release

```bash
# Copy .releaserc.json to repository root

# Commit
git add .releaserc.json
git commit -m "chore: add semantic release configuration"
```

## 5. Configure Git Commit Template

```bash
# Copy .gitmessage to repository root
cp .gitmessage ~/.gitmessage

# Configure git to use template
git config commit.template ~/.gitmessage

# Or project-specific
git config --local commit.template .gitmessage
```

## 6. Set Up Commit Hooks (Optional but Recommended)

### Using Husky

```bash
# Install husky
flutter pub add --dev husky

# Or use lefthook (lighter alternative)
# brew install lefthook
# lefthook install
```

### Create `.husky/pre-commit`

```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

# Format check
echo "🎨 Checking formatting..."
if ! dart format --set-exit-if-changed .; then
    echo "❌ Code formatting issues found. Run: dart format ."
    exit 1
fi

# Analyze
echo "🔍 Running analysis..."
if ! flutter analyze; then
    echo "❌ Analysis issues found."
    exit 1
fi

echo "✅ Pre-commit checks passed!"
```

### Create `.husky/commit-msg`

```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

# Validate commit message format
commit_msg=$(cat "$1")
pattern="^(feat|fix|test|refactor|docs|style|perf|chore|ci)(\(.+\))?: .{1,50}"

if ! echo "$commit_msg" | grep -Eq "$pattern"; then
    echo "❌ Invalid commit message format!"
    echo "Expected: <type>(<scope>): <subject>"
    echo "Example: feat(scores): add stableford calculation"
    exit 1
fi
```

## 7. Set Up PR Template

```bash
mkdir -p .github
# Copy pull_request_template.md to .github/
```

## 8. Verify CI Pipeline

```bash
# Create test branch
git checkout -b test/ci-pipeline

# Make a small change
echo "# Test" >> README.md
git add README.md
git commit -m "test: verify CI pipeline"

# Push
git push origin test/ci-pipeline

# Create PR on GitHub
# Verify that CI runs and passes
```

## 9. Test CD Pipeline

```bash
# Create feature branch
git checkout -b feat/initial-setup

# Complete setup
git add .
git commit -m "feat: complete initial project setup"
git push origin feat/initial-setup

# Create PR and merge to main
# CD pipeline should run automatically
# Check Actions tab for deploy job
```

## 10. Configure Coverage Enforcement

### Phase 1: P0 Tasks (Current)

Coverage is **reported only**, no enforcement.

### Phase 2: P1 Tasks (After Foundation)

In `.github/workflows/ci.yml`, uncomment:

```yaml
- name: Check coverage threshold
  run: |
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')
    echo "Current coverage: ${COVERAGE}%"

    THRESHOLD=70  # Uncomment this
    if (( $(echo "$COVERAGE < $THRESHOLD" | bc -l) )); then
      echo "Coverage ${COVERAGE}% is below threshold ${THRESHOLD}%"
      exit 1
    fi
```

### Phase 3: P2+ Tasks (After Core Features)

Change `THRESHOLD=70` to `THRESHOLD=80`

## 11. Monitoring and Maintenance

### View Pipeline Status

- Go to repository **Actions** tab
- See all workflow runs
- Click on any run for details
- View logs for debugging

### Coverage Reports

- Go to [codecov.io](https://codecov.io)
- View coverage trends
- See coverage on PRs

### Release History

- Go to repository **Releases**
- See all tagged versions
- View changelogs (auto-generated)

## Troubleshooting

### CI Fails on Formatting

```bash
# Fix locally
dart format .
git add .
git commit -m "style: fix formatting"
git push
```

### CI Fails on Analysis

```bash
# Run locally to see issues
flutter analyze

# Fix issues
git commit -m "fix: resolve analysis issues"
git push
```

### CI Fails on Tests

```bash
# Run tests locally
flutter test

# Fix failing tests
git commit -m "fix: resolve test failures"
git push
```

### CD Fails on Semantic Release

Check commit messages follow conventional commits format:

- `feat:` for features
- `fix:` for bug fixes
- Proper format: `type(scope): subject`

### TestFlight Upload Fails

1. Verify certificates are configured
2. Check secrets are set correctly
3. Ensure App Store Connect API key has correct permissions
4. Review build logs for specific error

## Next Steps

After initial setup:

1. ✅ Complete P0 tasks (Foundation)
2. ✅ Verify CI/CD pipeline working
3. 🔜 Enable coverage enforcement (Phase 2)
4. 🔜 Configure TestFlight when ready for beta testing
5. 🔜 Set up Supabase staging environment
6. 🔜 Configure automated database migrations

## Useful Commands

```bash
# View workflow runs locally
gh run list

# View specific run
gh run view <run-id>

# Trigger workflow manually
gh workflow run ci.yml

# View secrets
gh secret list

# Add secret
gh secret set SECRET_NAME
```

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Release](https://semantic-release.gitbook.io/)
- [Codecov Documentation](https://docs.codecov.com/)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
