package dto

import "time"

type InventoryItemResponse struct {
	ID                  string    `json:"id"`
	IngredientID        *int32    `json:"ingredient_id,omitempty"`
	Name                string    `json:"name"`
	Category            string    `json:"category"`
	Amount              *float64  `json:"amount,omitempty"`
	Unit                *string   `json:"unit,omitempty"`
	ApproximateQuantity *string   `json:"approximate_quantity,omitempty"`
	InStock             bool      `json:"in_stock"`
	ExpirationDate      *string   `json:"expiration_date,omitempty"`
	CreatedAt           time.Time `json:"created_at"`
	UpdatedAt           time.Time `json:"updated_at"`
}

type InventoryListResponse struct {
	Items []InventoryItemResponse `json:"items"`
	Total int                     `json:"total"`
}

type CreateInventoryItemRequest struct {
	IngredientID        *int32   `json:"ingredient_id"`
	CustomName          *string  `json:"custom_name"`
	Amount              *float64 `json:"amount"`
	Unit                *string  `json:"unit"`
	ApproximateQuantity *string  `json:"approximate_quantity" binding:"omitempty,oneof=few medium much"`
	InStock             *bool    `json:"in_stock"`
	ExpirationDate      *string  `json:"expiration_date"`
}

type UpdateInventoryItemRequest struct {
	IngredientID        *int32   `json:"ingredient_id"`
	CustomName          *string  `json:"custom_name"`
	Amount              *float64 `json:"amount"`
	Unit                *string  `json:"unit"`
	ApproximateQuantity *string  `json:"approximate_quantity" binding:"omitempty,oneof=few medium much"`
	InStock             *bool    `json:"in_stock"`
	ExpirationDate      *string  `json:"expiration_date"`
}
