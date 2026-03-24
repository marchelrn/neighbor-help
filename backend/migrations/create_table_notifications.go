package migrations

import (
	"database/sql"
	"log"
)

type CreateNotificationsTable struct{}

func (m CreateNotificationsTable) SkipProd() bool {
	return false
}

func getCreateNotificationsTable() *CreateNotificationsTable {
	return &CreateNotificationsTable{}
}

func (m CreateNotificationsTable) Name() string {
	return "create_notifications_table"
}

func (m CreateNotificationsTable) Up(conn *sql.Tx) error {
	_, err := conn.Exec(`
		CREATE TABLE IF NOT EXISTS notifications (
			id SERIAL PRIMARY KEY,
			user_id INT NOT NULL,
			title TEXT NOT NULL,
			is_read BOOLEAN NOT NULL DEFAULT FALSE,
			created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
			CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
		);
	`)
	log.Println("Creating up migrations : CreateNotificationsTable")
	return err
}

func (m CreateNotificationsTable) Down(conn *sql.Tx) error {
	_, err := conn.Exec(`DROP TABLE IF NOT EXISTS notifications`)
	if err != nil {
		return err
	}
	return err
}
