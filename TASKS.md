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

- [X] **Create Member BLoC** (P1) #members #tdd ✅
  - [X] Define MemberEvent (LoadRequested, AddRequested, UpdateRoleRequested, RemoveRequested) ✅
  - [X] Define MemberState (Initial, Loading, Loaded, Error, OperationInProgress, OperationSuccess) ✅
  - [X] Implement MemberBloc with event handlers ✅
  - [X] Tests: 10 BLoC tests for all events and state transitions (all passing) ✅
  - [X] Proper exception handling with MemberException catch clauses ✅

### Society Dashboard Screens

- [X] **Enhance Society List Screen** (P1) #societies #ui ✅
  - [X] Update SocietyCard component to display:
    - [X] Society name (large, bold) ✅
    - [X] Member count badge (e.g., "24 members") - REAL from getMemberCount ✅
    - [X] "View" button (green, rounded) instead of tap-to-edit ✅
  - [X] Add search bar at top for filtering societies by name (local filter) ✅
  - [X] Update navigation: "View" button navigates to dashboard route ✅
  - [X] Tests: Comprehensive widget tests ✅
    - 13 tests for SocietyCard widget (including member count display)
    - 22 tests for SocietyListScreen (including search + member count integration)
    - All tests passing (total test suite: 130+ tests passing)

- [X] **Create Society Dashboard Screen** (P1) #societies #ui ✅
  - [X] Route: `/societies/:id/dashboard` ✅
  - [X] Header with society logo placeholder/name/description from Society entity ✅
  - [X] Tab navigation: Overview, Members (other tabs show "Coming soon" placeholders) ✅
  - [X] **Overview Tab Content:** ✅
    - [X] StatisticsCard: Display member count (REAL from getMemberCount) ✅
    - [X] StatisticsCard: "Events" - shows 0 with "Coming soon" subtitle ✅
    - [X] QuickActions: "View Members" and "Settings" buttons ✅
  - [X] **Members Tab:** Shows "Coming soon" placeholder ✅
  - [X] Tests: Comprehensive widget tests (17 tests passing) ✅
    - Header: Society name, description, logo placeholder
    - Tabs: Display, switching, content rendering
    - Statistics: Member count display, async loading, error handling
    - Actions: Button display, navigation functionality
  - All tests passing (147+ total across codebase)

- [X] **Create Society Members Screen** (P1) #societies #ui ✅
  - [X] Route: `/societies/:id/members` ✅
  - [X] Use MemberBloc to load real members from database ✅
  - [X] AppBar with title "Members (X)" showing real count and "Add Member" button ✅
  - [X] Display list of members from GetSocietyMembers use case ✅
  - [X] MemberCard widget shows: avatar placeholder, name, role badge, handicap ✅
  - [X] Sort dropdown: Name Asc/Desc, Handicap Low/High (sort locally) ✅
  - [X] Empty state when no members ("No members yet. Add your first member!") ✅
  - [X] Tests: Comprehensive widget tests (15 tests passing) ✅
  - All 175+ tests passing across entire codebase

- [X] **Create Member Card Widget** (P1) #societies #ui ✅
  - [X] Create `member_card.dart` reusable widget ✅
  - [X] Display: avatar (placeholder circle with initials), name, role badge, handicap ✅
  - [X] Show chevron icon for future navigation ✅
  - [X] Tests: Comprehensive widget tests (12 tests passing) ✅

- [X] **Implement Main Bottom Navigation** (P1) #navigation #ui ✅
  - [X] Create `lib/core/widgets/main_scaffold.dart` with bottom navigation ✅
  - [X] Use IndexedStack to preserve state across tab switches ✅
  - [X] Implement 5 nested Navigators (one per tab: Home, Societies, Events, Leaderboard, Profile) ✅
  - [X] Bottom nav items: Home (Icons.home), Societies (Icons.groups), Events (Icons.event), Leaderboard (Icons.leaderboard), Profile (Icons.person) ✅
  - [X] Each tab maintains its own navigation stack (detail screens don't hide bottom nav) ✅
  - [X] Update AuthGate in main.dart to navigate to MainScaffold instead of HomeScreen ✅
  - [X] Configure route handling for each tab's Navigator ✅
  - [X] Tests: Widget tests for tab switching, state preservation, navigation stack per tab (11 tests) ✅
  - All 186 tests passing across entire codebase

- [X] **Create Dashboard Home Screen** (P1) #home #ui ✅
  - [X] Create `lib/features/home/presentation/screens/dashboard_screen.dart` ✅
  - [X] Move current HomeScreen content (remove design system demo section) ✅
  - [X] **Welcome Header:** "Welcome back, [Name]!", user avatar, current handicap display ✅
  - [X] **Quick Stats Section:** 2x2 grid of statistic cards ✅
    - [X] Total Societies count (placeholder: 0 for now) ✅
    - [X] Upcoming Events count (placeholder: 0 for now) ✅
    - [X] Recent Rounds count (placeholder: 0 for now) ✅
    - [X] Current Rank display (placeholder: "N/A" for now) ✅
  - [X] **Recent Activity Section:** Scrollable list (placeholder empty state: "No recent activity") ✅
  - [X] **Quick Actions:** "My Societies" button, "Start a Round" button (existing functionality) ✅
  - [X] AppBar with title "Mulligans Law" and sign out button ✅
  - [X] Tests: Widget tests for header, stats display, quick actions navigation (21 tests) ✅
  - All 335 tests passing across entire codebase

- [X] **Create Events Landing Screen** (P1) #events #ui ✅
  - [X] Create `lib/features/events/presentation/screens/events_screen.dart` ✅
  - [X] AppBar with title "Events" ✅
  - [X] Placeholder empty state: "Events coming soon" with event icon ✅
  - [X] Placeholder text: "Track society events, book tee times, and manage tournaments" ✅
  - [X] Tests: Basic widget test for screen rendering (6 tests) ✅
  - [X] Update MainScaffold to use EventsScreen ✅
  - All 341 tests passing across entire codebase

- [X] **Create Leaderboard Landing Screen** (P1) #leaderboard #ui ✅
  - [X] Create `lib/features/leaderboard/presentation/screens/leaderboard_screen.dart` ✅
  - [X] AppBar with title "Leaderboard" ✅
  - [X] Placeholder empty state: "Leaderboards coming soon" with leaderboard icon ✅
  - [X] Placeholder text: "View rankings, statistics, and compete with society members" ✅
  - [X] Tests: Basic widget test for screen rendering (6 tests) ✅
  - [X] Update MainScaffold to use LeaderboardScreen ✅
  - All 347 tests passing across entire codebase

- [X] **Create Profile Landing Screen** (P1) #profile #ui ✅
  - [X] Create `lib/features/profile/presentation/screens/profile_screen.dart` ✅
  - [X] AppBar with title "Profile" ✅
  - [X] Placeholder avatar circle with user initials (get from AuthBloc current user) ✅
  - [X] Display: Name, email (from AuthBloc) ✅
  - [X] Display: Handicap (placeholder: "Not set" for now - primary member profile coming later) ✅
  - [X] ListTile "Edit Profile" (placeholder, shows "Coming soon" snackbar) ✅
  - [X] ListTile "Settings" (placeholder, shows "Coming soon" snackbar) ✅
  - [X] Sign Out button (uses existing AuthBloc sign out) ✅
  - [X] Tests: Widget tests for display, sign out functionality (15 tests passing) ✅
  - [X] Update MainScaffold to use ProfileScreen ✅

- [X] **Update Societies Tab Navigation** (P1) #societies #navigation ✅
  - [X] Move SocietyListScreen to Societies tab Navigator ✅
  - [X] Ensure existing routes work within nested Navigator: ✅
    - [X] `/` → SocietyListScreen (root of Societies tab) ✅
    - [X] `/create` → SocietyFormScreen ✅
    - [X] `/edit` → SocietyFormScreen with society argument ✅
    - [X] `/:id/dashboard` → SocietyDashboardScreen ✅
    - [X] `/:id/members` → SocietyMembersScreen ✅
  - [X] Updated navigation calls in society screens to use relative paths ✅
  - [X] Removed society routes from main.dart app router ✅
  - [X] Verify back button navigation works correctly within tab ✅
  - [X] Verify tab switching preserves Societies navigation stack ✅
  - [X] Tests: All 11 main_scaffold navigation tests passing ✅

### Society & Member Management - Business Rules

**Role Hierarchy & Permissions (Cumulative):**

- **Member**: Basic access, can view society data
- **Captain**: Can add/remove members (change status to RESIGNED), manage day-to-day operations, all member permissions
- **Owner**: Original creator, can promote/demote captains, promote captains to co-owner, delete society, all captain permissions
- **Co-Owner**: Additional owners promoted by existing owners, same permissions as Owner (used to indicate primary responsible person vs co-opted owners)
- **Validation**: Must always have at least one Owner in a society

**Member Status Lifecycle:**

- User invited → **PENDING** (7-day expiry) → accepts → **ACTIVE**
- User invited → **PENDING** → declines/expires/rejected → record deleted
- User requests to join public society → **PENDING** → captain approves → **ACTIVE**
- User requests to join public society → **PENDING** → captain rejects → record deleted (with optional rejection message)
- **ACTIVE** member removed by captain → **RESIGNED** (data preserved, hidden from active lists)
- **ACTIVE** member leaves voluntarily → **RESIGNED**

**Invitation & Join Flow:**

- Can only invite existing app users (link sharing for non-users comes later)
- Invitations expire after **7 days** (background job deletes expired PENDING records)
- Handicap validation happens **before** invite/join request is allowed
- Private societies: Only invited members can join (requires captain/owner approval)
- Public societies: Anyone can request to join (requires captain/owner approval)
- Pending requests shown at top of members list for approval/rejection

**Handicap Limits:**

- Toggle: "Enforce handicap limits" (OFF by default)
- When **OFF**: No handicap restrictions on membership
- When **ON**: RangeSlider for min (+8 to 36, default 0) and max (+8 to 36, default 24)
- Members with handicaps outside the range **cannot join** (validation before invite/join)
- TODO: Handle handicap changes for existing members (future feature)

**Society Deletion:**

- Only **Owners** can delete society
- **Soft delete**: Set `deleted_at` timestamp, data preserved
- Former members retain **read-only access** to historical data (dashboard, past rounds, leaderboards)
- Deleted societies filtered out of active society lists
- All action buttons disabled (no new rounds, no member changes, no edits)

**Activity Events:**

- Events automatically published as actions occur
- Examples: memberInvited, invitationAccepted, joinRequestApproved, memberPromoted, memberResigned, societyDeleted, etc.

---

- [X] **Update Database Schema for Roles, Status, and Soft Delete** (P1) #database #migration #societies #members ✅
  - Note: **MUST BE COMPLETED FIRST** - Required for all other Society/Member features
  - Create new migration: `supabase migration new update_societies_members_schema`
  - **Update members table:**
    - Update `role` enum to add: OWNER, CO_OWNER (existing: MEMBER, CAPTAIN)
    - Update `status` enum values: PENDING, ACTIVE, RESIGNED (remove INACTIVE if exists)
    - Add `expires_at` TIMESTAMPTZ field (nullable) - for PENDING invitations (7 days from created_at)
    - Add `rejection_message` TEXT field (nullable) - captain's message when rejecting join request
    - Add index: `idx_members_status_expires_at` ON members(status, expires_at) WHERE status = 'PENDING'
  - **Update societies table:**
    - Add `deleted_at` TIMESTAMPTZ field (nullable) - for soft delete
    - Add `handicap_limit_enabled` BOOLEAN field (default: false)
    - Add `handicap_min` INT field (nullable) - minimum handicap when limits enabled
    - Add `handicap_max` INT field (nullable) - maximum handicap when limits enabled
    - Add index: `idx_societies_deleted_at` ON societies(deleted_at)
    - Add constraint: CHECK (handicap_min <= handicap_max)
    - Add constraint: CHECK (handicap_min >= -8 AND handicap_min <= 36)
    - Add constraint: CHECK (handicap_max >= -8 AND handicap_max <= 36)
  - **Update RLS Policies:**
    - Filter soft-deleted societies: Add `AND deleted_at IS NULL` to existing SELECT policies
    - Owners can soft-delete: Add policy for UPDATE where user is OWNER/CO_OWNER
    - Members can view deleted societies they belonged to: Add SELECT policy for deleted societies
  - **Data Migration:**
    - Set all existing members with role='CAPTAIN' who created the society to role='OWNER'
    - Set handicap_limit_enabled=false for all existing societies
  - Apply migration: `supabase db reset`
  - Tests: Verify table updates, constraints, RLS policies, indexes

- [X] **Enhance Society Form Screen (Create/Edit)** (P1) #societies #ui ✅ COMPLETED
  - Note: Add advanced fields from design flows
  - Route: Within Societies tab Navigator: `/societies/create` or `/societies/edit`
  - **Step 1: Generate Screen Design (AI Prompt for Miro/Figma)** ✅
    - Created AI design prompt including existing app design system
    - Generated screen mockup with all required sections
    - Design reviewed and approved
  - **New Fields Added:** ✅
    - Privacy toggle (default: OFF/Private) - Implemented with SwitchListTile
    - **Handicap Limits Section:** - Implemented with progressive disclosure
      - Toggle: "Enforce handicap limits" (default: OFF)
      - RangeSlider shown only when ON
      - Range: +8 to 36 with proper formatting
      - Labels at key points: +8, 0, 18, 36
      - Current range displayed below slider
    - Location field (text input, disabled with TODO) - Placeholder added
    - Society rules (multi-line text area, 3 lines) - Implemented
    - Society profile image upload - Placeholder section added
  - **Business Rules:** ✅ All implemented
    - Privacy: default OFF (private society)
    - Handicap limit toggle: default OFF
    - Handicap validation in CreateSociety and UpdateSociety use cases
    - Default handicap range: 0 to 24
    - Full range available: -8 (stored as +8) to 36
    - Creator automatically becomes CAPTAIN via RPC function
  - **Validation:** ✅ Implemented
    - Name required with proper error message
    - Handicap range validation (min <= max, within -8 to 36)
    - Meaningful error messages in use cases
  - **Database Fields:** ✅ All migrated and working
    - Migration: `20251022084842_add_missing_society_columns.sql`
    - Fields: `is_public`, `handicap_limit_enabled`, `handicap_min`, `handicap_max`, `location`, `rules`
    - RPC function updated: `create_society_with_captain`
  - **Tests:** ✅ All passing (213+ tests, 0 failures)
    - Widget tests for all 6 sections
    - Validation tests for handicap ranges
    - Event parameter tests updated
    - Form behavior tests (16 test cases)
  - **Implementation Notes:**
    - File: [society_form_screen.dart](lib/features/societies/presentation/screens/society_form_screen.dart) (567 lines)
    - Progressive disclosure: Handicap slider appears only when toggle ON
    - Fixed deprecation warnings (activeColor → activeTrackColor, withOpacity → withValues)
    - All BLoC events updated with new parameters
    - Repository layer fully integrated

- [ ] **Enhance Society Dashboard Screen** (P1) #societies #ui
  - Note: Add real stats and activity feed scaffolding
  - Route: Within Societies tab Navigator: `/societies/:id/dashboard`
  - **Step 1: Generate Screen Design (AI Prompt)**
    - Create AI design prompt for dashboard with stats, next event card, activity feed
    - Include design system (colors, spacing, components)
    - Review and approve design before implementation
  - **Stats Section (Real Implementation):**
    - Total members (query from members table where status = 'ACTIVE')
    - Owner name(s) (query members where role IN ('OWNER', 'CO_OWNER'))
    - Captain name(s) (query members where role = 'CAPTAIN')
    - Average handicap (calculate from ACTIVE members only)
    - Total rounds played (TODO: implement when rounds feature ready)
    - Use GetMemberCount and new GetSocietyStats use case
  - **Next Event Section:**
    - Placeholder card with "No upcoming events"
    - TODO comment: "Will integrate with Events feature"
    - Show event date, name, course when available
  - **Activity Feed Section:**
    - Build scaffolding for event publishing system
    - Create ActivityFeed widget (even if using placeholder items initially)
    - Define ActivityEvent domain entity (type, timestamp, userId, societyId, metadata)
    - Create ActivityEventRepository interface (for future implementation)
    - Placeholder items: "Member joined", "Round completed", "Role changed", "Member resigned"
    - TODO: Wire up to real events from other features
  - **Dashboard Tabs Note:**
    - Overview tab: fully implemented
    - Members tab: navigates to existing SocietyMembersScreen
    - Location tab: placeholder - TODO
    - Events tab: placeholder - TODO
    - Leaderboard tab: placeholder - TODO
    - Profile tab: placeholder - TODO
  - **Soft Delete Handling:**
    - If society is soft-deleted (deleted_at IS NOT NULL):
      - Show banner: "This society has been deleted"
      - All action buttons disabled
      - Read-only access to dashboard, stats, past rounds, leaderboards
  - Tests: Widget tests for stats display, activity feed widget, soft delete banner

- [ ] **Create Invite to Society Screen** (P1) #societies #members #ui
  - Note: New screen from design flows - for inviting existing app users only
  - Route: Within Societies tab Navigator: `/societies/:id/invite`
  - Accessible from: Society Members Screen (floating action button or app bar action)
  - Only captains and owners can access this screen
  - **Step 1: Generate Screen Design (AI Prompt)**
    - Create AI design prompt for invite screen with search, handicap validation display
    - Include design system (colors, spacing, components)
    - Review and approve design before implementation
  - **Features:**
    - **Search Players Section:**
      - Search bar to find existing app users by name/email
      - Results list showing matching users not already in society
      - Show user's handicap in results (for validation)
      - **Handicap Validation:**
        - If society has handicap limits enabled, check user's handicap before allowing invite
        - If user's handicap outside range: Show error badge on user, disable invite button
        - Error message: "Handicap [X] is outside society limits ([min] - [max])"
      - Tap user to send invite (creates PENDING member record with 7-day expiry)
    - **Suggested Players (TODO - Future Feature):**
      - Show list of users who might be interested
      - Based on location, mutual societies, similar handicap
      - Algorithm to be implemented later
    - **Custom Message:**
      - Optional message field to include with invite (shown in notification)
      - Max 200 characters
  - **Business Logic:**
    - Create InviteMember use case
    - Validation: Check handicap limits before creating invite
    - Creates member record with:
      - status = 'PENDING'
      - role = 'MEMBER' (default)
      - expires_at = NOW() + 7 days
    - Sends notification to invitee (TODO: notification system)
    - Invitee must accept invitation before expiry
  - **Share Link Section (TODO - Future Feature):**
    - For inviting non-app users via deep link
    - Will use native platform sharing (share_plus package)
    - Implement invite link backend logic and deep link handling later
  - Tests: Widget tests for search, handicap validation, invite creation, expiry date

- [ ] **Create Join Society Flow for Public Societies** (P1) #societies #members #ui
  - Note: Allow users to discover and request to join public societies
  - **Step 1: Generate Screen Design (AI Prompt)**
    - Create AI design prompt for public society discovery with join requests
    - Include design system (colors, spacing, components)
    - Review and approve design before implementation
  - **Society Discovery:**
    - Update SocietyListScreen to show "Discover Societies" tab/section
    - Query public societies (where is_public = true AND deleted_at IS NULL)
    - Show society cards with "Join" button
    - Display society info: name, description, member count, handicap range (if limits enabled)
  - **Handicap Validation:**
    - Before showing "Join" button, check if society has handicap limits
    - If limits enabled: Check if current user's handicap is within range
    - If outside range: Show "Cannot Join" with message: "Your handicap ([X]) is outside this society's limits ([min] - [max])"
    - If within range or no limits: Show "Request to Join" button
  - **Join Request:**
    - Tap "Request to Join" → Create PENDING member record
    - Set expires_at = NOW() + 7 days
    - Set role = 'MEMBER'
    - Send notification to captains/owners (TODO: notification system)
    - Show success message: "Join request sent. You'll be notified when a captain approves."
  - **Business Logic:**
    - Create JoinSociety use case (or RequestToJoinSociety)
    - Validation: Check handicap limits before creating PENDING record
    - Creates member record with status = 'PENDING', expires_at
    - Automatically publish activity event: 'joinRequestReceived'
  - **Pending Status Indication:**
    - In user's society list, show societies with pending requests with "Pending Approval" badge
    - User can cancel their own pending request
  - Tests: Widget tests for discovery, handicap validation, join request, pending indication

- [ ] **Update Add Member Screen with New Handicap Rules** (P1) #members #ui
  - Note: Update existing task with correct handicap range and handicap limit validation
  - Route: Within Societies tab Navigator: `/societies/:id/members/add`
  - Only captains and owners can access this screen
  - **Step 1: Generate Screen Design (AI Prompt)**
    - Create AI design prompt for add member form with handicap validation
    - Include design system (colors, spacing, components)
    - Review and approve design before implementation
  - **Updated Form Fields:**
    - Name (required)
    - Email (required, validated)
    - Handicap dropdown (+8 to 36, default: 0)
    - Role dropdown (Member/Captain) - only owners can set Captain role
  - **Business Rules:**
    - Handicap range: +8 (best) to 36 (highest) - not 0-54
    - Default handicap: 0 (scratch golfer)
    - Display format: "+8", "+4", "0", "12", "24", "36"
    - Note: Plus handicaps are better than scratch (0)
    - New member created with status = 'ACTIVE' (not PENDING, since captain is adding directly)
  - **Handicap Limit Validation:**
    - If society has handicap limits enabled:
      - Show warning if selected handicap is outside society's range
      - Block form submission with error: "Handicap [X] is outside society limits ([min] - [max])"
      - Show society's handicap range at top of form for reference
  - **Validation:**
    - Email format check
    - Handicap must be in valid range (+8 to 36)
    - If handicap limits enabled: handicap must be within society's range
    - All required fields must be filled
    - Email must not already be a member of this society
  - Use AddMember use case to create member
  - Success: navigate back within tab, show snackbar, refresh member list
  - Automatically publish activity event: 'memberJoined'
  - Tests: Widget tests for validation, handicap range, handicap limit checking, form submission

- [ ] **Create GetSocietyStats Use Case** (P1) #societies #tdd
  - Note: Required for enhanced dashboard
  - **Purpose:** Calculate real-time statistics for a society
  - **Returns:** SocietyStats entity with:
    - totalMembers (int) - count of ACTIVE members only
    - ownerNames (List<String>) - members where role IN ('OWNER', 'CO_OWNER')
    - captainNames (List<String>) - members where role = 'CAPTAIN'
    - averageHandicap (double) - calculated from ACTIVE members only
    - totalRoundsPlayed (int) - TODO: implement when rounds ready
    - pendingRequestsCount (int) - count of members where status = 'PENDING'
  - **Dependencies:**
    - MemberRepository for member queries
    - RoundRepository (for future rounds count)
  - **Implementation:**
    - Query members table for society where status = 'ACTIVE'
    - Calculate stats from member data
    - Handle edge cases (no members, no owners, no captains, division by zero for average)
    - Exclude RESIGNED and PENDING members from totals
  - Tests: Unit tests for calculation logic, edge cases, role filtering

- [ ] **Create ActivityEvent Domain Entity** (P1) #societies #tdd
  - Note: Foundation for activity feed - automatically published as actions occur
  - **Entity Fields:**
    - id (String)
    - type (ActivityEventType enum) - see below
    - societyId (String)
    - userId (String) - user who triggered the event
    - targetUserId (String?) - user affected by event (optional)
    - metadata (Map<String, dynamic>) - event-specific data (e.g., old role, new role, rejection message)
    - timestamp (DateTime)
    - message (String) - human-readable message for display
  - **ActivityEventType Enum:**
    - **Member Invitation Events:**
      - memberInvited - captain sent invitation to user
      - invitationAccepted - user accepted invitation
      - invitationDeclined - user declined invitation
      - invitationExpired - invitation expired after 7 days
    - **Join Request Events:**
      - joinRequestReceived - user requested to join public society
      - joinRequestApproved - captain approved join request
      - joinRequestRejected - captain rejected join request (with optional message)
    - **Member Management Events:**
      - memberJoined - member added directly by captain (not via invitation)
      - memberResigned - member removed or left voluntarily
      - memberPromoted - role changed upward (e.g., Member → Captain → Co-Owner)
      - memberDemoted - role changed downward (e.g., Co-Owner → Captain → Member)
    - **Society Events:**
      - societyCreated - new society created
      - societyUpdated - society details changed
      - societyDeleted - society soft-deleted by owner
    - **Round Events (for future):**
      - roundCreated
      - roundCompleted
      - (more types added as features develop)
  - **Auto-Publishing:**
    - Events automatically published when actions occur in use cases
    - Use ActivityEventRepository.publishEvent() after successful operations
    - Examples: After CreateSociety → publish societyCreated, After UpdateMemberRole → publish memberPromoted/memberDemoted
  - Tests: Entity creation, JSON serialization, event type enum values

- [ ] **Create ActivityEventRepository Interface** (P1) #societies #tdd
  - Note: Repository for activity feed events
  - **Methods:**
    - `Future<void> publishEvent(ActivityEvent event)` - publish new event
    - `Stream<List<ActivityEvent>> watchSocietyEvents(String societyId)` - real-time stream
    - `Future<List<ActivityEvent>> getSocietyEvents(String societyId, {int limit = 20})` - paginated
    - `Future<void> deleteEvent(String eventId)` - for moderation
  - **Implementation Notes:**
    - Will use Supabase activity_events table (to be created in migration)
    - Real-time subscriptions for live updates
    - Pagination support for performance
  - Tests: Mock repository implementation for testing

- [ ] **Implement Member Management Features** (P1) #members #ui
  - Note: Complete member management from design flows with pending approvals and role hierarchy
  - Location: SocietyMembersScreen enhancements
  - **Step 1: Generate Screen Design (AI Prompt)**
    - Create AI design prompt for members list with pending approvals, role badges, sorting
    - Include design system (colors, spacing, components)
    - Review and approve design before implementation
  - **Pending Requests Section (Top of List):**
    - Show all members with status = 'PENDING' at top of screen
    - Separate section header: "Pending Requests ([count])"
    - Each pending request shows:
      - Name, email, handicap
      - Date requested
      - Days until expiry (e.g., "Expires in 5 days")
      - **Approve button** (green) - changes status to ACTIVE, publishes joinRequestApproved event
      - **Reject button** (red) - shows dialog for optional rejection message, deletes record, publishes joinRequestRejected event
    - Only captains and owners see this section
    - If no pending requests, hide section entirely
  - **Active Members List (Sorted by Role):**
    - Sort order: Owners → Co-Owners → Captains → Members (alphabetically within each role)
    - Do NOT show RESIGNED members
    - Section headers for each role group (optional, for clarity)
  - **Member List Item Enhancement:**
    - Show member avatar (or initials placeholder)
    - Show handicap badge (e.g., "+8", "0", "24")
    - **Show role badge with color coding:**
      - Owner: Gold/Yellow badge
      - Co-Owner: Gold/Yellow badge (with "Co" indicator)
      - Captain: Blue badge
      - Member: Gray badge
    - Show "You" indicator if current user
  - **Change Member Role (Owners Only):**
    - Long-press or swipe actions on member list item
    - Show bottom sheet with role change options:
      - "Promote to Co-Owner" (if Captain)
      - "Promote to Captain" (if Member)
      - "Demote to Captain" (if Co-Owner)
      - "Demote to Member" (if Captain or Co-Owner)
    - Confirmation dialog for role changes: "Change [name]'s role from [old] to [new]?"
    - Validation: Must always have at least one Owner (cannot demote last owner)
    - Uses UpdateMemberRole use case, publishes memberPromoted/memberDemoted event
  - **Remove Member (Captains and Owners):**
    - Long-press or swipe actions on member list item
    - Show bottom sheet with "Remove member" option (red text)
    - Confirmation dialog: "Remove [name] from society? Their historical data will be preserved."
    - Changes status to RESIGNED (not deleted)
    - Captains can remove Members only
    - Owners can remove Members and Captains (but not other Owners)
    - Cannot remove yourself if you're the last Owner
    - Uses RemoveMember use case (update to LeaveSociety), publishes memberResigned event
  - **Filter by Role:**
    - Filter chips: "All", "Owners", "Captains", "Members", "Pending"
    - Filter member list based on selection
    - "Pending" filter shows PENDING requests (same as top section)
    - Preserve filter state when navigating away
  - **Permissions Summary:**
    - **Members**: Can only view the list
    - **Captains**: Can approve/reject pending requests, remove Members, add members
    - **Owners**: All captain permissions + can promote/demote captains, promote to co-owner, remove captains, delete society
  - **Soft Delete Handling:**
    - If society is soft-deleted: All action buttons disabled, list is read-only
  - Tests: Widget tests for pending approvals, filtering, role changes, member removal, permissions, sorting

- [ ] **Complete Society Settings Screen Implementation** (P1) #societies #ui
  - Note: Expand existing settings screen with all sections from design and owner-only features
  - Route: Within Societies tab Navigator: `/societies/:id/settings`
  - **Step 1: Generate Screen Design (AI Prompt)**
    - Create AI design prompt for settings screen with all sections and permissions
    - Include design system (colors, spacing, components)
    - Review and approve design before implementation
  - **Permission Levels:**
    - **Owners**: Full access to all sections
    - **Captains**: Access to Sections 1-4, cannot delete society
    - **Members**: Cannot access settings (show "You don't have permission" message)
  - **All Sections:**
    - **Section 1: Society Details**
      - ListTile "Edit society information" → Navigate to SocietyFormScreen
      - Shows current society name as subtitle
      - Captains and owners can edit
    - **Section 2: Members**
      - ListTile "View all members" (active count as subtitle) → Navigate to Members Screen
      - ListTile "Pending requests" (count as subtitle, if > 0) → Navigate to Members Screen with Pending filter
      - ListTile "Add member" → Navigate to Add Member Screen
      - ListTile "Invite to society" → Navigate to Invite Screen (new)
      - Captains and owners can access
    - **Section 3: Privacy & Permissions**
      - SwitchListTile "Society is public" (linked to is_public field)
      - Explanation text: "Public societies can be discovered and joined by anyone (with approval)"
      - ListTile "Handicap limits"
        - If enabled: Shows "Enforced: [min] - [max]" as subtitle
        - If disabled: Shows "Not enforced" as subtitle
        - Tap to show dialog for toggling and editing limits
      - Captains and owners can edit
    - **Section 4: Society Rules**
      - ListTile "View/Edit rules" → Navigate to rules editor or show dialog
      - Shows first line of rules as subtitle (if set), otherwise "Not set"
      - Captains and owners can edit
    - **Section 5: Danger Zone (Owners Only)**
      - Red outlined button "Delete Society" (soft delete)
      - Confirmation dialog with warning text:
        - "Are you sure you want to delete [Society Name]?"
        - "Members will retain read-only access to historical data."
        - "This action sets deleted_at timestamp."
      - Only owners can delete
      - Uses DeleteSociety use case, publishes societyDeleted event
  - **Soft Delete Handling:**
    - If society is soft-deleted: All settings disabled, show banner "This society has been deleted"
  - Tests: Widget tests for all sections, permissions (member/captain/owner), navigation, soft delete

- [ ] **Implement Handicap Limit Validation Use Case** (P1) #societies #members #tdd
  - Note: Reusable validation logic for handicap limits across invite/join/add flows
  - **Purpose:** Check if a member's handicap is within a society's limits (if enabled)
  - **Use Case: ValidateHandicapForSociety**
    - Input: societyId, memberHandicap
    - Output: ValidationResult (isValid: bool, errorMessage: String?)
    - Logic:
      - Query society to check if handicap_limit_enabled
      - If false: return valid (no restrictions)
      - If true: check if memberHandicap >= handicap_min AND memberHandicap <= handicap_max
      - If invalid: return error with message: "Handicap [X] is outside society limits ([min] - [max])"
  - **Usage:**
    - Called before creating invitation (InviteMember use case)
    - Called before join request (JoinSociety use case)
    - Called in Add Member form validation
    - Called in public society discovery (to show/hide Join button)
  - **TODO for Future:**
    - Handle existing member handicap changes
    - What happens when member's handicap goes outside limits after joining?
    - Options: notify only, prevent round participation, auto-remove (to be decided)
  - Tests: Unit tests for validation logic, enabled/disabled limits, edge cases (exactly at min/max, plus handicaps)

- [ ] **Implement Soft Delete for Societies** (P1) #societies #tdd
  - Note: Implement soft delete functionality with read-only access for former members
  - **Update DeleteSociety Use Case:**
    - Instead of hard delete, set `deleted_at = NOW()`
    - Validation: Only owners can delete
    - Automatically publish activity event: 'societyDeleted'
  - **Update SocietyRepository:**
    - `getSocieties()` - filter out soft-deleted (WHERE deleted_at IS NULL)
    - `getDeletedSocieties()` - new method to query soft-deleted societies for current user
    - `getSocietyById()` - allow reading soft-deleted societies (for read-only access)
  - **UI Changes:**
    - SocietyListScreen: Add "Archived Societies" tab/section (optional)
    - Show deleted societies with "Deleted" badge
    - SocietyDashboardScreen: Show banner if deleted_at IS NOT NULL
    - Disable all action buttons (no new rounds, no edits, no member changes)
    - Allow viewing: dashboard, stats, past rounds, leaderboards (read-only)
  - **RLS Policy Updates:**
    - Former members can SELECT soft-deleted societies they belonged to
    - Cannot UPDATE or INSERT on soft-deleted societies
  - Tests: Unit tests for soft delete, repository filtering, read-only access, UI disabled states

- [ ] **Implement Invitation Expiry Background Job** (P1) #societies #members #backend
  - Note: Automated cleanup of expired PENDING invitations
  - **Implementation Options:**
    - **Option A: Supabase Edge Function** (scheduled)
      - Create edge function: `expire_pending_invitations`
      - Schedule to run daily or hourly via pg_cron
      - Deletes PENDING members where expires_at < NOW()
    - **Option B: Database Trigger/Function**
      - Create PostgreSQL function to check expiry
      - Trigger on SELECT or UPDATE of members table
      - Lazy deletion when querying
    - **Option C: Application-Level Job**
      - Flutter background task (if app is running)
      - Not reliable, prefer server-side solution
  - **Recommended: Option A (Supabase Edge Function)**
    - Create `supabase/functions/expire-invitations/index.ts`
    - Query: `DELETE FROM members WHERE status = 'PENDING' AND expires_at < NOW()`
    - Log count of deleted invitations
    - Optionally publish 'invitationExpired' events for each
    - Schedule with pg_cron: `SELECT cron.schedule('expire-invitations', '0 */6 * * *', $$SELECT expire_pending_invitations()$$);`
  - **Notifications (TODO):**
    - Send notification to inviter: "Invitation to [Name] expired"
    - Send notification to invitee: "Your invitation to [Society] expired"
    - Implement when notification system is built
  - Tests: Integration tests for expiry logic, edge function execution, cron scheduling

- [ ] **Update Database Schema for Activity Events** (P1) #database #migration
  - Note: Required for activity feed feature
  - Create new migration: `supabase migration new create_activity_events_table`
  - **Table: activity_events**
    - id (UUID, primary key)
    - society_id (UUID, references societies, NOT NULL)
    - user_id (UUID, references auth.users, NOT NULL) - who triggered it
    - target_user_id (UUID, references auth.users, NULL) - who was affected
    - event_type (TEXT, NOT NULL) - enum values
    - metadata (JSONB, NULL) - event-specific data
    - message (TEXT, NOT NULL) - human-readable message
    - created_at (TIMESTAMPTZ, NOT NULL, default NOW())
  - **Indexes:**
    - idx_activity_events_society_id ON activity_events(society_id)
    - idx_activity_events_created_at ON activity_events(created_at DESC)
  - **RLS Policies:**
    - SELECT: Society members (including former members of deleted societies) can view events for their societies
    - INSERT: Authenticated users can publish events (application-level validation in use cases)
    - DELETE: Only owners can delete events (for moderation)
  - **Constraints:**
    - Check event_type in valid enum values (memberInvited, invitationAccepted, joinRequestReceived, etc.)
  - Apply migration: `supabase db reset`
  - Tests: Verify table creation, RLS policies, indexes, event type constraints

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
