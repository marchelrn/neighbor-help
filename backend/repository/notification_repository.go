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

func (r *notificationRepository) GetNotificationsByUserID(userID uint) ([]*models.Notifications, error) {
	var notifications []*models.Notifications
	if err := r.db.Joins("JOIN help_requests ON help_requests.id = notifications.help_request_id").
		Where("notifications.user_id = ? AND help_requests.user_id != ?", userID, userID).
		Order("notifications.created_at DESC").Find(&notifications).Error; err != nil {
		return nil, err
	}
	return notifications, nil
}

func (r *notificationRepository) GetUnreadCountByUserID(userID uint) (int64, error) {
	var count int64
	if err := r.db.Model(&models.Notifications{}).
		Joins("JOIN help_requests ON help_requests.id = notifications.help_request_id").
		Where("notifications.user_id = ? AND notifications.is_read = ? AND help_requests.user_id != ?", userID, false, userID).
		Count(&count).Error; err != nil {
		return 0, err
	}
	return count, nil
}

func (r *notificationRepository) MarkAsReadByUserID(userID uint) error {
	if err := r.db.Model(&models.Notifications{}).Where("user_id = ? AND is_read = ?", userID, false).Update("is_read", true).Error; err != nil {
		return err
	}
	return nil
}
