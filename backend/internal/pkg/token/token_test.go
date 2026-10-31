package token_test

import (
	"testing"
	"time"

	"github.com/kerrek8/what-to-cook/backend/internal/pkg/token"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTokenGenerateAndParse(t *testing.T) {
	secret := "test-secret-at-least-16-bytes"
	userID := "550e8400-e29b-41d4-a716-446655440000"
	version := int32(1)

	tok, err := token.GenerateAccessToken(userID, version, secret, time.Hour)
	require.NoError(t, err)
	assert.NotEmpty(t, tok)

	claims, err := token.ParseToken(tok, secret)
	require.NoError(t, err)
	assert.Equal(t, userID, claims.UserID)
	assert.Equal(t, version, claims.TokenVersion)
	assert.Equal(t, "access", claims.Subject)
}

func TestTokenExpired(t *testing.T) {
	secret := "test-secret-at-least-16-bytes"
	userID := "550e8400-e29b-41d4-a716-446655440000"

	tok, err := token.GenerateAccessToken(userID, 1, secret, -time.Second)
	require.NoError(t, err)

	_, err = token.ParseToken(tok, secret)
	assert.Error(t, err)
	assert.ErrorIs(t, err, token.ErrInvalidToken)
}

func TestTokenInvalidSecret(t *testing.T) {
	secret1 := "test-secret-111111111111"
	secret2 := "test-secret-222222222222"
	userID := "550e8400-e29b-41d4-a716-446655440000"

	tok, err := token.GenerateAccessToken(userID, 1, secret1, time.Hour)
	require.NoError(t, err)

	_, err = token.ParseToken(tok, secret2)
	assert.Error(t, err)
	assert.ErrorIs(t, err, token.ErrInvalidToken)
}
