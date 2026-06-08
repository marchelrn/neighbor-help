package utils

import (
	"fmt"
	"math"
	"strconv"
)

func SafeCompareString(a, b string) bool {
	if len(a) != len(b) {
		return false
	}
	lenA := len(a)
	var result byte = 0
	for i := range lenA {
		result |= a[i] ^ b[i]
	}

	return result == 0
}

func DecimalFormat(value float64) float64 {
	formatter := fmt.Sprintf("%.2f", value)
	result, _ := strconv.ParseFloat(formatter, 64)
	return result
}

func HaversineMeters(lat1, lon1, lat2, lon2 float64) float64 {
	const R = 6371000 // Radius of earth in meters
	phi1 := lat1 * math.Pi / 180
	phi2 := lat2 * math.Pi / 180
	deltaPhi := (lat2 - lat1) * math.Pi / 180
	deltaLambda := (lon2 - lon1) * math.Pi / 180

	a := math.Sin(deltaPhi/2)*math.Sin(deltaPhi/2) +
		math.Cos(phi1)*math.Cos(phi2)*
			math.Sin(deltaLambda/2)*math.Sin(deltaLambda/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))

	return R * c
}
