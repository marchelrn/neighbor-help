package repository

import (
	"neighbor_help/models"

	"gorm.io/gorm"
)

type HelpRequestRepository struct {
	DB *gorm.DB
}

func NewHelpRequestRepository(
	db *gorm.DB,
) *HelpRequestRepository {

	return &HelpRequestRepository{
		DB: db,
	}
}

func (r *HelpRequestRepository) CreateHelpRequest(
	payload *models.HelpRequest,
) error {

	return r.DB.Create(payload).Error
}

func (r *HelpRequestRepository) GetAllHelpRequests() (
	[]*models.HelpRequest,
	error,
) {

	var helpRequests []*models.HelpRequest

	err := r.DB.
		Order("created_at DESC").
		Find(&helpRequests).Error

	if err != nil {
		return nil, err
	}

	return helpRequests, nil
}

func (r *HelpRequestRepository) GetHelpRequestByID(
	id uint,
) (
	*models.HelpRequest,
	error,
) {

	var helpRequest models.HelpRequest

	err := r.DB.
		Where("id = ?", id).
		First(&helpRequest).Error

	if err != nil {
		return nil, err
	}

	return &helpRequest, nil
}

func (r *HelpRequestRepository) GetHelpRequestByUserID(
	id uint,
) (
	[]*models.HelpRequest,
	error,
) {

	var helpRequests []*models.HelpRequest

	err := r.DB.
		Where("user_id = ?", id).
		Order("created_at DESC").
		Find(&helpRequests).Error

	if err != nil {
		return nil, err
	}

	return helpRequests, nil
}

func (r *HelpRequestRepository) UpdateHelpRequest(
	payload *models.HelpRequest,
) error {

	return r.DB.Save(payload).Error
}

func (r *HelpRequestRepository) GetNearbyHelpRequests(
	lat, lon float64,
	excludeUserID uint,
	radiusMeters float64,
) (
	[]*models.NearbyHelpRequest,
	error,
) {

	var helpRequests []*models.NearbyHelpRequest

	query := `
	SELECT *
	FROM (
		SELECT
			help_requests.id,
			help_requests.user_id,
			users.username,
			help_requests.title,
			help_requests.description,
			help_requests.category,
			help_requests.status,
			help_requests.latitude,
			help_requests.longitude,

			(
				6371000 * acos(
					cos(radians(?)) *
					cos(radians(help_requests.latitude)) *
					cos(radians(help_requests.longitude) - radians(?)) +
					sin(radians(?)) *
					sin(radians(help_requests.latitude))
				)
			) AS distance

		FROM help_requests

		JOIN users
			ON users.id = help_requests.user_id

		WHERE help_requests.user_id != ?
	) AS nearby_requests

	WHERE distance <= ?

	ORDER BY distance ASC
`

	err := r.DB.Raw(
		query,
		lat,
		lon,
		lat,
		excludeUserID,
		radiusMeters,
	).Scan(&helpRequests).Error

	if err != nil {
		return nil, err
	}

	return helpRequests, nil
}

func (r *HelpRequestRepository) DeleteHelpRequest(
	id uint,
) error {

	return r.DB.
		Delete(&models.HelpRequest{}, id).
		Error
}

