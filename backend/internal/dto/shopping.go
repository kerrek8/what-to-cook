package dto

import "time"

type ShoppingItemResponse struct {
	ID           string    `json:"id"`
	IngredientID *int32    `json:"ingredient_id,omitempty"`
	Name         string    `json:"name"`
	Category     string    `json:"category"`
	Amount       *float64  `json:"amount,omitempty"`
	Unit         *string   `json:"unit,omitempty"`
	IsBought     bool      `json:"is_bought"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type ShoppingListResponse struct {
	Items []ShoppingItemResponse `json:"items"`
	Total int                    `json:"total"`
}

type CreateShoppingItemRequest struct {
	IngredientID *int32   `json:"ingredient_id"`
	CustomName   *string  `json:"custom_name"`
	Amount       *float64 `json:"amount"`
	Unit         *string  `json:"unit"`
}

type UpdateShoppingItemRequest struct {
	IngredientID *int32   `json:"ingredient_id"`
	CustomName   *string  `json:"custom_name"`
	Amount       *float64 `json:"amount"`
	Unit         *string  `json:"unit"`
	IsBought     *bool    `json:"is_bought"`
}

type UpdateShoppingItemStatusRequest struct {
	IsBought bool `json:"is_bought"`
}

type AddFromRecipeResponse struct {
	RecipeID   int32                  `json:"recipe_id"`
	AddedCount int                    `json:"added_count"`
	Items      []ShoppingItemResponse `json:"items"`
}

type TransferToInventoryResponse struct {
	TransferredCount int `json:"transferred_count"`
}
