-- Update Members Table for Primary Member Profiles
-- This migration enables the single identity architecture where:
-- - Each user gets ONE primary member profile (society_id = NULL) created at registration
-- - Users can then join societies, creating additional member records with society_id set
-- - This ensures proper identity management and avoids data duplication

-- =============================================================================
-- ALTER MEMBERS TABLE
-- =============================================================================

-- 1. Make society_id nullable to support primary member profiles
ALTER TABLE members
    ALTER COLUMN society_id DROP NOT NULL;

-- 2. Drop the existing unique constraint (society_id, user_id)
-- since it doesn't handle NULL society_id correctly
ALTER TABLE members
    DROP CONSTRAINT members_unique_user_society;

-- 3. Add unique constraint for primary member profiles (one per user)
-- This ensures each user has exactly ONE primary member where society_id IS NULL
CREATE UNIQUE INDEX idx_members_primary_unique
    ON members (user_id)
    WHERE society_id IS NULL;

-- 4. Add unique constraint for society memberships (one per user per society)
-- This ensures a user can only be a member of each society once
CREATE UNIQUE INDEX idx_members_society_unique
    ON members (society_id, user_id)
    WHERE society_id IS NOT NULL;

-- 5. Update handicap column to use DECIMAL for more precision
-- Golf handicaps can be fractional (e.g., 8.4, 12.3)
ALTER TABLE members
    ALTER COLUMN handicap TYPE DECIMAL(4,1);

-- 6. Make role nullable for primary members (role only applies to society memberships)
ALTER TABLE members
    ALTER COLUMN role DROP NOT NULL,
    ALTER COLUMN role DROP DEFAULT;

-- 7. Update role check constraint to allow NULL
ALTER TABLE members
    DROP CONSTRAINT members_role_valid;

ALTER TABLE members
    ADD CONSTRAINT members_role_valid
    CHECK (role IS NULL OR role IN ('CAPTAIN', 'MEMBER'));

-- 8. Add columns needed for primary member profiles
ALTER TABLE members
    ADD COLUMN IF NOT EXISTS avatar_url TEXT,
    ADD COLUMN IF NOT EXISTS joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ADD COLUMN IF NOT EXISTS last_played_at TIMESTAMPTZ;

-- 9. Add check constraint: if society_id IS NOT NULL, role must be set
ALTER TABLE members
    ADD CONSTRAINT members_society_requires_role
    CHECK (
        (society_id IS NULL AND role IS NULL)
        OR
        (society_id IS NOT NULL AND role IS NOT NULL)
    );

-- =============================================================================
-- UPDATE RLS POLICIES
-- =============================================================================

-- Drop existing member SELECT policy since it doesn't handle primary members
DROP POLICY IF EXISTS "View members in your societies" ON members;

-- New SELECT policy: Users can view:
-- 1. Their own primary member profile (society_id IS NULL)
-- 2. Members in societies they belong to
CREATE POLICY "View own profile and society members"
    ON members
    FOR SELECT
    TO authenticated
    USING (
        -- Own primary profile
        (user_id = auth.uid() AND society_id IS NULL)
        OR
        -- Members in societies you belong to
        (society_id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND society_id IS NOT NULL
            AND status = 'ACTIVE'
        ))
    );

-- Drop existing INSERT policy for members
DROP POLICY IF EXISTS "Captains can add members to their societies" ON members;

-- New INSERT policy:
-- 1. Users can create their own primary profile (during sign up)
-- 2. Users can join societies (create society membership)
-- 3. Captains can add members to their societies
CREATE POLICY "Create primary profile, join societies, or captains add members"
    ON members
    FOR INSERT
    TO authenticated
    WITH CHECK (
        -- User creating their own primary profile
        (user_id = auth.uid() AND society_id IS NULL)
        OR
        -- User joining a society (creating their own society membership)
        (user_id = auth.uid() AND society_id IS NOT NULL)
        OR
        -- Captain adding a member to their society
        (society_id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        ))
    );

-- Update the existing UPDATE policy to include primary profiles
DROP POLICY IF EXISTS "Members can update their own profile" ON members;

CREATE POLICY "Members can update their own profiles"
    ON members
    FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Note: "Captains can update members in their societies" policy remains unchanged
-- Note: "Captains can remove members from their societies" policy remains unchanged

-- =============================================================================
-- UPDATE INDEXES
-- =============================================================================

-- Add index for primary member lookups (by user_id where society_id IS NULL)
CREATE INDEX idx_members_primary_user
    ON members (user_id)
    WHERE society_id IS NULL;

-- =============================================================================
-- UPDATE COMMENTS
-- =============================================================================

COMMENT ON COLUMN members.society_id IS 'References the society (NULL for primary member profile, set for society memberships)';
COMMENT ON COLUMN members.role IS 'Member role in society: CAPTAIN (admin) or MEMBER (regular). NULL for primary profiles.';
COMMENT ON COLUMN members.avatar_url IS 'URL to member avatar image in Supabase Storage';
COMMENT ON COLUMN members.joined_at IS 'When the member profile/membership was created';
COMMENT ON COLUMN members.last_played_at IS 'Timestamp of last round played (NULL if never played)';
COMMENT ON COLUMN members.handicap IS 'Golf handicap index with one decimal precision (0.0-54.0)';

-- =============================================================================
-- MIGRATION NOTES
-- =============================================================================

-- This migration maintains backward compatibility:
-- - Existing society members remain unchanged (they have society_id set)
-- - New users will get primary profiles created during sign up
-- - The application will handle the migration of existing users to have primary profiles
