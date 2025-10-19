# Society Feature - Implementation Specification

## Overview

This specification details the implementation of the Society feature for Mulligans Law, building upon the existing foundation (auth, basic society CRUD already completed). The implementation focuses on completing the society management flows shown in the designs, with dummy data used for features not yet implemented (events, leaderboards, etc.).

## Current State (Already Implemented)

- ✅ Society entity and data models
- ✅ SocietyRepository with Supabase integration
- ✅ Society use cases (CreateSociety, GetUserSocieties, UpdateSociety)
- ✅ SocietyBloc with event handlers
- ✅ Basic SocietyListScreen
- ✅ SocietyFormScreen (create/edit modes)
- ✅ Navigation and routing

## Implementation Requirements

### 1. Enhanced My Societies List Screen

**File**: `lib/features/societies/presentation/screens/society_list_screen.dart`

#### Visual Updates Required

```dart
// Society Card Component should display:
class SocietyCard extends StatelessWidget {
  // Properties to show:
  - Society name (large, bold)
  - Member count badge (e.g., "24 members")
  - Handicap range (e.g., "Handicaps 8-24")
  - 3-4 member avatars (overlapping circles)
  - Next event indicator (if exists) - DUMMY DATA
  - "View" button (green, rounded)
}
```

#### Grouping/Categories

```dart
// Add society categories (can be enum or tags in Society model)
enum SocietyCategory {
  weekendWarriors,  // Active societies
  fairwayFriends,   // Casual/social societies
  birdieChasers,    // Competitive societies
  parBreakers       // Performance-focused societies
}
```

#### Search Functionality

- Add search bar at top of list
- Filter societies by name locally

### 2. Society Dashboard Screen (NEW)

**File**: `lib/features/societies/presentation/screens/society_dashboard_screen.dart`

#### Society Dashboard Screen Route

- `/societies/:id/dashboard`
- Navigate here on "View" button tap from list

#### Layout Structure

```dart
class SocietyDashboardScreen extends StatefulWidget {
  final String societyId;

  // Sections:
  // 1. Header with society image/name
  // 2. Tab navigation (Overview, Members, Events, Leaderboard)
  // 3. Content area based on selected tab
}
```

#### Overview Tab Content

```dart
// Components needed:
1. NextEventCard
   - Event title: "Saturday Stableford - Oct 28" (DUMMY)
   - Location: "Parkland Golf Club" (DUMMY)
   - Time: "First Tee: 9:00 AM" (DUMMY)
   - "View Details" button (show snackbar "Events coming soon")

2. StatisticsGrid (2x2 grid)
   - Members count (real data from members table)
   - Events this month: "12" (DUMMY)
   - Active members: "24" (DUMMY)
   - Average handicap: "12.3" (DUMMY)

3. RecentActivityFeed
   - List of 5 activity items (DUMMY DATA)
   - Format: "[Avatar] [Name] posted score: [X] pts [time ago]"
   - Example activities:
     * "Sarah posted score: 36 pts - 20 min"
     * "Mike posted score: 32 pts - 1h ago"
     * "David joined the society - 14 Apr"
     * "Emma posted score: 38 pts - 2d ago"

4. QuickActions
   - "Invite Members" button → Navigate to invite screen
   - "Settings" button → Navigate to settings screen
```

#### Members Tab

- Redirect to Members List Screen (section 3)

#### Events Tab

- Show placeholder: "Events feature coming soon"

#### Leaderboard Tab

- Show placeholder: "Leaderboard feature coming soon"

### 3. Society Members Screen (NEW)

**File**: `lib/features/societies/presentation/screens/society_members_screen.dart`

#### Society Member Screen Route

- `/societies/:id/members`

#### Header

```dart
AppBar(
  title: "Members (24)", // Dynamic count
  actions: [
    // Search icon button
    // "Invite Member" button (green)
  ]
)
```

#### Sort/Filter Controls

```dart
// Dropdown for sort
enum MemberSortOption {
  nameAsc,
  nameDesc,
  handicapLowToHigh,
  handicapHighToLow,
  joinDateNewest,
  joinDateOldest
}
```

#### Member List Items

```dart
class MemberCard extends StatelessWidget {
  // Display:
  - Avatar (placeholder image if none)
  - Name (bold)
  - Role badge (Member/Admin/Owner)
  - Handicap: "8.4" (DUMMY)
  - Last played: "Yesterday" (DUMMY)
  - Chevron icon for navigation (future)
}
```

#### Data

- For now, use dummy member data:

```dart
final dummyMembers = [
  Member(name: "James Wilson", handicap: 8.4, role: "Owner"),
  Member(name: "Sarah Johnson", handicap: 12.3, role: "Member"),
  Member(name: "Michael Chen", handicap: 3.2, role: "Member"),
  Member(name: "Emily Rodriguez", handicap: 9.8, role: "Member"),
  Member(name: "Robert Thompson", handicap: 13.5, role: "Member"),
];
```

### 4. Invite to Society Screen (NEW)

**File**: `lib/features/societies/presentation/screens/invite_society_screen.dart`

#### Invite to Societies Route

- `/societies/:id/invite`

#### Layout

```dart
class InviteSocietyScreen extends StatefulWidget {
  // Two main sections:
  // 1. Search and select players
  // 2. Selected players summary
}
```

#### Search Section

```dart
// Search bar with hint "Search by name or email"
TextField(
  decoration: InputDecoration(
    hintText: "Search Players",
    prefixIcon: Icon(Icons.search),
  )
)
```

#### Share Link Section

```dart
// Generate shareable link button
ElevatedButton.icon(
  icon: Icon(Icons.link),
  label: Text("Share Link"),
  onPressed: () {
    // Generate link like: "mulliganslaw.app/join/society123"
    // Copy to clipboard
    // Show snackbar "Link copied!"
  }
)
```

#### Suggested Players List

```dart
// For now, show dummy players
final suggestedPlayers = [
  Player(name: "James Wilson", email: "james@example.com"),
  Player(name: "Sarah Johnson", email: "sarah@example.com"),
  Player(name: "Michael Thompson", email: "michael@example.com"),
  Player(name: "Emma Davis", email: "emma@example.com"),
];

// Each item has checkbox for selection
```

#### Selected Players Section

```dart
// Show count badge "Selected (3)"
// List selected players with remove (X) button
// Custom message input (optional)
TextField(
  decoration: InputDecoration(
    hintText: "Add a personal message (optional)",
  ),
  maxLines: 3,
)
```

#### Send Button

```dart
ElevatedButton(
  child: Text("Send 3 Invites"), // Dynamic count
  onPressed: selectedPlayers.isEmpty ? null : () {
    // Show success snackbar
    // Navigate back
  }
)
```

### 5. Society Settings Screen (ENHANCED)

**File**: `lib/features/societies/presentation/screens/society_settings_screen.dart`

Update existing settings screen to include:

#### Sections

##### 1. Society Details

```dart
ListTile(
  title: Text("Edit society information"),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () => // Navigate to SocietyFormScreen in edit mode
)
```

##### 2. Privacy Settings

```dart
SwitchListTile(
  title: Text("Make society public"),
  subtitle: Text("Allow anyone to discover and join"),
  value: isPublic,
  onChanged: (value) => // Update society
)
```

##### 3. Notification Preferences

```dart
// These are user-specific, store locally for now
SwitchListTile(title: "New members", value: true)
SwitchListTile(title: "Score updates", value: true)
SwitchListTile(title: "Event reminders", value: true)
```

##### 4. Handicap Limits

```dart
// Dual slider for min/max handicap
RangeSlider(
  values: RangeValues(minHandicap, maxHandicap),
  min: 0,
  max: 54,
  divisions: 54,
  labels: RangeLabels(
    minHandicap.toString(),
    maxHandicap.toString(),
  ),
)
```

##### 5. Admin Management

```dart
// List current admins
Column(
  children: [
    ListTile(
      leading: CircleAvatar(),
      title: Text("James Wilson"),
      subtitle: Text("Owner"),
      trailing: Chip(label: Text("Owner")),
    ),
    ListTile(
      leading: CircleAvatar(),
      title: Text("Sarah Thompson"),
      subtitle: Text("Admin"),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle),
        onPressed: () => // Remove admin
      ),
    ),
    ElevatedButton(
      child: Text("Add Admin"),
      onPressed: () => // Show member picker
    ),
  ],
)
```

##### 6. Member Approval

```dart
SwitchListTile(
  title: Text("Auto-approve new members"),
  subtitle: Text("Members join immediately vs manual approval"),
  value: autoApprove,
)
```

##### 7. Danger Zone

```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.red,
    side: BorderSide(color: Colors.red),
  ),
  child: Text("Delete Society"),
  onPressed: () => // Show confirmation dialog
)
```

### 6. Navigation Updates

Update `main.dart` routing:

```dart
// Add new routes
'/societies/:id/dashboard': (context, params) => SocietyDashboardScreen(societyId: params['id']),
'/societies/:id/members': (context, params) => SocietyMembersScreen(societyId: params['id']),
'/societies/:id/invite': (context, params) => InviteSocietyScreen(societyId: params['id']),

// Update society card tap behavior
// FROM: Navigate to edit screen
// TO: Navigate to dashboard screen
onTap: () => Navigator.pushNamed(
  context,
  '/societies/${society.id}/dashboard',
)
```

## Data Models

### Update Society Model

```dart
class Society {
  // Existing fields...

  // Add:
  final SocietyCategory? category;
  final int memberCount; // Calculated field
  final double minHandicap;
  final double maxHandicap;
  final bool isPublic;
  final bool autoApprove;
  final String? imageUrl;
}
```

### Add Member Model (Dummy)

```dart
class Member {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;
  final double handicap;
  final String role; // Owner, Admin, Member
  final DateTime joinDate;
  final DateTime? lastPlayed;
}
```

### Add Activity Model (Dummy)

```dart
class Activity {
  final String id;
  final String userId;
  final String userName;
  final String avatarUrl;
  final String type; // score_posted, member_joined, etc.
  final String description;
  final DateTime timestamp;
}
```

## Implementation Notes

1. **Dummy Data**: All member, event, and activity data should use hardcoded dummy data for now. Add TODO comments where real data integration is needed.

2. **Placeholder Actions**: Features not yet implemented (events, leaderboards, member profiles) should show appropriate placeholder messages or snackbars.

3. **State Management**: Use existing SocietyBloc for society data. Create temporary local state for UI-only features (selected members, sort options, etc.).

4. **Error Handling**: All screens should handle loading, error, and empty states appropriately.

5. **Responsiveness**: Ensure all screens work on various screen sizes, especially tablets in landscape.

## Testing Requirements

For each new screen, create widget tests covering:

- Initial render
- User interactions (taps, selections)
- State changes
- Navigation
- Empty states
- Error states

## Accessibility

- All interactive elements must have semantic labels
- Ensure proper contrast ratios (follow Material Design)
- Support screen readers
- Minimum touch targets of 44x44 points

## Files to Create/Modify

### New Files

- `lib/features/societies/presentation/screens/society_dashboard_screen.dart`
- `lib/features/societies/presentation/screens/society_members_screen.dart`
- `lib/features/societies/presentation/screens/invite_society_screen.dart`
- `lib/features/societies/presentation/widgets/society_card.dart` (enhanced)
- `lib/features/societies/presentation/widgets/member_card.dart`
- `lib/features/societies/presentation/widgets/activity_item.dart`
- `lib/features/societies/presentation/widgets/next_event_card.dart`
- `lib/features/societies/domain/entities/member.dart` (dummy)
- `lib/features/societies/domain/entities/activity.dart` (dummy)

### Modified Files

- `lib/features/societies/presentation/screens/society_list_screen.dart`
- `lib/features/societies/presentation/screens/society_settings_screen.dart`
- `lib/features/societies/domain/entities/society.dart`
- `lib/main.dart` (routing)

## Success Criteria

1. All screens match the design mockups
2. Navigation flows work end-to-end
3. Dummy data displays correctly
4. All interactive elements respond appropriately
5. Placeholder messages appear for unimplemented features
6. Widget tests pass for all new screens
7. Code follows existing patterns and clean architecture

## Next Steps After Implementation

Once this society feature is complete, the next priorities would be:

1. Member management backend integration
2. Event management feature
3. Leaderboard calculations
4. Real activity feed
5. Invitation system with email/notifications
