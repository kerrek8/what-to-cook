package dto

type UserResponse struct {
	ID                    string  `json:"id"`
	Email                 string  `json:"email"`
	Name                  string  `json:"name"`
	AvatarURL             *string `json:"avatar_url"`
	ExcludedIngredientIDs []int32 `json:"excluded_ingredient_ids"`
	PantryIngredientIDs   []int32 `json:"pantry_ingredient_ids"`
	CreatedAt             string  `json:"created_at"`
}

type UploadAvatarResponse struct {
	AvatarURL string `json:"avatar_url"`
}

type UpdateAllergensRequest struct {
	ExcludedIngredientIDs []int32 `json:"excluded_ingredient_ids" binding:"required,max=1"`
}

type UpdatePantryRequest struct {
	PantryIngredientIDs []int32 `json:"pantry_ingredient_ids"`
}
