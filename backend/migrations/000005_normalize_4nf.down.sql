-- 000005_normalize_4nf.down.sql

ALTER TABLE users
    ADD COLUMN excluded_ingredient_ids INT[] NOT NULL DEFAULT '{}',
    ADD COLUMN pantry_ingredient_ids INT[] NOT NULL DEFAULT '{}';

ALTER TABLE recipes
    ADD COLUMN instructions JSONB NOT NULL DEFAULT '[]'::jsonb;

UPDATE users u
SET excluded_ingredient_ids = COALESCE(
    (SELECT array_agg(uei.ingredient_id ORDER BY uei.ingredient_id)
     FROM user_excluded_ingredients uei
     WHERE uei.user_id = u.id),
    '{}'
);

UPDATE users u
SET pantry_ingredient_ids = COALESCE(
    (SELECT array_agg(upi.ingredient_id ORDER BY upi.ingredient_id)
     FROM user_pantry_ingredients upi
     WHERE upi.user_id = u.id),
    '{}'
);

UPDATE recipes r
SET instructions = COALESCE(
    (SELECT jsonb_agg(rs.instruction ORDER BY rs.step_number)
     FROM recipe_steps rs
     WHERE rs.recipe_id = r.id),
    '[]'::jsonb
);

DROP TABLE IF EXISTS recipe_steps;
DROP TABLE IF EXISTS user_pantry_ingredients;
DROP TABLE IF EXISTS user_excluded_ingredients;

ALTER TABLE users
    DROP COLUMN IF EXISTS has_custom_pantry;
