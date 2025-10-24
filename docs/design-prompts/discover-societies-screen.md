# AI Design Prompt: Discover Societies Screen

## Context

Create a UI design for the "Discover Societies" feature in the Mulligans Law golf society management app. This screen allows users to browse and request to join public golf societies.

## App Design System

### Colors

- **Primary**: #4CD4B0 (Mint green)
- **Primary Dark**: #3AB895
- **Primary Light**: #6FE4C8
- **Background**: #F8F9FB (Light grey-blue)
- **Surface**: #FFFFFF (White)
- **Text Primary**: #2D3436 (Dark charcoal)
- **Text Secondary**: #636E72 (Medium grey)
- **Success**: #27AE60 (Green)
- **Error**: #E74C3C (Red)
- **Warning**: #F39C12 (Orange)
- **Info**: #3498DB (Blue)

### Typography

- **Font Family**: Inter (fallback: Roboto)
- **Heading Large**: 32px, Bold
- **Heading Medium**: 24px, Semibold
- **Heading Small**: 20px, Semibold
- **Body Large**: 16px, Regular
- **Body Medium**: 14px, Regular
- **Body Small**: 12px, Regular
- **Button Text**: 14px, Semibold

### Spacing (8-point grid)

- **xs**: 4px
- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px
- **xxl**: 48px

### Component Styles

- **Card**: White background, subtle shadow, 12px rounded corners
- **Button**: Rounded 8px, height 48px, semibold text
- **Badge**: Small pill-shaped containers with 12px border radius

## Screen Requirements

### Navigation

- **Tab Bar Integration**: This is a new tab within the SocietyListScreen
- **Two Tabs**: "My Societies" (existing) | "Discover" (new)
- Tab indicator should use primary color (#4CD4B0)

### Header Section

- **Title**: "Discover Societies" (Heading Medium, 24px)
- **Subtitle**: "Find and join public golf societies" (Body Medium, text secondary)
- **Spacing**: 24px padding top, 16px padding bottom

### Society Cards (Scrollable List)

Each card should display:

#### Card Layout

- **White background** with subtle shadow
- **16px padding** all around
- **12px rounded corners**
- **8px margin** between cards

#### Card Content Structure (Top to Bottom)

1. **Header Row**:

   - **Society Name** (Heading Small, 20px, semibold, text primary)
   - **Member Count Badge** (top-right corner)
     - Format: "24 members"
     - Background: grey100 (#F5F5F5)
     - Text: Body Small, text secondary
     - Padding: 4px 8px
     - Border radius: 12px

2. **Description** (if present):

   - Body Medium, text secondary
   - Max 2 lines with ellipsis
   - 8px margin top

3. **Info Row** (if handicap limits enabled):

   - **Icon**: Small info icon (#3498DB)
   - **Text**: "Handicap range: [min] - [max]"
   - Body Small, text secondary
   - 8px margin top

4. **Action Button** (always visible):

   - Full width button
   - 12px margin top
   - Height: 48px
   - Border radius: 8px

   **Button States**:

   a) **Can Join** (user's handicap is within limits or no limits):

   - Background: Primary (#4CD4B0)
   - Text: "Request to Join" (white, semibold)
   - Enabled state

   b) **Cannot Join** (user's handicap outside limits):

   - Background: grey200 (#EEEEEE)
   - Text: "Cannot Join" (text secondary, semibold)
   - Disabled state
   - Show helper text below button:
     - "Your handicap ([X]) is outside this society's limits"
     - Body Small, error color (#E74C3C)
     - 4px margin top

   c) **Pending Approval**:

   - Background: Warning (#F39C12)
   - Text: "Pending Approval" (white, semibold)
   - Disabled state
   - Show helper text below button:
     - "Request sent. Awaiting captain approval."
     - Body Small, text secondary
     - 4px margin top

### Empty State

If no public societies are available:

- **Icon**: Large groups icon (grey400, 64px)
- **Title**: "No public societies found" (Heading Small, text primary)
- **Message**: "Public societies will appear here when available" (Body Medium, text secondary)
- **Spacing**: Centered vertically and horizontally with 24px padding

### Loading State

- **Spinner**: Primary color (#4CD4B0)
- **Centered** in screen
- No additional text needed

### Interaction States

#### Society Card Tap

- Card should have subtle ripple effect
- Tapping card navigates to society details/dashboard (read-only preview)

#### "Request to Join" Button Tap

- Show confirmation bottom sheet:
  - **Title**: "Request to Join [Society Name]?"
  - **Message**: "You'll be notified when a captain approves your request"
  - **Cancel Button**: Text button, text secondary
  - **Confirm Button**: Primary button, "Send Request"

#### Success Feedback

- After successful request:
  - Green snackbar at bottom
  - Message: "Join request sent to [Society Name]"
  - Auto-dismiss after 3 seconds

#### Error Feedback

- If request fails:
  - Red snackbar at bottom
  - Message: [Error message from backend]
  - Auto-dismiss after 5 seconds

## Mobile Considerations

- **Minimum touch target**: 48x48px for all buttons
- **Scroll performance**: Use ListView.builder for efficient rendering
- **Pull-to-refresh**: Implement refresh indicator with primary color
- **Safe area**: Respect device safe areas (notches, home indicators)

## Accessibility

- **Semantic labels**: All buttons and interactive elements
- **Color contrast**: Minimum 4.5:1 for normal text, 3:1 for large text
- **Focus indicators**: Visible focus rings for keyboard navigation
- **Screen reader**: Descriptive labels for all UI elements

## Design Inspiration

- **Style**: Clean, modern, card-based layout
- **Mood**: Welcoming, community-focused, easy to browse
- **Reference**: Similar to LinkedIn groups discovery, Facebook groups browse

## Technical Notes

- **Framework**: Flutter Material 3
- **State Management**: BLoC pattern
- **Data Source**: Supabase query (is_public = true, deleted_at IS NULL)
- **Real-time Updates**: Optional - refresh on pull-down

## Deliverable

Please provide:

1. High-fidelity mockup of the Discover Societies tab
2. Show at least 3 society cards with different states (can join, cannot join, pending)
3. Include empty state design
4. Mobile dimensions: 375x812 (iPhone X/11 Pro dimensions)
5. Export as PNG at 2x resolution

## Questions to Consider

1. Should we show society logos/images when available?
2. Should there be filtering/search within public societies?
3. How many cards should be visible before scrolling?
4. Should we show distance to society location (future feature)?

---

**Design Goal**: Create an inviting, easy-to-scan interface that makes it simple for users to discover and join golf societies that match their handicap range.
