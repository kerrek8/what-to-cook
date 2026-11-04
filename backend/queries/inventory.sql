-- name: ListInventoryItemsByUserID :many
SELECT 
    i.id,
    i.user_id,
    i.ingredient_id,
    i.custom_name,
    i.amount,
    i.unit,
    i.approximate_quantity,
    i.in_stock,
    i.expiration_date,
    i.created_at,
    i.updated_at,
    ing.name AS ingredient_name,
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit
FROM inventory_items i
LEFT JOIN ingredients ing ON ing.id = i.ingredient_id
WHERE i.user_id = $1
ORDER BY 
    i.expiration_date ASC NULLS LAST,
    i.created_at DESC;

-- name: GetInventoryItemByIDAndUserID :one
SELECT 
    i.id,
    i.user_id,
    i.ingredient_id,
    i.custom_name,
    i.amount,
    i.unit,
    i.approximate_quantity,
    i.in_stock,
    i.expiration_date,
    i.created_at,
    i.updated_at,
    ing.name AS ingredient_name,
    ing.category AS ingredient_category,
    ing.default_unit AS ingredient_default_unit
FROM inventory_items i
LEFT JOIN ingredients ing ON ing.id = i.ingredient_id
WHERE i.id = $1 AND i.user_id = $2
LIMIT 1;

-- name: CreateInventoryItem :one
INSERT INTO inventory_items (
    user_id,
    ingredient_id,
    custom_name,
    amount,
    unit,
    approximate_quantity,
    in_stock,
    expiration_date
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
)
RETURNING *;

-- name: UpdateInventoryItem :one
UPDATE inventory_items
SET 
    ingredient_id = COALESCE(sqlc.narg('ingredient_id'), ingredient_id),
    custom_name = COALESCE(sqlc.narg('custom_name'), custom_name),
    amount = sqlc.narg('amount'),
    unit = sqlc.narg('unit'),
    approximate_quantity = sqlc.narg('approximate_quantity'),
    in_stock = COALESCE(sqlc.narg('in_stock'), in_stock),
    expiration_date = sqlc.narg('expiration_date'),
    updated_at = NOW()
WHERE id = sqlc.arg('id') AND user_id = sqlc.arg('user_id')
RETURNING *;

-- name: DeleteInventoryItem :exec
DELETE FROM inventory_items
WHERE id = $1 AND user_id = $2;
