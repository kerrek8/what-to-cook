-- name: ListIngredients :many
SELECT * FROM ingredients
ORDER BY category, name;

-- name: SearchIngredients :many
SELECT * FROM ingredients
WHERE name ILIKE '%' || $1 || '%'
ORDER BY name
LIMIT 20;

-- name: GetIngredientByID :one
SELECT * FROM ingredients
WHERE id = $1 LIMIT 1;

-- name: CreateIngredient :one
INSERT INTO ingredients (name, name_en, category, default_unit, is_pantry_essential)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;
