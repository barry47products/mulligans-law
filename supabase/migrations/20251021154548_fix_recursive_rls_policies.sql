-- Fix Recursive RLS Policies
-- This migration fixes the infinite recursion issue in the members table RLS policies
-- by using security definer functions to break the circular dependency

-- =============================================================================
-- SECURITY DEFINER FUNCTIONS
-- =============================================================================

-- Function to get society IDs for a user (used to avoid recursive RLS checks)
CREATE OR REPLACE FUNCTION get_user_society_ids(p_user_id UUID)
RETURNS TABLE(society_id UUID)
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT m.society_id
    FROM members m
    WHERE m.user_id = p_user_id
    AND m.society_id IS NOT NULL
    AND m.status = 'ACTIVE';
END;
$$;

-- Function to check if user is a captain of a society
CREATE OR REPLACE FUNCTION is_society_captain(p_user_id UUID, p_society_id UUID)
RETURNS BOOLEAN
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM members m
        WHERE m.user_id = p_user_id
        AND m.society_id = p_society_id
        AND m.role = 'CAPTAIN'
        AND m.status = 'ACTIVE'
    );
END;
$$;

-- =============================================================================
-- DROP EXISTING POLICIES
-- =============================================================================

-- Drop all existing policies on members table
DROP POLICY IF EXISTS "View own profile and society members" ON members;
DROP POLICY IF EXISTS "Create primary profile, join societies, or captains add members" ON members;
DROP POLICY IF EXISTS "Members can update their own profiles" ON members;
DROP POLICY IF EXISTS "Captains can update members in their societies" ON members;
DROP POLICY IF EXISTS "Captains can remove members from their societies" ON members;

-- Drop all existing policies on societies table
DROP POLICY IF EXISTS "View societies you are a member of" ON societies;
DROP POLICY IF EXISTS "Captains can update their society" ON societies;
DROP POLICY IF EXISTS "Captains can delete their society" ON societies;
DROP POLICY IF EXISTS "Anyone authenticated can create societies" ON societies;

-- =============================================================================
-- NEW NON-RECURSIVE POLICIES FOR MEMBERS
-- =============================================================================

-- SELECT: Users can view their own profiles and members in their societies
CREATE POLICY "View own profile and society members"
    ON members
    FOR SELECT
    TO authenticated
    USING (
        -- Own primary profile
        (user_id = auth.uid() AND society_id IS NULL)
        OR
        -- Own society memberships
        (user_id = auth.uid() AND society_id IS NOT NULL)
        OR
        -- Members in societies you belong to (using security definer function)
        (society_id IN (SELECT get_user_society_ids(auth.uid())))
    );

-- INSERT: Create primary profile, join societies, or captains add members
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
        -- Captain adding a member to their society (using security definer function)
        (is_society_captain(auth.uid(), society_id))
    );

-- UPDATE: Members can update their own profiles
CREATE POLICY "Members can update their own profiles"
    ON members
    FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- UPDATE: Captains can update members in their societies
CREATE POLICY "Captains can update members in their societies"
    ON members
    FOR UPDATE
    TO authenticated
    USING (is_society_captain(auth.uid(), society_id))
    WITH CHECK (is_society_captain(auth.uid(), society_id));

-- DELETE: Captains can remove members from their societies
CREATE POLICY "Captains can remove members from their societies"
    ON members
    FOR DELETE
    TO authenticated
    USING (is_society_captain(auth.uid(), society_id));

-- =============================================================================
-- NEW NON-RECURSIVE POLICIES FOR SOCIETIES
-- =============================================================================

-- INSERT: Anyone authenticated can create societies
CREATE POLICY "Anyone authenticated can create societies"
    ON societies
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- SELECT: View societies you are a member of (using security definer function)
CREATE POLICY "View societies you are a member of"
    ON societies
    FOR SELECT
    TO authenticated
    USING (id IN (SELECT get_user_society_ids(auth.uid())));

-- UPDATE: Only captains can update their society (using security definer function)
CREATE POLICY "Captains can update their society"
    ON societies
    FOR UPDATE
    TO authenticated
    USING (is_society_captain(auth.uid(), id))
    WITH CHECK (is_society_captain(auth.uid(), id));

-- DELETE: Only captains can delete their society (using security definer function)
CREATE POLICY "Captains can delete their society"
    ON societies
    FOR DELETE
    TO authenticated
    USING (is_society_captain(auth.uid(), id));

-- =============================================================================
-- GRANT PERMISSIONS
-- =============================================================================

-- Grant execute permissions on the security definer functions
GRANT EXECUTE ON FUNCTION get_user_society_ids(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION is_society_captain(UUID, UUID) TO authenticated;

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON FUNCTION get_user_society_ids(UUID) IS 'Returns society IDs for a user. Used by RLS policies to avoid infinite recursion.';
COMMENT ON FUNCTION is_society_captain(UUID, UUID) IS 'Checks if a user is a captain of a society. Used by RLS policies to avoid infinite recursion.';
