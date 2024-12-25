package config

import "fmt"

// shouldNotEmpty checks if the given fields are not empty
func shouldNotEmpty(ss ...interface{}) error {
	for _, s := range ss {
		switch s := s.(type) {
		case string:
			if s == "" {
				return fmt.Errorf("should not be empty")
			}
		case []string:
			if len(s) == 0 {
				return fmt.Errorf("should not be empty")
			}
		case map[string]string:
			if len(s) == 0 {
				return fmt.Errorf("should not be empty")
			}
		default:
			return fmt.Errorf("unsupported type")
		}
	}

	return nil
}
