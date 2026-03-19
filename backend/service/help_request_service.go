package service

import (
	"neighbor_help/contract"
	"neighbor_help/dto"
	"neighbor_help/models"
	errs "neighbor_help/pkg/error"
	"neighbor_help/utils"
	"net/http"
)

type HelpRequestService struct {
	HelpRequestRepository contract.HelpRequestRepository
	UsersRepository       contract.UsersRepository
}

func implHelpRequestService(helpRepo contract.HelpRequestRepository, usersRepo contract.UsersRepository) *HelpRequestService {
	return &HelpRequestService{
		HelpRequestRepository: helpRepo,
		UsersRepository:       usersRepo,
	}
}

func (s *HelpRequestService) CreateHelpRequest(userID uint, payload *dto.HelpRequest) (*dto.HelpRequestResponse, error) {
	if payload.Title == "" || payload.Description == "" || payload.Category == "" {
		return nil, errs.BadRequest("Title, Description, Category cannot be empty")
	}

	if payload.Category != "urgent" && payload.Category != "normal" {
		return nil, errs.BadRequest("Category must be 'urgent' or 'normal'")
	}

	category := models.Normal

	if payload.Category == "urgent" {
		category = models.Urgent
	} else {
		category = models.Normal
	}
	status := models.Pending

	helpRequest := &models.HelpRequest{
		ID:          payload.UserID,
		UserID:      int(userID),
		Title:       payload.Title,
		Description: payload.Description,
		Category:    category,
		Status:      status,
	}
	err := s.HelpRequestRepository.CreateHelpRequest(helpRequest)
	if err != nil {
		return nil, err
	}

	response := []dto.HelpRequestData{{
		ID:          helpRequest.ID,
		UserID:      uint(helpRequest.UserID),
		Title:       helpRequest.Title,
		Description: helpRequest.Description,
		Category:    string(helpRequest.Category),
		Status:      string(helpRequest.Status),
	}}

	return &dto.HelpRequestResponse{
		Status:       http.StatusOK,
		Message:      "Help request created successfully",
		HelpRequests: response,
	}, nil
}

func (s *HelpRequestService) GetAllHelpRequests() (*dto.HelpRequestResponse, error) {
	helpRequests, err := s.HelpRequestRepository.GetAllHelpRequests()
	if err != nil {
		return nil, err
	}

	response := &dto.HelpRequestResponse{
		Status:       http.StatusOK,
		Message:      "All Help requests retrieved successfully",
		HelpRequests: []dto.HelpRequestData{},
	}
	for _, helpRequest := range helpRequests {
		response.HelpRequests = append(response.HelpRequests, dto.HelpRequestData{
			ID:          helpRequest.ID,
			UserID:      uint(helpRequest.UserID),
			Title:       helpRequest.Title,
			Description: helpRequest.Description,
			Category:    string(helpRequest.Category),
			Status:      string(helpRequest.Status),
		})
	}

	return response, nil
}

func (s *HelpRequestService) GetNearbyHelpRequests(username string) (*dto.NearbyHelpRequestResponse, error) {
	currentUser, err := s.UsersRepository.GetUserByUsername(username)
	if err != nil {
		return nil, errs.NotFound("User not found")
	}

	const radiusMeters = 500.0

	helpRequests, err := s.HelpRequestRepository.GetNearbyHelpRequests(
		currentUser.Coordinate_lat,
		currentUser.Coordinate_long,
		currentUser.ID,
		radiusMeters,
	)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get nearby help requests")
	}

	response := &dto.NearbyHelpRequestResponse{
		Status:       http.StatusOK,
		Message:      "Nearby help requests retrieved successfully",
		HelpRequests: []dto.NearbyHelpRequestData{},
	}

	for _, hr := range helpRequests {
		response.HelpRequests = append(response.HelpRequests, dto.NearbyHelpRequestData{
			ID:          hr.ID,
			UserID:      uint(hr.UserID),
			Username:    hr.Username,
			Title:       hr.Title,
			Description: hr.Description,
			Category:    string(hr.Category),
			Status:      string(hr.Status),
			CreatedAt:   hr.CreatedAt,
			Distance:    utils.DecimalFormat(hr.Distance),
		})
	}

	return response, nil
}

func (s *HelpRequestService) UpdateHelpRequest(userID uint, helpRequestID uint, payload *dto.UpdateHelpRequest) (*dto.HelpRequestResponse, error) {
	helpReq, err := s.HelpRequestRepository.GetHelpRequestByID(helpRequestID)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get help request")
	}

	if uint(helpReq.UserID) != userID {
		return nil, errs.Forbidden("You are not authorized to update this help request")
	}

	if payload.Title != nil {
		helpReq.Title = *payload.Title
	}

	if payload.Description != nil {
		helpReq.Description = *payload.Description
	}

	if payload.Status != nil {
		if *payload.Status != "pending" && *payload.Status != "resolved" {
			return nil, errs.BadRequest("Status must be 'pending' or 'resolved'")
		}
		helpReq.Status = models.Status(*payload.Status)
	}

	if payload.Category != nil {
		if *payload.Category != "urgent" && *payload.Category != "normal" {
			return nil, errs.BadRequest("Category must be 'urgent' or 'normal'")
		}
		helpReq.Category = models.Category(*payload.Category)
	}

	err = s.HelpRequestRepository.UpdateHelpRequest(helpReq)
	if err != nil {
		return nil, err
	}

	return &dto.HelpRequestResponse{
		Status:  http.StatusOK,
		Message: "Help request updated successfully",
		HelpRequests: []dto.HelpRequestData{
			{
				ID:          helpReq.ID,
				UserID:      uint(helpReq.UserID),
				Title:       helpReq.Title,
				Description: helpReq.Description,
				Category:    string(helpReq.Category),
				Status:      string(helpReq.Status),
			},
		},
	}, nil
}

func (s *HelpRequestService) GetHelpRequestByID(id uint) (*dto.HelpRequestResponse, error) {
	helpReq, err := s.HelpRequestRepository.GetHelpRequestByID(id)
	if err != nil {
		return nil, errs.NotFound("Help request not found")
	}
	return &dto.HelpRequestResponse{
		Status:  http.StatusOK,
		Message: "Help request found",
		HelpRequests: []dto.HelpRequestData{
			{
				ID:          helpReq.ID,
				UserID:      uint(helpReq.UserID),
				Title:       helpReq.Title,
				Description: helpReq.Description,
				Category:    string(helpReq.Category),
				Status:      string(helpReq.Status),
			},
		},
	}, nil
}
