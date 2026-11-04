-- name: ListIngredients :many
SELECT * FROM ingredients
ORDER BY category, name;

-- name: SearchIngredients :many
SELECT * FROM ingredients
WHERE 
    (sqlc.narg('query')::text IS NULL OR sqlc.narg('query')::text = '' OR name ILIKE '%' || sqlc.narg('query') || '%')
    AND (sqlc.narg('category')::text IS NULL OR sqlc.narg('category')::text = '' OR category = sqlc.narg('category'))
ORDER BY 
    CASE WHEN sqlc.narg('query')::text IS NOT NULL AND sqlc.narg('query')::text != '' AND name ILIKE sqlc.narg('query') || '%' THEN 0 ELSE 1 END,
    is_pantry_essential DESC,
    name ASC;

-- name: GetIngredientByID :one
SELECT * FROM ingredients
WHERE id = $1 LIMIT 1;

-- name: CreateIngredient :one
INSERT INTO ingredients (name, category, default_unit, is_pantry_essential)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetIngredientByNameCaseInsensitive :one
SELECT * FROM ingredients
WHERE LOWER(name) = LOWER($1)
LIMIT 1;
