package utils

import "github.com/gin-gonic/gin"

func GetUserID(c *gin.Context) uint {

	userID, exists := c.Get("user_id")

	if !exists {
		return 0
	}

	return userID.(uint)
}

func GetUsername(c *gin.Context) string {

	username, exists := c.Get("username")

	if !exists {
		return ""
	}

	return username.(string)
}