package routes

import (
	"neighbor_help/contract"
	"neighbor_help/handler"
	"neighbor_help/middleware"
	"neighbor_help/repository"
	"neighbor_help/service"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func HelpRequestRoutes(
	r *gin.RouterGroup,
	db *gorm.DB,
) {

	repositories := &contract.Repository{
	HelpRequestRepository: repository.NewHelpRequestRepository(db),
	}

	helpService := service.ImplHelpRequestService(
		repositories,
	)
	
	helpHandler := handler.NewHelpRequestHandler(
		helpService,
	)

	help := r.Group("/help")

	help.Use(middleware.AuthMiddleware())

	{
	help.POST(
		"",
		helpHandler.CreateHelpRequest,
	)

	help.GET(
		"",
		helpHandler.GetAllHelpRequests,
	)

	help.GET(
		"/nearby",
		helpHandler.GetNearbyHelpRequests,
	)

	help.GET(
		"/my-help",
		helpHandler.GetHelpRequestByUserID,
	)

	help.GET(
		"/:id",
		helpHandler.GetHelpRequestByID,
	)

	help.DELETE(
		"/:id",
		helpHandler.DeleteHelpRequest,
	)

	help.PUT(
	"/:id",
	helpHandler.UpdateHelpRequest,
)	
}


}