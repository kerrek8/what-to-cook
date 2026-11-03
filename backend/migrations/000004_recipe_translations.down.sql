DROP INDEX IF EXISTS idx_recipes_translation_queue;

ALTER TABLE recipe_ingredients
    DROP COLUMN IF EXISTS localized_display_text;

ALTER TABLE recipes
    DROP COLUMN IF EXISTS translation_retry_after,
    DROP COLUMN IF EXISTS translation_attempts,
    DROP COLUMN IF EXISTS translation_status,
    DROP COLUMN IF EXISTS localized_instructions,
    DROP COLUMN IF EXISTS localized_description,
    DROP COLUMN IF EXISTS localized_title;
