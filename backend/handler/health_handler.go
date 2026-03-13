package handler

import (
	"fmt"
	"neighbor_help/contract"
	"net/http"

	"github.com/gin-gonic/gin"
)

type HealthController struct {
	service contract.HealthService
}

func (s *HealthController) InitService(svc *contract.Service) {
	fmt.Println("DEBUG: Initializing StocksController with StocksService")
	if svc == nil {
		fmt.Println("ERROR: Provided service is nil")
		return
	}
	s.service = svc.Health
}

func (h *HealthController) GetStatus(c *gin.Context) {
	service, err := h.service.GetStatus()

	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  http.StatusOK,
		"message": service,
	})
}
