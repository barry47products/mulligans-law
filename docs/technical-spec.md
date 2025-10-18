# Mulligans Law - Technical Specification

## 1. Technical Architecture

### 1.1 Technology Stack

#### Frontend

- Framework: Flutter (Dart)
- State Management: flutter_bloc (BLoC pattern)
- Local Database: drift (SQLite)
- Routing: go_router
- Image Handling: cached_network_image, image_picker

#### Backend

- Platform: Supabase (open-source Firebase alternative)
- Database: PostgreSQL 15
- Authentication: Supabase Auth (GoTrue)
- File Storage: Supabase Storage (S3-compatible)
- Real-time: Supabase Realtime (WebSocket-based)
- Edge Functions: Deno/TypeScript (for complex server-side logic)

#### Development Tools

- IDE: VSCode with Claude Code
- Version Control: Git
- Local Development: Supabase CLI + Docker
- Testing: flutter_test, mockito (minimal mocking)
- Code Generation: build_runner, drift_dev
- Linting: dart analyze, flutter_lints

### 1.2 Architecture Pattern

#### Clean Architecture with Offline-First

```bash
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Screens, Widgets, BLoC/Cubit)         │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Domain Layer                    │
│  (Entities, Use Cases, Repositories)    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Data Layer                      │
│  ┌──────────────┬─────────────────┐     │
│  │ Local Data   │  Remote Data    │     │
│  │ (Drift)      │  (Supabase)     │     │
│  └──────────────┴─────────────────┘     │
│         Sync Engine                     │
└─────────────────────────────────────────┘
```

### 1.3 Project Structure

```bash
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── themes/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   ├── societies/
│   ├── courses/
│   ├── seasons/
│   ├── tournaments/
│   ├── rounds/
│   ├── scores/
│   ├── leaderboards/
│   ├── knockouts/
│   └── chat/
├── database/
│   ├── local/           # Drift database
│   └── sync/            # Sync engine
└── main.dart

test/
├── unit/
├── widget/
└── integration/

supabase/
├── migrations/
├── functions/
└── seed.sql
```

## 2. Database Design

### 2.1 Supabase (PostgreSQL) Schema

#### Core Tables

```sql
-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Societies
CREATE TABLE societies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  logo_url TEXT,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Members
CREATE TABLE members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  photo_url TEXT,
  current_handicap NUMERIC(4,1),
  role TEXT NOT NULL CHECK (role IN ('ADMIN', 'CAPTAIN', 'USER')),
  status TEXT DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(society_id, user_id)
);

-- Handicap history
CREATE TABLE handicap_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  handicap NUMERIC(4,1) NOT NULL,
  effective_date DATE NOT NULL,
  reason TEXT,
  updated_by UUID REFERENCES members(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Courses
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  society_id UUID REFERENCES societies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  location TEXT,
  holes JSONB NOT NULL, -- Array of 18 holes with par and stroke_index
  total_par INTEGER GENERATED ALWAYS AS (
    (holes->0->>'par')::int + (holes->1->>'par')::int + ...
  ) STORED,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seasons
CREATE TABLE seasons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  season_type TEXT NOT NULL CHECK (season_type IN ('REGULAR', 'KNOCKOUT')),
  enabled_leaderboard_types TEXT[] DEFAULT '{}',
  settings JSONB DEFAULT '{}', -- knockout-specific settings
  status TEXT DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'COMPLETED', 'ARCHIVED')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tournaments
CREATE TABLE tournaments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  season_id UUID REFERENCES seasons(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  enabled_leaderboard_types TEXT[] DEFAULT '{}',
  status TEXT DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'COMPLETED', 'ARCHIVED')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Competition Rounds
CREATE TABLE rounds (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  course_id UUID NOT NULL REFERENCES courses(id),
  format_type TEXT NOT NULL CHECK (format_type IN (
    'INDIVIDUAL_STROKE', 'INDIVIDUAL_STABLEFORD',
    'FOURBALL_ALLIANCE', 'FOURBALL_BETTER_BALL', 'FOURSOMES'
  )),
  status TEXT DEFAULT 'SETUP' CHECK (status IN (
    'SETUP', 'IN_PROGRESS', 'SUBMITTED', 'COMPLETED'
  )),
  requires_approval BOOLEAN DEFAULT true,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tournament-Round junction (many-to-many)
CREATE TABLE tournament_rounds (
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (tournament_id, round_id)
);

-- Round leaderboard types
CREATE TABLE round_leaderboards (
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  leaderboard_type TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (round_id, leaderboard_type)
);

-- Groups (pairings)
CREATE TABLE groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  tee_time TIME,
  players UUID[] NOT NULL,
  group_type TEXT NOT NULL CHECK (group_type IN ('INDIVIDUAL', 'PAIR', 'TEAM')),
  pivot_player_id UUID REFERENCES members(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Scores
CREATE TABLE scores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  player_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  hole_scores INTEGER[] NOT NULL CHECK (array_length(hole_scores, 1) = 18),
  hole_net_scores INTEGER[],
  hole_stableford_points INTEGER[],
  total_gross INTEGER,
  total_net INTEGER,
  total_stableford INTEGER,
  handicap_used NUMERIC(4,1) NOT NULL,
  status TEXT DEFAULT 'IN_PROGRESS' CHECK (status IN (
    'IN_PROGRESS', 'SUBMITTED', 'APPROVED', 'DISPUTED'
  )),
  submitted_at TIMESTAMPTZ,
  submitted_by UUID REFERENCES members(id),
  approved_at TIMESTAMPTZ,
  approved_by UUID REFERENCES members(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(round_id, player_id)
);

-- Team scores
CREATE TABLE team_scores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  team_players UUID[] NOT NULL,
  combined_hole_scores INTEGER[] CHECK (array_length(combined_hole_scores, 1) = 18),
  total_score INTEGER,
  status TEXT DEFAULT 'IN_PROGRESS' CHECK (status IN (
    'IN_PROGRESS', 'SUBMITTED', 'APPROVED'
  )),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Knockout matches
CREATE TABLE matches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  season_id UUID NOT NULL REFERENCES seasons(id) ON DELETE CASCADE,
  bracket_position TEXT NOT NULL,
  flight TEXT NOT NULL,
  player_1_id UUID NOT NULL REFERENCES members(id),
  player_2_id UUID NOT NULL REFERENCES members(id),
  winner_id UUID REFERENCES members(id),
  match_result TEXT,
  playoff_result TEXT,
  status TEXT DEFAULT 'SCHEDULED' CHECK (status IN (
    'SCHEDULED', 'IN_PROGRESS', 'COMPLETED'
  )),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Spot prizes
CREATE TABLE spot_prizes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  prize_type TEXT NOT NULL CHECK (prize_type IN (
    'LONGEST_DRIVE', 'CLOSEST_TO_PIN', 'CLOSEST_IN_TWO', 'CLOSEST_IN_THREE'
  )),
  hole_number INTEGER CHECK (hole_number BETWEEN 1 AND 18),
  winner_id UUID REFERENCES members(id),
  measurement NUMERIC(6,2),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Scorecard photos
CREATE TABLE scorecard_photos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  players UUID[] NOT NULL,
  photo_url TEXT NOT NULL,
  uploaded_by UUID NOT NULL REFERENCES members(id),
  uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chat messages
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  author_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  context_type TEXT NOT NULL CHECK (context_type IN ('ROUND', 'TOURNAMENT', 'SEASON')),
  context_id UUID NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_members_society ON members(society_id);
CREATE INDEX idx_members_user ON members(user_id);
CREATE INDEX idx_rounds_society_date ON rounds(society_id, date);
CREATE INDEX idx_scores_round ON scores(round_id);
CREATE INDEX idx_scores_player ON scores(player_id);
CREATE INDEX idx_scores_status ON scores(status);
CREATE INDEX idx_chat_context ON chat_messages(context_type, context_id);
CREATE INDEX idx_tournament_rounds ON tournament_rounds(tournament_id, round_id);
```

### 2.2 Row-Level Security (RLS) Policies

```sql
-- Enable RLS on all tables
ALTER TABLE societies ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
-- ... (enable on all tables)

-- Members can view societies they belong to
CREATE POLICY "Members view their societies"
  ON societies FOR SELECT
  USING (
    id IN (SELECT society_id FROM members WHERE user_id = auth.uid())
  );

-- Members can view other members in their societies
CREATE POLICY "Members view society members"
  ON members FOR SELECT
  USING (
    society_id IN (SELECT society_id FROM members WHERE user_id = auth.uid())
  );

-- Captains can create rounds
CREATE POLICY "Captains create rounds"
  ON rounds FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM members
      WHERE user_id = auth.uid()
      AND society_id = rounds.society_id
      AND role IN ('ADMIN', 'CAPTAIN')
    )
  );

-- Players can insert their own scores
CREATE POLICY "Players insert own scores"
  ON scores FOR INSERT
  WITH CHECK (
    player_id IN (SELECT id FROM members WHERE user_id = auth.uid())
  );

-- Players can update their unapproved scores
CREATE POLICY "Players update own unapproved scores"
  ON scores FOR UPDATE
  USING (
    player_id IN (SELECT id FROM members WHERE user_id = auth.uid())
    AND status = 'IN_PROGRESS'
  );

-- Captains can approve scores
CREATE POLICY "Captains approve scores"
  ON scores FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM members m
      JOIN rounds r ON r.id = scores.round_id
      WHERE m.user_id = auth.uid()
      AND m.society_id = r.society_id
      AND m.role IN ('ADMIN', 'CAPTAIN')
    )
  );

-- Members can view scores in their society
CREATE POLICY "Members view society scores"
  ON scores FOR SELECT
  USING (
    round_id IN (
      SELECT r.id FROM rounds r
      JOIN members m ON m.society_id = r.society_id
      WHERE m.user_id = auth.uid()
    )
  );
```

### 2.3 Database Functions & Triggers

```sql
-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at
CREATE TRIGGER societies_updated_at
  BEFORE UPDATE ON societies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Auto-calculate net scores and Stableford points
CREATE OR REPLACE FUNCTION calculate_net_and_stableford()
RETURNS TRIGGER AS $$
DECLARE
  course_holes JSONB;
  handicap_strokes INTEGER;
  hole_par INTEGER;
  stroke_index INTEGER;
  net_score INTEGER;
  stableford INTEGER;
  net_scores INTEGER[];
  stableford_points INTEGER[];
BEGIN
  -- Get course holes
  SELECT c.holes INTO course_holes
  FROM rounds r
  JOIN courses c ON c.id = r.course_id
  WHERE r.id = NEW.round_id;

  -- Calculate for each hole
  FOR i IN 1..18 LOOP
    hole_par := (course_holes->>(i-1)->>'par')::INTEGER;
    stroke_index := (course_holes->>(i-1)->>'stroke_index')::INTEGER;

    -- Determine if player gets stroke on this hole
    handicap_strokes := CASE
      WHEN stroke_index <= NEW.handicap_used THEN 1
      ELSE 0
    END;

    -- Calculate net score
    net_score := NEW.hole_scores[i] - handicap_strokes;
    net_scores := array_append(net_scores, net_score);

    -- Calculate Stableford points
    stableford := CASE
      WHEN net_score >= hole_par + 2 THEN 0
      WHEN net_score = hole_par + 1 THEN 1
      WHEN net_score = hole_par THEN 2
      WHEN net_score = hole_par - 1 THEN 3
      WHEN net_score = hole_par - 2 THEN 4
      WHEN net_score <= hole_par - 3 THEN 5
    END;
    stableford_points := array_append(stableford_points, stableford);
  END LOOP;

  -- Update calculated fields
  NEW.hole_net_scores := net_scores;
  NEW.hole_stableford_points := stableford_points;
  NEW.total_gross := (SELECT SUM(s) FROM unnest(NEW.hole_scores) s);
  NEW.total_net := (SELECT SUM(s) FROM unnest(net_scores) s);
  NEW.total_stableford := (SELECT SUM(s) FROM unnest(stableford_points) s);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_score_values
  BEFORE INSERT OR UPDATE ON scores
  FOR EACH ROW
  WHEN (NEW.hole_scores IS NOT NULL)
  EXECUTE FUNCTION calculate_net_and_stableford();
```

### 2.4 Local Database (Drift) Schema

```dart
// lib/database/local/database.dart
import 'package:drift/drift.dart';

// Mirror remote schema for offline capability
@DataClassName('LocalScore')
class LocalScores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().nullable()(); // UUID from Supabase
  TextColumn get roundId => text()();
  TextColumn get groupId => text()();
  TextColumn get playerId => text()();
  TextColumn get holeScores => text()(); // JSON array
  TextColumn get holeNetScores => text().nullable()();
  TextColumn get holeStablefordPoints => text().nullable()();
  IntColumn get totalGross => integer().nullable()();
  IntColumn get totalNet => integer().nullable()();
  IntColumn get totalStableford => integer().nullable()();
  RealColumn get handicapUsed => real()();
  TextColumn get status => text()();
  DateTimeColumn get submittedAt => dateTime().nullable()();
  TextColumn get submittedBy => text().nullable()();
  DateTimeColumn get approvedAt => dateTime().nullable()();
  TextColumn get approvedBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
}

// Similar tables for other entities needed offline
@DataClassName('LocalRound')
class LocalRounds extends Table {
  // ...
}

@DataClassName('LocalCourse')
class LocalCourses extends Table {
  // ...
}

// Sync queue
@DataClassName('SyncQueueItem')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()(); // CREATE, UPDATE, DELETE
  TextColumn get tableName => text()();
  TextColumn get entityId => text()();
  TextColumn get payload => text()(); // JSON
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}
```

## 3. Application Architecture

### 3.1 State Management (BLoC Pattern)

```dart
// Example: Score Capture BLoC

// Events
abstract class ScoreCaptureEvent {}
class LoadRound extends ScoreCaptureEvent {
  final String roundId;
  LoadRound(this.roundId);
}
class UpdateHoleScore extends ScoreCaptureEvent {
  final int holeNumber;
  final int score;
  UpdateHoleScore(this.holeNumber, this.score);
}
class SubmitScore extends ScoreCaptureEvent {}

// States
abstract class ScoreCaptureState {}
class ScoreCaptureInitial extends ScoreCaptureState {}
class ScoreCaptureLoading extends ScoreCaptureState {}
class ScoreCaptureLoaded extends ScoreCaptureState {
  final Round round;
  final Score currentScore;
  final int currentHole;
  ScoreCaptureLoaded(this.round, this.currentScore, this.currentHole);
}
class ScoreCaptureError extends ScoreCaptureState {
  final String message;
  ScoreCaptureError(this.message);
}

// BLoC
class ScoreCaptureBloc extends Bloc<ScoreCaptureEvent, ScoreCaptureState> {
  final GetRoundUseCase getRound;
  final UpdateScoreUseCase updateScore;
  final SubmitScoreUseCase submitScore;

  ScoreCaptureBloc({
    required this.getRound,
    required this.updateScore,
    required this.submitScore,
  }) : super(ScoreCaptureInitial()) {
    on<LoadRound>(_onLoadRound);
    on<UpdateHoleScore>(_onUpdateHoleScore);
    on<SubmitScore>(_onSubmitScore);
  }

  Future<void> _onLoadRound(
    LoadRound event,
    Emitter<ScoreCaptureState> emit,
  ) async {
    emit(ScoreCaptureLoading());
    try {
      final round = await getRound(event.roundId);
      final score = await _getOrCreateScore(round);
      emit(ScoreCaptureLoaded(round, score, 0));
    } catch (e) {
      emit(ScoreCaptureError(e.toString()));
    }
  }

  // ...
}
```

### 3.2 Repository Pattern

```dart
// Domain layer
abstract class ScoreRepository {
  Future<Score> getScore(String id);
  Future<List<Score>> getScoresByRound(String roundId);
  Future<Score> createScore(Score score);
  Future<Score> updateScore(Score score);
  Future<void> submitScore(String scoreId);
  Stream<List<Score>> watchRoundScores(String roundId);
}

// Data layer implementation
class ScoreRepositoryImpl implements ScoreRepository {
  final SupabaseClient supabase;
  final LocalDatabase localDb;
  final SyncEngine syncEngine;

  ScoreRepositoryImpl({
    required this.supabase,
    required this.localDb,
    required this.syncEngine,
  });

  @override
  Future<Score> createScore(Score score) async {
    // Write to local database first (offline-first)
    final localScore = await localDb.into(localDb.localScores).insert(
      LocalScoresCompanion.insert(
        roundId: score.roundId,
        playerId: score.playerId,
        // ...
      ),
    );

    // Queue for sync
    await syncEngine.queueAction(
      SyncAction.create(
        table: 'scores',
        data: score.toJson(),
      ),
    );

    // Attempt immediate sync if online
    syncEngine.sync();

    return score;
  }

  @override
  Stream<List<Score>> watchRoundScores(String roundId) {
    // Real-time subscription from Supabase
    return supabase
        .from('scores')
        .stream(primaryKey: ['id'])
        .eq('round_id', roundId)
        .order('player_id')
        .map((data) => data.map((json) => Score.fromJson(json)).toList());
  }

  // ...
}
```

### 3.3 Use Cases (Business Logic)

```dart
// Single responsibility use cases
class SubmitScoreUseCase {
  final ScoreRepository repository;

  SubmitScoreUseCase(this.repository);

  Future<void> call(String scoreId) async {
    // Business logic
    final score = await repository.getScore(scoreId);

    // Validation
    if (!_isComplete(score)) {
      throw IncompleteScoreException('All 18 holes must be filled');
    }

    // Update status
    final updatedScore = score.copyWith(
      status: ScoreStatus.submitted,
      submittedAt: DateTime.now(),
    );

    await repository.updateScore(updatedScore);
  }

  bool _isComplete(Score score) {
    return score.holeScores.length == 18 &&
           score.holeScores.every((s) => s > 0);
  }
}
```

### 3.4 Sync Engine

```dart
class SyncEngine {
  final SupabaseClient supabase;
  final LocalDatabase localDb;
  final Connectivity connectivity;

  Future<void> sync() async {
    if (!await _isOnline()) return;

    // Get unsynced items
    final queue = await localDb.select(localDb.syncQueue)
      .where((q) => q.completed.equals(false))
      .get();

    for (final item in queue) {
      try {
        await _syncItem(item);

        // Mark as completed
        await (localDb.update(localDb.syncQueue)
          ..where((q) => q.id.equals(item.id)))
          .write(SyncQueueCompanion(completed: Value(true)));

      } catch (e) {
        // Increment retry count
        await (localDb.update(localDb.syncQueue)
          ..where((q) => q.id.equals(item.id)))
          .write(SyncQueueCompanion(
            retryCount: Value(item.retryCount + 1),
          ));

        // Give up after 5 retries
        if (item.retryCount >= 5) {
          _handleSyncFailure(item, e);
        }
      }
    }
  }

  Future<void> _syncItem(SyncQueueItem item) async {
    final payload = jsonDecode(item.payload);

    switch (item.action) {
      case 'CREATE':
        final result = await supabase
          .from(item.tableName)
          .insert(payload)
          .select()
          .single();

        // Update local record with remote ID
        await _updateLocalRecordId(item.tableName, item.entityId, result['id']);
        break;

      case 'UPDATE':
        await supabase
          .from(item.tableName)
          .update(payload)
          .eq('id', item.entityId);
        break;

      case 'DELETE':
        await supabase
          .from(item.tableName)
          .delete()
          .eq('id', item.entityId);
        break;
    }
  }

  Future<bool> _isOnline() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // ...
}
```

## 4. Testing Strategy

### 4.1 Test-Driven Development (TDD)

#### Approach: Red-Green-Refactor

1. **Red**: Write failing test first
2. **Green**: Write minimal code to pass
3. **Refactor**: Improve code quality

#### Test Pyramid

```bash
      ╱╲
     ╱  ╲      E2E Tests (10%)
    ╱────╲
   ╱      ╲    Integration Tests (20%)
  ╱────────╲
 ╱          ╲  Unit Tests (70%)
╱────────────╲
```

### 4.2 Unit Tests

```dart
// test/features/scores/domain/usecases/submit_score_test.dart

void main() {
  late SubmitScoreUseCase useCase;
  late MockScoreRepository mockRepository;

  setUp(() {
    mockRepository = MockScoreRepository();
    useCase = SubmitScoreUseCase(mockRepository);
  });

  group('SubmitScoreUseCase', () {
    test('should submit complete score successfully', () async {
      // Arrange
      final score = Score(
        id: '1',
        roundId: 'round1',
        playerId: 'player1',
        holeScores: List.filled(18, 4), // Complete score
        status: ScoreStatus.inProgress,
      );

      when(mockRepository.getScore('1')).thenAnswer((_) async => score);
      when(mockRepository.updateScore(any)).thenAnswer((_) async => score);

      // Act
      await useCase('1');

      // Assert
      verify(mockRepository.getScore('1')).called(1);
      verify(mockRepository.updateScore(
        argThat(predicate<Score>((s) => s.status == ScoreStatus.submitted))
      )).called(1);
    });

    test('should throw exception for incomplete score', () async {
      // Arrange
      final score = Score(
        id: '1',
        roundId: 'round1',
        playerId: 'player1',
        holeScores: List.filled(10, 4), // Only 10 holes
        status: ScoreStatus.inProgress,
      );

      when(mockRepository.getScore('1')).thenAnswer((_) async => score);

      // Act & Assert
      expect(
        () => useCase('1'),
        throwsA(isA<IncompleteScoreException>()),
      );

      verifyNever(mockRepository.updateScore(any));
    });
  });
}
```

### 4.3 Widget Tests

```dart
// test/features/scores/presentation/widgets/score_card_test.dart

void main() {
  testWidgets('ScoreCard displays hole information correctly', (tester) async {
    // Arrange
    const hole = 1;
    const par = 4;
    const strokeIndex = 3;
    const score = 5;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ScoreCard(
          hole: hole,
          par: par,
          strokeIndex: strokeIndex,
          score: score,
          onScoreChanged: (_) {},
        ),
      ),
    );

    // Assert
    expect(find.text('Hole 1'), findsOneWidget);
    expect(find.text('Par 4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('ScoreCard allows score input', (tester) async {
    // Arrange
    int? capturedScore;

    await tester.pumpWidget(
      MaterialApp(
        home: ScoreCard(
          hole: 1,
          par: 4,
          strokeIndex: 3,
          score: 0,
          onScoreChanged: (s) => capturedScore = s,
        ),
      ),
    );

    // Act
    await tester.tap(find.text('4'));
    await tester.pump();

    // Assert
    expect(capturedScore, equals(4));
  });
}
```

### 4.4 Integration Tests

```dart
// integration_test/score_submission_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete score submission flow', (tester) async {
    // Start app
    await tester.pumpWidget(MyApp());

    // Login
    await tester.enterText(find.byType(EmailField), 'test@example.com');
    await tester.enterText(find.byType(PasswordField), 'password');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Navigate to active round
    await tester.tap(find.text('Active Rounds'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Today\'s Round'));
    await tester.pumpAndSettle();

    // Enter scores for all 18 holes
    for (int i = 1; i <= 18; i++) {
      await tester.tap(find.text('$i'));
      await tester.pump();

      if (i < 18) {
        await tester.drag(find.byType(ScoreCard), Offset(-300, 0));
        await tester.pumpAndSettle();
      }
    }

    // Submit
    await tester.tap(find.text('Submit Score'));
    await tester.pumpAndSettle();

    // Verify success message
    expect(find.text('Score submitted successfully'), findsOneWidget);
  });
}
```

### 4.5 Mocking Strategy

#### Minimal Mocking Principle

- Only mock external dependencies (API, database)
- Don't mock domain entities or value objects
- Don't mock simple data classes
- Prefer real objects when possible

```dart
// Good: Mock repository (external dependency)
class MockScoreRepository extends Mock implements ScoreRepository {}

// Bad: Don't mock entities
// class MockScore extends Mock implements Score {} // DON'T DO THIS

// Good: Use real entities
final score = Score(
  id: '1',
  roundId: 'round1',
  // ... real data
);
```

## 5. API Contracts

### 5.1 Supabase Client Usage

```dart
// Fetch with relations
final rounds = await supabase
  .from('rounds')
  .select('''
    *,
    course:courses(*),
    groups:groups(*),
    scores:scores(*)
  ''')
  .eq('society_id', societyId)
  .order('date', ascending: false);

// Insert with return
final newRound = await supabase
  .from('rounds')
  .insert({
    'society_id': societyId,
    'date': date.toIso8601String(),
    'course_id': courseId,
    'format_type': 'INDIVIDUAL_STABLEFORD',
  })
  .select()
  .single();

// Real-time subscription
final subscription = supabase
  .from('scores')
  .stream(primaryKey: ['id'])
  .eq('round_id', roundId)
  .order('total_stableford', ascending: false)
  .listen((scores) {
    // Update UI
  });

// Cleanup
subscription.cancel();
```

### 5.2 Error Handling

```dart
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException(String message) : super(message, 'AUTH_ERROR');
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, 'VALIDATION_ERROR');
}

// Usage in repository
try {
  final result = await supabase.from('scores').insert(data);
} on PostgrestException catch (e) {
  if (e.code == '23505') { // Unique violation
    throw ValidationException('Score already exists for this round');
  }
  throw AppException(e.message, e.code);
} on SocketException {
  throw NetworkException('No internet connection');
}
```

## 6. Performance Optimization

### 6.1 Database Optimization

#### Indexes

- Created on foreign keys
- Created on frequently queried columns
- Composite indexes for complex queries

#### Query Optimization

- Use select() to fetch only needed columns
- Use joins instead of multiple queries
- Pagination for large result sets

### 6.2 Client-Side Optimization

#### Lazy Loading

```dart
ListView.builder(
  itemCount: scores.length,
  itemBuilder: (context, index) {
    return ScoreListItem(score: scores[index]);
  },
);
```

#### Caching

```dart
// Cache network images
CachedNetworkImage(
  imageUrl: photoUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);
```

#### Debouncing

```dart
Timer? _debounce;

void _onSearchChanged(String query) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    _performSearch(query);
  });
}
```

### 6.3 Offline Performance

- Prioritize local database reads
- Sync in background
- Optimistic UI updates
- Queue writes for later

## 7. Security Considerations

### 7.1 Authentication

- JWT tokens stored securely
- Automatic token refresh
- Secure session management

### 7.2 Authorization

- Row-level security enforced at database
- Role-based access control
- Client-side role checks for UI only

### 7.3 Data Protection

- HTTPS for all API calls
- Encrypted local database (optional)
- No sensitive data in logs

## 8. Deployment

### 8.1 Development Environment

- Local Supabase via Docker
- Hot reload for rapid development
- Debug builds only

### 8.2 Staging Environment

- Supabase staging project
- Beta testing builds
- Feature flags enabled

### 8.3 Production Environment

- Supabase production project
- App Store / Play Store releases
- Feature flags for gradual rollout

## 9. Monitoring & Analytics

### 9.1 Error Tracking

- Sentry or Firebase Crashlytics
- Error logs with context
- User feedback mechanism

### 9.2 Performance Monitoring

- App launch time
- API response times
- Sync success rates
- Crash-free rate

### 9.3 Usage Analytics

- Feature usage tracking
- User engagement metrics
- Retention rates

## 10. Development Workflow

### 10.1 Git Strategy (Trunk-Based Development)

#### Branch Structure

```bash
main (protected, long-lived, deployable)
  ↑
feature/task-name (short-lived, < 1 day)
```

#### Principles

- Main branch is always deployable
- One task at a time (no parallel feature branches)
- Small, frequent commits during development
- Squash merge to main (clean history)
- Feature branches integrate per complete task (one PR = one task from TASKS.md)

### 10.2 Commit Guidelines

#### Format: Conventional Commits

```bash
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

#### Types

- `feat`: New feature
- `fix`: Bug fix
- `test`: Add or update tests
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `style`: Code formatting
- `perf`: Performance improvements
- `chore`: Build, dependencies, tooling
- `ci`: CI/CD pipeline changes

#### Examples

```bash
git commit -m "test: add failing test for score submission"
git commit -m "feat(scores): implement score submission"
git commit -m "refactor(leaderboards): extract calculator to service"
git commit -m "fix(sync): handle offline queue correctly"
git commit -m "docs: update API documentation"
git commit -m "chore: bump supabase_flutter to 2.1.0"
```

#### Commit Frequency

- Commit after each TDD cycle (test passes)
- Commit multiple times per hour during active development
- Each commit should leave tests passing
- Push to remote frequently (at least daily, ideally more)

#### Commit Hooks

- Pre-commit: Format code (`dart format`)
- Pre-commit: Validate commit message format
- Pre-commit: Run quick tests (optional)

### 10.3 Branch Workflow

#### Starting a Task

```bash
# Always start from latest main
git checkout main
git pull origin main

# Create feature branch (named after task)
git checkout -b feat/score-capture-ui
```

#### During Development

```bash
# Work in small TDD cycles
git commit -m "test: add widget test for score card"
git commit -m "feat: create score card widget"
git commit -m "test: add swipe navigation test"
git commit -m "feat: implement swipe navigation"
git commit -m "refactor: extract score input to component"

# Push frequently (backup + triggers CI)
git push origin feat/score-capture-ui
```

#### Completing Task

```bash
# Ensure all tests pass locally
flutter test
flutter analyze

# Create Pull Request (even solo dev)
# GitHub Actions runs CI automatically

# After PR approval (can be self-approved)
# Squash and merge to main via GitHub UI
# This creates clean main history with one commit per task

# Delete feature branch
git branch -d feat/score-capture-ui
git push origin --delete feat/score-capture-ui
```

### 10.4 Semantic Versioning

**Version Format:** `MAJOR.MINOR.PATCH`

#### Pre-release (v0.x.x)

- v0.1.0 - Initial setup complete
- v0.2.0 - Authentication working
- v0.3.0 - Score capture complete
- v0.x.x - Development continues

#### Production (v1.0.0+)

- v1.0.0 - MVP complete, first production release
- v1.1.0 - New feature added
- v1.1.1 - Bug fix

#### Automated Version Bumping (Option C)

- `feat:` commits → MINOR bump (v0.1.0 → v0.2.0)
- `fix:` commits → PATCH bump (v0.1.0 → v0.1.1)
- `feat!:` or `BREAKING CHANGE:` → MAJOR bump (v0.9.0 → v1.0.0)
- Automated via semantic-release on merge to main

#### Tagging

```bash
# Automated via GitHub Actions after merge to main
# Tag format: v0.2.0
# Creates GitHub Release with changelog
```

### 10.5 Continuous Integration (CI/CD)

#### GitHub Actions Pipeline

##### CI Pipeline (On Every Push)

Runs on: Every push to any branch, all PRs

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest # macOS for iOS builds

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: "stable" # Latest stable Flutter
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --set-exit-if-changed .

      - name: Analyze code
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
          fail_ci_if_error: false # Report only, don't fail

      - name: Check coverage threshold
        run: |
          # Phase 1 (P0): Report only
          # Phase 2 (P1): Enforce 70%
          # Phase 3 (P2+): Enforce 80%
          # Script checks coverage and fails if below threshold

      - name: Build Android APK (debug)
        run: flutter build apk --debug

      - name: Build iOS (no codesign)
        run: flutter build ios --no-codesign --debug
```

##### CD Pipeline (On Merge to Main)

Runs on: Merge to main branch

```yaml
name: Deploy to Staging

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: macos-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0 # Full history for semantic-release

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: "stable"
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Build iOS (release)
        run: flutter build ipa --release

      - name: Upload to TestFlight
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/ipa/*.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}

      - name: Semantic Release (Auto-versioning)
        uses: cycjimmy/semantic-release-action@v3
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          extra_plugins: |
            @semantic-release/changelog
            @semantic-release/git

      - name: Create GitHub Release
        # Automated via semantic-release
        # Generates changelog from conventional commits
```

#### Environments

- **Local Development**: Supabase CLI + Docker (`supabase start`)
- **Staging (Future)**: Separate Supabase project + TestFlight
- **Production (Future)**: Production Supabase + App Store

#### Database Migrations

- Local: `supabase db reset` applies all migrations
- Staging/Production: `supabase db push` (manual for now, automate later)

### 10.6 Code Coverage Strategy

#### Phased Approach

##### Phase 1: P0 Tasks (Foundation)

- Report coverage, don't enforce
- Visibility without build failures
- Learn realistic baselines
- Target: >70% informally

##### Phase 2: P1 Tasks (Core Features)

- Enforce 70% threshold
- Build fails if coverage drops below 70%
- Exceptions allowed via `// coverage:ignore-file`
- Focus on business logic coverage

##### Phase 3: P2+ Tasks (Polish)

- Increase to 80% threshold
- Industry standard for production code
- Exclude UI-only widgets, generated files

#### Coverage Exclusions

```yaml
# .coveragerc or in test scripts
exclude:
  - "**/*.g.dart" # Generated code
  - "**/*.freezed.dart" # Freezed generated
  - "**/main.dart" # App entry point
  - "lib/core/theme/**" # Theme definitions
  - "lib/core/constants/**" # Constants only
```

#### Coverage Reports

- Visible in GitHub PR checks
- Uploaded to Codecov for tracking
- Trend monitoring over time

### 10.7 Branch Protection Rules

#### Main Branch Protection

- Require pull request reviews: Yes (self-review allowed)
- Require status checks: Yes
  - CI / test
  - CI / analyze
  - CI / build
- Require branches up to date: Yes
- Include administrators: Yes (even solo, forces discipline)
- Allow force pushes: No
- Allow deletions: No

### 10.8 Pull Request Process

#### Creating PR

1. Complete task from TASKS.md
2. Ensure all tests pass locally
3. Update Docusaurus documentation (if API/feature changes)
4. Push feature branch
5. Create PR via GitHub UI
6. Fill PR template (see below)
7. Wait for CI to complete
8. Review own code (yes, even solo)
9. Merge via "Squash and merge"

#### PR Template

```markdown
## Task

Closes #[task-number]

## Changes

- Brief description of changes
- Key implementation details

## Testing

- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests pass (if applicable)
- [ ] Tested on iOS device/simulator
- [ ] No linting errors
- [ ] TDD approach followed

## Documentation

- [ ] Docusaurus docs updated (if API/feature changes)
- [ ] README.md updated (if setup changes)
- [ ] Code comments added for complex logic
- [ ] CHANGELOG.md will auto-update via semantic-release

## Screenshots (if UI changes)

[Add screenshots here]

## Notes

Any special considerations or decisions made
```

### 10.9 Code Review Checklist

Before merging PR:

- [ ] All CI checks pass (green)
- [ ] Tests written first (TDD)
- [ ] Minimum mocking (only external dependencies)
- [ ] Clean architecture maintained
- [ ] No linting warnings
- [ ] Code formatted properly
- [ ] Documentation updated (if API changes)
- [ ] Coverage threshold met
- [ ] Tested on device (not just simulator)
- [ ] Commit messages follow conventional format
- [ ] No debug code or console logs

### 10.10 Definition of Done

A task is done when:

- [ ] All acceptance criteria met
- [ ] Tests written and passing
- [ ] Code follows clean architecture
- [ ] PR created and reviewed
- [ ] CI passes
- [ ] Coverage threshold met
- [ ] Squash merged to main
- [ ] Feature branch deleted
- [ ] Deployed to staging (if applicable)
- [ ] Verified working on device
- [ ] Documentation updated
- [ ] TASKS.md status updated to [X]

### 10.11 AI-Assisted Development Notes

#### Using Claude Code

- Claude Code suggests/writes code
- Human reviews and commits
- Commits attributed to human developer only
- No special AI attribution in commit messages

#### README Note

```markdown
## Development

This project uses AI-assisted development tools including Claude Code
for implementation assistance while maintaining human oversight and
decision-making for all code changes.
```

## 11. Documentation Strategy

### 11.1 Documentation Architecture

#### Repository Documentation (Markdown)

- README.md - Quick start and setup
- CONTRIBUTING.md - Contribution guidelines
- CHANGELOG.md - Auto-generated release notes
- Functional Spec, Technical Spec, CLAUDE.md, TASKS.md

#### Docusaurus Documentation Site

- Living technical documentation
- API reference
- Architecture guides
- User guides (future: for app users)
- Development tutorials

#### In-Code Documentation

- Inline comments for complex logic
- Dart doc comments for public APIs
- README per feature module

### 11.2 Docusaurus Structure

```bash
docs-technical/
├── docs/
│   ├── intro.md
│   ├── getting-started/
│   │   ├── installation.md
│   │   ├── local-development.md
│   │   └── first-contribution.md
│   ├── architecture/
│   │   ├── overview.md
│   │   ├── clean-architecture.md
│   │   ├── offline-first.md
│   │   └── database-design.md
│   ├── features/
│   │   ├── authentication.md
│   │   ├── score-capture.md
│   │   ├── leaderboards.md
│   │   └── tournaments.md
│   ├── api/
│   │   ├── repositories.md
│   │   ├── use-cases.md
│   │   └── blocs.md
│   ├── testing/
│   │   ├── tdd-approach.md
│   │   ├── unit-testing.md
│   │   └── integration-testing.md
│   └── deployment/
│       ├── ci-cd.md
│       └── releasing.md
├── blog/
│   └── YYYY-MM-DD-post-name.md
├── src/
│   └── pages/
├── static/
│   └── img/
├── docusaurus.config.js
└── package.json
```

### 11.3 Documentation Workflow

#### When to Update Documentation

1. **New Feature** → Update feature docs
2. **API Change** → Update API reference
3. **Architecture Change** → Update architecture docs
4. **Setup Change** → Update getting started
5. **Bug Fix** → Usually no doc update needed

#### Documentation PR Checklist

- [ ] Feature documented in docs-technical/docs/features/
- [ ] API changes reflected in docs-technical/docs/api/
- [ ] Examples updated
- [ ] Screenshots added (if UI changes)
- [ ] Navigation updated (sidebar)

### 11.4 Docusaurus Deployment

**Hosting:** GitHub Pages

#### Deployment Pipeline

```yaml
# On merge to main, after app deployment
name: Deploy Docs

on:
  push:
    branches: [main]
    paths:
      - "docs-technical/**"
      - "docusaurus.config.js"

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 18

      - name: Install dependencies
        run: |
          cd docs-technical
          npm ci

      - name: Build
        run: |
          cd docs-technical
          npm run build

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs-technical/build
```

**URL:** `https://YOUR_USERNAME.github.io/golf-society-app/`

### 11.5 Documentation Standards

#### Writing Style

- Clear, concise, active voice
- Code examples for every concept
- Step-by-step tutorials
- Visual diagrams where helpful

#### Code Examples

- Complete, runnable examples
- Syntax highlighting
- Inline comments
- Link to full source

#### Maintenance

- Review docs on every major release
- Flag outdated content
- Update examples to match current code

### 11.6 Documentation Examples

#### Feature Documentation Template

```markdown
# Score Capture

## Overview

Brief description of the feature.

## User Flow

1. Step-by-step user journey
2. Screenshots at each step

## Technical Implementation

### Architecture

Diagram showing components

### Key Classes

- `ScoreCaptureBloc` - State management
- `ScoreRepository` - Data access
- `CalculateScoreUseCase` - Business logic

### Example Usage

\`\`\`dart
// Code example
\`\`\`

## Testing

How to test this feature

## Troubleshooting

Common issues and solutions
```

## 12. Emergency Procedures

### 12.1 Hotfix Process

#### Critical Bug in Production (Future)

```bash
# Identify bug in production
git checkout main
git checkout -b hotfix/critical-bug-description

# Fix, test, commit
git commit -m "fix!: resolve critical data loss issue"

# Create PR with HOTFIX label
# Expedite review
# Merge with fast-track approval
# Auto-deploys to production

# Version automatically bumps (PATCH or MAJOR if breaking)
```

### 12.2 Rolling Back

#### Revert Single Commit

```bash
# Identify problematic commit
git checkout main
git revert <commit-hash>
git push origin main
```

#### Revert to Previous Release

```bash
# Identify last good release
git checkout v0.5.0
git checkout -b revert-to-stable

# Create PR to make this main
# Documents rollback reason
# Merge to main
```

### 12.3 Database Migration Rollback

#### Local Development

```bash
# Reset to specific migration
supabase db reset --version YYYYMMDDHHMMSS
```

#### Production (Manual)

```sql
-- Create down migration
-- Apply manually with caution
-- Test thoroughly before applying
```

#### Hotfix Process

```bash
# Critical bug in production (future)
git checkout main
git checkout -b hotfix/critical-bug-description

# Fix, test, commit
git commit -m "fix!: resolve critical data loss issue"

# Create PR, expedite review
# Merge with fast-track approval
# Auto-deploys to production

# Version automatically bumps (PATCH)
```

#### Rolling Back

```bash
# Identify problematic commit/tag
git checkout main
git revert <commit-hash>
git push origin main

# Or revert to previous tag
git checkout v0.5.0
git checkout -b revert-to-stable
# Create PR to make this main
```
