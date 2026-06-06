package middleware

import (
	"net/http"
	"strings"

	"neighbor_help/pkg/token"

	"github.com/gin-gonic/gin"
)

func AuthMiddleware() gin.HandlerFunc {

	return func(c *gin.Context) {

		authHeader := c.GetHeader(
			"Authorization",
		)

		if authHeader == "" {

			c.AbortWithStatusJSON(
				http.StatusUnauthorized,
				gin.H{
					"message": "Authorization header required",
				},
			)

			return
		}

		parts := strings.SplitN(
			authHeader,
			" ",
			2,
		)

		if len(parts) != 2 {

			c.AbortWithStatusJSON(
				http.StatusUnauthorized,
				gin.H{
					"message": "Invalid authorization format",
				},
			)

			return
		}

		if strings.ToLower(parts[0]) != "bearer" {

			c.AbortWithStatusJSON(
				http.StatusUnauthorized,
				gin.H{
					"message": "Authorization type must be Bearer",
				},
			)

			return
		}

		claims, err := token.ValidateToken(
			parts[1],
		)

		if err != nil {

			c.AbortWithStatusJSON(
				http.StatusUnauthorized,
				gin.H{
					"message": "Invalid or expired token",
				},
			)

			return
		}

		c.Set("user_id", claims.UserID)
		c.Set("username", claims.Username)

		c.Next()
	}
}