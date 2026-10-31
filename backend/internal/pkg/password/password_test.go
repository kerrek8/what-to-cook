package password_test

import (
	"testing"

	"github.com/kerrek8/what-to-cook/backend/internal/pkg/password"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestHashAndCompare(t *testing.T) {
	plain := "my-secret-password-123"

	hashed, err := password.Hash(plain)
	require.NoError(t, err)
	assert.NotEmpty(t, hashed)
	assert.NotEqual(t, plain, hashed)

	err = password.Compare(hashed, plain)
	assert.NoError(t, err)

	err = password.Compare(hashed, "wrong-password")
	assert.Error(t, err)
}
