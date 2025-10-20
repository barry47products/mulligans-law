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

- [X] **Configure Dependencies** (P0) #setup

  - [X] Add supabase_flutter (backend & auth)
  - [X] Add drift and drift_flutter (local SQLite database)
  - [X] Add flutter_bloc (state management)
  - [X] Add testing dependencies (mockito, bloc_test, build_runner)
  - [X] Add image_picker, cached_network_image (media handling)
  - [X] Add path_provider, intl (utilities)
  - [X] Tests: All dependencies resolve ✅

- [X] **Set Up Git Repository** (P0) #setup #git

  - [X] Initialize git repository
  - [X] Create .gitignore (Flutter + sensitive files)
  - [X] Create README.md with AI assistance note
  - [X] Create initial commit
  - [X] Tests: Repository initialized ✅

- [X] **Configure Git Commit Hooks** (P0) #setup #git

  - [X] Install Lefthook (Git hooks manager)
  - [X] Pre-commit: dart format (auto-formats staged files)
  - [X] Pre-commit: flutter analyze (catches issues before commit)
  - [X] Commit-msg: validate conventional commits format
  - [ ] Pre-commit: run quick tests (optional - commented out for speed)
  - [X] Tests: Hooks prevent bad commits ✅

- [X] **Create GitHub Repository** (P0) #setup #git

  - [X] Create remote repository (barry47products/mulligans-law)
  - [X] Push initial code
  - [ ] Configure branch protection for main (optional - can do later)
  - [X] Tests: Remote repository accessible ✅

- [X] **Set Up GitHub Actions - CI Pipeline** (P0) #setup #ci

  - [X] Create .github/workflows/ci.yml
  - [X] Configure: checkout, Flutter setup, dependencies
  - [X] Add: format check, analyze, tests, coverage
  - [X] Add: build Android APK and iOS (no codesign)
  - [X] Tests: CI runs successfully on push ✅

- [X] **Set Up GitHub Actions - CD Pipeline** (P0) #setup #ci

  - [X] Create .github/workflows/cd.yml
  - [X] Configure: runs on merge to main
  - [X] Add: semantic-release for auto-versioning (.releaserc.json)
  - [X] Add: iOS TestFlight upload (placeholder ready for configuration)
  - [X] Add: Android Play Store upload (placeholder ready for configuration)
  - [X] Create comprehensive deployment documentation (docs/DEPLOYMENT.md)
  - [X] Tests: CD workflow configured and ready ✅

- [X] **Configure Codecov** (P0) #setup #ci

  - [X] Sign up for Codecov (documented in CODECOV_SETUP.md)
  - [X] Add repository (instructions provided)
  - [X] Configure in CI pipeline (ci.yml with continue-on-error)
  - [X] Set coverage reporting (no enforcement initially)
  - [X] Documentation created (docs/CODECOV_SETUP.md)
  - Tests: Coverage reports will appear in PRs once token configured ✅

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

- [X] **Create Initial Database Migration** (P0) #database

  - [X] Enable UUID extension (uuid-ossp and pgcrypto)
  - [X] Create societies table with RLS (4 policies)
  - [X] Create members table with RLS (5 policies)
  - [X] Create updated_at trigger function (auto-updates timestamps)
  - [X] Create indexes for performance (8 indexes total)
  - [X] Add table and column comments (documentation)
  - [X] Tests: Migration applies successfully ✅

- [X] **Set Up Testing Infrastructure** (P0) #testing

  - [X] Configure test directory structure (test/core, test/features, test/helpers, test/fixtures)
  - [X] Set up mock factories (mock_factories.dart with test data creators)
  - [X] Create test helpers (test_helper.dart with widget testing utilities)
  - [X] Configure coverage exclusions (coverage_helper.dart)
  - [X] Create fixtures documentation (test/fixtures/README.md)
  - [X] Tests: Sample tests run successfully (11/11 tests passing) ✅

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

- [X] **Create Initial Documentation** (P0) #setup #docs
  - [X] Getting Started guide (installation page created)
  - [X] Architecture overview (comprehensive architecture guide)
  - [X] Development workflow (complete TDD development guide)
  - [X] Testing strategy (testing best practices and patterns)
  - [X] Updated Docusaurus navigation (sidebars.ts)
  - [X] Tests: Documentation builds successfully ✅

- [X] **Implement Design System** (P0) #setup #ui
  - [X] Create design system documentation (docs/mulligans-law-design-system.md)
  - [X] Implement AppColors with brand colors (#4CD4B0 mint green, golf-specific colors)
  - [X] Implement AppTypography with Material 3 type scale
  - [X] Implement AppSpacing with 8-point grid system
  - [X] Implement AppTheme with light theme configuration
  - [X] Create reusable widgets (AppCard, AppButton, AppTextField)
  - [X] Update main.dart with design system showcase
  - [X] Fix deprecated API usage (withOpacity → withValues)
  - [X] Tests: Design system renders correctly on Android and iOS ✅

---

## P0: Authentication

### Basic Auth Flow

- [X] **Create Auth Data Layer** (P0) #auth #tdd

  - [X] Define AuthRepository interface (domain)
  - [X] Implement AuthRepositoryImpl with Supabase (data)
  - [X] Write unit tests for repository
  - [X] Tests: Sign up, sign in, sign out, session management ✅

- [X] **Create Auth Use Cases** (P0) #auth #tdd

  - [X] SignIn - Email/password validation and sign in
  - [X] SignUp - Email/password validation and registration
  - [X] SignOut - Session termination
  - [X] GetCurrentUser - Retrieve authenticated user
  - [X] Tests: 20 tests covering all use cases ✅

- [X] **Create Auth BLoC** (P0) #auth #tdd

  - [X] Define AuthEvent (5 events: CheckRequested, SignInRequested, SignUpRequested, SignOutRequested, UserChanged)
  - [X] Define AuthState (5 states: Initial, Loading, Authenticated, Unauthenticated, Error)
  - [X] Implement AuthBloc with event handlers
  - [X] Listen to auth state changes stream
  - [X] Tests: 13 BLoC tests covering all event handlers and state transitions ✅
  - [X] VS Code launch.json configured for debugging tests interactively

- [X] **Create Auth Screens** (P0) #auth #ui

  - [X] WelcomeScreen with branding and navigation to sign in/sign up
  - [X] SignInScreen with email/password, forgot password link, Google sign in
  - [X] SignUpScreen with name, email, password, optional handicap index
  - [X] ForgotPasswordScreen with email input and success state
  - [X] VerifyEmailScreen with 6-digit code input
  - [X] All screens integrated with AuthBloc
  - [X] Routes configured in main.dart
  - [X] Tests: All screens compile without errors ✅

- [X] **Wire Up Auth BLoC Provider** (P0) #auth #ui
  - [X] Created SupabaseConfig for environment-based configuration
  - [X] Initialized Supabase in main.dart with local dev defaults
  - [X] Added BlocProvider for AuthBloc with dependency injection
  - [X] Created AuthGate widget to check auth state on app start
  - [X] Implemented navigation routing based on auth state (authenticated → Home, unauthenticated → Welcome)
  - [X] All 62 tests passing (51 auth + 11 widget tests)
  - [X] Auth flow ready for manual testing with local Supabase ✅

---

## P1: Society Management

### Create & Manage Societies

- [X] **Create Society Data Layer** (P1) #societies #tdd ✅

  - [X] Define SocietyRepository interface ✅
  - [X] Created Society entity and SocietyModel with tests ✅
  - [X] Created exception classes and constants ✅
  - [X] Implement SocietyRepositoryImpl with Supabase ✅
  - [X] Write repository unit tests (data transformation tests) ✅
  - Note: RLS policies tested at database level via migration

- [X] **Create Society Use Cases** (P1) #societies #tdd ✅

  - [X] CreateSociety - validates name, description length ✅
  - [X] GetUserSocieties - fetches user's societies ✅
  - [X] UpdateSociety - validates updates, ensures at least one field ✅
  - [X] All tests passing (25 use case tests) ✅

- [X] **Create Society BLoC** (P1) #societies #tdd ✅

  - [X] Define events and states ✅
  - [X] Implement bloc with event handlers ✅
  - [X] Write bloc tests (14 tests passing) ✅
  - [X] Tests: Load, Create, Update, Select operations ✅

- [X] **Create Society List Screen** (P1) #societies #ui ✅

  - [X] Display user's societies with logo/placeholder ✅
  - [X] Empty state when no societies ✅
  - [X] Error state with retry button ✅
  - [X] Loading state with spinner ✅
  - [X] Society selection on tap ✅
  - [X] FAB to create new society ✅
  - [X] Widget tests (9 tests passing) ✅

- [X] **Create Society Form Screen** (P1) #societies #ui ✅
  - [X] Society name input with validation ✅
  - [X] Description textarea (optional) with max length validation ✅
  - [X] Supports both Create and Edit modes ✅
  - [X] Save button (disabled during operations) ✅
  - [X] Progress indicator during save ✅
  - [X] Form validation (empty name, max lengths) ✅
  - [X] Auto-navigation on success ✅
  - [X] Widget tests (16 tests passing: 11 create mode + 5 edit mode) ✅
  - Note: Logo upload placeholder - will be implemented later

- [X] **Wire Up Society Navigation** (P1) #societies #ui ✅
  - [X] Add society routes to main.dart (/societies, /societies/create, /societies/edit) ✅
  - [X] Set up SocietyBloc provider in MultiBlocProvider ✅
  - [X] Add "My Societies" button to HomeScreen ✅
  - [X] Wire FAB in SocietyListScreen to navigate to create form ✅
  - [X] Wire society card tap to navigate to edit screen (temporary until dashboard exists) ✅
  - [X] All navigation working end-to-end ✅

### Society Dashboard & Screens (Phase 2 - Minimal Real Implementation)

**Note:** Build only what's needed for each screen. Implement real backend functionality incrementally as screens require it. No dummy data - implement the minimal real features needed.

### Member Management (Required for Dashboard)

IMPORTANT: Member Architecture

- User (auth.users) = Authentication identity only
- Member (members table) = Person profile - ONE primary member per user created at registration
- Society Membership = Member belongs to Society via members table with society_id
- When user registers → creates auth.users + primary Member (society_id = null)
- When member creates society → becomes captain of that society
- When member joins society → gets 'member' role in that society
- society_id is nullable to support primary member profile before joining societies

- [X] **Update Members Table Migration** (P0) #database #members ✅
  - [X] Make society_id column nullable in members table ✅
  - [X] Update RLS policies to handle null society_id (primary member profiles) ✅
  - [X] Add unique constraint: one primary member per user (WHERE society_id IS NULL) ✅
  - [X] Add unique constraint: one membership per society per user (WHERE society_id IS NOT NULL) ✅
  - [X] Change handicap from INTEGER to DECIMAL(4,1) for precision ✅
  - [X] Make role nullable for primary members ✅
  - [X] Add check constraint: society members must have role set ✅
  - [X] Add avatar_url, joined_at, last_played_at columns ✅
  - [X] Add index for primary member lookups ✅
  - [X] Update comments and documentation ✅
  - [X] Migration applied successfully ✅

- [X] **Create Member Data Layer** (P1) #members #tdd ✅
  - [X] Define Member entity with all fields (id, societyId, userId, name, email, avatarUrl, handicap, role, joinedAt, lastPlayedAt) ✅
  - [X] Create MemberModel with JSON serialization (fromJson, toJson, fromEntity, toEntity) ✅
  - [X] Define MemberRepository interface (getSocietyMembers, getMemberCount, addMember, updateMember, removeMember, getMemberById) ✅
  - [X] Implement MemberRepositoryImpl with Supabase ✅
  - [X] Create member exception classes (MemberNotFoundException, InvalidMemberDataException, etc.) ✅
  - [X] Add database column constants (avatarUrl, joinedAt, lastPlayedAt) ✅
  - [X] Tests: 19 tests passing (11 model + 8 repository data transformations) ✅

- [X] **Update Member Entity for Nullable Society** (P1) #members #tdd ✅
  - [X] Change Member entity: societyId from required to nullable (String?) ✅
  - [X] Change Member entity: role from required to nullable (String?) ✅
  - [X] Update MemberModel to handle null society_id and role ✅
  - [X] Add repository method: getPrimaryMember(userId) - gets member where society_id IS NULL ✅
  - [X] Add repository method: createPrimaryMember - creates member with null society_id ✅
  - [X] Tests: 44 tests passing (14 model + 11 repository + 19 entity behavior/equality/edge cases) ✅
  - [X] Coverage: Member Entity 100% (up from 4%), MemberModel 100%, Overall 94.9% ✅

- [X] **Add Repository Integration Tests** (P2) #members #tdd #testing ✅
  - [X] Data transformation tests for MemberRepositoryImpl ✅
  - [X] Test JSON transformations (fromJson/toJson for all 8 methods) ✅
  - [X] Test database constants and column mappings ✅
  - [X] Test primary member data structures (getPrimaryMember, createPrimaryMember) ✅
  - [X] 11 data transformation tests passing ✅
  - Note: Project uses data transformation tests rather than mocking Supabase client (see society_repository_impl_test.dart pattern)

- [X] **Update SignUp Use Case** (P0) #auth #members #tdd ✅
  - [X] After creating auth.users, automatically create primary Member record ✅
  - [X] Member fields: userId (from auth), name (from sign up), email (from auth), handicap (from sign up or default 0.0), role (null), society_id (null) ✅
  - [X] Throws MemberAlreadyExistsException or MemberDatabaseException if member creation fails (auth user remains) ✅
  - [X] Tests: 5 new tests for primary member creation (14 total SignUp tests, 56 total auth tests) ✅
  - [X] All 173 tests passing, overall coverage: 52.3% ✅

- [X] **Update CreateSociety Use Case** (P1) #societies #members #tdd ✅
  - [X] After creating society, automatically add creator as captain member ✅
  - [X] Get primary member by user_id ✅
  - [X] Create society membership: same member, society_id = new society, role = 'captain' ✅
  - [X] This creates a SECOND member record for the user (one primary + one society membership) ✅
  - [X] Tests: 4 new tests for captain member creation, updated all 11 existing tests with userId (15 total CreateSociety tests) ✅
  - [X] Updated SocietyCreateRequested event with userId field ✅
  - [X] Updated SocietyBloc to pass userId from event to use case ✅
  - [X] Updated society_form_screen to get userId from AuthBloc ✅
  - [X] Updated all presentation layer tests (SocietyBloc + society_form_screen) ✅
  - [X] All 188 tests passing ✅

- [X] **Create Member Use Cases** (P1) #members #tdd ✅
  - [X] GetPrimaryMember (4 tests) - Gets user's primary member profile by userId ✅
  - [X] GetSocietyMembers (5 tests) - Fetches members for a society, sorted by name ✅
  - [X] GetMemberCount (3 tests) - Counts members in a society ✅
  - [X] UpdatePrimaryMember (5 tests) - Updates primary profile: name, email, handicap, avatarUrl ✅
  - [X] JoinSociety (4 tests) - Creates society membership from primary member, validates society exists ✅
  - [X] UpdateMemberRole (3 tests) - Captain only, updates role for society member ✅
  - [X] LeaveSociety (4 tests) - Removes society membership, captain restrictions apply ✅
  - [X] Added 3 new repository methods: updatePrimaryMember, updateMemberRole, removeSocietyMember ✅
  - [X] Added InvalidMemberOperationException for business rule violations ✅
  - [X] Total: 28 use case tests, all passing ✅

- [ ] **Create Member BLoC** (P1) #members #tdd
  - Define MemberEvent (LoadRequested, AddRequested, UpdateRoleRequested, RemoveRequested)
  - Define MemberState (Initial, Loading, Loaded, Error, OperationInProgress, OperationSuccess)
  - Implement MemberBloc with event handlers
  - Tests: 12 BLoC tests for all events and state transitions

### Society Dashboard Screens

- [ ] **Enhance Society List Screen** (P1) #societies #ui
  - Update SocietyCard component to display:
    - Society name (large, bold)
    - Member count badge (e.g., "24 members") - REAL from getMemberCount
    - "View" button (green, rounded) instead of tap-to-edit
  - Add search bar at top for filtering societies by name (local filter)
  - Update navigation: "View" button navigates to dashboard (not edit screen)
  - Tests: Widget tests for new card layout, search, member count integration

- [ ] **Create Society Dashboard Screen** (P1) #societies #ui
  - Route: `/societies/:id/dashboard`
  - Header with society logo placeholder/name/description from Society entity
  - Tab navigation: Overview, Members (other tabs show "Coming soon" placeholders)
  - **Overview Tab Content:**
    - StatisticsCard: Display member count (REAL from getMemberCount)
    - StatisticsCard: "Events" - shows 0 with "Coming soon" subtitle
    - QuickActions: "View Members" and "Settings" buttons
  - **Members Tab:** Navigate to Society Members Screen
  - Tests: Widget tests for tabs, navigation, member count display

- [ ] **Create Society Members Screen** (P1) #societies #ui
  - Route: `/societies/:id/members`
  - Use MemberBloc to load real members from database
  - AppBar with title "Members (X)" showing real count and "Add Member" button
  - Display list of members from GetSocietyMembers use case
  - MemberCard widget shows: avatar placeholder, name, role badge, handicap
  - Sort dropdown: Name Asc/Desc, Handicap Low/High (sort locally)
  - Empty state when no members ("No members yet. Add your first member!")
  - Tests: Widget tests with real BLoC integration

- [ ] **Create Member Card Widget** (P1) #societies #ui
  - Create `member_card.dart` reusable widget
  - Display: avatar (placeholder circle with initials), name, role badge, handicap
  - Show chevron icon for future navigation
  - Tests: Widget tests for display and interactions

- [ ] **Create Add Member Screen** (P1) #members #ui
  - Route: `/societies/:id/members/add`
  - Form fields: name (required), email (required, validated), handicap (0-54, required), role (dropdown: Member/Captain)
  - Use AddMember use case to create member
  - Validation: email format, handicap range, required fields
  - Success: navigate back, show snackbar
  - Tests: Widget tests for validation, form submission

- [ ] **Create Society Settings Screen** (P1) #societies #ui
  - Route: `/societies/:id/settings`
  - **Section 1: Society Details**
    - ListTile "Edit society information" → Navigate to SocietyFormScreen (existing)
  - **Section 2: Members**
    - ListTile "View all members" → Navigate to Society Members Screen
    - ListTile "Add member" → Navigate to Add Member Screen
  - **Section 3: Danger Zone**
    - Red outlined button "Delete Society" (uses existing delete use case from SocietyBloc)
    - Confirmation dialog: "Are you sure? This cannot be undone."
  - Tests: Widget tests for navigation, delete confirmation

- [ ] **Update Navigation Routes** (P1) #societies #ui
  - Add MemberBloc to MultiBlocProvider in main.dart
  - Add routes to main.dart:
    - `/societies/:id/dashboard` → SocietyDashboardScreen
    - `/societies/:id/members` → SocietyMembersScreen
    - `/societies/:id/members/add` → AddMemberScreen
    - `/societies/:id/settings` → SocietySettingsScreen
  - Update SocietyListScreen: "View" button navigates to dashboard (not edit)
  - Verify all navigation flows work end-to-end
  - Tests: Navigation integration tests

---

## P1: Course Management

### Course Library

- [ ] **Create Course Data Layer** (P1) #courses #tdd

  - Define CourseRepository interface
  - Implement with Supabase
  - Store holes as JSONB (par + stroke index)
  - Tests: CRUD operations, JSON parsing

- [ ] **Create Course Use Cases** (P1) #courses #tdd

  - CreateCourse
  - GetCourses
  - UpdateCourse
  - DeleteCourse
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

  - CreateRound
  - UpdateRound
  - DefineField (select members)
  - CreatePairings (auto + manual)
  - LinkToTournament
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

  - SubmitScore
  - Validate all 18 holes filled
  - Update status to SUBMITTED
  - Trigger approval flow if required
  - Tests: Validation, status changes

- [ ] **Create Score Approval Use Case** (P1) #scores #tdd

  - ApproveScore
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

  - GetRoundLeaderboard
  - GetTournamentLeaderboard
  - GetSeasonLeaderboard
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

  - CreateTournament
  - LinkRoundToTournament
  - UnlinkRoundFromTournament
  - GetTournamentDetails
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

  - CreateSeason
  - LinkTournamentToSeason
  - GetSeasonDetails
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

  - PostMessage
  - GetMessages (by context)
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

  - CreateSpotPrize (captain)
  - RecordSpotPrizeWinner
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

  - RecordMatchResult
  - DetermineNextMatch
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
