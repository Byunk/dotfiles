package install

import (
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"os"
	"path"
	"runtime"
	"strings"
)

type DownloadOptions struct {
	// Incomplete URL having placeholders
	URL string
	// Name of the file to download
	// If not set, the base name of the URL will be used
	Name    string
	Version string
	// TargetDir is the directory where the file will be downloaded
	// If not set, the file will be downloaded to a temporary directory
	TargetDir string
}

func (o *DownloadOptions) OS() []string {
	return []string{runtime.GOOS}
}

func (o *DownloadOptions) Arch() []string {
	goarch := runtime.GOARCH
	switch goarch {
	case "amd64":
		return []string{"amd64", "x86_64"}
	case "arm64":
		return []string{"arm64", "aarch64"}
	default:
		return []string{goarch}
	}
}

// FullPath returns the full path of the download file
func (o *DownloadOptions) FullPath() string {
	baseDir := ""
	if o.TargetDir != "" {
		baseDir = o.TargetDir
	} else {
		baseDir = tmpDir
	}

	return path.Join(baseDir, o.FileName())
}

func (o *DownloadOptions) BaseDir() string {
	if o.TargetDir != "" {
		return o.TargetDir
	}
	return tmpDir
}

// FileName returns the file name of the download
// If the Name field is set, it will return that
// Otherwise, it will return the base name of the URL
func (o *DownloadOptions) FileName() string {
	if o.Name != "" {
		return o.Name
	}
	return path.Base(o.URL)
}

type Downloader struct {
	*http.Client
}

func NewDownloader() *Downloader {
	return &Downloader{
		Client: http.DefaultClient,
	}
}

// TODO: show progress
func (d *Downloader) Download(o *DownloadOptions) (string, error) {
	// Ensure the target directory exists
	_ = os.MkdirAll(o.BaseDir(), 0755)

	for _, OS := range o.OS() {
		for _, arch := range o.Arch() {
			if fullpath, err := d.download(o, OS, arch); err == nil {
				return fullpath, nil
			}
		}
	}

	return "", fmt.Errorf("failed to download file")
}

func (d *Downloader) download(o *DownloadOptions, OS, arch string) (string, error) {
	url := formatURL(o.URL, map[string]string{"OS": OS, "Arch": arch, "Version": o.Version})

	var filename string
	if o.Name != "" {
		filename = o.Name
	} else {
		filename = path.Base(url)
	}

	slog.Info("Downloading file", "url", url)

	resp, err := d.Get(url)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("failed to download file: status code %d", resp.StatusCode)
	}

	out, err := os.Create(path.Join(o.BaseDir(), filename))
	if err != nil {
		slog.Error("Failed to create file", "error", err)
		return "", err
	}
	defer out.Close()

	_, err = io.Copy(out, resp.Body)
	if err != nil {
		slog.Error("Failed to copy file", "error", err)
		return "", err
	}

	return path.Join(o.BaseDir(), filename), nil
}

// formatURL replaces placeholders in the URL template with the given parameters.
func formatURL(template string, params map[string]string) string {
	for key, value := range params {
		for _, placeholder := range []string{
			fmt.Sprintf("$%s", strings.ToUpper(key)),
			fmt.Sprintf("${%s}", strings.ToUpper(key)),
		} {
			template = strings.ReplaceAll(template, placeholder, value)
		}
	}
	return template
}
