# Mulligans Law - Task Kanban Board

## How to Use This Document

**Status Indicators:**

- `[ ]` = To Do
- `[>]` = In Progress
- `[T]` = Testing
- `[X]` = Done

**Priority Levels:**

- P0 = Critical (blocks other work)
- P1 = High (core features)
- P2 = Medium (important features)
- P3 = Low (nice to have)

**Task Format:**

```bash
[Status] Task Name (Priority) #tags
  - Acceptance criteria
  - Test requirements
```

---

## P0: Foundation & Setup

### Project Initialization

- [X] **Initialize Flutter Project** (P0) #setup

  - [X] Create Flutter project structure (lib/, test/, android/, ios/)
  - [X] Configure for iOS and Android
  - [X] Set up basic app structure (Clean Architecture folders)
  - [X] Create welcome screen with golf theme
  - [X] Tests: Project compiles successfully ✅

- [ ] **Configure Dependencies** (P0) #setup

  - Add supabase_flutter
  - Add drift and drift_flutter
  - Add flutter_bloc
  - Add testing dependencies (mockito, bloc_test)
  - Add image_picker, cached_network_image
  - Tests: All dependencies resolve

- [ ] **Set Up Git Repository** (P0) #setup #git

  - Initialize git repository
  - Create .gitignore (Flutter + sensitive files)
  - Create README.md with AI assistance note
  - Create initial commit
  - Tests: Repository initialized

- [ ] **Configure Git Commit Hooks** (P0) #setup #git

  - Install husky or similar
  - Pre-commit: dart format
  - Pre-commit: validate commit message (conventional commits)
  - Pre-commit: run quick tests (optional)
  - Tests: Hooks prevent bad commits

- [ ] **Create GitHub Repository** (P0) #setup #git

  - Create remote repository
  - Push initial code
  - Configure branch protection for main
  - Tests: Remote repository accessible

- [ ] **Set Up GitHub Actions - CI Pipeline** (P0) #setup #ci

  - Create .github/workflows/ci.yml
  - Configure: checkout, Flutter setup, dependencies
  - Add: format check, analyze, tests, coverage
  - Add: build Android APK and iOS (no codesign)
  - Tests: CI runs successfully on push

- [ ] **Set Up GitHub Actions - CD Pipeline** (P0) #setup #ci

  - Create .github/workflows/deploy.yml
  - Configure: runs on merge to main
  - Add: semantic-release for auto-versioning
  - Add: TestFlight upload (placeholder)
  - Tests: CD runs successfully on merge

- [ ] **Configure Codecov** (P0) #setup #ci

  - Sign up for Codecov
  - Add repository
  - Configure in CI pipeline
  - Set coverage reporting (no enforcement initially)
  - Tests: Coverage reports appear in PRs

- [X] **Create PR Template** (P0) #setup #git

  - [X] Create .github/pull_request_template.md
  - [X] Include: task reference, changes, testing checklist
  - [X] Tests: Template appears on new PRs ✅

- [X] **Create Issue Templates** (P0) #setup #git

  - [X] Bug report template
  - [X] Feature request template
  - [X] Task template (from TASKS.md)
  - [X] Tests: Templates appear when creating issues ✅

- [X] **Initialize Supabase Local Development** (P0) #setup #database

  - [X] Run `supabase init`
  - [X] Configure local Supabase
  - [X] Verify Docker containers start
  - [X] Document local setup process (docs/SUPABASE_LOCAL_SETUP.md)
  - [X] Tests: `supabase start` succeeds ✅

- [ ] **Create Initial Database Migration** (P0) #database

  - Enable UUID extension
  - Create societies table with RLS
  - Create members table with RLS
  - Create updated_at trigger
  - Tests: Migration applies successfully

- [ ] **Set Up Testing Infrastructure** (P0) #testing

  - Configure test directory structure
  - Set up mock factories
  - Create test helpers
  - Configure coverage exclusions
  - Tests: Sample tests run successfully

- [X] **Create Development Documentation** (P0) #setup #docs

  - [X] Update README.md with comprehensive setup instructions
  - [X] Document Git workflow (trunk-based development)
  - [X] Document CI/CD pipeline (CI and CD workflows)
  - [X] Document local Supabase setup (detailed steps with verification)
  - [X] Add AI assistance note to README (at top of file)
  - [X] Tests: Another developer could onboard from README ✅

- [X] **Initialize Docusaurus** (P0) #setup #docs

  - Install Docusaurus in /docs-technical directory (see docs/DOCUSAURUS_SETUP.md)
  - Configure docusaurus.config.ts (TypeScript)
  - Set up basic structure (getting-started, architecture, features, api, testing, deployment)
  - Create intro page and installation guide
  - Tests: Site builds and runs locally ✅

- [X] **Set Up Docusaurus Deployment** (P0) #setup #docs #ci

  - Create .github/workflows/deploy-docs.yml
  - Configure GitHub Pages (ready for first deployment)
  - Set up automatic deployment on docs changes
  - Tests: Workflow created, will deploy on first push to main

- [>] **Create Initial Documentation** (P0) #setup #docs
  - [X] Getting Started guide (installation page created)
  - [ ] Architecture overview (structure ready, content pending)
  - [ ] Development workflow (can reference WORKFLOW.md)
  - [ ] Testing strategy (can reference CLAUDE.md TDD section)
  - Tests: Documentation is accurate and helpful

---

## P0: Authentication

### Basic Auth Flow

- [ ] **Create Auth Data Layer** (P0) #auth #tdd

  - Define AuthRepository interface (domain)
  - Implement AuthRepositoryImpl with Supabase (data)
  - Write unit tests for repository
  - Tests: Sign up, sign in, sign out, session management

- [ ] **Create Auth Use Cases** (P0) #auth #tdd

  - SignInUseCase
  - SignUpUseCase
  - SignOutUseCase
  - GetCurrentUserUseCase
  - Tests: Business logic for each use case

- [ ] **Create Auth BLoC** (P0) #auth #tdd

  - Define AuthEvent and AuthState
  - Implement AuthBloc
  - Write BLoC tests
  - Tests: State transitions for all events

- [ ] **Create Login Screen** (P0) #auth #ui

  - Email and password fields
  - Sign in button
  - Navigate to sign up
  - Error messaging
  - Tests: Widget tests for interactions

- [ ] **Create Sign Up Screen** (P0) #auth #ui

  - Email and password fields
  - Confirm password field
  - Sign up button
  - Navigate to login
  - Tests: Widget tests for validation

- [ ] **Wire Up Auth Navigation** (P0) #auth #ui
  - StreamBuilder on auth state
  - Navigate to home when authenticated
  - Navigate to login when not authenticated
  - Tests: Integration test for auth flow

---

## P1: Society Management

### Create & Manage Societies

- [ ] **Create Society Data Layer** (P1) #societies #tdd

  - Define SocietyRepository interface
  - Implement with Supabase
  - Write unit tests
  - Tests: CRUD operations, RLS policies work

- [ ] **Create Society Use Cases** (P1) #societies #tdd

  - CreateSocietyUseCase
  - GetUserSocietiesUseCase
  - UpdateSocietyUseCase
  - Tests: Business logic validation

- [ ] **Create Society BLoC** (P1) #societies #tdd

  - Define events and states
  - Implement bloc
  - Write bloc tests
  - Tests: State management verified

- [ ] **Create Society List Screen** (P1) #societies #ui

  - Display user's societies
  - Navigate to society details
  - Create new society button
  - Tests: Widget tests

- [ ] **Create Society Form Screen** (P1) #societies #ui
  - Society name input
  - Logo upload (placeholder initially)
  - Save button
  - Validation
  - Tests: Widget tests for form

### Member Management

- [ ] **Create Member Data Layer** (P1) #members #tdd

  - Define MemberRepository interface
  - Implement with Supabase
  - Implement RLS policies for members
  - Tests: CRUD operations, role validation

- [ ] **Create Member Use Cases** (P1) #members #tdd

  - AddMemberUseCase
  - UpdateMemberUseCase
  - UpdateMemberRoleUseCase (captain only)
  - RemoveMemberUseCase (captain only)
  - Tests: Permission checks, validation

- [ ] **Create Member BLoC** (P1) #members #tdd

  - Define events and states
  - Implement bloc
  - Tests: State transitions

- [ ] **Create Member List Screen** (P1) #members #ui

  - Display society members
  - Filter by role/status
  - Add member button (captain only)
  - Tests: Widget tests

- [ ] **Create Member Form Screen** (P1) #members #ui

  - Name, email, phone inputs
  - Handicap input
  - Role selection (captain only)
  - Photo upload (placeholder)
  - Tests: Form validation

- [ ] **Create Handicap History** (P1) #members #tdd
  - HandicapHistory data model
  - Update handicap with history tracking
  - Display history in member profile
  - Tests: History correctly tracked

---

## P1: Course Management

### Course Library

- [ ] **Create Course Data Layer** (P1) #courses #tdd

  - Define CourseRepository interface
  - Implement with Supabase
  - Store holes as JSONB (par + stroke index)
  - Tests: CRUD operations, JSON parsing

- [ ] **Create Course Use Cases** (P1) #courses #tdd

  - CreateCourseUseCase
  - GetCoursesUseCase
  - UpdateCourseUseCase
  - DeleteCourseUseCase
  - Tests: Validation (18 holes, valid par values)

- [ ] **Create Course BLoC** (P1) #courses #tdd

  - Define events and states
  - Implement bloc
  - Tests: State management

- [ ] **Create Course List Screen** (P1) #courses #ui

  - Display all courses
  - Search/filter courses
  - Add course button (captain only)
  - Tests: Widget tests

- [ ] **Create Course Form Screen** (P1) #courses #ui
  - Course name and location
  - 18-hole input grid (par + stroke index)
  - Calculate total par automatically
  - Validation
  - Tests: Widget tests, validation

---

## P1: Competition Rounds

### Round Creation & Setup

- [ ] **Create Round Data Layer** (P1) #rounds #tdd

  - Define RoundRepository interface
  - Implement with Supabase
  - Handle tournament linkage (many-to-many)
  - Tests: CRUD, tournament linking

- [ ] **Create Group/Pairing Data Layer** (P1) #rounds #tdd

  - Define GroupRepository interface
  - Groups belong to rounds
  - Store tee times
  - Tests: CRUD operations

- [ ] **Create Round Use Cases** (P1) #rounds #tdd

  - CreateRoundUseCase
  - UpdateRoundUseCase
  - DefineFieldUseCase (select members)
  - CreatePairingsUseCase (auto + manual)
  - LinkToTournamentUseCase
  - Tests: Business rules, validation

- [ ] **Create Round BLoC** (P1) #rounds #tdd

  - Define events and states
  - Round setup flow (multi-step)
  - Tests: State transitions

- [ ] **Create Round List Screen** (P1) #rounds #ui

  - Display upcoming rounds
  - Display past rounds
  - Create round button (captain only)
  - Filter by status
  - Tests: Widget tests

- [ ] **Create Round Setup Screen - Basic Info** (P1) #rounds #ui

  - Select date
  - Select course
  - Select format type
  - Tests: Widget tests

- [ ] **Create Round Setup Screen - Field Definition** (P1) #rounds #ui

  - Select members playing
  - Display selected count
  - Tests: Widget tests

- [ ] **Create Round Setup Screen - Pairings** (P1) #rounds #ui

  - Auto-generate pairings (random)
  - Drag-drop to rearrange
  - Set tee times per group
  - Validate group sizes (2-4 players)
  - Tests: Widget tests

- [ ] **Create Round Details Screen** (P1) #rounds #ui
  - Display round information
  - Display groups and tee times
  - Display scores (if available)
  - Navigate to score capture
  - Tests: Widget tests

---

## P1: Score Capture (Offline-First)

### Local Database

- [ ] **Set Up Drift Database** (P1) #offline #tdd

  - Define LocalScores table
  - Define LocalRounds table
  - Define LocalCourses table
  - Define SyncQueue table
  - Tests: Schema generation works

- [ ] **Create Local Repository Implementations** (P1) #offline #tdd
  - LocalScoreRepository
  - Read/write to Drift
  - Tests: CRUD on local database

### Score Capture UI

- [ ] **Create Score Entity & Calculator** (P1) #scores #tdd

  - Score entity with 18 hole scores
  - Net score calculation (gross - handicap strokes)
  - Stableford calculation (points vs par)
  - Tests: Calculations correct for various scenarios

- [ ] **Create Score Capture BLoC** (P1) #scores #tdd

  - LoadRound event
  - UpdateHoleScore event
  - NextHole / PreviousHole events
  - SubmitScore event
  - Tests: State management

- [ ] **Create Score Card Widget** (P1) #scores #ui

  - Large display: Hole number, Par, Stroke Index
  - Current hole score (large)
  - Running totals (gross, net, Stableford)
  - Number pad or +/- buttons for input
  - Tests: Widget tests

- [ ] **Create Swipe Navigation** (P1) #scores #ui

  - PageView for 18 holes
  - Swipe left/right between holes
  - Progress indicator (e.g., 7 of 18)
  - Tests: Widget tests for gestures

- [ ] **Create Score Summary Screen** (P1) #scores #ui
  - Display full scorecard (all 18 holes)
  - Show totals
  - Edit individual holes
  - Submit button
  - Tests: Widget tests

### Score Submission & Approval

- [ ] **Create Score Submission Use Case** (P1) #scores #tdd

  - Validate all 18 holes filled
  - Update status to SUBMITTED
  - Trigger approval flow if required
  - Tests: Validation, status changes

- [ ] **Create Score Approval Use Case** (P1) #scores #tdd

  - Captains can approve any score
  - Markers can approve assigned scores
  - Update status to APPROVED
  - Tests: Permission checks

- [ ] **Create Score Approval Screen** (P1) #scores #ui #captain
  - List pending scores
  - View scorecard details
  - Approve/reject actions
  - Tests: Widget tests

---

## P1: Sync Engine

### Offline-to-Online Sync

- [ ] **Create Sync Engine Core** (P1) #offline #tdd

  - Queue mechanism for actions
  - Retry logic with exponential backoff
  - Conflict resolution (last-write-wins)
  - Tests: Sync scenarios, retry behavior

- [ ] **Implement Score Sync** (P1) #offline #tdd

  - Upload local scores to Supabase
  - Update local records with remote IDs
  - Handle conflicts
  - Tests: Sync success and failure cases

- [ ] **Add Connectivity Monitoring** (P1) #offline

  - Detect online/offline status
  - Trigger sync when online
  - Display connection status in UI
  - Tests: Status changes handled correctly

- [ ] **Create Sync Status UI** (P1) #offline #ui
  - Indicator for synced/unsynced data
  - Manual sync trigger (button)
  - Sync progress display
  - Tests: Widget tests

---

## P2: Leaderboards

### Leaderboard Calculation Engine

- [ ] **Create Leaderboard Calculator** (P2) #leaderboards #tdd

  - Order of Merit calculator
  - Average Score calculator
  - Cumulative Total calculator
  - Best Per Hole (Gross/Net/Stableford) calculators
  - Tests: Calculation accuracy for each type

- [ ] **Create Leaderboard Data Layer** (P2) #leaderboards #tdd

  - Fetch scores for round/tournament/season
  - Apply calculation method
  - Sort and rank players
  - Handle ties
  - Tests: Query optimization, correctness

- [ ] **Create Leaderboard Use Cases** (P2) #leaderboards #tdd

  - GetRoundLeaderboardUseCase
  - GetTournamentLeaderboardUseCase
  - GetSeasonLeaderboardUseCase
  - Tests: Correct data aggregation

- [ ] **Create Leaderboard BLoC** (P2) #leaderboards #tdd
  - Define events and states
  - Real-time subscription option
  - Tests: State management

### Leaderboard UI

- [ ] **Create Leaderboard Widget** (P2) #leaderboards #ui

  - Display ranked list of players
  - Show score/points based on type
  - Highlight current user
  - Indicate ties
  - Tests: Widget tests

- [ ] **Create Round Leaderboard Screen** (P2) #leaderboards #ui

  - Display leaderboard for single round
  - Show round details (date, course)
  - Drill down to individual scorecards
  - Tests: Widget tests

- [ ] **Create Tournament Leaderboard Screen** (P2) #leaderboards #ui

  - Display tournament leaderboard
  - Show list of contributing rounds
  - Clickable rounds for drill-down
  - Multiple leaderboard types (tabs)
  - Tests: Widget tests

- [ ] **Create Season Leaderboard Screen** (P2) #leaderboards #ui
  - Display season standings
  - Show contributing tournaments
  - Multiple leaderboard types
  - Tests: Widget tests

### Real-Time Leaderboard Updates

- [ ] **Implement Real-Time Subscriptions** (P2) #leaderboards #realtime
  - Subscribe to score changes
  - Update leaderboard automatically
  - Handle connection drops gracefully
  - Tests: Subscription behavior

---

## P2: Tournaments

### Tournament Management

- [ ] **Create Tournament Data Layer** (P2) #tournaments #tdd

  - Define TournamentRepository interface
  - Implement with Supabase
  - Handle round linkage
  - Tests: CRUD, many-to-many linking

- [ ] **Create Tournament Use Cases** (P2) #tournaments #tdd

  - CreateTournamentUseCase
  - LinkRoundToTournamentUseCase
  - UnlinkRoundFromTournamentUseCase
  - GetTournamentDetailsUseCase
  - Tests: Business logic

- [ ] **Create Tournament BLoC** (P2) #tournaments #tdd

  - Define events and states
  - Tests: State management

- [ ] **Create Tournament List Screen** (P2) #tournaments #ui

  - Display active tournaments
  - Display past tournaments
  - Create tournament button (captain only)
  - Tests: Widget tests

- [ ] **Create Tournament Form Screen** (P2) #tournaments #ui

  - Tournament name
  - Select leaderboard types to enable
  - Link to season (optional)
  - Tests: Widget tests

- [ ] **Create Tournament Details Screen** (P2) #tournaments #ui
  - Display tournament info
  - List of rounds
  - Add/remove rounds (captain only)
  - View leaderboards
  - Tests: Widget tests

---

## P2: Seasons

### Season Management

- [ ] **Create Season Data Layer** (P2) #seasons #tdd

  - Define SeasonRepository interface
  - Implement with Supabase
  - Support REGULAR and KNOCKOUT types
  - Tests: CRUD operations

- [ ] **Create Season Use Cases** (P2) #seasons #tdd

  - CreateSeasonUseCase
  - LinkTournamentToSeasonUseCase
  - GetSeasonDetailsUseCase
  - Tests: Type-specific logic

- [ ] **Create Season BLoC** (P2) #seasons #tdd

  - Define events and states
  - Tests: State management

- [ ] **Create Season List Screen** (P2) #seasons #ui

  - Display current season
  - Display past seasons
  - Create season button (captain only)
  - Tests: Widget tests

- [ ] **Create Season Form Screen** (P2) #seasons #ui

  - Season name
  - Select type (Regular/Knockout)
  - Select leaderboard types
  - Tests: Widget tests

- [ ] **Create Season Details Screen** (P2) #seasons #ui
  - Display season info
  - List tournaments in season
  - View season leaderboards
  - Tests: Widget tests

---

## P2: Social Features

### Player Profiles

- [ ] **Create Player Profile Screen** (P2) #social #ui

  - Display player info
  - Current handicap
  - Handicap history
  - Statistics (avg score, rounds played)
  - Tests: Widget tests

- [ ] **Create Player Stats Calculator** (P2) #social #tdd
  - Calculate average score
  - Count rounds played
  - Best round
  - Tests: Calculation accuracy

### Banter/Chat

- [ ] **Create Chat Data Layer** (P2) #social #tdd

  - Define ChatRepository interface
  - Implement with Supabase
  - Context-based (round/tournament/season)
  - Tests: CRUD operations

- [ ] **Create Chat Use Cases** (P2) #social #tdd

  - PostMessageUseCase
  - GetMessagesUseCase (by context)
  - Tests: Context filtering

- [ ] **Create Chat BLoC** (P2) #social #tdd

  - Real-time message subscription
  - Post message event
  - Tests: State management

- [ ] **Create Chat Widget** (P2) #social #ui
  - Display messages
  - Post new message
  - Contextual (shows round/tournament/season chat)
  - Tests: Widget tests

---

## P2: Scorecard Photos

### Photo Upload

- [ ] **Configure Supabase Storage** (P2) #storage

  - Create scorecards bucket
  - Set up storage policies
  - Tests: Upload/download policies work

- [ ] **Create Photo Upload Use Case** (P2) #photos #tdd

  - Compress image locally
  - Upload to Supabase Storage
  - Save reference in database
  - Tests: Upload flow

- [ ] **Create Scorecard Photo Screen** (P2) #photos #ui
  - Camera integration
  - Select from gallery
  - Link to group and players
  - Display uploaded photos
  - Tests: Widget tests

---

## P3: Spot Prizes

### Spot Prize Management

- [ ] **Create Spot Prize Data Layer** (P3) #prizes #tdd

  - Define SpotPrizeRepository interface
  - Implement with Supabase
  - Tests: CRUD operations

- [ ] **Create Spot Prize Use Cases** (P3) #prizes #tdd

  - CreateSpotPrizeUseCase (captain)
  - RecordSpotPrizeWinnerUseCase
  - Tests: Validation

- [ ] **Add Spot Prizes to Round Setup** (P3) #prizes #ui

  - Define prizes during round creation
  - Select hole (or whole round)
  - Select prize type
  - Tests: Widget tests

- [ ] **Create Spot Prize Results Screen** (P3) #prizes #ui
  - Display winners
  - Record measurements
  - Tests: Widget tests

---

## P3: Team Formats

### Team Scoring

- [ ] **Create Team Score Calculator** (P3) #teams #tdd

  - Fourball Alliance (best 2 of 4)
  - Fourball Better Ball
  - Foursomes
  - Handle 3-ball with pivot player
  - Tests: Calculation accuracy

- [ ] **Create Team Score Data Layer** (P3) #teams #tdd

  - TeamScore entity
  - Store combined scores
  - Tests: CRUD operations

- [ ] **Update Score Capture for Teams** (P3) #teams #ui

  - Individual entry still
  - Display team score calculation
  - Tests: Widget tests

- [ ] **Create Team Leaderboards** (P3) #teams #leaderboards
  - Rank teams instead of individuals
  - Display team composition
  - Tests: Calculation correctness

---

## P3: Knockout Competitions

### Knockout Season Setup

- [ ] **Extend Season for Knockout Settings** (P3) #knockout #tdd

  - Bracket structure
  - Seeding method
  - Flights configuration
  - Tests: Knockout-specific validation

- [ ] **Create Bracket Generation** (P3) #knockout #tdd

  - Generate bracket based on seeding
  - Handle byes
  - Support multiple flights
  - Tests: Bracket correctness

- [ ] **Create Match Data Layer** (P3) #knockout #tdd
  - Match entity with bracket position
  - Winner determination
  - Tests: CRUD operations

### Match Management

- [ ] **Create Match Result Use Cases** (P3) #knockout #tdd

  - RecordMatchResultUseCase
  - DetermineNextMatchUseCase
  - Tests: Progression logic

- [ ] **Create Bracket Display Widget** (P3) #knockout #ui

  - Visual bracket layout
  - Show match results
  - Highlight active matches
  - Tests: Widget tests (complex)

- [ ] **Create Match Result Entry Screen** (P3) #knockout #ui

  - Enter match result (e.g., "5 & 4")
  - Record playoff if needed
  - Tests: Widget tests

- [ ] **Implement Dual Competition** (P3) #knockout
  - Capture both stroke scores and match result
  - Feed into both competitions
  - Tests: Both leaderboards update

---

## P3: Polish & Enhancement

### UI/UX Improvements

- [ ] **Implement Dark Mode** (P3) #ui

  - Define dark theme
  - Support system preference
  - Toggle in settings
  - Tests: Theme switching works

- [ ] **Add Loading States** (P3) #ui

  - Skeleton screens for loading
  - Progress indicators
  - Tests: Loading states display

- [ ] **Add Empty States** (P3) #ui

  - No scores yet
  - No rounds yet
  - Helpful messaging
  - Tests: Empty states display

- [ ] **Improve Error Messages** (P3) #ui
  - User-friendly error text
  - Actionable suggestions
  - Tests: Error handling

### Performance Optimization

- [ ] **Optimize Leaderboard Queries** (P3) #performance

  - Add database indexes
  - Pagination for large datasets
  - Tests: Query performance

- [ ] **Implement Image Caching** (P3) #performance

  - Cache profile photos
  - Cache scorecard photos
  - Tests: Cache hit rate

- [ ] **Optimize Sync Engine** (P3) #performance
  - Batch sync operations
  - Prioritize important data
  - Tests: Sync efficiency

### Accessibility

- [ ] **Add Screen Reader Support** (P3) #accessibility

  - Semantic labels
  - Proper focus management
  - Tests: Screen reader navigation

- [ ] **Ensure Minimum Touch Targets** (P3) #accessibility

  - 44x44 points minimum
  - Adequate spacing
  - Tests: Touch target sizes

- [ ] **Support Large Text** (P3) #accessibility
  - Respect system text size
  - Dynamic layout
  - Tests: Large text modes

---

## Future Considerations (Not Prioritized)

### Phase 2 Ideas

- [ ] **OCR for Scorecards** #future

  - Extract scores from photos
  - ML model integration

- [ ] **Custom Leaderboards** #future

  - Captain-configurable calculation rules
  - Visual builder

- [ ] **Betting System** #future

  - Place bets between players
  - Track winnings

- [ ] **Push Notifications** #future

  - Tee time reminders
  - Score approvals
  - Leaderboard updates

- [ ] **Social Media Integration** #future

  - Share achievements
  - Post scores to social

- [ ] **Advanced Statistics** #future

  - Trends over time
  - Strengths/weaknesses analysis
  - Handicap recommendations

- [ ] **Automated Handicap Calculation** #future
  - WHS (World Handicap System)
  - Automatic updates

### Multi-Society Support

- [ ] **User in Multiple Societies** #future

  - Society switcher
  - Cross-society stats

- [ ] **Guest Players** #future

  - Non-member participation
  - One-time players

- [ ] **Society Competitions** #future
  - Society vs society
  - Combined leaderboards

---

## Notes

### Testing Reminders

- Every task with #tdd MUST have tests written first
- Widget tests for all screens
- Integration tests for critical flows
- Mock only external dependencies

### Code Quality

- Run `flutter analyze` before marking done
- Run all tests before marking done
- Manual device testing required
- Follow clean architecture

### Documentation

- Update CLAUDE.md if patterns change
- Document complex algorithms
- Add inline comments for tricky logic

### Performance

- Profile before optimizing
- Measure impact of changes
- Test on low-end devices

---

## Task Dependencies

**Foundation blocks everything:**

- Project Setup → All other tasks

**Critical path for MVP:**

1. Auth → Society Management → Member Management
2. Course Management → Round Creation
3. Round Creation → Score Capture
4. Score Capture → Offline Sync
5. Offline Sync → Leaderboards

**Parallel work possible:**

- Auth + Course Management
- Tournaments + Seasons (after rounds)
- Social features + Spot prizes (anytime after core)
- Team formats + Knockouts (after individual scoring)

**Recommended order:**

1. Complete all P0 (Foundation + Auth)
2. Complete P1 (Core features)
3. Tackle P2 in any order based on priority
4. P3 as time permits
