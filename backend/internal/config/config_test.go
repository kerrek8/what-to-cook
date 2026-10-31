package config_test

import (
	"testing"

	"github.com/kerrek8/what-to-cook/backend/internal/config"
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
					Mode: "production", // must be release/debug/test
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
