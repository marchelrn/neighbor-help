package contract

type Repository struct {
	HealthRepository HealthRepository
}

type HealthRepository interface {
	GetStatus() (string, error)
}
