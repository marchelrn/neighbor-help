package models

import "time"

type Users struct {
	ID uint `gorm:"primaryKey;autoIncrement" json:"id"`

	Username string `gorm:"column:username;type:varchar(255);uniqueIndex;not null" json:"username"`

	Email string `gorm:"column:email;type:varchar(255);uniqueIndex;not null" json:"email"`

	Password string `gorm:"column:password;type:varchar(255);not null" json:"-"`

	Role string `gorm:"column:role;type:varchar(20);default:'user'" json:"role"`

	FullName string `gorm:"column:full_name;type:varchar(255);not null" json:"full_name"`

	Address string `gorm:"column:address;type:text;not null" json:"address"`
	

	CoordinateLat float64 `gorm:"column:coordinate_lat;type:decimal(10,8);not null" json:"coordinate_lat"`

	CoordinateLong float64 `gorm:"column:coordinate_long;type:decimal(11,8);not null" json:"coordinate_long"`

	CreatedAt time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`

	UpdatedAt time.Time `gorm:"column:updated_at;autoUpdateTime" json:"updated_at"`
}

func (Users) TableName() string {
	return "users"
}

type NearbyUser struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	CoordinateLat   float64 `json:"coordinate_lat"`
	CoordinateLong  float64 `json:"coordinate_long"`
	Distance        float64 `json:"distance"`
}