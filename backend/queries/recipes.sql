-- name: ListRecipes :many
SELECT 
    r.id,
    r.external_id,
    r.title,
    r.description,
    r.instructions,
    r.cooking_time_minutes,
    r.difficulty,
    r.image_url,
    r.created_at,
    r.updated_at
FROM recipes r
WHERE 
    (sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = '' OR r.title ILIKE '%' || sqlc.narg('query') || '%')
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR r.difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR r.cooking_time_minutes <= sqlc.narg('max_time'))
ORDER BY r.title ASC
LIMIT sqlc.arg('limit_val') OFFSET sqlc.arg('offset_val');

-- name: CountRecipes :one
SELECT COUNT(*) FROM recipes
WHERE 
    (sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = '' OR title ILIKE '%' || sqlc.narg('query') || '%')
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR cooking_time_minutes <= sqlc.narg('max_time'));

-- name: GetRecipeByID :one
SELECT 
    r.id,
    r.external_id,
    r.title,
    r.description,
    r.instructions,
    r.cooking_time_minutes,
    r.difficulty,
    r.image_url,
    r.created_at,
    r.updated_at
FROM recipes r
WHERE r.id = $1 LIMIT 1;

-- name: GetRecipeIngredients :many
SELECT 
    ri.id,
    ri.recipe_id,
    ri.ingredient_id,
    ri.amount,
    ri.unit,
    ri.display_text,
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
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    instructions = EXCLUDED.instructions,
    cooking_time_minutes = EXCLUDED.cooking_time_minutes,
    difficulty = EXCLUDED.difficulty,
    image_url = EXCLUDED.image_url,
    updated_at = NOW()
RETURNING *;

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
