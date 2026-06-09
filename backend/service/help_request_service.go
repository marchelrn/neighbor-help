package service

import (
	"fmt"
	"neighbor_help/contract"
	"neighbor_help/dto"
	"neighbor_help/models"
	errs "neighbor_help/pkg/error"
	"neighbor_help/utils"

	"net/http"
	"time"
)

type HelpRequestService struct {
	HelpRequestRepository  contract.HelpRequestRepository
	UsersRepository        contract.UsersRepository
	NotificationRepository contract.NotificationRepository
	MessagesRepository     contract.MessagesRepository
}

func implHelpRequestService(helpRepo contract.HelpRequestRepository, usersRepo contract.UsersRepository, notificationRepo contract.NotificationRepository, messagesRepo contract.MessagesRepository) *HelpRequestService {
	return &HelpRequestService{
		HelpRequestRepository:  helpRepo,
		UsersRepository:        usersRepo,
		NotificationRepository: notificationRepo,
		MessagesRepository:     messagesRepo,
	}
}

func (s *HelpRequestService) CreateHelpRequest(userID uint, payload *dto.HelpRequest) (*dto.HelpRequestResponse, error) {
	err := utils.ValidateStruct(payload)
	if err != nil {
		return nil, errs.BadRequest("Invalid request payload")
	}

	if payload.Category != "urgent" && payload.Category != "normal" {
		return nil, errs.BadRequest("Category must be 'urgent' or 'normal'")
	}

	category := models.Normal
	if payload.Category == "urgent" {
		category = models.Urgent
	}

	status := models.Pending
	username := s.UsersRepository.GetUsernameByID(userID)

	helpRequest := &models.HelpRequest{
		Username:    username,
		UserID:      userID,
		Title:       payload.Title,
		Description: payload.Description,
		Category:    category,
		Status:      status,
	}

	err = s.HelpRequestRepository.CreateHelpRequest(helpRequest)
	if err != nil {
		return nil, err
	}

	// Notify nearby users (radius 10km for example)
	creator, errCreator := s.UsersRepository.GetUserByID(userID)
	if errCreator == nil {
		nearbyUsers, _ := s.UsersRepository.GetNearbyUsers(creator.Coordinate_lat, creator.Coordinate_long, 10000, userID)
		for _, u := range nearbyUsers {
			uid := u.ID
			_ = s.NotificationRepository.CreateNotification(&models.Notifications{
				HelpRequestID: &helpRequest.ID,
				UserID:        &uid,
				Title:         fmt.Sprintf("Request baru: %s", helpRequest.Title),
				Username:      username,
				IsRead:        false,
				Created_at:    time.Now(),
			})
		}
	}

	response := []dto.HelpRequestData{{
		ID:          helpRequest.ID,
		Username:    helpRequest.Username,
		UserID:      uint(helpRequest.UserID),
		Title:       helpRequest.Title,
		Description: helpRequest.Description,
		Category:    string(helpRequest.Category),
		Status:      string(helpRequest.Status),
		CreatedAt:   helpRequest.CreatedAt,
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
			Username:    helpRequest.Username,
			Title:       helpRequest.Title,
			Description: helpRequest.Description,
			Category:    string(helpRequest.Category),
			Status:      string(helpRequest.Status),
			Address:     helpRequest.Address,
			CreatedAt:   helpRequest.CreatedAt,
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
			Latitude:    hr.Latitude,
			Longitude:   hr.Longitude,
		})
	}

	return response, nil
}

func (s *HelpRequestService) UpdateHelpRequest(userID uint, helpRequestID uint, payload *dto.UpdateHelpRequest) (*dto.BasicResponse, error) {
	err := utils.ValidateStruct(payload)
	if err != nil {
		return nil, errs.BadRequest("Invalid request payload")
	}

	helpReq, err := s.HelpRequestRepository.GetHelpRequestByID(helpRequestID)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get help request")
	}

	Users, err := s.UsersRepository.GetUserByID(userID)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get user")
	}

	if uint(helpReq.UserID) != userID && Users.Role != "admin" {
		return nil, errs.Forbidden("You are not authorized to update this help request")
	}

	if payload.Title != nil {
		helpReq.Title = *payload.Title
	}

	if payload.Description != nil {
		helpReq.Description = *payload.Description
	}

	if payload.Status != nil {
		if *payload.Status != "pending" && *payload.Status != "solved" {
			return nil, errs.BadRequest("Status must be 'pending' or 'solved'")
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

	response := &dto.BasicResponse{
		Status:  http.StatusOK,
		Message: "Help request updated successfully",
	}

	return response, nil
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
				CreatedAt:   helpReq.CreatedAt,
			},
		},
	}, nil
}

func (s *HelpRequestService) GetHelpRequestByUserID(userID uint) (*dto.HelpRequestResponse, error) {
	helpReq, err := s.HelpRequestRepository.GetHelpRequestByUserID(userID)
	if err != nil {
		return nil, errs.NotFound("Help request not found for this user")
	}
	response := &dto.HelpRequestResponse{
		Status:       http.StatusOK,
		Message:      fmt.Sprintf("Help requests for user %d retrieved successfully", userID),
		HelpRequests: []dto.HelpRequestData{},
	}

	for _, hr := range helpReq {
		response.HelpRequests = append(response.HelpRequests, dto.HelpRequestData{
			ID:          hr.ID,
			UserID:      uint(hr.UserID),
			Username:    hr.Username,
			Title:       hr.Title,
			Description: hr.Description,
			Category:    string(hr.Category),
			Status:      string(hr.Status),
			CreatedAt:   hr.CreatedAt,
		})
	}
	return response, nil
}

func (s *HelpRequestService) DeleteHelpRequest(id uint) (*dto.BasicResponse, error) {
	messages, err := s.MessagesRepository.GetMessagesByHelpRequestID(id)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get messages related to help request")
	}

	if len(messages) > 0 {
		err = s.MessagesRepository.DeleteMessageByHelpRequestID(id)
		if err != nil {
			return nil, errs.InternalServerError("Failed to delete messages related to help request")
		}
	}

	err = s.NotificationRepository.DeleteNotificationByHelpRequestID(id)
	if err != nil {
		return nil, errs.InternalServerError("Failed to delete notifications related to help request")
	}

	err = s.HelpRequestRepository.DeleteHelpRequest(id)
	if err != nil {
		return nil, errs.InternalServerError("Failed to delete help request")
	}

	response := &dto.BasicResponse{
		Status:  http.StatusOK,
		Message: "Help request deleted successfully",
	}
	return response, nil
}
