package models

import "time"

type Category string

const (
	Urgent Category = "urgent"
	Normal Category = "normal"
)

type Status string

const (
	Pending  Status = "pending"
	Resolved Status = "resolved"
)

type HelpRequest struct {
	ID          int      `gorm:"primaryKey;autoIncrement"`
	UserID      int      `gorm:"not null"`
	Title       string   `gorm:"type:varchar(255);not null"`
	Description string   `gorm:"type:varchar(255);not null"`
	Category    Category `gorm:"type:varchar(255);not null;default:'normal'"`
	Status      Status   `gorm:"type:varchar(255);not null;default:'pending'"`
	CreatedAt   time.Time
}

func (HelpRequest) TableName() string {
	return "help_requests"
}
