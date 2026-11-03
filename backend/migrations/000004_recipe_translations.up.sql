ALTER TABLE recipes
    ADD COLUMN localized_title TEXT,
    ADD COLUMN localized_description TEXT,
    ADD COLUMN localized_instructions JSONB,
    ADD COLUMN translation_status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (translation_status IN ('pending', 'translating', 'translated')),
    ADD COLUMN translation_attempts INT NOT NULL DEFAULT 0,
    ADD COLUMN translation_retry_after TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE recipe_ingredients
    ADD COLUMN localized_display_text TEXT;

CREATE INDEX idx_recipes_translation_queue
    ON recipes (translation_retry_after, id)
    WHERE translation_status <> 'translated';

UPDATE recipes SET translation_status = 'pending', translation_retry_after = NOW();
