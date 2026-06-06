package repository

import (
	"neighbor_help/models"

	"gorm.io/gorm"
)

type AuthRepository struct {
	DB *gorm.DB
}

func NewAuthRepository(
	db *gorm.DB,
) *AuthRepository {

	return &AuthRepository{
		DB: db,
	}
}

// =========================
// CREATE USER
// =========================

func (r *AuthRepository) CreateUser(
	user *models.Users,
) error {

	return r.DB.Create(user).Error
}

// =========================
// FIND BY EMAIL
// =========================

func (r *AuthRepository) FindByEmail(
	email string,
) (*models.Users, error) {

	var user models.Users

	err := r.DB.
		Where("email = ?", email).
		First(&user).Error

	if err != nil {
		return nil, err
	}

	return &user, nil
}

// =========================
// GET USER BY ID
// =========================

func (r *AuthRepository) GetUserByID(
	id uint,
) (*models.Users, error) {

	var user models.Users

	err := r.DB.
		Where("id = ?", id).
		First(&user).Error

	if err != nil {
		return nil, err
	}

	return &user, nil
}