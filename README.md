# Mulligans Law

A Flutter mobile application for managing golf scores and leaderboards for social golf societies. Supports regular season play, knockout competitions, offline score capture, and real-time leaderboards.

> **Note**: This project is built with AI-assisted development tools, including Claude Code, for implementation assistance. All code changes are reviewed and committed by human developers who maintain full oversight and decision-making authority.

## 📱 Features

- **Offline-First Score Capture**: Record scores during rounds without internet connection
- **Real-time Leaderboards**: Multiple leaderboard types with live updates
- **Tournament Management**: Flexible tournament and season structures
- **Knockout Competitions**: Bracket-based matchplay competitions
- **Social Features**: Player profiles, chat, and scorecard photos
- **Multi-Format Support**: Individual and team scoring formats

## 🛠 Tech Stack

- **Framework**: Flutter (latest stable)
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Realtime)
- **State Management**: flutter_bloc (BLoC pattern)
- **Local Database**: Drift (SQLite)
- **Architecture**: Clean Architecture with Offline-First approach

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (latest stable) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (included with Flutter)
- **Docker Desktop** - [Download Docker](https://www.docker.com/products/docker-desktop/)
- **Supabase CLI** - [Install Guide](https://supabase.com/docs/guides/cli)
- **Xcode** (macOS, for iOS development) - Available on Mac App Store
- **Android Studio** (for Android development, optional)
- **Git** - [Install Git](https://git-scm.com/downloads)
- **Node.js** 18+ (for documentation site) - [Install Node.js](https://nodejs.org/)

### Verify Installation

```bash
flutter doctor        # Check Flutter installation
supabase --version    # Should show CLI version
docker --version      # Check Docker installation
node --version        # Should show v18.x or higher
```

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/barry47products/mulligans-law.git
cd mulligans-law
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Set Up Local Supabase

#### Install Supabase CLI (if not already installed)

```bash
# macOS
brew install supabase/tap/supabase

# Windows (via Scoop)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Linux
brew install supabase/tap/supabase
```

#### Start Local Supabase Instance

```bash
supabase start
```

This will output important connection details:

```
API URL: http://localhost:54321
GraphQL URL: http://localhost:54321/graphql/v1
DB URL: postgresql://postgres:postgres@localhost:54322/postgres
Studio URL: http://localhost:54323
Inbucket URL: http://localhost:54324
JWT secret: super-secret-jwt-token-with-at-least-32-characters-long
anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Access Supabase Studio

Open [http://localhost:54323](http://localhost:54323) to access the Supabase Studio dashboard where you can:
- View database tables
- Run SQL queries
- Manage authentication
- View storage buckets

### 4. Configure Flutter App

Create `lib/core/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'http://localhost:54321';
  static const String supabaseAnonKey = 'your-anon-key-from-supabase-start';
}
```

**Note**: Replace `your-anon-key-from-supabase-start` with the actual anon key from the `supabase start` output.

### 5. Run Database Migrations

```bash
# Apply all migrations to local database
supabase db reset

# This will:
# - Drop existing database
# - Recreate schema
# - Run all migrations in order
# - Apply seed data (if any)
```

### 6. Run the App

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Chrome (for web testing)
flutter run -d chrome
```

## 💻 Development Workflow

### Git Workflow

This project follows **trunk-based development** with short-lived feature branches:

#### 1. Start a New Task

```bash
# Always start from latest main
git checkout main
git pull origin main

# Create feature branch (named after task from TASKS.md)
git checkout -b feat/score-capture-ui
```

#### 2. Work in TDD Cycles

Follow the Red-Green-Refactor cycle with frequent commits:

```bash
# Red: Write failing test
git commit -m "test: add failing test for score validation"

# Green: Make it pass
git commit -m "feat(scores): implement score validation"

# Refactor: Improve code
git commit -m "refactor(scores): extract validation logic"
```

#### 3. Push Frequently

```bash
# Push to remote (triggers CI)
git push origin feat/score-capture-ui
```

#### 4. Create Pull Request

When your task is complete:

1. Ensure all tests pass locally
2. Update documentation if needed
3. Create PR via GitHub UI
4. Wait for CI to pass
5. Self-review your code
6. Squash and merge to main

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

[optional body]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `test`: Add/update tests
- `refactor`: Code restructuring (no behavior change)
- `docs`: Documentation changes
- `style`: Formatting, whitespace
- `perf`: Performance improvements
- `chore`: Build, dependencies, tooling
- `ci`: CI/CD pipeline changes

**Examples:**

```bash
feat(scores): add stableford calculation
fix(sync): handle offline queue correctly
test(leaderboards): add order of merit tests
refactor(auth): simplify login flow
docs: update API documentation
```

### Testing Strategy

This project uses **Test-Driven Development (TDD)**. Always write tests BEFORE implementation.

#### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report locally (requires lcov: brew install lcov)
genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html

# Run specific test file
flutter test test/features/scores/domain/usecases/submit_score_test.dart

# Run tests matching pattern
flutter test --name "score"

# Watch mode (re-run on changes - requires fswatch)
flutter test --watch
```

#### Coverage Requirements

- **P0 Tasks**: Report coverage, no enforcement
- **P1 Tasks**: 70% threshold enforced
- **P2+ Tasks**: 80% threshold enforced

#### View Coverage Report

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
```

### Code Quality

```bash
# Analyze code (check for errors)
flutter analyze

# Format code
dart format .

# Run all checks (what CI runs)
flutter analyze && dart format --set-exit-if-changed . && flutter test
```

### Database Migrations

```bash
# Create new migration
supabase migration new add_spot_prizes

# Edit the generated file in supabase/migrations/
# Example: supabase/migrations/20240101000000_add_spot_prizes.sql

# Apply migrations locally
supabase db reset

# View migration status
supabase migration list

# Generate TypeScript types (optional, for Supabase functions)
supabase gen types typescript --local > lib/core/types/database.types.ts
```

### Working with Supabase Studio

Access the local Supabase Studio at [http://localhost:54323](http://localhost:54323):

- **Table Editor**: View and edit data
- **SQL Editor**: Run custom SQL queries
- **Authentication**: Manage users and auth settings
- **Storage**: Upload and manage files
- **API Docs**: Auto-generated API documentation

## 📁 Project Structure

```
mulligans-law/
├── .github/
│   └── workflows/          # CI/CD pipelines
│       ├── ci.yml          # Lint, test, build
│       ├── cd.yml          # App deployment (semantic-release)
│       └── deploy-docs.yml # Documentation deployment
├── docs/                   # Project documentation
│   ├── functional-spec.md  # Feature requirements
│   ├── technical-spec.md   # Architecture details
│   ├── GITHUB_SETUP.md     # GitHub configuration
│   ├── CODECOV_SETUP.md    # Coverage reporting setup
│   ├── DEPLOYMENT.md       # CD pipeline and deployment guide
│   └── DOCUSAURUS_SETUP.md # Docs site setup
├── docs-technical/         # Docusaurus documentation site
│   ├── docs/              # Documentation content
│   └── docusaurus.config.ts
├── lib/
│   ├── core/              # Shared utilities, themes, constants
│   │   ├── config/        # App configuration
│   │   ├── constants/     # App-wide constants
│   │   ├── theme/         # App theme
│   │   └── utils/         # Utility functions
│   ├── features/          # Feature modules
│   │   ├── auth/          # Authentication
│   │   ├── scores/        # Score capture
│   │   ├── leaderboards/  # Leaderboards
│   │   └── ...
│   └── main.dart
├── test/
│   ├── features/          # Feature tests (mirrors lib/)
│   ├── integration/       # Integration tests
│   └── helpers/           # Test utilities
├── supabase/
│   ├── migrations/        # Database migrations
│   ├── seed.sql          # Seed data
│   └── config.toml       # Local Supabase config
├── CLAUDE.md              # Claude Code development guidelines
├── TASKS.md               # Kanban board of tasks
├── WORKFLOW.md            # Development workflow guide
└── README.md              # This file
```

### Feature Module Structure

Each feature follows **Clean Architecture**:

```
feature/
├── data/
│   ├── models/            # Data models (JSON serialization)
│   ├── datasources/       # Remote & local data sources
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Business objects
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic
└── presentation/
    ├── bloc/              # State management
    ├── screens/           # Full screen widgets
    └── widgets/           # Reusable widgets
```

## 📚 Documentation

### Project Documentation

- **[Functional Specification](docs/functional-spec.md)** - Complete feature requirements and user stories
- **[Technical Specification](docs/technical-spec.md)** - Architecture and implementation details
- **[CLAUDE.md](CLAUDE.md)** - Development guidelines for AI-assisted development
- **[TASKS.md](TASKS.md)** - Kanban board of tasks (prioritized)
- **[WORKFLOW.md](WORKFLOW.md)** - Detailed development workflow
- **[GitHub Setup](docs/GITHUB_SETUP.md)** - GitHub configuration guide
- **[Docusaurus Setup](docs/DOCUSAURUS_SETUP.md)** - Documentation site setup

### Live Documentation

- **[Technical Documentation](https://barry47products.github.io/mulligans-law/)** - Docusaurus site with:
  - Getting started guides
  - Architecture documentation
  - API reference
  - Feature guides
  - Testing strategies

### Updating Documentation

When you add features, update the technical documentation:

```bash
cd docs-technical
npm start  # Preview locally at http://localhost:3000

# Add your documentation pages
# Commit and push - auto-deploys to GitHub Pages
```

## 🔄 CI/CD Pipeline

### Continuous Integration (CI)

Runs on **every push** to any branch:

```yaml
✓ Checkout code
✓ Setup Flutter
✓ Install dependencies
✓ Format check (dart format)
✓ Analyze code (flutter analyze)
✓ Run tests (flutter test)
✓ Generate coverage report
✓ Upload to Codecov
✓ Build Android APK
✓ Build iOS (no codesign)
```

### Continuous Deployment (CD)

Runs on **merge to main**:

```yaml
✓ Run full CI pipeline
✓ Semantic versioning (conventional commits)
✓ Create GitHub Release
✓ Build production APK
✓ Upload to TestFlight (future)
✓ Deploy documentation to GitHub Pages
```

### Coverage Tracking

- Tracked via [Codecov](https://codecov.io)
- Reports appear in Pull Requests
- Phase 1 (P0): Report only, no enforcement
- Phase 2 (P1): 70% threshold enforced
- Phase 3 (P2+): 80% threshold enforced

### Branch Protection

Main branch is protected with:
- ✓ Require PR reviews (self-review allowed for solo dev)
- ✓ Require status checks (CI must pass)
- ✓ No force pushes
- ✓ No deletions

## 🐛 Troubleshooting

### Supabase Issues

**Can't connect to Supabase:**
```bash
# Check if Supabase is running
supabase status

# If not running, start it
supabase start

# Check Docker is running
docker ps
```

**Database issues:**
```bash
# Reset database (WARNING: deletes all data)
supabase db reset

# View logs
supabase db logs
```

### Flutter Issues

**Build errors:**
```bash
# Clean build
flutter clean
flutter pub get

# Regenerate generated files
flutter pub run build_runner build --delete-conflicting-outputs
```

**Dependency conflicts:**
```bash
# Update dependencies
flutter pub upgrade

# Get exact versions from pubspec.lock
flutter pub get
```

### Testing Issues

**Tests failing:**
```bash
# Run tests with verbose output
flutter test --reporter expanded

# Run single test file
flutter test test/path/to/test_file.dart
```

## 🤝 Contributing

This is currently a solo development project. If you'd like to contribute:

1. Open an issue to discuss proposed changes
2. Wait for approval before starting work
3. Follow the development guidelines in [CLAUDE.md](CLAUDE.md)
4. Ensure all tests pass and coverage requirements are met

## 📄 License

[To be determined]

## 📧 Contact

[To be determined]

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/) - Google's UI toolkit
- Backend powered by [Supabase](https://supabase.com/) - Open source Firebase alternative
- State management with [flutter_bloc](https://bloclibrary.dev/)
- Local database with [Drift](https://drift.simonbinder.eu/)
- AI assistance from [Claude](https://www.anthropic.com/claude) by Anthropic
- Documentation with [Docusaurus](https://docusaurus.io/)

---

**Happy Coding! ⛳️**
