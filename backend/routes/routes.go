package routes

import (
	"time"

	"neighbor_help/config"
	"neighbor_help/contract"
	"neighbor_help/handler"
	"neighbor_help/middleware"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/ulule/limiter/v3"
	mgin "github.com/ulule/limiter/v3/drivers/middleware/gin"
	"github.com/ulule/limiter/v3/drivers/store/memory"
)

func SetupRoutes(s *contract.Service) *gin.Engine {

	r := gin.Default()
	r.RedirectTrailingSlash = false

	cfg := config.GetConfig()

	// =====================================
	// RATE LIMITER
	// =====================================

	var limiterCount int64

	if cfg.Env != "production" {
		limiterCount = 1000
	} else {
		limiterCount = 100
	}

	rate := limiter.Rate{
		Period: 1 * time.Minute,
		Limit:  limiterCount,
	}

	store := memory.NewStore()
	instance := limiter.New(store, rate)

	r.Use(mgin.NewMiddleware(instance))

	// =====================================
	// CORS
	// =====================================

	corsConfig := cors.DefaultConfig()

	corsConfig.AllowAllOrigins = true

	corsConfig.AllowMethods = []string{
		"GET",
		"POST",
		"PUT",
		"DELETE",
		"PATCH",
		"OPTIONS",
	}

	corsConfig.AllowHeaders = []string{
		"Origin",
		"Content-Type",
		"Authorization",
		"Accept",
		"X-Requested-With",
	}

	corsConfig.AllowCredentials = true

	r.Use(cors.New(corsConfig))

	// =====================================
	// HANDLERS
	// =====================================

	helpRequestHandler := handler.NewHelpRequestHandler(
		s.HelpRequest,
	)

	// =====================================
	// PUBLIC ROUTES
	// =====================================

	api := r.Group("/")

	{
		api.GET("/health", func(c *gin.Context) {
			c.JSON(200, gin.H{
				"status":  200,
				"message": "Server is running",
			})
		})
	}

	// =====================================
	// AUTH ROUTES
	// =====================================

	auth := r.Group("/")
	auth.Use(middleware.AuthMiddleware())

	{
		// =========================
		// HELP REQUEST
		// =========================

		auth.POST(
			"/help",
			helpRequestHandler.CreateHelpRequest,
		)

		auth.GET(
			"/help",
			helpRequestHandler.GetAllHelpRequests,
		)

		auth.GET(
			"/help/nearby",
			helpRequestHandler.GetNearbyHelpRequests,
		)
	}

	// =====================================
	// DEBUG ROUTES
	// =====================================

	for _, route := range r.Routes() {
		println(route.Method, route.Path)
	}

	return r
}