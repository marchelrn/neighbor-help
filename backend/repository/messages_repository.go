package repository

import (
	"neighbor_help/contract"
	"neighbor_help/models"

	"gorm.io/gorm"
)

func ImplMessagesRepository(db *gorm.DB) contract.MessagesRepository {
	return &messagesRepository{db: db}
}

type messagesRepository struct {
	db *gorm.DB
}

func (r *messagesRepository) GetMessagesByHelpRequestID(helpRequestID uint) ([]*models.Messages, error) {
	var messages []*models.Messages
	if err := r.db.Where("request_id = ?", helpRequestID).Order("sent_at ASC").Find(&messages).Error; err != nil {
		return nil, err
	}
	return messages, nil
}

func (r *messagesRepository) CreateMessage(payload *models.Messages) error {
	if err := r.db.Create(payload).Error; err != nil {
		return err
	}
	return nil
}

func (r *messagesRepository) SaveMessage(payload *models.Messages) error {
	if err := r.db.Save(payload).Error; err != nil {
		return err
	}
	return nil
}
