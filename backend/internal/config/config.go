package config

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// ServerConfig contains HTTP server configuration parameters.
type ServerConfig struct {
	Port string
	Mode string
}

// DatabaseConfig contains PostgreSQL database connection parameters.
type DatabaseConfig struct {
	URL string
}

// AuthConfig contains authentication and security token settings.
type AuthConfig struct {
	JWTSecret string
}

// CORSConfig contains Cross-Origin Resource Sharing settings.
type CORSConfig struct {
	AllowedOrigins []string
}

// VAPIDConfig contains Web Push VAPID keys and subject.
type VAPIDConfig struct {
	PublicKey  string
	PrivateKey string
	Subject    string
}

// Config aggregates all application configuration sections.
type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
	Auth     AuthConfig
	CORS     CORSConfig
	VAPID    VAPIDConfig
}

// Load reads configuration from environment variables and performs strict validation.
// If any required parameter is missing or invalid, an error is returned to prevent startup.
func Load() (*Config, error) {
	cfg := &Config{
		Server: ServerConfig{
			Port: getEnv("PORT", "8080"),
			Mode: getEnv("GIN_MODE", "debug"),
		},
		Database: DatabaseConfig{
			URL: getEnv("DATABASE_URL", ""),
		},
		Auth: AuthConfig{
			JWTSecret: getEnv("JWT_SECRET", ""),
		},
		CORS: CORSConfig{
			AllowedOrigins: parseCommaSeparated(getEnv("CORS_ALLOWED_ORIGINS", "http://localhost:5173,http://localhost:3000")),
		},
		VAPID: VAPIDConfig{
			PublicKey:  getEnv("VAPID_PUBLIC_KEY", ""),
			PrivateKey: getEnv("VAPID_PRIVATE_KEY", ""),
			Subject:    getEnv("VAPID_SUBJECT", "mailto:admin@whatcook.app"),
		},
	}

	if err := cfg.Validate(); err != nil {
		return nil, fmt.Errorf("configuration validation failed: %w", err)
	}

	return cfg, nil
}

// Validate checks all mandatory configuration parameters for correctness.
func (c *Config) Validate() error {
	var errs []string

	// Server validation
	if c.Server.Port == "" {
		errs = append(errs, "server port cannot be empty")
	} else {
		portNum, err := strconv.Atoi(c.Server.Port)
		if err != nil || portNum < 1 || portNum > 65535 {
			errs = append(errs, fmt.Sprintf("invalid server port %q, must be between 1 and 65535", c.Server.Port))
		}
	}

	validModes := map[string]bool{"debug": true, "release": true, "test": true}
	if !validModes[c.Server.Mode] {
		errs = append(errs, fmt.Sprintf("invalid GIN_MODE %q, allowed values: debug, release, test", c.Server.Mode))
	}

	// Database validation
	if strings.TrimSpace(c.Database.URL) == "" {
		errs = append(errs, "DATABASE_URL is required and cannot be empty")
	}

	// Auth validation
	if strings.TrimSpace(c.Auth.JWTSecret) == "" {
		errs = append(errs, "JWT_SECRET is required and cannot be empty")
	} else if len(c.Auth.JWTSecret) < 16 {
		errs = append(errs, "JWT_SECRET must be at least 16 characters long for security")
	}

	if len(errs) > 0 {
		return errors.New(strings.Join(errs, "; "))
	}

	return nil
}

func getEnv(key, defaultValue string) string {
	val, ok := os.LookupEnv(key)
	if !ok || strings.TrimSpace(val) == "" {
		return defaultValue
	}
	return strings.TrimSpace(val)
}

func parseCommaSeparated(raw string) []string {
	parts := strings.Split(raw, ",")
	var result []string
	for _, p := range parts {
		trimmed := strings.TrimSpace(p)
		if trimmed != "" {
			result = append(result, trimmed)
		}
	}
	return result
}
