package service_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockQuerier struct {
	store.Querier
	usersByEmail map[string]store.User
	usersByID    map[string]store.User
}

func newMockQuerier() *mockQuerier {
	return &mockQuerier{
		usersByEmail: make(map[string]store.User),
		usersByID:    make(map[string]store.User),
	}
}

func (m *mockQuerier) CreateUser(ctx context.Context, arg store.CreateUserParams) (store.User, error) {
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
	idStr := uuid.UUID(u.ID.Bytes).String()
	m.usersByEmail[u.Email] = u
	m.usersByID[idStr] = u
	return u, nil
}

func (m *mockQuerier) GetUserByEmail(ctx context.Context, email string) (store.User, error) {
	u, ok := m.usersByEmail[email]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	return u, nil
}

func (m *mockQuerier) GetUserByID(ctx context.Context, id pgtype.UUID) (store.User, error) {
	idStr := uuid.UUID(id.Bytes).String()
	u, ok := m.usersByID[idStr]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	return u, nil
}

func (m *mockQuerier) UpdateUserTokenVersion(ctx context.Context, id pgtype.UUID) error {
	idStr := uuid.UUID(id.Bytes).String()
	u, ok := m.usersByID[idStr]
	if !ok {
		return pgx.ErrNoRows
	}
	u.TokenVersion++
	m.usersByID[idStr] = u
	m.usersByEmail[u.Email] = u
	return nil
}

func (m *mockQuerier) UpdateUserExcludedIngredients(ctx context.Context, arg store.UpdateUserExcludedIngredientsParams) error {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	u, ok := m.usersByID[idStr]
	if !ok {
		return pgx.ErrNoRows
	}
	u.ExcludedIngredientIds = arg.ExcludedIngredientIds
	m.usersByID[idStr] = u
	m.usersByEmail[u.Email] = u
	return nil
}

func (m *mockQuerier) UpdateUserAvatar(ctx context.Context, arg store.UpdateUserAvatarParams) (store.User, error) {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	u, ok := m.usersByID[idStr]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	u.AvatarUrl = arg.AvatarUrl
	m.usersByID[idStr] = u
	m.usersByEmail[u.Email] = u
	return u, nil
}

func TestAuthService_RegisterAndLogin(t *testing.T) {
	secret := "test-secret-at-least-16-bytes"
	mock := newMockQuerier()
	authService := service.NewAuthService(mock, secret)
	ctx := context.Background()

	t.Run("successful register", func(t *testing.T) {
		req := dto.RegisterRequest{
			Email:    "test@example.com",
			Password: "password123",
			Name:     "Test User",
		}

		resp, refToken, err := authService.Register(ctx, req)
		require.NoError(t, err)
		assert.Equal(t, "test@example.com", resp.User.Email)
		assert.Equal(t, "Test User", resp.User.Name)
		assert.NotEmpty(t, resp.AccessToken)
		assert.NotEmpty(t, refToken)
	})

	t.Run("duplicate email fails", func(t *testing.T) {
		req := dto.RegisterRequest{
			Email:    "test@example.com",
			Password: "password123",
			Name:     "Test User 2",
		}

		_, _, err := authService.Register(ctx, req)
		assert.ErrorIs(t, err, service.ErrUserAlreadyExists)
	})

	t.Run("successful login", func(t *testing.T) {
		req := dto.LoginRequest{
			Email:    "test@example.com",
			Password: "password123",
		}

		resp, refToken, err := authService.Login(ctx, req)
		require.NoError(t, err)
		assert.NotEmpty(t, resp.AccessToken)
		assert.NotEmpty(t, refToken)
	})

	t.Run("wrong password fails", func(t *testing.T) {
		req := dto.LoginRequest{
			Email:    "test@example.com",
			Password: "wrongpassword",
		}

		_, _, err := authService.Login(ctx, req)
		assert.ErrorIs(t, err, service.ErrInvalidCredentials)
	})

	t.Run("unknown email fails", func(t *testing.T) {
		req := dto.LoginRequest{
			Email:    "unknown@example.com",
			Password: "password123",
		}

		_, _, err := authService.Login(ctx, req)
		assert.ErrorIs(t, err, service.ErrInvalidCredentials)
	})
}

func TestAuthService_Refresh(t *testing.T) {
	secret := "test-secret-at-least-16-bytes"
	mock := newMockQuerier()
	authService := service.NewAuthService(mock, secret)
	ctx := context.Background()

	resp, refToken, err := authService.Register(ctx, dto.RegisterRequest{
		Email:    "refresh@example.com",
		Password: "password123",
		Name:     "Refresh User",
	})
	require.NoError(t, err)

	t.Run("valid refresh token", func(t *testing.T) {
		newResp, newRefToken, err := authService.Refresh(ctx, refToken)
		require.NoError(t, err)
		assert.NotEmpty(t, newResp.AccessToken)
		assert.NotEmpty(t, newRefToken)
		assert.Equal(t, resp.User.ID, newResp.User.ID)
	})

	t.Run("refresh after session invalidation fails", func(t *testing.T) {
		err := authService.InvalidateSessions(ctx, resp.User.ID)
		require.NoError(t, err)

		_, _, err = authService.Refresh(ctx, refToken)
		assert.ErrorIs(t, err, service.ErrInvalidToken)
	})
}
