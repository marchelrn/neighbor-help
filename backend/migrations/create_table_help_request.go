package migrations

import (
	"database/sql"
	"log"
)

type CreateHelpRequestTable struct{}

func (m CreateHelpRequestTable) SkipProd() bool {
	return false
}

func getCreateHelpRequestTable() *CreateHelpRequestTable {
	return &CreateHelpRequestTable{}
}

func (m CreateHelpRequestTable) Name() string {
	return "create_help_request_table"
}

func (m CreateHelpRequestTable) Up(conn *sql.Tx) error {
	_, err := conn.Exec(`
		CREATE TABLE IF NOT EXISTS help_requests (
			id SERIAL PRIMARY KEY,
			user_id INT NOT NULL,
			title TEXT NOT NULL,
			description TEXT NOT NULL,
			category TEXT NOT NULL,
			status TEXT NOT NULL,
			created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
			CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
		);
	`)
	log.Println("Creating up migrations : CreateHelpRequestTable")
	return err
}

func (m CreateHelpRequestTable) Down(conn *sql.Tx) error {
	_, err := conn.Exec(`DROP TABLE IF NOT EXISTS help_requests`)
	if err != nil {
		return err
	}
	return err
}
