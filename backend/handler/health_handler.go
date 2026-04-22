package handler

import (
	"fmt"
	"neighbor_help/contract"
	"net/http"

	"github.com/gin-gonic/gin"
)

type HealthController struct {
	HealthService contract.HealthService
}

func (h *HealthController) InitService(s *contract.Service) {
	fmt.Println("DEBUG: Initializing HealthController with HealthService")
	if s == nil {
		fmt.Println("ERROR: Provided service is nil")
		return
	}
	if s.Health == nil {
		fmt.Println("ERROR: Provided HealthService is nil")
		return
	}

	h.HealthService = s.Health
}

func (h *HealthController) GetStatus(c *gin.Context) {
	service, err := h.HealthService.GetStatus()

	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  http.StatusOK,
		"message": service,
	})
}
