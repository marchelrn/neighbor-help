package repository

import (
	"neighbor_help/contract"
	"neighbor_help/models"

	"gorm.io/gorm"
)

type UsersRepository struct {
	db *gorm.DB
}

func ImplUsersRepository(db *gorm.DB) contract.UsersRepository {
	return &UsersRepository{db: db}
}

func (r *UsersRepository) CreateUser(user *models.Users) error {
	if err := r.db.Create(user).Error; err != nil {
		return err
	}
	return nil
}

func (r *UsersRepository) GetUsers() ([]*models.Users, error) {
	var users []*models.Users
	if err := r.db.Find(&users).Error; err != nil {
		return nil, err
	}
	return users, nil
}

func (r *UsersRepository) GetUserByID(id uint) (*models.Users, error) {
	var user models.Users
	if err := r.db.First(&user, id).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UsersRepository) GetUserByUsername(username string) (*models.Users, error) {
	var user models.Users
	if err := r.db.First(&user, "username = ?", username).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UsersRepository) UpdateUser(username string, payload *models.Users) error {
	if err := r.db.Model(&models.Users{}).Where("username = ?", username).Updates(payload).Error; err != nil {
		return err
	}
	return nil
}
