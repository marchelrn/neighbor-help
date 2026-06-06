package models

import "time"

type HelpRequest struct {
	ID uint `gorm:"primaryKey" json:"id"`

	UserID uint `gorm:"not null" json:"user_id"`

	Title string `gorm:"type:text;not null" json:"title"`

	Description string `gorm:"type:text;not null" json:"description"`

	Category string `gorm:"type:varchar(50);not null" json:"category"`

	Status string `gorm:"type:varchar(50);default:'pending'" json:"status"`

	Latitude float64 `gorm:"type:decimal(10,8);not null" json:"latitude"`

	Longitude float64 `gorm:"type:decimal(11,8);not null" json:"longitude"`

	CreatedAt time.Time `json:"created_at"`

	UpdatedAt time.Time `json:"updated_at"`
}

type NearbyHelpRequest struct {
	ID          uint    `json:"id"`
	UserID      uint    `json:"user_id"`
	Username    string  `json:"username"`
	Title       string  `json:"title"`
	Description string  `json:"description"`
	Category    string  `json:"category"`
	Status      string  `json:"status"`
	Latitude    float64 `json:"latitude"`
	Longitude   float64 `json:"longitude"`
	Distance    float64 `json:"distance"`
}