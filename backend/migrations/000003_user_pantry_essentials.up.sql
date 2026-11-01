-- Add custom pantry ingredient IDs to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS pantry_ingredient_ids integer[] DEFAULT NULL;
