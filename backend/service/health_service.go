package service

import (
	"fmt"
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

func (h *HealthService) GetStatus() (string, error) {
	status, err := h.HealthRepository.GetStatus()
	if err != nil {
		return "", fmt.Errorf("failed to get health status: %w", err)
	}
	return status, nil
}
