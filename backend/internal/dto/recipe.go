package dto

import "time"

type RecipeIngredientResponse struct {
	IngredientID         int32    `json:"ingredient_id"`
	Name                 string   `json:"name"`
	NameEn               *string  `json:"name_en,omitempty"`
	Category             string   `json:"category"`
	Amount               *float64 `json:"amount,omitempty"`
	Unit                 *string  `json:"unit,omitempty"`
	DisplayText          *string  `json:"display_text,omitempty"`
	LocalizedName        *string  `json:"localized_name,omitempty"`
	LocalizedDisplayText *string  `json:"localized_display_text,omitempty"`
	Criticality          string   `json:"criticality"`
	IsPantryEssential    bool     `json:"is_pantry_essential"`
}

type RecipeResponse struct {
	ID                    int32                      `json:"id"`
	ExternalID            *string                    `json:"external_id,omitempty"`
	Title                 string                     `json:"title"`
	Description           *string                    `json:"description,omitempty"`
	Instructions          []string                   `json:"instructions"`
	LocalizedTitle        *string                    `json:"localized_title,omitempty"`
	LocalizedDescription  *string                    `json:"localized_description,omitempty"`
	LocalizedInstructions []string                   `json:"localized_instructions,omitempty"`
	CookingTimeMinutes    int32                      `json:"cooking_time_minutes"`
	Difficulty            string                     `json:"difficulty"`
	ImageURL              *string                    `json:"image_url,omitempty"`
	IsFavorite            bool                       `json:"is_favorite"`
	Ingredients           []RecipeIngredientResponse `json:"ingredients,omitempty"`
	CreatedAt             time.Time                  `json:"created_at"`
	UpdatedAt             time.Time                  `json:"updated_at"`
}

type RecipeListResponse struct {
	Items               []RecipeResponse `json:"items"`
	Total               int              `json:"total"`
	PendingTranslations int              `json:"pending_translations"`
}

type RecipeQuery struct {
	Query      string `form:"q"`
	Difficulty string `form:"difficulty"`
	MaxTime    int32  `form:"max_time"`
	Limit      int32  `form:"limit"`
	Offset     int32  `form:"offset"`
}

type RecipeMatchItem struct {
	Recipe             RecipeResponse             `json:"recipe"`
	MatchPercentage    int                        `json:"match_percentage"`
	TotalIngredients   int                        `json:"total_ingredients"`
	AvailableCount     int                        `json:"available_count"`
	UsedIngredients    []RecipeIngredientResponse `json:"used_ingredients"`
	MissingIngredients []RecipeIngredientResponse `json:"missing_ingredients"`
	CanCookNow         bool                       `json:"can_cook_now"`
}

type RecipeMatchResponse struct {
	Items []RecipeMatchItem `json:"items"`
	Total int               `json:"total"`
}

type RecipeSyncResponse struct {
	SyncedCount int `json:"synced_count"`
}
