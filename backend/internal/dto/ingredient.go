package dto

type IngredientResponse struct {
	ID                int32   `json:"id"`
	Name              string  `json:"name"`
	NameEn            *string `json:"name_en,omitempty"`
	Category          string  `json:"category"`
	DefaultUnit       string  `json:"default_unit"`
	IsPantryEssential bool    `json:"is_pantry_essential"`
}

type IngredientListResponse struct {
	Items []IngredientResponse `json:"items"`
	Total int                  `json:"total"`
}

type IngredientFilterQuery struct {
	Query    string `form:"q"`
	Category string `form:"category"`
}
