package dto

type RegisterRequest struct {
	Username       string  `json:"username"`
	Email          string  `json:"email"`
	Password       string  `json:"password"`
	FullName       string  `json:"full_name"`
	Address        string  `json:"address"`
	CoordinateLat  float64 `json:"CoordinateLat"`
	CoordinateLong float64 `json:"CoordinateLong"`
}

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginResponse struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
	Token   string `json:"token"`
}