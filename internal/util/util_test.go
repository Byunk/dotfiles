package util

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFileNameWithoutExtension(t *testing.T) {
	tests := []struct {
		name     string
		fileName string
		expected string
	}{
		{
			name:     "single extension",
			fileName: "example.txt",
			expected: "example",
		},
		{
			name:     "multiple extensions",
			fileName: "archive.tar.gz",
			expected: "archive.tar",
		},
		{
			name:     "no extension",
			fileName: "README",
			expected: "README",
		},
		{
			name:     "empty file name",
			fileName: "",
			expected: "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := FileNameWithoutExtension(tt.fileName)
			require.Equal(t, tt.expected, result)
		})
	}
}
