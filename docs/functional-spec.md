# Golf Society App - Functional Specification

## 1. Executive Summary

A platform-agnostic mobile application for managing golf scores and leaderboards for social golf societies. The system supports regular season play, knockout competitions, multiple concurrent tournaments, offline score capture, and social interaction between members.

## 2. Core Entities

### 2.1 Entity Hierarchy

```bash
Society
  └── Season (Regular | Knockout)
        └── Tournament (flexible container)
              └── Competition Round (actual golf event)
                    └── Scores (individual/team)
                    └── Matches (knockout results)

Standalone Entities:
  - Players/Members
  - Courses
  - Leaderboard Types
```

### 2.2 Key Principles

- **Flexible Linking**: Rounds can exist standalone or link to tournaments; tournaments can exist standalone or link to seasons
- **Many-to-Many**: A single round can contribute to multiple tournaments simultaneously
- **Calculated Views**: Leaderboards computed on-the-fly from linked rounds
- **Offline-First**: Must function without internet during rounds, sync when connected

## 3. User Roles

### 3.1 Admin

- System-level administration
- Manage society settings
- All captain and user permissions

### 3.2 Captain

- Create/edit seasons, tournaments, rounds
- Define fields, tee times, groupings
- Approve scores
- Manage members and courses
- Configure spot prizes

### 3.3 User (Player)

- Capture own scores (hole-by-hole)
- View leaderboards
- Participate in banter/chat
- View stats and history
- Upload scorecard photos

## 4. Core Features

### 4.1 Society Management

#### 4.1.1 Create Society

- Society name
- Logo/branding
- Settings and preferences
- Timezone configuration

#### 4.1.2 Member Management

- Add/remove members
- Assign roles (Admin, Captain, User)
- Manage handicaps with history
- Member profiles (name, email, phone, photo)
- Active/inactive status

#### 4.1.3 Course Management

- Add courses to society library
- Define 18 holes with:
  - Par per hole
  - Stroke index per hole
- Calculate total par
- Edit course details

### 4.2 Season Management

#### 4.2.1 Regular Season

- Collection of tournaments
- Aggregate scoring across tournaments
- Multiple leaderboard types enabled
- Dates inferred from tournament dates

#### 4.2.2 Knockout Season

- Bracket/draw structure
- Head-to-head matchups
- Winner progression
- Multiple flights (Championship, Plate, Bowl)
- Seeding methods:
  - By handicap
  - By season standing
  - Manual assignment
  - Random draw
- Bye handling for uneven brackets

#### 4.2.3 Season Operations

- Create new season (select type)
- Link tournaments to season
- Enable leaderboard types for season
- View season standings
- Archive completed seasons

### 4.3 Tournament Management

#### 4.3.1 Tournament Creation

- Tournament name
- Link to season (optional)
- Select enabled leaderboard types
- Add existing rounds or create new rounds
- Dates inferred from linked rounds

#### 4.3.2 Tournament Properties

- Flexible container for rounds
- No inherent rules, just grouping
- Multiple calculation methods via leaderboard types
- Can exist standalone or within season

#### 4.3.3 Tournament Operations

- Link/unlink rounds
- Enable/disable leaderboard types
- View tournament standings
- Archive completed tournaments

### 4.4 Competition Round Management

#### 4.4.1 Round Creation - Setup Phase

##### **Basic Information**

- Date of competition
- Course selection
- Format type:
  - Individual: Stroke Play, Stableford
  - Team: Fourball Alliance, Fourball Better Ball, Foursomes

##### **Field Definition**

- Select members participating
- Define tee times
- Create groupings (2-ball, 3-ball, 4-ball)
- Auto-pairing with random distribution
- Manual override of pairings

##### **Special Configurations**

- 3-ball in fourball alliance: Select pivot player
- Spot prize definition:
  - Longest drive (specify hole or whole round)
  - Closest to pin (specify hole)
  - Closest in 2/3 (specify hole)
- Approval requirements (configurable)

#### 4.4.2 Round Linking

- Add to tournament(s) - multiple allowed
- Select applicable leaderboards
- Can exist standalone (casual round)

#### 4.4.3 Round Status Flow

```bash
SETUP → IN_PROGRESS → SUBMITTED → COMPLETED
```

- **SETUP**: Captain configuring round
- **IN_PROGRESS**: Players capturing scores
- **SUBMITTED**: Awaiting approval
- **COMPLETED**: Approved, counts towards leaderboards

### 4.5 Score Capture

#### 4.5.1 Individual Score Entry

##### **During Round (Offline-Capable)**

- Swipe navigation between holes
- Large display showing:
  - Current hole number
  - Par for hole
  - Stroke index
- Quick entry methods:
  - Number pad (tap score directly)
  - +/- buttons
- Real-time calculations:
  - Net score (gross - handicap strokes)
  - Stableford points
  - Running totals
- Visual progress indicator
- Auto-save to local database

##### **Submission Workflow**

1. Player completes all 18 holes
2. Review full scorecard
3. Submit for approval
4. Status: SUBMITTED
5. Playing partner/marker approves (if required)
6. Status: APPROVED
7. Counts towards leaderboards

#### 4.5.2 Team Score Capture

##### **Individual Entry**

- Each team member enters own scores
- Captured separately in system

##### **Team Calculation**

- System calculates team score based on format:
  - Fourball Alliance: Best 2 of 4 scores per hole
  - Fourball Better Ball: Best 2 of 4 balls
  - Foursomes: Aggregate score

##### **Approval**

- All team members must submit
- Marker/partner approval required
- Team score calculated once all approved

#### 4.5.3 Knockout Match Results

##### **Separate Capture**

- Match result entry (e.g., "5 & 4", "2 & 1", "A/S")
- Playoff results if applicable
- Winner determination
- Independent from stroke/Stableford scorecard

##### **Dual Competition**

- Same round can count for both:
  - Knockout (match result)
  - Regular season (stroke/Stableford scores)
- Two separate submissions required

#### 4.5.4 Scorecard Photos

##### **Upload Process**

- Take photo of physical scorecard
- Link to specific group
- Link to players on scorecard
- Store for reference and audit
- Future: OCR extraction (not in v1)

#### 4.5.5 Spot Prize Capture

##### **During/After Round**

- Longest drive: Distance measurement
- Closest to pin: Distance measurement
- Closest in 2/3: Distance or score
- Winner selection
- Prize tracking per round

##### **Important**

- Spot prizes do NOT contribute to tournament leaderboards
- Separate prize pool per round
- Winners displayed on round results page

### 4.6 Leaderboard System

#### 4.6.1 Pre-Built Leaderboard Types (v1)

##### **Best Score Per Hole - Gross**

- Sum of player's best gross score on each of 18 holes
- Calculated across all rounds in tournament
- Example: Best on Hole 1 = 3, Best on Hole 2 = 4, etc., Total = sum of all 18

##### **Best Score Per Hole - Net**

- Sum of player's best net score on each of 18 holes
- Handicap-adjusted scoring
- More equitable across different handicaps

##### **Best Score Per Hole - Stableford**

- Sum of player's best Stableford points on each of 18 holes
- Most equitable calculation method
- Rewards consistency

##### **Order of Merit**

- Points awarded for top-N finishes per round
- Configurable point structure (default: 10 for 1st, 9 for 2nd, ... 1 for 10th)
- Cumulative across all rounds in tournament
- Rewards consistent performance

##### **Average Score**

- Mean Stableford points across all rounds
- Example: (38 + 35 + 41) / 3 = 38.0
- Normalizes for players who play different number of rounds

##### **Cumulative Total**

- Sum of all Stableford points
- Gross accumulation across all rounds
- Favours players who play more rounds

#### 4.6.2 Leaderboard Calculation Rules

##### **Computation**

- Calculated on-the-fly (not persisted initially)
- Real-time updates when scores submitted/approved
- Transparent calculation (show which rounds included)

##### **Inclusion Criteria**

- Only APPROVED scores count
- SUBMITTED scores visible but marked as pending
- Round must be COMPLETED status

##### **Tie Handling**

- Same score = same position
- Next position adjusted (two 1st places, next is 3rd)
- Tie-breakers (configurable):
  - Back 9 score
  - Last 6 holes
  - Last 3 holes
  - Countback method

##### **Qualification**

- Optional minimum rounds requirement
- Configurable by captain per tournament
- Non-qualified players shown but marked ineligible

#### 4.6.3 Leaderboard Display

##### **Round Leaderboard**

- Single round results
- Display: Date, course, format
- Player rankings for that day
- Spot prize winners
- Scorecard access

##### **Tournament Leaderboard**

- Aggregated results across linked rounds
- List of rounds included (clickable)
- Player rankings by selected calculation type
- Multiple leaderboard types displayed simultaneously

##### **Season Leaderboard**

- Aggregated across all tournaments
- Show contributing tournaments + rounds
- Overall season standings
- Multiple leaderboard types

##### **Display Requirements**

- Show which rounds are included
- Clickable rounds to drill down
- View round details without losing context
- Return to parent leaderboard easily
- Real-time updates during active rounds

### 4.7 Social Features

#### 4.7.1 Contextual Banter/Chat

##### **Scoped Chat Feeds**

- Round-level chat (when viewing round)
- Tournament-level chat (when viewing tournament)
- Season-level chat (when viewing season)
- Cascading display based on user context

##### **Features**

- Post messages/comments
- View conversation history
- Timestamp display
- Author attribution
- Future: Betting between players (not v1)

#### 4.7.2 Player Profiles

##### **Profile Information**

- Name, photo, contact details
- Current handicap
- Handicap history (audit trail)
- Society membership details

##### **Statistics**

- Average score
- Best rounds
- Rounds played
- Tournament participations
- Wins and placements

##### **History**

- Past round scores
- Tournament results
- Season achievements
- Personal bests

### 4.8 Knockout Competition Features

#### 4.8.1 Bracket Management

##### **Bracket Setup**

- Visual bracket display
- Seeding options:
  - By handicap (lowest = 1 seed)
  - By season standing
  - Manual assignment
  - Random draw
- Bye handling for odd numbers
- Multiple flights support

##### **Flights**

- Championship (main bracket)
- Plate (first-round losers)
- Bowl (second-round losers)
- Configurable flight structure

#### 4.8.2 Match Progression

##### **Result Entry**

- Match result format: "X & Y"
- Playoff handling for all-square
- Winner determination
- Automatic bracket updates

##### **Progression Rules**

- Winners advance to next round
- Losers to consolation bracket (if configured)
- Bye players advance automatically
- Final determines overall winner

#### 4.8.3 Dual Competition Support

##### **Same Round, Two Competitions**

- Knockout match result
- Regular season stroke/Stableford scores
- Two separate captures
- Both count simultaneously

## 5. Business Rules

### 5.1 Scoring Rules

#### 5.1.1 Score Validation

- All 18 holes must have scores
- Gross scores must be positive integers
- Net scores calculated: Gross - Handicap strokes (by stroke index)
- Stableford points calculated: Based on net score vs par
- Invalid/missing scores prevent submission

#### 5.1.2 Handicap Application

##### **Individual Play**

- Full handicap applied based on stroke index
- Strokes received on holes where index ≤ handicap
- Net score = Gross score - strokes received

##### **Team Play**

- Format-specific allowances:
  - Fourball: 85% of handicap
  - Foursomes: 50% of combined handicap
  - Configurable per format

#### 5.1.3 Stableford Points Calculation

```bash
Double Bogey or worse: 0 points
Bogey: 1 point
Par: 2 points
Birdie: 3 points
Eagle: 4 points
Albatross: 5 points
```

Based on net score vs par

#### 5.1.4 Score Approval Workflow

##### **Individual Formats**

- Player submits own score
- Optional marker approval (configurable per round)
- Captain can always override

##### **Team Formats**

- All team members submit individual scores
- Playing partner/marker approval required
- Team score calculated once all approved
- Captain override available

#### 5.1.5 Score Corrections

##### **Pre-Approval**

- Player can edit freely
- No audit trail required

##### **Post-Approval**

- Captain override required
- Audit trail maintained
- Reason for change recorded

### 5.2 Leaderboard Rules

#### 5.2.1 Calculation Timing

- Leaderboards calculated on-demand
- Update when scores approved
- Real-time during active rounds (via subscriptions)

#### 5.2.2 Round Inclusion

- Only APPROVED scores count
- SUBMITTED scores not included
- Round must be COMPLETED status

#### 5.2.3 Qualification Rules

- Minimum rounds requirement (optional, configurable)
- Must be active member
- Non-qualified players shown separately

### 5.3 Tournament Rules

#### 5.3.1 Round Contribution

- Single round can feed multiple tournaments
- Each tournament applies its own calculation
- Round removal recalculates affected leaderboards

#### 5.3.2 Date Handling

- Tournament dates inferred from rounds
- Start date: Earliest round date
- End date: Latest round date
- Dynamic updating as rounds added/removed

### 5.4 Knockout Rules

#### 5.4.1 Seeding

- Lower handicap = higher seed (for handicap seeding)
- Higher standing = higher seed (for standing seeding)
- Byes awarded to higher seeds

#### 5.4.2 Match Determination

- Winner determined by match result
- All-square requires playoff or countback
- Playoff results recorded separately

#### 5.4.3 Bracket Progression

- Automatic pairing for next round
- Based on bracket position
- Consolation bracket routing (if configured)

### 5.5 Data Sync Rules

#### 5.5.1 Offline Behaviour

- All score capture works offline
- Writes to local database first
- Queued for sync when connection available
- UI updates optimistically

#### 5.5.2 Conflict Resolution

- Last-write-wins for player scores
- Captain approval overrides conflicts
- Audit log for all changes
- Timestamp-based resolution

#### 5.5.3 Sync Priority

- Score submissions: High priority
- Leaderboard queries: Medium priority
- Chat messages: Low priority
- Photos: Background, opportunistic

## 6. Non-Functional Requirements

### 6.1 Performance

- Leaderboard calculation: < 2 seconds (50 players, 20 rounds)
- Score submission: < 1 second (offline capture)
- Sync latency: < 5 seconds (when online)
- App launch: < 3 seconds

### 6.2 Offline Capability

- Full score capture offline
- View cached leaderboards offline
- Queue all mutations locally
- Graceful degradation when offline
- Clear online/offline status indication

### 6.3 Platform Support

- iOS (iPhone/iPad) - iOS 13+
- Android (phones/tablets) - Android 8+
- Responsive design (phone and tablet layouts)
- Native feel despite cross-platform framework

### 6.4 Security

- Authentication required for all actions
- Role-based access control
- Row-level security in database
- Data encryption in transit (HTTPS)
- Data encryption at rest
- Audit logging for sensitive actions

### 6.5 Scalability

- Support up to 200 members per society
- Support up to 50 rounds per season
- Support up to 10 concurrent tournaments
- Handle 50 concurrent score submissions
- Multiple societies per platform (future)

### 6.6 Usability

- Intuitive navigation
- Large touch targets (min 44x44 points)
- Works in bright sunlight (high contrast)
- One-handed operation for score capture
- Minimal taps to complete common actions
- Clear error messages
- Helpful validation messages

### 6.7 Reliability

- 99.5% uptime target
- Graceful error handling
- Data integrity guaranteed
- No data loss during offline mode
- Successful sync on reconnection

## 7. Future Considerations

### 7.1 Phase 2 Features

- OCR for scorecard photo analysis
- Custom leaderboard builder (captain-configurable)
- Betting system between players
- Push notifications (tee times, results, chat)
- Social media integration
- Advanced statistics and insights
- Automated handicap calculation (WHS)
- Guest player support

### 7.2 Phase 3 Features

- Multi-society support (user in multiple societies)
- Society-to-society competitions
- Equipment tracking and preferences
- Weather integration
- Course recommendations
- Pro shop integration
- Payment processing (entry fees)

## 8. Out of Scope (v1)

- Live GPS tracking during rounds
- Shot-by-shot tracking
- Course mapping/layouts
- Tee time booking integration
- Handicap calculation (manual entry only)
- Payment processing
- E-commerce features
- Video content
- Live streaming
- AR features
- Apple Watch / Wear OS apps

## 9. Success Criteria

### 9.1 Functional Success

- Members can capture scores offline
- Leaderboards update in real-time
- Zero data loss during sync
- All user roles function correctly
- Knockout and regular seasons work simultaneously

### 9.2 User Adoption

- 80% of society members using app within 3 months
- 95% of scores captured via app (vs paper)
- Average session time > 15 minutes
- Return rate > 80% for next round

### 9.3 Technical Success

- < 1% crash rate
- < 5 second sync time
- > 99% successful syncs
- Zero data loss incidents
- Pass all accessibility audits

## 10. Glossary

- **Stableford**: Scoring system awarding points based on score vs par
- **Net Score**: Gross score minus handicap strokes
- **Stroke Index**: Difficulty rating of hole (1-18)
- **Fourball Alliance**: Team format, best 2 of 4 scores per hole
- **Pivot Player**: In 3-ball, player whose score counts twice
- **Order of Merit**: Points-based leaderboard for consistent performance
- **Knockout Season**: Bracket-style elimination competition
- **Flight**: Separate bracket within knockout (Championship, Plate, Bowl)
- **RLS**: Row-Level Security (database security policy)
- **A/S**: All Square (tie in matchplay)
- **5 & 4**: Matchplay result (5 holes up with 4 to play)
