package install

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestFormatURL(t *testing.T) {
	tests := []struct {
		template string
		params   map[string]string
		expected string
	}{
		{
			template: "https://kind.sigs.k8s.io/dl/$VERSION/kind-$OS-$ARCH",
			params: map[string]string{
				"OS":      "linux",
				"ARCH":    "amd64",
				"VERSION": "v0.11.1",
			},
			expected: "https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64",
		},
		{
			template: "https://example.com/download/${VERSION}/app-${OS}-${ARCH}.tar.gz",
			params: map[string]string{
				"OS":      "darwin",
				"ARCH":    "arm64",
				"VERSION": "1.2.3",
			},
			expected: "https://example.com/download/1.2.3/app-darwin-arm64.tar.gz",
		},
		{
			template: "https://example.com/$OS/$ARCH/$VERSION/app",
			params: map[string]string{
				"OS":      "windows",
				"ARCH":    "386",
				"VERSION": "2.0.0",
			},
			expected: "https://example.com/windows/386/2.0.0/app",
		},
		{
			template: "https://example.com/app-$VERSION",
			params: map[string]string{
				"VERSION": "latest",
			},
			expected: "https://example.com/app-latest",
		},
		{
			template: "https://example.com/app",
			params:   map[string]string{},
			expected: "https://example.com/app",
		},
	}

	for _, tt := range tests {
		url := formatURL(tt.template, tt.params)
		require.Equal(t, tt.expected, url)
	}
}
