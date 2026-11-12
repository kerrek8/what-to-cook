package service_test

import (
	"context"
	"testing"

	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestUserService(t *testing.T) {
	mock := newMockQuerier()
	authService := service.NewAuthService(mock, "test-secret-at-least-16-bytes")
	userService := service.NewUserService(mock)
	ctx := context.Background()

	authResp, _, err := authService.Register(ctx, dto.RegisterRequest{
		Email:    "allergens@example.com",
		Password: "password123",
		Name:     "Allergen User",
	})
	require.NoError(t, err)

	t.Run("get me", func(t *testing.T) {
		me, err := userService.GetMe(ctx, authResp.User.ID)
		require.NoError(t, err)
		assert.Equal(t, authResp.User.Email, me.Email)
		assert.Empty(t, me.ExcludedIngredientIDs)
		assert.Nil(t, me.AvatarURL)
	})

	t.Run("update allergens valid single item", func(t *testing.T) {
		updated, err := userService.UpdateAllergens(ctx, authResp.User.ID, dto.UpdateAllergensRequest{
			ExcludedIngredientIDs: []int32{42},
		})
		require.NoError(t, err)
		assert.Equal(t, []int32{42}, updated.ExcludedIngredientIDs)
	})

	t.Run("update allergens exceeds free limit", func(t *testing.T) {
		_, err := userService.UpdateAllergens(ctx, authResp.User.ID, dto.UpdateAllergensRequest{
			ExcludedIngredientIDs: []int32{42, 99},
		})
		assert.ErrorIs(t, err, service.ErrMaxAllergensExceeded)
	})

	t.Run("update avatar and delete avatar", func(t *testing.T) {
		avatarURL := "/uploads/avatars/test-user.jpg"
		updated, err := userService.UpdateAvatar(ctx, authResp.User.ID, &avatarURL)
		require.NoError(t, err)
		require.NotNil(t, updated.AvatarURL)
		assert.Equal(t, avatarURL, *updated.AvatarURL)

		deleted, err := userService.UpdateAvatar(ctx, authResp.User.ID, nil)
		require.NoError(t, err)
		assert.Nil(t, deleted.AvatarURL)
	})
}
