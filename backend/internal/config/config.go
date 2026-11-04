package config

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type ServerConfig struct {
	Port string
	Mode string
}

type DatabaseConfig struct {
	URL string
}

type AuthConfig struct {
	JWTSecret string
}

type CORSConfig struct {
	AllowedOrigins []string
}

type VAPIDConfig struct {
	PublicKey  string
	PrivateKey string
	Subject    string
}

type GigaChatConfig struct {
	AuthKey   string
	Scope     string
	Model     string
	VerifySSL bool
}

type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
	Auth     AuthConfig
	CORS     CORSConfig
	VAPID    VAPIDConfig
	GigaChat GigaChatConfig
}

func Load() (*Config, error) {
	cfg := &Config{
		Server: ServerConfig{
			Port: getEnvWithFallback("PORT", "BACKEND_PORT", "8080"),
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
		GigaChat: GigaChatConfig{
			AuthKey:   getEnv("GIGACHAT_AUTH_KEY", "MDFhMWE3YjctZDY3MC03NTU3LWI1ZjctZGM1NTkxZDk0MjhhOjNjZTRkM2FjLTA0ODctNGZjOC04YWQyLWE1NmFlMjdiMDYyYQ=="),
			Scope:     getEnv("GIGACHAT_SCOPE", "GIGACHAT_API_PERS"),
			Model:     getEnv("GIGACHAT_MODEL", "GigaChat"),
			VerifySSL: getEnvBool("GIGACHAT_VERIFY_SSL", false),
		},
	}

	if err := cfg.Validate(); err != nil {
		return nil, fmt.Errorf("configuration validation failed: %w", err)
	}

	return cfg, nil
}

func (c *Config) Validate() error {
	var errs []string

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

	if strings.TrimSpace(c.Database.URL) == "" {
		errs = append(errs, "DATABASE_URL is required and cannot be empty")
	}

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

func getEnvWithFallback(primaryKey, fallbackKey, defaultValue string) string {
	if val, ok := os.LookupEnv(primaryKey); ok && strings.TrimSpace(val) != "" {
		return strings.TrimSpace(val)
	}
	if val, ok := os.LookupEnv(fallbackKey); ok && strings.TrimSpace(val) != "" {
		return strings.TrimSpace(val)
	}
	return defaultValue
}

func getEnvBool(key string, defaultValue bool) bool {
	val, ok := os.LookupEnv(key)
	if !ok || strings.TrimSpace(val) == "" {
		return defaultValue
	}
	parsed, err := strconv.ParseBool(strings.TrimSpace(val))
	if err != nil {
		return defaultValue
	}
	return parsed
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
