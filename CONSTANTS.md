# Constants and Magic Values Guide

## Philosophy: No Magic Strings or Numbers

**Every literal value in the codebase must be a named constant.** This improves:

- **Readability**: Clear intent through descriptive names
- **Maintainability**: Change once, apply everywhere
- **Type Safety**: Compile-time checks prevent typos
- **Discoverability**: IDE autocomplete helps find values
- **Testability**: Easy to mock/override for tests

## Organization Structure

```bash
lib/core/constants/
├── app_strings.dart         # UI text, labels, messages
├── ui_constants.dart         # Spacing, sizes, durations
├── scoring_constants.dart    # Golf scoring rules
├── database_constants.dart   # Table names, column names, status values
├── time_constants.dart       # Durations, intervals
├── route_constants.dart      # Navigation routes
└── api_constants.dart        # API endpoints, keys (non-sensitive)
```

## Examples by Category

### 1. UI Constants

#### lib/core/constants/ui_constants.dart

```dart
class UiConstants {
  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;

  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeTitle = 24.0;

  // Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Touch targets (accessibility)
  static const double minTouchTarget = 44.0;

  // Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
```

### 2. App Strings

#### lib/core/constants/app_strings.dart

```dart
class AppStrings {
  // App info
  static const String appName = 'Mulligans Law';
  static const String appTagline = 'Golf Society Score Management';

  // Common labels
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String done = 'Done';

  // Golf terms
  static const String hole = 'Hole';
  static const String par = 'Par';
  static const String gross = 'Gross';
  static const String net = 'Net';
  static const String stableford = 'Stableford';
  static const String handicap = 'Handicap';
  static const String strokeIndex = 'Stroke Index';

  // Score capture
  static const String enterScore = 'Enter Score';
  static const String submitScore = 'Submit Score';
  static const String reviewScore = 'Review Score';
  static const String scoreSubmitted = 'Score Submitted';

  // Error messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'No internet connection.';
  static const String errorInvalidScore = 'Please enter a valid score.';
  static const String errorIncompleteRound = 'All 18 holes must be completed.';

  // Success messages
  static const String successScoreSubmitted = 'Score submitted successfully!';
  static const String successScoreApproved = 'Score approved.';

  // Validation messages
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email';
  static const String validationPasswordLength = 'Password must be at least 8 characters';
}
```

### 3. Scoring Constants

#### lib/core/constants/scoring_constants.dart

```dart
class ScoringConstants {
  // Holes
  static const int holesPerRound = 18;
  static const int frontNineStart = 1;
  static const int frontNineEnd = 9;
  static const int backNineStart = 10;
  static const int backNineEnd = 18;

  // Handicap limits
  static const int minHandicap = 0;
  static const int maxHandicap = 54;

  // Stableford points
  static const int pointsDoubleBogeyOrWorse = 0;
  static const int pointsBogey = 1;
  static const int pointsPar = 2;
  static const int pointsBirdie = 3;
  static const int pointsEagle = 4;
  static const int pointsAlbatross = 5;

  // Score to par offsets
  static const int scoreDoubleBogey = 2;
  static const int scoreBogey = 1;
  static const int scorePar = 0;
  static const int scoreBirdie = -1;
  static const int scoreEagle = -2;
  static const int scoreAlbatross = -3;

  // Team handicap allowances (percentages)
  static const double fourballHandicapAllowance = 0.85;
  static const double foursomesHandicapAllowance = 0.50;

  // Order of Merit points
  static const int pointsFirstPlace = 10;
  static const int pointsSecondPlace = 9;
  static const int pointsThirdPlace = 8;
  static const int pointsFourthPlace = 7;
  static const int pointsFifthPlace = 6;
  static const int pointsSixthPlace = 5;
  static const int pointsSeventhPlace = 4;
  static const int pointsEighthPlace = 3;
  static const int pointsNinthPlace = 2;
  static const int pointsTenthPlace = 1;

  // Par values
  static const int parThree = 3;
  static const int parFour = 4;
  static const int parFive = 5;

  // Minimum/maximum realistic scores
  static const int minScorePerHole = 1; // Hole in one
  static const int maxScorePerHole = 10; // Reasonable maximum
}
```

### 4. Database Constants

#### lib/core/constants/database_constants.dart

```dart
class DatabaseTables {
  static const String societies = 'societies';
  static const String members = 'members';
  static const String courses = 'courses';
  static const String seasons = 'seasons';
  static const String tournaments = 'tournaments';
  static const String rounds = 'rounds';
  static const String groups = 'groups';
  static const String scores = 'scores';
  static const String teamScores = 'team_scores';
  static const String matches = 'matches';
  static const String spotPrizes = 'spot_prizes';
  static const String scorecardPhotos = 'scorecard_photos';
  static const String chatMessages = 'chat_messages';
  static const String handicapHistory = 'handicap_history';
}

class ScoreStatus {
  static const String inProgress = 'IN_PROGRESS';
  static const String submitted = 'SUBMITTED';
  static const String approved = 'APPROVED';
  static const String disputed = 'DISPUTED';
}

class RoundStatus {
  static const String setup = 'SETUP';
  static const String inProgress = 'IN_PROGRESS';
  static const String submitted = 'SUBMITTED';
  static const String completed = 'COMPLETED';
}

class MemberRole {
  static const String admin = 'ADMIN';
  static const String captain = 'CAPTAIN';
  static const String user = 'USER';
}

class MemberStatus {
  static const String active = 'ACTIVE';
  static const String inactive = 'INACTIVE';
}

class SeasonType {
  static const String regular = 'REGULAR';
  static const String knockout = 'KNOCKOUT';
}

class FormatType {
  static const String individualStroke = 'INDIVIDUAL_STROKE';
  static const String individualStableford = 'INDIVIDUAL_STABLEFORD';
  static const String fourballAlliance = 'FOURBALL_ALLIANCE';
  static const String fourballBetterBall = 'FOURBALL_BETTER_BALL';
  static const String foursomes = 'FOURSOMES';
}

class LeaderboardType {
  static const String bestGrossPerHole = 'BEST_GROSS_PER_HOLE';
  static const String bestNetPerHole = 'BEST_NET_PER_HOLE';
  static const String bestStablefordPerHole = 'BEST_STABLEFORD_PER_HOLE';
  static const String orderOfMerit = 'ORDER_OF_MERIT';
  static const String averageScore = 'AVERAGE_SCORE';
  static const String cumulativeTotal = 'CUMULATIVE_TOTAL';
}
```

### 5. Time Constants

#### lib/core/constants/time_constants.dart

```dart
class TimeConstants {
  // Sync intervals
  static const Duration syncInterval = Duration(seconds: 30);
  static const Duration syncRetryDelay = Duration(seconds: 5);

  // Debounce delays
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration inputDebounce = Duration(milliseconds: 300);

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(seconds: 60);

  // Conversion factors
  static const int secondsPerMinute = 60;
  static const int minutesPerHour = 60;
  static const int secondsPerHour = 3600;
  static const int millisecondsPerSecond = 1000;

  // Cache durations
  static const Duration cacheShort = Duration(minutes: 5);
  static const Duration cacheMedium = Duration(hours: 1);
  static const Duration cacheLong = Duration(days: 1);
}
```

### 6. Route Constants

#### lib/core/constants/route_constants.dart

```dart
class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String home = '/home';

  // Societies
  static const String societies = '/societies';
  static const String societyDetails = '/societies/:id';
  static const String createSociety = '/societies/create';

  // Rounds
  static const String rounds = '/rounds';
  static const String roundDetails = '/rounds/:id';
  static const String createRound = '/rounds/create';
  static const String scoreCapture = '/rounds/:id/score';

  // Leaderboards
  static const String leaderboards = '/leaderboards';
  static const String tournamentLeaderboard = '/tournaments/:id/leaderboard';

  // Profile
  static const String profile = '/profile';
  static const String settings = '/settings';
}
```

### 7. Configuration Constants

#### lib/core/config/app_config.dart

```dart
class AppConfig {
  // Environment-based configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://localhost:54321',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-local-dev-key',
  );

  // Feature flags
  static const bool enableDebugTools = bool.fromEnvironment(
    'ENABLE_DEBUG_TOOLS',
    defaultValue: false,
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  // App metadata
  static const String appVersion = '0.1.0';
  static const String minSupportedVersion = '0.1.0';
}
```

## Usage Examples

### Before (❌ Bad)

```dart
class ScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Hole 7',
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 8.0),
          Text('Par 4'),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            child: Text('Submit Score'),
          ),
        ],
      ),
    );
  }
}
```

### After (✅ Good)

```dart
class ScoreCard extends StatelessWidget {
  final int holeNumber;
  final int par;

  const ScoreCard({
    required this.holeNumber,
    required this.par,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UiConstants.spacingMedium),
      child: Column(
        children: [
          Text(
            '${AppStrings.hole} $holeNumber',
            style: TextStyle(fontSize: UiConstants.fontSizeTitle),
          ),
          SizedBox(height: UiConstants.spacingSmall),
          Text('${AppStrings.par} $par'),
          SizedBox(height: UiConstants.spacingMedium),
          ElevatedButton(
            onPressed: () {},
            child: Text(AppStrings.submitScore),
          ),
        ],
      ),
    );
  }
}
```

## Acceptable Exceptions

Some literal values are acceptable without constants:

1. **Loop indices**: `for (int i = 0; i < list.length; i++)`
2. **Boolean literals**: `true`, `false`
3. **Null**: `null`
4. **Empty collections**: `[]`, `{}`
5. **Simple offsets**: `index + 1`, `count - 1` (when contextually obvious)
6. **Test values**: Test-specific data can use literals for clarity

## Testing with Constants

```dart
// test/core/constants/scoring_constants_test.dart
void main() {
  group('ScoringConstants', () {
    test('stableford points are correct', () {
      expect(ScoringConstants.pointsPar, equals(2));
      expect(ScoringConstants.pointsBirdie, equals(3));
    });

    test('holes per round is 18', () {
      expect(ScoringConstants.holesPerRound, equals(18));
    });
  });
}
```

## Enforcement

**Pre-commit hook** can check for common magic values:

```bash
#!/bin/bash
# Check for common magic strings/numbers

if git diff --cached | grep -E "fontSize.*[0-9]+\\.0|padding.*[0-9]+\\.0"; then
  echo "❌ Magic numbers detected in UI code. Use UiConstants instead."
  exit 1
fi

if git diff --cached | grep -E "'(Submit|Cancel|Save)'"; then
  echo "❌ Magic strings detected. Use AppStrings instead."
  exit 1
fi
```

## Benefits Realized

- ✅ **Single source of truth**: Change spacing once, applies everywhere
- ✅ **Type safety**: Typos caught at compile time, not runtime
- ✅ **Discoverability**: IDE shows all available constants
- ✅ **Consistency**: Same values used throughout app
- ✅ **Maintainability**: Easy to update design system
- ✅ **Testability**: Mock constants for different test scenarios
- ✅ **Documentation**: Constants serve as documentation

## Remember

> If you're typing a number or string literal directly in code (outside of constants), you're probably doing it wrong.

Every literal value is a candidate for extraction to a constant!
