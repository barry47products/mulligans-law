-- Fix Society UPDATE RLS Policies - Version 2
-- Drop ALL existing UPDATE policies and recreate them correctly

-- Drop all existing UPDATE policies on societies table
DROP POLICY IF EXISTS "Captains can update their society" ON societies;
DROP POLICY IF EXISTS "Owners and captains can update society settings" ON societies;
DROP POLICY IF EXISTS "Owners can soft delete societies" ON societies;

-- Create a single, comprehensive UPDATE policy for society settings
CREATE POLICY "Society leadership can update settings"
ON societies FOR UPDATE TO authenticated
USING (
    deleted_at IS NULL -- Can only update active (non-deleted) societies
    AND (
        -- Use the is_society_captain helper function
        is_society_captain(auth.uid(), id)
        OR 
        -- Or check if user is OWNER, CO_OWNER, or CAPTAIN with ACTIVE status
        EXISTS (
            SELECT 1 
            FROM members m
            WHERE m.society_id = societies.id  -- Explicitly reference societies.id
            AND m.user_id = auth.uid()
            AND m.role IN ('OWNER', 'CO_OWNER', 'CAPTAIN')
            AND m.status = 'ACTIVE'
        )
    )
)
WITH CHECK (
    deleted_at IS NULL -- Prevent setting deleted_at through this policy
    AND (
        is_society_captain(auth.uid(), id)
        OR 
        EXISTS (
            SELECT 1 
            FROM members m
            WHERE m.society_id = societies.id  -- Explicitly reference societies.id
            AND m.user_id = auth.uid()
            AND m.role IN ('OWNER', 'CO_OWNER', 'CAPTAIN')
            AND m.status = 'ACTIVE'
        )
    )
);

-- Note: We're keeping it simple with one policy
-- The deleted_at field should be handled through a separate soft delete function
-- rather than through direct UPDATE statements
