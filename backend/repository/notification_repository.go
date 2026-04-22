package repository

import (
	"neighbor_help/contract"
	"neighbor_help/models"

	"gorm.io/gorm"
)

func ImplNotificationRepository(db *gorm.DB) contract.NotificationRepository {
	return &notificationRepository{db: db}
}

type notificationRepository struct {
	db *gorm.DB
}

func (r *notificationRepository) CreateNotification(payload *models.Notifications) error {
	if err := r.db.Create(payload).Error; err != nil {
		return err
	}
	return nil
}
