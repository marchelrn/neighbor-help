package service

import (
	"errors"

	"neighbor_help/contract"
	"neighbor_help/dto"
	"neighbor_help/models"
)

type HelpRequestService struct {
	repo *contract.Repository
}

func ImplHelpRequestService(
	repo *contract.Repository,
) *HelpRequestService {

	return &HelpRequestService{
		repo: repo,
	}
}

func (s *HelpRequestService) CreateHelpRequest(
	userID uint,
	req *dto.HelpRequest,
) (
	*dto.HelpRequestResponse,
	error,
) {

	if req.Category != "urgent" &&
		req.Category != "normal" {

		return nil, errors.New(
			"category must be urgent or normal",
		)
	}

	helpRequest := &models.HelpRequest{
		UserID:      userID,
		Title:       req.Title,
		Description: req.Description,
		Category:    req.Category,
		Latitude:    req.Latitude,
		Longitude:   req.Longitude,
		Status:      "pending",
	}

	err := s.repo.
		HelpRequestRepository.
		CreateHelpRequest(helpRequest)

	if err != nil {
		return nil, err
	}

	return &dto.HelpRequestResponse{
		Status: 201,
		Message: "Help request created successfully",
	}, nil
}

func (s *HelpRequestService) GetAllHelpRequests() (
	[]*models.HelpRequest,
	error,
) {

	return s.repo.
		HelpRequestRepository.
		GetAllHelpRequests()
}

func (s *HelpRequestService) GetNearbyHelpRequests(
	lat, lon float64,
	excludeUserID uint,
	radiusMeters float64,
) (
	[]*models.NearbyHelpRequest,
	error,
) {

	if radiusMeters <= 0 {
		radiusMeters = 3000
	}

	return s.repo.
		HelpRequestRepository.
		GetNearbyHelpRequests(
			lat,
			lon,
			excludeUserID,
			radiusMeters,
		)
}

func (s *HelpRequestService) GetHelpRequestByID(
	helpRequestID uint,
) (
	*models.HelpRequest,
	error,
) {

	return s.repo.
		HelpRequestRepository.
		GetHelpRequestByID(helpRequestID)
}

func (s *HelpRequestService) GetHelpRequestByUserID(
	userID uint,
) (
	[]*models.HelpRequest,
	error,
) {

	return s.repo.
		HelpRequestRepository.
		GetHelpRequestByUserID(userID)
}

func (s *HelpRequestService) UpdateHelpRequest(
	userID uint,
	helpRequestID uint,
	payload *dto.UpdateHelpRequestRequest,
) error {

	helpRequest, err := s.repo.
		HelpRequestRepository.
		GetHelpRequestByID(helpRequestID)

	if err != nil {
		return err
	}

	if helpRequest.UserID != userID {
		return errors.New(
			"you are not the owner of this help request",
		)
	}

	if payload.Title != nil {
		helpRequest.Title = *payload.Title
	}

	if payload.Description != nil {
		helpRequest.Description = *payload.Description
	}

	if payload.Category != nil {
		helpRequest.Category = *payload.Category
	}

	if payload.Status != nil {
		helpRequest.Status = *payload.Status
	}

	if payload.Latitude != nil {
		helpRequest.Latitude = *payload.Latitude
	}

	if payload.Longitude != nil {
		helpRequest.Longitude = *payload.Longitude
	}

	return s.repo.
		HelpRequestRepository.
		UpdateHelpRequest(helpRequest)
}

func (s *HelpRequestService) DeleteHelpRequest(
	userID uint,
	helpRequestID uint,
) error {

	helpRequest, err :=
		s.repo.HelpRequestRepository.
			GetHelpRequestByID(helpRequestID)

	if err != nil {
		return err
	}

	if helpRequest.UserID != userID {
		return errors.New(
			"you are not the owner of this help request",
		)
	}

	return s.repo.
		HelpRequestRepository.
		DeleteHelpRequest(helpRequestID)
}