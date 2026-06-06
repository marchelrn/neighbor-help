package dto

import "time"

// =========================
// USERS
// =========================

type UsersRequest struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	Email           string  `json:"email"`
	Password        string  `json:"password"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	CoordinateLat  float64 `json:"CoordinateLat"`
	CoordinateLong float64 `json:"CoordinateLong"`
}

type UpdateUserRequest struct {
	Username        *string  `json:"username"`
	Email           *string  `json:"email"`
	Password        *string  `json:"password"`
	FullName        *string  `json:"full_name"`
	Address         *string  `json:"address"`
	CoordinateLat  *float64 `json:"CoordinateLat"`
	CoordinateLong *float64 `json:"CoordinateLong"`
}

type UsersData struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	Email           string  `json:"email"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	CoordinateLat  float64 `json:"CoordinateLat"`
	CoordinateLong float64 `json:"CoordinateLong"`
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



// =========================
// NEARBY USERS
// =========================

type NearbyUserData struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	CoordinateLat  float64 `json:"CoordinateLat"`
	CoordinateLong float64 `json:"CoordinateLong"`
	Distance        float64 `json:"distance"`
}

type NearbyUsersResponse struct {
	Status  int              `json:"status"`
	Message string           `json:"message"`
	Users   []NearbyUserData `json:"users"`
}

// =========================
// HELP REQUESTS
// =========================

type HelpRequest struct {
	ID          uint    `json:"id"`
	UserID      uint    `json:"user_id"`
	Title       string  `json:"title"`
	Description string  `json:"description"`
	Category    string  `json:"category"`
	Status      string  `json:"status"`
	Latitude    float64 `json:"latitude"`
	Longitude   float64 `json:"longitude"`
}
type UpdateHelpRequest struct {
	Title       *string `json:"title"`
	Description *string `json:"description"`
	Category    *string `json:"category"`
	Status      *string `json:"status"`
}

type HelpRequestData struct {
	ID          uint   `json:"id"`
	UserID      uint   `json:"user_id"`
	Username    string `json:"username"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Category    string `json:"category"`
	Status      string `json:"status"`
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
}

type NearbyHelpRequestResponse struct {
	Status       int                     `json:"status"`
	Message      string                  `json:"message"`
	HelpRequests []NearbyHelpRequestData `json:"help_requests"`
}

// =========================
// MESSAGES / CHAT
// =========================

type MessageData struct {
	ID         uint      `json:"id"`
	RequestID  uint      `json:"request_id"`
	SenderID   uint      `json:"sender_id"`
	RecieverID uint      `json:"reciever_id"`
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

// =========================
// BASIC RESPONSE
// =========================

type BasicResponse struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
}