package models

import "time"

type Messages struct {
	ID         uint      `gorm:"column:id;primaryKey;autoIncrement"`
	RequestID  uint      `gorm:"column:request_id;not null"`
	SenderID   uint      `gorm:"column:sender_id;not null"`
	ReceiverID uint      `gorm:"column:receiver_id;not null"`
	Content    string    `gorm:"column:content;type:text;not null"`
	Sent_At    time.Time `gorm:"column:sent_at"`
}

func (Messages) TableName() string {
	return "messages"
}
