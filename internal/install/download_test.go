package install

import (
	"os"
	"path"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestDownload(t *testing.T) {
	tests := []*DownloadOptions{
		{
			URL: "https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64",
		},
		{
			URL: "https://kind.sigs.k8s.io/dl/v0.11.1/kind-darwin-amd64",
		},
		{
			URL:  "https://kind.sigs.k8s.io/dl/v0.11.1/kind-windows-amd64",
			Name: "kind.exe",
		},
		{
			URL:       "https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64",
			TargetDir: "/tmp/testdir1",
		},
		{
			URL:       "https://kind.sigs.k8s.io/dl/v0.11.1/kind-darwin-amd64",
			TargetDir: "/tmp/testdir2",
		},
		{
			URL:       "https://kind.sigs.k8s.io/dl/v0.11.1/kind-windows-amd64",
			Name:      "kind.exe",
			TargetDir: "/tmp/testdir3",
		},
	}

	d := NewDownloader()
	for _, tt := range tests {
		_, err := d.Download(tt)
		require.NoError(t, err)

		// Check if the file exists
		if tt.TargetDir != "" {
			_, err = os.Stat(tt.FullPath())
			require.NoError(t, err)
			_ = os.RemoveAll(tt.TargetDir)
		} else {
			_, err = os.Stat(path.Join(tmpDir, tt.FileName()))
			require.NoError(t, err)
		}
	}

	// Clean up
	_ = os.RemoveAll(tmpDir)
}
