-- Initial Schema Migration
-- This migration creates the core tables for societies and members with RLS policies

-- Enable UUID extension for generating unique IDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable pgcrypto for additional security functions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- SOCIETIES TABLE
-- =============================================================================

CREATE TABLE societies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    logo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT societies_name_not_empty CHECK (char_length(trim(name)) > 0)
);

-- Create index for faster queries
CREATE INDEX idx_societies_created_at ON societies(created_at DESC);

-- Add updated_at trigger
CREATE TRIGGER societies_updated_at
    BEFORE UPDATE ON societies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (policies added after members table is created)
ALTER TABLE societies ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- MEMBERS TABLE
-- =============================================================================

CREATE TABLE members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    handicap INTEGER NOT NULL DEFAULT 24,
    role TEXT NOT NULL DEFAULT 'MEMBER',
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT members_name_not_empty CHECK (char_length(trim(name)) > 0),
    CONSTRAINT members_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT members_handicap_valid CHECK (handicap >= 0 AND handicap <= 54),
    CONSTRAINT members_role_valid CHECK (role IN ('CAPTAIN', 'MEMBER')),
    CONSTRAINT members_status_valid CHECK (status IN ('ACTIVE', 'INACTIVE', 'PENDING')),
    CONSTRAINT members_unique_user_society UNIQUE (society_id, user_id)
);

-- Create indexes for faster queries
CREATE INDEX idx_members_society_id ON members(society_id);
CREATE INDEX idx_members_user_id ON members(user_id);
CREATE INDEX idx_members_role ON members(role);
CREATE INDEX idx_members_status ON members(status);
CREATE INDEX idx_members_society_user ON members(society_id, user_id);

-- Add updated_at trigger
CREATE TRIGGER members_updated_at
    BEFORE UPDATE ON members
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (policies added below)
ALTER TABLE members ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- ROW LEVEL SECURITY POLICIES
-- =============================================================================
-- Note: Policies are defined here after both tables exist to avoid dependency issues

-- RLS Policies for societies
-- Anyone authenticated can create societies
CREATE POLICY "Anyone authenticated can create societies"
    ON societies
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Society members can view their societies
CREATE POLICY "View societies you are a member of"
    ON societies
    FOR SELECT
    TO authenticated
    USING (
        id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND status = 'ACTIVE'
        )
    );

-- Only captains can update their society
CREATE POLICY "Captains can update their society"
    ON societies
    FOR UPDATE
    TO authenticated
    USING (
        id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        )
    )
    WITH CHECK (
        id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        )
    );

-- Only captains can delete their society
CREATE POLICY "Captains can delete their society"
    ON societies
    FOR DELETE
    TO authenticated
    USING (
        id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        )
    );

-- RLS Policies for members
-- Members can view other members in their societies
CREATE POLICY "View members in your societies"
    ON members
    FOR SELECT
    TO authenticated
    USING (
        society_id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND status = 'ACTIVE'
        )
    );

-- Captains can add members to their societies
CREATE POLICY "Captains can add members to their societies"
    ON members
    FOR INSERT
    TO authenticated
    WITH CHECK (
        society_id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        )
    );

-- Members can update their own profile
CREATE POLICY "Members can update their own profile"
    ON members
    FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Captains can update any member in their societies
CREATE POLICY "Captains can update members in their societies"
    ON members
    FOR UPDATE
    TO authenticated
    USING (
        society_id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        )
    )
    WITH CHECK (
        society_id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        )
    );

-- Captains can remove members from their societies
CREATE POLICY "Captains can remove members from their societies"
    ON members
    FOR DELETE
    TO authenticated
    USING (
        society_id IN (
            SELECT society_id
            FROM members
            WHERE user_id = auth.uid()
            AND role = 'CAPTAIN'
            AND status = 'ACTIVE'
        )
    );

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON TABLE societies IS 'Golf societies - the top-level organization entity';
COMMENT ON TABLE members IS 'Society members - links users to societies with roles and handicaps';

COMMENT ON COLUMN societies.name IS 'Society name (e.g., "Mulligans Golf Society")';
COMMENT ON COLUMN societies.description IS 'Optional description of the society';
COMMENT ON COLUMN societies.logo_url IS 'URL to society logo image in Supabase Storage';

COMMENT ON COLUMN members.society_id IS 'References the society this member belongs to';
COMMENT ON COLUMN members.user_id IS 'References the authenticated user (auth.users)';
COMMENT ON COLUMN members.name IS 'Member display name';
COMMENT ON COLUMN members.email IS 'Member email address';
COMMENT ON COLUMN members.phone IS 'Optional phone number';
COMMENT ON COLUMN members.handicap IS 'Golf handicap (0-54)';
COMMENT ON COLUMN members.role IS 'Member role: CAPTAIN (admin) or MEMBER (regular)';
COMMENT ON COLUMN members.status IS 'Member status: ACTIVE, INACTIVE, or PENDING';
