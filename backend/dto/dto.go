package dto

// Users
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
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Users   []UsersData `json:"users"`
}

// Login
type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type LoginResponse struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
	Token   string `json:"token"`
}

// Nearby Users
type NearbyUserData struct {
	ID              uint    `json:"id"`
	Username        string  `json:"username"`
	FullName        string  `json:"full_name"`
	Address         string  `json:"address"`
	Coordinate_lat  float64 `json:"coordinate_lat"`
	Coordinate_long float64 `json:"coordinate_long"`
	Distance        float64 `json:"distance"`
}

type NearbyUsersResponse struct {
	Status  int              `json:"status"`
	Message string           `json:"message"`
	Users   []NearbyUserData `json:"users"`
}
