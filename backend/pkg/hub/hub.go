package hub

import (
	"encoding/json"
	"sync"
	"time"

	"github.com/gorilla/websocket"
)

const (
	writeWait      = 10 * time.Second
	pongWait       = 60 * time.Second
	pingPeriod     = (pongWait * 9) / 10
	maxMessageSize = 512
)

type IncomingMessage struct {
	Message string `json:"message"`
}

type OutgoingMessage struct {
	SenderID       uint      `json:"sender_id"`
	SenderUsername string    `json:"sender_username"`
	Message        string    `json:"message"`
	SentAt         time.Time `json:"sent_at"`
}

type Client struct {
	UserID   uint
	Username string
	Conn     *websocket.Conn
	Send     chan []byte
	Room     *Room
}

type Room struct {
	RequestID   uint
	RequesterID uint
	Clients     map[*Client]bool
	Broadcast   chan []byte
	Register    chan *Client
	Unregister  chan *Client
	mu          sync.RWMutex
}

type Hub struct {
	rooms map[uint]*Room
	mu    sync.RWMutex
}

func NewHub() *Hub {
	return &Hub{
		rooms: make(map[uint]*Room),
	}
}

func (h *Hub) GetOrCreateRoom(requestID, requesterID uint) *Room {
	h.mu.Lock()
	defer h.mu.Unlock()

	if room, ok := h.rooms[requestID]; ok {
		return room
	}

	room := &Room{
		RequestID:   requestID,
		RequesterID: requesterID,
		Clients:     make(map[*Client]bool),
		Broadcast:   make(chan []byte, 256),
		Register:    make(chan *Client),
		Unregister:  make(chan *Client),
	}
	h.rooms[requestID] = room
	go room.Run()
	return room
}

func (r *Room) GetOtherParticipantID(senderID uint) uint {
	r.mu.RLock()
	defer r.mu.RUnlock()

	for client := range r.Clients {
		if client.UserID != senderID {
			return client.UserID
		}
	}

	return 0
}

func (r *Room) Run() {
	for {
		select {
		case client := <-r.Register:
			r.mu.Lock()
			r.Clients[client] = true
			r.mu.Unlock()

		case client := <-r.Unregister:
			r.mu.Lock()
			if _, ok := r.Clients[client]; ok {
				delete(r.Clients, client)
				close(client.Send)
			}
			r.mu.Unlock()

		case message := <-r.Broadcast:
			r.mu.RLock()
			for client := range r.Clients {
				select {
				case client.Send <- message:
				default:
					close(client.Send)
					delete(r.Clients, client)
				}
			}
			r.mu.RUnlock()
		}
	}
}

func (c *Client) ReadPump(onMessage func(msg IncomingMessage) (*OutgoingMessage, error)) {
	defer func() {
		c.Room.Unregister <- c
		c.Conn.Close()
	}()

	c.Conn.SetReadLimit(maxMessageSize)
	c.Conn.SetReadDeadline(time.Now().Add(pongWait))
	c.Conn.SetPongHandler(func(string) error {
		c.Conn.SetReadDeadline(time.Now().Add(pongWait))
		return nil
	})

	for {
		var incoming IncomingMessage
		if err := c.Conn.ReadJSON(&incoming); err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				// connection closed unexpectedly
			}
			break
		}

		outgoing, err := onMessage(incoming)
		if err != nil || outgoing == nil {
			continue
		}

		data, err := json.Marshal(outgoing)
		if err != nil {
			continue
		}
		c.Room.Broadcast <- data
	}
}

func (c *Client) WritePump() {
	ticker := time.NewTicker(pingPeriod)
	defer func() {
		ticker.Stop()
		c.Conn.Close()
	}()

	for {
		select {
		case message, ok := <-c.Send:
			c.Conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				c.Conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}
			if err := c.Conn.WriteMessage(websocket.TextMessage, message); err != nil {
				return
			}

		case <-ticker.C:
			c.Conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := c.Conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}
