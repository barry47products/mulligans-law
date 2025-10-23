# AI Design Prompt: Invite to Society Screen

## Context

This is a design prompt for generating a UI mockup of the "Invite to Society" screen in the Mulligans Law mobile app. This screen allows society captains and owners to invite existing app users to join their society.

## App Design System

### Brand Colors

- **Primary (Mint Green)**: `#4CD4B0` - Main brand color, used for primary actions
- **Secondary (Navy)**: `#1A365D` - Headers, important text
- **Accent (Coral)**: `#FF6B6B` - Error states, warnings
- **Success (Green)**: `#48BB78` - Success states, positive actions
- **Warning (Orange)**: `#ED8936` - Warnings, handicap validation errors
- **Background**: `#F7FAFC` - Light gray background
- **Card Background**: `#FFFFFF` - White cards
- **Text Primary**: `#2D3748` - Dark gray for primary text
- **Text Secondary**: `#718096` - Medium gray for secondary text
- **Border**: `#E2E8F0` - Light border color

### Typography

- **Headline Large**: 32px, Bold, Navy
- **Headline Medium**: 24px, Bold, Navy
- **Headline Small**: 20px, Semi-bold, Navy
- **Body Large**: 16px, Regular, Text Primary
- **Body Medium**: 14px, Regular, Text Primary
- **Body Small**: 12px, Regular, Text Secondary
- **Button Text**: 16px, Semi-bold

### Spacing

- 8-point grid system (8px, 16px, 24px, 32px, etc.)
- Card padding: 16px
- Screen padding: 16px horizontal, 24px vertical
- Component spacing: 16px between sections

### Components

- **Cards**: White background, 8px border radius, subtle shadow
- **Buttons (Primary)**: Mint green background, white text, 8px border radius, 48px height
- **Buttons (Secondary)**: White background, mint green border, mint green text, 8px border radius, 48px height
- **Text Fields**: White background, light gray border, 8px border radius, 48px height
- **Badges**: Small rounded rectangles with colored background and white text
- **Icons**: Material Design icons, consistent sizing

## Screen Requirements

### Route & Access

- Route: `/societies/:id/invite` (within Societies tab Navigator)
- Accessible from: Society Members Screen (FAB or app bar action button)
- Only captains and owners can access this screen

### AppBar

- Title: "Invite Members"
- Back button (left)
- Close button or cancel text (optional)
- Background: White
- Elevation: Small shadow

### Screen Layout (Top to Bottom)

#### 1. Society Context Header (Optional)

- Small card showing current society name and logo
- Helps user confirm which society they're inviting to
- Subtle, not prominent

#### 2. Search Players Section

**Search Bar:**

- Placeholder: "Search by name or email"
- Search icon on left
- Clear button (X) on right when text entered
- White background, light border
- Full width with screen padding

**Search Results List:**

- Scrollable list of matching users
- Each result item shows:
  - Avatar circle (or initials placeholder) - 48px diameter
  - User name (Body Large, Text Primary)
  - User email (Body Small, Text Secondary)
  - Handicap badge (e.g., "+8", "0", "24") - right side, colored badge
  - "Invite" button (small, mint green) - or disabled if validation fails

**Handicap Validation Display:**

- If society has handicap limits enabled AND user's handicap is outside range:
  - Show warning badge/icon next to handicap (orange/red)
  - Error message below user info: "Handicap [X] is outside society limits ([min] - [max])"
  - "Invite" button disabled and grayed out
  - Visual indicator (e.g., red border or background tint on card)

**Empty State (No Results):**

- Icon (search or user icon, gray)
- Text: "No users found"
- Subtext: "Try a different search term"

**Initial State (No Search Yet):**

- Icon (group of people, gray)
- Text: "Search for users to invite"
- Subtext: "Enter a name or email address above"

#### 3. Custom Message Section (Optional, Expandable)

- Collapsed state: "Add a message (optional)" with expand icon
- Expanded state:
  - Multi-line text input (3-4 lines visible)
  - Character counter: "0/200"
  - Placeholder: "Add a personal message to include with your invitation..."
  - Collapse button

#### 4. Suggested Players Section (Future Feature - Show Placeholder)

- Section header: "Suggested Players"
- Gray box with dashed border
- Icon (wand or sparkles)
- Text: "Coming soon"
- Subtext: "We'll suggest players based on location and mutual connections"
- Add a TODO comment for future implementation

#### 5. Share Link Section (Future Feature - Show Placeholder)

- Section header: "Invite via Link"
- Gray box with dashed border
- Icon (link icon)
- Text: "Coming soon"
- Subtext: "Invite non-app users with a shareable link"
- Add a TODO comment for future implementation

### Interaction States

**Invite Button States:**

- Default: Mint green background, white text, "Invite"
- Disabled (handicap validation failed): Gray background, gray text, "Cannot Invite"
- Loading (during invite): Spinner, "Inviting..."
- Success (after invite): Green checkmark, "Invited" (briefly, then fade out or replace with new state)

**Search Bar States:**

- Empty: Show placeholder
- Typing: Show clear button
- Loading results: Show spinner in field
- Results loaded: Display results list

### Success Feedback

When user taps "Invite" and it succeeds:

- Show snackbar at bottom: "Invitation sent to [Name]"
- Green checkmark icon
- Auto-dismiss after 2-3 seconds
- Remove invited user from search results (or show "Invited" state on their card)

### Error Feedback

If invite fails:

- Show snackbar: "Failed to send invitation. Please try again."
- Red error icon
- Action button: "Retry"

## Design Notes

1. **Focus on search functionality** - This is the primary action, make it prominent
2. **Clear handicap validation** - Users must understand why they can't invite someone
3. **Minimal cognitive load** - Don't overwhelm with too many options
4. **Progressive disclosure** - Custom message is optional, can be collapsed
5. **Future features clearly marked** - Show placeholders for upcoming features but make it clear they're not ready yet
6. **Mobile-first** - Design for phone screen sizes (375px - 414px width)
7. **Thumb-friendly** - Important actions within easy reach
8. **Consistent with app** - Use established patterns from existing screens

## Example User Flow

1. Captain opens Society Members Screen
2. Taps "Invite Members" FAB
3. Navigates to this screen
4. Types "John" in search bar
5. Sees 2 results: "John Smith" and "John Doe"
6. John Smith has handicap "12" (valid) - can invite
7. John Doe has handicap "30" (outside society limits 0-24) - cannot invite, sees error
8. Captain taps "Invite" for John Smith
9. Optional: Adds custom message "Looking forward to playing with you!"
10. Invitation sent, snackbar appears
11. John Smith receives notification (not shown on this screen)

## References

- Similar patterns: Society Members Screen (member list display)
- Similar patterns: Add Member Screen (search and validation)
- Material Design: Search patterns, list items, badges
