package server

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"neighbor_help/config"
	"neighbor_help/contract"
	"neighbor_help/internal/database"
	"neighbor_help/migrations"
	"neighbor_help/repository"
	"neighbor_help/routes"
	"neighbor_help/service"
)

func Run() {
	log.SetFlags(log.Ldate | log.Ltime)
	log.SetOutput(os.Stdout)

	cfg := config.GetConfig()

	db, sqlDB := database.ConnectDB()

	repositories := &contract.Repository{
		HelpRequestRepository: repository.NewHelpRequestRepository(db),

		// Add these back once their repositories exist:
		// HealthRepository:       repository.NewHealthRepository(),
		// UsersRepository:        repository.NewUsersRepository(db),
		// MessagesRepository:     repository.NewMessagesRepository(db),
		// NotificationRepository: repository.NewNotificationRepository(db),
	}

	services, err := service.New(repositories)
	if err != nil {
		log.Fatalf("Failed to initialize services: %v", err)
	}

	r := routes.SetupRoutes(services)

	migrations.Up(sqlDB)

	serv := &http.Server{
		Addr:    fmt.Sprintf(":%s", cfg.Port),
		Handler: r,
	}

	log.Printf("Server is running on port %s\n", cfg.Port)

	if err := serv.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}