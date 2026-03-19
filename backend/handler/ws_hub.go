package handler

import (
	"encoding/json"
	"log"
	"sync"
	"time"

	"github.com/gorilla/websocket"
)

type WSMessage struct {
	Type      string    `json:"type"` // "message", "system", "history"
	SenderID  uint      `json:"sender_id,omitempty"`
	Username  string    `json:"username,omitempty"`
	Content   string    `json:"content,omitempty"`
	SentAt    time.Time `json:"sent_at,omitempty"`
	RequestID uint      `json:"request_id,omitempty"`
}

type IncomingMessage struct {
	Content string `json:"content"`
}

type Client struct {
	UserID        uint
	Username      string
	HelpRequestID uint
	conn          *websocket.Conn
	send          chan []byte
	room          *Room
}

type Room struct {
	HelpRequestID uint
	clients       map[*Client]bool
	broadcast     chan []byte
	register      chan *Client
	unregister    chan *Client
	mu            sync.RWMutex
}

// Hub mengelola semua room yang aktif
type Hub struct {
	rooms map[uint]*Room
	mu    sync.RWMutex
}

var globalHub = &Hub{
	rooms: make(map[uint]*Room),
}

func GetHub() *Hub {
	return globalHub
}

func (h *Hub) GetOrCreateRoom(helpRequestID uint) *Room {
	h.mu.Lock()
	defer h.mu.Unlock()
	room, ok := h.rooms[helpRequestID]
	if !ok {
		room = &Room{
			HelpRequestID: helpRequestID,
			clients:       make(map[*Client]bool),
			broadcast:     make(chan []byte, 256),
			register:      make(chan *Client),
			unregister:    make(chan *Client),
		}
		h.rooms[helpRequestID] = room
		go room.Run(h)
	}
	return room
}

func (h *Hub) removeRoom(helpRequestID uint) {
	h.mu.Lock()
	defer h.mu.Unlock()
	delete(h.rooms, helpRequestID)
}

func (r *Room) Run(h *Hub) {
	for {
		select {
		case client := <-r.register:
			r.mu.Lock()
			r.clients[client] = true
			r.mu.Unlock()

			joinMsg, _ := json.Marshal(WSMessage{
				Type:      "system",
				Username:  client.Username,
				Content:   client.Username + " bergabung ke chat",
				SentAt:    time.Now(),
				RequestID: r.HelpRequestID,
			})
			r.broadcastToOthers(client, joinMsg)

		case client := <-r.unregister:
			r.mu.Lock()
			if _, ok := r.clients[client]; ok {
				delete(r.clients, client)
				close(client.send)
			}
			remaining := len(r.clients)
			r.mu.Unlock()

			leaveMsg, _ := json.Marshal(WSMessage{
				Type:      "system",
				Username:  client.Username,
				Content:   client.Username + " meninggalkan chat",
				SentAt:    time.Now(),
				RequestID: r.HelpRequestID,
			})
			r.broadcastToAll(leaveMsg)

			if remaining == 0 {
				h.removeRoom(r.HelpRequestID)
				return
			}

		case message := <-r.broadcast:
			r.mu.RLock()
			for client := range r.clients {
				select {
				case client.send <- message:
				default:
					close(client.send)
					delete(r.clients, client)
				}
			}
			r.mu.RUnlock()
		}
	}
}

func (r *Room) broadcastToAll(msg []byte) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for client := range r.clients {
		select {
		case client.send <- msg:
		default:
		}
	}
}

func (r *Room) broadcastToOthers(sender *Client, msg []byte) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for client := range r.clients {
		if client != sender {
			select {
			case client.send <- msg:
			default:
			}
		}
	}
}

const (
	writeWait      = 10 * time.Second
	pongWait       = 60 * time.Second
	pingPeriod     = (pongWait * 9) / 10
	maxMessageSize = 1024
)

func (c *Client) ReadPump(onMessage func(client *Client, content string)) {
	defer func() {
		c.room.unregister <- c
		c.conn.Close()
	}()

	c.conn.SetReadLimit(maxMessageSize)
	c.conn.SetReadDeadline(time.Now().Add(pongWait))
	c.conn.SetPongHandler(func(string) error {
		c.conn.SetReadDeadline(time.Now().Add(pongWait))
		return nil
	})

	for {
		_, message, err := c.conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("WebSocket read error: %v", err)
			}
			break
		}

		var incoming IncomingMessage
		if err := json.Unmarshal(message, &incoming); err != nil {
			log.Printf("Format pesan tidak valid: %v", err)
			continue
		}

		if incoming.Content == "" {
			continue
		}

		onMessage(c, incoming.Content)
	}
}

func (c *Client) WritePump() {
	ticker := time.NewTicker(pingPeriod)
	defer func() {
		ticker.Stop()
		c.conn.Close()
	}()

	for {
		select {
		case message, ok := <-c.send:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if !ok {
				c.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}

			w, err := c.conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}
			w.Write(message)

			n := len(c.send)
			for i := 0; i < n; i++ {
				w.Write([]byte{'\n'})
				w.Write(<-c.send)
			}

			if err := w.Close(); err != nil {
				return
			}

		case <-ticker.C:
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := c.conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				return
			}
		}
	}
}
