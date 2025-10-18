---
sidebar_position: 1
---

# Installation

Get Mulligans Law running on your local machine.

## Prerequisites

### Required

- **Flutter SDK** - Version 3.5.6 or higher ([install guide](https://docs.flutter.dev/get-started/install))
- **Dart SDK** - Included with Flutter
- **Git** - For version control
- **Node.js** - Version 16+ (for local development tools)

### Platform-Specific

**macOS:**

- Xcode 15+ (for iOS development)
- CocoaPods (installed via `sudo gem install cocoapods`)

**Windows:**

- Android Studio (for Android development)
- Visual Studio Build Tools

**Linux:**

- Android Studio (for Android development)
- Development libraries: `libgtk-3-dev`

### Backend (Supabase)

- **Docker Desktop** - Required for local Supabase instance
- **Supabase CLI** - Install via `brew install supabase/tap/supabase`

## Step-by-Step Installation

### 1. Clone Repository

```bash
git clone https://github.com/barry47products/mulligans-law.git
cd mulligans-law
```

### 2. Install Flutter Dependencies

```bash
# Get all Flutter packages
flutter pub get

# Verify Flutter installation
flutter doctor -v
```

### 3. Set Up Local Supabase

#### Start Supabase

```bash
# Start all Supabase services (PostgreSQL, Auth, Storage, etc.)
supabase start
```

This will:

- Start PostgreSQL database on port 54322
- Start Supabase API on port 54321
- Start Supabase Studio on port 54323
- Output the anon key and service role key

#### Verify Supabase is Running

```bash
# Check status
supabase status
```

Expected output:

```bash
         API URL: http://127.0.0.1:54321
     GraphQL URL: http://127.0.0.1:54321/graphql/v1
         ...
```

#### Access Supabase Studio

Open `http://localhost:54323` in your browser to access the database management UI.

### 4. Configure Environment (Optional)

The app uses default local Supabase configuration. To customize:

```bash
# Create .env file (optional)
cp .env.example .env

# Edit values (defaults work for local development)
# SUPABASE_URL=http://localhost:54321
# SUPABASE_ANON_KEY=<your-local-anon-key>
```

**Note:** For local development, the defaults in `SupabaseConfig` work out of the box.

### 5. Run Database Migrations

```bash
# Apply all migrations to local database
supabase db reset
```

This creates all necessary tables (societies, members, etc.).

### 6. Run the App

#### iOS Simulator (macOS only)

```bash
# List available simulators
flutter devices

# Run on iOS simulator
flutter run -d ios
```

#### Android Emulator

```bash
# Start emulator (if not already running)
flutter emulators --launch <emulator-id>

# Run on Android emulator
flutter run -d android
```

#### Physical Device

```bash
# Connect device via USB, enable developer mode

# List connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

## Verify Installation

### Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test suite
flutter test test/features/auth/
```

**Expected:** All 62 tests passing ✅

### Run Linter

```bash
# Check for issues
flutter analyze

# Auto-fix formatting
dart format lib test
```

**Expected:** No issues found

### Check Git Hooks

```bash
# Lefthook should be installed automatically
lefthook version

# Test pre-commit hook
git commit -m "test" --allow-empty
```

**Expected:** Format and analyze hooks run successfully

## Troubleshooting

### "Supabase not found"

```bash
# Install Supabase CLI
brew install supabase/tap/supabase

# Verify installation
supabase --version
```

### "Docker not running"

```bash
# Start Docker Desktop application
# Then retry: supabase start
```

### "Port already in use"

```bash
# Stop Supabase
supabase stop

# Kill processes on ports 54321-54323
lsof -ti:54321 | xargs kill -9

# Restart Supabase
supabase start
```

### "Flutter doctor shows errors"

```bash
# Android license issues
flutter doctor --android-licenses

# iOS issues (macOS)
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### "Tests fail with MissingPluginException"

This is expected for widget tests that try to initialize Supabase. The individual auth tests mock Supabase properly.

### "Cannot connect to Supabase"

Check that Supabase is running:

```bash
supabase status

# If not running:
supabase start
```

## IDE Setup

### VS Code (Recommended)

Install extensions:

- **Flutter** - Dart and Flutter support
- **Dart** - Dart language support
- **Error Lens** - Inline error display
- **GitLens** - Git integration

Launch configurations are included in `.vscode/launch.json`:

- Run app
- Run tests
- Run auth tests

### Android Studio / IntelliJ

Install plugins:

- **Flutter**
- **Dart**

The project should be recognized automatically.

## Production Configuration

For production builds, set environment variables:

```bash
# iOS
flutter build ios \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=SUPABASE_DEBUG=false

# Android
flutter build apk \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=SUPABASE_DEBUG=false
```

## Next Steps

- [Development Workflow](../workflow/development.md) - How to build features
- [Testing Strategy](../testing/strategy.md) - TDD approach and testing
- [Authentication Feature](../features/authentication.md) - Explore the auth implementation
- [Architecture Overview](../architecture/overview.md) - Understand the codebase structure
