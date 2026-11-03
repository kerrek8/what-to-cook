package service_test

import (
	"context"
	"testing"

	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTranslationService_SourceEqualsTarget(t *testing.T) {
	svc := service.NewTranslationService("", "")
	res, err := svc.Translate(dto.TranslateRequest{
		Texts:  []string{"Hello", "World"},
		Source: "en",
		Target: "en",
	})
	require.NoError(t, err)
	assert.Equal(t, []string{"Hello", "World"}, res.Translations)
}

func TestTranslationService_DictionaryTranslations(t *testing.T) {
	svc := service.NewTranslationService("", "")

	t.Run("EN to RU culinary terms", func(t *testing.T) {
		res, err := svc.Translate(dto.TranslateRequest{
			Texts:  []string{"Salt", "chicken breast", "olive oil", "eggs"},
			Source: "en",
			Target: "ru",
		})
		require.NoError(t, err)
		assert.Equal(t, []string{"соль", "куриная грудка", "оливковое масло", "яйца"}, res.Translations)
	})

	t.Run("RU to EN search query terms", func(t *testing.T) {
		res, err := svc.Translate(dto.TranslateRequest{
			Texts:  []string{"курица", "говядина", "паста", "суп"},
			Source: "ru",
			Target: "en",
		})
		require.NoError(t, err)
		assert.Equal(t, []string{"chicken", "beef", "pasta", "soup"}, res.Translations)
	})
}

func TestTranslationService_AlreadyInTargetLanguage(t *testing.T) {
	svc := service.NewTranslationService("", "")

	res, err := svc.Translate(dto.TranslateRequest{
		Texts:  []string{"Соль поваренная", "100г", "1/2 ч. л."},
		Source: "en",
		Target: "ru",
	})
	require.NoError(t, err)
	assert.Equal(t, []string{"Соль поваренная", "100г", "1/2 ч. л."}, res.Translations)
}

func TestTranslationService_EmptyStrings(t *testing.T) {
	svc := service.NewTranslationService("", "")

	res, err := svc.Translate(dto.TranslateRequest{
		Texts:  []string{"", "   ", "salt"},
		Source: "en",
		Target: "ru",
	})
	require.NoError(t, err)
	assert.Equal(t, []string{"", "   ", "соль"}, res.Translations)
}

func TestTranslationService_Caching(t *testing.T) {
	svc := service.NewTranslationService("", "")

	req := dto.TranslateRequest{
		Texts:  []string{"water", "garlic"},
		Source: "en",
		Target: "ru",
	}

	first, err := svc.Translate(req)
	require.NoError(t, err)

	second, err := svc.Translate(req)
	require.NoError(t, err)

	assert.Equal(t, first.Translations, second.Translations)
}

func TestTranslationService_GroqDisabled(t *testing.T) {
	svc := service.NewTranslationService("", "")
	assert.False(t, svc.IsGroqEnabled())

	_, err := svc.TranslateRecipeGroq(context.Background(), service.GroqRecipeTranslateRequest{
		Title: "Test",
	})
	assert.Error(t, err)
}

func TestTranslationService_GroqEnabled(t *testing.T) {
	svc := service.NewTranslationService("test_key", "llama-3.3-70b-versatile")
	assert.True(t, svc.IsGroqEnabled())
}
