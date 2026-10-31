-- name: ListShoppingItemsByUserID :many
SELECT 
    s.id,
    s.user_id,
    s.ingredient_id,
    s.custom_name,
    s.amount,
    s.unit,
    s.is_bought,
    s.created_at,
    s.updated_at,
    ing.name AS ingredient_name,
    ing.name_en AS ingredient_name_en,
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit
FROM shopping_list_items s
LEFT JOIN ingredients ing ON ing.id = s.ingredient_id
WHERE s.user_id = $1
ORDER BY 
    s.is_bought ASC,
    s.created_at DESC;

-- name: GetShoppingItemByIDAndUserID :one
SELECT 
    s.id,
    s.user_id,
    s.ingredient_id,
    s.custom_name,
    s.amount,
    s.unit,
    s.is_bought,
    s.created_at,
    s.updated_at,
    ing.name AS ingredient_name,
    ing.name_en AS ingredient_name_en,
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit
FROM shopping_list_items s
LEFT JOIN ingredients ing ON ing.id = s.ingredient_id
WHERE s.id = $1 AND s.user_id = $2
LIMIT 1;

-- name: CreateShoppingItem :one
INSERT INTO shopping_list_items (
    user_id,
    ingredient_id,
    custom_name,
    amount,
    unit,
    is_bought
) VALUES (
    $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: UpdateShoppingItem :one
UPDATE shopping_list_items
SET 
    ingredient_id = COALESCE(sqlc.narg('ingredient_id'), ingredient_id),
    custom_name = COALESCE(sqlc.narg('custom_name'), custom_name),
    amount = sqlc.narg('amount'),
    unit = sqlc.narg('unit'),
    is_bought = COALESCE(sqlc.narg('is_bought'), is_bought),
    updated_at = NOW()
WHERE id = sqlc.arg('id') AND user_id = sqlc.arg('user_id')
RETURNING *;

-- name: SetShoppingItemBoughtStatus :one
UPDATE shopping_list_items
SET 
    is_bought = $3,
    updated_at = NOW()
WHERE id = $1 AND user_id = $2
RETURNING *;

-- name: DeleteShoppingItem :exec
DELETE FROM shopping_list_items
WHERE id = $1 AND user_id = $2;

-- name: TransferBoughtItemsToInventory :many
INSERT INTO inventory_items (
    user_id,
    ingredient_id,
    custom_name,
    amount,
    unit,
    in_stock
)
SELECT 
    s.user_id,
    s.ingredient_id,
    s.custom_name,
    s.amount,
    s.unit,
    TRUE
FROM shopping_list_items s
WHERE s.user_id = $1 AND s.is_bought = TRUE
RETURNING *;

-- name: DeleteBoughtShoppingItemsByUserID :exec
DELETE FROM shopping_list_items
WHERE user_id = $1 AND is_bought = TRUE;

-- name: GetShoppingItemByIngredientAndUserID :one
SELECT s.id, s.user_id, s.ingredient_id, s.custom_name, s.amount, s.unit, s.is_bought, s.created_at, s.updated_at
FROM shopping_list_items s
WHERE s.user_id = $1 AND s.ingredient_id = $2 AND s.is_bought = FALSE
LIMIT 1;
