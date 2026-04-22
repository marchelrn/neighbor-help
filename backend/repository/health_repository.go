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
	const message = "API is healthy"
	const err = "Error API is not healthy"

	if message == "" {
		return "", fmt.Errorf(err)
	}
	return message, nil
}
