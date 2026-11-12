package service

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/pkg/password"
	"github.com/kerrek8/what-to-cook/backend/internal/pkg/token"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var (
	ErrUserAlreadyExists  = errors.New("user with this email already exists")
	ErrInvalidCredentials = errors.New("invalid email or password")
	ErrUserNotFound       = errors.New("user not found")
	ErrInvalidToken       = errors.New("invalid refresh token")
)

type AuthService struct {
	queries   store.Querier
	jwtSecret string
}

func NewAuthService(queries store.Querier, jwtSecret string) *AuthService {
	return &AuthService{
		queries:   queries,
		jwtSecret: jwtSecret,
	}
}

func (s *AuthService) Register(ctx context.Context, req dto.RegisterRequest) (*dto.AuthResponse, string, error) {
	_, err := s.queries.GetUserByEmail(ctx, req.Email)
	if err == nil {
		return nil, "", ErrUserAlreadyExists
	}
	if !errors.Is(err, pgx.ErrNoRows) {
		return nil, "", fmt.Errorf("check email: %w", err)
	}

	hashedPassword, err := password.Hash(req.Password)
	if err != nil {
		return nil, "", fmt.Errorf("hash password: %w", err)
	}

	user, err := s.queries.CreateUser(ctx, store.CreateUserParams{
		Email:        req.Email,
		PasswordHash: hashedPassword,
		Name:         req.Name,
	})
	if err != nil {
		return nil, "", fmt.Errorf("create user: %w", err)
	}

	userIDStr := uuid.UUID(user.ID.Bytes).String()
	accessToken, err := token.GenerateAccessToken(userIDStr, user.TokenVersion, s.jwtSecret, 15*time.Minute)
	if err != nil {
		return nil, "", fmt.Errorf("generate access token: %w", err)
	}

	refreshToken, err := token.GenerateRefreshToken(userIDStr, user.TokenVersion, s.jwtSecret, 30*24*time.Hour)
	if err != nil {
		return nil, "", fmt.Errorf("generate refresh token: %w", err)
	}

	return &dto.AuthResponse{
		AccessToken: accessToken,
		User:        MapUserToDTO(user),
	}, refreshToken, nil
}

func (s *AuthService) Login(ctx context.Context, req dto.LoginRequest) (*dto.AuthResponse, string, error) {
	user, err := s.queries.GetUserByEmail(ctx, req.Email)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, "", ErrInvalidCredentials
		}
		return nil, "", fmt.Errorf("get user: %w", err)
	}

	if err := password.Compare(user.PasswordHash, req.Password); err != nil {
		return nil, "", ErrInvalidCredentials
	}

	userIDStr := uuid.UUID(user.ID.Bytes).String()
	accessToken, err := token.GenerateAccessToken(userIDStr, user.TokenVersion, s.jwtSecret, 15*time.Minute)
	if err != nil {
		return nil, "", fmt.Errorf("generate access token: %w", err)
	}

	refreshToken, err := token.GenerateRefreshToken(userIDStr, user.TokenVersion, s.jwtSecret, 30*24*time.Hour)
	if err != nil {
		return nil, "", fmt.Errorf("generate refresh token: %w", err)
	}

	return &dto.AuthResponse{
		AccessToken: accessToken,
		User:        MapUserToDTO(user),
	}, refreshToken, nil
}

func (s *AuthService) Refresh(ctx context.Context, refreshTokenString string) (*dto.AuthResponse, string, error) {
	claims, err := token.ParseToken(refreshTokenString, s.jwtSecret)
	if err != nil || claims.Subject != "refresh" {
		return nil, "", ErrInvalidToken
	}

	parsedUUID, err := uuid.Parse(claims.UserID)
	if err != nil {
		return nil, "", ErrInvalidToken
	}

	user, err := s.queries.GetUserByID(ctx, pgtype.UUID{Bytes: parsedUUID, Valid: true})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, "", ErrUserNotFound
		}
		return nil, "", fmt.Errorf("get user by id: %w", err)
	}

	if user.TokenVersion != claims.TokenVersion {
		return nil, "", ErrInvalidToken
	}

	newAccessToken, err := token.GenerateAccessToken(claims.UserID, user.TokenVersion, s.jwtSecret, 15*time.Minute)
	if err != nil {
		return nil, "", fmt.Errorf("generate access token: %w", err)
	}

	newRefreshToken, err := token.GenerateRefreshToken(claims.UserID, user.TokenVersion, s.jwtSecret, 30*24*time.Hour)
	if err != nil {
		return nil, "", fmt.Errorf("generate refresh token: %w", err)
	}

	return &dto.AuthResponse{
		AccessToken: newAccessToken,
		User:        MapUserToDTO(user),
	}, newRefreshToken, nil
}

func (s *AuthService) InvalidateSessions(ctx context.Context, userIDStr string) error {
	parsedUUID, err := uuid.Parse(userIDStr)
	if err != nil {
		return ErrInvalidToken
	}
	return s.queries.UpdateUserTokenVersion(ctx, pgtype.UUID{Bytes: parsedUUID, Valid: true})
}

func MapUserToDTO(u store.User) dto.UserResponse {
	var avatarURL *string
	if u.AvatarUrl.Valid && u.AvatarUrl.String != "" {
		avatarURL = &u.AvatarUrl.String
	}
	return dto.UserResponse{
		ID:                    uuid.UUID(u.ID.Bytes).String(),
		Email:                 u.Email,
		Name:                  u.Name,
		AvatarURL:             avatarURL,
		ExcludedIngredientIDs: u.ExcludedIngredientIds,
		PantryIngredientIDs:   u.PantryIngredientIds,
		CreatedAt:             u.CreatedAt.Time.Format(time.RFC3339),
	}
}
