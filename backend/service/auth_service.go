package service

import (
	"errors"

	"neighbor_help/dto"
	"neighbor_help/models"
	"neighbor_help/pkg/hash"
	"neighbor_help/pkg/token"
	"neighbor_help/repository"
)

type AuthService struct {
	Repo *repository.AuthRepository
}

func NewAuthService(
	repo *repository.AuthRepository,
) *AuthService {

	return &AuthService{
		Repo: repo,
	}
}

// =========================
// REGISTER
// =========================

func (s *AuthService) Register(
	req dto.RegisterRequest,
) (string, error) {

	hashedPassword, err := hash.HashPassword(
		req.Password,
	)

	if err != nil {
		return "", err
	}

	user := models.Users{
		Username:       req.Username,
		Email:          req.Email,
		Password:       hashedPassword,
		FullName:       req.FullName,
		Address:        req.Address,
		CoordinateLat:  req.CoordinateLat,
		CoordinateLong: req.CoordinateLong,
	}

	err = s.Repo.CreateUser(&user)

	if err != nil {
		return "", err
	}

	// IMPORTANT DEBUG
	println("REGISTERED USER ID:", user.ID)

	jwtToken, err := token.GenerateToken(
		user.ID,
		user.Username,
	)

	if err != nil {
		return "", err
	}

	return jwtToken, nil
}
// =========================
// LOGIN
// =========================

func (s *AuthService) Login(
	req dto.LoginRequest,
) (string, error) {

	user, err := s.Repo.FindByEmail(
		req.Email,
	)

	if err != nil {

		return "", errors.New(
			"invalid credentials",
		)
	}

	valid := hash.CheckPasswordHash(
		req.Password,
		user.Password,
	)

	if !valid {

		return "", errors.New(
			"invalid credentials",
		)
	}

	jwtToken, err := token.GenerateToken(
		user.ID,
		user.Username,
	)

	return jwtToken, err
}

// =========================
// GET CURRENT USER
// =========================

func (s *AuthService) GetCurrentUser(
	userID uint,
) (*models.Users, error) {

	return s.Repo.GetUserByID(
		userID,
	)
}