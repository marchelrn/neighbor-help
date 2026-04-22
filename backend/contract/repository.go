package contract

import (
	"neighbor_help/models"
)

type Repository struct {
	HealthRepository       HealthRepository
	UsersRepository        UsersRepository
	HelpRequestRepository  HelpRequestRepository
	MessagesRepository     MessagesRepository
	NotificationRepository NotificationRepository
}

type HealthRepository interface {
	GetStatus() (string, error)
}

type UsersRepository interface {
	GetUsers() ([]*models.Users, error)
	GetUserByID(id uint) (*models.Users, error)
	GetUserByUsername(username string) (*models.Users, error)
	GetNearbyUsers(lat, lon float64, radius float64, excludeID uint) ([]*models.NearbyUser, error)
	GetUsernameByID(id uint) string
	CreateUser(user *models.Users) error
	UpdateUser(username string, payload *models.Users) error
}

type HelpRequestRepository interface {
	CreateHelpRequest(payload *models.HelpRequest) error
	GetAllHelpRequests() ([]*models.HelpRequest, error)
	GetHelpRequestByID(id uint) (*models.HelpRequest, error)
	GetHelpRequestByUserID(id uint) ([]*models.HelpRequest, error)
	GetNearbyHelpRequests(lat, lon float64, excludeUserID uint, radiusMeters float64) ([]*models.NearbyHelpRequest, error)
	UpdateHelpRequest(payload *models.HelpRequest) error
}

type MessagesRepository interface {
	GetMessagesByHelpRequestID(helpRequestID uint) ([]*models.Messages, error)
	CreateMessage(payload *models.Messages) error
	SaveMessage(payload *models.Messages) error
}

type NotificationRepository interface {
	// GetNotificationsByUserID(userID uint) ([]*models.Notifications, error)
	CreateNotification(payload *models.Notifications) error
	// UpdateNotification(payload *models.Notifications) error
}
