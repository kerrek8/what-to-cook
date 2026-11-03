package service_test

import (
	"context"
	"errors"
	"testing"
	"time"

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


func TestParseDailyLimitError(t *testing.T) {
	t.Run("nil error", func(t *testing.T) {
		isDaily, d := service.ParseDailyLimitError(nil)
		assert.False(t, isDaily)
		assert.Equal(t, time.Duration(0), d)
	})

	t.Run("regular error", func(t *testing.T) {
		isDaily, d := service.ParseDailyLimitError(errors.New("connection reset by peer"))
		assert.False(t, isDaily)
		assert.Equal(t, time.Duration(0), d)
	})

	t.Run("TPM minute rate limit", func(t *testing.T) {
		isDaily, d := service.ParseDailyLimitError(errors.New("groq status 429: Rate limit reached on tokens per minute (TPM). Please try again in 2s."))
		assert.False(t, isDaily)
		assert.Equal(t, time.Duration(0), d)
	})

	t.Run("TPD daily limit with minutes and seconds", func(t *testing.T) {
		err := errors.New("groq status 429: Rate limit reached for model openai/gpt-oss-20b on tokens per day (TPD): Limit 200000, Used 199644, Requested 1418. Please try again in 7m38.784s. Need more tokens? Upgrade to Dev Tier.")
		isDaily, d := service.ParseDailyLimitError(err)
		assert.True(t, isDaily)
		expected := 7*time.Minute + 38*time.Second + 784*time.Millisecond + 10*time.Second
		assert.Equal(t, expected, d)
	})

	t.Run("RPD daily limit with minutes and seconds", func(t *testing.T) {
		err := errors.New("groq status 429: Rate limit reached on requests per day (RPD): Please try again in 20m51.936s.")
		isDaily, d := service.ParseDailyLimitError(err)
		assert.True(t, isDaily)
		expected := 20*time.Minute + 51*time.Second + 936*time.Millisecond + 10*time.Second
		assert.Equal(t, expected, d)
	})

	t.Run("TPD daily limit without parseable duration", func(t *testing.T) {
		err := errors.New("groq status 429: Rate limit reached on tokens per day (TPD).")
		isDaily, d := service.ParseDailyLimitError(err)
		assert.True(t, isDaily)
		assert.Equal(t, 15*time.Minute, d)
	})
}
