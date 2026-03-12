package handler

import (
	"neighbor_help/contract"
	"net/http"

	"github.com/gin-gonic/gin"
)

type HealthHandler struct {
	service contract.HealthService
}

func NewHealthHandler(svc contract.HealthService) *HealthHandler {
	return &HealthHandler{
		service: svc,
	}
}

func (h *HealthHandler) GetStatus(c *gin.Context) {
	service := h.service.GetStatus()

	c.JSON(http.StatusOK, gin.H{
		"status":  http.StatusOK,
		"message": service,
	})
}
