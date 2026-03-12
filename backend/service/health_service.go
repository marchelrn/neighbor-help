package service

import (
	"neighbor_help/contract"
)

type HealthService struct {
	HealthRepository contract.HealthRepository
}

func implHealthService(repo contract.HealthRepository) *HealthService {
	return &HealthService{
		HealthRepository: repo,
	}
}

func (h *HealthService) GetStatus() string {
	status := h.HealthRepository.GetStatus()
	return status
}
