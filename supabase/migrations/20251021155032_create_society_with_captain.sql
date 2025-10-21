-- Create Society with Captain Function
-- This migration creates a function to atomically create a society and add the creator as captain
-- This solves the RLS policy issue where newly created societies can't be viewed by their creator

-- =============================================================================
-- FUNCTION TO CREATE SOCIETY WITH CAPTAIN
-- =============================================================================

CREATE OR REPLACE FUNCTION create_society_with_captain(
    p_name TEXT,
    p_description TEXT DEFAULT NULL,
    p_logo_url TEXT DEFAULT NULL,
    p_user_id UUID DEFAULT auth.uid(),
    p_user_name TEXT DEFAULT NULL,
    p_user_email TEXT DEFAULT NULL
)
RETURNS TABLE(
    society_id UUID,
    society_name TEXT,
    society_description TEXT,
    society_logo_url TEXT,
    society_created_at TIMESTAMPTZ,
    society_updated_at TIMESTAMPTZ
)
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    v_society_id UUID;
    v_user_name TEXT;
    v_user_email TEXT;
BEGIN
    -- Validate user is authenticated
    IF p_user_id IS NULL THEN
        RAISE EXCEPTION 'User must be authenticated to create a society';
    END IF;

    -- Get user info from primary member profile if not provided
    IF p_user_name IS NULL OR p_user_email IS NULL THEN
        SELECT m.name, m.email INTO v_user_name, v_user_email
        FROM members m
        WHERE m.user_id = p_user_id
        AND m.society_id IS NULL
        LIMIT 1;

        -- If no primary member profile exists, try to get info from auth.users
        IF v_user_name IS NULL OR v_user_email IS NULL THEN
            SELECT
                COALESCE(raw_user_meta_data->>'name', split_part(email, '@', 1)),
                email
            INTO v_user_name, v_user_email
            FROM auth.users
            WHERE id = p_user_id;
        END IF;

        -- Use provided values or fallback to profile/auth values or defaults
        v_user_name := COALESCE(p_user_name, v_user_name, 'Unknown');
        v_user_email := COALESCE(p_user_email, v_user_email, 'unknown@example.com');
    ELSE
        v_user_name := p_user_name;
        v_user_email := p_user_email;
    END IF;

    -- Create the society
    INSERT INTO societies (name, description, logo_url)
    VALUES (p_name, p_description, p_logo_url)
    RETURNING id INTO v_society_id;

    -- Add creator as captain member
    INSERT INTO members (society_id, user_id, name, email, role, status)
    VALUES (v_society_id, p_user_id, v_user_name, v_user_email, 'CAPTAIN', 'ACTIVE');

    -- Return the created society
    RETURN QUERY
    SELECT 
        s.id,
        s.name,
        s.description,
        s.logo_url,
        s.created_at,
        s.updated_at
    FROM societies s
    WHERE s.id = v_society_id;
END;
$$;

-- =============================================================================
-- GRANT PERMISSIONS
-- =============================================================================

GRANT EXECUTE ON FUNCTION create_society_with_captain(TEXT, TEXT, TEXT, UUID, TEXT, TEXT) TO authenticated;

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON FUNCTION create_society_with_captain(TEXT, TEXT, TEXT, UUID, TEXT, TEXT) IS 
'Creates a society and automatically adds the creator as a captain member. This ensures the creator can view and manage the society immediately after creation.';
