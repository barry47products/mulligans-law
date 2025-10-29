# AI Design Prompt: Add Member Screen

## Context

Create a UI design for the "Add Member" form in the Mulligans Law golf society management app. This screen allows captains and owners to add members directly to their society with proper handicap validation.

## App Design System

### Colors

- **Primary**: #4CD4B0 (Mint green)
- **Background**: #F8F9FB (Light grey-blue)
- **Surface**: #FFFFFF (White)
- **Text Primary**: #2D3436 (Dark charcoal)
- **Text Secondary**: #636E72 (Medium grey)
- **Error**: #E74C3C (Red)
- **Success**: #27AE60 (Green)

### Typography

- **Heading Medium**: 24px, Semibold
- **Body Large**: 16px, Regular
- **Body Medium**: 14px, Regular
- **Button Text**: 14px, Semibold

### Spacing (8-point grid)

- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px

## Screen Requirements

### Route

- Within Societies tab Navigator: `/societies/:id/members/add`
- Only accessible by captains and owners

### Form Fields

1. **Name** (required)

   - Text input
   - Placeholder: "Enter member's name"
   - Validation: Required, min 2 characters

2. **Email** (required)

   - Email input
   - Placeholder: "Enter member's email"
   - Validation: Required, valid email format
   - Error: "Email already a member" if duplicate

3. **Handicap** (required)

   - Dropdown selector
   - Range: +8 to 36
   - Default: 0 (scratch)
   - Display format: "+8", "+4", "0", "12", "24", "36"
   - Label: "Handicap"

4. **Role** (required)
   - Dropdown selector
   - Options: "Member", "Captain"
   - Default: "Member"
   - Note: Only owners can assign Captain role
   - Label: "Role"

### Handicap Limit Warning

If society has handicap limits enabled:

- Show info banner at top: "This society has handicap limits: [min] - [max]"
- Banner style: Light blue background, info icon
- If selected handicap outside limits:
  - Show error below handicap field
  - Block form submission
  - Error message: "Handicap [X] is outside society limits ([min] - [max])"

### Actions

- **Submit Button**: "Add Member"

  - Full width
  - Primary color
  - Disabled until form valid
  - Loading state during submission

- **Cancel**: Back navigation (app bar back button)

### Success Flow

- Submit → Loading → Success
- Navigate back to members list
- Show snackbar: "Member added successfully"
- Refresh member list

### Error Handling

- Invalid email format
- Email already a member
- Handicap outside society limits
- Network errors
- Generic errors

## UI Layout

```bash
┌────────────────────────────┐
│ ← Add Member               │ <- App Bar
├────────────────────────────┤
│                            │
│ ℹ️ Society handicap limits:│ <- Info banner (if limits enabled)
│    10 - 28                 │
│                            │
│ Name *                     │
│ ┌────────────────────────┐ │
│ │ Enter member's name    │ │
│ └────────────────────────┘ │
│                            │
│ Email *                    │
│ ┌────────────────────────┐ │
│ │ Enter member's email   │ │
│ └────────────────────────┘ │
│                            │
│ Handicap *                 │
│ ┌────────────────────────┐ │
│ │ 0 ▼                    │ │
│ └────────────────────────┘ │
│ ⚠️  Handicap outside limits │ <- Error (if applicable)
│                            │
│ Role *                     │
│ ┌────────────────────────┐ │
│ │ Member ▼               │ │
│ └────────────────────────┘ │
│                            │
│ ┌────────────────────────┐ │
│ │     Add Member         │ │ <- Submit button
│ └────────────────────────┘ │
└────────────────────────────┘
```

## Accessibility

- All form fields have labels
- Error messages are clear and actionable
- Keyboard navigation support
- Screen reader compatible
