-- name: ListRecipes :many
SELECT 
    r.*
FROM recipes r
WHERE 
    (
        sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = ''
        OR r.search_vector @@ plainto_tsquery('russian', sqlc.narg('query'))
        OR r.title ILIKE '%' || sqlc.narg('query') || '%'
        OR EXISTS (
            SELECT 1 FROM recipe_ingredients ri
            JOIN ingredients ing ON ing.id = ri.ingredient_id
            WHERE ri.recipe_id = r.id
              AND ing.name ILIKE '%' || sqlc.narg('query') || '%'
        )
    )
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR r.difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR r.cooking_time_minutes <= sqlc.narg('max_time'))
ORDER BY r.title ASC
LIMIT sqlc.arg('limit_val') OFFSET sqlc.arg('offset_val');

-- name: CountRecipes :one
SELECT COUNT(*) FROM recipes r
WHERE 
    (
        sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = ''
        OR r.search_vector @@ plainto_tsquery('russian', sqlc.narg('query'))
        OR r.title ILIKE '%' || sqlc.narg('query') || '%'
        OR EXISTS (
            SELECT 1 FROM recipe_ingredients ri
            JOIN ingredients ing ON ing.id = ri.ingredient_id
            WHERE ri.recipe_id = r.id
              AND ing.name ILIKE '%' || sqlc.narg('query') || '%'
        )
    )
    AND (sqlc.narg('difficulty')::text IS NULL OR sqlc.narg('difficulty')::text = '' OR r.difficulty = sqlc.narg('difficulty'))
    AND (sqlc.narg('max_time')::int IS NULL OR sqlc.narg('max_time')::int = 0 OR r.cooking_time_minutes <= sqlc.narg('max_time'));

-- name: GetRecipeByID :one
SELECT 
    r.*
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
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit,
    ing.is_pantry_essential
FROM recipe_ingredients ri
JOIN ingredients ing ON ing.id = ri.ingredient_id
WHERE ri.recipe_id = $1
ORDER BY 
    CASE ri.criticality
        WHEN 'основной' THEN 1
        WHEN 'важный' THEN 2
        WHEN 'опциональный' THEN 3
        ELSE 4
    END,
    ing.name ASC;

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
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit,
    ing.is_pantry_essential
FROM recipe_ingredients ri
JOIN ingredients ing ON ing.id = ri.ingredient_id;

-- name: CountTotalRecipes :one
SELECT COUNT(*) FROM recipes;

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

-- name: ListFavoriteRecipes :many
SELECT r.*
FROM recipes r
JOIN recipe_favorites rf ON rf.recipe_id = r.id
WHERE rf.user_id = $1
ORDER BY rf.created_at DESC;

-- name: IsRecipeFavorite :one
SELECT EXISTS (
    SELECT 1 FROM recipe_favorites
    WHERE user_id = $1 AND recipe_id = $2
);


-- name: GetRecipeByTitle :one
SELECT * FROM recipes
WHERE LOWER(title) = LOWER($1)
LIMIT 1;

-- name: CreateRecipe :one
INSERT INTO recipes (
    title,
    description,
    cooking_time_minutes,
    difficulty,
    image_url
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetRecipeSteps :many
SELECT step_number, instruction
FROM recipe_steps
WHERE recipe_id = $1
ORDER BY step_number ASC;

-- name: GetAllRecipeSteps :many
SELECT recipe_id, step_number, instruction
FROM recipe_steps
ORDER BY recipe_id ASC, step_number ASC;

-- name: AddRecipeStep :exec
INSERT INTO recipe_steps (recipe_id, step_number, instruction)
VALUES ($1, $2, $3)
ON CONFLICT (recipe_id, step_number) DO UPDATE SET
    instruction = EXCLUDED.instruction;

-- name: DeleteRecipeSteps :exec
DELETE FROM recipe_steps
WHERE recipe_id = $1;

-- name: UpdateRecipeImage :exec
UPDATE recipes
SET image_url = $2, updated_at = NOW()
WHERE id = $1;
