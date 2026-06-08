package service

import (
	"neighbor_help/contract"
	"neighbor_help/dto"
	errs "neighbor_help/pkg/error"
	"net/http"
)

type NotificationService struct {
	NotificationRepository contract.NotificationRepository
}

func implNotificationService(notifRepo contract.NotificationRepository) *NotificationService {
	return &NotificationService{
		NotificationRepository: notifRepo,
	}
}

func (s *NotificationService) GetNotificationsByUserID(userID uint) (*dto.NotificationResponse, error) {
	notifications, err := s.NotificationRepository.GetNotificationsByUserID(userID)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get notifications")
	}

	response := &dto.NotificationResponse{
		Status:        http.StatusOK,
		Message:       "Notifications retrieved successfully",
		Notifications: []dto.NotificationData{},
	}

	for _, n := range notifications {
		response.Notifications = append(response.Notifications, dto.NotificationData{
			ID:            n.ID,
			HelpRequestID: n.HelpRequestID,
			UserID:        n.UserID,
			Title:         n.Title,
			Username:      n.Username,
			IsRead:        n.IsRead,
			CreatedAt:     n.Created_at,
		})
	}

	return response, nil
}

func (s *NotificationService) GetUnreadCountByUserID(userID uint) (*dto.UnreadCountResponse, error) {
	count, err := s.NotificationRepository.GetUnreadCountByUserID(userID)
	if err != nil {
		return nil, errs.InternalServerError("Failed to get unread notifications count")
	}

	return &dto.UnreadCountResponse{
		Status:  http.StatusOK,
		Message: "Unread count retrieved successfully",
		Count:   count,
	}, nil
}

func (s *NotificationService) MarkAsReadByUserID(userID uint) (*dto.BasicResponse, error) {
	err := s.NotificationRepository.MarkAsReadByUserID(userID)
	if err != nil {
		return nil, errs.InternalServerError("Failed to mark notifications as read")
	}

	return &dto.BasicResponse{
		Status:  http.StatusOK,
		Message: "Notifications marked as read successfully",
	}, nil
}
