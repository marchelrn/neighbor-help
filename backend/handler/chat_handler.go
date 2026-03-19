package handler

import (
	"encoding/json"
	"fmt"
	"neighbor_help/contract"
	"neighbor_help/dto"
	errs "neighbor_help/pkg/error"
	"neighbor_help/pkg/hub"
	"neighbor_help/pkg/token"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

type ChatController struct {
	Hub         *hub.Hub
	ChatService contract.ChatService
}

func (h *ChatController) InitService(s *contract.Service) {
	fmt.Println("DEBUG: Initializing ChatController with ChatService")
	if s == nil {
		fmt.Println("ERROR: Service is nil")
		return
	}

	if s.Chat == nil {
		fmt.Println("ERROR: ChatService is nil")
		return
	}

	h.ChatService = s.Chat
	if h.Hub == nil {
		h.Hub = hub.NewHub()
	}

	fmt.Println("DEBUG: ChatController initialized successfully with ChatService")
}

func (h *ChatController) GetMessages(c *gin.Context) {
	userIDGet, exists := c.Get("UserID")
	if !exists {
		HandleError(c, errs.Unauthorized("Unauthorized"))
		return
	}

	requestID, err := parseRequestIDParam(c)
	if err != nil {
		HandleError(c, err)
		return
	}

	if _, err := h.ChatService.ValidateChatAccess(userIDGet.(uint), requestID); err != nil {
		HandleError(c, err)
		return
	}

	response, err := h.ChatService.GetMessages(requestID)
	if err != nil {
		HandleError(c, err)
		return
	}

	c.JSON(response.Status, response)
}

func (h *ChatController) JoinChat(c *gin.Context) {
	tokenStr := c.Query("token")
	if tokenStr == "" {
		HandleError(c, errs.Unauthorized("Token is required"))
		return
	}

	claims, err := token.ValidateToken(tokenStr)
	if err != nil {
		HandleError(c, errs.Unauthorized("Invalid token"))
		return
	}

	requestID, err := parseRequestIDParam(c)
	if err != nil {
		HandleError(c, err)
		return
	}

	access, err := h.ChatService.ValidateChatAccess(claims.UserID, requestID)
	if err != nil {
		HandleError(c, err)
		return
	}

	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		return
	}

	room := h.Hub.GetOrCreateRoom(requestID, access.RequesterID)
	client := &hub.Client{
		UserID:   claims.UserID,
		Username: access.CurrentUsername,
		Conn:     conn,
		Send:     make(chan []byte, 256),
		Room:     room,
	}

	room.Register <- client
	if err := h.pushHistory(client, requestID); err != nil {
		room.Unregister <- client
		return
	}

	go client.WritePump()
	client.ReadPump(func(incoming hub.IncomingMessage) (*hub.OutgoingMessage, error) {
		if incoming.Message == "" || len(incoming.Message) == 0 {
			return nil, fmt.Errorf("Empty message")
		}

		receiverID := access.RequesterID
		if claims.UserID == access.RequesterID {
			receiverID = room.GetOtherParticipantID(claims.UserID)
			if receiverID == 0 {
				return nil, fmt.Errorf("no nearby user connected to receive the message")
			}
		}

		saved, err := h.ChatService.SaveMessage(&dto.CreateMessageRequest{
			RequestID:  requestID,
			SenderID:   claims.UserID,
			ReceiverID: receiverID,
			Content:    incoming.Message,
		})
		if err != nil {
			return nil, err
		}

		return &hub.OutgoingMessage{
			SenderID:       saved.SenderID,
			SenderUsername: access.CurrentUsername,
			Message:        saved.Content,
			SentAt:         saved.SentAt,
		}, nil
	})
}

func (h *ChatController) pushHistory(client *hub.Client, requestID uint) error {
	response, err := h.ChatService.GetMessages(requestID)
	if err != nil {
		return err
	}

	payload, err := json.Marshal(gin.H{
		"type":     "history",
		"messages": response.MessageData,
	})
	if err != nil {
		return err
	}

	client.Send <- payload
	return nil
}

func parseRequestIDParam(c *gin.Context) (uint, error) {
	requestIDParam := c.Param("id")
	requestIDInt, err := strconv.Atoi(requestIDParam)
	if err != nil || requestIDInt <= 0 {
		return 0, errs.BadRequest("Invalid request ID")
	}

	return uint(requestIDInt), nil
}
