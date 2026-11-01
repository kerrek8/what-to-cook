-- name: UpsertPushSubscription :one
INSERT INTO push_subscriptions (
    user_id,
    endpoint,
    p256dh,
    auth
) VALUES (
    $1, $2, $3, $4
)
ON CONFLICT (endpoint) DO UPDATE
SET 
    user_id = EXCLUDED.user_id,
    p256dh = EXCLUDED.p256dh,
    auth = EXCLUDED.auth,
    created_at = NOW()
RETURNING *;

-- name: ListPushSubscriptionsByUserID :many
SELECT id, user_id, endpoint, p256dh, auth, created_at
FROM push_subscriptions
WHERE user_id = $1;

-- name: DeletePushSubscriptionByEndpoint :exec
DELETE FROM push_subscriptions
WHERE endpoint = $1;

-- name: DeletePushSubscriptionByID :exec
DELETE FROM push_subscriptions
WHERE id = $1 AND user_id = $2;

-- name: ListExpiringInventoryItems :many
SELECT 
    i.id,
    i.user_id,
    i.ingredient_id,
    i.custom_name,
    i.amount,
    i.unit,
    i.expiration_date,
    ing.name AS ingredient_name
FROM inventory_items i
LEFT JOIN ingredients ing ON ing.id = i.ingredient_id
WHERE i.in_stock = TRUE
  AND i.expiration_date IS NOT NULL
  AND i.expiration_date <= sqlc.arg('max_expiration_date')
  AND i.expiration_date >= sqlc.arg('min_expiration_date')
ORDER BY i.user_id, i.expiration_date ASC;
