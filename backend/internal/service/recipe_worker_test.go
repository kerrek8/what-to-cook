package service_test

import (
	"context"
	"testing"
	"time"

	"github.com/kerrek8/what-to-cook/backend/internal/config"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockWorkerQuerier struct {
	store.Querier
	countFunc func(ctx context.Context) (int64, error)
}

func (m *mockWorkerQuerier) CountTotalRecipes(ctx context.Context) (int64, error) {
	if m.countFunc != nil {
		return m.countFunc(ctx)
	}
	return 0, nil
}

func TestRecipeWorker_NewAndDisabled(t *testing.T) {
	mockStore := &mockWorkerQuerier{}

	cfg := config.RecipeWorkerConfig{
		Enabled:        false,
		TargetTotal:    500,
		ChunkSize:      50,
		SubBatchSize:   3,
		SubBatchPause:  10 * time.Millisecond,
		RateLimitPause: 50 * time.Millisecond,
	}

	worker := service.NewRecipeWorker(mockStore, config.GigaChatConfig{}, cfg, nil)
	require.NotNil(t, worker)

	worker.Start()
	worker.Stop()
}

func TestRecipeWorker_StartAndStop(t *testing.T) {
	mockStore := &mockWorkerQuerier{
		countFunc: func(ctx context.Context) (int64, error) {
			return 500, nil
		},
	}

	cfg := config.RecipeWorkerConfig{
		Enabled:        true,
		TargetTotal:    500,
		ChunkSize:      50,
		SubBatchSize:   3,
		SubBatchPause:  10 * time.Millisecond,
		RateLimitPause: 50 * time.Millisecond,
	}

	worker := service.NewRecipeWorker(mockStore, config.GigaChatConfig{}, cfg, nil)
	require.NotNil(t, worker)

	worker.Start()
	worker.Start()

	time.Sleep(50 * time.Millisecond)

	worker.Stop()
	worker.Stop()
}

func TestRecipeImageFilename(t *testing.T) {
	fn1 := service.RecipeImageFilename("Борщ классический")
	fn2 := service.RecipeImageFilename("борщ классический ")
	assert.NotEmpty(t, fn1)
	assert.Equal(t, fn1, fn2)
	assert.True(t, len(fn1) > 5)
	assert.Contains(t, fn1, ".jpg")

	fn3 := service.RecipeImageFilename("Шарлотка с яблоками")
	assert.NotEqual(t, fn1, fn3)
}

func TestGetCuratedRecipeImage(t *testing.T) {
	tests := []struct {
		title         string
		category      string
		disallowedURL string
	}{
		{"Борщ классический с говядиной", "Супы", ""},
		{"Суп гороховый с копченостями", "Супы", ""},
		{"Скумбрия на гриле с лимоном", "Вторые блюда", ""},
		{"Куриные крылышки в медово-соевом соусе", "Вторые блюда", ""},
		{"Говядина тушеная с луком", "Вторые блюда", ""},
		{"Лазанья классическая болоньезе", "Вторые блюда", ""},
		{"Салат греческий с сыром фета", "Салаты", ""},
		{"Сырники из творога со сметаной", "Закуски", ""},
		{"Рогалики с повидлом домашние", "Выпечка", ""},
		{"Чизкейк нью-йорк с ягодами", "Десерты", "photo-1509440159596-0249088772ff"},
		{"Ананасовый пирог со взбитыми сливками", "Выпечка", "photo-1509440159596-0249088772ff"},
		{"Шоколадная паста Нутелла с фундуком", "Десерты", "photo-1551183053-bf91a1d81141"},
		{"Пицца четыре сыра", "Выпечка", ""},
		{"Домашние картофельные чипсы", "Закуски", ""},
		{"Неизвестное блюдо", "Другое", ""},
	}

	for _, tc := range tests {
		img := service.GetCuratedRecipeImage(tc.title, tc.category)
		assert.NotEmpty(t, img, "image should not be empty for %s", tc.title)
		assert.Contains(t, img, "https://images.unsplash.com/", "should be valid unsplash image for %s", tc.title)
		if tc.disallowedURL != "" {
			assert.NotContains(t, img, tc.disallowedURL, "image should not contain %s for %s", tc.disallowedURL, tc.title)
		}
	}
}

func TestGenerateFluxImage_DelegationAndFallback(t *testing.T) {
	mockStore := &mockWorkerQuerier{}
	worker := service.NewRecipeWorker(mockStore, config.GigaChatConfig{}, config.RecipeWorkerConfig{}, nil)
	require.NotNil(t, worker)

	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	// Calling with cancelled/short context should return error or fallback gracefully without panic
	_, _ = worker.GenerateFluxImage(ctx, "Борщ классический", "appetizing borscht")
	_, _ = worker.GenerateKandinskyImage(ctx, "Борщ классический")
}
