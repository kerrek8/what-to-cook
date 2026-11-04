package config_test

import (
	"os"
	"testing"

	"github.com/kerrek8/what-to-cook/backend/internal/config"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestConfig_Validate(t *testing.T) {
	tests := []struct {
		name      string
		cfg       config.Config
		wantError bool
	}{
		{
			name: "valid configuration",
			cfg: config.Config{
				Server: config.ServerConfig{
					Port: "8080",
					Mode: "debug",
				},
				Database: config.DatabaseConfig{
					URL: "postgres://user:pass@localhost:5432/db",
				},
				Auth: config.AuthConfig{
					JWTSecret: "super-secret-key-at-least-16-bytes",
				},
				CORS: config.CORSConfig{
					AllowedOrigins: []string{"http://localhost:3000"},
				},
			},
			wantError: false,
		},
		{
			name: "missing database url",
			cfg: config.Config{
				Server: config.ServerConfig{
					Port: "8080",
					Mode: "debug",
				},
				Database: config.DatabaseConfig{
					URL: "",
				},
				Auth: config.AuthConfig{
					JWTSecret: "super-secret-key-at-least-16-bytes",
				},
			},
			wantError: true,
		},
		{
			name: "short jwt secret",
			cfg: config.Config{
				Server: config.ServerConfig{
					Port: "8080",
					Mode: "debug",
				},
				Database: config.DatabaseConfig{
					URL: "postgres://user:pass@localhost:5432/db",
				},
				Auth: config.AuthConfig{
					JWTSecret: "too-short",
				},
			},
			wantError: true,
		},
		{
			name: "invalid port number",
			cfg: config.Config{
				Server: config.ServerConfig{
					Port: "invalid-port",
					Mode: "debug",
				},
				Database: config.DatabaseConfig{
					URL: "postgres://user:pass@localhost:5432/db",
				},
				Auth: config.AuthConfig{
					JWTSecret: "super-secret-key-at-least-16-bytes",
				},
			},
			wantError: true,
		},
		{
			name: "invalid gin mode",
			cfg: config.Config{
				Server: config.ServerConfig{
					Port: "8080",
					Mode: "production",
				},
				Database: config.DatabaseConfig{
					URL: "postgres://user:pass@localhost:5432/db",
				},
				Auth: config.AuthConfig{
					JWTSecret: "super-secret-key-at-least-16-bytes",
				},
			},
			wantError: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := tt.cfg.Validate()
			if (err != nil) != tt.wantError {
				t.Errorf("Validate() error = %v, wantError %v", err, tt.wantError)
			}
		})
	}
}

func TestConfig_LoadWithGigaChat(t *testing.T) {
	_ = os.Setenv("BACKEND_PORT", "8085")
	_ = os.Setenv("GIN_MODE", "debug")
	_ = os.Setenv("DATABASE_URL", "postgres://user:pass@localhost:5432/db")
	_ = os.Setenv("JWT_SECRET", "super-secret-key-at-least-16-bytes")
	_ = os.Setenv("GIGACHAT_AUTH_KEY", "test-gigachat-auth-key")
	_ = os.Setenv("GIGACHAT_SCOPE", "GIGACHAT_API_CORP")
	_ = os.Setenv("GIGACHAT_MODEL", "GigaChat-Pro")
	_ = os.Setenv("GIGACHAT_VERIFY_SSL", "false")
	defer func() {
		_ = os.Unsetenv("BACKEND_PORT")
		_ = os.Unsetenv("GIN_MODE")
		_ = os.Unsetenv("DATABASE_URL")
		_ = os.Unsetenv("JWT_SECRET")
		_ = os.Unsetenv("GIGACHAT_AUTH_KEY")
		_ = os.Unsetenv("GIGACHAT_SCOPE")
		_ = os.Unsetenv("GIGACHAT_MODEL")
		_ = os.Unsetenv("GIGACHAT_VERIFY_SSL")
	}()

	cfg, err := config.Load()
	require.NoError(t, err)
	assert.Equal(t, "8085", cfg.Server.Port)
	assert.Equal(t, "test-gigachat-auth-key", cfg.GigaChat.AuthKey)
	assert.Equal(t, "GIGACHAT_API_CORP", cfg.GigaChat.Scope)
	assert.Equal(t, "GigaChat-Pro", cfg.GigaChat.Model)
	assert.False(t, cfg.GigaChat.VerifySSL)
}
