# Complete Development Workflow

Quick reference for the complete development workflow from task start to deployment.

## Daily Workflow

### 1. Start Your Day

```bash
# Pull latest from main
git checkout main
git pull origin main

# Check what's next in TASKS.md
# Pick next task from P0 → P1 → P2 → P3
```

### 2. Start a Task

```bash
# Create feature branch (named after task)
git checkout -b feat/score-capture-ui

# Or for fixes
git checkout -b fix/sync-queue-bug
```

### 3. Work in TDD Cycles

```bash
# Red: Write failing test
# File: test/features/scores/domain/usecases/submit_score_test.dart

# Green: Write minimal code to pass
# File: lib/features/scores/domain/usecases/submit_score.dart

# Commit
git add .
git commit -m "test: add score submission validation test"

# Implement
git add .
git commit -m "feat(scores): implement score submission validation"

# Refactor: Improve code
git add .
git commit -m "refactor(scores): extract validation to helper"

# Push frequently (backup + triggers CI)
git push origin feat/score-capture-ui
```

### 4. Update Documentation

**If you changed/added features or APIs:**

```bash
# Navigate to technical docs
cd docs-technical

# Start local preview
npm start  # Opens http://localhost:3000

# Create/update documentation
# Example: docs-technical/docs/features/score-capture.md

# Verify build works
npm run build

# Return to project root
cd ..

# Commit documentation with feature
git add docs-technical/
git commit -m "docs(features): document score capture workflow"
git push origin feat/score-capture-ui
```

**Documentation checklist:**

- [ ] Created/updated feature page in `docs-technical/docs/features/`
- [ ] Updated API reference in `docs-technical/docs/api/` (if API changed)
- [ ] Added code examples
- [ ] Added screenshots (if UI)
- [ ] Updated sidebar in `docs-technical/sidebars.js` (if new page)

### 5. Final Checks

```bash
# Run all tests
flutter test

# Check coverage
flutter test --coverage
open coverage/index.html  # macOS
# Or: genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html

# Analyze code
flutter analyze

# Format code
dart format .

# Test on device
flutter run -d ios
# Manually test the feature
```

### 6. Create Pull Request

```bash
# Ensure branch is pushed
git push origin feat/score-capture-ui

# Create PR on GitHub
# - Fill out PR template
# - Wait for CI to pass (green checks)
# - Review your own code
# - Check Codecov report
```

**PR Checklist (from template):**

- [ ] Tests written first (TDD)
- [ ] All tests passing
- [ ] No linting errors
- [ ] Offline functionality tested
- [ ] Documentation updated
- [ ] Screenshots added (if UI)

### 7. Merge and Clean Up

```bash
# Once CI passes and you've self-reviewed:
# - Squash and merge via GitHub UI
# - This triggers CD pipeline (deploys to staging)
# - Auto-creates version tag
# - Auto-updates CHANGELOG.md
# - Auto-deploys documentation

# Locally, clean up
git checkout main
git pull origin main
git branch -d feat/score-capture-ui
```

### 8. Verify Deployment

```bash
# Check GitHub Actions for successful deployment
# Check TestFlight for new build (when configured)
# Check docs site: https://barry47products.github.io/mulligans-law/

# Update TASKS.md
# Change [>] to [X] for completed task
```

## Commit Message Examples

### Features

```bash
git commit -m "feat(auth): add email/password authentication"
git commit -m "feat(scores): implement stableford calculation"
git commit -m "feat(leaderboards): add order of merit calculator"
```

### Fixes

```bash
git commit -m "fix(sync): prevent duplicate score submissions"
git commit -m "fix(ui): correct score card layout on iPad"
git commit -m "fix(leaderboards): handle ties correctly"
```

### Tests

```bash
git commit -m "test(scores): add net score calculation tests"
git commit -m "test(auth): add sign in error handling tests"
```

### Refactoring

```bash
git commit -m "refactor(scores): extract calculator to service"
git commit -m "refactor(repos): simplify error handling"
```

### Documentation

```bash
git commit -m "docs: update installation instructions"
git commit -m "docs(api): document score repository methods"
git commit -m "docs(features): add tournament management guide"
```

### Chores

```bash
git commit -m "chore: upgrade flutter to 3.24.1"
git commit -m "chore: update dependencies"
git commit -m "chore: add missing .gitignore entries"
```

### CI/CD

```bash
git commit -m "ci: add coverage threshold check"
git commit -m "ci: fix iOS build configuration"
```

## When Things Go Wrong

### Test Failures

```bash
# Run specific test
flutter test test/path/to/test_file.dart

# Debug with prints
# Add print statements to test
flutter test test/path/to/test_file.dart

# Fix the issue
# Commit fix
git commit -m "fix(tests): correct test expectations"
```

### Linting Errors

```bash
# See all issues
flutter analyze

# Fix automatically (formatting)
dart format .

# Fix manually (logic issues)
# Update code
git commit -m "style: fix linting issues"
```

### CI Fails

```bash
# View CI logs on GitHub Actions tab
# Fix issues locally
# Push again (CI re-runs automatically)
git push origin feat/branch-name
```

### Merge Conflicts

```bash
# Update feature branch with latest main
git checkout feat/branch-name
git fetch origin
git rebase origin/main

# Resolve conflicts
# For each conflict:
# 1. Open file, resolve conflict markers
# 2. git add <file>

git rebase --continue

# Force push (rebased history)
git push --force-with-lease origin feat/branch-name
```

### Need to Change Commit Message

```bash
# Most recent commit
git commit --amend -m "new message"
git push --force-with-lease

# Older commits
git rebase -i HEAD~3  # Last 3 commits
# Change 'pick' to 'reword' for commits to change
# Save and close, then update messages
git push --force-with-lease
```

## Quick Commands

```bash
# Current status
git status

# What changed
git diff

# Commit history
git log --oneline -10

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes) - DANGEROUS
git reset --hard HEAD~1

# See remote branches
git branch -r

# Delete local branch
git branch -d branch-name

# Delete remote branch
git push origin --delete branch-name

# View CI status
gh run list  # GitHub CLI

# View docs locally
cd docs && npm start

# Run tests continuously
flutter test --watch
```

## Time-Saving Aliases

Add to `~/.gitconfig`:

```ini
[alias]
  co = checkout
  br = branch
  ci = commit
  st = status
  unstage = reset HEAD --
  last = log -1 HEAD
  visual = log --oneline --graph --decorate --all

  # TDD workflow
  tdd = "!f() { \
    flutter test && \
    git add . && \
    git commit -m \"test: $1\"; \
  }; f"

  # Quick commit with formatting
  quick = "!f() { \
    dart format . && \
    flutter analyze && \
    git add . && \
    git commit -m \"$1\"; \
  }; f"
```

Usage:

```bash
git co main  # checkout main
git br  # list branches
git last  # show last commit
git visual  # pretty log

# TDD alias
git tdd "add score validation"
# Runs tests, stages files, commits with "test: add score validation"

# Quick commit
git quick "feat(auth): add sign in"
# Formats, analyzes, stages, commits
```

## Daily Checklist

Start of day:

- [ ] Pull latest main
- [ ] Review TASKS.md for next task
- [ ] Check GitHub for any discussion/issues

During development:

- [ ] Write test first (TDD)
- [ ] Commit after each green test
- [ ] Push frequently
- [ ] Update docs as you go

End of task:

- [ ] All tests pass locally
- [ ] Documentation updated
- [ ] Create PR
- [ ] Wait for CI
- [ ] Merge when green
- [ ] Update TASKS.md

End of day:

- [ ] All branches merged or pushed
- [ ] No uncommitted changes
- [ ] TASKS.md updated

## Weekly Checklist

- [ ] Review documentation accuracy
- [ ] Check code coverage trends
- [ ] Update dependencies (if needed)
- [ ] Review open issues
- [ ] Plan next week's priorities

## Resources

- [TASKS.md](TASKS.md) - What to work on
- [CLAUDE.md](CLAUDE.md) - How to work with Claude Code
- [Technical Spec](docs/technical-spec.md) - Architecture reference
- [Functional Spec](docs/functional-spec.md) - Feature requirements
- [Docusaurus Docs](https://barry47products.github.io/mulligans-law/) - Live documentation
