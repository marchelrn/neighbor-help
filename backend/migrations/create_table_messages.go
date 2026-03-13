package migrations

import (
	"database/sql"
	"log"
)

type CreateMessagesTable struct{}

func (m CreateMessagesTable) SkipProd() bool {
	return false
}

func getCreateMessagesTable() *CreateMessagesTable {
	return &CreateMessagesTable{}
}

func (m CreateMessagesTable) Name() string {
	return "create_messages_table"
}

func (m CreateMessagesTable) Up(conn *sql.Tx) error {
	_, err := conn.Exec(`
		CREATE TABLE IF NOT EXISTS messages (
			id SERIAL PRIMARY KEY,
			request_id  INT NOT NULL,
			sender_id 	INT NOT NULL,
			receiver_id INT NOT NULL,
			message TEXT NOT NULL,
			sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
			CONSTRAINT fk_request_id FOREIGN KEY (request_id) REFERENCES help_requests(id),
			CONSTRAINT fk_sender_id FOREIGN KEY (sender_id) REFERENCES users(id),
			CONSTRAINT fk_receiver_id FOREIGN KEY (receiver_id) REFERENCES users(id)
		);
	`)
	log.Println("Creating up migrations : CreateMessagesTable")
	return err
}

func (m CreateMessagesTable) Down(conn *sql.Tx) error {
	_, err := conn.Exec(`DROP TABLE IF NOT EXISTS messages`)
	if err != nil {
		return err
	}
	return err
}
