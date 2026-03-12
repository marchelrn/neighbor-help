package app

import (
	"neighbor_help/config"
	"neighbor_help/internal/server"
)

func Run() {
	config.Load()
	server.Run()
}
