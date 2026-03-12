package repository

import (
	"gorm.io/gorm"
)

type HealthRepository struct {
	db *gorm.DB
}

func ImplHealthRepository(db *gorm.DB) *HealthRepository {
	return &HealthRepository{db: db}
}

func (r *HealthRepository) GetStatus() string {
	message := "API is healthy"
	return message
}
