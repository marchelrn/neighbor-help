package repository

import (
	"neighbor_help/contract"
	"neighbor_help/models"

	"gorm.io/gorm"
)

func ImplHelpRequestRepository(db *gorm.DB) contract.HelpRequestRepository {
	return &helpRequestRepository{db: db}
}

type helpRequestRepository struct {
	db *gorm.DB
}

func (r *helpRequestRepository) CreateHelpRequest(payload *models.HelpRequest) error {
	if err := r.db.Create(payload).Error; err != nil {
		return err
	}
	return nil
}

func (r *helpRequestRepository) GetAllHelpRequests() ([]*models.HelpRequest, error) {
	var helpRequests []*models.HelpRequest
	if err := r.db.Find(&helpRequests).Error; err != nil {
		return nil, err
	}
	return helpRequests, nil
}

func (r *helpRequestRepository) GetHelpRequestByUserID(id uint) ([]*models.HelpRequest, error) {
	var helpRequests []*models.HelpRequest

	if err := r.db.
		Table("help_requests").
		Select("help_requests.*, users.username AS username").
		Joins("JOIN users ON users.id = help_requests.user_id").
		Where("help_requests.user_id = ?", id).
		Find(&helpRequests).Error; err != nil {
		return nil, err
	}
	return helpRequests, nil
}

func (r *helpRequestRepository) GetHelpRequestByID(id uint) (*models.HelpRequest, error) {
	var helpRequest models.HelpRequest
	if err := r.db.First(&helpRequest, id).Error; err != nil {
		return nil, err
	}
	return &helpRequest, nil
}

func (r *helpRequestRepository) UpdateHelpRequest(payload *models.HelpRequest) error {
	return r.db.Save(payload).Error
}

func (r *helpRequestRepository) GetNearbyHelpRequests(lat, lon float64, excludeUserID uint, radiusMeters float64) ([]*models.NearbyHelpRequest, error) {
	var helpRequests []*models.NearbyHelpRequest

	subQuery := r.db.
		Table("users u").
		Select(`
			u.id AS user_id,
			u.username,
			(6371000 * acos(
				LEAST(1.0,
					cos(radians(?)) * cos(radians(u.coordinate_lat)) *
					cos(radians(u.coordinate_long) - radians(?)) +
					sin(radians(?)) * sin(radians(u.coordinate_lat))
				)
			)) AS distance
		`, lat, lon, lat).
		Where("u.id != ?", excludeUserID)

	if err := r.db.
		Table("help_requests hr").
		Select(`
			hr.id,
			hr.user_id,
			hr.title,
			sub.username,
			hr.description,
			hr.category,
			hr.status,
			hr.created_at,
			sub.distance
		`).
		Joins("JOIN (?) sub ON hr.user_id = sub.user_id", subQuery).
		Where("sub.distance < ?", radiusMeters).
		Order("sub.distance ASC").
		Order("hr.created_at DESC").
		Scan(&helpRequests).Error; err != nil {
		return nil, err
	}
	return helpRequests, nil
}
