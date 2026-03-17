package repository

import (
	"neighbor_help/contract"

	"gorm.io/gorm"
)

func New(db *gorm.DB) *contract.Repository {
	return &contract.Repository{
		HealthRepository:      ImplHealthRepository(db),
		UsersRepository:       ImplUsersRepository(db),
		HelpRequestRepository: ImplHelpRequestRepository(db),
	}
}
