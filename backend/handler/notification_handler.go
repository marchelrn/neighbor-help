package handler

import (
	"fmt"
	"neighbor_help/contract"
	errs "neighbor_help/pkg/error"
	"net/http"

	"github.com/gin-gonic/gin"
)

type NotificationController struct {
	NotificationService contract.NotificationService
}

func (c *NotificationController) InitService(s *contract.Service) {
	fmt.Println("DEBUG: Initializing NotificationController")
	if s == nil {
		fmt.Println("ERROR: Service is nil")
		return
	}
	if s.Notification == nil {
		fmt.Println("ERROR: NotificationService is nil")
		return
	}
	c.NotificationService = s.Notification
	fmt.Println("DEBUG: NotificationController initialized successfully")
}

func (n *NotificationController) GetNotifications(c *gin.Context) {
	userID, exists := c.Get("UserID")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}

	response, err := n.NotificationService.GetNotificationsByUserID(userID.(uint))
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":        response.Status,
		"message":       response.Message,
		"notifications": response.Notifications,
	})
}

func (n *NotificationController) GetUnreadCount(c *gin.Context) {
	userID, exists := c.Get("UserID")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}

	response, err := n.NotificationService.GetUnreadCountByUserID(userID.(uint))
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  response.Status,
		"message": response.Message,
		"count":   response.Count,
	})
}

func (n *NotificationController) MarkAsRead(c *gin.Context) {
	userID, exists := c.Get("UserID")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}

	response, err := n.NotificationService.MarkAsReadByUserID(userID.(uint))
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  response.Status,
		"message": response.Message,
	})
}
