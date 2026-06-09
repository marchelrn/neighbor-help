package service

import (
	"neighbor_help/contract"
	"neighbor_help/dto"
	"neighbor_help/models"
	errs "neighbor_help/pkg/error"
	"neighbor_help/utils"

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
		var senderUsername string
		if user, err := s.usersRepo.GetUserByID(message.SenderID); err == nil {
			senderUsername = user.Username
		}

		response.MessageData = append(response.MessageData, dto.MessageData{
			ID:             message.ID,
			RequestID:      message.RequestID,
			SenderID:       message.SenderID,
			SenderUsername: senderUsername,
			RecieverID:     message.ReceiverID,
			Content:        message.Content,
			SentAt:         message.Sent_At,
		})
	}

	return response, nil
}

func (s *chatService) ValidateChatAccess(userID uint, requestID uint) (*dto.ChatAccessResult, error) {
	helpRequest, err := s.helpRepo.GetHelpRequestByID(requestID)
	if err != nil {
		return nil, errs.NotFound("Help request not found")
	}

	if helpRequest.Status == models.Solved {
		return nil, errs.Forbidden("This help request is already solved")
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

		dist := utils.HaversineMeters(
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
	err := utils.ValidateStruct(payload)
	if err != nil {
		return nil, errs.BadRequest("Invalid request payload")
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

func (s *chatService) DeleteMessage(requestID uint) (*dto.BasicResponse, error) {
	if err := s.messagesRepo.DeleteMessageByHelpRequestID(requestID); err != nil {
		return nil, errs.InternalServerError("Failed to delete message")
	}
	return &dto.BasicResponse{
		Status:  http.StatusOK,
		Message: "Message deleted successfully",
	}, nil
}
