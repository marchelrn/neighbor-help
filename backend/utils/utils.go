package utils

import (
	"fmt"
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
