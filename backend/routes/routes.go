package routes

import (
	"time"

	"neighbor_help/config"
	"neighbor_help/contract"
	"neighbor_help/handler"
	"neighbor_help/middleware"
	"neighbor_help/pkg/hub"

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

	helpRequestController := &handler.HelpRequestController{}
	helpRequestController.InitService(s)

	chatController := &handler.ChatController{}
	chatController.Hub = hub.NewHub()
	chatController.InitService(s)

	api := r.Group("/")
	{
		api.GET("/health", healthController.GetStatus)
		api.POST("/register", userController.Register)
		api.POST("/login", userController.Login)
		api.GET("/ws/help/:id/chat", chatController.JoinChat)
	}

	auth := r.Group("/")
	auth.Use(middleware.AuthMiddleware())
	{
		auth.GET("/users", userController.GetUsers)
		auth.GET("/user/:id", userController.GetUserByID)
		auth.PUT("/user/:username", userController.UpdateUser)
		auth.GET("/nearby", userController.GetNearbyUsers)
		auth.POST("/help", helpRequestController.CreateHelpRequest)
		auth.GET("/help/nearby", helpRequestController.GetNearbyHelpRequests)
		auth.GET("/help", helpRequestController.GetAllHelpRequests)
		auth.PUT("/help/:id", helpRequestController.UpdateHelpRequest)
		auth.GET("/help/:id/messages", chatController.GetMessages)
	}
	return r
}
