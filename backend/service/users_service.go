package service

import (
	"neighbor_help/contract"
	"neighbor_help/dto"
	"neighbor_help/models"
	errs "neighbor_help/pkg/error"
	"net/http"

	"gorm.io/gorm"
)

type UsersService struct {
	UserRepository contract.UsersRepository
}

func implUsersService(repo contract.UsersRepository) *UsersService {
	return &UsersService{
		UserRepository: repo,
	}
}

func (u *UsersService) Register(payload *dto.UsersRequest) (*dto.UsersResponse, error) {
	if payload.Username == "" || payload.Password == "" || payload.FullName == "" || payload.Address == "" {
		return nil, errs.BadRequest("Username, password, full name, and address are required")
	}

	if payload.Coordinate_lat == 0 || payload.Coordinate_long == 0 {
		return nil, errs.BadRequest("Coordinate latitude and longitude are required")
	}

	// if user.Password != "" {
	// 	return nil, errs.BadRequest("Password confirmation does not match")
	// }
	// usernameExists, err := u.UserRepository.GetUsers()

	userModel := &models.Users{
		Username:        payload.Username,
		Password:        payload.Password,
		FullName:        payload.FullName,
		Address:         payload.Address,
		Coordinate_lat:  payload.Coordinate_lat,
		Coordinate_long: payload.Coordinate_long,
	}
	err := u.UserRepository.CreateUser(userModel)
	if err != nil {
		return nil, errs.InternalServerError("Failed to register user")
	}

	response := &dto.UsersResponse{
		Status:  http.StatusCreated,
		Message: "User Registered Successfully",
		Data: []dto.UsersData{
			{
				ID:              userModel.ID,
				Username:        userModel.Username,
				Password:        userModel.Password,
				FullName:        userModel.FullName,
				Address:         userModel.Address,
				Coordinate_lat:  userModel.Coordinate_lat,
				Coordinate_long: userModel.Coordinate_long,
			},
		},
	}
	return response, nil
}

func (u *UsersService) GetUsers() (*dto.AllUsersResponse, error) {
	users, err := u.UserRepository.GetUsers()
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, errs.NotFound("User Not Found")
		}
		return nil, errs.InternalServerError("Failed to get Users")
	}

	response := &dto.AllUsersResponse{
		Response: []dto.UsersData{},
	}
	for _, user := range users {
		response.Response = append(response.Response, dto.UsersData{
			ID:              user.ID,
			Username:        user.Username,
			Password:        user.Password,
			FullName:        user.FullName,
			Address:         user.Address,
			Coordinate_lat:  user.Coordinate_lat,
			Coordinate_long: user.Coordinate_long,
		})
	}
	return response, nil
}

func (u *UsersService) GetUserByID(id uint) (*dto.UsersResponse, error) {
	user, err := u.UserRepository.GetUserByID(id)
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, errs.NotFound("User Not Found")
		}
		return nil, errs.InternalServerError("Failed to get User")
	}

	response := &dto.UsersResponse{
		Status:  http.StatusOK,
		Message: "User retrieved successfully",
		Data: []dto.UsersData{
			{
				ID:              user.ID,
				Username:        user.Username,
				Password:        user.Password,
				FullName:        user.FullName,
				Address:         user.Address,
				Coordinate_lat:  user.Coordinate_lat,
				Coordinate_long: user.Coordinate_long,
			},
		},
	}
	return response, nil
}
