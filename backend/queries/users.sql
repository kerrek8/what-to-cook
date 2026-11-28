-- name: CreateUser :one
INSERT INTO users (email, password_hash, name)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetUserByEmail :one
SELECT * FROM users
WHERE email = $1 LIMIT 1;

-- name: GetUserByID :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: UpdateUserTokenVersion :exec
UPDATE users
SET token_version = token_version + 1, updated_at = NOW()
WHERE id = $1;

-- name: ListUserExcludedIngredientIDs :many
SELECT ingredient_id FROM user_excluded_ingredients
WHERE user_id = $1
ORDER BY ingredient_id ASC;

-- name: ClearUserExcludedIngredients :exec
DELETE FROM user_excluded_ingredients
WHERE user_id = $1;

-- name: AddUserExcludedIngredient :exec
INSERT INTO user_excluded_ingredients (user_id, ingredient_id)
VALUES ($1, $2)
ON CONFLICT DO NOTHING;

-- name: ListUserPantryIngredientIDs :many
SELECT ingredient_id FROM user_pantry_ingredients
WHERE user_id = $1
ORDER BY ingredient_id ASC;

-- name: SetUserCustomPantryFlag :exec
UPDATE users
SET has_custom_pantry = $2, updated_at = NOW()
WHERE id = $1;

-- name: ClearUserPantryIngredients :exec
DELETE FROM user_pantry_ingredients
WHERE user_id = $1;

-- name: AddUserPantryIngredient :exec
INSERT INTO user_pantry_ingredients (user_id, ingredient_id)
VALUES ($1, $2)
ON CONFLICT DO NOTHING;

-- name: UpdateUserAvatar :one
UPDATE users
SET avatar_url = $2, updated_at = NOW()
WHERE id = $1
RETURNING *;
