package models

type ReputationLog struct {
	ID            int `gorm:"primaryKey;autoIncrement"`
	HelperID      int `gorm:"not null"`
	RequestID     int `gorm:"not null"`
	PointRetrieve int `gorm:"type:int"`
}
