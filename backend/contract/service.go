package contract

type Service struct {
	Health HealthService
}

type HealthService interface {
	GetStatus() (string, error)
}
