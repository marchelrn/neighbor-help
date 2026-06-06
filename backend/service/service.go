package service

import (
	"neighbor_help/contract"
)

func New(repo *contract.Repository) (*contract.Service, error) {

	return &contract.Service{
		HelpRequest: ImplHelpRequestService(repo),
	}, nil
}