package server

import (
	"context"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/kerrek8/what-to-cook/backend/internal/config"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

type Server struct {
	httpServer *http.Server
	db         *pgxpool.Pool
}

func New(cfg *config.Config, db *pgxpool.Pool) *Server {
	gin.SetMode(cfg.Server.Mode)

	router := gin.New()
	router.Use(gin.Logger(), gin.Recovery())
	router.Use(middleware.CORS(cfg.CORS.AllowedOrigins))

	var queries store.Querier
	if db != nil {
		queries = store.New(db)
	}

	authService := service.NewAuthService(queries, cfg.Auth.JWTSecret)
	userService := service.NewUserService(queries)
	ingredientService := service.NewIngredientService(queries)

	healthHandler := handler.NewHealthHandler()
	authHandler := handler.NewAuthHandler(authService, cfg.Server.Mode == "release")
	userHandler := handler.NewUserHandler(userService)
	ingredientHandler := handler.NewIngredientHandler(ingredientService)

	router.GET("/health", healthHandler.Health)

	v1 := router.Group("/api/v1")
	{
		auth := v1.Group("/auth")
		{
			auth.POST("/register", authHandler.Register)
			auth.POST("/login", authHandler.Login)
			auth.POST("/refresh", authHandler.Refresh)
			auth.POST("/logout", authHandler.Logout)
		}

		ingredients := v1.Group("/ingredients")
		{
			ingredients.GET("", ingredientHandler.List)
			ingredients.GET("/:id", ingredientHandler.GetByID)
		}

		protected := v1.Group("")
		protected.Use(middleware.Auth(cfg.Auth.JWTSecret))
		{
			users := protected.Group("/users")
			{
				users.GET("/me", userHandler.GetMe)
				users.PUT("/me/allergens", userHandler.UpdateAllergens)
			}
		}
	}

	httpServer := &http.Server{
		Addr:         ":" + cfg.Server.Port,
		Handler:      router,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	return &Server{
		httpServer: httpServer,
		db:         db,
	}
}

func (s *Server) Start() error {
	return s.httpServer.ListenAndServe()
}

func (s *Server) Shutdown(ctx context.Context) error {
	if s.db != nil {
		s.db.Close()
	}
	return s.httpServer.Shutdown(ctx)
}
