package handler

import (
	"net/http"

	"neighbor_help/dto"
	"neighbor_help/service"

	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	Service *service.AuthService
}

func NewAuthHandler(
	service *service.AuthService,
) *AuthHandler {

	return &AuthHandler{
		Service: service,
	}
}

// =========================
// REGISTER
// =========================

func (h *AuthHandler) Register(
	c *gin.Context,
) {

	var req dto.RegisterRequest

	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})

		return
	}

	token, err := h.Service.Register(req)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Register success",
		"token":  token,
	})
}

// =========================
// LOGIN
// =========================

func (h *AuthHandler) Login(
	c *gin.Context,
) {

	var req dto.LoginRequest

	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})

		return
	}

	token, err := h.Service.Login(req)

	if err != nil {

		c.JSON(http.StatusUnauthorized, gin.H{
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Login success",
		"token":  token,
	})
}

// =========================
// GET CURRENT USER
// =========================

func (h *AuthHandler) GetCurrentUser(
	c *gin.Context,
) {

	// IMPORTANT FIX
	userID := c.GetUint("user_id")

	user, err := h.Service.GetCurrentUser(
		userID,
	)

	if err != nil {

		c.JSON(http.StatusNotFound, gin.H{
			"message": "User not found",
		})

		return
	}

	c.JSON(http.StatusOK, user)
}