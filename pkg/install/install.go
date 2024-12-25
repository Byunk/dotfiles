package install

import (
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"path"

	"github.com/byunk/dotfiles/pkg/config"
	"github.com/byunk/dotfiles/pkg/util"
)

var (
	// TODO: dynamically generate tmpDir
	tmpDir = path.Join(os.TempDir(), "dotfiles")
)

type InstallOptions struct {
	*Downloader
	*config.InstallerConfig

	Upgrade bool
}

func New() *InstallOptions {
	return &InstallOptions{
		Downloader: NewDownloader(),
	}
}

func NewForConfig(c *config.InstallerConfig, downloader *Downloader) *InstallOptions {
	return &InstallOptions{
		Downloader:      downloader,
		InstallerConfig: c,
	}
}

func Install(o *InstallOptions) error {
	slog.Info("Installing package", "name", o.Name, "version", o.Version)

	switch o.Type {
	case "binary":
		return installBinary(o)
	case "source":
		return installSource(o)
	case "package":
		return installPackage(o)
	case "pip":
		return installPip(o)
	default:
		return fmt.Errorf("unsupported package type: %s", o.Type)
	}
}

func installBinary(o *InstallOptions) error {
	validate(o)

	do := &DownloadOptions{
		URL:       o.URL,
		Name:      o.Name,
		Version:   o.Version,
		TargetDir: o.TargetDir(),
	}
	slog.Info("Downloading binary", "name", o.Name, "url", do.URL, "target", do.TargetDir, "version", do.Version)

	fullpath, err := o.Download(do)
	if err != nil {
		return err
	}

	grantPermission(fullpath, 0755)
	return nil
}

func installSource(o *InstallOptions) error {
	validate(o)

	do := &DownloadOptions{
		URL:     o.URL,
		Version: o.Version,
	}
	slog.Info("Downloading source", "url", do.URL)
	fullpath, err := o.Download(do)
	if err != nil {
		return err
	}

	uz := util.NewUnZipper(o.Name, fullpath, tmpDir)
	binary, err := uz.Unzip()
	if err != nil {
		return err
	}

	if err := move(binary, path.Join(o.TargetDir(), o.Name)); err != nil {
		return err
	}

	return nil
}

func installPackage(o *InstallOptions) error {
	packageManagers := config.SupportedPackageManagers

	for _, manager := range packageManagers {
		if _, err := exec.LookPath(manager); err == nil {
			cmd := exec.Command(manager, "install", o.Name)
			cmd.Stdout = os.Stdout
			cmd.Stderr = os.Stderr
			return cmd.Run()
		}
	}

	return nil
}

func installPip(o *InstallOptions) error {
	if _, err := exec.LookPath("pip"); err != nil {
		return fmt.Errorf("pip is not installed")
	}

	cmd := exec.Command("pip3", "install", o.Name)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func validate(o *InstallOptions) error {
	currVersion, err := currentVersion(o.VersionCmd)
	if err == nil {
		if !o.Upgrade {
			slog.Info("Package is already installed", "name", o.Name, "version", currVersion)
			return nil
		} else if currVersion == o.Version {
			slog.Info("Package is already at the desired version", "name", o.Name, "version", currVersion)
			return nil
		}
	}

	return nil
}

// TODO: parse version from the output of the command
// currentVersion returns the current version of the package.
func currentVersion(cmd string) (string, error) {
	out, err := exec.Command(cmd).Output()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

func grantPermission(path string, perm os.FileMode) error {
	return os.Chmod(path, perm)
}

func move(src, dst string) error {
	return os.Rename(src, dst)
}
