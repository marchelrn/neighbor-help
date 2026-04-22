package migrations

import (
	"database/sql"
	"log"
)

type CreateUsersTable struct{}

func (m CreateUsersTable) SkipProd() bool {
	return false
}

func getCreateUsersTable() *CreateUsersTable {
	return &CreateUsersTable{}
}

func (m CreateUsersTable) Name() string {
	return "create_users_table"
}

func (m CreateUsersTable) Up(conn *sql.Tx) error {
	_, err := conn.Exec(`
	CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY,
		username VARCHAR(255) NOT NULL,
		password VARCHAR(255) NOT NULL,
		full_name VARCHAR(255) NOT NULL,
		address VARCHAR(255) NOT NULL,
		coordinate_lat DECIMAL(10, 8) NOT NULL,
		coordinate_long DECIMAL(11, 8) NOT NULL
	)
	`)
	log.Println("Creating up migrations : CreateUsersTable")
	return err
}

func (m CreateUsersTable) Down(conn *sql.Tx) error {
	_, err := conn.Exec(`DROP TABLE IF NOT EXISTS users`)
	if err != nil {
		return err
	}
	return err
}
