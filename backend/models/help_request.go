package models

import "time"

type Category string

const (
	Urgent Category = "urgent"
	Normal Category = "normal"
)

type Status string

const (
	Pending Status = "pending"
	Solved  Status = "solved"
)

type HelpRequest struct {
	ID          uint     `gorm:"primaryKey;autoIncrement"`
	Username    string   `gorm:"type:varchar(25);column:username"`
	Address     string   `gorm:"column:address"`
	UserID      uint     `gorm:"not null"`
	Title       string   `gorm:"type:varchar(255);not null"`
	Description string   `gorm:"type:varchar(255);not null"`
	Category    Category `gorm:"type:varchar(255);not null;default:'normal'"`
	Status      Status   `gorm:"type:varchar(255);not null;default:'pending'"`
	CreatedAt   time.Time
}

func (HelpRequest) TableName() string {
	return "help_requests"
}

type NearbyHelpRequest struct {
	ID          uint      `gorm:"column:id"`
	UserID      int       `gorm:"column:user_id"`
	Username    string    `gorm:"column:username"`
	Title       string    `gorm:"column:title"`
	Description string    `gorm:"column:description"`
	Category    Category  `gorm:"column:category"`
	Status      Status    `gorm:"column:status"`
	CreatedAt   time.Time `gorm:"column:created_at"`
	Distance    float64   `gorm:"column:distance"`
	Latitude    float64   `gorm:"column:latitude"`
	Longitude   float64   `gorm:"column:longitude"`
}
