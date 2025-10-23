-- Fix Society UPDATE RLS Policy
-- The existing policy only allows soft deletes, but we need to allow general updates too

-- Drop the existing policy that's too restrictive
DROP POLICY IF EXISTS "Owners can soft delete societies" ON societies;

-- Create separate policies for different UPDATE operations

-- 1. Allow owners/co-owners/captains to update society settings (not deleted_at)
CREATE POLICY "Owners and captains can update society settings"
ON societies FOR UPDATE TO authenticated
USING (
    deleted_at IS NULL -- Can only update active (non-deleted) societies
    AND (
        is_society_captain(auth.uid(), id)
        OR EXISTS (
            SELECT 1 FROM members m
            WHERE m.society_id = id
            AND m.user_id = auth.uid()
            AND m.role IN ('OWNER', 'CO_OWNER', 'CAPTAIN')
            AND m.status = 'ACTIVE'
        )
    )
)
WITH CHECK (
    deleted_at IS NULL -- Cannot set deleted_at through normal updates
    AND (
        is_society_captain(auth.uid(), id)
        OR EXISTS (
            SELECT 1 FROM members m
            WHERE m.society_id = id
            AND m.user_id = auth.uid()
            AND m.role IN ('OWNER', 'CO_OWNER', 'CAPTAIN')
            AND m.status = 'ACTIVE'
        )
    )
);

-- 2. Allow only owners to soft-delete societies (set deleted_at)
CREATE POLICY "Owners can soft delete societies"
ON societies FOR UPDATE TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = id
        AND m.user_id = auth.uid()
        AND m.role IN ('OWNER', 'CO_OWNER')
        AND m.status = 'ACTIVE'
    )
)
WITH CHECK (
    -- Only allow setting deleted_at, not unsetting it
    deleted_at IS NOT NULL
    AND EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = id
        AND m.user_id = auth.uid()
        AND m.role IN ('OWNER', 'CO_OWNER')
        AND m.status = 'ACTIVE'
    )
);

-- Note: These policies work together:
-- - First policy allows CAPTAIN/OWNER/CO_OWNER to update settings on active societies
-- - Second policy allows only OWNER/CO_OWNER to soft-delete societies
-- - The WITH CHECK on the first policy prevents setting deleted_at through normal updates
-- - The WITH CHECK on the second policy ensures deleted_at can only be set, not unset
