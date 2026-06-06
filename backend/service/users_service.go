package service

import (
	"neighbor_help/contract"
	"neighbor_help/dto"
	"neighbor_help/models"
	errs "neighbor_help/pkg/error"
	"neighbor_help/pkg/token"
	"neighbor_help/utils"

	"net/http"

	"golang.org/x/crypto/bcrypt"
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
	if payload.Email == "" || payload.Password == "" || payload.FullName == "" || payload.Address == "" {
		return nil, errs.BadRequest("Username, password, full name, and address are required")
	}

	if payload.CoordinateLat == 0 || payload.CoordinateLong == 0 {
		return nil, errs.BadRequest("Coordinate latitude and longitude are required")
	}

	if !utils.IsValidUsername(payload.Email) {
		return nil, errs.BadRequest("Invalid username")
	}

	if !utils.IsValidPassword(payload.Password) {
		return nil, errs.BadRequest("Invalid password")
	}

	usernameExists, err := u.UserRepository.GetUserByUsername(payload.Email)
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, errs.InternalServerError("Failed to get user by username")
	}
	if err == nil && usernameExists != nil {
		return nil, errs.Conflict("Username already exists")
	}
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(payload.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, errs.InternalServerError("Failed to hash password")
	}

	userModel := &models.Users{
		Username:        payload.Email,
		Password:        string(hashedPassword),
		FullName:        payload.FullName,
		Address:         payload.Address,
		CoordinateLat:  payload.CoordinateLat,
		CoordinateLong: payload.CoordinateLong,
	}

	err = u.UserRepository.CreateUser(userModel)
	if err != nil {
		return nil, errs.InternalServerError("Failed to register user")
	}

	response := &dto.UsersResponse{
		Status:  http.StatusCreated,
		Message: "User Registered Successfully",
		Data: dto.UsersData{
			ID:              userModel.ID,
			Username:        userModel.Username,
			FullName:        userModel.FullName,
			Address:         userModel.Address,
			CoordinateLat:  userModel.CoordinateLat,
			CoordinateLong: userModel.CoordinateLong,
		},
	}
	return response, nil
}

func (u *UsersService) Login(payload *dto.LoginRequest) (*dto.LoginResponse, error) {
	user, err := u.UserRepository.GetUserByUsername(payload.Email)
	if err != nil {
		return nil, errs.NotFound("User Not Found, Please register first")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(payload.Password))
	if err != nil {
		return nil, errs.BadRequest("Invalid Password")
	}

	t, err := token.GenerateToken(user.ID, user.Username)
	if err != nil {
		return nil, errs.InternalServerError("Failed to generate token")
	}

	response := &dto.LoginResponse{
		Status:  http.StatusOK,
		Message: "Login Success",
		Token:   t,
	}
	return response, nil
}

func (u *UsersService) UpdateUser(username string, usernameParam string, payload *dto.UpdateUserRequest) (*dto.UsersResponse, error) {
	err := utils.ValidateStruct(payload)
	if err != nil {
		return nil, errs.BadRequest("Invalid request payload")
	}

	user, err := u.UserRepository.GetUserByUsername(username)
	if err != nil {
		return nil, errs.NotFound("User Not Found")
	}
	if payload.Email != nil {
		if !utils.IsValidUsername(*payload.Email) {
			return nil, errs.BadRequest("Invalid Username")
		}

		usrExists, err := u.UserRepository.GetUserByUsername(*payload.Email)
		if err == nil && usrExists.Username != username {
			return nil, errs.Conflict("Username already taken")
		}
		user.Username = *payload.Email
	}

	if username != usernameParam {
		return nil, errs.Unauthorized("You can only update your own account")
	}

	if payload.Password != nil {
		if !utils.IsValidPassword(*payload.Password) {
			return nil, errs.BadRequest("Invalid Password")
		}
		hashed, err := bcrypt.GenerateFromPassword([]byte(*payload.Password), bcrypt.DefaultCost)
		if err != nil {
			return nil, errs.InternalServerError("Failed to hash password")
		}
		user.Password = string(hashed)
	}

	if payload.FullName != nil {
		user.FullName = *payload.FullName
	}

	if payload.Address != nil {
		user.Address = *payload.Address
	}

	if payload.CoordinateLat != nil {
		user.CoordinateLat = *payload.CoordinateLat
	}
	if payload.CoordinateLong != nil {
		user.CoordinateLong = *payload.CoordinateLong
	}

	err = u.UserRepository.UpdateUser(username, user)
	if err != nil {
		return nil, errs.InternalServerError("Failed to update User")
	}

	response := &dto.UsersResponse{
		Status:  http.StatusOK,
		Message: "Update Success",
		Data: dto.UsersData{
			ID:              user.ID,
			Username:        user.Username,
			FullName:        user.FullName,
			Address:         user.Address,
			CoordinateLat:  user.CoordinateLat,
			CoordinateLong: user.CoordinateLong,
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
		Status:  http.StatusOK,
		Message: "Users retrieved successfully",
		Data:    []dto.UsersData{},
	}
	for _, user := range users {
		response.Data = append(response.Data, dto.UsersData{
			ID:              user.ID,
			Username:        user.Username,
			FullName:        user.FullName,
			Address:         user.Address,
			CoordinateLat:  user.CoordinateLat,
			CoordinateLong: user.CoordinateLong,
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
		Data: dto.UsersData{
			ID:              user.ID,
			Username:        user.Username,
			FullName:        user.FullName,
			Address:         user.Address,
			CoordinateLat:  user.CoordinateLat,
			CoordinateLong: user.CoordinateLong,
		},
	}
	return response, nil
}

func (u *UsersService) GetNearbyUsers(username string) (*dto.NearbyUsersResponse, error) {
	currentUsers, err := u.UserRepository.GetUserByUsername(username)
	if err != nil {
		return nil, errs.NotFound("User Not Found")
	}

	const radius = 500

	nearbyUsers, err := u.UserRepository.GetNearbyUsers(
		currentUsers.CoordinateLat,
		currentUsers.CoordinateLong,
		radius,
		currentUsers.ID,
	)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get Nearby Users")
	}

	response := &dto.NearbyUsersResponse{
		Status:  http.StatusOK,
		Users:   []dto.NearbyUserData{},
		Message: "Nearby users retrieved successfully",
	}

	for _, user := range nearbyUsers {
		response.Users = append(response.Users, dto.NearbyUserData{
			ID:              user.ID,
			Username:        user.Username,
			FullName:        user.FullName,
			Address:         user.Address,
			CoordinateLat:  user.CoordinateLat,
			CoordinateLong: user.CoordinateLong,
			Distance:        utils.DecimalFormat(user.Distance),
		})
	}

	return response, nil
}
