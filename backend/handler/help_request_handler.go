package handler

import (
	"fmt"
	"neighbor_help/contract"
	"neighbor_help/dto"
	errs "neighbor_help/pkg/error"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type HelpRequestController struct {
	HelpRequestService contract.HelpRequestService
}

func (c *HelpRequestController) InitService(s *contract.Service) {
	fmt.Println("DEBUG: Initializing HelpRequestController with HelpRequestService")
	if s == nil {
		fmt.Println("ERROR: Service is nil")
		return
	}

	if s.User == nil {
		fmt.Println("ERROR: UserService is nil")
		return
	}
	c.HelpRequestService = s.HelpRequest

	fmt.Println("DEBUG: HelpRequestController initialized successfully with HelpRequestService")
}

func (h *HelpRequestController) CreateHelpRequest(c *gin.Context) {
	userIDGet, exists := c.Get("UserID")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}
	var helpRequest dto.HelpRequest
	if err := c.ShouldBindJSON(&helpRequest); err != nil {
		HandleError(c, err)
		return
	}
	response, err := h.HelpRequestService.CreateHelpRequest(userIDGet.(uint), &helpRequest)
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(response.Status, gin.H{
		"status":  response.Status,
		"message": response.Message,
	})
}

func (h *HelpRequestController) UpdateHelpRequest(c *gin.Context) {
	userID, exists := c.Get("UserID")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}

	helpRequestIDParam := c.Param("id")
	helpRequestID, err := strconv.Atoi(helpRequestIDParam)
	if err != nil || helpRequestID <= 0 {
		HandleError(c, errs.BadRequest("Invalid help request ID"))
		return
	}

	var payload dto.UpdateHelpRequest
	if err := c.ShouldBindJSON(&payload); err != nil {
		HandleError(c, errs.BadRequest("Invalid Request Body"))
		return
	}

	response, err := h.HelpRequestService.UpdateHelpRequest(
		userID.(uint),
		uint(helpRequestID),
		&payload,
	)
	if err != nil {
		HandleError(c, err)
		return
	}
	c.JSON(response.Status, gin.H{
		"status":        response.Status,
		"message":       response.Message,
		"help_requests": response.HelpRequests,
	})
}

func (h *HelpRequestController) GetNearbyHelpRequests(c *gin.Context) {
	username, exists := c.Get("Username")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}

	response, err := h.HelpRequestService.GetNearbyHelpRequests(username.(string))
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":       response.Message,
		"help_requests": response.HelpRequests,
	})
}

func (h *HelpRequestController) GetAllHelpRequests(c *gin.Context) {
	response, err := h.HelpRequestService.GetAllHelpRequests()
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusAccepted, gin.H{
		"status":        response.Status,
		"message":       response.Message,
		"help_requests": response.HelpRequests,
	})
}

func (h *HelpRequestController) GetHelpRequestByUserID(c *gin.Context) {
	userID, exists := c.Get("UserID")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}

	response, err := h.HelpRequestService.GetHelpRequestByUserID(userID.(uint))
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":        response.Status,
		"message":       response.Message,
		"help_requests": response.HelpRequests,
	})
}
