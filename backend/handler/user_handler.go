package handler

import (
	"fmt"
	"neighbor_help/contract"
	"neighbor_help/dto"
	errs "neighbor_help/pkg/error"
	"net/http"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	UserService contract.UsersService
}

func (c *UserController) InitService(s *contract.Service) {
	fmt.Println("DEBUG: Initializing UserController with UserService")
	if s == nil {
		fmt.Println("ERROR: Service is nil")
		return
	}

	if s.User == nil {
		fmt.Println("ERROR: UserService is nil")
		return
	}
	c.UserService = s.User
	fmt.Println("DEBUG: UserController initialized successfully with UserService")
}

func (u *UserController) Register(c *gin.Context) {
	var payload dto.UsersRequest
	if err := c.ShouldBindJSON(&payload); err != nil {
		HandleError(c, errs.BadRequest("Invalid Request Body"))
		return
	}

	response, err := u.UserService.Register(&payload)
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(response.Status, gin.H{
		"message": response.Message,
	})
}

func (u *UserController) Login(c *gin.Context) {
	var payload dto.LoginRequest
	if err := c.ShouldBindJSON(&payload); err != nil {
		HandleError(c, errs.BadRequest("Invalid Request Body"))
		return
	}

	response, err := u.UserService.Login(&payload)
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(response.Status, gin.H{
		"message":  response.Message,
		"username": response.Data,
	})
}

func (u *UserController) UpdateUser(c *gin.Context) {
	usernameParam := c.Param("username")
	if usernameParam == "" {
		HandleError(c, errs.BadRequest("Invalid username"))
		return
	}

	var payload dto.UsersRequest
	if err := c.ShouldBindJSON(&payload); err != nil {
		HandleError(c, errs.BadRequest("Invalid Request Body"))
		return
	}

	response, err := u.UserService.UpdateUser(usernameParam, &payload)
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(response.Status, gin.H{
		"message": response.Message,
		"resp":    response.Data,
	})
}

func (u *UserController) GetUsers(c *gin.Context) {
	users, err := u.UserService.GetUsers()
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Users retrieved successfully",
		"data":    users,
	})
}

func (u *UserController) GetUserByID(c *gin.Context) {
	userIdParam := c.Param("id")
	var userId uint
	_, err := fmt.Sscanf(userIdParam, "%d", &userId)
	if err != nil || userId <= 0 {
		HandleError(c, errs.BadRequest("Invalid User ID"))
		return
	}
	response, err := u.UserService.GetUserByID(userId)
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, response)
}
