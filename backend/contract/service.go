package contract

type Service struct {
	HealthService HealthService
}

type HealthService interface {
	GetStatus() string
}
