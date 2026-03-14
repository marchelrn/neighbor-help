package routes

import (
	"time"

	"neighbor_help/config"
	"neighbor_help/contract"
	"neighbor_help/handler"

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

	var limitter int64
	if cfg.IsProd == false {
		limitter = 1000
	} else {
		limitter = 100
	}

	rate := limiter.Rate{
		Period: 1 * time.Minute,
		Limit:  limitter,
	}

	store := memory.NewStore()
	instance := limiter.New(store, rate)
	rateLimitter := mgin.NewMiddleware(instance)
	r.Use(rateLimitter)

	defaultConfig := cors.DefaultConfig()
	defaultConfig.AllowAllOrigins = true
	// defaultConfig.AllowOrigins = []string{"http://localhost:3000", "http://localhost:5500"}
	defaultConfig.AllowMethods = []string{"GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"}
	defaultConfig.AllowHeaders = []string{"Origin", "Content-Length", "Content-Type", "Authorization", "Accept", "X-Requested-With"}
	defaultConfig.AllowCredentials = true
	defaultConfig.ExposeHeaders = []string{"Content-Length"}
	r.Use(cors.New(defaultConfig))

	healthController := &handler.HealthController{}
	healthController.InitService(s)

	userController := &handler.UserController{}
	userController.InitService(s)

	api := r.Group("/")
	{
		api.GET("/health", healthController.GetStatus)
		api.GET("/users", userController.GetUsers)
		api.GET("/user/:id", userController.GetUserByID)
		api.POST("/user", userController.Register)

	}
	return r
}
