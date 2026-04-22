package utils

import "regexp"

func IsValidUsername(username string) bool {
	if len(username) < 3 || len(username) > 30 {
		return false
	}
	regex := `^[a-z0-9]+([._][a-z0-9]+)*$`
	re, err := regexp.Compile(regex)
	if err != nil {
		return false
	}
	return re.MatchString(username)
}

//func IsValidEmail(email string) bool {
//	regex := `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
//	re, err := regexp.Compile(regex)
//	if err != nil {
//		return false
//	}
//	return re.MatchString(email)
//}

func IsValidPassword(password string) bool {
	hasUpper := regexp.MustCompile(`[A-Z]`).MatchString(password)
	hasLower := regexp.MustCompile(`[a-z]`).MatchString(password)
	hasNumber := regexp.MustCompile(`[0-9]`).MatchString(password)
	hasSpecialChar := regexp.MustCompile(`[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:'"\\|,.<>\/?]`).MatchString(password)
	hasMinLen := len(password) >= 8

	return hasUpper && hasLower && hasNumber && hasSpecialChar && hasMinLen
}
