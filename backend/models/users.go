package models

type Users struct {
	ID              uint    `gorm:"primaryKey;autoIncrement"`
	Username        string  `gorm:"column:username;type:varchar(255);uniqueIndex;not null"`
	Password        string  `gorm:"column:password;type:varchar(255);not null"`
	FullName        string  `gorm:"column:full_name;type:varchar(255);not null"`
	Address         string  `gorm:"column:address;type:varchar(255);not null"`
	Coordinate_lat  float64 `gorm:"column:coordinate_lat;type:float;not null"`
	Coordinate_long float64 `gorm:"column:coordinate_long;type:float;not null"`
}

func (Users) TableName() string {
	return "users"
}

type NearbyUser struct {
	ID              uint    `gorm:"primaryKey;autoIncrement"`
	Username        string  `gorm:"column:username;type:varchar(255);uniqueIndex;not null"`
	FullName        string  `gorm:"column:full_name;type:varchar(255);not null"`
	Address         string  `gorm:"column:address;type:varchar(255);not null"`
	Coordinate_lat  float64 `gorm:"column:coordinate_lat;type:float;not null"`
	Coordinate_long float64 `gorm:"column:coordinate_long;type:float;not null"`
	Distance        float64 `gorm:"column:distance;type:float;not null"`
}
