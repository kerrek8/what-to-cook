-- Remove custom pantry ingredient IDs from users table
ALTER TABLE users DROP COLUMN IF EXISTS pantry_ingredient_ids;
