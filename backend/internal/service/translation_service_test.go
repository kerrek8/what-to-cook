package service_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/stretchr/testify/assert"
)

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

	t.Run("non-daily error", func(t *testing.T) {
		isDaily, d := service.ParseDailyLimitError(errors.New("connection reset by peer"))
		assert.False(t, isDaily)
		assert.Equal(t, time.Duration(0), d)
	})

	t.Run("tokens per day limit with duration", func(t *testing.T) {
		err := errors.New("Rate limit reached for model `llama-3.3-70b-versatile` on tokens per day (TPD): Limit 100000, Used 99500, Requested 1500. Please try again in 4h21m15.5s.")
		isDaily, d := service.ParseDailyLimitError(err)
		assert.True(t, isDaily)
		expected := 4*time.Hour + 21*time.Minute + 15*time.Second + 500*time.Millisecond + 10*time.Second
		assert.Equal(t, expected, d)
	})

	t.Run("requests per day limit with seconds", func(t *testing.T) {
		err := errors.New("requests per day (RPD) limit exceeded. Please try again in 45s.")
		isDaily, d := service.ParseDailyLimitError(err)
		assert.True(t, isDaily)
		assert.Equal(t, 55*time.Second, d)
	})

	t.Run("daily limit without parseable duration", func(t *testing.T) {
		err := errors.New("exceeded tokens per day (tpd) quota")
		isDaily, d := service.ParseDailyLimitError(err)
		assert.True(t, isDaily)
		assert.Equal(t, 15*time.Minute, d)
	})
}
