package dto

import "time"

// Users
type UsersRequest struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	Password        string  `json:"password"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	Coordinate_lat  float64 `json:"coordinate_lat"`
	Coordinate_long float64 `json:"coordinate_long"`
	Actual_lat      float64 `json:"actual_lat"`
	Actual_long     float64 `json:"actual_long"`
}

type UpdateUserRequest struct {
	Username        *string  `json:"username"`
	Password        *string  `json:"password"`
	FullName        *string  `json:"full_name"`
	Address         *string  `json:"address"`
	Coordinate_lat  *float64 `json:"coordinate_lat"`
	Coordinate_long *float64 `json:"coordinate_long"`
}

type UsersData struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	Coordinate_lat  float64 `json:"coordinate_lat"`
	Coordinate_long float64 `json:"coordinate_long"`
}

type UsersResponse struct {
	Status  int       `json:"status"`
	Message string    `json:"message"`
	Data    UsersData `json:"data"`
}

type AllUsersResponse struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Data    []UsersData `json:"users"`
}

// Login
type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type LoginResponse struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
	Token   string `json:"token"`
}

// Nearby Users
type NearbyUserData struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	Coordinate_lat  float64 `json:"coordinate_lat"`
	Coordinate_long float64 `json:"coordinate_long"`
	Distance        float64 `json:"distance"`
}

type NearbyUsersResponse struct {
	Status  int              `json:"status"`
	Message string           `json:"message"`
	Users   []NearbyUserData `json:"users"`
}

// Help Request
type HelpRequest struct {
	ID          uint   `json:"id"`
	UserID      uint   `json:"user_id"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Category    string `json:"category"`
	Status      string `json:"status"`
}

type UpdateHelpRequest struct {
	Title       *string `json:"title"`
	Description *string `json:"description"`
	Category    *string `json:"category"`
	Status      *string `json:"status"`
}

type HelpRequestData struct {
	ID          uint      `json:"id"`
	UserID      uint      `json:"user_id"`
	Username    string    `json:"username"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Category    string    `json:"category"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
}

type HelpRequestResponse struct {
	Status       int               `json:"status"`
	Message      string            `json:"message"`
	HelpRequests []HelpRequestData `json:"help_requests"`
}

type NearbyHelpRequestData struct {
	ID          uint      `json:"id"`
	UserID      uint      `json:"user_id"`
	Username    string    `json:"username"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Category    string    `json:"category"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
	Distance    float64   `json:"distance_m"`
	Latitude    float64   `json:"latitude"`
	Longitude   float64   `json:"longitude"`
}

type NearbyHelpRequestResponse struct {
	Status       int                     `json:"status"`
	Message      string                  `json:"message"`
	HelpRequests []NearbyHelpRequestData `json:"help_requests"`
}

// Messages / chat

type MessageData struct {
	ID         uint      `json:"id"`
	RequestID      uint      `json:"request_id"`
	SenderID       uint      `json:"sender_id"`
	SenderUsername string    `json:"sender_username"`
	RecieverID     uint      `json:"reciever_id"`
	Content    string    `json:"content"`
	SentAt     time.Time `json:"created_at"`
}

type MessageResponse struct {
	Status      int           `json:"status"`
	Message     string        `json:"message"`
	MessageData []MessageData `json:"message_data"`
}

type CreateMessageRequest struct {
	RequestID  uint   `json:"request_id"`
	SenderID   uint   `json:"sender_id"`
	ReceiverID uint   `json:"receiver_id"`
	Content    string `json:"content"`
}

type SavedMessage struct {
	ID         uint      `json:"id"`
	RequestID  uint      `json:"request_id"`
	SenderID   uint      `json:"sender_id"`
	RecieverID uint      `json:"reciever_id"`
	Content    string    `json:"content"`
	SentAt     time.Time `json:"sent_at"`
}

type ChatAccessResult struct {
	RequestID       uint   `json:"request_id"`
	RequesterID     uint   `json:"requester_id"`
	CurrentUserID   uint   `json:"current_user_id"`
	CurrentUsername string `json:"current_username"`
}

// Basic Response

type BasicResponse struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
}

// Notification

type NotificationResponse struct {
	Status        int                `json:"status"`
	Message       string             `json:"message"`
	Notifications []NotificationData `json:"notifications"`
}

type NotificationData struct {
	ID            uint      `json:"id"`
	HelpRequestID *uint     `json:"request_id"`
	UserID        *uint     `json:"user_id"`
	Title         string    `json:"title"`
	Username      string    `json:"username"`
	IsRead        bool      `json:"is_read"`
	CreatedAt     time.Time `json:"created_at"`
}

type UnreadCountResponse struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
	Count   int64  `json:"count"`
}
