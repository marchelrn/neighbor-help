package middleware

import (
	errs "neighbor_help/pkg/error"
	"neighbor_help/pkg/token"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

func isAdmin() gin.HandlerFunc {
	return func(c *gin.Context) {
		if c.GetString("Role") != "admin" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"message": "Unauthorized",
			})
			c.Abort()
			return
		}
		c.Next()
	}
}

func AuthMiddleware(isAdmin bool) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"message": "Authorization header not found",
			})
			c.Abort()
			return
		}
		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"message": "Invalid authorization header format",
			})
			c.Abort()
			return
		}

		claims, err := token.ValidateToken(parts[1])
		if err != nil {
			c.JSON(errs.GetStatusCode(errs.Unauthorized("Invalid or expired token")), gin.H{
				"message": "Invalid or expired token",
			})
			c.Abort()
			return
		}

		if isAdmin && strings.ToLower(claims.Role) != "admin" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"message": "Unauthorized: admin access required (your role is '" + claims.Role + "')",
			})
			c.Abort()
			return
		}

		c.Set("UserID", claims.UserID)
		c.Set("Username", claims.Username)
		c.Set("Role", claims.Role)
		c.Next()
	}
}
