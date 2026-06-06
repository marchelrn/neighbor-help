package contract

import (
	"neighbor_help/dto"
	"neighbor_help/models"
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
	UpdateUser(username string, usernameParam string, payload *dto.UpdateUserRequest) (*dto.UsersResponse, error)
}

type HelpRequestService interface {
	CreateHelpRequest(
		userID uint,
		payload *dto.HelpRequest,
	) (
		*dto.HelpRequestResponse,
		error,
	)

	GetAllHelpRequests() (
		[]*models.HelpRequest,
		error,
	)

	GetNearbyHelpRequests(
		lat, lon float64,
		excludeUserID uint,
		radiusMeters float64,
	) (
		[]*models.NearbyHelpRequest,
		error,
	)

	GetHelpRequestByID(
		helpRequestID uint,
	) (
		*models.HelpRequest,
		error,
	)

	GetHelpRequestByUserID(
		userID uint,
	) (
		[]*models.HelpRequest,
		error,
	)

	UpdateHelpRequest(
	userID uint,
	helpRequestID uint,
	payload *dto.UpdateHelpRequestRequest,
) error

	DeleteHelpRequest(
	userID uint,
	helpRequestID uint,
) error
}

type ChatService interface {
	GetMessages(requestID uint) (*dto.MessageResponse, error)
	SaveMessage(payload *dto.CreateMessageRequest) (*dto.SavedMessage, error)
	ValidateChatAccess(userID uint, requestID uint) (*dto.ChatAccessResult, error)
}

