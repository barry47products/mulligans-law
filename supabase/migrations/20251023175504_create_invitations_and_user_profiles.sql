-- ===========================================================================
-- CREATE SOCIETY INVITATIONS TABLE
-- ===========================================================================
-- This table stores invitations sent by society captains/owners to existing users

CREATE TABLE society_invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
    invited_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    invited_by_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    message TEXT,
    status TEXT NOT NULL DEFAULT 'PENDING',
    responded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT society_invitations_status_valid CHECK (status IN ('PENDING', 'ACCEPTED', 'DECLINED', 'CANCELLED', 'EXPIRED')),
    CONSTRAINT society_invitations_unique_pending UNIQUE (society_id, invited_user_id, status),
    CONSTRAINT society_invitations_no_self_invite CHECK (invited_user_id != invited_by_user_id)
);

-- Create indexes for faster queries
CREATE INDEX idx_society_invitations_society_id ON society_invitations(society_id);
CREATE INDEX idx_society_invitations_invited_user_id ON society_invitations(invited_user_id);
CREATE INDEX idx_society_invitations_invited_by_user_id ON society_invitations(invited_by_user_id);
CREATE INDEX idx_society_invitations_status ON society_invitations(status);
CREATE INDEX idx_society_invitations_society_status ON society_invitations(society_id, status);

-- Add updated_at trigger
CREATE TRIGGER society_invitations_updated_at
    BEFORE UPDATE ON society_invitations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE society_invitations ENABLE ROW LEVEL SECURITY;

-- ===========================================================================
-- CREATE USER PROFILES VIEW
-- ===========================================================================
-- This view provides a searchable list of user profiles for invitations

CREATE OR REPLACE VIEW user_profiles AS
SELECT
    u.id,
    u.email,
    COALESCE(u.raw_user_meta_data->>'name', split_part(u.email, '@', 1)) as name,
    u.raw_user_meta_data->>'avatar_url' as avatar_url,
    -- Get user's primary handicap from their primary member profile
    (
        SELECT m.handicap
        FROM members m
        WHERE m.user_id = u.id
        AND m.society_id IS NULL
        LIMIT 1
    ) as handicap
FROM auth.users u
WHERE u.deleted_at IS NULL;

-- Grant access to authenticated users
GRANT SELECT ON user_profiles TO authenticated;

-- ===========================================================================
-- ROW LEVEL SECURITY POLICIES FOR INVITATIONS
-- ===========================================================================

-- Users can view invitations they've been sent
CREATE POLICY "Users can view their own invitations"
ON society_invitations FOR SELECT
TO authenticated
USING (invited_user_id = auth.uid());

-- Society captains/owners can view invitations for their society
CREATE POLICY "Society leadership can view society invitations"
ON society_invitations FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = society_invitations.society_id
        AND m.user_id = auth.uid()
        AND m.role IN ('OWNER', 'CO_OWNER', 'CAPTAIN')
        AND m.status = 'ACTIVE'
    )
);

-- Society captains/owners can send invitations
CREATE POLICY "Society leadership can send invitations"
ON society_invitations FOR INSERT
TO authenticated
WITH CHECK (
    invited_by_user_id = auth.uid()
    AND EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = society_invitations.society_id
        AND m.user_id = auth.uid()
        AND m.role IN ('OWNER', 'CO_OWNER', 'CAPTAIN')
        AND m.status = 'ACTIVE'
    )
    -- Ensure user is not already a member
    AND NOT EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = society_invitations.society_id
        AND m.user_id = society_invitations.invited_user_id
        AND m.status IN ('ACTIVE', 'PENDING')
    )
);

-- Users can respond to their own invitations (update status)
CREATE POLICY "Users can respond to their invitations"
ON society_invitations FOR UPDATE
TO authenticated
USING (invited_user_id = auth.uid())
WITH CHECK (
    invited_user_id = auth.uid()
    AND status IN ('ACCEPTED', 'DECLINED')
);

-- Senders and society leadership can cancel invitations
CREATE POLICY "Senders and leadership can cancel invitations"
ON society_invitations FOR UPDATE
TO authenticated
USING (
    invited_by_user_id = auth.uid()
    OR EXISTS (
        SELECT 1 FROM members m
        WHERE m.society_id = society_invitations.society_id
        AND m.user_id = auth.uid()
        AND m.role IN ('OWNER', 'CO_OWNER', 'CAPTAIN')
        AND m.status = 'ACTIVE'
    )
)
WITH CHECK (status = 'CANCELLED');

-- ===========================================================================
-- FUNCTION TO ACCEPT INVITATION AND CREATE MEMBER
-- ===========================================================================

CREATE OR REPLACE FUNCTION accept_society_invitation(invitation_id UUID)
RETURNS members
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_invitation society_invitations;
    v_society societies;
    v_user_handicap INTEGER;
    v_new_member members;
BEGIN
    -- Get invitation
    SELECT * INTO v_invitation
    FROM society_invitations
    WHERE id = invitation_id
    AND status = 'PENDING'
    AND invited_user_id = auth.uid()
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invitation not found or already responded to';
    END IF;

    -- Get society
    SELECT * INTO v_society
    FROM societies
    WHERE id = v_invitation.society_id;

    -- Get user's handicap
    SELECT handicap INTO v_user_handicap
    FROM user_profiles
    WHERE id = v_invitation.invited_user_id;

    -- Check handicap limits if enabled
    IF v_society.enforce_handicap_limits THEN
        IF v_user_handicap IS NULL THEN
            RAISE EXCEPTION 'User has no handicap set';
        END IF;

        IF v_user_handicap < v_society.min_handicap OR v_user_handicap > v_society.max_handicap THEN
            RAISE EXCEPTION 'User handicap % is outside society limits (% - %)',
                v_user_handicap, v_society.min_handicap, v_society.max_handicap;
        END IF;
    END IF;

    -- Check if user is already a member
    IF EXISTS (
        SELECT 1 FROM members
        WHERE society_id = v_invitation.society_id
        AND user_id = v_invitation.invited_user_id
        AND status IN ('ACTIVE', 'PENDING')
    ) THEN
        RAISE EXCEPTION 'User is already a member of this society';
    END IF;

    -- Update invitation status
    UPDATE society_invitations
    SET status = 'ACCEPTED',
        responded_at = NOW(),
        updated_at = NOW()
    WHERE id = invitation_id;

    -- Get user info
    DECLARE
        v_user_email TEXT;
        v_user_name TEXT;
    BEGIN
        SELECT email, name INTO v_user_email, v_user_name
        FROM user_profiles
        WHERE id = v_invitation.invited_user_id;

        -- Create member record
        INSERT INTO members (
            society_id,
            user_id,
            name,
            email,
            handicap,
            role,
            status
        ) VALUES (
            v_invitation.society_id,
            v_invitation.invited_user_id,
            v_user_name,
            v_user_email,
            COALESCE(v_user_handicap, 24),
            'MEMBER',
            'ACTIVE'
        )
        RETURNING * INTO v_new_member;
    END;

    RETURN v_new_member;
END;
$$;
