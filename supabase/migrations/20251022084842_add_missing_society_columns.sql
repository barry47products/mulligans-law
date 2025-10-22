-- Add Missing Society Columns
-- This migration adds the columns that were missing from the previous migration:
-- - is_public (privacy setting)
-- - location (society location)
-- - rules (society rules)

-- =============================================================================
-- ADD MISSING COLUMNS TO SOCIETIES TABLE
-- =============================================================================

-- 1. Add is_public field (default: false for private societies)
ALTER TABLE societies
ADD COLUMN IF NOT EXISTS is_public BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN societies.is_public IS 'Whether society is publicly discoverable. false = private (invite-only), true = public (anyone can discover and request to join)';

-- 2. Add location field (optional)
ALTER TABLE societies
ADD COLUMN IF NOT EXISTS location TEXT;

COMMENT ON COLUMN societies.location IS 'Optional location/course name for the society';

-- 3. Add rules field (optional)
ALTER TABLE societies
ADD COLUMN IF NOT EXISTS rules TEXT;

COMMENT ON COLUMN societies.rules IS 'Optional society-specific rules and guidelines';

-- =============================================================================
-- CREATE INDEX FOR PUBLIC SOCIETIES SEARCH
-- =============================================================================

-- Add index for searching public societies
CREATE INDEX IF NOT EXISTS idx_societies_is_public
ON societies(is_public)
WHERE is_public = true AND deleted_at IS NULL;

COMMENT ON INDEX idx_societies_is_public IS 'Index for efficient public society discovery';
