# Mulligans Law

A platform-agnostic mobile application for managing golf scores and leaderboards for social golf societies. Supports regular season play, knockout competitions, offline score capture, and real-time leaderboards.

## Features

- **Offline-First Score Capture**: Record scores during rounds without internet connection
- **Real-time Leaderboards**: Multiple leaderboard types with live updates
- **Tournament Management**: Flexible tournament and season structures
- **Knockout Competitions**: Bracket-based matchplay competitions
- **Social Features**: Player profiles, chat, and scorecard photos
- **Multi-Format Support**: Individual and team scoring formats

## Tech Stack

- **Framework**: Flutter (latest stable)
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Realtime)
- **State Management**: flutter_bloc (BLoC pattern)
- **Local Database**: Drift (SQLite)
- **Architecture**: Clean Architecture with Offline-First

## Prerequisites

- Flutter SDK (latest stable)
- Dart SDK (included with Flutter)
- Docker Desktop (for local Supabase)
- Xcode (for iOS development)
- Git

## Getting Started

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

```bash
# Install Supabase CLI
brew install supabase/tap/supabase

# Start local Supabase stack
supabase start

# This will output:
# - API URL: http://localhost:54321
# - Database URL: postgresql://...
# - Studio URL: http://localhost:54323
# - anon key: (for Flutter app)
```

### 4. Configure Flutter App

Create `lib/core/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'http://localhost:54321';
  static const String supabaseAnonKey = 'your-anon-key-from-supabase-start';
}
```

### 5. Run the App

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android
```

## Development

### Git Workflow

This project follows trunk-based development:

1. **Create feature branch** from `main`

   ```bash
   git checkout -b feat/task-name
   ```

2. **Work in TDD cycles** with frequent commits

   ```bash
   git commit -m "test: add failing test for X"
   git commit -m "feat: implement X"
   ```

3. **Push frequently**

   ```bash
   git push origin feat/task-name
   ```

4. **Create PR** when task complete
   - CI runs automatically
   - Squash and merge to main

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
<type>(<scope>): <subject>

feat(scores): add stableford calculation
fix(sync): handle offline queue correctly
test(leaderboards): add order of merit tests
```

Types: `feat`, `fix`, `test`, `refactor`, `docs`, `style`, `perf`, `chore`, `ci`

### Testing

This project uses **Test-Driven Development (TDD)**:

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/scores/domain/usecases/submit_score_test.dart

# Watch mode (re-run on changes)
flutter test --watch
```

**Coverage Requirements:**

- P0/P1 Tasks: Report only
- P1 Tasks: 70% threshold enforced
- P2+ Tasks: 80% threshold enforced

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Run all checks (what CI runs)
flutter analyze && dart format --set-exit-if-changed . && flutter test
```

### Database Migrations

```bash
# Create new migration
supabase migration new migration_name

# Apply migrations locally
supabase db reset

# View database in Studio
open http://localhost:54323
```

## Project Structure

```bash
lib/
├── core/               # Shared utilities, themes, constants
├── features/           # Feature modules
│   ├── auth/
│   ├── scores/
│   ├── leaderboards/
│   └── ...
└── main.dart

test/
├── unit/              # Unit tests
├── widget/            # Widget tests
└── integration/       # Integration tests

supabase/
├── migrations/        # Database migrations
└── seed.sql          # Seed data
```

Each feature follows Clean Architecture:

```bash
feature/
├── data/              # Repositories, models
├── domain/            # Entities, use cases, interfaces
└── presentation/      # Screens, widgets, BLoCs
```

## Documentation

- [Functional Specification](docs/functional-spec.md) - Complete feature requirements
- [Technical Specification](docs/technical-spec.md) - Architecture and implementation details
- [CLAUDE.md](CLAUDE.md) - Development guidelines for Claude Code
- [TASKS.md](TASKS.md) - Kanban board of tasks
- [Live Documentation](https://barry47products.github.io/mulligans-law/) - Docusaurus site

## CI/CD

- **CI**: Runs on every push (lint, test, build)
- **CD**: Deploys to TestFlight on merge to `main`
- **Versioning**: Semantic versioning via conventional commits
- **Coverage**: Tracked via Codecov

See [.github/workflows/](.github/workflows/) for pipeline definitions.

## AI-Assisted Development

This project uses AI-assisted development tools, including Claude Code, for implementation assistance. All code changes are reviewed and committed by human developers who maintain full oversight and decision-making authority.

## Contributing

This is currently a solo development project. If you'd like to contribute, please open an issue first to discuss proposed changes.

## License

[TBD]

## Contact

[TBD]

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Backend powered by [Supabase](https://supabase.com/)
- AI assistance from [Claude](https://www.anthropic.com/claude)
