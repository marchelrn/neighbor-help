package dto

type UsersRequest struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	Password        string  `json:"password"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	Coordinate_lat  float64 `json:"coordinate_lat"`
	Coordinate_long float64 `json:"coordinate_long"`
}

type UsersData struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	Password        string  `json:"password"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	Coordinate_lat  float64 `json:"coordinate_lat"`
	Coordinate_long float64 `json:"coordinate_long"`
}

type UsersResponse struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Data    []UsersData `json:"data"`
}

type AllUsersResponse struct {
	Response []UsersData `json:"data"`
}
