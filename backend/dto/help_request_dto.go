package dto

type CreateHelpRequestRequest struct {
	Title       string  `json:"title" binding:"required"`
	Description string  `json:"description" binding:"required"`
	Category    string  `json:"category" binding:"required"`
	Latitude    float64 `json:"latitude" binding:"required"`
	Longitude   float64 `json:"longitude" binding:"required"`
}

type UpdateHelpRequestRequest struct {
	Title       *string  `json:"title"`
	Description *string  `json:"description"`
	Category    *string  `json:"category"`
	Status      *string  `json:"status"`
	Latitude    *float64 `json:"latitude"`
	Longitude   *float64 `json:"longitude"`
}

type GetNearbyHelpRequestsRequest struct {
	Latitude     float64 `form:"latitude" binding:"required"`
	Longitude    float64 `form:"longitude" binding:"required"`
	RadiusMeters float64 `form:"radius_meters"`
}