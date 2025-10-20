-- Seed Data for Development and Testing
-- This file contains test data for societies and members
-- Run with: supabase db reset

-- =============================================================================
-- TEST USER IDS
-- =============================================================================
-- Note: In a real environment, these would be actual auth.users IDs
-- For local testing, we'll create placeholder user records
-- You may need to adjust these UUIDs based on your local auth setup

-- =============================================================================
-- SOCIETIES SEED DATA
-- =============================================================================

-- Clear existing data (for development reset)
TRUNCATE societies, members CASCADE;

-- Insert test societies
INSERT INTO societies (id, name, description, logo_url, created_at, updated_at) VALUES
(
    '11111111-1111-1111-1111-111111111111',
    'Mulligans Golf Society',
    'A friendly golf society for weekend warriors who believe every shot deserves a second chance',
    NULL,
    NOW() - INTERVAL '6 months',
    NOW() - INTERVAL '6 months'
),
(
    '22222222-2222-2222-2222-222222222222',
    'Sunday Morning Golfers',
    'Early risers who love the peace of a Sunday morning round',
    NULL,
    NOW() - INTERVAL '3 months',
    NOW() - INTERVAL '3 months'
),
(
    '33333333-3333-3333-3333-333333333333',
    'The 19th Hole Club',
    'Where the real game begins after 18 holes',
    NULL,
    NOW() - INTERVAL '1 month',
    NOW() - INTERVAL '1 month'
),
(
    '44444444-4444-4444-4444-444444444444',
    'Birdie Hunters',
    'Dedicated to chasing birdies and occasionally catching them',
    NULL,
    NOW() - INTERVAL '2 weeks',
    NOW() - INTERVAL '2 weeks'
),
(
    '55555555-5555-5555-5555-555555555555',
    'Hackers Anonymous',
    'No judgment zone for high handicappers',
    NULL,
    NOW() - INTERVAL '1 week',
    NOW() - INTERVAL '1 week'
);

-- =============================================================================
-- MEMBERS SEED DATA
-- =============================================================================

-- Note: For local development testing only - create fake auth users
-- These users won't actually exist in auth.users, but we'll drop the FK constraint temporarily

-- Temporarily drop the foreign key constraint for seeding
ALTER TABLE members DROP CONSTRAINT IF EXISTS members_user_id_fkey;

-- Members for Mulligans Golf Society (20 members - large society)
INSERT INTO members (id, society_id, user_id, name, email, phone, handicap, role, status, created_at, updated_at) VALUES
-- Captain
('a1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000001', 'John Smith', 'john.smith@example.com', '+44 7700 900001', 12, 'CAPTAIN', 'ACTIVE', NOW() - INTERVAL '6 months', NOW() - INTERVAL '6 months'),
-- Regular members
('a1111111-1111-1111-1111-111111111112', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000002', 'Sarah Johnson', 'sarah.johnson@example.com', '+44 7700 900002', 18, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '5 months', NOW() - INTERVAL '5 months'),
('a1111111-1111-1111-1111-111111111113', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000003', 'Michael Brown', 'michael.brown@example.com', '+44 7700 900003', 8, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '5 months', NOW() - INTERVAL '5 months'),
('a1111111-1111-1111-1111-111111111114', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000004', 'Emily Davis', 'emily.davis@example.com', NULL, 24, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '4 months', NOW() - INTERVAL '4 months'),
('a1111111-1111-1111-1111-111111111115', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000005', 'David Wilson', 'david.wilson@example.com', '+44 7700 900005', 15, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '4 months', NOW() - INTERVAL '4 months'),
('a1111111-1111-1111-1111-111111111116', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000006', 'Lisa Anderson', 'lisa.anderson@example.com', '+44 7700 900006', 20, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '3 months', NOW() - INTERVAL '3 months'),
('a1111111-1111-1111-1111-111111111117', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000007', 'James Taylor', 'james.taylor@example.com', NULL, 10, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '3 months', NOW() - INTERVAL '3 months'),
('a1111111-1111-1111-1111-111111111118', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000008', 'Emma Thomas', 'emma.thomas@example.com', '+44 7700 900008', 28, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 months', NOW() - INTERVAL '2 months'),
('a1111111-1111-1111-1111-111111111119', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000009', 'Robert Martinez', 'robert.martinez@example.com', '+44 7700 900009', 14, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 months', NOW() - INTERVAL '2 months'),
('a1111111-1111-1111-1111-11111111111a', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-00000000000a', 'Sophie Garcia', 'sophie.garcia@example.com', NULL, 22, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 months', NOW() - INTERVAL '2 months'),
('a1111111-1111-1111-1111-11111111111b', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-00000000000b', 'William Lee', 'william.lee@example.com', '+44 7700 900011', 16, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 month', NOW() - INTERVAL '1 month'),
('a1111111-1111-1111-1111-11111111111c', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-00000000000c', 'Olivia White', 'olivia.white@example.com', '+44 7700 900012', 19, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 month', NOW() - INTERVAL '1 month'),
('a1111111-1111-1111-1111-11111111111d', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-00000000000d', 'Daniel Harris', 'daniel.harris@example.com', NULL, 11, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 month', NOW() - INTERVAL '1 month'),
('a1111111-1111-1111-1111-11111111111e', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-00000000000e', 'Ava Clark', 'ava.clark@example.com', '+44 7700 900014', 26, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '3 weeks', NOW() - INTERVAL '3 weeks'),
('a1111111-1111-1111-1111-11111111111f', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-00000000000f', 'Matthew Lewis', 'matthew.lewis@example.com', '+44 7700 900015', 13, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '3 weeks', NOW() - INTERVAL '3 weeks'),
('a1111111-1111-1111-1111-111111111120', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000010', 'Isabella Walker', 'isabella.walker@example.com', NULL, 21, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '2 weeks'),
('a1111111-1111-1111-1111-111111111121', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000011', 'Christopher Hall', 'christopher.hall@example.com', '+44 7700 900017', 9, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '2 weeks'),
('a1111111-1111-1111-1111-111111111122', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000012', 'Mia Allen', 'mia.allen@example.com', '+44 7700 900018', 17, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 week', NOW() - INTERVAL '1 week'),
('a1111111-1111-1111-1111-111111111123', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000013', 'Andrew Young', 'andrew.young@example.com', NULL, 25, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 week', NOW() - INTERVAL '1 week'),
('a1111111-1111-1111-1111-111111111124', '11111111-1111-1111-1111-111111111111', 'f0000000-0000-0000-0000-000000000014', 'Charlotte King', 'charlotte.king@example.com', '+44 7700 900020', 23, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days');

-- Members for Sunday Morning Golfers (8 members - medium society)
INSERT INTO members (id, society_id, user_id, name, email, phone, handicap, role, status, created_at, updated_at) VALUES
-- Captain
('b2222222-2222-2222-2222-222222222221', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-000000000015', 'Richard Wright', 'richard.wright@example.com', '+44 7700 900021', 10, 'CAPTAIN', 'ACTIVE', NOW() - INTERVAL '3 months', NOW() - INTERVAL '3 months'),
-- Regular members
('b2222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-000000000016', 'Grace Hill', 'grace.hill@example.com', '+44 7700 900022', 16, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 months', NOW() - INTERVAL '2 months'),
('b2222222-2222-2222-2222-222222222223', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-000000000017', 'Thomas Scott', 'thomas.scott@example.com', NULL, 12, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 months', NOW() - INTERVAL '2 months'),
('b2222222-2222-2222-2222-222222222224', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-000000000018', 'Ella Green', 'ella.green@example.com', '+44 7700 900024', 20, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 month', NOW() - INTERVAL '1 month'),
('b2222222-2222-2222-2222-222222222225', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-000000000019', 'Joshua Adams', 'joshua.adams@example.com', '+44 7700 900025', 14, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 month', NOW() - INTERVAL '1 month'),
('b2222222-2222-2222-2222-222222222226', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-00000000001a', 'Chloe Baker', 'chloe.baker@example.com', NULL, 18, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '3 weeks', NOW() - INTERVAL '3 weeks'),
('b2222222-2222-2222-2222-222222222227', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-00000000001b', 'Ryan Nelson', 'ryan.nelson@example.com', '+44 7700 900027', 11, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '2 weeks'),
('b2222222-2222-2222-2222-222222222228', '22222222-2222-2222-2222-222222222222', 'f0000000-0000-0000-0000-00000000001c', 'Lily Carter', 'lily.carter@example.com', '+44 7700 900028', 22, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '1 week', NOW() - INTERVAL '1 week');

-- Members for The 19th Hole Club (3 members - small society)
INSERT INTO members (id, society_id, user_id, name, email, phone, handicap, role, status, created_at, updated_at) VALUES
-- Captain
('c3333333-3333-3333-3333-333333333331', '33333333-3333-3333-3333-333333333333', 'f0000000-0000-0000-0000-00000000001d', 'Nathan Mitchell', 'nathan.mitchell@example.com', '+44 7700 900029', 15, 'CAPTAIN', 'ACTIVE', NOW() - INTERVAL '1 month', NOW() - INTERVAL '1 month'),
-- Regular members
('c3333333-3333-3333-3333-333333333332', '33333333-3333-3333-3333-333333333333', 'f0000000-0000-0000-0000-00000000001e', 'Zoe Perez', 'zoe.perez@example.com', NULL, 19, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '3 weeks', NOW() - INTERVAL '3 weeks'),
('c3333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', 'f0000000-0000-0000-0000-00000000001f', 'Ethan Roberts', 'ethan.roberts@example.com', '+44 7700 900031', 13, 'MEMBER', 'ACTIVE', NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '2 weeks');

-- Members for Birdie Hunters (1 member - single member society)
INSERT INTO members (id, society_id, user_id, name, email, phone, handicap, role, status, created_at, updated_at) VALUES
('d4444444-4444-4444-4444-444444444441', '44444444-4444-4444-4444-444444444444', 'f0000000-0000-0000-0000-000000000020', 'Victoria Turner', 'victoria.turner@example.com', '+44 7700 900032', 8, 'CAPTAIN', 'ACTIVE', NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '2 weeks');

-- Members for Hackers Anonymous (just captain - testing edge case)
INSERT INTO members (id, society_id, user_id, name, email, phone, handicap, role, status, created_at, updated_at) VALUES
('e5555555-5555-5555-5555-555555555551', '55555555-5555-5555-5555-555555555555', 'f0000000-0000-0000-0000-000000000021', 'Benjamin Phillips', 'benjamin.phillips@example.com', NULL, 28, 'CAPTAIN', 'ACTIVE', NOW() - INTERVAL '1 week', NOW() - INTERVAL '1 week');

-- Re-add the foreign key constraint after seeding
-- NOTE: In a real app, you'd need actual auth.users records
-- For local development/testing, we leave the constraint off
-- ALTER TABLE members ADD CONSTRAINT members_user_id_fkey
--   FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================
-- Uncomment to verify seed data after running

-- SELECT s.name, COUNT(m.id) as member_count
-- FROM societies s
-- LEFT JOIN members m ON s.id = m.society_id
-- GROUP BY s.id, s.name
-- ORDER BY member_count DESC;
