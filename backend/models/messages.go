package models

import "time"

type Messages struct {
	ID         int    `gorm:"primaryKey;autoIncrement"`
	RequestID  int    `gorm:"not null"`
	SenderID   int    `gorm:"not null"`
	ReceiverID int    `gorm:"not null"`
	Messages   string `gorm:"type:text"`
	Sent_At    time.Time
}

func (Messages) TableName() string {
	return "messages"
}
