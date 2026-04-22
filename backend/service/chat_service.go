package service

import (
	"math"
	"neighbor_help/contract"
	"neighbor_help/dto"
	"neighbor_help/models"
	errs "neighbor_help/pkg/error"
	"net/http"
	"time"
)

type chatService struct {
	messagesRepo contract.MessagesRepository
	helpRepo     contract.HelpRequestRepository
	usersRepo    contract.UsersRepository
}

func implChatService(
	messagesRepo contract.MessagesRepository,
	helpRepo contract.HelpRequestRepository,
	usersRepo contract.UsersRepository,
) contract.ChatService {
	return &chatService{
		messagesRepo: messagesRepo,
		helpRepo:     helpRepo,
		usersRepo:    usersRepo,
	}
}

func (s *chatService) GetMessages(requestID uint) (*dto.MessageResponse, error) {
	messages, err := s.messagesRepo.GetMessagesByHelpRequestID(requestID)
	if err != nil {
		return nil, errs.InternalServerError("Failed to retrieve messages")
	}

	response := &dto.MessageResponse{
		Status:      http.StatusOK,
		Message:     "Messages retrieved successfully",
		MessageData: []dto.MessageData{},
	}

	for _, message := range messages {
		response.MessageData = append(response.MessageData, dto.MessageData{
			ID:         message.ID,
			RequestID:  message.RequestID,
			SenderID:   message.SenderID,
			RecieverID: message.ReceiverID,
			Content:    message.Content,
			SentAt:     message.Sent_At,
		})
	}

	return response, nil
}

func (s *chatService) ValidateChatAccess(userID uint, requestID uint) (*dto.ChatAccessResult, error) {
	helpRequest, err := s.helpRepo.GetHelpRequestByID(requestID)
	if err != nil {
		return nil, errs.NotFound("Help request not found")
	}

	if helpRequest.Status == models.Resolved {
		return nil, errs.Forbidden("This help request is already resolved")
	}

	currentUser, err := s.usersRepo.GetUserByID(userID)
	if err != nil {
		return nil, errs.NotFound("User not found")
	}

	requesterID := uint(helpRequest.UserID)
	if requesterID != userID {
		requester, err := s.usersRepo.GetUserByID(requesterID)
		if err != nil {
			return nil, errs.InternalServerError("Failed to validate requester")
		}

		dist := haversineMeters(
			currentUser.Coordinate_lat, currentUser.Coordinate_long,
			requester.Coordinate_lat, requester.Coordinate_long,
		)
		if dist > 500 {
			return nil, errs.Forbidden("You are not within proximity")
		}
	}

	return &dto.ChatAccessResult{
		RequestID:       requestID,
		RequesterID:     requesterID,
		CurrentUserID:   currentUser.ID,
		CurrentUsername: currentUser.Username,
	}, nil
}

func (s *chatService) SaveMessage(payload *dto.CreateMessageRequest) (*dto.SavedMessage, error) {
	if payload.Content == "" {
		return nil, errs.BadRequest("Message cannot be empty")
	}

	if _, err := s.ValidateChatAccess(payload.SenderID, payload.RequestID); err != nil {
		return nil, err
	}

	now := time.Now()
	msg := &models.Messages{
		RequestID:  payload.RequestID,
		SenderID:   payload.SenderID,
		ReceiverID: payload.ReceiverID,
		Content:    payload.Content,
		Sent_At:    now,
	}
	if err := s.messagesRepo.CreateMessage(msg); err != nil {
		return nil, errs.InternalServerError("Failed to save message")
	}

	return &dto.SavedMessage{
		ID:         msg.ID,
		RequestID:  msg.RequestID,
		SenderID:   msg.SenderID,
		RecieverID: msg.ReceiverID,
		Content:    msg.Content,
		SentAt:     msg.Sent_At,
	}, nil
}

func haversineMeters(lat1, lon1, lat2, lon2 float64) float64 {
	const earthRadiusMeters = 6371000

	lat1Rad := lat1 * math.Pi / 180
	lat2Rad := lat2 * math.Pi / 180
	latDelta := (lat2 - lat1) * math.Pi / 180
	lonDelta := (lon2 - lon1) * math.Pi / 180

	a := math.Sin(latDelta/2)*math.Sin(latDelta/2) +
		math.Cos(lat1Rad)*math.Cos(lat2Rad)*math.Sin(lonDelta/2)*math.Sin(lonDelta/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))

	return earthRadiusMeters * c
}
