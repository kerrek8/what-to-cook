package service

import (
	"context"
	"encoding/json"
	"errors"
	"sort"
	"strings"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/provider"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var (
	ErrRecipeNotFound = errors.New("recipe not found")
)

type RecipeService interface {
	List(ctx context.Context, userID *uuid.UUID, q dto.RecipeQuery) (dto.RecipeListResponse, error)
	GetByID(ctx context.Context, userID *uuid.UUID, id int32) (*dto.RecipeResponse, error)
	Match(ctx context.Context, userID uuid.UUID) (dto.RecipeMatchResponse, error)
	SetFavorite(ctx context.Context, userID uuid.UUID, recipeID int32, isFav bool) error
	SyncFromProvider(ctx context.Context, query string) (dto.RecipeSyncResponse, error)
}

type recipeService struct {
	store    store.Querier
	provider provider.RecipeProvider
}

func NewRecipeService(st store.Querier, prov provider.RecipeProvider) RecipeService {
	return &recipeService{
		store:    st,
		provider: prov,
	}
}

func (s *recipeService) List(ctx context.Context, userID *uuid.UUID, q dto.RecipeQuery) (dto.RecipeListResponse, error) {
	limit := q.Limit
	if limit <= 0 || limit > 100 {
		limit = 20
	}

	offset := q.Offset
	if offset < 0 {
		offset = 0
	}

	var queryText pgtype.Text
	if q.Query != "" {
		queryText = pgtype.Text{String: q.Query, Valid: true}
	}

	var diffText pgtype.Text
	if q.Difficulty != "" {
		diffText = pgtype.Text{String: q.Difficulty, Valid: true}
	}

	var maxTime pgtype.Int4
	if q.MaxTime > 0 {
		maxTime = pgtype.Int4{Int32: q.MaxTime, Valid: true}
	}

	recipes, err := s.store.ListRecipes(ctx, store.ListRecipesParams{
		Query:      queryText,
		Difficulty: diffText,
		MaxTime:    maxTime,
		LimitVal:   limit,
		OffsetVal:  offset,
	})
	if err != nil {
		return dto.RecipeListResponse{}, err
	}

	total, err := s.store.CountRecipes(ctx, store.CountRecipesParams{
		Query:      queryText,
		Difficulty: diffText,
		MaxTime:    maxTime,
	})
	if err != nil {
		return dto.RecipeListResponse{}, err
	}

	favMap := make(map[int32]bool)
	if userID != nil {
		favIDs, _ := s.store.ListUserFavoriteRecipeIDs(ctx, pgtype.UUID{Bytes: *userID, Valid: true})
		for _, f := range favIDs {
			favMap[f] = true
		}
	}

	responses := make([]dto.RecipeResponse, len(recipes))
	for i, r := range recipes {
		responses[i] = mapStoreRecipeToDTO(r, favMap[r.ID], nil)
	}

	return dto.RecipeListResponse{
		Items: responses,
		Total: int(total),
	}, nil
}

func (s *recipeService) GetByID(ctx context.Context, userID *uuid.UUID, id int32) (*dto.RecipeResponse, error) {
	recipe, err := s.store.GetRecipeByID(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrRecipeNotFound
		}
		return nil, err
	}

	ingredients, err := s.store.GetRecipeIngredients(ctx, id)
	if err != nil {
		return nil, err
	}

	isFav := false
	if userID != nil {
		isFav, _ = s.store.IsRecipeFavorite(ctx, store.IsRecipeFavoriteParams{
			UserID:   pgtype.UUID{Bytes: *userID, Valid: true},
			RecipeID: id,
		})
	}

	ingResponses := make([]dto.RecipeIngredientResponse, len(ingredients))
	for i, ing := range ingredients {
		ingResponses[i] = mapRecipeIngredientToDTO(ing)
	}

	resp := mapStoreRecipeToDTO(recipe, isFav, ingResponses)
	return &resp, nil
}

func (s *recipeService) Match(ctx context.Context, userID uuid.UUID) (dto.RecipeMatchResponse, error) {
	user, err := s.store.GetUserByID(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return dto.RecipeMatchResponse{}, err
	}

	excludedSet := make(map[int32]bool)
	for _, id := range user.ExcludedIngredientIds {
		excludedSet[id] = true
	}

	invItems, err := s.store.ListInventoryItemsByUserID(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return dto.RecipeMatchResponse{}, err
	}

	availableSet := make(map[int32]bool)
	for _, item := range invItems {
		if item.InStock && item.IngredientID.Valid {
			availableSet[item.IngredientID.Int32] = true
		}
	}

	recipes, err := s.store.ListRecipes(ctx, store.ListRecipesParams{
		LimitVal: 100,
	})
	if err != nil {
		return dto.RecipeMatchResponse{}, err
	}

	allIngredients, err := s.store.GetAllRecipeIngredientsWithDetails(ctx)
	if err != nil {
		return dto.RecipeMatchResponse{}, err
	}

	recipeIngMap := make(map[int32][]store.GetAllRecipeIngredientsWithDetailsRow)
	for _, ing := range allIngredients {
		recipeIngMap[ing.RecipeID] = append(recipeIngMap[ing.RecipeID], ing)
	}

	favIDs, _ := s.store.ListUserFavoriteRecipeIDs(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	favMap := make(map[int32]bool)
	for _, f := range favIDs {
		favMap[f] = true
	}

	matchItems := make([]dto.RecipeMatchItem, 0, len(recipes))

	for _, r := range recipes {
		ings := recipeIngMap[r.ID]

		hasAllergen := false
		for _, ing := range ings {
			if excludedSet[ing.IngredientID] {
				hasAllergen = true
				break
			}
		}
		if hasAllergen {
			continue
		}

		var used []dto.RecipeIngredientResponse
		var missing []dto.RecipeIngredientResponse

		for _, ing := range ings {
			ingDTO := mapAllDetailsIngredientToDTO(ing)
			if ing.IsPantryEssential || availableSet[ing.IngredientID] {
				used = append(used, ingDTO)
			} else {
				missing = append(missing, ingDTO)
			}
		}

		totalIngs := len(ings)
		matchPct := 100
		if totalIngs > 0 {
			matchPct = (len(used) * 100) / totalIngs
		}

		canCook := len(missing) == 0

		recipeDTO := mapStoreRecipeToDTO(r, favMap[r.ID], append(used, missing...))
		matchItems = append(matchItems, dto.RecipeMatchItem{
			Recipe:             recipeDTO,
			MatchPercentage:    matchPct,
			TotalIngredients:   totalIngs,
			AvailableCount:     len(used),
			UsedIngredients:    used,
			MissingIngredients: missing,
			CanCookNow:         canCook,
		})
	}

	sort.Slice(matchItems, func(i, j int) bool {
		if matchItems[i].MatchPercentage != matchItems[j].MatchPercentage {
			return matchItems[i].MatchPercentage > matchItems[j].MatchPercentage
		}
		if len(matchItems[i].MissingIngredients) != len(matchItems[j].MissingIngredients) {
			return len(matchItems[i].MissingIngredients) < len(matchItems[j].MissingIngredients)
		}
		return matchItems[i].Recipe.CookingTimeMinutes < matchItems[j].Recipe.CookingTimeMinutes
	})

	return dto.RecipeMatchResponse{
		Items: matchItems,
		Total: len(matchItems),
	}, nil
}

func (s *recipeService) SetFavorite(ctx context.Context, userID uuid.UUID, recipeID int32, isFav bool) error {
	_, err := s.store.GetRecipeByID(ctx, recipeID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrRecipeNotFound
		}
		return err
	}

	if isFav {
		return s.store.AddRecipeFavorite(ctx, store.AddRecipeFavoriteParams{
			UserID:   pgtype.UUID{Bytes: userID, Valid: true},
			RecipeID: recipeID,
		})
	}

	return s.store.RemoveRecipeFavorite(ctx, store.RemoveRecipeFavoriteParams{
		UserID:   pgtype.UUID{Bytes: userID, Valid: true},
		RecipeID: recipeID,
	})
}

func (s *recipeService) SyncFromProvider(ctx context.Context, query string) (dto.RecipeSyncResponse, error) {
	if s.provider == nil {
		return dto.RecipeSyncResponse{}, errors.New("no recipe provider configured")
	}

	externalRecipes, err := s.provider.SearchRecipes(ctx, query)
	if err != nil {
		return dto.RecipeSyncResponse{}, err
	}

	synced := 0
	for _, ext := range externalRecipes {
		instructionsJSON, _ := json.Marshal(ext.Instructions)

		var extID pgtype.Text
		if ext.ExternalID != "" {
			extID = pgtype.Text{String: ext.ExternalID, Valid: true}
		}

		var imgURL pgtype.Text
		if ext.ImageURL != "" {
			imgURL = pgtype.Text{String: ext.ImageURL, Valid: true}
		}

		var desc pgtype.Text
		if ext.Category != "" {
			desc = pgtype.Text{String: ext.Category, Valid: true}
		}

		recipe, err := s.store.UpsertRecipe(ctx, store.UpsertRecipeParams{
			ExternalID:         extID,
			Title:              ext.Title,
			Description:        desc,
			Instructions:       instructionsJSON,
			CookingTimeMinutes: 30,
			Difficulty:         "medium",
			ImageUrl:           imgURL,
		})
		if err != nil {
			continue
		}

		for _, ing := range ext.Ingredients {
			trimmedName := strings.TrimSpace(ing.Name)
			if trimmedName == "" {
				continue
			}

			found, err := s.store.SearchIngredients(ctx, store.SearchIngredientsParams{
				Query: pgtype.Text{String: trimmedName, Valid: true},
			})

			var ingredientID int32
			if err == nil && len(found) > 0 {
				ingredientID = found[0].ID
			} else {
				created, err := s.store.CreateIngredient(ctx, store.CreateIngredientParams{
					Name:              trimmedName,
					NameEn:            pgtype.Text{String: trimmedName, Valid: true},
					Category:          "other",
					DefaultUnit:       "g",
					IsPantryEssential: false,
				})
				if err != nil {
					continue
				}
				ingredientID = created.ID
			}

			var displayTxt pgtype.Text
			if ing.Measure != "" {
				displayTxt = pgtype.Text{String: ing.Measure + " " + trimmedName, Valid: true}
			}

			_, _ = s.store.AddRecipeIngredient(ctx, store.AddRecipeIngredientParams{
				RecipeID:     recipe.ID,
				IngredientID: ingredientID,
				DisplayText:  displayTxt,
				Criticality:  "critical",
			})
		}

		synced++
	}

	return dto.RecipeSyncResponse{SyncedCount: synced}, nil
}

func mapStoreRecipeToDTO(r store.Recipe, isFav bool, ings []dto.RecipeIngredientResponse) dto.RecipeResponse {
	var extID *string
	if r.ExternalID.Valid {
		extID = &r.ExternalID.String
	}

	var desc *string
	if r.Description.Valid {
		desc = &r.Description.String
	}

	var imgURL *string
	if r.ImageUrl.Valid {
		imgURL = &r.ImageUrl.String
	}

	var instructions []string
	if len(r.Instructions) > 0 {
		_ = json.Unmarshal(r.Instructions, &instructions)
	}
	if instructions == nil {
		instructions = []string{}
	}

	return dto.RecipeResponse{
		ID:                 r.ID,
		ExternalID:         extID,
		Title:              r.Title,
		Description:        desc,
		Instructions:       instructions,
		CookingTimeMinutes: r.CookingTimeMinutes,
		Difficulty:         r.Difficulty,
		ImageURL:           imgURL,
		IsFavorite:         isFav,
		Ingredients:        ings,
		CreatedAt:          r.CreatedAt.Time,
		UpdatedAt:          r.UpdatedAt.Time,
	}
}

func mapRecipeIngredientToDTO(ing store.GetRecipeIngredientsRow) dto.RecipeIngredientResponse {
	var nameEn *string
	if ing.IngredientNameEn.Valid {
		nameEn = &ing.IngredientNameEn.String
	}

	var unit *string
	if ing.Unit.Valid && ing.Unit.String != "" {
		unit = &ing.Unit.String
	} else if ing.IngredientDefaultUnit != "" {
		unit = &ing.IngredientDefaultUnit
	}

	var dispText *string
	if ing.DisplayText.Valid {
		dispText = &ing.DisplayText.String
	}

	return dto.RecipeIngredientResponse{
		IngredientID:      ing.IngredientID,
		Name:              ing.IngredientName,
		NameEn:            nameEn,
		Category:          ing.IngredientCategory,
		Amount:            numericToFloat(ing.Amount),
		Unit:              unit,
		DisplayText:       dispText,
		Criticality:       ing.Criticality,
		IsPantryEssential: ing.IsPantryEssential,
	}
}

func mapAllDetailsIngredientToDTO(ing store.GetAllRecipeIngredientsWithDetailsRow) dto.RecipeIngredientResponse {
	var nameEn *string
	if ing.IngredientNameEn.Valid {
		nameEn = &ing.IngredientNameEn.String
	}

	var unit *string
	if ing.Unit.Valid && ing.Unit.String != "" {
		unit = &ing.Unit.String
	} else if ing.IngredientDefaultUnit != "" {
		unit = &ing.IngredientDefaultUnit
	}

	var dispText *string
	if ing.DisplayText.Valid {
		dispText = &ing.DisplayText.String
	}

	return dto.RecipeIngredientResponse{
		IngredientID:      ing.IngredientID,
		Name:              ing.IngredientName,
		NameEn:            nameEn,
		Category:          ing.IngredientCategory,
		Amount:            numericToFloat(ing.Amount),
		Unit:              unit,
		DisplayText:       dispText,
		Criticality:       ing.Criticality,
		IsPantryEssential: ing.IsPantryEssential,
	}
}
