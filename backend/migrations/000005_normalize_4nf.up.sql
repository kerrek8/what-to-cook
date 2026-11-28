-- 000005_normalize_4nf.up.sql

ALTER TABLE users
    ADD COLUMN has_custom_pantry BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE user_excluded_ingredients (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, ingredient_id)
);

CREATE INDEX idx_user_excluded_ingredients_ingredient ON user_excluded_ingredients(ingredient_id);

CREATE TABLE user_pantry_ingredients (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, ingredient_id)
);

CREATE INDEX idx_user_pantry_ingredients_ingredient ON user_pantry_ingredients(ingredient_id);

CREATE TABLE recipe_steps (
    id SERIAL PRIMARY KEY,
    recipe_id INT NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
    step_number INT NOT NULL,
    instruction TEXT NOT NULL,
    CONSTRAINT uq_recipe_step_number UNIQUE (recipe_id, step_number)
);

CREATE INDEX idx_recipe_steps_recipe_id ON recipe_steps(recipe_id);

-- Migrate existing arrays and JSONB into normalized 4NF tables
INSERT INTO user_excluded_ingredients (user_id, ingredient_id)
SELECT u.id, eid
FROM users u,
LATERAL unnest(u.excluded_ingredient_ids) AS eid
JOIN ingredients i ON i.id = eid
ON CONFLICT DO NOTHING;

INSERT INTO user_pantry_ingredients (user_id, ingredient_id)
SELECT u.id, pid
FROM users u,
LATERAL unnest(u.pantry_ingredient_ids) AS pid
JOIN ingredients i ON i.id = pid
ON CONFLICT DO NOTHING;

UPDATE users
SET has_custom_pantry = TRUE
WHERE cardinality(pantry_ingredient_ids) > 0;

INSERT INTO recipe_steps (recipe_id, step_number, instruction)
SELECT r.id, elem.ord::int, elem.val
FROM recipes r,
LATERAL jsonb_array_elements_text(r.instructions) WITH ORDINALITY AS elem(val, ord);

ALTER TABLE users
    DROP COLUMN excluded_ingredient_ids,
    DROP COLUMN pantry_ingredient_ids;

ALTER TABLE recipes
    DROP COLUMN instructions;
