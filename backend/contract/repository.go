package contract

import (
	"neighbor_help/models"
)

type Repository struct {
	HealthRepository HealthRepository
	UsersRepository  UsersRepository
}

type HealthRepository interface {
	GetStatus() (string, error)
}

type UsersRepository interface {
	GetUsers() ([]*models.Users, error)
	GetUserByID(id uint) (*models.Users, error)
	GetUserByUsername(username string) (*models.Users, error)
	CreateUser(user *models.Users) error
	UpdateUser(username string, payload *models.Users) error
}
