package server_test

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"math/big"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/config"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/server"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type e2eMockStore struct {
	store.Querier
	users             map[string]store.User
	usersByID         map[string]store.User
	ingredients       []store.Ingredient
	inventoryItems    map[string]store.InventoryItem
	recipes           map[int32]store.Recipe
	recipeIngredients map[int32][]store.GetRecipeIngredientsRow
	favorites         map[string]map[int32]bool
	shoppingItems     map[string]store.ShoppingListItem
	subscriptions     map[string]store.PushSubscription
}

func newE2EMockStore() *e2eMockStore {
	chicken := store.Ingredient{
		ID:                1,
		Name:              "Куриное филе",
		Category:          "Мясо и птица",
		DefaultUnit:       "г",
		IsPantryEssential: false,
	}
	potato := store.Ingredient{
		ID:                2,
		Name:              "Картофель",
		Category:          "Овощи",
		DefaultUnit:       "г",
		IsPantryEssential: false,
	}
	peanut := store.Ingredient{
		ID:                3,
		Name:              "Арахис",
		Category:          "Орехи",
		DefaultUnit:       "г",
		IsPantryEssential: false,
	}
	salt := store.Ingredient{
		ID:                4,
		Name:              "Соль",
		Category:          "Специи",
		DefaultUnit:       "г",
		IsPantryEssential: true,
	}

	recipe := store.Recipe{
		ID:                 1,
		Title:              "Курица с картофелем",
		Description:        pgtype.Text{String: "Вкусный и простой ужин", Valid: true},
		Instructions:       []byte(`["1. Нарезать курицу.", "2. Запечь с картофелем."}`),
		CookingTimeMinutes: 30,
		Difficulty:         "easy",
		CreatedAt:          pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}

	amount100 := pgtype.Numeric{Int: big.NewInt(100), Valid: true}
	amount200 := pgtype.Numeric{Int: big.NewInt(200), Valid: true}

	rIngs := []store.GetRecipeIngredientsRow{
		{
			ID:                    1,
			RecipeID:              1,
			IngredientID:          1,
			Amount:                amount200,
			Unit:                  pgtype.Text{String: "г", Valid: true},
			DisplayText:           pgtype.Text{String: "200г куриного филе", Valid: true},
			Criticality:           "critical",
			IngredientName:        "Куриное филе",
			IngredientCategory:    "Мясо и птица",
			IngredientDefaultUnit: "г",
			IsPantryEssential:     false,
		},
		{
			ID:                    2,
			RecipeID:              1,
			IngredientID:          2,
			Amount:                amount100,
			Unit:                  pgtype.Text{String: "г", Valid: true},
			DisplayText:           pgtype.Text{String: "100г картофеля", Valid: true},
			Criticality:           "critical",
			IngredientName:        "Картофель",
			IngredientCategory:    "Овощи",
			IngredientDefaultUnit: "г",
			IsPantryEssential:     false,
		},
	}

	return &e2eMockStore{
		users:             make(map[string]store.User),
		usersByID:         make(map[string]store.User),
		ingredients:       []store.Ingredient{chicken, potato, peanut, salt},
		inventoryItems:    make(map[string]store.InventoryItem),
		recipes:           map[int32]store.Recipe{1: recipe},
		recipeIngredients: map[int32][]store.GetRecipeIngredientsRow{1: rIngs},
		favorites:         make(map[string]map[int32]bool),
		shoppingItems:     make(map[string]store.ShoppingListItem),
		subscriptions:     make(map[string]store.PushSubscription),
	}
}

func (m *e2eMockStore) CreateUser(ctx context.Context, arg store.CreateUserParams) (store.User, error) {
	u := store.User{
		ID:                    pgtype.UUID{Bytes: uuid.New(), Valid: true},
		Email:                 arg.Email,
		PasswordHash:          arg.PasswordHash,
		Name:                  arg.Name,
		TokenVersion:          1,
		ExcludedIngredientIds: []int32{},
		CreatedAt:             pgtype.Timestamptz{Time: time.Now(), Valid: true},
		UpdatedAt:             pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}
	m.users[arg.Email] = u
	uidStr := uuid.UUID(u.ID.Bytes).String()
	m.usersByID[uidStr] = u
	return u, nil
}

func (m *e2eMockStore) GetUserByEmail(ctx context.Context, email string) (store.User, error) {
	u, ok := m.users[email]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	return u, nil
}

func (m *e2eMockStore) GetUserByID(ctx context.Context, id pgtype.UUID) (store.User, error) {
	uidStr := uuid.UUID(id.Bytes).String()
	u, ok := m.usersByID[uidStr]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	return u, nil
}

func (m *e2eMockStore) UpdateUserExcludedIngredients(ctx context.Context, arg store.UpdateUserExcludedIngredientsParams) error {
	uidStr := uuid.UUID(arg.ID.Bytes).String()
	u, ok := m.usersByID[uidStr]
	if !ok {
		return pgx.ErrNoRows
	}
	u.ExcludedIngredientIds = arg.ExcludedIngredientIds
	m.usersByID[uidStr] = u
	m.users[u.Email] = u
	return nil
}

func (m *e2eMockStore) UpdateUserTokenVersion(ctx context.Context, id pgtype.UUID) error {
	uidStr := uuid.UUID(id.Bytes).String()
	u, ok := m.usersByID[uidStr]
	if !ok {
		return pgx.ErrNoRows
	}
	u.TokenVersion++
	m.usersByID[uidStr] = u
	m.users[u.Email] = u
	return nil
}

func (m *e2eMockStore) SearchIngredients(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error) {
	query := strings.ToLower(arg.Query.String)
	var result []store.Ingredient
	for _, ing := range m.ingredients {
		if query == "" || strings.Contains(strings.ToLower(ing.Name), query) {
			result = append(result, ing)
		}
	}
	return result, nil
}

func (m *e2eMockStore) GetIngredientByID(ctx context.Context, id int32) (store.Ingredient, error) {
	for _, ing := range m.ingredients {
		if ing.ID == id {
			return ing, nil
		}
	}
	return store.Ingredient{}, pgx.ErrNoRows
}

func (m *e2eMockStore) CreateInventoryItem(ctx context.Context, arg store.CreateInventoryItemParams) (store.InventoryItem, error) {
	itemID := uuid.New()
	item := store.InventoryItem{
		ID:                  pgtype.UUID{Bytes: itemID, Valid: true},
		UserID:              arg.UserID,
		IngredientID:        arg.IngredientID,
		CustomName:          arg.CustomName,
		Amount:              arg.Amount,
		Unit:                arg.Unit,
		ApproximateQuantity: arg.ApproximateQuantity,
		InStock:             arg.InStock,
		ExpirationDate:      arg.ExpirationDate,
		CreatedAt:           pgtype.Timestamptz{Time: time.Now(), Valid: true},
		UpdatedAt:           pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}
	m.inventoryItems[itemID.String()] = item
	return item, nil
}

func (m *e2eMockStore) GetInventoryItemByIDAndUserID(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	it, ok := m.inventoryItems[idStr]
	if !ok || it.UserID != arg.UserID {
		return store.GetInventoryItemByIDAndUserIDRow{}, pgx.ErrNoRows
	}
	var ingName, ingCategory, ingUnit pgtype.Text
	for _, ing := range m.ingredients {
		if it.IngredientID.Valid && ing.ID == it.IngredientID.Int32 {
			ingName = pgtype.Text{String: ing.Name, Valid: true}
			ingCategory = pgtype.Text{String: ing.Category, Valid: true}
			ingUnit = pgtype.Text{String: ing.DefaultUnit, Valid: true}
			break
		}
	}
	return store.GetInventoryItemByIDAndUserIDRow{
		ID:                    it.ID,
		UserID:                it.UserID,
		IngredientID:          it.IngredientID,
		CustomName:            it.CustomName,
		Amount:                it.Amount,
		Unit:                  it.Unit,
		ApproximateQuantity:   it.ApproximateQuantity,
		InStock:               it.InStock,
		ExpirationDate:        it.ExpirationDate,
		CreatedAt:             it.CreatedAt,
		UpdatedAt:             it.UpdatedAt,
		IngredientName:        ingName,
		IngredientCategory:    ingCategory,
		IngredientDefaultUnit: ingUnit,
	}, nil
}

func (m *e2eMockStore) ListInventoryItemsByUserID(ctx context.Context, userID pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
	var rows []store.ListInventoryItemsByUserIDRow
	for _, it := range m.inventoryItems {
		if it.UserID == userID {
			var ingName, ingCategory, ingUnit pgtype.Text
			for _, ing := range m.ingredients {
				if it.IngredientID.Valid && ing.ID == it.IngredientID.Int32 {
					ingName = pgtype.Text{String: ing.Name, Valid: true}
					ingCategory = pgtype.Text{String: ing.Category, Valid: true}
					ingUnit = pgtype.Text{String: ing.DefaultUnit, Valid: true}
					break
				}
			}
			rows = append(rows, store.ListInventoryItemsByUserIDRow{
				ID:                    it.ID,
				UserID:                it.UserID,
				IngredientID:          it.IngredientID,
				CustomName:            it.CustomName,
				Amount:                it.Amount,
				Unit:                  it.Unit,
				ApproximateQuantity:   it.ApproximateQuantity,
				InStock:               it.InStock,
				ExpirationDate:        it.ExpirationDate,
				CreatedAt:             it.CreatedAt,
				UpdatedAt:             it.UpdatedAt,
				IngredientName:        ingName,
				IngredientCategory:    ingCategory,
				IngredientDefaultUnit: ingUnit,
			})
		}
	}
	return rows, nil
}

func (m *e2eMockStore) ListRecipes(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
	var result []store.Recipe
	for _, r := range m.recipes {
		result = append(result, r)
	}
	return result, nil
}

func (m *e2eMockStore) CountRecipes(ctx context.Context, arg store.CountRecipesParams) (int64, error) {
	return int64(len(m.recipes)), nil
}

func (m *e2eMockStore) CountPendingRecipeTranslations(ctx context.Context) (int64, error) {
	return 0, nil
}

func (m *e2eMockStore) GetRecipeByID(ctx context.Context, id int32) (store.Recipe, error) {
	r, ok := m.recipes[id]
	if !ok {
		return store.Recipe{}, pgx.ErrNoRows
	}
	return r, nil
}

func (m *e2eMockStore) GetRecipeIngredients(ctx context.Context, recipeID int32) ([]store.GetRecipeIngredientsRow, error) {
	return m.recipeIngredients[recipeID], nil
}

func (m *e2eMockStore) GetAllRecipeIngredientsWithDetails(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error) {
	var rows []store.GetAllRecipeIngredientsWithDetailsRow
	for _, ings := range m.recipeIngredients {
		for _, ing := range ings {
			rows = append(rows, store.GetAllRecipeIngredientsWithDetailsRow{
				ID:                    ing.ID,
				RecipeID:              ing.RecipeID,
				IngredientID:          ing.IngredientID,
				Amount:                ing.Amount,
				Unit:                  ing.Unit,
				DisplayText:           ing.DisplayText,
				Criticality:           ing.Criticality,
				IngredientName:        ing.IngredientName,
				IngredientCategory:    ing.IngredientCategory,
				IngredientDefaultUnit: ing.IngredientDefaultUnit,
				IsPantryEssential:     ing.IsPantryEssential,
			})
		}
	}
	return rows, nil
}

func (m *e2eMockStore) GetTranslatedRecipeIngredientsWithDetails(ctx context.Context) ([]store.GetTranslatedRecipeIngredientsWithDetailsRow, error) {
	var rows []store.GetTranslatedRecipeIngredientsWithDetailsRow
	for _, ings := range m.recipeIngredients {
		for _, ing := range ings {
			rows = append(rows, store.GetTranslatedRecipeIngredientsWithDetailsRow{
				ID:                    ing.ID,
				RecipeID:              ing.RecipeID,
				IngredientID:          ing.IngredientID,
				Amount:                ing.Amount,
				Unit:                  ing.Unit,
				DisplayText:           ing.DisplayText,
				Criticality:           ing.Criticality,
				IngredientName:        ing.IngredientName,
				IngredientCategory:    ing.IngredientCategory,
				IngredientDefaultUnit: ing.IngredientDefaultUnit,
				IsPantryEssential:     ing.IsPantryEssential,
			})
		}
	}
	return rows, nil
}

func (m *e2eMockStore) ListUserFavoriteRecipeIDs(ctx context.Context, userID pgtype.UUID) ([]int32, error) {
	uidStr := uuid.UUID(userID.Bytes).String()
	userFavs := m.favorites[uidStr]
	var ids []int32
	for id, isFav := range userFavs {
		if isFav {
			ids = append(ids, id)
		}
	}
	return ids, nil
}

func (m *e2eMockStore) AddRecipeFavorite(ctx context.Context, arg store.AddRecipeFavoriteParams) error {
	uidStr := uuid.UUID(arg.UserID.Bytes).String()
	if _, ok := m.favorites[uidStr]; !ok {
		m.favorites[uidStr] = make(map[int32]bool)
	}
	m.favorites[uidStr][arg.RecipeID] = true
	return nil
}

func (m *e2eMockStore) RemoveRecipeFavorite(ctx context.Context, arg store.RemoveRecipeFavoriteParams) error {
	uidStr := uuid.UUID(arg.UserID.Bytes).String()
	if userFavs, ok := m.favorites[uidStr]; ok {
		delete(userFavs, arg.RecipeID)
	}
	return nil
}

func (m *e2eMockStore) CreateShoppingItem(ctx context.Context, arg store.CreateShoppingItemParams) (store.ShoppingListItem, error) {
	id := uuid.New()
	it := store.ShoppingListItem{
		ID:           pgtype.UUID{Bytes: id, Valid: true},
		UserID:       arg.UserID,
		IngredientID: arg.IngredientID,
		CustomName:   arg.CustomName,
		Amount:       arg.Amount,
		Unit:         arg.Unit,
		IsBought:     arg.IsBought,
		CreatedAt:    pgtype.Timestamptz{Time: time.Now(), Valid: true},
		UpdatedAt:    pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}
	m.shoppingItems[id.String()] = it
	return it, nil
}

func (m *e2eMockStore) GetShoppingItemByIDAndUserID(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	it, ok := m.shoppingItems[idStr]
	if !ok || it.UserID != arg.UserID {
		return store.GetShoppingItemByIDAndUserIDRow{}, pgx.ErrNoRows
	}
	var ingName, ingCategory, ingUnit pgtype.Text
	for _, ing := range m.ingredients {
		if it.IngredientID.Valid && ing.ID == it.IngredientID.Int32 {
			ingName = pgtype.Text{String: ing.Name, Valid: true}
			ingCategory = pgtype.Text{String: ing.Category, Valid: true}
			ingUnit = pgtype.Text{String: ing.DefaultUnit, Valid: true}
			break
		}
	}
	return store.GetShoppingItemByIDAndUserIDRow{
		ID:                    it.ID,
		UserID:                it.UserID,
		IngredientID:          it.IngredientID,
		CustomName:            it.CustomName,
		Amount:                it.Amount,
		Unit:                  it.Unit,
		IsBought:              it.IsBought,
		CreatedAt:             it.CreatedAt,
		UpdatedAt:             it.UpdatedAt,
		IngredientName:        ingName,
		IngredientCategory:    ingCategory,
		IngredientDefaultUnit: ingUnit,
	}, nil
}

func (m *e2eMockStore) GetShoppingItemByIngredientAndUserID(ctx context.Context, arg store.GetShoppingItemByIngredientAndUserIDParams) (store.ShoppingListItem, error) {
	for _, it := range m.shoppingItems {
		if it.UserID == arg.UserID && it.IngredientID == arg.IngredientID {
			return it, nil
		}
	}
	return store.ShoppingListItem{}, pgx.ErrNoRows
}

func (m *e2eMockStore) ListShoppingItemsByUserID(ctx context.Context, userID pgtype.UUID) ([]store.ListShoppingItemsByUserIDRow, error) {
	var rows []store.ListShoppingItemsByUserIDRow
	for _, it := range m.shoppingItems {
		if it.UserID == userID {
			var ingName, ingCategory, ingUnit pgtype.Text
			for _, ing := range m.ingredients {
				if it.IngredientID.Valid && ing.ID == it.IngredientID.Int32 {
					ingName = pgtype.Text{String: ing.Name, Valid: true}
					ingCategory = pgtype.Text{String: ing.Category, Valid: true}
					ingUnit = pgtype.Text{String: ing.DefaultUnit, Valid: true}
					break
				}
			}
			rows = append(rows, store.ListShoppingItemsByUserIDRow{
				ID:                    it.ID,
				UserID:                it.UserID,
				IngredientID:          it.IngredientID,
				CustomName:            it.CustomName,
				Amount:                it.Amount,
				Unit:                  it.Unit,
				IsBought:              it.IsBought,
				CreatedAt:             it.CreatedAt,
				UpdatedAt:             it.UpdatedAt,
				IngredientName:        ingName,
				IngredientCategory:    ingCategory,
				IngredientDefaultUnit: ingUnit,
			})
		}
	}
	return rows, nil
}

func (m *e2eMockStore) UpdateShoppingItem(ctx context.Context, arg store.UpdateShoppingItemParams) (store.ShoppingListItem, error) {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	it, ok := m.shoppingItems[idStr]
	if !ok || it.UserID != arg.UserID {
		return store.ShoppingListItem{}, pgx.ErrNoRows
	}
	if arg.CustomName.Valid {
		it.CustomName = arg.CustomName
	}
	if arg.Amount.Valid {
		it.Amount = arg.Amount
	}
	if arg.Unit.Valid {
		it.Unit = arg.Unit
	}
	if arg.IsBought.Valid {
		it.IsBought = arg.IsBought.Bool
	}
	it.UpdatedAt = pgtype.Timestamptz{Time: time.Now(), Valid: true}
	m.shoppingItems[idStr] = it
	return it, nil
}

func (m *e2eMockStore) SetShoppingItemBoughtStatus(ctx context.Context, arg store.SetShoppingItemBoughtStatusParams) (store.ShoppingListItem, error) {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	it, ok := m.shoppingItems[idStr]
	if !ok {
		return store.ShoppingListItem{}, pgx.ErrNoRows
	}
	it.IsBought = arg.IsBought
	it.UpdatedAt = pgtype.Timestamptz{Time: time.Now(), Valid: true}
	m.shoppingItems[idStr] = it
	return it, nil
}

func (m *e2eMockStore) TransferBoughtItemsToInventory(ctx context.Context, userID pgtype.UUID) ([]store.InventoryItem, error) {
	var transferred []store.InventoryItem
	for idStr, it := range m.shoppingItems {
		if it.UserID == userID && it.IsBought {
			invID := uuid.New()
			invItem := store.InventoryItem{
				ID:           pgtype.UUID{Bytes: invID, Valid: true},
				UserID:       it.UserID,
				IngredientID: it.IngredientID,
				CustomName:   it.CustomName,
				Amount:       it.Amount,
				Unit:         it.Unit,
				InStock:      true,
				CreatedAt:    pgtype.Timestamptz{Time: time.Now(), Valid: true},
				UpdatedAt:    pgtype.Timestamptz{Time: time.Now(), Valid: true},
			}
			m.inventoryItems[invID.String()] = invItem
			transferred = append(transferred, invItem)
			delete(m.shoppingItems, idStr)
		}
	}
	return transferred, nil
}

func (m *e2eMockStore) DeleteBoughtShoppingItemsByUserID(ctx context.Context, userID pgtype.UUID) error {
	for idStr, it := range m.shoppingItems {
		if it.UserID == userID && it.IsBought {
			delete(m.shoppingItems, idStr)
		}
	}
	return nil
}

func (m *e2eMockStore) UpsertPushSubscription(ctx context.Context, arg store.UpsertPushSubscriptionParams) (store.PushSubscription, error) {
	id := uuid.New()
	sub := store.PushSubscription{
		ID:        pgtype.UUID{Bytes: id, Valid: true},
		UserID:    arg.UserID,
		Endpoint:  arg.Endpoint,
		P256dh:    arg.P256dh,
		Auth:      arg.Auth,
		CreatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}
	m.subscriptions[id.String()] = sub
	return sub, nil
}

func (m *e2eMockStore) ListPushSubscriptionsByUserID(ctx context.Context, userID pgtype.UUID) ([]store.PushSubscription, error) {
	var subs []store.PushSubscription
	for _, s := range m.subscriptions {
		if s.UserID == userID {
			subs = append(subs, s)
		}
	}
	return subs, nil
}

func setupTestServer() (*gin.Engine, *e2eMockStore) {
	mockStore := newE2EMockStore()
	cfg := &config.Config{
		Server: config.ServerConfig{
			Port: "8080",
			Mode: gin.TestMode,
		},
		Auth: config.AuthConfig{
			JWTSecret: "test-super-secret-jwt-key-minimum-32-bytes",
		},
		CORS: config.CORSConfig{
			AllowedOrigins: []string{"*"},
		},
		VAPID: config.VAPIDConfig{
			PublicKey: "test-vapid-public-key",
		},
	}
	srv := server.NewWithQuerier(cfg, mockStore, nil, nil)
	return srv.Router(), mockStore
}

func TestSwaggerAndHealthEndpoints(t *testing.T) {
	router, _ := setupTestServer()

	// 1. Health endpoint
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	assert.Equal(t, http.StatusOK, rec.Code)

	var healthResp dto.HealthResponse
	err := json.Unmarshal(rec.Body.Bytes(), &healthResp)
	require.NoError(t, err)
	assert.Equal(t, "ok", healthResp.Status)

	// 2. Swagger UI endpoint
	req = httptest.NewRequest(http.MethodGet, "/swagger/index.html", nil)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	assert.Equal(t, http.StatusOK, rec.Code)
	assert.Contains(t, rec.Body.String(), "Swagger UI")

	// 3. Swagger Doc JSON endpoint
	req = httptest.NewRequest(http.MethodGet, "/swagger/doc.json", nil)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	assert.Equal(t, http.StatusOK, rec.Code)
	assert.Contains(t, rec.Body.String(), "/api/v1/auth/register")
	assert.Contains(t, rec.Body.String(), "/health")
	assert.Contains(t, rec.Body.String(), "/api/v1/notifications/vapid-key")
}

func TestEndToEndUserJourney(t *testing.T) {
	router, _ := setupTestServer()

	// 1. Register User
	registerPayload := dto.RegisterRequest{
		Email:    "chef@whatcook.app",
		Password: "SecurePassword123!",
		Name:     "Шеф-Повар",
	}
	body, _ := json.Marshal(registerPayload)
	req := httptest.NewRequest(http.MethodPost, "/api/v1/auth/register", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	rec := httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusCreated, rec.Code)

	var authResp dto.AuthResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &authResp))
	assert.NotEmpty(t, authResp.AccessToken)
	assert.Equal(t, "Шеф-Повар", authResp.User.Name)
	tokenHeader := "Bearer " + authResp.AccessToken

	// 2. Get Profile
	req = httptest.NewRequest(http.MethodGet, "/api/v1/users/me", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	var userResp dto.UserResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &userResp))
	assert.Equal(t, "chef@whatcook.app", userResp.Email)

	// 3. Update Allergen (exclude peanuts, id=3)
	allergenPayload := dto.UpdateAllergensRequest{
		ExcludedIngredientIDs: []int32{3},
	}
	body, _ = json.Marshal(allergenPayload)
	req = httptest.NewRequest(http.MethodPut, "/api/v1/users/me/allergens", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &userResp))
	assert.Equal(t, []int32{3}, userResp.ExcludedIngredientIDs)

	// 4. Search Ingredients Catalog
	req = httptest.NewRequest(http.MethodGet, "/api/v1/ingredients?q=Кури", nil)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	var ingListResp dto.IngredientListResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &ingListResp))
	require.NotEmpty(t, ingListResp.Items)
	assert.Equal(t, "Куриное филе", ingListResp.Items[0].Name)

	// 5. Add Inventory Item to Fridge
	chickenID := int32(1)
	invPayload := dto.CreateInventoryItemRequest{
		IngredientID: &chickenID,
		Amount:       floatPtr(300),
		Unit:         stringPtr("г"),
		InStock:      boolPtr(true),
	}
	body, _ = json.Marshal(invPayload)
	req = httptest.NewRequest(http.MethodPost, "/api/v1/inventory", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusCreated, rec.Code)

	// 6. List Fridge Inventory
	req = httptest.NewRequest(http.MethodGet, "/api/v1/inventory", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	var invListResp dto.InventoryListResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &invListResp))
	require.Len(t, invListResp.Items, 1)
	assert.Equal(t, "Куриное филе", invListResp.Items[0].Name)

	// 7. Match Recipes
	req = httptest.NewRequest(http.MethodGet, "/api/v1/recipes/match", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	var matchResp dto.RecipeMatchResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &matchResp))
	require.NotEmpty(t, matchResp.Items)
	assert.Equal(t, int32(1), matchResp.Items[0].Recipe.ID)
	assert.Equal(t, 1, matchResp.Items[0].AvailableCount)
	assert.Len(t, matchResp.Items[0].MissingIngredients, 1)

	// 8. Add Recipe to Favorites
	req = httptest.NewRequest(http.MethodPost, "/api/v1/recipes/1/favorite", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	// 9. Add Missing Recipe Ingredients to Shopping List
	req = httptest.NewRequest(http.MethodPost, "/api/v1/shopping-list/from-recipe/1", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	var fromRecipeResp dto.AddFromRecipeResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &fromRecipeResp))
	assert.Equal(t, 1, fromRecipeResp.AddedCount)

	// 10. List Shopping Items
	req = httptest.NewRequest(http.MethodGet, "/api/v1/shopping-list", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	var shopListResp dto.ShoppingListResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &shopListResp))
	require.Len(t, shopListResp.Items, 1)
	assert.Equal(t, "Картофель", shopListResp.Items[0].Name)
	assert.False(t, shopListResp.Items[0].IsBought)
	shoppingItemID := shopListResp.Items[0].ID

	// 11. Mark Shopping Item as Bought
	isBought := true
	updateShopPayload := dto.UpdateShoppingItemRequest{
		IsBought: &isBought,
	}
	body, _ = json.Marshal(updateShopPayload)
	req = httptest.NewRequest(http.MethodPatch, fmt.Sprintf("/api/v1/shopping-list/%s", shoppingItemID), bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	// 12. Transfer Bought Items to Fridge Inventory
	req = httptest.NewRequest(http.MethodPost, "/api/v1/shopping-list/transfer-to-inventory", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	var transferResp dto.TransferToInventoryResponse
	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &transferResp))
	assert.Equal(t, 1, transferResp.TransferredCount)

	// Verify Fridge now has 2 items (Куриное филе + Картофель)
	req = httptest.NewRequest(http.MethodGet, "/api/v1/inventory", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	require.NoError(t, json.Unmarshal(rec.Body.Bytes(), &invListResp))
	assert.Len(t, invListResp.Items, 2)

	// 13. Web Push VAPID key
	req = httptest.NewRequest(http.MethodGet, "/api/v1/notifications/vapid-key", nil)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	// 14. Push Subscribe
	pushPayload := dto.SubscribeNotificationRequest{
		Endpoint: "https://fcm.googleapis.com/fcm/send/test-token",
		Keys: &dto.PushKeys{
			P256dh: "BM123...",
			Auth:   "auth456...",
		},
	}
	body, _ = json.Marshal(pushPayload)
	req = httptest.NewRequest(http.MethodPost, "/api/v1/notifications/subscribe", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusCreated, rec.Code)

	// 15. List Push Subscriptions
	req = httptest.NewRequest(http.MethodGet, "/api/v1/notifications/subscriptions", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusOK, rec.Code)

	// 16. Logout
	req = httptest.NewRequest(http.MethodPost, "/api/v1/auth/logout", nil)
	req.Header.Set("Authorization", tokenHeader)
	rec = httptest.NewRecorder()
	router.ServeHTTP(rec, req)
	require.Equal(t, http.StatusNoContent, rec.Code)
}

func floatPtr(v float64) *float64 {
	return &v
}

func stringPtr(v string) *string {
	return &v
}

func boolPtr(v bool) *bool {
	return &v
}
