package token

import (
	"errors"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var ErrInvalidToken = errors.New("invalid or expired token")

type Claims struct {
	UserID       string `json:"user_id"`
	TokenVersion int32  `json:"token_version"`
	jwt.RegisteredClaims
}

func GenerateAccessToken(userID string, tokenVersion int32, secret string, ttl time.Duration) (string, error) {
	return generate(userID, tokenVersion, secret, ttl, "access")
}

func GenerateRefreshToken(userID string, tokenVersion int32, secret string, ttl time.Duration) (string, error) {
	return generate(userID, tokenVersion, secret, ttl, "refresh")
}

func generate(userID string, tokenVersion int32, secret string, ttl time.Duration, subject string) (string, error) {
	now := time.Now().UTC()
	claims := Claims{
		UserID:       userID,
		TokenVersion: tokenVersion,
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   subject,
			ExpiresAt: jwt.NewNumericDate(now.Add(ttl)),
			IssuedAt:  jwt.NewNumericDate(now),
		},
	}

	t := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, err := t.SignedString([]byte(secret))
	if err != nil {
		return "", fmt.Errorf("sign token: %w", err)
	}

	return signed, nil
}

func ParseToken(tokenString, secret string) (*Claims, error) {
	parsed, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}
		return []byte(secret), nil
	})

	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidToken, err)
	}

	claims, ok := parsed.Claims.(*Claims)
	if !ok || !parsed.Valid {
		return nil, ErrInvalidToken
	}

	return claims, nil
}
