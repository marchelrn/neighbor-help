package models

import (
	"time"
)

type Notifications struct {
	ID            uint      `gorm:"primaryKey;autoIncrement"`
	HelpRequestID *uint     `gorm:"not null"`
	UserID        *uint     `gorm:"not null"`
	Title         string    `gorm:"type:text;not null"`
	Username      string    `gorm:"type:varchar(255);not null"`
	Read          bool      `gorm:"default:false"`
	Created_at    time.Time `gorm:"autoCreateTime"`
}

func (Notifications) TableName() string {
	return "notifications"
}
