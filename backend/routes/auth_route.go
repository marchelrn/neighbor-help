package routes

import (
	"neighbor_help/handler"
	"neighbor_help/middleware"
	"neighbor_help/repository"
	"neighbor_help/service"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func AuthRoutes(
	r *gin.RouterGroup,
	db *gorm.DB,
) {

	repo := repository.NewAuthRepository(db)

	service := service.NewAuthService(repo)

	handler := handler.NewAuthHandler(service)

	// =========================
	// AUTH
	// =========================

	auth := r.Group("/auth")

	{
		auth.POST("/register", handler.Register)
		auth.POST("/login", handler.Login)
	}

	// =========================
	// USER
	// =========================

	user := r.Group("/user")

	user.Use(middleware.AuthMiddleware())

	{
		user.GET("/me", handler.GetCurrentUser)
	}
}