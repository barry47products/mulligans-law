-- Update Societies and Members Schema for Enhanced Features
-- This migration adds support for:
-- - Owner/Co-Owner roles
-- - PENDING/RESIGNED member status
-- - Invitation expiry tracking
-- - Soft delete for societies
-- - Handicap limits for societies

-- =============================================================================
-- UPDATE MEMBERS TABLE
-- =============================================================================

-- 1. Update role constraint to include OWNER and CO_OWNER
ALTER TABLE members
DROP CONSTRAINT IF EXISTS members_role_valid;

ALTER TABLE members
ADD CONSTRAINT members_role_valid CHECK (role IN ('MEMBER', 'CAPTAIN', 'OWNER', 'CO_OWNER'));

-- 2. Update status constraint to use PENDING, ACTIVE, RESIGNED (remove INACTIVE)
ALTER TABLE members
DROP CONSTRAINT IF EXISTS members_status_valid;

ALTER TABLE members
ADD CONSTRAINT members_status_valid CHECK (status IN ('PENDING', 'ACTIVE', 'RESIGNED'));

-- 3. Add expires_at field for PENDING invitations (7-day expiry)
ALTER TABLE members
ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ;

COMMENT ON COLUMN members.expires_at IS 'Expiry date for PENDING invitations (7 days from created_at)';

-- 4. Add rejection_message field for declined join requests
ALTER TABLE members
ADD COLUMN IF NOT EXISTS rejection_message TEXT;

COMMENT ON COLUMN members.rejection_message IS 'Optional message from captain when rejecting a join request';

-- 5. Add partial index for pending members with expiry
CREATE INDEX IF NOT EXISTS idx_members_status_expires_at
ON members(status, expires_at)
WHERE status = 'PENDING';

-- =============================================================================
-- UPDATE SOCIETIES TABLE
-- =============================================================================

-- 1. Add deleted_at field for soft delete
ALTER TABLE societies
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

COMMENT ON COLUMN societies.deleted_at IS 'Timestamp when society was soft-deleted. NULL = active society';

-- 2. Add handicap_limit_enabled field
ALTER TABLE societies
ADD COLUMN IF NOT EXISTS handicap_limit_enabled BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN societies.handicap_limit_enabled IS 'Whether handicap limits are enforced for membership';

-- 3. Add handicap_min field (nullable, only used when limits enabled)
ALTER TABLE societies
ADD COLUMN IF NOT EXISTS handicap_min INTEGER;

COMMENT ON COLUMN societies.handicap_min IS 'Minimum handicap allowed (+8 to 36). NULL when limits disabled';

-- 4. Add handicap_max field (nullable, only used when limits enabled)
ALTER TABLE societies
ADD COLUMN IF NOT EXISTS handicap_max INTEGER;

COMMENT ON COLUMN societies.handicap_max IS 'Maximum handicap allowed (+8 to 36). NULL when limits disabled';

-- 5. Add index for soft delete filtering
CREATE INDEX IF NOT EXISTS idx_societies_deleted_at ON societies(deleted_at);

-- 6. Add constraints for handicap limits
ALTER TABLE societies
ADD CONSTRAINT societies_handicap_min_max_order CHECK (
    handicap_min IS NULL OR handicap_max IS NULL OR handicap_min <= handicap_max
);

ALTER TABLE societies
ADD CONSTRAINT societies_handicap_min_range CHECK (
    handicap_min IS NULL OR (handicap_min >= -8 AND handicap_min <= 36)
);

ALTER TABLE societies
ADD CONSTRAINT societies_handicap_max_range CHECK (
    handicap_max IS NULL OR (handicap_max >= -8 AND handicap_max <= 36)
);

-- =============================================================================
-- UPDATE RLS POLICIES FOR SOCIETIES
-- =============================================================================

-- Drop existing SELECT policy to recreate with soft delete filter
DROP POLICY IF EXISTS "Society members can view their societies" ON societies;

-- Recreate SELECT policy with soft delete filter
CREATE POLICY "Society members can view their societies"
ON societies FOR SELECT TO authenticated
USING (
    deleted_at IS NULL -- Only show non-deleted societies
    AND id IN (SELECT society_id FROM get_user_society_ids(auth.uid()))
);

-- Add policy for viewing soft-deleted societies (read-only for former members)
CREATE POLICY "Members can view deleted societies they belonged to"
ON societies FOR SELECT TO authenticated
USING (
    deleted_at IS NOT NULL -- Only applies to deleted societies
    AND id IN (
        SELECT DISTINCT m.society_id
        FROM members m
        WHERE m.user_id = auth.uid()
        AND m.society_id IS NOT NULL
    )
);

-- Add policy for owners to soft-delete societies (UPDATE deleted_at)
CREATE POLICY "Owners can soft delete societies"
ON societies FOR UPDATE TO authenticated
USING (
    is_society_captain(auth.uid(), id)
    OR EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = id
        AND m.user_id = auth.uid()
        AND m.role IN ('OWNER', 'CO_OWNER')
        AND m.status = 'ACTIVE'
    )
)
WITH CHECK (
    is_society_captain(auth.uid(), id)
    OR EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = id
        AND m.user_id = auth.uid()
        AND m.role IN ('OWNER', 'CO_OWNER')
        AND m.status = 'ACTIVE'
    )
);

-- =============================================================================
-- DATA MIGRATION
-- =============================================================================

-- 1. Migrate existing INACTIVE members to RESIGNED
UPDATE members
SET status = 'RESIGNED'
WHERE status = 'INACTIVE';

-- 2. Set handicap_limit_enabled to false for all existing societies
UPDATE societies
SET handicap_limit_enabled = false
WHERE handicap_limit_enabled IS NULL;

-- 3. Promote society creators to OWNER role
-- Note: This assumes the first CAPTAIN who created the society should become OWNER
-- We'll promote the earliest captain member (by created_at) for each society to OWNER
WITH first_captains AS (
    SELECT DISTINCT ON (society_id)
        id,
        society_id
    FROM members
    WHERE role = 'CAPTAIN'
    AND status = 'ACTIVE'
    ORDER BY society_id, created_at ASC
)
UPDATE members m
SET role = 'OWNER'
FROM first_captains fc
WHERE m.id = fc.id;

-- =============================================================================
-- VERIFICATION QUERIES (commented out - for manual testing)
-- =============================================================================

-- Verify role enum values
-- SELECT constraint_name, check_clause
-- FROM information_schema.check_constraints
-- WHERE constraint_name = 'members_role_valid';

-- Verify status enum values
-- SELECT constraint_name, check_clause
-- FROM information_schema.check_constraints
-- WHERE constraint_name = 'members_status_valid';

-- Verify new columns added
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_name IN ('members', 'societies')
-- AND column_name IN ('expires_at', 'rejection_message', 'deleted_at', 'handicap_limit_enabled', 'handicap_min', 'handicap_max');

-- Verify indexes created
-- SELECT indexname, indexdef
-- FROM pg_indexes
-- WHERE tablename IN ('members', 'societies')
-- AND indexname IN ('idx_members_status_expires_at', 'idx_societies_deleted_at');

-- Verify constraints
-- SELECT constraint_name, check_clause
-- FROM information_schema.check_constraints
-- WHERE constraint_name LIKE 'societies_handicap%';

-- Verify RLS policies
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
-- FROM pg_policies
-- WHERE tablename IN ('societies', 'members')
-- ORDER BY tablename, policyname;
