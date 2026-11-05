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

	worker := service.NewRecipeWorker(mockStore, config.GigaChatConfig{}, cfg)
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

	worker := service.NewRecipeWorker(mockStore, config.GigaChatConfig{}, cfg)
	require.NotNil(t, worker)

	worker.Start()
	worker.Start()

	time.Sleep(50 * time.Millisecond)

	worker.Stop()
	worker.Stop()
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
			assert.NotContains(t, img, tc.disallowedURL, "image for %s must not match generic disallowed image %s", tc.title, tc.disallowedURL)
		}
	}
}
