package contract

import (
	"neighbor_help/dto"
)

type Service struct {
	Health      HealthService
	User        UsersService
	HelpRequest HelpRequestService
}

type HealthService interface {
	GetStatus() (string, error)
}

type UsersService interface {
	GetUsers() (*dto.AllUsersResponse, error)
	GetUserByID(id uint) (*dto.UsersResponse, error)
	GetNearbyUsers(username string) (*dto.NearbyUsersResponse, error)
	Register(payload *dto.UsersRequest) (*dto.UsersResponse, error)
	Login(payload *dto.LoginRequest) (*dto.LoginResponse, error)
	UpdateUser(username string, payload *dto.UpdateUserRequest) (*dto.UsersResponse, error)
}

type HelpRequestService interface {
	CreateHelpRequest(userID uint, helpRequest *dto.HelpRequest) (*dto.HelpRequestResponse, error)
	GetAllHelpRequests() (*dto.HelpRequestResponse, error)
	GetNearbyHelpRequests(username string) (*dto.NearbyHelpRequestResponse, error)
	UpdateHelpRequest(userID uint, helpRequestID uint, payload *dto.UpdateHelpRequest) (*dto.HelpRequestResponse, error)
}
