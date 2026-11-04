-- name: ListRecipes :many
SELECT 
    r.*
FROM recipes r
WHERE 
    r.translation_status = 'translated'
    AND (
        sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = ''
        OR r.localized_title ILIKE '%' || sqlc.narg('query') || '%'
        OR r.title ILIKE '%' || sqlc.narg('query') || '%'
        OR EXISTS (
            SELECT 1 FROM recipe_ingredients ri
            JOIN ingredients ing ON ing.id = ri.ingredient_id
            WHERE ri.recipe_id = r.id
              AND (ing.name ILIKE '%' || sqlc.narg('query') || '%' OR (ing.name_en IS NOT NULL AND ing.name_en ILIKE '%' || sqlc.narg('query') || '%'))
        )
    )
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR r.difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR r.cooking_time_minutes <= sqlc.narg('max_time'))
ORDER BY r.title ASC
LIMIT sqlc.arg('limit_val') OFFSET sqlc.arg('offset_val');

-- name: CountRecipes :one
SELECT COUNT(*) FROM recipes r
WHERE 
    r.translation_status = 'translated'
    AND (
        sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = ''
        OR r.localized_title ILIKE '%' || sqlc.narg('query') || '%'
        OR r.title ILIKE '%' || sqlc.narg('query') || '%'
        OR EXISTS (
            SELECT 1 FROM recipe_ingredients ri
            JOIN ingredients ing ON ing.id = ri.ingredient_id
            WHERE ri.recipe_id = r.id
              AND (ing.name ILIKE '%' || sqlc.narg('query') || '%' OR (ing.name_en IS NOT NULL AND ing.name_en ILIKE '%' || sqlc.narg('query') || '%'))
        )
    )
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR r.difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR r.cooking_time_minutes <= sqlc.narg('max_time'));

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

-- name: GetTranslatedRecipeIngredientsWithDetails :many
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
JOIN recipes r ON r.id = ri.recipe_id
WHERE r.translation_status = 'translated';

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
    localized_title = CASE 
        WHEN recipes.translation_status = 'translated' AND recipes.localized_title IS NOT NULL THEN recipes.localized_title
        WHEN recipes.title IS DISTINCT FROM EXCLUDED.title THEN NULL 
        ELSE recipes.localized_title 
    END,
    localized_description = CASE 
        WHEN recipes.translation_status = 'translated' AND recipes.localized_description IS NOT NULL THEN recipes.localized_description
        WHEN recipes.title IS DISTINCT FROM EXCLUDED.title THEN NULL 
        ELSE recipes.localized_description 
    END,
    localized_instructions = CASE 
        WHEN recipes.translation_status = 'translated' AND recipes.localized_instructions IS NOT NULL THEN recipes.localized_instructions
        WHEN recipes.title IS DISTINCT FROM EXCLUDED.title THEN NULL 
        ELSE recipes.localized_instructions 
    END,
    translation_status = CASE 
        WHEN recipes.translation_status = 'translated' THEN 'translated'
        WHEN recipes.title IS DISTINCT FROM EXCLUDED.title THEN 'pending' 
        ELSE recipes.translation_status 
    END,
    translation_retry_after = CASE 
        WHEN recipes.translation_status = 'translated' THEN recipes.translation_retry_after
        WHEN recipes.title IS DISTINCT FROM EXCLUDED.title THEN NOW() 
        ELSE recipes.translation_retry_after 
    END,
    title = EXCLUDED.title,
    description = COALESCE(recipes.description, EXCLUDED.description),
    instructions = EXCLUDED.instructions,
    cooking_time_minutes = CASE WHEN recipes.cooking_time_minutes > 0 THEN recipes.cooking_time_minutes ELSE EXCLUDED.cooking_time_minutes END,
    difficulty = CASE WHEN recipes.difficulty <> '' THEN recipes.difficulty ELSE EXCLUDED.difficulty END,
    image_url = COALESCE(EXCLUDED.image_url, recipes.image_url),
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

-- name: UpdateRecipeTranslationWithDetails :exec
UPDATE recipes
SET localized_title = $2,
    localized_description = $3,
    localized_instructions = $4,
    cooking_time_minutes = CASE WHEN @cooking_time_minutes::int > 0 THEN @cooking_time_minutes::int ELSE cooking_time_minutes END,
    difficulty = CASE WHEN @difficulty::text <> '' THEN @difficulty::text ELSE difficulty END,
    translation_status = 'translated',
    translation_attempts = 0,
    translation_retry_after = NOW(),
    updated_at = NOW()
WHERE id = $1;

-- name: UpdateIngredientRussianName :exec
UPDATE ingredients
SET name = $2
WHERE ingredients.id = $1
  AND NOT EXISTS (
      SELECT 1 FROM ingredients other WHERE LOWER(other.name) = LOWER($2) AND other.id <> ingredients.id
  );

-- name: ReassignRecipeIngredient :exec
INSERT INTO recipe_ingredients (
    recipe_id, ingredient_id, display_text, localized_display_text, criticality
)
VALUES (
    @recipe_id,
    @target_ingredient_id,
    @display_text,
    @localized_display_text,
    COALESCE(NULLIF(@criticality::text, ''), 'desirable')
)
ON CONFLICT (recipe_id, ingredient_id) DO UPDATE SET
    localized_display_text = COALESCE(NULLIF(EXCLUDED.localized_display_text, ''), recipe_ingredients.localized_display_text);

-- name: DeleteRecipeIngredientLink :exec
DELETE FROM recipe_ingredients
WHERE recipe_id = $1 AND ingredient_id = $2;

-- name: DeleteUnusedIngredient :exec
DELETE FROM ingredients
WHERE ingredients.id = $1
  AND NOT EXISTS (SELECT 1 FROM recipe_ingredients ri WHERE ri.ingredient_id = ingredients.id)
  AND NOT EXISTS (SELECT 1 FROM inventory_items ii WHERE ii.ingredient_id = ingredients.id)
  AND NOT EXISTS (SELECT 1 FROM shopping_list_items sli WHERE sli.ingredient_id = ingredients.id);

-- name: CountTotalRecipes :one
SELECT COUNT(*) FROM recipes;

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

-- name: ResetStaleTranslationRetries :exec
UPDATE recipes
SET translation_retry_after = NOW()
WHERE translation_status = 'pending' AND translation_retry_after > NOW();

-- name: ResetStalledTranslatingRecipes :exec
UPDATE recipes
SET translation_status = 'pending',
    translation_retry_after = NOW()
WHERE translation_status = 'translating' AND updated_at < NOW() - INTERVAL '5 minutes';

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
    localized_display_text = CASE 
        WHEN recipe_ingredients.localized_display_text IS NOT NULL THEN recipe_ingredients.localized_display_text
        WHEN recipe_ingredients.display_text IS DISTINCT FROM EXCLUDED.display_text THEN NULL 
        ELSE recipe_ingredients.localized_display_text 
    END,
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

-- name: ListFavoriteRecipes :many
SELECT r.*
FROM recipes r
JOIN recipe_favorites rf ON rf.recipe_id = r.id
WHERE rf.user_id = $1 AND r.translation_status = 'translated'
ORDER BY rf.created_at DESC;

-- name: IsRecipeFavorite :one
SELECT EXISTS (
    SELECT 1 FROM recipe_favorites
    WHERE user_id = $1 AND recipe_id = $2
);
