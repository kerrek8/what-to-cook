package server

import (
	"context"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
	_ "github.com/kerrek8/what-to-cook/backend/docs"
	"github.com/kerrek8/what-to-cook/backend/internal/config"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/provider"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

type Server struct {
	httpServer        *http.Server
	db                *pgxpool.Pool
	expirationWorker  *service.ExpirationWorker
	recipeService     service.RecipeService
	translationWorker *service.RecipeTranslationWorker
	router            *gin.Engine
}

func NewWithQuerier(cfg *config.Config, queries store.Querier, recipeProvider provider.RecipeProvider, pushSender service.PushSender) *Server {
	gin.SetMode(cfg.Server.Mode)

	router := gin.New()
	router.Use(gin.Logger(), gin.Recovery())
	router.Use(middleware.CORS(cfg.CORS.AllowedOrigins))

	if recipeProvider == nil {
		recipeProvider = provider.NewTheMealDBClient("", 10*time.Second)
	}

	authService := service.NewAuthService(queries, cfg.Auth.JWTSecret)
	userService := service.NewUserService(queries)
	ingredientService := service.NewIngredientService(queries)
	inventoryService := service.NewInventoryService(queries)
	recipeService := service.NewRecipeService(queries, recipeProvider)
	shoppingService := service.NewShoppingService(queries)
	translationService := service.NewTranslationService()
	translationHandler := handler.NewTranslationHandler(translationService)

	if pushSender == nil {
		pushSender = service.NewDefaultPushSender(cfg.VAPID.Subject, cfg.VAPID.PublicKey, cfg.VAPID.PrivateKey, nil)
	}
	notificationService := service.NewNotificationService(queries, pushSender)
	expirationWorker := service.NewExpirationWorker(notificationService, 24*time.Hour)

	healthHandler := handler.NewHealthHandler()
	authHandler := handler.NewAuthHandler(authService, cfg.Server.Mode == "release")
	userHandler := handler.NewUserHandler(userService)
	ingredientHandler := handler.NewIngredientHandler(ingredientService)
	inventoryHandler := handler.NewInventoryHandler(inventoryService)
	recipeHandler := handler.NewRecipeHandler(recipeService)
	shoppingHandler := handler.NewShoppingHandler(shoppingService)
	notificationHandler := handler.NewNotificationHandler(notificationService).WithVAPIDKey(cfg.VAPID.PublicKey)

	router.GET("/health", healthHandler.Health)
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	v1 := router.Group("/api/v1")
	{
		v1.POST("/translations", translationHandler.Translate)

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

		recipes := v1.Group("/recipes")
		{
			recipes.GET("", recipeHandler.List)
			recipes.POST("/sync", recipeHandler.Sync)
		}

		v1.GET("/notifications/vapid-key", notificationHandler.GetVAPIDKey)

		protected := v1.Group("")
		protected.Use(middleware.Auth(cfg.Auth.JWTSecret))
		{
			users := protected.Group("/users")
			{
				users.GET("/me", userHandler.GetMe)
				users.PUT("/me/allergens", userHandler.UpdateAllergens)
				users.PUT("/me/pantry", userHandler.UpdatePantry)
				users.GET("/me/pantry", userHandler.GetPantry)
			}

			inventory := protected.Group("/inventory")
			{
				inventory.GET("", inventoryHandler.List)
				inventory.POST("", inventoryHandler.Create)
				inventory.GET("/:id", inventoryHandler.GetByID)
				inventory.PUT("/:id", inventoryHandler.Update)
				inventory.DELETE("/:id", inventoryHandler.Delete)
			}

			protectedRecipes := protected.Group("/recipes")
			{
				protectedRecipes.GET("/match", recipeHandler.Match)
				protectedRecipes.POST("/:id/favorite", recipeHandler.AddFavorite)
				protectedRecipes.DELETE("/:id/favorite", recipeHandler.RemoveFavorite)
			}

			shopping := protected.Group("/shopping-list")
			{
				shopping.GET("", shoppingHandler.List)
				shopping.POST("", shoppingHandler.Create)
				shopping.POST("/from-recipe/:id", shoppingHandler.AddFromRecipe)
				shopping.PATCH("/:id", shoppingHandler.Update)
				shopping.DELETE("/:id", shoppingHandler.Delete)
				shopping.POST("/transfer-to-inventory", shoppingHandler.TransferToInventory)
			}

			notifications := protected.Group("/notifications")
			{
				notifications.POST("/subscribe", notificationHandler.Subscribe)
				notifications.GET("/subscriptions", notificationHandler.ListSubscriptions)
			}
		}

		v1.GET("/recipes/:id", recipeHandler.GetByID)
	}

	httpServer := &http.Server{
		Addr:         ":" + cfg.Server.Port,
		Handler:      router,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 50 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	return &Server{
		httpServer:       httpServer,
		expirationWorker: expirationWorker,
		recipeService:    recipeService,
		translationWorker: func() *service.RecipeTranslationWorker {
			if queries == nil {
				return nil
			}
			return service.NewRecipeTranslationWorker(queries, translationService)
		}(),
		router: router,
	}
}

func New(cfg *config.Config, db *pgxpool.Pool) *Server {
	var queries store.Querier
	if db != nil {
		queries = store.New(db)
	}

	srv := NewWithQuerier(cfg, queries, nil, nil)
	srv.db = db
	return srv
}

func (s *Server) Router() *gin.Engine {
	return s.router
}

func (s *Server) Start() error {
	if s.expirationWorker != nil {
		s.expirationWorker.Start()
	}
	if s.translationWorker != nil {
		s.translationWorker.Start()
	}
	if s.recipeService != nil {
		go s.syncInitialRecipesIfEmpty()
	}
	return s.httpServer.ListenAndServe()
}

func (s *Server) syncInitialRecipesIfEmpty() {
	time.Sleep(1 * time.Second)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Minute)
	defer cancel()

	list, err := s.recipeService.List(ctx, nil, dto.RecipeQuery{Limit: 1})
	if err != nil || list.Total+list.PendingTranslations >= 120 {
		return
	}

	for _, query := range []string{"chicken", "beef", "pasta", "salad", "pork", "lamb", "fish", "seafood", "curry", "soup", "rice", "dessert", "breakfast", "vegetarian"} {
		_, _ = s.recipeService.SyncFromProvider(ctx, query)
	}
}

func (s *Server) Shutdown(ctx context.Context) error {
	if s.expirationWorker != nil {
		s.expirationWorker.Stop()
	}
	if s.translationWorker != nil {
		s.translationWorker.Stop()
	}
	if s.db != nil {
		s.db.Close()
	}
	return s.httpServer.Shutdown(ctx)
}
