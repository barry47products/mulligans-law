# AI Design Prompt: Society Form Screen (Create/Edit)

**Design Request for Miro/Figma:** Create a mobile screen design for creating/editing a golf society in the Mulligans Law app.

---

## App Design System

### Color Palette

- **Primary:** #4CD4B0 (Mint green) - Used for buttons, toggles, active states
- **Primary Dark:** #3AB895 - Hover states
- **Primary Light:** #6FE4C8 - Light accents
- **Background:** #F8F9FB (Light grey-blue) - Screen background
- **Surface:** #FFFFFF (Pure white) - Cards, form fields
- **Text Primary:** #2D3436 (Dark charcoal) - Main text
- **Text Secondary:** #636E72 (Medium grey) - Helper text, labels
- **Success:** #27AE60 (Green) - Success states
- **Error:** #E74C3C (Red) - Validation errors
- **Warning:** #F39C12 (Orange) - Warnings
- **Grey 300:** #E0E0E0 - Borders, dividers

### Typography

- **Screen Title:** 20px, Bold, #2D3436
- **Section Headers:** 16px, Bold, #2D3436
- **Body Text:** 16px, Regular, #2D3436
- **Input Labels:** 14px, Medium, #2D3436
- **Helper Text:** 12px, Regular, #636E72
- **Button Text:** 16px, Medium, #FFFFFF

### Spacing (8-point grid)

- **Tight:** 8px - Between related elements
- **Standard:** 16px - Between form fields
- **Section:** 24px - Between sections
- **Large:** 32px - Between major sections
- **Screen Padding:** 20px horizontal, 24px vertical
- **Input/Button Height:** 48px minimum

### Component Styles

- **Border Radius:** 8px for inputs, buttons, cards
- **Input Border:** 1px solid #E0E0E0, focus: 2px solid #4CD4B0
- **Button:** Full width, 48px height, rounded 8px
- **Toggle Switch:** Mint green (#4CD4B0) when ON, grey when OFF
- **Section Divider:** 1px solid #E0E0E0, 24px top/bottom margin

---

## Screen Layout

### Header (Fixed)

```bash
┌─────────────────────────────────┐
│ ← [Back]  Create Society        │  ← 56px height, white background
└─────────────────────────────────┘
```

- Back arrow: Mint green (#4CD4B0)
- Title: "Create Society" or "Edit Society" (centered or left-aligned)
- Background: White (#FFFFFF)

### Form Content (Scrollable)

20px horizontal padding throughout

#### Section 1: Basic Information

```bash
Society Name *
┌─────────────────────────────────┐
│ [Text Input Field]              │  ← 48px height, white bg
└─────────────────────────────────┘
Helper: "Maximum 100 characters"

Description (Optional)
┌─────────────────────────────────┐
│ [Multi-line Text Input]         │  ← 96px height (4 lines)
│                                 │
│                                 │
└─────────────────────────────────┘
Helper: "Tell members about your society"
```

#### Section 2: Privacy Settings

```bash
─────────────────────────────────── ← Divider

Privacy Settings

[ ] Make society public              ← Toggle OFF by default
Helper: "Private: Only invited members can join
        Public: Anyone can discover and request to join
        Both require approval"
```

#### Section 3: Handicap Requirements

```bash
─────────────────────────────────── ← Divider

Handicap Requirements

[ ] Enforce handicap limits          ← Toggle OFF by default

[WHEN TOGGLE IS ON, SHOW:]
┌─────────────────────────────────┐
│     +8    0     18    36        │  ← Labels above slider
│     ●─────○─────────────○       │  ← RangeSlider with 2 thumbs
│                                 │
│   Handicap Range: 0 - 24        │  ← Current values displayed
└─────────────────────────────────┘
Helper: "Members outside this range cannot join
        In golf, +8 is better than 0 (scratch)"
```

#### Section 4: Location

```bash
─────────────────────────────────── ← Divider

Location (Coming Soon)

┌─────────────────────────────────┐
│ [City or course name]            │  ← Placeholder text, greyed out
└─────────────────────────────────┘
Helper: "Location picker coming soon"
```

#### Section 5: Society Rules

```bash
─────────────────────────────────── ← Divider

Society Rules (Optional)

┌─────────────────────────────────┐
│ [Multi-line Text Area]          │  ← 128px height (6-8 lines)
│                                 │
│                                 │
│                                 │
└─────────────────────────────────┘
Placeholder: "Enter any rules or guidelines..."
```

#### Section 6: Society Logo

```bash
─────────────────────────────────── ← Divider

Society Logo (Optional)

┌─────────────────────────────────┐
│         📷                      │  ← Camera icon, centered
│    Tap to upload                │  ← Greyed out text
└─────────────────────────────────┘
Helper: "Image upload coming soon"
```

### Footer (Fixed)

```bash
┌─────────────────────────────────┐
│  [     Save Society     ]       │  ← 48px height, mint green
└─────────────────────────────────┘
        24px bottom padding

[Loading State: Show spinner below button]
```

### Bottom Navigation Bar (Fixed)

```bash
┌─────────────────────────────────┐
│  🏠    👥    📅   🏆    👤      │  ← 5 icons, 56px height
│ Home   Soc  Evt  Lead  Prof     │
└─────────────────────────────────┘
```

- Societies tab (👥) highlighted in mint green
- Other tabs in grey

---

## Interaction States

### Toggle Switch States

- **OFF:** Grey background, white circle on left
- **ON:** Mint green background (#4CD4B0), white circle on right
- **Transition:** Smooth 200ms animation

### Input Field States

- **Default:** 1px solid #E0E0E0 border
- **Focus:** 2px solid #4CD4B0 border, slight glow
- **Error:** 2px solid #E74C3C border, red helper text below
- **Disabled:** Grey background (#F3F4F6), grey text

### Handicap Range Slider (When Enabled)

- **Track:** Grey line (#E0E0E0)
- **Filled Track:** Mint green (#4CD4B0) between thumbs
- **Thumbs:** White circles with mint green border, 24px diameter
- **Labels:** Above slider at +8, 0, 18, 36 positions
- **Value Display:** Below slider, bold, updated in real-time

### Button States

- **Default:** Mint green (#4CD4B0), white text
- **Pressed:** Darker mint (#3AB895)
- **Loading:** Show CircularProgressIndicator below button, button stays enabled
- **Disabled:** Grey (#E0E0E0), grey text

### Validation Errors

- Red text (#E74C3C) appears below field
- Examples:
  - "Society name is required"
  - "Minimum handicap must be less than maximum"

---

## Business Rules to Display

### Create Mode

- Title: "Create Society"
- All fields empty
- Privacy toggle: OFF (Private)
- Handicap limits toggle: OFF
- Save button: "Save Society"

### Edit Mode

- Title: "Edit Society"
- All fields pre-filled with existing data
- Toggles reflect current settings
- If handicap limits enabled, show slider with current values
- Save button: "Save Changes"

### Validation Rules

1. **Society Name:** Required, max 100 characters
2. **Handicap Limits:** If enabled:
   - Min must be <= Max
   - Both must be in range +8 to 36
   - Default when enabled: 0 (min) to 24 (max)

### User Flow

1. User fills in society name (required)
2. Optionally fills description
3. Toggles privacy (default OFF)
4. Optionally enables handicap limits and sets range
5. Optionally adds location (placeholder)
6. Optionally adds rules
7. Optionally uploads logo (placeholder)
8. Taps Save → Success → Navigate back to society list

---

## Layout Notes

- **Mobile-first:** Design for iOS/Android, 375px width minimum
- **Scrollable content:** Everything between header and footer scrolls
- **Fixed elements:** Header, Save button, Bottom nav stay fixed
- **Touch targets:** Minimum 44x44px for all interactive elements
- **Accessibility:** High contrast, readable text sizes, clear labels
- **Visual hierarchy:** Section headers bold, generous spacing between sections
- **Progressive disclosure:** Only show handicap slider when toggle is ON
- **Placeholders:** Clear indication for "coming soon" features

---

## Style Guidelines

- **Clean & Modern:** Minimal UI, focus on content
- **Golf-Inspired:** Mint green accents, professional but approachable
- **White Space:** Don't crowd elements, use padding generously
- **Consistency:** Match existing app patterns (bottom nav, colors, spacing)
- **Feedback:** Clear validation messages, loading states
- **Delight:** Smooth animations, satisfying interactions

---

## Export Requirements

- **Format:** PNG or SVG at 2x or 3x resolution
- **Artboards:**
  1. Create Mode - All fields empty
  2. Edit Mode - Pre-filled fields
  3. Validation Errors - Show error states
  4. Handicap Slider Expanded - Toggle ON with slider
- **Annotations:** Label interactive elements, states, and spacing

---

Use this prompt to generate a high-fidelity mobile screen design that matches the Mulligans Law design system and includes all specified features and business rules.
