-- name: ListRecipes :many
SELECT 
    r.*
FROM recipes r
WHERE 
    r.translation_status = 'translated'
    AND (sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = '' OR r.title ILIKE '%' || sqlc.narg('query') || '%' OR r.localized_title ILIKE '%' || sqlc.narg('query') || '%')
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR r.difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR r.cooking_time_minutes <= sqlc.narg('max_time'))
ORDER BY r.title ASC
LIMIT sqlc.arg('limit_val') OFFSET sqlc.arg('offset_val');

-- name: CountRecipes :one
SELECT COUNT(*) FROM recipes
WHERE 
    translation_status = 'translated'
    AND (sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = '' OR title ILIKE '%' || sqlc.narg('query') || '%' OR localized_title ILIKE '%' || sqlc.narg('query') || '%')
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR cooking_time_minutes <= sqlc.narg('max_time'));

-- name: GetRecipeByID :one
SELECT 
    r.*
FROM recipes r
WHERE r.id = $1 AND r.translation_status = 'translated' LIMIT 1;

-- name: GetRecipeIngredients :many
SELECT 
    ri.id,
    ri.recipe_id,
    ri.ingredient_id,
    ri.amount,
    ri.unit,
    ri.display_text,
    ri.localized_display_text,
    ri.criticality,
    ing.name AS ingredient_name,
    ing.name_en AS ingredient_name_en,
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit,
    ing.is_pantry_essential
FROM recipe_ingredients ri
JOIN ingredients ing ON ing.id = ri.ingredient_id
WHERE ri.recipe_id = $1
ORDER BY ri.criticality ASC, ing.name ASC;

-- name: GetAllRecipeIngredientsWithDetails :many
SELECT 
    ri.id,
    ri.recipe_id,
    ri.ingredient_id,
    ri.amount,
    ri.unit,
    ri.display_text,
    ri.localized_display_text,
    ri.criticality,
    ing.name AS ingredient_name,
    ing.name_en AS ingredient_name_en,
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit,
    ing.is_pantry_essential
FROM recipe_ingredients ri
JOIN ingredients ing ON ing.id = ri.ingredient_id;

-- name: UpsertRecipe :one
INSERT INTO recipes (
    external_id,
    title,
    description,
    instructions,
    cooking_time_minutes,
    difficulty,
    image_url
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
)
ON CONFLICT (external_id) DO UPDATE SET
    localized_title = CASE WHEN recipes.title IS DISTINCT FROM EXCLUDED.title THEN NULL ELSE recipes.localized_title END,
    localized_description = CASE WHEN recipes.description IS DISTINCT FROM EXCLUDED.description THEN NULL ELSE recipes.localized_description END,
    localized_instructions = CASE WHEN recipes.instructions IS DISTINCT FROM EXCLUDED.instructions THEN NULL ELSE recipes.localized_instructions END,
    translation_status = CASE WHEN recipes.title IS DISTINCT FROM EXCLUDED.title OR recipes.description IS DISTINCT FROM EXCLUDED.description OR recipes.instructions IS DISTINCT FROM EXCLUDED.instructions THEN 'pending' ELSE recipes.translation_status END,
    translation_retry_after = CASE WHEN recipes.title IS DISTINCT FROM EXCLUDED.title OR recipes.description IS DISTINCT FROM EXCLUDED.description OR recipes.instructions IS DISTINCT FROM EXCLUDED.instructions THEN NOW() ELSE recipes.translation_retry_after END,
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    instructions = EXCLUDED.instructions,
    cooking_time_minutes = EXCLUDED.cooking_time_minutes,
    difficulty = EXCLUDED.difficulty,
    image_url = EXCLUDED.image_url,
    updated_at = NOW()
RETURNING *;

-- name: ClaimPendingRecipeTranslation :one
WITH candidate AS (
    SELECT id
    FROM recipes
    WHERE (translation_status = 'pending' AND translation_retry_after <= NOW())
       OR (translation_status = 'translating' AND updated_at < NOW() - INTERVAL '10 minutes')
    ORDER BY translation_retry_after, id
    FOR UPDATE SKIP LOCKED
    LIMIT 1
)
UPDATE recipes r
SET translation_status = 'translating', updated_at = NOW()
FROM candidate
WHERE r.id = candidate.id
RETURNING r.id, r.title, r.description, r.instructions;

-- name: GetRecipeTranslationIngredients :many
SELECT ri.ingredient_id, ing.name, ing.name_en, ri.display_text
FROM recipe_ingredients ri
JOIN ingredients ing ON ing.id = ri.ingredient_id
WHERE ri.recipe_id = $1
ORDER BY ri.id;

-- name: UpdateRecipeTranslation :exec
UPDATE recipes
SET localized_title = $2,
    localized_description = $3,
    localized_instructions = $4,
    translation_status = 'translated',
    translation_attempts = 0,
    translation_retry_after = NOW(),
    updated_at = NOW()
WHERE id = $1;

-- name: UpdateIngredientRussianName :exec
UPDATE ingredients
SET name = $2
WHERE id = $1;

-- name: UpdateRecipeIngredientTranslation :exec
UPDATE recipe_ingredients
SET localized_display_text = $3
WHERE recipe_id = $1 AND ingredient_id = $2;

-- name: RetryRecipeTranslation :exec
UPDATE recipes
SET translation_status = 'pending',
    translation_attempts = translation_attempts + 1,
    translation_retry_after = NOW() + LEAST(INTERVAL '6 hours', INTERVAL '1 minute' * POWER(2, LEAST(translation_attempts, 8))),
    updated_at = NOW()
WHERE id = $1;

-- name: CountPendingRecipeTranslations :one
SELECT COUNT(*) FROM recipes WHERE translation_status <> 'translated';

-- name: AddRecipeIngredient :one
INSERT INTO recipe_ingredients (
    recipe_id,
    ingredient_id,
    amount,
    unit,
    display_text,
    criticality
) VALUES (
    $1, $2, $3, $4, $5, $6
)
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    amount = EXCLUDED.amount,
    unit = EXCLUDED.unit,
    localized_display_text = CASE WHEN recipe_ingredients.display_text IS DISTINCT FROM EXCLUDED.display_text THEN NULL ELSE recipe_ingredients.localized_display_text END,
    display_text = EXCLUDED.display_text,
    criticality = EXCLUDED.criticality
RETURNING *;

-- name: DeleteRecipeIngredients :exec
DELETE FROM recipe_ingredients
WHERE recipe_id = $1;

-- name: AddRecipeFavorite :exec
INSERT INTO recipe_favorites (user_id, recipe_id)
VALUES ($1, $2)
ON CONFLICT DO NOTHING;

-- name: RemoveRecipeFavorite :exec
DELETE FROM recipe_favorites
WHERE user_id = $1 AND recipe_id = $2;

-- name: ListUserFavoriteRecipeIDs :many
SELECT recipe_id FROM recipe_favorites
WHERE user_id = $1;

-- name: IsRecipeFavorite :one
SELECT EXISTS (
    SELECT 1 FROM recipe_favorites
    WHERE user_id = $1 AND recipe_id = $2
);
