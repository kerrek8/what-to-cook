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

-- name: UpdateUserExcludedIngredients :exec
UPDATE users
SET excluded_ingredient_ids = $2, updated_at = NOW()
WHERE id = $1;

-- name: UpdateUserPantryIngredients :exec
UPDATE users
SET pantry_ingredient_ids = $2, updated_at = NOW()
WHERE id = $1;

-- name: UpdateUserAvatar :one
UPDATE users
SET avatar_url = $2, updated_at = NOW()
WHERE id = $1
RETURNING *;
