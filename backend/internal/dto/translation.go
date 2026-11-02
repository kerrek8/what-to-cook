package dto

type TranslateRequest struct {
	Texts  []string `json:"texts" binding:"required,min=1,max=10,dive,required,max=2000"`
	Source string   `json:"source" binding:"required,oneof=en ru"`
	Target string   `json:"target" binding:"required,oneof=en ru"`
}

type TranslateResponse struct {
	Translations []string `json:"translations"`
}
