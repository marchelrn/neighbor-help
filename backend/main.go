package main

import (
	"log"

	"neighbor_help/config"
	"neighbor_help/internal/database"
	"neighbor_help/models"
	"neighbor_help/routes"

	"github.com/gin-gonic/gin"
)

func main() {

	config.Load()

	db, sqlDB := database.ConnectDB()
	defer sqlDB.Close()

	err := db.AutoMigrate(
		&models.Users{},
		&models.HelpRequest{},
	)

	if err != nil {
		log.Fatal(err)
	}

	router := gin.Default()

	api := router.Group("/api")

	routes.AuthRoutes(api, db)
	routes.HelpRequestRoutes(api, db)

	router.Run(":8080")
}