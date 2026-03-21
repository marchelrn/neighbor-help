package contract

import (
	"neighbor_help/dto"
)

type Service struct {
	Health      HealthService
	User        UsersService
	HelpRequest HelpRequestService
	Chat        ChatService
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
	CreateHelpRequest(userID uint, payload *dto.HelpRequest) (*dto.HelpRequestResponse, error)
	GetAllHelpRequests() (*dto.HelpRequestResponse, error)
	GetNearbyHelpRequests(username string) (*dto.NearbyHelpRequestResponse, error)
	GetHelpRequestByID(helpRequestID uint) (*dto.HelpRequestResponse, error)
	GetHelpRequestByUserID(userID uint) (*dto.HelpRequestResponse, error)
	UpdateHelpRequest(userID uint, helpRequestID uint, payload *dto.UpdateHelpRequest) (*dto.HelpRequestResponse, error)
}

type ChatService interface {
	GetMessages(requestID uint) (*dto.MessageResponse, error)
	SaveMessage(payload *dto.CreateMessageRequest) (*dto.SavedMessage, error)
	ValidateChatAccess(userID uint, requestID uint) (*dto.ChatAccessResult, error)
}
