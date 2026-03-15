package contract

import (
	"neighbor_help/dto"
)

type Service struct {
	Health HealthService
	User   UsersService
}

type HealthService interface {
	GetStatus() (string, error)
}

type UsersService interface {
	GetUsers() (*dto.AllUsersResponse, error)
	GetUserByID(id uint) (*dto.UsersResponse, error)
	Register(payload *dto.UsersRequest) (*dto.UsersResponse, error)
	Login(payload *dto.LoginRequest) (*dto.LoginResponse, error)
	UpdateUser(username string, payload *dto.UsersRequest) (*dto.UsersResponse, error)
}
