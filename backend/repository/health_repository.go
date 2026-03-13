package repository

import (
	"fmt"

	"gorm.io/gorm"
)

type HealthRepository struct {
	db *gorm.DB
}

func ImplHealthRepository(db *gorm.DB) *HealthRepository {
	return &HealthRepository{db: db}
}

func (r *HealthRepository) GetStatus() (string, error) {
	message := "API is healthy"
	err := "Error API is not healthy"

	if message == "" {
		message = err
		return "", fmt.Errorf(message)
	}
	return message, nil
}
