package migrations

import (
	"database/sql"
	"log"
)

type CreateReputationLogsTable struct{}

func (m CreateReputationLogsTable) SkipProd() bool {
	return false
}

func getCreateReputationLogsTable() migration {
	return CreateReputationLogsTable{}
}

func (m CreateReputationLogsTable) Name() string {
	return "create_reputation_logs_table"
}

func (m CreateReputationLogsTable) Up(conn *sql.Tx) error {
	_, err := conn.Exec(`
	CREATE TABLE IF NOT EXISTS reputation_logs (
		id SERIAL PRIMARY KEY,
		helper_id INT NOT NULL,
		request_id INT NOT NULL,
		points_received INT NOT NULL,
		CONSTRAINT fk_helper_id FOREIGN KEY (helper_id) REFERENCES users(id),
		CONSTRAINT fk_request_id FOREIGN KEY (request_id) REFERENCES help_requests(id)
	);
	`)
	log.Println("Creating up migrations : CreateMessagesTable")
	return err
}

func (m CreateReputationLogsTable) Down(conn *sql.Tx) error {
	_, err := conn.Exec(`DROP TABLE IF NOT EXISTS reputation_logs`)
	if err != nil {
		return err
	}
	return err
}
